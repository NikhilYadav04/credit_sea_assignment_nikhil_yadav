import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/auth_scaffold.dart';
import '../../../core/widgets/phone_field.dart';
import 'sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final linkStyle = AppTextStyles.caption.copyWith(
      color: AppColors.textMuted,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );

    return AuthScaffold(
      title: 'Welcome to Credit Sea!',
      children: [
        Form(
          key: controller.formKey,
          child: PhoneField(controller: controller.mobile),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: controller.acceptedTerms.value,
                onChanged: (v) => controller.acceptedTerms.value = v ?? false,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text.rich(
                    TextSpan(
                      style: AppTextStyles.caption,
                      children: [
                        const TextSpan(text: 'By continuing, you agree to our '),
                        TextSpan(text: 'privacy policies', style: linkStyle),
                        const TextSpan(text: ' and '),
                        TextSpan(text: 'Terms & Conditions.', style: linkStyle),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => PrimaryButton(
            label: 'Request OTP',
            isLoading: controller.isLoading.value,
            onPressed: controller.requestOtp,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: controller.goToSignIn,
            child: Text(
              'Existing User? Sign in',
              style: AppTextStyles.bodyStrong.copyWith(color: AppColors.heroBlue),
            ),
          ),
        ),
      ],
    );
  }
}
