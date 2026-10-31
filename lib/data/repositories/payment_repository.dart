import '../../app/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/payment_order.dart';

class PaymentRepository {
  PaymentRepository(this._api);

  final ApiClient _api;

  Future<PaymentOrder> createOrder(String applicationId) async {
    final data = await _api.post(ApiEndpoints.paymentOrder, body: {'applicationId': applicationId});
    return PaymentOrder.fromJson(data);
  }

  Future<int> verify({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    final data = await _api.post(
      ApiEndpoints.paymentVerify,
      body: {
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      },
    );
    return (data['creditScore'] as num).toInt();
  }
}
