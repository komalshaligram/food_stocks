import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';

class CommonPaginationEndWidget extends StatelessWidget {
  final String pageEndText;

  const CommonPaginationEndWidget({super.key, required this.pageEndText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.maxFinite,
      padding: const EdgeInsets.only(top: AppConstants.padding_15),
      child: Text(pageEndText,
          textAlign: TextAlign.center, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor)),
    );
  }
}
