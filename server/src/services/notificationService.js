const DeviceToken = require('../models/DeviceToken');
const { messaging } = require('../config/firebase');

const DEAD_TOKEN_CODES = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
]);

function stringifyData(data = {}) {
  const out = {};
  for (const [key, value] of Object.entries(data)) {
    if (value === null || value === undefined) continue;
    out[key] = typeof value === 'string' ? value : JSON.stringify(value);
  }
  return out;
}

async function saveToken(userId, token, platform) {
  await DeviceToken.findOneAndUpdate(
    { token },
    { user: userId, platform, active: true },
    { upsert: true },
  );
}

async function removeToken(userId, token) {
  await DeviceToken.updateOne({ user: userId, token }, { active: false });
}

async function sendToUser(userId, { title, body, data }) {
  if (!messaging) return;

  try {
    const devices = await DeviceToken.find({ user: userId, active: true });
    if (!devices.length) return;

    const results = await Promise.allSettled(
      devices.map((device) =>
        messaging.send({
          token: device.token,
          notification: { title, body },
          data: stringifyData(data),
          android: { priority: 'high', notification: { channelId: 'loan_updates' } },
        }),
      ),
    );

    await Promise.all(
      results.map((result, i) => {
        if (result.status === 'fulfilled') return null;
        const code = result.reason?.code;
        console.error(`push failed (${code}):`, result.reason?.message);
        return DEAD_TOKEN_CODES.has(code)
          ? DeviceToken.updateOne({ _id: devices[i]._id }, { active: false })
          : null;
      }),
    );
  } catch (err) {
    console.error('push error:', err.message);
  }
}

module.exports = { saveToken, removeToken, sendToUser };
