import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF0075FF);
  static const heroBlue = Color(0xFF0F4B92);
  static const teal = Color(0xFF00A676);
  static const congrats = Color(0xFF59DD2B);
  static const submitted = Color(0xFF00935D);
  static const error = Color(0xFFD93025);
  static const noteBlue = Color(0xFF2C7DA8);

  static const textDark = Color(0xFF2B2B2B);
  static const textMuted = Color(0xFF838383);
  static const hint = Color(0xFF9AA0A6);

  static const fieldBorder = Color(0xFFE4E7EC);
  static const stepIdle = Color(0xFFE8E8E8);
  static const stepPendingBorder = Color(0xFFB6BCC8);
  static const sliderTrack = Color(0xFFEBF4FF);
  static const skeleton = Color(0xFFD9D9D9);

  static const borderGradient = LinearGradient(
    colors: [primary, teal],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
