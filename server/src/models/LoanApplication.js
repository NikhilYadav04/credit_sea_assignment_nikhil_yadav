const mongoose = require('mongoose');

const STATUSES = ['SUBMITTED', 'UNDER_REVIEW', 'APPROVED', 'REJECTED', 'DISBURSED'];
const APPROVAL_STEPS = ['E_KYC', 'E_NACH', 'E_SIGN'];

const loanApplicationSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    applicationNo: { type: String, required: true, unique: true },

    purpose: { type: String, required: true },
    amount: { type: Number, required: true },
    tenureDays: { type: Number, required: true },
    interest: { type: Number, required: true },
    processingFee: { type: Number, required: true },
    totalPayable: { type: Number, required: true },

    status: { type: String, enum: STATUSES, default: 'SUBMITTED' },
    approvalStep: { type: String, enum: [...APPROVAL_STEPS, null], default: null },
    rejectionReason: String,
    disbursedAt: Date,
    repaidAt: Date,
    history: [
      {
        status: String,
        approvalStep: String,
        at: { type: Date, default: Date.now },
      },
    ],
  },
  { timestamps: true },
);

module.exports = mongoose.model('LoanApplication', loanApplicationSchema);
module.exports.STATUSES = STATUSES;
module.exports.APPROVAL_STEPS = APPROVAL_STEPS;
