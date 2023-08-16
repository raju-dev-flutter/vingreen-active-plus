import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/theme/app_assets.dart';
import '../../config/theme/app_colors.dart';

showCirclerLoading(context, double? width) {
  return Container(
    alignment: Alignment.center,
    child: Lottie.asset(LottieFile.circlerLoader, width: width ?? 60),
  );
}

showDropdownLoaded() {
  return const ShimmerSkelton(height: 62);
}

class ShimmerSkelton extends StatelessWidget {
  const ShimmerSkelton(
      {super.key,
      this.width,
      this.height,
      this.color,
      this.radius,
      this.child});

  final double? width;
  final double? height;
  final double? radius;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? AppColor.bgColor,
          border: Border.all(width: 1, color: AppColor.secondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 8)),
        ),
        child: child,
      ),
    );
  }
}
