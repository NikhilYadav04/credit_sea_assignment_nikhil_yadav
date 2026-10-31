import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/utils/upper_case_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/illustrations.dart';
import '../../../core/widgets/sheet_scaffold.dart';
import 'verify_pan_controller.dart';

class VerifyPanView extends GetView<VerifyPanController> {
  const VerifyPanView({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      step: 1,
      title: 'Verify PAN Number',
      bottom: Obx(
        () => PrimaryButton(
          label: 'Verify',
          isLoading: controller.isLoading.value,
          onPressed: controller.verify,
        ),
      ),
      child: Column(
        children: [
          const CardIllustration(),
          const SizedBox(height: 24),
          Form(
            key: controller.formKey,
            child: AppTextField(
              label: 'Enter Your PAN Number',
              required: true,
              hint: 'e.g., ABCDE1234F',
              controller: controller.pan,
              maxLength: 10,
              textCapitalization: TextCapitalization.characters,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                const UpperCaseFormatter(),
              ],
              validator: Validators.pan,
            ),
          ),
        ],
      ),
    );
  }
}
