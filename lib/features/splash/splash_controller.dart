import 'package:get/get.dart';

import '../../app/session/session_controller.dart';

class SplashController extends GetxController {
  SplashController(this._session);

  final SessionController _session;

  @override
  void onReady() {
    super.onReady();
    _openNext();
  }

  Future<void> _openNext() async {
    final results = await Future.wait([
      _session.resolveStartRoute(),
      Future<void>.delayed(const Duration(milliseconds: 1500)),
    ]);
    Get.offAllNamed(results.first as String);
  }
}
