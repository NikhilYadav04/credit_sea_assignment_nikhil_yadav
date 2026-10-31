const LOAN_RULES = {
  interestPerDay: 0.01,
  processingFeePercent: 10,
  minAmount: 5000,
  amountStep: 1000,
  minTenureDays: 20,
  maxTenureDays: 45,
  defaultTenureDays: 30,
};

function calculateLoan(amount, tenureDays) {
  const interest = Math.round(amount * LOAN_RULES.interestPerDay * tenureDays);
  const processingFee = Math.round((amount * LOAN_RULES.processingFeePercent) / 100);
  return {
    amount,
    tenureDays,
    interest,
    processingFee,
    totalPayable: amount + interest + processingFee,
  };
}

module.exports = { LOAN_RULES, calculateLoan };
