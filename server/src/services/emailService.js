const nodemailer = require('nodemailer');
const { env } = require('../config/env');

let transport;

function getTransport() {
  if (!env.smtp.host) return null;
  if (!transport) {
    transport = nodemailer.createTransport({
      host: env.smtp.host,
      port: env.smtp.port,
      secure: env.smtp.port === 465,
      auth: { user: env.smtp.user, pass: env.smtp.pass },
    });
  }
  return transport;
}

async function sendMail({ to, subject, text }) {
  const smtp = getTransport();
  if (!smtp) {
    console.log(`[mail:mock] to=${to} subject="${subject}" body="${text}"`);
    return;
  }
  await smtp.sendMail({ from: env.smtp.from, to, subject, text });
}

module.exports = { sendMail };
