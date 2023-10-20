import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmerWidget extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerDirection direction;
  final Duration period;

  const CommonShimmerWidget({
    super.key,
    required this.child,
    this.baseColor = const Color(0xCCE0E0E0),
    this.highlightColor = const Color(0xffF5F5F5),
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 3000),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      period: period,
      enabled: true,
    );
  }
}
