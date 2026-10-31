import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyMedium: AppTextStyles.body,
      titleMedium: AppTextStyles.label,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _outline(AppColors.fieldBorder),
      enabledBorder: _outline(AppColors.fieldBorder),
      focusedBorder: _outline(AppColors.primary),
      errorBorder: _outline(AppColors.error),
      focusedErrorBorder: _outline(AppColors.error),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.submitted : null,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );

  static OutlineInputBorder _outline(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}
