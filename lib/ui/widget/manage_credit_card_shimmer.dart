import 'package:flutter/material.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import 'common_shimmer_widget.dart';

class ManageCreditCardShimmer extends StatelessWidget {
  const ManageCreditCardShimmer({super.key});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        CommonShimmerWidget(
            child: Container(height: 180, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(20)))),
        20.height,
        _buildCardShimmer(),
        24.height,
        CommonShimmerWidget(
          child: Container(
              height: AppConstants.buttonHeight, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(14))),
        ),
        12.height,
        CommonShimmerWidget(
          child: Container(
              height: AppConstants.buttonHeight, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(14))),
        ),
      ]),
    );
  }

  Widget _buildCardShimmer() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
      padding: const EdgeInsets.all(16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildTextFieldTitle(), buildTextField(), 14.height, buildTextFieldTitle(), buildTextField()]),
    );
  }

  Widget buildTextField() {
    return CommonShimmerWidget(
      child: Container(
          height: AppConstants.textFormFieldHeight,
          width: double.maxFinite,
          decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(12))),
    );
  }

  Widget buildTextFieldTitle() {
    return CommonShimmerWidget(
      child: Container(
          height: AppConstants.shimmerTextHeight,
          width: 120,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(8))),
    );
  }
}
