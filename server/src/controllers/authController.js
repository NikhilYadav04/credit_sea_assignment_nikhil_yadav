const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const ApiError = require('../utils/apiError');
const { ok } = require('../utils/respond');
const { env } = require('../config/env');
const otpService = require('../services/otpService');

function signSession(user) {
  return jwt.sign({ sub: user._id.toString() }, env.jwtSecret, { expiresIn: env.jwtExpiresIn });
}

function signVerification(mobile) {
  return jwt.sign({ mobile, purpose: 'signup' }, env.jwtSecret, { expiresIn: '15m' });
}

async function sendOtp(req, res) {
  const { mobile } = req.body;
  if (await User.exists({ mobile })) {
    throw ApiError.conflict('This number is already registered, please sign in');
  }
  const result = await otpService.sendOtp(mobile, 'signup');
  ok(res, result, 'OTP sent');
}

async function verifyOtp(req, res) {
  const { mobile, otp } = req.body;
  await otpService.verifyOtp(mobile, 'signup', otp);
  ok(res, { verificationToken: signVerification(mobile) }, 'Mobile number verified');
}

async function setPassword(req, res) {
  const { verificationToken, password } = req.body;

  let payload;
  try {
    payload = jwt.verify(verificationToken, env.jwtSecret);
  } catch {
    throw ApiError.badRequest('Verification expired, please start again');
  }
  if (payload.purpose !== 'signup') throw ApiError.badRequest('Invalid verification token');

  const user = await User.create({
    mobile: payload.mobile,
    passwordHash: await bcrypt.hash(password, 10),
  });
  ok(res, { token: signSession(user), user: user.toPublic() }, 'Account created', 201);
}

async function login(req, res) {
  const { mobile, password } = req.body;
  const user = await User.findOne({ mobile });
  const valid = user && (await bcrypt.compare(password, user.passwordHash));
  if (!valid) throw ApiError.unauthorized('Incorrect mobile number or password');

  ok(res, { token: signSession(user), user: user.toPublic() }, 'Signed in');
}

async function me(req, res) {
  ok(res, { user: req.user.toPublic() });
}

module.exports = { sendOtp, verifyOtp, setPassword, login, me };
