process.env.JWT_SECRET = process.env.JWT_SECRET || 'local-dev-secret';
process.env.ADMIN_KEY = process.env.ADMIN_KEY || 'local-admin';
process.env.OTP_MODE = 'mock';

const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const { env } = require('../src/config/env');
const { createApp } = require('../src/app');
const { startLoanProgressJob } = require('../src/services/loanProgressJob');

async function main() {
  const mongod = await MongoMemoryServer.create();
  await mongoose.connect(mongod.getUri());
  createApp().listen(env.port, () => {
    console.log(`CreditSea API (in-memory db) on http://localhost:${env.port}/api`);
    startLoanProgressJob();
  });
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
