
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

import '../utils/themes/app_strings.dart';

class CustomOneButtonDialog extends StatelessWidget {
  final String title;
  final void Function()? positiveOnTap;
  final String? positiveTitle;
  final String directionality;
  final bool isProcessing;
  final double width;
  final String Subtitle;

  CustomOneButtonDialog({
    super.key,
    required this.title,
    this.positiveOnTap,
    this.positiveTitle,
    required this.directionality,
    this.isProcessing = false,
    this.width = 80,
    this.Subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: directionality == AppStrings.englishString ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
        contentPadding: EdgeInsets.all(20.0),
        surfaceTintColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: RichText(
          text:  TextSpan(
            text: Subtitle == '' ? '': '${Subtitle}' ':',
            style: AppStyles.rkRegularTextStyle(
              size: AppConstants.font_14,
              color: AppColors.blackColor,),
            children: <TextSpan>[
              TextSpan(
                text:
                '${title}',
                style: AppStyles.rkRegularTextStyle(
                    color: AppColors.blackColor, size: AppConstants.smallFont,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
        ),

        actionsPadding: EdgeInsets.only(
            right: AppConstants.padding_20,
            bottom: AppConstants.padding_10,
            left: AppConstants.padding_20),
        actions: [
          positiveTitle != null
              ? Align(
            alignment: Alignment.center,
                child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: positiveOnTap,
                            child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                alignment: Alignment.center,
                width: width,
                decoration: BoxDecoration(
                    gradient: AppColors.appMainGradientColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  positiveTitle ?? '',
                  style: AppStyles.rkRegularTextStyle(
                      color: AppColors.whiteColor,
                      size: AppConstants.smallFont),
                ),
                            ),
                          ),
              )
              : Container(),

        ],
      ),
    );
  }
}