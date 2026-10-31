import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/theme/app_colors.dart';

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 48, this.radius = 8});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeleton,
      highlightColor: const Color(0xFFEDEDED),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.skeleton,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
