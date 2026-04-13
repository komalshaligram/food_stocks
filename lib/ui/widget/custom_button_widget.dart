import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  final bool enable;
  final Color bGColor;
  final Color? loadingColor;
  final Color fontColors;
  final double? height;
  final double? radius;
  final bool isLoading;
  final Color borderColor;
  final bool isFromConnectScreen;
  final double width;
  final double fontSize;
  final bool isDeleteButton;
  final Widget? iconWidget;

  const CustomButtonWidget({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.enable = true,
    this.isLoading = false,
    this.bGColor = Colors.white,
    this.fontColors = Colors.white,
    this.isFromConnectScreen = false,
    this.height,
    this.radius,
    this.borderColor = Colors.white,
    this.loadingColor = Colors.white,
    this.width = double.maxFinite,
    this.fontSize = 18,
    this.isDeleteButton = false,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppConstants.buttonHeight,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          gradient: isDeleteButton && !enable
              ? AppColors.disableGradientColor
              : isDeleteButton && enable
                  ? AppColors.redGradientColor
                  : isFromConnectScreen
                      ? AppColors.connectGradientColor
                      : !enable
                          ? AppColors.disableGradientColor
                          : AppColors.appMainGradientColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(radius ?? AppConstants.radius_10))),
      child: MaterialButton(
        onPressed: enable ? onPressed : null,
        child: isLoading
            ? CupertinoActivityIndicator(color: loadingColor)
            : iconWidget != null
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    iconWidget!,
                    5.width,
                    Text(buttonText.toUpperCase(), style: AppStyles.rkRegularTextStyle(size: fontSize, color: fontColors)),
                  ])
                : Text(buttonText.toUpperCase(), style: AppStyles.rkRegularTextStyle(size: fontSize, color: fontColors)),
      ),
    );
  }
}
