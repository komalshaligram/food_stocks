import 'package:flutter/material.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class BasketScreenShimmerWidget extends StatelessWidget {
  const BasketScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return CommonShimmerWidget(
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_5,
                  horizontal: AppConstants.padding_10),
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_3,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: AppConstants.containerSize_50,
                    height: AppConstants.containerSize_50,
                    color: AppColors.whiteColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
