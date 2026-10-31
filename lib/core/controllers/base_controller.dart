import 'package:get/get.dart';

import '../network/api_exception.dart';
import '../widgets/app_snack.dart';

abstract class BaseController extends GetxController {
  final isLoading = false.obs;

  Future<bool> guard(Future<void> Function() action) async {
    isLoading.value = true;
    try {
      await action();
      return true;
    } on ApiException catch (e) {
      AppSnack.error(e.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
