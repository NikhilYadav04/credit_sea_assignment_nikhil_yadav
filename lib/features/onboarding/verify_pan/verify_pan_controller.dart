import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/session/session_controller.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../data/repositories/user_repository.dart';

class VerifyPanController extends BaseController {
  VerifyPanController(this._users, this._session);

  final UserRepository _users;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  final pan = TextEditingController();

  Future<void> verify() async {
    if (!formKey.currentState!.validate()) return;

    await guard(() async {
      final user = await _users.verifyPan(pan.text.trim().toUpperCase());
      _session.updateUser(user);
      Get.offAllNamed(Routes.calculator);
    });
  }

  @override
  void onClose() {
    pan.dispose();
    super.onClose();
  }
}
