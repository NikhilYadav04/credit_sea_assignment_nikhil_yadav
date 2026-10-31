const ApiError = require('../utils/apiError');
const { env } = require('../config/env');

function notFound(req, res, next) {
  next(ApiError.notFound(`Route not found: ${req.method} ${req.originalUrl}`));
}

function errorHandler(err, req, res, next) {
  if (err instanceof ApiError) {
    return res.status(err.status).json({ success: false, message: err.message });
  }
  if (err.code === 11000) {
    return res.status(409).json({ success: false, message: 'This record already exists' });
  }
  if (err.name === 'CastError') {
    return res.status(400).json({ success: false, message: 'Invalid id' });
  }

  console.error(err);
  const message = env.isProduction ? 'Something went wrong' : err.message;
  return res.status(500).json({ success: false, message });
}

module.exports = { notFound, errorHandler };
