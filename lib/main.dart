import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'core/services/push_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  InitialBinding().dependencies();
  await Get.find<PushService>().init();

  runApp(const CreditSeaApp());
}

class CreditSeaApp extends StatelessWidget {
  const CreditSeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CreditSea',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
