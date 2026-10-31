import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/controllers/base_controller.dart';
import '../../data/models/loan_application.dart';
import '../../data/repositories/loan_repository.dart';
import 'repayment_controller.dart';

class ApplicationStatusController extends BaseController {
  ApplicationStatusController(this._loans, this.repayment);

  static const _pollInterval = Duration(seconds: 3);

  final LoanRepository _loans;
  final RepaymentController repayment;
  final application = Rxn<LoanApplication>();
  Timer? _poll;

  @override
  void onReady() {
    super.onReady();
    repayment.onRepaid = _reload;
    _start();
  }

  Future<void> _start() async {
    final args = Get.arguments;
    String? id;

    if (args is LoanApplication) {
      application.value = args;
      id = args.id;
    } else if (args is String) {
      id = args;
      await _load(id);
    } else {
      final all = await _fetchAll();
      if (all.isNotEmpty) {
        application.value = all.first;
        id = all.first.id;
      }
    }

    if (id != null) _startPolling(id);
  }

  Future<List<LoanApplication>> _fetchAll() async {
    try {
      return await _loans.list();
    } catch (e) {
      debugPrint('Could not load applications: $e');
      return const [];
    }
  }

  Future<void> _load(String id) async {
    await guard(() async => application.value = await _loans.detail(id));
  }

  void _reload() {
    final id = application.value?.id;
    if (id != null) _load(id);
  }

  void _startPolling(String id) {
    _poll?.cancel();
    _poll = Timer.periodic(_pollInterval, (timer) async {
      try {
        final fresh = await _loans.detail(id);
        application.value = fresh;
        if (fresh.isFinished) timer.cancel();
      } catch (e) {
        debugPrint('Status refresh failed: $e');
      }
    });
  }

  void goHome() => Get.offAllNamed(Routes.home);

  @override
  void onClose() {
    _poll?.cancel();
    super.onClose();
  }
}
