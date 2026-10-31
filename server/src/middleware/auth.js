const jwt = require('jsonwebtoken');
const User = require('../models/User');
const ApiError = require('../utils/apiError');
const { env } = require('../config/env');

async function requireAuth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) throw ApiError.unauthorized();

  let payload;
  try {
    payload = jwt.verify(token, env.jwtSecret);
  } catch {
    throw ApiError.unauthorized('Your session has expired, please sign in again');
  }
  if (payload.purpose) throw ApiError.unauthorized();

  const user = await User.findById(payload.sub);
  if (!user) throw ApiError.unauthorized();

  req.user = user;
  next();
}

function requireAdmin(req, res, next) {
  if (!env.adminKey || req.headers['x-admin-key'] !== env.adminKey) {
    throw ApiError.forbidden('Admin access only');
  }
  next();
}

module.exports = { requireAuth, requireAdmin };
