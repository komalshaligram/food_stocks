import 'package:flutter/material.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class ProductDetailsScreenShimmerWidget extends StatelessWidget {
  const ProductDetailsScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonShimmerWidget(
          child: Container(
            height: 180,
            width: double.maxFinite,
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
        ),
        CommonShimmerWidget(
          child: Container(
            height: 25,
            width: 100,
          ),
        ),

        ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return CommonShimmerWidget(
              child: Container(
                margin: EdgeInsets.all(AppConstants.padding_10),
                padding: EdgeInsets.symmetric(
                    vertical: AppConstants.padding_15,
                    horizontal: AppConstants.padding_10),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadowColor.withOpacity(0.15),
                        blurRadius: AppConstants.blur_10),
                  ],
                  borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                ),
                child: Container(
                  height: 40,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
