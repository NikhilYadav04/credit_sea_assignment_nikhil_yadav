const express = require('express');
const Joi = require('joi');

const validate = require('../middleware/validate');
const { requireAuth, requireAdmin } = require('../middleware/auth');
const auth = require('../controllers/authController');
const user = require('../controllers/userController');
const loan = require('../controllers/loanController');
const payment = require('../controllers/paymentController');
const device = require('../controllers/deviceController');
const { GENDERS, MARITAL_STATUSES } = require('../models/User');
const { STATUSES, APPROVAL_STEPS } = require('../models/LoanApplication');

const mobile = Joi.string().pattern(/^[6-9]\d{9}$/).required().messages({
  'string.pattern.base': 'Enter a valid 10 digit mobile number',
});
const email = Joi.string().email().lowercase().required();
const password = Joi.string()
  .min(8)
  .pattern(/[^A-Za-z0-9]/)
  .required()
  .messages({
    'string.min': 'Password must have at least 8 characters',
    'string.pattern.base': 'Password needs at least 1 special character',
  });

const router = express.Router();

router.get('/health', (req, res) => res.json({ success: true, message: 'ok' }));

router.post('/auth/send-otp', validate(Joi.object({ mobile })), auth.sendOtp);
router.post(
  '/auth/verify-otp',
  validate(Joi.object({ mobile, otp: Joi.string().length(4).required() })),
  auth.verifyOtp,
);
router.post(
  '/auth/set-password',
  validate(Joi.object({ verificationToken: Joi.string().required(), password })),
  auth.setPassword,
);
router.post(
  '/auth/login',
  validate(Joi.object({ mobile, password: Joi.string().required() })),
  auth.login,
);
router.get('/auth/me', requireAuth, auth.me);

router.put(
  '/user/profile',
  requireAuth,
  validate(
    Joi.object({
      firstName: Joi.string().trim().min(1).max(40).required(),
      lastName: Joi.string().trim().min(1).max(40).required(),
      gender: Joi.string().valid(...GENDERS).required(),
      dob: Joi.date().max('now').required(),
      maritalStatus: Joi.string().valid(...MARITAL_STATUSES).required(),
    }),
  ),
  user.updateProfile,
);
router.post('/user/email/send-otp', requireAuth, validate(Joi.object({ email })), user.sendEmailOtp);
router.post(
  '/user/email/verify',
  requireAuth,
  validate(Joi.object({ email, otp: Joi.string().length(6).required() })),
  user.verifyEmail,
);
router.post(
  '/user/pan',
  requireAuth,
  validate(
    Joi.object({
      pan: Joi.string()
        .uppercase()
        .pattern(/^[A-Z]{5}[0-9]{4}[A-Z]$/)
        .required()
        .messages({ 'string.pattern.base': 'Enter a valid PAN, e.g. ABCDE1234F' }),
    }),
  ),
  user.verifyPan,
);

router.get('/loan/offer', requireAuth, loan.offer);
router.post(
  '/loan/apply',
  requireAuth,
  validate(
    Joi.object({
      amount: Joi.number().integer().required(),
      tenureDays: Joi.number().integer().required(),
      purpose: Joi.string().trim().max(60).required(),
    }),
  ),
  loan.apply,
);
router.get('/loan/applications', requireAuth, loan.list);
router.get('/loan/applications/:id', requireAuth, loan.detail);
router.patch(
  '/loan/applications/:id/status',
  requireAdmin,
  validate(
    Joi.object({
      status: Joi.string().valid(...STATUSES).required(),
      approvalStep: Joi.string().valid(...APPROVAL_STEPS),
      rejectionReason: Joi.string().max(200),
    }),
  ),
  loan.adminSetStatus,
);

router.post(
  '/payments/order',
  requireAuth,
  validate(Joi.object({ applicationId: Joi.string().required() })),
  payment.createOrder,
);
router.post(
  '/payments/verify',
  requireAuth,
  validate(
    Joi.object({
      razorpay_order_id: Joi.string().required(),
      razorpay_payment_id: Joi.string().required(),
      razorpay_signature: Joi.string().required(),
    }),
  ),
  payment.verify,
);

const deviceBody = Joi.object({
  token: Joi.string().required(),
  platform: Joi.string().valid('android', 'ios').default('android'),
});
router.post('/devices', requireAuth, validate(deviceBody), device.register);
router.delete('/devices', requireAuth, validate(deviceBody), device.unregister);

module.exports = router;
