import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/constants/dimens.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../utils/validators.dart';
import 'app_text_field.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({super.key, required this.controller, this.enabled = true});

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Mobile Number'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CountryCode(),
            const SizedBox(width: 8),
            Expanded(
              child: AppTextField(
                controller: controller,
                enabled: enabled,
                hint: 'Please enter your mobile no.',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: Validators.mobile,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CountryCode extends StatelessWidget {
  const _CountryCode();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.fieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(Dimens.fieldRadius),
      ),
      child: Row(
        children: [
          const _IndiaFlag(),
          const SizedBox(width: 10),
          Text('+91', style: AppTextStyles.input),
        ],
      ),
    );
  }
}

class _IndiaFlag extends StatelessWidget {
  const _IndiaFlag();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 28,
        height: 28,
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFFFF9933))),
            Expanded(
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF000080), width: 1),
                  ),
                ),
              ),
            ),
            Expanded(child: Container(color: const Color(0xFF138808))),
          ],
        ),
      ),
    );
  }
}
