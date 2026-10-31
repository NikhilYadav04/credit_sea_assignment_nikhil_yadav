import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';

class _Slide {
  const _Slide({required this.icons, required this.title, required this.subtitle});

  final List<IconData> icons;
  final String title;
  final String subtitle;
}

const _slides = [
  _Slide(
    icons: [
      Icons.directions_car_filled_outlined,
      Icons.two_wheeler,
      Icons.laptop_mac,
      Icons.smartphone,
    ],
    title: 'Flexible Loan Options',
    subtitle: 'Loan types to cater to different financial needs',
  ),
  _Slide(
    icons: [Icons.request_quote_outlined],
    title: 'Instant Loan Approval',
    subtitle: 'Users will receive approval within minutes',
  ),
  _Slide(
    icons: [Icons.headset_mic_outlined],
    title: '24x7 Customer Care',
    subtitle: 'Dedicated customer support team',
  ),
];

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final _pages = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final next = (_index + 1) % _slides.length;
      _pages.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pages,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
          ),
        ),
        const SizedBox(height: 12),
        _Dots(count: _slides.length, active: _index),
      ],
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final grid = slide.icons.length > 1;
    return Column(
      children: [
        if (grid)
          SizedBox(
            width: 190,
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [for (final icon in slide.icons) _IconTile(icon: icon, size: 80)],
            ),
          )
        else
          _IconTile(icon: slide.icons.first, size: 184, iconSize: 64),
        const SizedBox(height: 16),
        Text(
          slide.title,
          style: AppTextStyles.bodyStrong.copyWith(color: Colors.white, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Text(
          slide.subtitle,
          style: AppTextStyles.caption.copyWith(color: Colors.white54),
        ),
      ],
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, required this.size, this.iconSize = 40});

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 26 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == active ? Colors.white : Colors.white38,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
