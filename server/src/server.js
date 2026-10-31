const { env, assertConfigured } = require('./config/env');
const { connectDb } = require('./config/db');
const { createApp } = require('./app');
const { startLoanProgressJob } = require('./services/loanProgressJob');

async function start() {
  assertConfigured();
  await connectDb(env.mongoUri);
  createApp().listen(env.port, () => {
    console.log(`CreditSea API listening on port ${env.port}`);
    startLoanProgressJob();
  });
}

start().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
