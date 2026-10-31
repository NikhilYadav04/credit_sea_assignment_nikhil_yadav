import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/session/session_controller.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class CreatePasswordController extends BaseController {
  CreatePasswordController(this._auth, this._session);

  final AuthRepository _auth;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final confirm = TextEditingController();

  late final String _verificationToken = Get.arguments as String;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    await guard(() async {
      final session = await _auth.setPassword(_verificationToken, password.text);
      await _session.start(session);
      Get.offAllNamed(Routes.personalDetails);
    });
  }

  @override
  void onClose() {
    password.dispose();
    confirm.dispose();
    super.onClose();
  }
}
