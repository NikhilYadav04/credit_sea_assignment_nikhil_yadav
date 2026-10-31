const mongoose = require('mongoose');

const GENDERS = ['Male', 'Female', 'Other'];
const MARITAL_STATUSES = ['Single', 'Married', 'Divorced', 'Widowed'];

const userSchema = new mongoose.Schema(
  {
    mobile: { type: String, required: true, unique: true, index: true },
    passwordHash: { type: String, required: true },

    firstName: String,
    lastName: String,
    gender: { type: String, enum: GENDERS },
    dob: Date,
    maritalStatus: { type: String, enum: MARITAL_STATUSES },

    email: { type: String, lowercase: true, trim: true },
    emailVerified: { type: Boolean, default: false },

    pan: String,
    panVerified: { type: Boolean, default: false },

    creditScore: { type: Number, default: 650 },
  },
  { timestamps: true },
);

userSchema.virtual('onboardingStep').get(function onboardingStep() {
  if (!this.firstName) return 'personal';
  if (!this.emailVerified) return 'email';
  if (!this.panVerified) return 'pan';
  return 'complete';
});

userSchema.methods.toPublic = function toPublic() {
  return {
    id: this._id.toString(),
    mobile: this.mobile,
    firstName: this.firstName ?? null,
    lastName: this.lastName ?? null,
    gender: this.gender ?? null,
    dob: this.dob ?? null,
    maritalStatus: this.maritalStatus ?? null,
    email: this.email ?? null,
    emailVerified: this.emailVerified,
    pan: this.pan ?? null,
    panVerified: this.panVerified,
    creditScore: this.creditScore,
    onboardingStep: this.onboardingStep,
  };
};

module.exports = mongoose.model('User', userSchema);
module.exports.GENDERS = GENDERS;
module.exports.MARITAL_STATUSES = MARITAL_STATUSES;
