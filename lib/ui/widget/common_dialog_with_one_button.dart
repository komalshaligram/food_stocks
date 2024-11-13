
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/themes/app_strings.dart';

class CustomOneButtonDialog extends StatelessWidget {
  final String title;
  final void Function()? positiveOnTap;
  final void Function()? positiveOnTap1;
  final void Function()? positiveOnTap2;
  final String? positiveTitle;
  final String? positiveTitle1;
  final String? positiveTitle2;
  final String directionality;
  final double width;
  final String subTitle;
  final bool isLoading;

  const CustomOneButtonDialog({
    super.key,
    required this.title,
    this.positiveOnTap,
    this.positiveOnTap1,
    this.positiveOnTap2,
    this.positiveTitle,
    this.positiveTitle1,
    this.positiveTitle2,
    required this.directionality,
    this.width = double.maxFinite,
    this.subTitle = '',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: directionality == AppStrings.englishString ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(20.0),
        surfaceTintColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title,
                style: AppStyles.rkRegularTextStyle(
                    color: subTitle.isNotEmpty?AppColors.redColor:AppColors.blackColor, size: AppConstants.smallFont,
                    fontWeight: FontWeight.w600
                )),
            subTitle.isEmpty?0.height: Text(subTitle,
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14,
                  color: AppColors.blackColor,))
          ],
        ),
        actionsPadding: const EdgeInsets.only(
            right: AppConstants.padding_20,
            bottom: AppConstants.padding_10,
            left: AppConstants.padding_20),
        actions: [
           Column(
             children: [
               positiveTitle != null
                   ? commonButton(positiveTitle:positiveTitle ?? '' ,width: width,positiveOnTap: positiveOnTap)
                   : 0.width,
               10.height,
               positiveTitle1 != null
                   ? commonButton(positiveTitle:positiveTitle1 ?? '' ,width: width,positiveOnTap: positiveOnTap1)
                   : 0.width,
               10.height,
               positiveTitle2 != null
                   ? commonButton(positiveTitle:positiveTitle2 ?? '' ,width: width,positiveOnTap: positiveOnTap2)
                   : 0.width,
               10.height,
             ],
           ),
        ],
      ),
    );
  }

}
commonButton({
  Function()? positiveOnTap , required double width,required String positiveTitle
  }) {
  return Align(
    alignment: Alignment.center,
    child: InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: positiveOnTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
            gradient: AppColors.appMainGradientColor,
            borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          positiveTitle,
          style: AppStyles.rkRegularTextStyle(
              color: AppColors.whiteColor,
              size: AppConstants.smallFont),
        ),
      ),
    ),
  );
}