const crypto = require('node:crypto');
const Razorpay = require('razorpay');

const LoanApplication = require('../models/LoanApplication');
const Payment = require('../models/Payment');
const ApiError = require('../utils/apiError');
const { env } = require('../config/env');
const creditScoreService = require('./creditScoreService');
const notificationService = require('./notificationService');

const DAY_MS = 24 * 60 * 60 * 1000;
const MOCK_PREFIX = 'mock_';

let client;

function getClient() {
  if (!env.razorpay.keyId || !env.razorpay.keySecret) {
    throw new ApiError(503, 'Payments are not configured on the server');
  }
  if (!client) {
    client = new Razorpay({ key_id: env.razorpay.keyId, key_secret: env.razorpay.keySecret });
  }
  return client;
}

function dueDateOf(application) {
  return new Date(application.disbursedAt.getTime() + application.tenureDays * DAY_MS);
}

async function createRepaymentOrder(user, applicationId) {
  const application = await LoanApplication.findOne({ _id: applicationId, user: user._id });
  if (!application) throw ApiError.notFound('Application not found');
  if (application.status !== 'DISBURSED') {
    throw ApiError.badRequest('Only a disbursed loan can be repaid');
  }
  if (application.repaidAt) throw ApiError.conflict('This loan is already repaid');

  const mock = env.paymentMode === 'mock';
  const order = mock
    ? { id: `${MOCK_PREFIX}${crypto.randomUUID()}`, amount: application.totalPayable * 100, currency: 'INR' }
    : await getClient().orders.create({
        amount: application.totalPayable * 100,
        currency: 'INR',
        receipt: application.applicationNo,
        notes: { applicationId: application.id },
      });

  await Payment.create({
    user: user._id,
    application: application._id,
    amount: application.totalPayable,
    razorpayOrderId: order.id,
  });

  return {
    mock,
    keyId: mock ? '' : env.razorpay.keyId,
    orderId: order.id,
    amount: order.amount,
    currency: order.currency,
    applicationNo: application.applicationNo,
  };
}

function signatureMatches(orderId, paymentId, signature) {
  const expected = crypto
    .createHmac('sha256', env.razorpay.keySecret)
    .update(`${orderId}|${paymentId}`)
    .digest('hex');

  const a = Buffer.from(expected);
  const b = Buffer.from(String(signature));
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

async function confirmPayment(user, { orderId, paymentId, signature }) {
  const mockPayment = env.paymentMode === 'mock' && orderId.startsWith(MOCK_PREFIX);
  if (!mockPayment && !signatureMatches(orderId, paymentId, signature)) {
    throw ApiError.badRequest('Payment verification failed');
  }

  const payment = await Payment.findOne({ razorpayOrderId: orderId, user: user._id });
  if (!payment) throw ApiError.notFound('Payment not found');
  if (payment.status === 'PAID') return { alreadyPaid: true, creditScore: user.creditScore };

  const application = await LoanApplication.findById(payment.application);
  const onTime = Date.now() <= dueDateOf(application).getTime();

  payment.status = 'PAID';
  payment.razorpayPaymentId = paymentId;
  payment.paidAt = new Date();
  await payment.save();

  application.repaidAt = payment.paidAt;
  await application.save();

  const creditScore = await creditScoreService.recordRepayment(user._id, { onTime });
  notificationService.sendToUser(user._id, {
    title: 'Repayment received',
    body: `Thank you! Your loan #${application.applicationNo} is fully repaid.`,
    data: { type: 'repayment', applicationId: application.id },
  });

  return { alreadyPaid: false, creditScore };
}

module.exports = { createRepaymentOrder, confirmPayment, signatureMatches, dueDateOf };
