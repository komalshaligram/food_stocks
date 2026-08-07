import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';

Widget relatedProductTitle(BuildContext context) {
  return Align(
    alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: AppConstants.padding_8, right: AppConstants.padding_8, top: AppConstants.padding_10),
      child: Text(AppLocalizations.of(context)!.related_products,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.blackColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center),
    ),
  );
}
