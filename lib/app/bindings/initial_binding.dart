import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../core/services/push_service.dart';
import '../../core/storage/token_storage.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/loan_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../session/session_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final tokens = TokenStorage();
    Get.put(tokens, permanent: true);

    final api = ApiClient(tokens, onUnauthorized: () => Get.find<SessionController>().logout());
    Get.put(api, permanent: true);

    final auth = AuthRepository(api);
    final push = PushService(api, tokens);
    Get.put(push, permanent: true);
    Get.put(auth, permanent: true);
    Get.put(UserRepository(api), permanent: true);
    Get.put(LoanRepository(api), permanent: true);
    Get.put(PaymentRepository(api), permanent: true);
    Get.put(SessionController(auth, tokens, push), permanent: true);
  }
}
