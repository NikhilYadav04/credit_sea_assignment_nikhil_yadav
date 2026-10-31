require('dotenv').config();

const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT) || 4000,
  mongoUri: process.env.MONGODB_URI || '',
  jwtSecret: process.env.JWT_SECRET || '',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '30d',
  adminKey: process.env.ADMIN_KEY || '',
  otpMode: process.env.OTP_MODE || 'mock',
  stageSeconds: Number(process.env.STAGE_SECONDS) || 8,
  razorpay: {
    keyId: process.env.RAZORPAY_KEY_ID || '',
    keySecret: process.env.RAZORPAY_KEY_SECRET || '',
  },
  firebase: {
    projectId: process.env.FIREBASE_PROJECT_ID || '',
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL || '',
    privateKey: process.env.FIREBASE_PRIVATE_KEY || '',
  },
  smtp: {
    host: process.env.SMTP_HOST || '',
    port: Number(process.env.SMTP_PORT) || 587,
    user: process.env.SMTP_USER || '',
    pass: process.env.SMTP_PASS || '',
    from: process.env.SMTP_FROM || 'CreditSea <no-reply@creditsea.app>',
  },
};

env.isProduction = env.nodeEnv === 'production';
env.paymentMode =
  process.env.PAYMENT_MODE || (env.razorpay.keyId && env.razorpay.keySecret ? 'razorpay' : 'mock');

function assertConfigured() {
  const missing = [];
  if (!env.mongoUri) missing.push('MONGODB_URI');
  if (!env.jwtSecret) missing.push('JWT_SECRET');
  if (missing.length) {
    throw new Error(`Missing environment variables: ${missing.join(', ')}`);
  }
}

module.exports = { env, assertConfigured };
