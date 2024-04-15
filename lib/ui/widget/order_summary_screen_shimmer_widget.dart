import 'package:flutter/material.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class OrderSummaryScreenShimmerWidget extends StatelessWidget {
  final int itemCount;
   OrderSummaryScreenShimmerWidget({super.key , this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding:
      EdgeInsets.symmetric(vertical: AppConstants.padding_5),
      itemBuilder: (context, index) {
        return CommonShimmerWidget(
          child: Container(
            margin: EdgeInsets.all(AppConstants.padding_10),
            padding: EdgeInsets.symmetric(
                vertical: AppConstants.padding_10,
                horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.15),
                    blurRadius: AppConstants.blur_10),
              ],
              borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.radius_5)),

            ),
            child: Container(
              height: 55,
            ),
          ),
        );
      },
    );
  }
}
