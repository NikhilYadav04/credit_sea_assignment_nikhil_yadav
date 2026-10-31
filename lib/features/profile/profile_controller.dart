import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/session/session_controller.dart';
import '../../data/models/user_model.dart';

class ProfileController extends GetxController {
  ProfileController(this._session);

  final SessionController _session;

  UserModel? get user => _session.user.value;

  Future<void> confirmLogout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to continue.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Log out')),
        ],
      ),
    );
    if (confirmed == true) await _session.logout();
  }
}
