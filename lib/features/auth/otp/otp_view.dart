import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/auth_scaffold.dart';
import '../../../core/widgets/otp_input.dart';
import 'otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Enter OTP',
      onBack: Get.back,
      children: [
        Text.rich(
          TextSpan(
            style: AppTextStyles.body,
            children: [
              const TextSpan(text: 'Verify OTP, Sent on '),
              TextSpan(
                text: Formatters.maskedMobile(controller.args.mobile),
                style: AppTextStyles.bodyStrong,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OtpInput(
          length: controller.otpLength,
          controller: controller.otpField,
          onChanged: (v) => controller.code.value = v,
        ),
        const SizedBox(height: 16),
        Obx(
          () => controller.countdown.finished
              ? GestureDetector(
                  onTap: controller.resend,
                  child: Text('Resend OTP', style: AppTextStyles.link),
                )
              : Text(controller.countdown.label, style: AppTextStyles.bodyStrong),
        ),
        const SizedBox(height: 24),
        Obx(
          () => PrimaryButton(
            label: 'Verify',
            isLoading: controller.isLoading.value,
            onPressed: controller.code.value.length == controller.otpLength
                ? controller.verify
                : null,
          ),
        ),
      ],
    );
  }
}
