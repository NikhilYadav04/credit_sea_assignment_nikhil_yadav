import 'package:flutter/material.dart';

import '../../app/constants/dimens.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return Container(
      height: Dimens.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.fieldRadius),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.fieldRadius),
          ),
          minimumSize: const Size.fromHeight(Dimens.buttonHeight),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
              )
            : Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

class OutlineAppButton extends StatelessWidget {
  const OutlineAppButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.buttonHeight,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.fieldRadius),
          ),
        ),
        child: Text(label, style: AppTextStyles.buttonOutline),
      ),
    );
  }
}
