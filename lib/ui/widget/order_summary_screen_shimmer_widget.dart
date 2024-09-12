import 'package:flutter/material.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class OrderSummaryScreenShimmerWidget extends StatelessWidget {
  final int itemCount;
  final double containerHeight;
   const OrderSummaryScreenShimmerWidget({super.key , this.itemCount = 5 , this.containerHeight  = 55});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding:
      const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
      itemBuilder: (context, index) {
        return CommonShimmerWidget(
          child: Container(
            margin: const EdgeInsets.all(AppConstants.padding_10),
            padding: const EdgeInsets.symmetric(
                vertical: AppConstants.padding_10,
                horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.15),
                    blurRadius: AppConstants.blur_10),
              ],
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppConstants.radius_5)),

            ),
            child: Container(
              height: containerHeight,
            ),
          ),
        );
      },
    );
  }
}
