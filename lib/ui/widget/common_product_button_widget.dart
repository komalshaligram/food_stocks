import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class CommonProductButtonWidget extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final Color bgColor;
  final Color textColor;
  final double textSize;
  final double? height;
  final double? width;
  final double horizontalPadding;
  final double verticalPadding;
  final double? borderRadius;
  final bool isLoading;
  final Color borderColor;

  CommonProductButtonWidget(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isLoading = false,
      this.horizontalPadding = 0.0,
      this.verticalPadding = 0.0,
      this.textSize = AppConstants.smallFont,
      this.bgColor = Colors.black,
      this.textColor = Colors.white,
      this.height,
      this.width,
      this.borderRadius,
      this.borderColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppConstants.buttonHeightSmall,
      width: width,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? AppConstants.radius_10))),
      child: MaterialButton(
        elevation: 0,
        minWidth: width,
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? CupertinoActivityIndicator()
            : Text(
                title,
                style: AppStyles.rkRegularTextStyle(
                    size: textSize,
                    color: textColor,
                    fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
