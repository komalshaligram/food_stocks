import 'package:flutter/material.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_styles.dart';

class CommonSaleDescriptionDialog extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final String buttonTitle;

  const CommonSaleDescriptionDialog({
    super.key,
    required this.title,
    required this.onTap,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(AppConstants.padding_15),
      surfaceTintColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_10)),
      title: Text(
        title,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor),
      ),
      actionsPadding: const EdgeInsets.only(right: AppConstants.padding_15, bottom: AppConstants.padding_15, left: AppConstants.padding_15),
      actions: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_10),
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radius_7)),
            width: 80,
            child: Text(
              buttonTitle,
              style: AppStyles.rkRegularTextStyle(color: AppColors.mainColor.withOpacity(0.9), size: AppConstants.smallFont),
            ),
          ),
        )
      ],
    );
  }
}
