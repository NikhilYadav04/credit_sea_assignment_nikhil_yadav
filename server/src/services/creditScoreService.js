const User = require('../models/User');

const MAX_SCORE = 900;
const ON_TIME_BONUS = 25;
const LATE_BONUS = 5;

async function recordRepayment(userId, { onTime }) {
  const user = await User.findById(userId);
  if (!user) return null;

  const bonus = onTime ? ON_TIME_BONUS : LATE_BONUS;
  user.creditScore = Math.min(MAX_SCORE, user.creditScore + bonus);
  await user.save();
  return user.creditScore;
}

module.exports = { recordRepayment };
