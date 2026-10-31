import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/dimens.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/illustrations.dart';
import '../../../core/widgets/step_indicator.dart';
import 'offer_controller.dart';

class OfferView extends GetView<OfferController> {
  const OfferView({super.key});

  @override
  Widget build(BuildContext context) {
    final quote = controller.request.quote;
    final strong = AppTextStyles.bodyStrong.copyWith(fontSize: 15);
    final normal = AppTextStyles.body.copyWith(fontSize: 15);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StepIndicator(current: 2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.pagePadding),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    Text('Our Offerings', style: AppTextStyles.sheetTitle),
                    const Spacer(),
                    const RupeeCoin(),
                    const Spacer(),
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        style: normal.copyWith(height: 1.4),
                        children: [
                          TextSpan(
                            text: 'Congratulations! ',
                            style: normal.copyWith(color: AppColors.congrats),
                          ),
                          const TextSpan(text: 'We can offer you '),
                          TextSpan(text: 'Rs. ${Formatters.number(quote.amount)}', style: strong),
                          const TextSpan(text: ' Amount Within '),
                          TextSpan(text: '30 minutes', style: strong),
                          const TextSpan(text: ' for '),
                          TextSpan(text: '${quote.tenureDays} days', style: normal),
                          const TextSpan(text: ', with a payable amount of '),
                          TextSpan(
                            text: 'Rs. ${Formatters.number(quote.totalPayable)}',
                            style: strong,
                          ),
                          const TextSpan(text: '. Just with few more steps.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Proceed further to', style: strong),
                    const Spacer(flex: 2),
                    Obx(
                      () => PrimaryButton(
                        label: 'Accept Offer',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.accept,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlineAppButton(label: 'Extend Offer', onPressed: controller.extend),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
