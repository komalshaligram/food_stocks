import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final void Function()? positiveOnTap;
  final void Function()? negativeOnTap;
  final String? positiveTitle;
  final String? negativeTitle;

  CommonAlertDialog({
    super.key,
    required this.title,
     this.subTitle = '',
    this.positiveOnTap,
    this.negativeOnTap,
    this.positiveTitle,
    this.negativeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20.0),
      surfaceTintColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(title,
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.mediumFont,
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold)),
      content: Text(
        subTitle,
        style: AppStyles.rkRegularTextStyle(
            color: AppColors.blackColor, size: AppConstants.font_14),
      ),
      actionsPadding: EdgeInsets.only(
          right: AppConstants.padding_20,
          bottom: AppConstants.padding_20,
          left: AppConstants.padding_20),
      actions: [
        positiveTitle != null
            ? InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: positiveOnTap,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                  width: 80,
                  child: Text(
                    positiveTitle ?? '',
                    style: AppStyles.rkRegularTextStyle(
                        color: AppColors.mainColor.withOpacity(0.9),
                        size: AppConstants.smallFont),
                  ),
                ),
              )
            : Container(),
        negativeTitle != null
            ? InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: negativeOnTap,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  alignment: Alignment.center,
                  width: 80,
                  decoration: BoxDecoration(
                      color: AppColors.mainColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    negativeTitle ?? '',
                    style: AppStyles.rkRegularTextStyle(
                        color: AppColors.whiteColor,
                        size: AppConstants.smallFont),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
