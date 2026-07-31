import 'package:flutter/material.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import '../../widget/sized_box_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

void bankTransferDialog({required BuildContext context, required String language, required String text, required Function function}) {
  showDialog(
      context: context,
      builder: (context1) {
        return Directionality(
          textDirection: language == AppStrings.englishString ? TextDirection.ltr : TextDirection.rtl,
          child: AlertDialog(
              contentPadding: const EdgeInsets.all(AppConstants.padding_20),
              surfaceTintColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_20)),
              title: Text(text, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont)),
              actionsPadding: const EdgeInsets.only(right: AppConstants.padding_20, bottom: AppConstants.padding_10, left: AppConstants.padding_20),
              actions: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context1);
                    function();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_7)),
                    child: Text(AppLocalizations.of(context)!.understand_submit_order,
                        style: AppStyles.rkRegularTextStyle(color: AppColors.whiteColor, size: AppConstants.smallFont)),
                  ),
                ),
                8.height,
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context1);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: AppColors.connectGradientColor,
                        border: Border.all(color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(AppConstants.radius_7)),
                    child: Text(AppLocalizations.of(context)!.closeText,
                        style: AppStyles.rkRegularTextStyle(color: AppColors.mainColor, size: AppConstants.smallFont)),
                  ),
                ),
              ]),
        );
      });
}
