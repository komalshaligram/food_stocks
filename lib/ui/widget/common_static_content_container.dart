import 'package:flutter/material.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class CommonStaticContentContainer extends StatelessWidget {
  final String content;
  const CommonStaticContentContainer({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: AppConstants.padding_10,
          right: AppConstants.padding_10,
          top: AppConstants.padding_15),
      padding: EdgeInsets.symmetric(
          vertical: AppConstants.padding_15,
          horizontal: AppConstants.padding_30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(AppConstants.radius_5)),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10)
          ]),
      child: Text(
        content,
        style: AppStyles.rkRegularTextStyle(
            size: AppConstants.font_12,
            color: AppColors.blackColor),
      ),
    );
  }
}
