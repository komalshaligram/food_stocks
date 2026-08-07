import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';
import 'common_shimmer_widget.dart';
import 'sized_box_widget.dart';

class MyClientsScreenShimmerWidget extends StatelessWidget {
  final int itemCount;
  const MyClientsScreenShimmerWidget({super.key, this.itemCount = 8});
  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 12),
        child: CommonShimmerWidget(
            child: Container(height: 48, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(12)))),
      ),
      Expanded(
        child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(_horizontalPadding, 0, _horizontalPadding, 16),
            itemCount: itemCount,
            separatorBuilder: (_, __) => 12.height,
            itemBuilder: (_, __) => _buildClientCardShimmer()),
      ),
    ]);
  }

  Widget _buildClientCardShimmer() {
    return Container(
      decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2)),
      ]),
      padding: const EdgeInsets.all(14),
      child: CommonShimmerWidget(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 44, width: 44, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(12))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 14, width: 140, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 8),
              Container(height: 12, width: 100, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 8),
              Container(height: 12, width: 160, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(8)))
            ]),
          ),
          const SizedBox(width: 8),
          Column(children: [
            Container(height: 34, width: 100, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 8),
            Container(height: 34, width: 100, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(10)))
          ]),
        ]),
      ),
    );
  }
}
