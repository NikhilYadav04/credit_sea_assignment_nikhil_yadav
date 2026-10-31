import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_scaffold.dart';
import 'create_password_controller.dart';

class CreatePasswordView extends GetView<CreatePasswordController> {
  const CreatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create a password',
      onBack: Get.back,
      children: [
        Form(
          key: controller.formKey,
          child: Column(
            children: [
              PasswordField(
                label: 'Enter password',
                controller: controller.password,
                validator: Validators.password,
              ),
              const SizedBox(height: 16),
              PasswordField(
                label: 'Re enter password',
                hint: 'Re enter password',
                controller: controller.confirm,
                textInputAction: TextInputAction.done,
                validator: Validators.confirmPassword(() => controller.password.text),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '*your password must include at least 8 characters, inclusive of alt least 1 special character',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 16),
        Obx(
          () => PrimaryButton(
            label: 'Proceed',
            isLoading: controller.isLoading.value,
            onPressed: controller.submit,
          ),
        ),
      ],
    );
  }
}
