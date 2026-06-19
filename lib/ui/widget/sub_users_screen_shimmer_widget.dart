import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';
import 'common_shimmer_widget.dart';
import 'sized_box_widget.dart';

class SubUsersScreenShimmerWidget extends StatelessWidget {
  final int itemCount;

  const SubUsersScreenShimmerWidget({super.key, this.itemCount = 8});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 12.height,
      itemBuilder: (context, index) => _buildUserCardShimmer(),
    );
  }

  Widget _buildUserCardShimmer() {
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
      padding: const EdgeInsets.all(14),
      child: CommonShimmerWidget(
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.pageColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.pageColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.pageColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: AppColors.pageColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
