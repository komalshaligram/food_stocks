import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class DashBoardStatsWidget extends StatelessWidget {
  final BuildContext context;
  final String image;
  final String title;
  final String value;

  const DashBoardStatsWidget({super.key,required this.context,
    required this.image,
    required this.title,
    required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius:
          const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          color: AppColors.iconBGColor),
      padding:  EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_10),
      child: Row(
        children: [
          SvgPicture.asset(image),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_10, color: AppColors.mainColor),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  value,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}