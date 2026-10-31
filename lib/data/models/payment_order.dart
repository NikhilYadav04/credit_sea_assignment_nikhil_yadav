class PaymentOrder {
  const PaymentOrder({
    required this.keyId,
    required this.orderId,
    required this.amount,
    required this.applicationNo,
    required this.mock,
  });

  final bool mock;
  final String keyId;
  final String orderId;

  final int amount;
  final String applicationNo;

  factory PaymentOrder.fromJson(Map<String, dynamic> json) {
    return PaymentOrder(
      mock: json['mock'] as bool? ?? false,
      keyId: json['keyId'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toInt(),
      applicationNo: json['applicationNo'] as String,
    );
  }
}
