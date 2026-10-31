const admin = require('firebase-admin');
const { env } = require('./env');

let messaging = null;

function toPem(rawKey) {
  const key = rawKey.trim().replace(/^["']|["']$/g, '').replace(/\\n/g, '\n');
  if (key.includes('BEGIN PRIVATE KEY')) return key;

  const body = key.replace(/\s+/g, '');
  const lines = body.match(/.{1,64}/g).join('\n');
  return `-----BEGIN PRIVATE KEY-----\n${lines}\n-----END PRIVATE KEY-----\n`;
}

if (env.firebase.projectId && env.firebase.clientEmail && env.firebase.privateKey) {
  try {
    admin.initializeApp({
      credential: admin.credential.cert({
        projectId: env.firebase.projectId,
        clientEmail: env.firebase.clientEmail,
        privateKey: toPem(env.firebase.privateKey),
      }),
    });
    messaging = admin.messaging();
    console.log('Firebase Admin initialised');
  } catch (err) {
    console.error('Firebase Admin failed to start:', err.message);
  }
}

module.exports = { messaging };
