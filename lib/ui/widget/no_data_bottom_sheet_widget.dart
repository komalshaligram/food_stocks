
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class NoDataBottomSheet extends StatelessWidget {
  const NoDataBottomSheet({super.key,required this.dialogContext});
 final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: dialogContext.rtl ? Alignment.topLeft : Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(dialogContext);
              },
              child: Icon(
                Icons.close,
                size: 36,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(
            height: getScreenHeight(context) * 0.7,
            child: Center(
              child: Text(
                  AppLocalizations.of(context)!.no_product,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.normalFont,
                    color: AppColors.redColor,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
