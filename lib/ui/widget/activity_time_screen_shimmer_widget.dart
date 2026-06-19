import 'package:flutter/material.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import 'common_shimmer_widget.dart';

class ActivityTimeScreenShimmerWidget extends StatelessWidget {
  const ActivityTimeScreenShimmerWidget({super.key});

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
              children: [
                buildHeaderRow(),
                12.height,
                ListView.separated(
                  itemCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Divider(height: 1, color: AppColors.lightBorderColor.withValues(alpha: 0.6)),
                  ),
                  itemBuilder: (context, index) => buildDayWiseShiftTime(),
                ),
              ],
            ),
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

  Widget buildHeaderRow() {
    return Row(
      children: [
        const Expanded(flex: 3, child: SizedBox()),
        Expanded(
          flex: 3,
          child: CommonShimmerWidget(
            child: Container(
              height: AppConstants.shimmerTextHeight,
              decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: CommonShimmerWidget(
            child: Container(
              height: AppConstants.shimmerTextHeight,
              decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 52),
      ],
    );
  }

  Widget buildDayWiseShiftTime() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CommonShimmerWidget(
            child: Container(
              height: AppConstants.shimmerTextHeight,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: CommonShimmerWidget(
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: CommonShimmerWidget(
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CommonShimmerWidget(
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
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
