import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/custom_button_widget.dart';

class PrivacyPolicyRoute {
  static Widget get route =>  PrivacyPolicyScreen();
}


class PrivacyPolicyScreen extends StatelessWidget {
   PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyPolicyWidget();
  }
}

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        surfaceTintColor: AppColors.whiteColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                  context, RouteDefine.activityTimeScreen.name);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: Align(
          alignment:
          context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)!.privacy_policy,
            style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        titleSpacing: 0,
        elevation: 0,
      ),
      bottomSheet: Container(
        color: AppColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 30),
          child: CustomButtonWidget(
            buttonText: AppLocalizations.of(context)!
                .next
                .toUpperCase(),
            bGColor: AppColors.mainColor,
            onPressed:  () {

                Navigator.pushNamed(context, RouteDefine.fileUploadScreen.name);

            },
            fontColors: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
