import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class GradientBorderBox extends StatelessWidget {
  const GradientBorderBox({
    super.key,
    required this.child,
    this.radius = 8,
    this.borderWidth = 2,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final double radius;
  final double borderWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.borderGradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.all(borderWidth),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius - borderWidth),
        ),
        child: child,
      ),
    );
  }
}
