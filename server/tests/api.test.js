process.env.JWT_SECRET = 'test-secret';
process.env.ADMIN_KEY = 'test-admin';
process.env.OTP_MODE = 'mock';
process.env.STAGE_SECONDS = '1';

const { test, before, after } = require('node:test');
const assert = require('node:assert/strict');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');

const { createApp } = require('../src/app');

let mongod;
let server;
let baseUrl;

async function call(method, path, { body, token, headers } = {}) {
  const res = await fetch(`${baseUrl}/api${path}`, {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...headers,
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  return { status: res.status, body: await res.json() };
}

before(async () => {
  mongod = await MongoMemoryServer.create();
  await mongoose.connect(mongod.getUri());
  await new Promise((resolve) => {
    server = createApp().listen(0, resolve);
  });
  baseUrl = `http://127.0.0.1:${server.address().port}`;
});

after(async () => {
  server.close();
  await mongoose.disconnect();
  await mongod.stop();
});

async function signUp(mobile) {
  const sent = await call('POST', '/auth/send-otp', { body: { mobile } });
  assert.equal(sent.status, 200);
  const verified = await call('POST', '/auth/verify-otp', {
    body: { mobile, otp: sent.body.data.devOtp },
  });
  const created = await call('POST', '/auth/set-password', {
    body: { verificationToken: verified.body.data.verificationToken, password: 'Strong@123' },
  });
  assert.equal(created.status, 201);
  return created.body.data.token;
}

async function completeOnboarding(token, { dob = '1995-05-10', maritalStatus = 'Married', pan }) {
  await call('PUT', '/user/profile', {
    token,
    body: { firstName: 'Asha', lastName: 'Rao', gender: 'Female', dob, maritalStatus },
  });
  const email = `${pan.toLowerCase()}@example.com`;
  const sent = await call('POST', '/user/email/send-otp', { token, body: { email } });
  const verified = await call('POST', '/user/email/verify', {
    token,
    body: { email, otp: sent.body.data.devOtp },
  });
  assert.equal(verified.status, 200);
  const panRes = await call('POST', '/user/pan', { token, body: { pan } });
  assert.equal(panRes.body.data.user.onboardingStep, 'complete');
}

test('signup, login and onboarding progress', async () => {
  const token = await signUp('9876543210');

  const me = await call('GET', '/auth/me', { token });
  assert.equal(me.body.data.user.onboardingStep, 'personal');

  const duplicate = await call('POST', '/auth/send-otp', { body: { mobile: '9876543210' } });
  assert.equal(duplicate.status, 409);

  const wrong = await call('POST', '/auth/login', {
    body: { mobile: '9876543210', password: 'nope' },
  });
  assert.equal(wrong.status, 401);

  const login = await call('POST', '/auth/login', {
    body: { mobile: '9876543210', password: 'Strong@123' },
  });
  assert.equal(login.status, 200);
  assert.ok(login.body.data.token);
});

test('rejects weak password and wrong otp', async () => {
  const sent = await call('POST', '/auth/send-otp', { body: { mobile: '9123456780' } });
  const wrongOtp = sent.body.data.devOtp === '0000' ? '1111' : '0000';
  const bad = await call('POST', '/auth/verify-otp', { body: { mobile: '9123456780', otp: wrongOtp } });
  assert.equal(bad.status, 400);

  const resend = await call('POST', '/auth/send-otp', { body: { mobile: '9123456780' } });
  assert.equal(resend.status, 429);

  const weak = await call('POST', '/auth/set-password', {
    body: { verificationToken: 'x', password: 'short' },
  });
  assert.equal(weak.status, 400);
});

test('requires auth for protected routes', async () => {
  const res = await call('GET', '/loan/offer');
  assert.equal(res.status, 401);
});

test('loan application moves through every stage', async () => {
  const token = await signUp('9000000001');

  const early = await call('GET', '/loan/offer', { token });
  assert.equal(early.body.data.eligible, false);

  await completeOnboarding(token, { pan: 'ABCDE1234F' });

  const offer = await call('GET', '/loan/offer', { token });
  assert.equal(offer.body.data.eligible, true);
  assert.ok(offer.body.data.maxAmount >= 20000);

  const tooMuch = await call('POST', '/loan/apply', {
    token,
    body: { amount: 900000, tenureDays: 30, purpose: 'Medical' },
  });
  assert.equal(tooMuch.status, 400);

  const applied = await call('POST', '/loan/apply', {
    token,
    body: { amount: 10000, tenureDays: 30, purpose: 'Medical' },
  });
  assert.equal(applied.status, 201);
  const application = applied.body.data.application;
  assert.match(application.applicationNo, /^CS\d{5}$/);
  assert.equal(application.totalPayable, 10000 + 3000 + 1000);
  assert.equal(application.timeline.length, 6);

  const second = await call('POST', '/loan/apply', {
    token,
    body: { amount: 10000, tenureDays: 30, purpose: 'Travel' },
  });
  assert.equal(second.status, 409);

  await new Promise((resolve) => setTimeout(resolve, 6500));
  const done = await call('GET', `/loan/applications/${application.id}`, { token });
  assert.equal(done.body.data.application.status, 'DISBURSED');
  assert.ok(done.body.data.application.timeline.every((row) => row.state === 'done'));
});

test('underage-for-lending users are not eligible', async () => {
  const token = await signUp('9000000002');
  await completeOnboarding(token, { dob: '2006-01-01', pan: 'PQRSX5678L' });

  const offer = await call('GET', '/loan/offer', { token });
  assert.equal(offer.body.data.eligible, false);
  assert.match(offer.body.data.reason, /ages 21 to 58/);
});

test('admin can reject an application', async () => {
  const token = await signUp('9000000003');
  await completeOnboarding(token, { pan: 'LMNOP4321Q' });
  const applied = await call('POST', '/loan/apply', {
    token,
    body: { amount: 5000, tenureDays: 20, purpose: 'Education' },
  });
  const id = applied.body.data.application.id;

  const denied = await call('PATCH', `/loan/applications/${id}/status`, {
    body: { status: 'REJECTED' },
  });
  assert.equal(denied.status, 403);

  const rejected = await call('PATCH', `/loan/applications/${id}/status`, {
    headers: { 'x-admin-key': 'test-admin' },
    body: { status: 'REJECTED', rejectionReason: 'Policy' },
  });
  assert.equal(rejected.body.data.application.status, 'REJECTED');
  assert.equal(rejected.body.data.application.timeline[1].state, 'rejected');
});
