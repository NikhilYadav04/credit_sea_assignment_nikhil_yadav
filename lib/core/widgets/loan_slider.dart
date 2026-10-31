import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class LoanSlider extends StatelessWidget {
  const LoanSlider({
    super.key,
    required this.label,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.minLabel,
    this.maxLabel,
  });

  final String label;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final String? minLabel;
  final String? maxLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyStrong),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.fieldBorder),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(valueText, style: AppTextStyles.input),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 14,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.sliderTrack,
            trackShape: const _FlatTrackShape(),
            thumbShape: const _BarThumbShape(),
            overlayShape: SliderComponentShape.noOverlay,
            tickMarkShape: SliderTickMarkShape.noTickMark,
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        if (minLabel != null || maxLabel != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(minLabel ?? '', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                Text(maxLabel ?? '', style: AppTextStyles.caption.copyWith(fontSize: 10)),
              ],
            ),
          ),
      ],
    );
  }
}

class _FlatTrackShape extends RoundedRectSliderTrackShape {
  const _FlatTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final height = sliderTheme.trackHeight ?? 14;
    final top = offset.dy + (parentBox.size.height - height) / 2;
    return Rect.fromLTWH(offset.dx, top, parentBox.size.width, height);
  }
}

class _BarThumbShape extends SliderComponentShape {
  const _BarThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(8, 26);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 7, height: 26),
      const Radius.circular(3),
    );
    context.canvas.drawRRect(rect, Paint()..color = AppColors.primary);
  }
}
