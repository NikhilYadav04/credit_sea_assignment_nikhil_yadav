const mongoose = require('mongoose');

const otpSchema = new mongoose.Schema({
  target: { type: String, required: true },
  purpose: { type: String, enum: ['signup', 'email'], required: true },
  codeHash: { type: String, required: true },
  attempts: { type: Number, default: 0 },
  sentAt: { type: Date, default: Date.now },
  expiresAt: { type: Date, required: true },
});

otpSchema.index({ target: 1, purpose: 1 }, { unique: true });
otpSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

module.exports = mongoose.model('Otp', otpSchema);
