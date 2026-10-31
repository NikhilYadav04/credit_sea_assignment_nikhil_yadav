const ApiError = require('../utils/apiError');

function validate(schema) {
  return (req, res, next) => {
    const { value, error } = schema.validate(req.body, { abortEarly: true, stripUnknown: true });
    if (error) throw ApiError.badRequest(error.details[0].message.replace(/"/g, ''));
    req.body = value;
    next();
  };
}

module.exports = validate;
