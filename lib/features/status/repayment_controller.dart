import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../app/session/session_controller.dart';
import '../../core/controllers/base_controller.dart';
import '../../core/network/api_exception.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_snack.dart';
import '../../data/models/loan_application.dart';
import '../../data/repositories/payment_repository.dart';

class RepaymentController extends BaseController {
  RepaymentController(this._payments, this._session);

  final PaymentRepository _payments;
  final SessionController _session;
  final _razorpay = Razorpay();

  void Function()? onRepaid;

  @override
  void onInit() {
    super.onInit();
    _razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _onError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {});
  }

  Future<void> repay(LoanApplication application) async {
    await guard(() async {
      final order = await _payments.createOrder(application.id);
      final user = _session.user.value;

      if (order.mock) {
        final confirmed = await _confirmMockPayment(order.amount ~/ 100);
        if (confirmed) await _confirm(order.orderId, 'mock_payment', 'mock');
        return;
      }

      _razorpay.open({
        'key': order.keyId,
        'order_id': order.orderId,
        'amount': order.amount,
        'name': 'CreditSea',
        'description': 'Repayment for #${order.applicationNo}',
        'prefill': {'contact': user?.mobile ?? '', 'email': user?.email ?? ''},
        'theme': {'color': '#0075FF'},
      });
    });
  }

  Future<void> _onSuccess(PaymentSuccessResponse response) async {
    final orderId = response.orderId;
    final paymentId = response.paymentId;
    final signature = response.signature;
    if (orderId == null || paymentId == null || signature == null) {
      AppSnack.error('Payment could not be confirmed');
      return;
    }
    await _confirm(orderId, paymentId, signature);
  }

  Future<bool> _confirmMockPayment(int rupees) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Demo payment'),
        content: Text('Pay ${Formatters.rupees(rupees)} to repay this loan? No real money is charged.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Pay')),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _confirm(String orderId, String paymentId, String signature) async {
    try {
      final score = await _payments.verify(
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
      );
      AppSnack.success('Repayment received. Your credit score is now $score');
      await _session.refreshUser();
      onRepaid?.call();
    } on ApiException catch (e) {
      AppSnack.error(e.message);
    }
  }

  void _onError(PaymentFailureResponse response) {
    AppSnack.error(response.message ?? 'Payment cancelled');
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
