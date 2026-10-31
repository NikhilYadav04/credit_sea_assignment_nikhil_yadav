import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../core/utils/resend_countdown.dart';
import '../../../core/widgets/app_snack.dart';
import '../../../data/models/otp_result.dart';
import '../../../data/repositories/auth_repository.dart';

class OtpArgs {
  const OtpArgs({required this.mobile, required this.initial});

  final String mobile;
  final OtpResult initial;
}

class OtpController extends BaseController {
  OtpController(this._auth);

  final AuthRepository _auth;
  final countdown = ResendCountdown();
  final code = ''.obs;
  final otpField = TextEditingController();

  late final OtpArgs args = Get.arguments as OtpArgs;
  late int otpLength = args.initial.length;

  bool get complete => code.value.length == otpLength;

  @override
  void onInit() {
    super.onInit();
    ever(code, (_) {
      if (complete && !isLoading.value) verify();
    });
  }

  @override
  void onReady() {
    super.onReady();
    _onSent(args.initial);
  }

  void _onSent(OtpResult result) {
    otpLength = result.length;
    countdown.start(result.resendAfterSeconds);
    if (result.devOtp != null) AppSnack.info('Demo OTP: ${result.devOtp}');
  }

  Future<void> verify() async {
    if (!complete) return;
    await guard(() async {
      final token = await _auth.verifyOtp(args.mobile, code.value);
      Get.toNamed(Routes.createPassword, arguments: token);
    });
    otpField.clear();
  }

  Future<void> resend() async {
    if (!countdown.finished) return;
    otpField.clear();
    await guard(() async => _onSent(await _auth.sendOtp(args.mobile)));
  }

  @override
  void onClose() {
    otpField.dispose();
    countdown.dispose();
    super.onClose();
  }
}
