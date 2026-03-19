import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';

Padding buildListTitles({required BuildContext context, required String title, required void Function() onTap, required subTitle}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.padding_10,
        right: AppConstants.padding_10,
        top: AppConstants.padding_10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              subTitle,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.mainColor),
            ),
          ),
        ],
      ),
    );

}