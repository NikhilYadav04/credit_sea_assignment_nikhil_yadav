import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/dashed_chip.dart';
import '../../../core/widgets/gradient_border_box.dart';
import '../../../core/widgets/loan_slider.dart';
import '../../../core/widgets/sheet_scaffold.dart';
import '../../../core/widgets/skeleton_box.dart';
import 'calculator_controller.dart';

class CalculatorView extends GetView<CalculatorController> {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.cancel();
      },
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return SheetScaffold(
      title: 'Apply for loan',
      subtitle:
          "We've calculated your loan eligibility. Select your preferred loan amount and tenure.",
      onBack: controller.cancel,
      header: const Padding(
        padding: EdgeInsets.fromLTRB(0, 24, 0, 16),
        child: AppLogo(onDark: false, size: 34),
      ),
      bottom: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: 'Apply',
              onPressed: controller.isReady ? controller.apply : null,
            ),
            const SizedBox(height: 12),
            OutlineAppButton(label: 'Cancel', onPressed: controller.cancel),
          ],
        ),
      ),
      child: Obx(() {
        if (controller.isLoadingOffer.value) return const _CalculatorSkeleton();

        final offer = controller.offer.value;
        if (offer == null) {
          return _Message(
            text: 'We could not load your loan eligibility.',
            buttonLabel: 'Try again',
            onPressed: controller.load,
          );
        }
        if (!offer.eligible) {
          return _Message(
            text: offer.reason ?? 'You are not eligible for a loan right now.',
            buttonLabel: 'Go to home',
            onPressed: controller.goHome,
          );
        }
        return _CalculatorForm(controller: controller);
      }),
    );
  }
}

class _CalculatorForm extends StatelessWidget {
  const _CalculatorForm({required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    final rules = controller.rules;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DashedChip(
                text: 'Interest Per Day ${_percent(rules.interestPerDay * 100)}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashedChip(
                text: 'Processing Fee ${_percent(rules.processingFeePercent)}%',
              ),
            ),
          ],
        ),
        const Divider(height: 32, color: AppColors.fieldBorder),
        Obx(
          () => AppDropdown(
            label: 'Purpose of Loan',
            required: true,
            hint: 'Select purpose of loan',
            items: CalculatorController.purposes,
            value: controller.purpose.value,
            onChanged: (v) => controller.purpose.value = v,
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => LoanSlider(
            label: 'Principal Amount',
            valueText: '₹  ${Formatters.number(controller.amount.value)}',
            value: controller.amount.value.toDouble(),
            min: rules.minAmount.toDouble(),
            max: controller.offer.value!.maxAmount.toDouble(),
            divisions: controller.amountDivisions,
            onChanged: controller.setAmount,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => LoanSlider(
            label: 'Tenure',
            valueText: '${controller.tenure.value} Days',
            value: controller.tenure.value.toDouble(),
            min: rules.minTenureDays.toDouble(),
            max: rules.maxTenureDays.toDouble(),
            divisions: controller.tenureDivisions,
            minLabel: '${rules.minTenureDays} Days',
            maxLabel: '${rules.maxTenureDays} Days',
            onChanged: controller.setTenure,
          ),
        ),
        const SizedBox(height: 24),
        Obx(() {
          final quote = controller.quote;
          return GradientBorderBox(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                _SummaryRow('Principle Amount', Formatters.rupees(quote.amount)),
                const SizedBox(height: 14),
                _SummaryRow('Interest', Formatters.rupees(quote.interest)),
                const SizedBox(height: 14),
                _SummaryRow('Total Payable', Formatters.rupees(quote.totalPayable)),
              ],
            ),
          );
        }),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Thank you for choosing CreditSea. Please accept to proceed with the loan details.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyStrong.copyWith(
              color: AppColors.noteBlue,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  String _percent(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 15)),
        Text(
          value,
          style: AppTextStyles.bodyStrong.copyWith(color: AppColors.primary, fontSize: 15),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.buttonLabel, required this.onPressed});

  final String text;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(text, textAlign: TextAlign.center, style: AppTextStyles.bodyStrong),
          const SizedBox(height: 24),
          PrimaryButton(label: buttonLabel, onPressed: onPressed),
        ],
      ),
    );
  }
}

class _CalculatorSkeleton extends StatelessWidget {
  const _CalculatorSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 40)),
            SizedBox(width: 12),
            Expanded(child: SkeletonBox(height: 40)),
          ],
        ),
        SizedBox(height: 32),
        SkeletonBox(),
        SizedBox(height: 28),
        SkeletonBox(height: 24),
        SizedBox(height: 28),
        SkeletonBox(height: 24),
        SizedBox(height: 28),
        SkeletonBox(height: 110),
      ],
    );
  }
}
