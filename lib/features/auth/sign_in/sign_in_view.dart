import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_scaffold.dart';
import '../../../core/widgets/phone_field.dart';
import '../../../core/utils/validators.dart';
import 'sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Please enter your credentials',
      children: [
        Form(
          key: controller.formKey,
          child: Column(
            children: [
              PhoneField(controller: controller.mobile),
              const SizedBox(height: 16),
              PasswordField(
                label: 'Enter password',
                controller: controller.password,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.required(value, 'your password'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => PrimaryButton(
            label: 'Sign In',
            isLoading: controller.isLoading.value,
            onPressed: controller.signIn,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: controller.goToSignUp,
            child: Text(
              'New to CreditSea? Create an account',
              style: AppTextStyles.bodyStrong.copyWith(color: AppColors.heroBlue),
            ),
          ),
        ),
      ],
    );
  }
}
