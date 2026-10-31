import 'package:creditsea/core/utils/formatters.dart';
import 'package:creditsea/core/utils/loan_math.dart';
import 'package:creditsea/data/models/loan_offer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const rules = LoanRules(
    interestPerDay: 0.01,
    processingFeePercent: 10,
    minAmount: 5000,
    amountStep: 1000,
    minTenureDays: 20,
    maxTenureDays: 45,
    defaultTenureDays: 30,
  );

  test('adds daily interest and the processing fee to the principal', () {
    final quote = calculateLoan(rules, 10000, 30);
    expect(quote.interest, 3000);
    expect(quote.processingFee, 1000);
    expect(quote.totalPayable, 14000);
  });

  test('matches the server for the smallest loan', () {
    final quote = calculateLoan(rules, 5000, 20);
    expect(quote.totalPayable, 5000 + 1000 + 500);
  });

  test('formats rupees with Indian grouping', () {
    expect(Formatters.rupees(100000), '₹1,00,000');
    expect(Formatters.number(30000), '30,000');
  });
}
