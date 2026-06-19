import 'package:flutter/material.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_constants.dart';

class ProfileScreenShimmerWidget extends StatelessWidget {
  final bool isProfileImage;

  const ProfileScreenShimmerWidget({super.key, this.isProfileImage = true});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextFieldTitle(width: 120),
                buildTextField(),
                14.height,
                buildTextFieldTitle(width: 100),
                buildTextField(),
                14.height,
                buildTextFieldTitle(width: 90),
                buildTextField(),
                14.height,
                buildTextFieldTitle(width: 110),
                buildTextField(),
                14.height,
                buildTextFieldTitle(width: 110),
                buildTextField(),
                14.height,
                buildTextFieldTitle(width: 80),
                buildTextField(),
                14.height,
                buildTextFieldTitle(width: 100),
                buildTextField(),
              ],
            ),
          ),
          24.height,
          buildTextField(height: AppConstants.buttonHeight),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget buildTextField({double? height}) {
    return CommonShimmerWidget(
      child: Container(
        height: height ?? AppConstants.textFormFieldHeight,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.pageColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget buildTextFieldTitle({double width = 140}) {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.shimmerTextHeight,
        width: width,
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: AppColors.pageColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
