import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  final bool enable;
  final Color bGColor;
  final Color fontColors;
  CustomButtonWidget(
      {super.key,
      required this.buttonText,
      this.onPressed,
      this.enable = true,
      this.bGColor = Colors.white,
      this.fontColors = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainColor),
          color: bGColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppConstants.padding_10))),
      child: MaterialButton(
        height: AppConstants.buttonHeight,
        onPressed: enable ? onPressed : null,
        child: Text(
          buttonText,
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.mediumFont, color: fontColors),
        ),
      ),
    );
  }
}