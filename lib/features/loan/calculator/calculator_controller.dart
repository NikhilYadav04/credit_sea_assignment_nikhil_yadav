import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/controllers/base_controller.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/loan_math.dart';
import '../../../core/widgets/app_snack.dart';
import '../../../data/models/loan_offer.dart';
import '../../../data/models/loan_request.dart';
import '../../../data/repositories/loan_repository.dart';

class CalculatorController extends BaseController {
  CalculatorController(this._loans);

  static const purposes = [
    'Medical',
    'Education',
    'Travel',
    'Home Renovation',
    'Business',
    'Personal Needs',
  ];

  final LoanRepository _loans;

  final offer = Rxn<LoanOffer>();
  final isLoadingOffer = true.obs;
  final purpose = RxnString();
  final amount = 0.obs;
  final tenure = 0.obs;

  LoanRules get rules => offer.value!.rules;
  LoanQuote get quote => calculateLoan(rules, amount.value, tenure.value);
  bool get isReady => offer.value?.eligible ?? false;

  int get amountDivisions =>
      (offer.value!.maxAmount - rules.minAmount) ~/ rules.amountStep;
  int get tenureDivisions => rules.maxTenureDays - rules.minTenureDays;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoadingOffer.value = true;
    try {
      final result = await _loans.getOffer();
      if (result.eligible) {
        amount.value = result.maxAmount;
        tenure.value = result.rules.defaultTenureDays;
      }
      offer.value = result;
    } on ApiException catch (e) {
      AppSnack.error(e.message);
    } finally {
      isLoadingOffer.value = false;
    }
  }

  void setAmount(double value) {
    final step = rules.amountStep;
    amount.value = (value / step).round() * step;
  }

  void setTenure(double value) => tenure.value = value.round();

  void apply() {
    final chosen = purpose.value;
    if (chosen == null) {
      AppSnack.error('Select the purpose of your loan');
      return;
    }
    Get.toNamed(Routes.offer, arguments: LoanRequest(quote: quote, purpose: chosen));
  }

  void cancel() {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      goHome();
    }
  }

  void goHome() => Get.offAllNamed(Routes.home);
}
