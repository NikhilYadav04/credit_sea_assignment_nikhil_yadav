# CreditSea Loan App

A loan application app built with Flutter (GetX) and a Node.js / MongoDB backend. A user signs up with a mobile number and OTP, fills in their details, gets a loan offer, applies, and follows the application until it is disbursed. Disbursed loans can be repaid through Razorpay (test mode), and status changes arrive as push notifications.

The screens follow the Figma file in `design/`.

## What it does

- Sign up with mobile OTP, set a password, sign in with mobile and password
- Stay signed in until the user logs out (the JWT is kept on the device)
- Onboarding: personal details, email verification by OTP, PAN check
- Eligibility based on age, credit score and profile
- Loan calculator with amount and tenure sliders
- Application tracking: Submitted, Under Review, E-KYC, E-Nach, E-Sign, Disbursement (or Rejected)
- Credit score that goes up when a loan is repaid, and lifts the loan limit
- Razorpay repayment and FCM push notifications

## Project layout

```
lib/
  app/            routes, bindings, theme, session controller
  core/           api client, storage, services, validators, shared widgets
  data/           models and repositories
  features/       one folder per screen: controller + view
server/
  src/
    models/       User, Otp, LoanApplication, Payment, DeviceToken
    services/     otp, eligibility, loan, payment, credit score, notifications
    controllers/  thin request handlers
    routes/       route table and request validation
  tests/          API tests
design/           Figma exports
```

State management is GetX. Each screen has a controller (state and actions) and a view (layout only). Controllers talk to repositories, and repositories are the only code that knows about HTTP. Shared pieces such as buttons, fields, the OTP input and the page shells live in `lib/core/widgets`.

## Running the backend

```
cd server
cp .env.example .env      # fill in MONGODB_URI and JWT_SECRET at least
npm install
npm start
```

To try the API without a database, `npm run dev:memory` starts it against an in-memory MongoDB.

`npm test` runs the API tests (they use an in-memory MongoDB as well).

### Environment variables

| Name | Purpose |
|---|---|
| `MONGODB_URI` | MongoDB Atlas connection string |
| `JWT_SECRET` | signs session tokens |
| `OTP_MODE` | `mock` returns the OTP in the response and logs it. There is no SMS gateway |
| `ADMIN_KEY` | protects the manual status endpoint |
| `STAGE_SECONDS` | how long each loan stage lasts before the application moves on |
| `RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET` | Razorpay test keys |
| `FIREBASE_*` | service account for push. Leave empty to switch push off |
| `SMTP_*` | optional, sends real email OTPs. Without it the code is logged |

## Deploying the backend

The API ships with a `server/Dockerfile` and a `render.yaml` for Render.

1. Create a new Blueprint on Render and pick this repository. It reads `render.yaml` and builds the Docker image from `server/`.
2. Fill in the secret variables Render asks for (`MONGODB_URI`, `JWT_SECRET`, `ADMIN_KEY`, the Razorpay keys and the Firebase service account values).
3. In MongoDB Atlas, allow Render to connect under Network Access.
4. Check `https://<your-service>.onrender.com/api/health`, then point the app at it with `API_BASE_URL`.

The free plan sleeps after a few minutes without traffic, so the first request can take close to a minute.

## Running the app

```
flutter pub get
flutter run
```

The app talks to the deployed API at `https://credit-sea-assignment-nikhil-yadav-1.onrender.com/api` by default. To use a server on your own computer from the Android emulator, run `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api`.

Push notifications need `android/app/google-services.json` from your Firebase project. Without that file the app builds and runs normally, it just has no push.

## API

All responses look like `{ success, message, data }`.

| Method | Path | Notes |
|---|---|---|
| POST | `/auth/send-otp` | `{ mobile }` |
| POST | `/auth/verify-otp` | returns a short-lived verification token |
| POST | `/auth/set-password` | creates the account, returns a session token |
| POST | `/auth/login` | `{ mobile, password }` |
| GET | `/auth/me` | current user and onboarding step |
| PUT | `/user/profile` | name, gender, date of birth, marital status |
| POST | `/user/email/send-otp`, `/user/email/verify` | email verification |
| POST | `/user/pan` | PAN format check |
| GET | `/loan/offer` | eligibility, limits and a default offer |
| POST | `/loan/apply` | `{ amount, tenureDays, purpose }` |
| GET | `/loan/applications`, `/loan/applications/:id` | list and status |
| PATCH | `/loan/applications/:id/status` | admin only (`x-admin-key`) |
| POST | `/payments/order`, `/payments/verify` | Razorpay repayment |
| POST, DELETE | `/devices` | register or remove an FCM token |

## How loans work

- Interest is 1% per day and the processing fee is 10%, both on the principal. Total payable is principal + interest + fee. The app calculates this locally for the sliders using the same formula as the server (`server/src/utils/loanMath.js`), and the server recomputes it when you apply.
- Eligibility (`server/src/services/eligibilityService.js`): profile, email and PAN must be complete, age 21 to 58, credit score of at least 500. The limit starts at 10,000 and goes up for ages 25 to 45, for married users, and for every 50 points of credit score above 600. It is capped at 1,00,000.
- Only one application can be open at a time.
- A repayment adds 25 points to the credit score when paid before the due date, 5 when late (max 900).

## Things to know

- **No real back office.** Nobody reviews applications, so a background job on the server (`loanProgressJob`, every second) moves each open application forward every `STAGE_SECONDS` and sends a push notification at each change, even when the app is closed. The approval decision re-runs the eligibility rules. On a free host that sleeps when idle, the job only runs while the server is awake. `PATCH /loan/applications/:id/status` can set a status by hand.
- **No real SMS.** In `mock` mode the OTP is returned by the API and shown in a snackbar in the app, so the flow can be demoed. Plug an SMS provider into `otpService.deliver` for production.
- **PAN verification** only checks the format and that no other account uses it.
- The Android manifest allows cleartext HTTP so the emulator can reach a local server. Remove `usesCleartextTraffic` if you only talk to an HTTPS server.
- Fonts are loaded through `google_fonts`, so the first launch needs internet.
