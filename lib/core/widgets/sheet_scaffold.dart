import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/dimens.dart';
import '../../app/theme/app_text_styles.dart';
import 'keyboard_dismiss.dart';
import 'step_indicator.dart';

class SheetScaffold extends StatelessWidget {
  const SheetScaffold({
    super.key,
    required this.title,
    required this.child,
    this.header,
    this.step,
    this.subtitle,
    this.bottom,
    this.showBack = true,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? bottom;

  final Widget? header;
  final int? step;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              header ?? StepIndicator(current: step ?? 1),
              Expanded(
                child: _Sheet(
                  title: title,
                  subtitle: subtitle,
                  showBack: showBack,
                  onBack: onBack ?? Get.back,
                  bottom: bottom,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.title,
    required this.child,
    required this.showBack,
    required this.onBack,
    this.subtitle,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? bottom;
  final bool showBack;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimens.sheetRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimens.pagePadding, 24, Dimens.pagePadding, 0),
            child: Row(
              children: [
                if (showBack) ...[
                  GestureDetector(onTap: onBack, child: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 16),
                ],
                Expanded(child: Text(title, style: AppTextStyles.sheetTitle)),
              ],
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimens.pagePadding, 8, Dimens.pagePadding, 0),
              child: Text(subtitle!, style: AppTextStyles.body),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(Dimens.pagePadding, 20, Dimens.pagePadding, 16),
              child: child,
            ),
          ),
          if (bottom != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimens.pagePadding, 0, Dimens.pagePadding, 16),
              child: bottom,
            ),
        ],
      ),
    );
  }
}
