const crypto = require('node:crypto');
const Otp = require('../models/Otp');
const ApiError = require('../utils/apiError');
const { env } = require('../config/env');
const { sendMail } = require('./emailService');

const RESEND_COOLDOWN_SECONDS = 30;
const EXPIRY_MINUTES = 5;
const MAX_ATTEMPTS = 5;
const CODE_LENGTH = { signup: 4, email: 6 };

function hash(target, code) {
  return crypto.createHash('sha256').update(`${target}:${code}`).digest('hex');
}

function generateCode(length) {
  return crypto.randomInt(0, 10 ** length).toString().padStart(length, '0');
}

async function deliver(purpose, target, code) {
  if (purpose === 'email') {
    await sendMail({
      to: target,
      subject: 'Your CreditSea verification code',
      text: `Your CreditSea verification code is ${code}. It is valid for ${EXPIRY_MINUTES} minutes.`,
    });
    return;
  }
  console.log(`[sms:mock] ${target} -> ${code}`);
}

async function sendOtp(target, purpose) {
  const existing = await Otp.findOne({ target, purpose });
  if (existing) {
    const waited = (Date.now() - existing.sentAt.getTime()) / 1000;
    if (waited < RESEND_COOLDOWN_SECONDS) {
      const left = Math.ceil(RESEND_COOLDOWN_SECONDS - waited);
      throw ApiError.tooMany(`Please wait ${left}s before requesting another OTP`);
    }
  }

  const code = generateCode(CODE_LENGTH[purpose]);
  await Otp.findOneAndUpdate(
    { target, purpose },
    {
      codeHash: hash(target, code),
      attempts: 0,
      sentAt: new Date(),
      expiresAt: new Date(Date.now() + EXPIRY_MINUTES * 60 * 1000),
    },
    { upsert: true },
  );
  await deliver(purpose, target, code);

  return {
    length: CODE_LENGTH[purpose],
    resendAfterSeconds: RESEND_COOLDOWN_SECONDS,
    ...(env.otpMode === 'mock' ? { devOtp: code } : {}),
  };
}

async function verifyOtp(target, purpose, code) {
  const record = await Otp.findOne({ target, purpose });
  if (!record || record.expiresAt < new Date()) {
    throw ApiError.badRequest('OTP expired, please request a new one');
  }
  if (record.attempts >= MAX_ATTEMPTS) {
    throw ApiError.tooMany('Too many wrong attempts, please request a new OTP');
  }
  if (record.codeHash !== hash(target, code)) {
    record.attempts += 1;
    await record.save();
    throw ApiError.badRequest('Incorrect OTP');
  }
  await record.deleteOne();
}

module.exports = { sendOtp, verifyOtp, CODE_LENGTH };
