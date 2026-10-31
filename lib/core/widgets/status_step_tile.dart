import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/loan_application.dart';

class StatusStepTile extends StatelessWidget {
  const StatusStepTile({super.key, required this.step, this.showConnector = true});

  final TimelineStep step;
  final bool showConnector;

  Color get _color {
    switch (step.state) {
      case StageState.done:
        return AppColors.submitted;
      case StageState.active:
        return AppColors.primary;
      case StageState.rejected:
        return AppColors.error;
      case StageState.pending:
        return AppColors.stepPendingBorder;
    }
  }

  Color get _textColor =>
      step.state == StageState.pending ? AppColors.textMuted : _color;

  IconData get _icon {
    switch (step.state) {
      case StageState.done:
        return Icons.assignment_turned_in_outlined;
      case StageState.rejected:
        return Icons.cancel_outlined;
      case StageState.active:
      case StageState.pending:
        return Icons.assignment_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final highlighted = step.state != StageState.pending;
    return Column(
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _color, width: highlighted ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Icon(_icon, color: highlighted ? _color : AppColors.textMuted, size: 22),
              Expanded(
                child: Text(
                  step.label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: _textColor),
                ),
              ),
              const SizedBox(width: 22),
            ],
          ),
        ),
        if (showConnector) Container(width: 1.5, height: 16, color: AppColors.stepPendingBorder),
      ],
    );
  }
}
