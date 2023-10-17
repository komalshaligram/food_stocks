

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class CircularButtonWidget extends StatelessWidget {
  bool isBoxShadow;
   CircularButtonWidget({super.key, this.isBoxShadow = false,


  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.padding_80,vertical: AppConstants.padding_50),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withOpacity(0.95),
         boxShadow: [
           isBoxShadow? BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.20),
              blurRadius: AppConstants.blur_10
          ) : BoxShadow(),
        ],
        borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.radius_40)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: AppConstants.padding_5,
            horizontal: AppConstants.padding_5
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radius_40),
          color: AppColors.whiteColor,
        ),
        child: Container(
          padding: EdgeInsets.all(AppConstants.padding_10),
          height:AppConstants.containerHeight_60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.navSelectedColor,
              borderRadius: BorderRadius.circular(AppConstants.radius_40)
          ),
          child: Text(AppLocalizations.of(context)!.back_to_home_page,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.normalFont,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
