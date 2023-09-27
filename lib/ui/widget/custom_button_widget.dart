import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  final bool enable;
  final Color bGColor;
  final Color fontColors;
  final double? height;
  final double? radius;
  CustomButtonWidget(
      {super.key,
      required this.buttonText,
      this.onPressed,
      this.enable = true,
      this.bGColor = Colors.white,
      this.fontColors = Colors.white, this.height, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppConstants.buttonHeight,
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          // border: Border.all(color: AppColors.mainColor),
          color: bGColor,
          borderRadius:
              BorderRadius.all(Radius.circular(radius ?? AppConstants.radius_10))),
      child: MaterialButton(
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