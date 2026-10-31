import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AppSnack {
  AppSnack._();

  static void error(String message) => _show(message, AppColors.error);

  static void success(String message) => _show(message, AppColors.submitted);

  static void info(String message) => _show(message, AppColors.heroBlue);

  static void _show(String message, Color color) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      messageText: Text(message, style: AppTextStyles.body.copyWith(color: Colors.white)),
      backgroundColor: color,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
}
