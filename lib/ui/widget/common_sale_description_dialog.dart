import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class CommonSaleDescriptionDialog extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final String buttonTitle;

  CommonSaleDescriptionDialog({
    super.key,
    required this.title,
    required this.onTap,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(AppConstants.padding_15),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius_10)),
      title: Text(
        title,
        style: AppStyles.rkRegularTextStyle(
            size: AppConstants.font_14, color: AppColors.blackColor),
      ),
      actionsPadding: EdgeInsets.only(
          right: AppConstants.padding_15,
          bottom: AppConstants.padding_15,
          left: AppConstants.padding_15),
      actions: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
            width: 80,
            child: Text(
              buttonTitle,
              style: AppStyles.rkRegularTextStyle(
                  color: AppColors.mainColor.withOpacity(0.9),
                  size: AppConstants.smallFont),
            ),
          ),
        )
      ],
    );
  }
}
