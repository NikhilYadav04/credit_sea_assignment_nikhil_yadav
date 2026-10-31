import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.current});

  final int current;

  static const _labels = ['Register', 'Offer', 'Approval'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < _labels.length; i++)
            _Step(number: i + 1, label: _labels[i], active: i + 1 == current),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.label, required this.active});

  final int number;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primary : AppColors.stepIdle,
          ),
          child: Text(
            '$number',
            style: AppTextStyles.caption.copyWith(
              color: active ? Colors.white : AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.stepLabel.copyWith(
            color: active ? AppColors.primary : AppColors.textMuted,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
