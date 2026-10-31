import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/session/session_controller.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class SignInController extends BaseController {
  SignInController(this._auth, this._session);

  final AuthRepository _auth;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  final mobile = TextEditingController();
  final password = TextEditingController();

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    await guard(() async {
      final session = await _auth.login(mobile.text, password.text);
      await _session.start(session);
      Get.offAllNamed(_session.routeFor(session.user));
    });
  }

  void goToSignUp() => Get.offNamed(Routes.signUp);

  @override
  void onClose() {
    mobile.dispose();
    password.dispose();
    super.onClose();
  }
}
