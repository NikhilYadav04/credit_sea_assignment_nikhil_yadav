import '../../data/models/loan_offer.dart';

LoanQuote calculateLoan(LoanRules rules, int amount, int tenureDays) {
  final interest = (amount * rules.interestPerDay * tenureDays).round();
  final fee = (amount * rules.processingFeePercent / 100).round();
  return LoanQuote(
    amount: amount,
    tenureDays: tenureDays,
    interest: interest,
    processingFee: fee,
    totalPayable: amount + interest + fee,
  );
}
