import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class NoInternetDialog extends StatelessWidget {
  final void Function()? positiveOnTap;
  NoInternetDialog({
    super.key,
    this.positiveOnTap
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.pageColor,
      contentPadding: EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Icon(Icons.wifi_off,size: 40,color: AppColors.mainColor,),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          AppStrings.noInternetConnection,
          textAlign: TextAlign.center,
          style: AppStyles.rkRegularTextStyle(
              color: AppColors.blackColor, size: AppConstants.smallFont,fontWeight: FontWeight.w500),
        ),
      ),
      actionsPadding: EdgeInsets.only(
          right: AppConstants.padding_20,
          bottom: AppConstants.padding_20,
          left: AppConstants.padding_20),
      actions: [
       InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: positiveOnTap,
          child: Center(
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              alignment: Alignment.center,
              width: AppConstants.containerHeight_80,
              decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                'OK',
                style: AppStyles.rkRegularTextStyle(
                    color: AppColors.whiteColor,
                    size: AppConstants.smallFont),
              ),
            ),
          ),
        )

      ],
    );
  }
}
