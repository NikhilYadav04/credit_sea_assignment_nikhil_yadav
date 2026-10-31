const { LOAN_RULES } = require('../utils/loanMath');

const MIN_AGE = 21;
const MAX_AGE = 58;
const MIN_CREDIT_SCORE = 500;
const BASE_LIMIT = 10000;
const LIMIT_CAP = 100000;

function ageOf(dob, today) {
  let age = today.getFullYear() - dob.getFullYear();
  const hadBirthday =
    today.getMonth() > dob.getMonth() ||
    (today.getMonth() === dob.getMonth() && today.getDate() >= dob.getDate());
  if (!hadBirthday) age -= 1;
  return age;
}

function rejection(reason) {
  return { eligible: false, reason, maxAmount: 0 };
}

function checkEligibility(user, today = new Date()) {
  if (user.onboardingStep !== 'complete') {
    return rejection('Complete your profile to check eligibility');
  }

  const age = ageOf(user.dob, today);
  if (age < MIN_AGE || age > MAX_AGE) {
    return rejection(`Loans are available for ages ${MIN_AGE} to ${MAX_AGE}`);
  }
  if (user.creditScore < MIN_CREDIT_SCORE) {
    return rejection('Your credit score is too low for a loan right now');
  }

  let limit = BASE_LIMIT;
  if (age >= 25 && age <= 45) limit += 10000;
  if (user.maritalStatus === 'Married') limit += 5000;
  limit += Math.max(0, Math.floor((user.creditScore - 600) / 50)) * 5000;

  return { eligible: true, reason: null, maxAmount: Math.min(limit, LIMIT_CAP) };
}

module.exports = { checkEligibility, ageOf };
