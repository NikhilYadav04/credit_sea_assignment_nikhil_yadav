import 'package:flutter/material.dart';

import '../../app/constants/dimens.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_logo.dart';
import 'keyboard_dismiss.dart';
import 'promo_carousel.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.children,
    this.onBack,
  });

  static const _sheetMaxHeightFactor = 0.7;
  static const _sheetMaxHeightFactorWithKeyboard = 0.95;

  final String title;
  final List<Widget> children;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final heightFactor =
        keyboardOpen ? _sheetMaxHeightFactorWithKeyboard : _sheetMaxHeightFactor;

    return KeyboardDismiss(
      child: Scaffold(
        backgroundColor: AppColors.heroBlue,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Expanded(
                  child: keyboardOpen
                      ? const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: AppLogo(size: 30),
                          ),
                        )
                      : const _Hero(),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: constraints.maxHeight * heightFactor),
                  child: _Sheet(title: title, onBack: onBack, children: children),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  static const _designWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: _designWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [AppLogo(), SizedBox(height: 28), PromoCarousel()],
          ),
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.title, required this.children, this.onBack});

  final String title;
  final List<Widget> children;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(Dimens.sheetRadius);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppColors.borderGradient,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 4),
          padding: EdgeInsets.fromLTRB(
            Dimens.pagePadding - 8,
            20,
            Dimens.pagePadding - 8,
            MediaQuery.paddingOf(context).bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (onBack != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: onBack,
                        child: const Icon(Icons.arrow_back, color: AppColors.textMuted),
                      ),
                    ),
                  Text(title, style: AppTextStyles.authTitle),
                ],
              ),
              const SizedBox(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
