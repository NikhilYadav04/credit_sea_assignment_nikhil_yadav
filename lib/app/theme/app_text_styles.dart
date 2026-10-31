import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _montserrat(
    double size,
    FontWeight weight, {
    Color color = AppColors.textDark,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static final sheetTitle = _montserrat(
    20,
    FontWeight.w600,
    height: 1.0,
    letterSpacing: 20 * 0.02,
  );

  static final authTitle = _montserrat(20, FontWeight.w600);
  static final label = _montserrat(14, FontWeight.w500);
  static final body = _montserrat(14, FontWeight.w400);
  static final bodyStrong = _montserrat(14, FontWeight.w600);
  static final input = _montserrat(14, FontWeight.w400);
  static final hint = _montserrat(14, FontWeight.w400, color: AppColors.hint);
  static final caption = _montserrat(12, FontWeight.w400, color: AppColors.textMuted);
  static final link = _montserrat(12, FontWeight.w500, color: AppColors.primary);
  static final button = _montserrat(16, FontWeight.w600, color: Colors.white);
  static final buttonOutline = _montserrat(16, FontWeight.w600);
  static final stepLabel = _montserrat(13, FontWeight.w500, color: AppColors.textMuted);
  static final error = _montserrat(12, FontWeight.w400, color: AppColors.error);
}
