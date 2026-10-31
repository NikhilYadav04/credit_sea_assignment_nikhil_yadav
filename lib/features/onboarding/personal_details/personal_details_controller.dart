import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/session/session_controller.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../data/repositories/user_repository.dart';

class PersonalDetailsController extends BaseController {
  PersonalDetailsController(this._users, this._session);

  static const genders = ['Male', 'Female', 'Other'];
  static const maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed'];

  final UserRepository _users;
  final SessionController _session;

  final formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final gender = RxnString();
  final maritalStatus = RxnString();
  final dob = Rxn<DateTime>();

  final isPrefilling = true.obs;

  DateTime get latestDob {
    final now = DateTime.now();
    return DateTime(now.year - 18, now.month, now.day);
  }

  @override
  void onInit() {
    super.onInit();
    _prefill();
  }

  Future<void> _prefill() async {
    try {
      final user = await _session.refreshUser();
      firstName.text = user.firstName ?? '';
      lastName.text = user.lastName ?? '';
      gender.value = user.gender;
      maritalStatus.value = user.maritalStatus;
      dob.value = user.dob;
    } catch (_) {
    } finally {
      isPrefilling.value = false;
    }
  }

  Future<void> goBack() async {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
      return;
    }
    final leave = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Leave registration?'),
        content: const Text('You will be signed out. Sign in again to continue where you left off.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Stay')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Sign out')),
        ],
      ),
    );
    if (leave == true) await _session.logout();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    await guard(() async {
      final user = await _users.saveProfile(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        gender: gender.value!,
        dob: dob.value!,
        maritalStatus: maritalStatus.value!,
      );
      _session.updateUser(user);
      Get.toNamed(Routes.emailVerify);
    });
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    super.onClose();
  }
}
