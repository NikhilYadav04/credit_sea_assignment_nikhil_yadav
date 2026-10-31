import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/dimens.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/gradient_border_box.dart';
import '../../core/widgets/skeleton_box.dart';
import '../../data/models/loan_application.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          child: ListView(
            padding: const EdgeInsets.all(Dimens.pagePadding),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(onDark: false, size: 32),
                  IconButton(
                    onPressed: controller.openProfile,
                    icon: const Icon(Icons.account_circle_outlined, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Obx(() => Text('Hi, ${controller.firstName}', style: AppTextStyles.sheetTitle)),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isFirstLoad.value) return const SkeletonBox(height: 150);
                return _LimitCard(controller: controller);
              }),
              const SizedBox(height: 28),
              Text('Your applications', style: AppTextStyles.bodyStrong.copyWith(fontSize: 16)),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.isFirstLoad.value) {
                  return const Column(
                    children: [SkeletonBox(height: 72), SizedBox(height: 12), SkeletonBox(height: 72)],
                  );
                }
                if (controller.applications.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'No applications yet. Apply for your first loan above.',
                      style: AppTextStyles.caption,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final application in controller.applications)
                      _ApplicationCard(
                        application: application,
                        onTap: () => controller.openApplication(application),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LimitCard extends StatelessWidget {
  const _LimitCard({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final offer = controller.offer.value;
    final eligible = offer?.eligible ?? false;

    return GradientBorderBox(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eligible ? 'You can borrow up to' : 'Loan eligibility', style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(
            eligible ? Formatters.rupees(offer!.maxAmount) : (offer?.reason ?? 'Unavailable'),
            style: eligible
                ? AppTextStyles.sheetTitle.copyWith(color: AppColors.primary, fontSize: 28)
                : AppTextStyles.body,
          ),
          const SizedBox(height: 16),
          if (controller.hasOpenApplication)
            Text('You have a loan in progress.', style: AppTextStyles.caption)
          else if (eligible)
            PrimaryButton(label: 'Apply for a loan', onPressed: controller.applyForLoan),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.application, required this.onTap});

  final LoanApplication application;
  final VoidCallback onTap;

  Color get _statusColor {
    switch (application.status) {
      case 'DISBURSED':
        return AppColors.submitted;
      case 'REJECTED':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.fieldBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Formatters.rupees(application.amount),
                      style: AppTextStyles.bodyStrong.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#${application.applicationNo}  •  ${application.tenureDays} days',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  application.bannerTitle.replaceAll('Application ', ''),
                  style: AppTextStyles.caption.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
