import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class DashBoardStatsWidget extends StatelessWidget {
  final BuildContext context;
  final String image;
  final String title;
  final String value;
  final double fontSize;

  const DashBoardStatsWidget(
      {super.key,
      required this.context,
      required this.image,
      required this.title,
      required this.value,
       this.fontSize = 10,

      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenHeight(context) <= 730 ? 115 : 90,
      decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          color: AppColors.iconBGColor),
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.padding_8,
          vertical: AppConstants.padding_8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(context.rtl ? pi : 0),
                  child: SvgPicture.asset(image)),
              5.width,
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                      size: fontSize, color: AppColors.mainColor),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          10.height,
          Text(
            value,
            maxLines: 2,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor),
          ),
        ],
      ),
    );
  }
}
