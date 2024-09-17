import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final double titleTextSize;
  final FontWeight valueTextWeight;
  final double columnPadding;
  final Color borderCoder;
  final Color backGroundColor;
  final int maxLine;
  final int titleMaxLine;


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
      required  this.backGroundColor,
      required  this.borderCoder,
         this.maxLine = 1,
        this.titleMaxLine = 1,
        this.titleTextSize = 10
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flexValue ?? 1,
        child: Container(
          decoration: BoxDecoration(
            color: backGroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppConstants.radius_5),
            ),
            border: Border.all(color:borderCoder, width: 1),
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
                    size: titleTextSize,
                    color: titleColor,
                    fontWeight: FontWeight.normal),
                maxLines: titleMaxLine,
                overflow: TextOverflow.ellipsis,
              ),
              5.height,
              Text(
                value,
                style: AppStyles.rkRegularTextStyle(
                    size: valueTextSize,
                    color: valueColor,
                    fontWeight: valueTextWeight),
                maxLines: maxLine,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ));
  }
}
