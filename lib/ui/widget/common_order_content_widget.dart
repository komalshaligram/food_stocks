import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/themes/app_styles.dart';

class CommonOrderContentWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color titleColor;
  final Color valueColor;
  final int? flexValue;
  final double valueTextSize;
  final FontWeight valueTextWeight;
  final double columnPadding;

  const CommonOrderContentWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.titleColor,
      required this.valueColor,
      this.flexValue,
      this.valueTextSize = 14,
        this.valueTextWeight = FontWeight.bold,
       this.columnPadding = 5,
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flexValue ?? 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.iconBGColor,
            borderRadius: BorderRadius.all(
              Radius.circular(AppConstants.radius_5),
            ),
            border: Border.all(color: AppColors.lightBorderColor, width: 1),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.padding_10,
              vertical: columnPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_10,
                    color: titleColor,
                    fontWeight: FontWeight.normal),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              5.height,
              Text(
                value,
                style: AppStyles.rkRegularTextStyle(
                    size: valueTextSize,
                    color: valueColor,
                    fontWeight: valueTextWeight),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ));
  }
}
