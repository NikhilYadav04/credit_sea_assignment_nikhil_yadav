const crypto = require('node:crypto');
const LoanApplication = require('../models/LoanApplication');
const ApiError = require('../utils/apiError');
const { env } = require('../config/env');
const { LOAN_RULES, calculateLoan } = require('../utils/loanMath');
const { checkEligibility } = require('./eligibilityService');
const notificationService = require('./notificationService');

const FLOW = [
  { status: 'SUBMITTED', approvalStep: null },
  { status: 'UNDER_REVIEW', approvalStep: null },
  { status: 'APPROVED', approvalStep: 'E_KYC' },
  { status: 'APPROVED', approvalStep: 'E_NACH' },
  { status: 'APPROVED', approvalStep: 'E_SIGN' },
  { status: 'DISBURSED', approvalStep: null },
];
const APPROVAL_INDEX = 2;

const TIMELINE_LABELS = [
  'Application Submitted',
  'Application Under Review',
  'E-KYC',
  'E-Nach',
  'E-Sign',
  'Disbursement',
];

const BANNERS = {
  SUBMITTED: [
    'Application Under Review',
    "We're carefully reviewing your application to ensure everything is in order. Thank you for your patience.",
  ],
  UNDER_REVIEW: [
    'Application Under Review',
    "We're carefully reviewing your application to ensure everything is in order. Thank you for your patience.",
  ],
  E_KYC: ['E-KYC In Progress', 'Your application is approved. We are verifying your identity details.'],
  E_NACH: ['E-Nach In Progress', 'Setting up your repayment mandate.'],
  E_SIGN: ['E-Sign In Progress', 'Your loan agreement is being signed digitally.'],
  DISBURSED: ['Loan Disbursed', 'The amount has been sent to your bank account.'],
  REJECTED: ['Application Rejected', 'Sorry, we could not approve your application this time.'],
};

function isFinished(application) {
  return application.status === 'REJECTED' || application.status === 'DISBURSED';
}

function flowIndexOf(application) {
  return FLOW.findIndex(
    (step) => step.status === application.status && step.approvalStep === application.approvalStep,
  );
}

function moveTo(application, step) {
  application.status = step.status;
  application.approvalStep = step.approvalStep;
  if (step.status === 'DISBURSED') application.disbursedAt = new Date();
  application.history.push({ status: step.status, approvalStep: step.approvalStep });
}

function reject(application, reason) {
  application.status = 'REJECTED';
  application.approvalStep = null;
  application.rejectionReason = reason;
  application.history.push({ status: 'REJECTED' });
}

function getOffer(user) {
  const eligibility = checkEligibility(user);
  const rules = { ...LOAN_RULES };
  if (!eligibility.eligible) {
    return { eligible: false, reason: eligibility.reason, rules, maxAmount: 0, offer: null };
  }
  return {
    eligible: true,
    reason: null,
    rules,
    maxAmount: eligibility.maxAmount,
    offer: calculateLoan(eligibility.maxAmount, LOAN_RULES.defaultTenureDays),
  };
}

function validateRequest(user, { amount, tenureDays }) {
  const eligibility = checkEligibility(user);
  if (!eligibility.eligible) throw ApiError.forbidden(eligibility.reason);

  if (amount < LOAN_RULES.minAmount || amount > eligibility.maxAmount) {
    throw ApiError.badRequest(
      `Amount must be between ${LOAN_RULES.minAmount} and ${eligibility.maxAmount}`,
    );
  }
  if (amount % LOAN_RULES.amountStep !== 0) {
    throw ApiError.badRequest(`Amount must be a multiple of ${LOAN_RULES.amountStep}`);
  }
  if (tenureDays < LOAN_RULES.minTenureDays || tenureDays > LOAN_RULES.maxTenureDays) {
    throw ApiError.badRequest(
      `Tenure must be between ${LOAN_RULES.minTenureDays} and ${LOAN_RULES.maxTenureDays} days`,
    );
  }
}

async function nextApplicationNo() {
  for (let attempt = 0; attempt < 5; attempt++) {
    const applicationNo = `CS${crypto.randomInt(10000, 100000)}`;
    if (!(await LoanApplication.exists({ applicationNo }))) return applicationNo;
  }
  throw new Error('Could not generate an application number');
}

async function createApplication(user, { amount, tenureDays, purpose }) {
  validateRequest(user, { amount, tenureDays });

  const open = await LoanApplication.exists({
    user: user._id,
    status: { $nin: ['REJECTED', 'DISBURSED'] },
  });
  if (open) throw ApiError.conflict('You already have a loan application in progress');

  return LoanApplication.create({
    user: user._id,
    applicationNo: await nextApplicationNo(),
    purpose,
    ...calculateLoan(amount, tenureDays),
    history: [{ status: 'SUBMITTED' }],
  });
}

async function advanceApplication(application, user) {
  if (isFinished(application)) return false;

  const elapsed = (Date.now() - application.createdAt.getTime()) / 1000;
  const target = Math.min(Math.floor(elapsed / env.stageSeconds), FLOW.length - 1);

  let index = flowIndexOf(application);
  const startedAt = index;
  while (index < target) {
    index += 1;
    if (index === APPROVAL_INDEX) {
      const eligibility = checkEligibility(user);
      if (!eligibility.eligible || application.amount > eligibility.maxAmount) {
        reject(application, eligibility.reason || 'Requested amount is above your limit');
        break;
      }
    }
    moveTo(application, FLOW[index]);
  }

  const changed = index !== startedAt || application.status === 'REJECTED';
  if (changed) {
    await application.save();
    notifyStatusChange(application);
  }
  return changed;
}

function notifyStatusChange(application) {
  const { banner } = describe(application);
  notificationService.sendToUser(application.user, {
    title: banner.title,
    body: banner.message,
    data: {
      type: 'loan_status',
      applicationId: application.id,
      status: application.status,
    },
  });
}

function buildTimeline(application) {
  if (application.status === 'DISBURSED') {
    return TIMELINE_LABELS.map((label) => ({ label, state: 'done' }));
  }

  const active = Math.max(flowIndexOf(application), 1);
  const rejected = application.status === 'REJECTED';

  return TIMELINE_LABELS.map((label, i) => {
    if (i === 0) return { label, state: 'done' };
    if (rejected) return { label, state: i === 1 ? 'rejected' : 'pending' };
    if (i < active) return { label, state: 'done' };
    return { label, state: i === active ? 'active' : 'pending' };
  });
}

function describe(application) {
  const bannerKey =
    application.status === 'APPROVED' ? application.approvalStep : application.status;
  const [bannerTitle, bannerMessage] = BANNERS[bannerKey];

  return {
    id: application._id.toString(),
    applicationNo: application.applicationNo,
    purpose: application.purpose,
    amount: application.amount,
    tenureDays: application.tenureDays,
    interest: application.interest,
    processingFee: application.processingFee,
    totalPayable: application.totalPayable,
    status: application.status,
    approvalStep: application.approvalStep,
    rejectionReason: application.rejectionReason ?? null,
    disbursedAt: application.disbursedAt ?? null,
    dueAt: application.disbursedAt
      ? new Date(application.disbursedAt.getTime() + application.tenureDays * 86400000)
      : null,
    repaid: Boolean(application.repaidAt),
    banner: { title: bannerTitle, message: bannerMessage },
    timeline: buildTimeline(application),
    createdAt: application.createdAt,
  };
}

module.exports = {
  FLOW,
  getOffer,
  createApplication,
  advanceApplication,
  notifyStatusChange,
  describe,
  isFinished,
};
