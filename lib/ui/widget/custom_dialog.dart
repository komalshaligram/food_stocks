import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_styles.dart';

import '../utils/themes/app_strings.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final void Function()? positiveOnTap;
  final void Function()? negativeOnTap;
  final String? positiveTitle;
  final String? negativeTitle;
  final String directionality;
  final bool isProcessing;

  const CustomDialog({
    super.key,
    required this.title,
    this.subTitle = '',
    this.positiveOnTap,
    this.negativeOnTap,
    this.positiveTitle,
    this.negativeTitle,
    required this.directionality,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: directionality == AppStrings.englishString ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(20.0),
        surfaceTintColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(title,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.mediumFont,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600)),
        actionsPadding: const EdgeInsets.only(
            right: AppConstants.padding_20,
            bottom: AppConstants.padding_10,
            left: AppConstants.padding_20),
        actions: [
          positiveTitle != null
              ? InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: positiveOnTap,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              alignment: Alignment.center,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              width: 80,
              child: isProcessing ? CupertinoActivityIndicator(
                color: AppColors.mainColor,
              ) : Text(
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
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              alignment: Alignment.center,
              width: 80,
              decoration: BoxDecoration(
                  gradient: AppColors.appMainGradientColor,
                  // color: AppColors.mainColor.withOpacity(0.9),
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
      ),
    );
  }
}