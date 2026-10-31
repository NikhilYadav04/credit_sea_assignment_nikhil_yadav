class LoanRules {
  const LoanRules({
    required this.interestPerDay,
    required this.processingFeePercent,
    required this.minAmount,
    required this.amountStep,
    required this.minTenureDays,
    required this.maxTenureDays,
    required this.defaultTenureDays,
  });

  final double interestPerDay;
  final double processingFeePercent;
  final int minAmount;
  final int amountStep;
  final int minTenureDays;
  final int maxTenureDays;
  final int defaultTenureDays;

  factory LoanRules.fromJson(Map<String, dynamic> json) {
    return LoanRules(
      interestPerDay: (json['interestPerDay'] as num).toDouble(),
      processingFeePercent: (json['processingFeePercent'] as num).toDouble(),
      minAmount: (json['minAmount'] as num).toInt(),
      amountStep: (json['amountStep'] as num).toInt(),
      minTenureDays: (json['minTenureDays'] as num).toInt(),
      maxTenureDays: (json['maxTenureDays'] as num).toInt(),
      defaultTenureDays: (json['defaultTenureDays'] as num).toInt(),
    );
  }
}

class LoanQuote {
  const LoanQuote({
    required this.amount,
    required this.tenureDays,
    required this.interest,
    required this.processingFee,
    required this.totalPayable,
  });

  final int amount;
  final int tenureDays;
  final int interest;
  final int processingFee;
  final int totalPayable;

  factory LoanQuote.fromJson(Map<String, dynamic> json) {
    return LoanQuote(
      amount: (json['amount'] as num).toInt(),
      tenureDays: (json['tenureDays'] as num).toInt(),
      interest: (json['interest'] as num).toInt(),
      processingFee: (json['processingFee'] as num).toInt(),
      totalPayable: (json['totalPayable'] as num).toInt(),
    );
  }
}

class LoanOffer {
  const LoanOffer({
    required this.eligible,
    required this.rules,
    required this.maxAmount,
    this.reason,
    this.quote,
  });

  final bool eligible;
  final String? reason;
  final LoanRules rules;
  final int maxAmount;
  final LoanQuote? quote;

  factory LoanOffer.fromJson(Map<String, dynamic> json) {
    return LoanOffer(
      eligible: json['eligible'] as bool,
      reason: json['reason'] as String?,
      rules: LoanRules.fromJson(json['rules'] as Map<String, dynamic>),
      maxAmount: (json['maxAmount'] as num).toInt(),
      quote: json['offer'] == null
          ? null
          : LoanQuote.fromJson(json['offer'] as Map<String, dynamic>),
    );
  }
}
