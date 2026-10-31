const mongoose = require('mongoose');
const { env } = require('../src/config/env');

async function main() {
  if (!process.argv.includes('--yes')) {
    console.log('This deletes every document in the database. Run again with --yes to continue.');
    process.exit(1);
  }
  if (!env.mongoUri) {
    console.error('MONGODB_URI is not set');
    process.exit(1);
  }

  await mongoose.connect(env.mongoUri);
  const db = mongoose.connection.db;
  console.log(`Database: ${db.databaseName}`);

  const collections = await db.listCollections().toArray();
  for (const { name } of collections) {
    const { deletedCount } = await db.collection(name).deleteMany({});
    console.log(`${name}: removed ${deletedCount}`);
  }

  await mongoose.disconnect();
  console.log('Done');
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
