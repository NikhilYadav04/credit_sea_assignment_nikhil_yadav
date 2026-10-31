import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/sheet_scaffold.dart';
import '../../core/widgets/skeleton_box.dart';
import '../../core/widgets/status_step_tile.dart';
import '../../data/models/loan_application.dart';
import 'application_status_controller.dart';

class ApplicationStatusView extends GetView<ApplicationStatusController> {
  const ApplicationStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.goHome();
      },
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return SheetScaffold(
      step: 3,
      title: 'Application Status',
      onBack: controller.goHome,
      bottom: Obx(() {
        final application = controller.application.value;
        final repayment = controller.repayment;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (application != null && application.canRepay) ...[
              PrimaryButton(
                label: 'Repay ${Formatters.rupees(application.totalPayable)}',
                isLoading: repayment.isLoading.value,
                onPressed: () => repayment.repay(application),
              ),
              const SizedBox(height: 12),
              OutlineAppButton(label: 'Continue', onPressed: controller.goHome),
            ] else
              PrimaryButton(label: 'Continue', onPressed: controller.goHome),
          ],
        );
      }),
      child: Obx(() {
        final application = controller.application.value;
        if (application == null) return const _StatusSkeleton();
        return _StatusBody(application: application);
      }),
    );
  }
}

class _StatusBody extends StatelessWidget {
  const _StatusBody({required this.application});

  final LoanApplication application;

  @override
  Widget build(BuildContext context) {
    final steps = application.timeline;
    final rejected = application.status == 'REJECTED';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: AppTextStyles.body,
            children: [
              const TextSpan(text: 'Loan application no. '),
              TextSpan(text: '#${application.applicationNo}', style: AppTextStyles.bodyStrong),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < steps.length; i++)
          StatusStepTile(step: steps[i], showConnector: i != steps.length - 1),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Icon(
                rejected ? Icons.cancel_outlined : Icons.fact_check_outlined,
                size: 44,
                color: rejected ? AppColors.error : AppColors.primary,
              ),
              const SizedBox(height: 8),
              Text(application.bannerTitle, style: AppTextStyles.bodyStrong.copyWith(fontSize: 15)),
              const SizedBox(height: 4),
              Text(
                rejected && application.rejectionReason != null
                    ? application.rejectionReason!
                    : application.repaid
                        ? 'Your loan is fully repaid. Thank you!'
                        : application.bannerMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusSkeleton extends StatelessWidget {
  const _StatusSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 6; i++) ...const [
          SkeletonBox(height: 48),
          SizedBox(height: 16),
        ],
      ],
    );
  }
}
