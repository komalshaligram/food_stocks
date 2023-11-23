import 'package:flutter/material.dart';

import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class WalletScreenShimmerWidget extends StatelessWidget {
  const WalletScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  CommonShimmerWidget(
          child: Container(
            height: getScreenHeight(context) * 0.21,
            width: double.maxFinite,
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

          ),
        );

  }
}
