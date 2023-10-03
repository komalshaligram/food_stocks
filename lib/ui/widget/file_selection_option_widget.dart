import 'package:flutter/material.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class FileSelectionOptionWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;

  const FileSelectionOptionWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppConstants.padding_15,
            horizontal: AppConstants.padding_10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.mediumFont, color: AppColors.blackColor),
            ),
            Icon(
              icon,
              color: AppColors.blueColor,
            ),
          ],
        ),
      ),
    );
  }
}
