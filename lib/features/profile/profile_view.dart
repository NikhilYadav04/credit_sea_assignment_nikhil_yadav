import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/sheet_scaffold.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.user;
    if (user == null) return const SizedBox.shrink();

    final initials = [user.firstName, user.lastName]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .map((s) => s[0].toUpperCase())
        .join();

    return SheetScaffold(
      header: const SizedBox(height: 16),
      title: 'My Profile',
      bottom: OutlineAppButton(label: 'Log out', onPressed: controller.confirmLogout),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary,
            child: Text(
              initials,
              style: AppTextStyles.sheetTitle.copyWith(color: Colors.white, fontSize: 24),
            ),
          ),
          const SizedBox(height: 12),
          Text(user.fullName, style: AppTextStyles.bodyStrong.copyWith(fontSize: 17)),
          const SizedBox(height: 24),
          _InfoRow('Mobile', Formatters.maskedMobile(user.mobile)),
          _InfoRow('Email', user.email ?? '-'),
          _InfoRow('Gender', user.gender ?? '-'),
          _InfoRow(
            'Date of birth',
            user.dob == null ? '-' : DateFormat('dd MMM yyyy').format(user.dob!),
          ),
          _InfoRow('Marital status', user.maritalStatus ?? '-'),
          _InfoRow('PAN', user.pan ?? '-'),
          _InfoRow('Credit score', '${user.creditScore}'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 14)),
          Flexible(child: Text(value, style: AppTextStyles.bodyStrong, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
