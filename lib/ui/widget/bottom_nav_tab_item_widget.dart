import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import 'confetti.dart';

class BottomNavTabItem extends StatelessWidget {
  const BottomNavTabItem(
      {super.key,
      required this.imagePath,
      required this.isSelected,
      required this.isRtl,
      this.isCart = false,
      this.cartCount = 0,
      this.showCartBadge = false,
      this.showCartAnimation = false,
      this.showCelebration = false});

  final String imagePath;
  final bool isSelected;
  final bool isRtl;
  final bool isCart;
  final int cartCount;
  final bool showCartBadge;
  final bool showCartAnimation;
  final bool showCelebration;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 50,
        width: 50,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            gradient: isSelected ? AppColors.appMainGradientColor : LinearGradient(colors: [AppColors.whiteColor, AppColors.whiteColor]),
            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100))),
        child: Center(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isRtl ? pi : 0),
            child: SvgPicture.asset(imagePath,
                height: 26,
                width: 26,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(isSelected ? AppColors.whiteColor : AppColors.navSelectedColor, BlendMode.srcIn)),
          ),
        ),
      ),
      if (isCart && showCartBadge && cartCount > 0)
        Positioned(
          top: 5,
          right: isRtl ? null : 0,
          left: isRtl ? 0 : null,
          child: Container(
            height: 18,
            width: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: isSelected ? LinearGradient(colors: [AppColors.whiteColor, AppColors.whiteColor]) : AppColors.appMainGradientColor,
                borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                border: Border.all(color: isSelected ? AppColors.mainColor : AppColors.whiteColor, width: 1)),
            child: Text('$cartCount',
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: isSelected ? AppColors.mainColor : AppColors.whiteColor)),
          ),
        ),
      if (isCart && showCartAnimation && !isSelected)
        Positioned(
          right: isRtl ? null : 0,
          left: isRtl ? 0 : null,
          child: SizedBox(
            height: 50,
            width: 25,
            child: Visibility(
                visible: showCelebration,
                child: IgnorePointer(child: Confetti(isStopped: !showCelebration, snippingCount: 10, snipSize: 3.0, colors: [AppColors.mainColor]))),
          ),
        ),
    ]);
  }
}
