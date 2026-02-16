import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';

class DividerWidget extends StatelessWidget {
  final double height;
  const DividerWidget({
    super.key,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: AppColors.borderColor,
    );
  }
}
