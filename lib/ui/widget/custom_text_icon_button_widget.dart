import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/themes/app_colors.dart';

class CustomTextIconButtonWidget extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final String? svgImage;
  final int? cartCount;
  final double? titleSize;
  final double? width;

  const CustomTextIconButtonWidget({super.key,
    required this.title,
    required this.onPressed,
    this.svgImage,
    this.cartCount,
    this.titleSize,
    this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.buttonHeight,
      width: width,
      decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(AppConstants.padding_10)),
      clipBehavior: Clip.hardEdge,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        elevation: 0,
        color: AppColors.mainColor,
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                svgImage == null
                    ? 0.height
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(context.rtl ? pi : 0),
                        child: SvgPicture.asset(svgImage!,
                            height: 20,
                            width: 20,
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                AppColors.whiteColor, BlendMode.srcIn)),
                      ),
                7.width,
                Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                      size: titleSize ?? 18, color: AppColors.whiteColor),
                ),
              ],
            ),
            10.width,
            cartCount == null
                ? 0.height
                : cartCount == 0
                ? 0.width
                : Container(
              height: 16,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppConstants.radius_100)),
              ),
              child: Text(
                '${cartCount == 0 ? '' : cartCount}',
                style: AppStyles.rkRegularTextStyle(
                    fontWeight: FontWeight.w100,
                    size: AppConstants.padding_10, color: AppColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
