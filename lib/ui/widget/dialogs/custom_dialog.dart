import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_styles.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../utils/constants/app_strings.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final void Function()? positiveOnTap;
  final void Function()? negativeOnTap;
  final String? positiveTitle;
  final String? negativeTitle;
  final String directionality;
  final bool isProcessing;
  final List content;
  final bool isMixedSale;

  const CustomDialog(
      {super.key,
      required this.title,
      this.subTitle = '',
      this.positiveOnTap,
      this.negativeOnTap,
      this.positiveTitle,
      this.negativeTitle,
      required this.directionality,
      this.isProcessing = false,
      required this.content,
      required this.isMixedSale});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: directionality == AppStrings.englishString ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
          contentPadding: const EdgeInsets.all(AppConstants.padding_20),
          surfaceTintColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_20)),
          title: Text(title,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.w400)),
          content: content.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8),
                  child: SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if (isMixedSale == true)
                        Text(AppLocalizations.of(context)?.productParticipatingSale ?? '',
                            style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.blackColor)),
                      2.height,
                      Expanded(
                        child: ListView.builder(
                            itemCount: content.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_2),
                                child: Row(children: [
                                  Container(
                                      height: 5,
                                      width: 5,
                                      decoration:
                                          BoxDecoration(color: AppColors.blackColor, borderRadius: BorderRadius.circular(AppConstants.radius_50))),
                                  8.width,
                                  Expanded(
                                    child: Text(content[index],
                                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
                                  ),
                                ]),
                              );
                            }),
                      ),
                    ]),
                  ),
                ),
          actionsPadding: const EdgeInsets.only(right: AppConstants.padding_20, bottom: AppConstants.padding_10, left: AppConstants.padding_20),
          actions: [
            positiveTitle != null
                ? InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: positiveOnTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radius_7)),
                      width: 80,
                      child: isProcessing
                          ? CupertinoActivityIndicator(color: AppColors.mainColor)
                          : Text(positiveTitle ?? '',
                              style: AppStyles.rkRegularTextStyle(color: AppColors.mainColor.withValues(alpha: 0.9), size: AppConstants.smallFont)),
                    ),
                  )
                : Container(),
            negativeTitle != null
                ? InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: negativeOnTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_10),
                      alignment: Alignment.center,
                      width: 80,
                      decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_7)),
                      child:
                          Text(negativeTitle ?? '', style: AppStyles.rkRegularTextStyle(color: AppColors.whiteColor, size: AppConstants.smallFont)),
                    ),
                  )
                : Container()
          ]),
    );
  }
}
