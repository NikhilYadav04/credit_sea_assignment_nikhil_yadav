import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../data/models/loan_request.dart';
import '../../../data/repositories/loan_repository.dart';

class OfferController extends BaseController {
  OfferController(this._loans);

  final LoanRepository _loans;

  late final LoanRequest request = Get.arguments as LoanRequest;

  Future<void> accept() async {
    final quote = request.quote;
    await guard(() async {
      final application = await _loans.apply(
        amount: quote.amount,
        tenureDays: quote.tenureDays,
        purpose: request.purpose,
      );
      Get.offAllNamed(Routes.applicationStatus, arguments: application);
    });
  }

  void extend() => Get.back();
}
