import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/session/session_controller.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../core/utils/resend_countdown.dart';
import '../../../core/widgets/app_snack.dart';
import '../../../data/models/otp_result.dart';
import '../../../data/repositories/user_repository.dart';

class EmailVerifyController extends BaseController {
  EmailVerifyController(this._users, this._session);

  final UserRepository _users;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final countdown = ResendCountdown();
  final code = ''.obs;
  final otpSent = false.obs;
  final otpField = TextEditingController();
  int otpLength = 6;

  @override
  void onInit() {
    super.onInit();
    ever(code, (_) {
      if (otpSent.value && code.value.length == otpLength && !isLoading.value) verify();
    });
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;

    await guard(() async {
      final OtpResult result = await _users.sendEmailOtp(email.text.trim());
      otpLength = result.length;
      otpSent.value = true;
      countdown.start(result.resendAfterSeconds);
      if (result.devOtp != null) AppSnack.info('Demo OTP: ${result.devOtp}');
    });
  }

  Future<void> verify() async {
    if (!otpSent.value) {
      AppSnack.error('Tap "Send OTP" to get a code on your email first');
      return;
    }
    if (code.value.length != otpLength) {
      AppSnack.error('Enter the $otpLength digit code');
      return;
    }

    final verified = await guard(() async {
      final user = await _users.verifyEmail(email.text.trim(), code.value);
      _session.updateUser(user);
      Get.toNamed(Routes.verifyPan);
    });
    if (!verified) otpField.clear();
  }

  @override
  void onClose() {
    otpField.dispose();
    email.dispose();
    countdown.dispose();
    super.onClose();
  }
}
