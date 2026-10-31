import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/date_picker_field.dart';
import '../../../core/widgets/sheet_scaffold.dart';
import '../../../core/widgets/skeleton_box.dart';
import 'personal_details_controller.dart';

class PersonalDetailsView extends GetView<PersonalDetailsController> {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPrefilling.value) return const _PersonalDetailsSkeleton();

      return SheetScaffold(
        step: 1,
        title: 'Personal Details',
        onBack: controller.goBack,
        bottom: PrimaryButton(
          label: 'Continue',
          isLoading: controller.isLoading.value,
          onPressed: controller.submit,
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'First Name',
                      required: true,
                      hint: 'Your first name',
                      controller: controller.firstName,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) => Validators.required(v, 'your first name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppTextField(
                      label: 'Last Name',
                      required: true,
                      hint: 'Your last name',
                      controller: controller.lastName,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) => Validators.required(v, 'your last name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppDropdown(
                label: 'Gender',
                required: true,
                hint: 'Select your gender',
                items: PersonalDetailsController.genders,
                value: controller.gender.value,
                onChanged: (v) => controller.gender.value = v,
                validator: (v) => v == null ? 'Select your gender' : null,
              ),
              const SizedBox(height: 20),
              DatePickerField(
                label: 'Date of Birth',
                required: true,
                value: controller.dob.value,
                lastDate: controller.latestDob,
                onPicked: (d) => controller.dob.value = d,
                validator: (d) => d == null ? 'Select your date of birth' : null,
              ),
              const SizedBox(height: 20),
              AppDropdown(
                label: 'Your Marital Status',
                required: true,
                hint: 'Select',
                items: PersonalDetailsController.maritalStatuses,
                value: controller.maritalStatus.value,
                onChanged: (v) => controller.maritalStatus.value = v,
                validator: (v) => v == null ? 'Select your marital status' : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _PersonalDetailsSkeleton extends StatelessWidget {
  const _PersonalDetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonBox(height: 20, radius: 6),
              const SizedBox(height: 44),
              const SkeletonBox(width: 170, height: 20, radius: 6),
              const SizedBox(height: 40),
              const Row(
                children: [
                  Expanded(child: SkeletonBox(height: 18, radius: 6)),
                  SizedBox(width: 8),
                  Expanded(child: SkeletonBox(height: 18, radius: 6)),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(child: SkeletonBox()),
                  SizedBox(width: 8),
                  Expanded(child: SkeletonBox()),
                ],
              ),
              for (var i = 0; i < 2; i++) ...const [
                SizedBox(height: 24),
                SkeletonBox(height: 18, radius: 6),
                SizedBox(height: 12),
                SkeletonBox(),
              ],
              const Spacer(),
              const SkeletonBox(),
            ],
          ),
        ),
      ),
    );
  }
}
