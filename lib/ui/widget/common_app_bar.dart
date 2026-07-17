import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final IconData iconData;
  final void Function()? onTap;
  final Widget? trailingWidget;
  final double? width;
  final double? height;
  final Color bgColor;

  /// ווידג'ט אופציונלי שמוצג **ליד** חץ החזרה (באותו צד). null = רק החץ.
  final Widget? leadingExtra;

  const CommonAppBar({super.key, required this.title, required this.iconData, this.onTap, this.trailingWidget, this.height, this.width, required this.bgColor, this.leadingExtra});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: bgColor,
      surfaceTintColor: AppColors.pageColor,
      leadingWidth: leadingExtra == null ? null : 96,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.padding_10),
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
              onTap: onTap,
              child: Icon(iconData, size: 26, color: AppColors.blackColor),
            ),
          ),
          if (leadingExtra != null) leadingExtra!,
        ],
      ),
      actions: [
        SizedBox(height: height, width: width, child: trailingWidget ?? const SizedBox()),
        const Padding(padding: EdgeInsets.all(AppConstants.padding_10)),
      ],
      title: Text(title, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
    );
  }
}