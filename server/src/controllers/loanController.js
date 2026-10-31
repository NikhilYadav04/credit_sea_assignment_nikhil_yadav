const LoanApplication = require('../models/LoanApplication');
const User = require('../models/User');
const ApiError = require('../utils/apiError');
const { ok } = require('../utils/respond');
const loanService = require('../services/loanService');

async function findOwned(req) {
  const application = await LoanApplication.findOne({ _id: req.params.id, user: req.user._id });
  if (!application) throw ApiError.notFound('Application not found');
  return application;
}

async function offer(req, res) {
  ok(res, loanService.getOffer(req.user));
}

async function apply(req, res) {
  const application = await loanService.createApplication(req.user, req.body);
  ok(res, { application: loanService.describe(application) }, 'Application submitted', 201);
}

async function list(req, res) {
  const applications = await LoanApplication.find({ user: req.user._id }).sort({ createdAt: -1 });
  for (const application of applications) {
    await loanService.advanceApplication(application, req.user);
  }
  ok(res, { applications: applications.map(loanService.describe) });
}

async function detail(req, res) {
  const application = await findOwned(req);
  await loanService.advanceApplication(application, req.user);
  ok(res, { application: loanService.describe(application) });
}

async function adminSetStatus(req, res) {
  const application = await LoanApplication.findById(req.params.id);
  if (!application) throw ApiError.notFound('Application not found');

  const { status, approvalStep, rejectionReason } = req.body;
  application.status = status;
  application.approvalStep = status === 'APPROVED' ? approvalStep || 'E_KYC' : null;
  if (status === 'REJECTED') application.rejectionReason = rejectionReason || 'Rejected by reviewer';
  if (status === 'DISBURSED' && !application.disbursedAt) application.disbursedAt = new Date();
  application.history.push({ status, approvalStep: application.approvalStep });
  await application.save();
  loanService.notifyStatusChange(application);

  const owner = await User.findById(application.user);
  ok(res, { application: loanService.describe(application), owner: owner?.mobile });
}

module.exports = { offer, apply, list, detail, adminSetStatus };
