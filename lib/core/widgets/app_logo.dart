import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.onDark = true, this.size = 40, this.stacked = false});

  final bool onDark;
  final double size;

  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final textColor = onDark ? Colors.white : AppColors.primary;
    final mark = CustomPaint(size: Size.square(size), painter: _MarkPainter(onDark: onDark));
    final wordmark = Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Credit', style: _style(textColor, FontWeight.w500)),
          TextSpan(text: 'Sea', style: _style(textColor, FontWeight.w300)),
        ],
      ),
    );

    if (stacked) {
      return Column(mainAxisSize: MainAxisSize.min, children: [mark, const SizedBox(height: 8), wordmark]);
    }
    return Row(mainAxisSize: MainAxisSize.min, children: [mark, const SizedBox(width: 8), wordmark]);
  }

  TextStyle _style(Color color, FontWeight weight) {
    return GoogleFonts.montserrat(fontSize: size * 0.8, fontWeight: weight, color: color);
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter({required this.onDark});

  final bool onDark;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final disc = Paint()..color = onDark ? Colors.white : AppColors.primary;
    canvas.drawCircle(Offset(w / 2, w / 2), w / 2, disc);

    final sail = Paint()..color = const Color(0xFF1BE5A0);
    final path = Path()
      ..moveTo(w * 0.12, w * 0.62)
      ..lineTo(w * 0.62, w * 0.22)
      ..lineTo(w * 0.52, w * 0.45)
      ..lineTo(w * 1.0, w * 0.42)
      ..lineTo(w * 0.56, w * 0.7)
      ..lineTo(w * 0.34, w * 0.62)
      ..close();
    canvas.drawPath(path, sail);
  }

  @override
  bool shouldRepaint(covariant _MarkPainter old) => old.onDark != onDark;
}
