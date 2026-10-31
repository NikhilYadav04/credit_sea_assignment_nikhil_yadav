import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class DashedChip extends StatelessWidget {
  const DashedChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(fontSize: 13, color: AppColors.textDark),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final paint = Paint()
      ..shader = AppColors.borderGradient.createShader(bounds)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()..addRRect(RRect.fromRectAndRadius(bounds, const Radius.circular(2)));

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
        distance += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
