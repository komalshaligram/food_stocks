import 'package:flutter/material.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final IconData iconData;
  final void Function()? onTap;
  final Widget? trailingWidget;
  final double? width;
  final double? height;
  final Color bgColor;

   const CommonAppBar({super.key, required this.title, required this.iconData, this.onTap, this.trailingWidget ,this.height,this.width,required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: bgColor,
      surfaceTintColor: AppColors.pageColor,
      leading: Container(
        padding: const EdgeInsets.all(AppConstants.padding_10),
        child: InkWell(
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_100)),
          onTap: onTap,
          child: Icon(
            iconData,
            size: 26,
            color: AppColors.blackColor,
          ),
        ),
      ),
      actions: [
        Container(
            height: height,
            width: width,
            child: trailingWidget ?? SizedBox()),
        Padding(padding: EdgeInsets.all(AppConstants.padding_10)),
      ],
      title: Text(
        title,
        style: AppStyles.rkRegularTextStyle(
            size: AppConstants.smallFont, color: AppColors.blackColor),
      ),
    );
  }
}
