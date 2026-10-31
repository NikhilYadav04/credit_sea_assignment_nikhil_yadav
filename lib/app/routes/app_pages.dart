import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/loan_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../features/auth/create_password/create_password_controller.dart';
import '../../features/auth/create_password/create_password_view.dart';
import '../../features/auth/otp/otp_controller.dart';
import '../../features/auth/otp/otp_view.dart';
import '../../features/auth/sign_in/sign_in_controller.dart';
import '../../features/auth/sign_in/sign_in_view.dart';
import '../../features/auth/sign_up/sign_up_controller.dart';
import '../../features/auth/sign_up/sign_up_view.dart';
import '../../features/home/home_controller.dart';
import '../../features/home/home_view.dart';
import '../../features/loan/calculator/calculator_controller.dart';
import '../../features/loan/calculator/calculator_view.dart';
import '../../features/loan/offer/offer_controller.dart';
import '../../features/loan/offer/offer_view.dart';
import '../../features/onboarding/email_verify/email_verify_controller.dart';
import '../../features/onboarding/email_verify/email_verify_view.dart';
import '../../features/onboarding/personal_details/personal_details_controller.dart';
import '../../features/onboarding/personal_details/personal_details_view.dart';
import '../../features/onboarding/verify_pan/verify_pan_controller.dart';
import '../../features/onboarding/verify_pan/verify_pan_view.dart';
import '../../features/profile/profile_controller.dart';
import '../../features/profile/profile_view.dart';
import '../../features/splash/splash_controller.dart';
import '../../features/splash/splash_view.dart';
import '../../features/status/application_status_controller.dart';
import '../../features/status/application_status_view.dart';
import '../../features/status/repayment_controller.dart';
import '../session/session_controller.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController(Get.find<SessionController>()));
      }),
    ),
    GetPage(
      name: Routes.signIn,
      page: () => const SignInView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => SignInController(Get.find<AuthRepository>(), Get.find<SessionController>()),
        ),
      ),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => const SignUpView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => SignUpController(Get.find<AuthRepository>())),
      ),
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => OtpController(Get.find<AuthRepository>())),
      ),
    ),
    GetPage(
      name: Routes.createPassword,
      page: () => const CreatePasswordView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => CreatePasswordController(Get.find<AuthRepository>(), Get.find<SessionController>()),
        ),
      ),
    ),
    GetPage(
      name: Routes.personalDetails,
      page: () => const PersonalDetailsView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => PersonalDetailsController(Get.find<UserRepository>(), Get.find<SessionController>()),
        ),
      ),
    ),
    GetPage(
      name: Routes.emailVerify,
      page: () => const EmailVerifyView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => EmailVerifyController(Get.find<UserRepository>(), Get.find<SessionController>()),
        ),
      ),
    ),
    GetPage(
      name: Routes.verifyPan,
      page: () => const VerifyPanView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => VerifyPanController(Get.find<UserRepository>(), Get.find<SessionController>()),
        ),
      ),
    ),
    GetPage(
      name: Routes.offer,
      page: () => const OfferView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => OfferController(Get.find<LoanRepository>())),
      ),
    ),
    GetPage(
      name: Routes.calculator,
      page: () => const CalculatorView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => CalculatorController(Get.find<LoanRepository>())),
      ),
    ),
    GetPage(
      name: Routes.applicationStatus,
      page: () => const ApplicationStatusView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(
          () => RepaymentController(Get.find<PaymentRepository>(), Get.find<SessionController>()),
        );
        Get.lazyPut(
          () => ApplicationStatusController(
            Get.find<LoanRepository>(),
            Get.find<RepaymentController>(),
          ),
        );
      }),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => HomeController(Get.find<LoanRepository>(), Get.find<SessionController>()),
        ),
      ),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => ProfileController(Get.find<SessionController>())),
      ),
    ),
  ];
}
