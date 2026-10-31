const LoanApplication = require('../models/LoanApplication');
const User = require('../models/User');
const loanService = require('./loanService');

const INTERVAL_MS = 1000;

async function tick() {
  const open = await LoanApplication.find({ status: { $nin: ['REJECTED', 'DISBURSED'] } });
  for (const application of open) {
    const user = await User.findById(application.user);
    if (user) await loanService.advanceApplication(application, user);
  }
}

function startLoanProgressJob() {
  let running = false;
  return setInterval(async () => {
    if (running) return;
    running = true;
    try {
      await tick();
    } catch (err) {
      console.error('loan progress job failed:', err.message);
    } finally {
      running = false;
    }
  }, INTERVAL_MS);
}

module.exports = { startLoanProgressJob };
