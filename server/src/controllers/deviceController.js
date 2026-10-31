const { ok } = require('../utils/respond');
const notificationService = require('../services/notificationService');

async function register(req, res) {
  const { token, platform } = req.body;
  await notificationService.saveToken(req.user._id, token, platform);
  ok(res, {}, 'Device registered');
}

async function unregister(req, res) {
  await notificationService.removeToken(req.user._id, req.body.token);
  ok(res, {}, 'Device removed');
}

module.exports = { register, unregister };
