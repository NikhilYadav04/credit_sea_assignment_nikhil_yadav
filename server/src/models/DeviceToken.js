const mongoose = require('mongoose');

const deviceTokenSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    token: { type: String, required: true, unique: true },
    platform: { type: String, enum: ['android', 'ios'], default: 'android' },
    active: { type: Boolean, default: true },
  },
  { timestamps: true },
);

module.exports = mongoose.model('DeviceToken', deviceTokenSchema);
