import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../core/widgets/app_snack.dart';
import '../../../data/models/otp_result.dart';
import '../../../data/repositories/auth_repository.dart';
import '../otp/otp_controller.dart';

class SignUpController extends BaseController {
  SignUpController(this._auth);

  final AuthRepository _auth;

  final formKey = GlobalKey<FormState>();
  final mobile = TextEditingController();
  final acceptedTerms = true.obs;

  Future<void> requestOtp() async {
    if (!formKey.currentState!.validate()) return;
    if (!acceptedTerms.value) {
      AppSnack.error('Please accept the privacy policy and terms to continue');
      return;
    }

    OtpResult? result;
    final sent = await guard(() async => result = await _auth.sendOtp(mobile.text));
    if (!sent || result == null) return;

    Get.toNamed(Routes.otp, arguments: OtpArgs(mobile: mobile.text, initial: result!));
  }

  void goToSignIn() => Get.offNamed(Routes.signIn);

  @override
  void onClose() {
    mobile.dispose();
    super.onClose();
  }
}
