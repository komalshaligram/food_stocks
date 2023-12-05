import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class FileSelectionOptionWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool lastItem;
  final void Function() onTap;

  const FileSelectionOptionWidget(
      {super.key,
      required this.title,
      required this.icon,
      this.lastItem = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
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
                      size: AppConstants.mediumFont,
                      color: AppColors.blackColor),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(context.rtl ? pi : 0),
                  child: Icon(
                    icon,
                    color: AppColors.blueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        lastItem
            ? 0.width
            : Container(
                height: 1,
                width: getScreenWidth(context),
                color: AppColors.borderColor.withOpacity(0.5),
              ),
      ],
    );
  }
}
