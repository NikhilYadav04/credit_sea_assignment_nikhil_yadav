import 'loan_offer.dart';

class LoanRequest {
  const LoanRequest({required this.quote, required this.purpose});

  final LoanQuote quote;
  final String purpose;
}
