import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/session/session_controller.dart';
import '../../core/controllers/base_controller.dart';
import '../../data/models/loan_application.dart';
import '../../data/models/loan_offer.dart';
import '../../data/repositories/loan_repository.dart';

class HomeController extends BaseController {
  HomeController(this._loans, this._session);

  final LoanRepository _loans;
  final SessionController _session;

  final applications = <LoanApplication>[].obs;
  final offer = Rxn<LoanOffer>();
  final isFirstLoad = true.obs;

  String get firstName => _session.user.value?.firstName ?? '';

  bool get hasOpenApplication => applications.any((a) => !a.isFinished);

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  Future<void> refreshData() async {
    await guard(() async {
      final results = await Future.wait([_loans.list(), _loans.getOffer()]);
      applications.assignAll(results[0] as List<LoanApplication>);
      offer.value = results[1] as LoanOffer;
    });
    isFirstLoad.value = false;
  }

  void applyForLoan() => Get.toNamed(Routes.calculator)?.then((_) => refreshData());

  void openApplication(LoanApplication application) {
    Get.toNamed(Routes.applicationStatus, arguments: application.id)?.then((_) => refreshData());
  }

  void openProfile() => Get.toNamed(Routes.profile);
}
