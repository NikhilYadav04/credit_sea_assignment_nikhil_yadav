import 'package:get/get.dart';

import '../../core/services/push_service.dart';
import '../../core/storage/token_storage.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../routes/app_routes.dart';

class SessionController extends GetxController {
  SessionController(this._auth, this._tokens, this._push);

  final AuthRepository _auth;
  final TokenStorage _tokens;
  final PushService _push;

  final user = Rxn<UserModel>();

  bool get hasToken => _tokens.read() != null;

  Future<String> resolveStartRoute() async {
    if (!hasToken) return Routes.signIn;
    try {
      user.value = await _auth.currentUser();
      _push.registerDevice();
      return routeFor(user.value!);
    } catch (_) {
      return hasToken ? Routes.home : Routes.signIn;
    }
  }

  Future<void> start(AuthSession session) async {
    await _tokens.write(session.token);
    user.value = session.user;
    _push.registerDevice();
  }

  void updateUser(UserModel updated) => user.value = updated;

  Future<UserModel> refreshUser() async {
    final fresh = await _auth.currentUser();
    user.value = fresh;
    return fresh;
  }

  bool _loggingOut = false;

  Future<void> logout() async {
    if (_loggingOut) return;
    _loggingOut = true;
    try {
      await _push.unregisterDevice();
      await _tokens.clear();
      user.value = null;
      Get.offAllNamed(Routes.signIn);
    } finally {
      _loggingOut = false;
    }
  }

  String routeFor(UserModel user) {
    switch (user.onboardingStep) {
      case OnboardingStep.personal:
        return Routes.personalDetails;
      case OnboardingStep.email:
        return Routes.emailVerify;
      case OnboardingStep.pan:
        return Routes.verifyPan;
      case OnboardingStep.complete:
        return Routes.home;
    }
  }
}
