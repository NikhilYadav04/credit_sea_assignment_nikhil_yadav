import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/otp_input.dart';
import '../../../core/widgets/sheet_scaffold.dart';
import '../../../core/widgets/illustrations.dart';
import 'email_verify_controller.dart';

class EmailVerifyView extends GetView<EmailVerifyController> {
  const EmailVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      step: 1,
      title: 'Personal Email ID',
      bottom: Obx(
        () => PrimaryButton(
          label: 'Verify',
          isLoading: controller.isLoading.value,
          onPressed: controller.verify,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: EmailIllustration()),
          const SizedBox(height: 24),
          Form(
            key: controller.formKey,
            child: Obx(
              () => AppTextField(
                label: 'Email ID',
                required: true,
                hint: 'Enter your email ID',
                controller: controller.email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                suffix: controller.otpSent.value
                    ? null
                    : TextButton(
                        onPressed: controller.isLoading.value ? null : controller.sendOtp,
                        child: Text('Send OTP', style: AppTextStyles.link),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const FieldLabel('OTP Verification'),
          OtpInput(
            length: controller.otpLength,
            boxSize: 48,
            autofocus: false,
            controller: controller.otpField,
            onChanged: (v) => controller.code.value = v,
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (!controller.otpSent.value) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Didn't receive it? ", style: AppTextStyles.caption),
                    GestureDetector(
                      onTap: controller.countdown.finished ? controller.sendOtp : null,
                      child: Text(
                        'Resend Code',
                        style: AppTextStyles.link.copyWith(
                          color: controller.countdown.finished
                              ? null
                              : AppTextStyles.caption.color,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(controller.countdown.label, style: AppTextStyles.caption),
              ],
            );
          }),
        ],
      ),
    );
  }
}
