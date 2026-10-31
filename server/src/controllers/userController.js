const User = require('../models/User');
const ApiError = require('../utils/apiError');
const { ok } = require('../utils/respond');
const otpService = require('../services/otpService');
const { ageOf } = require('../services/eligibilityService');

const MIN_REGISTRATION_AGE = 18;

async function updateProfile(req, res) {
  const { firstName, lastName, gender, dob, maritalStatus } = req.body;
  if (ageOf(dob, new Date()) < MIN_REGISTRATION_AGE) {
    throw ApiError.badRequest(`You must be at least ${MIN_REGISTRATION_AGE} years old`);
  }

  Object.assign(req.user, { firstName, lastName, gender, dob, maritalStatus });
  await req.user.save();
  ok(res, { user: req.user.toPublic() }, 'Profile saved');
}

async function sendEmailOtp(req, res) {
  const { email } = req.body;
  const taken = await User.exists({ email, emailVerified: true, _id: { $ne: req.user._id } });
  if (taken) throw ApiError.conflict('This email is linked to another account');

  const result = await otpService.sendOtp(email, 'email');
  ok(res, result, 'OTP sent to your email');
}

async function verifyEmail(req, res) {
  const { email, otp } = req.body;
  await otpService.verifyOtp(email, 'email', otp);

  req.user.email = email;
  req.user.emailVerified = true;
  await req.user.save();
  ok(res, { user: req.user.toPublic() }, 'Email verified');
}

async function verifyPan(req, res) {
  const { pan } = req.body;
  const lastName = (req.user.lastName || '').trim().toUpperCase();
  if (pan[3] === 'P' && lastName && pan[4] !== lastName[0]) {
    throw ApiError.badRequest('This PAN does not match the last name you entered');
  }

  const taken = await User.exists({ pan, panVerified: true, _id: { $ne: req.user._id } });
  if (taken) throw ApiError.conflict('This PAN is linked to another account');

  req.user.pan = pan;
  req.user.panVerified = true;
  await req.user.save();
  ok(res, { user: req.user.toPublic() }, 'PAN verified');
}

module.exports = { updateProfile, sendEmailOtp, verifyEmail, verifyPan };
