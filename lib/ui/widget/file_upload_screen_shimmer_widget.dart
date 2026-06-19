import 'package:flutter/material.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import 'common_shimmer_widget.dart';

class FileUploadScreenShimmerWidget extends StatelessWidget {
  const FileUploadScreenShimmerWidget({super.key});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 32),
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            separatorBuilder: (_, __) => 12.height,
            itemBuilder: (context, index) => buildFileOrForm(),
          ),
          24.height,
          buildButton(),
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

  Widget buildFileOrForm() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [buildTextFieldTitle(), buildDownloadButton()],
          ),
          12.height,
          CommonShimmerWidget(
            child: Container(
              height: 150,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.pageColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDownloadButton() {
    return CommonShimmerWidget(
      child: Container(
        height: 30,
        width: 90,
        decoration: BoxDecoration(
          color: AppColors.pageColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildTextFieldTitle() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.shimmerTextHeight,
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.pageColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget buildButton() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.buttonHeight,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.pageColor,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
