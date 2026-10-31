const { ok } = require('../utils/respond');
const paymentService = require('../services/paymentService');

async function createOrder(req, res) {
  const order = await paymentService.createRepaymentOrder(req.user, req.body.applicationId);
  ok(res, order, 'Order created', 201);
}

async function verify(req, res) {
  const { razorpay_order_id: orderId, razorpay_payment_id: paymentId, razorpay_signature: signature } =
    req.body;
  const result = await paymentService.confirmPayment(req.user, { orderId, paymentId, signature });
  ok(res, result, 'Payment successful');
}

module.exports = { createOrder, verify };
