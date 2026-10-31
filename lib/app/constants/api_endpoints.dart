class ApiEndpoints {
  ApiEndpoints._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://credit-sea-assignment-nikhil-yadav.onrender.com/api',
  );

  static const sendOtp = '/auth/send-otp';
  static const verifyOtp = '/auth/verify-otp';
  static const setPassword = '/auth/set-password';
  static const login = '/auth/login';
  static const me = '/auth/me';

  static const profile = '/user/profile';
  static const emailSendOtp = '/user/email/send-otp';
  static const emailVerify = '/user/email/verify';
  static const pan = '/user/pan';

  static const loanOffer = '/loan/offer';
  static const loanApply = '/loan/apply';
  static const loanApplications = '/loan/applications';

  static const paymentOrder = '/payments/order';
  static const paymentVerify = '/payments/verify';
  static const devices = '/devices';
}
