const mongoose = require('mongoose');

const paymentSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    application: { type: mongoose.Schema.Types.ObjectId, ref: 'LoanApplication', required: true },
    amount: { type: Number, required: true },
    razorpayOrderId: { type: String, required: true, unique: true },
    razorpayPaymentId: String,
    status: { type: String, enum: ['CREATED', 'PAID'], default: 'CREATED' },
    paidAt: Date,
  },
  { timestamps: true },
);

module.exports = mongoose.model('Payment', paymentSchema);
