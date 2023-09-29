import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_img_path.dart';
import '../widget/custom_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectRoute {
  static Widget get route => const ConnectScreen();
}

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
 final screenHeight = MediaQuery.of(context).size.height;
 final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 38,right: 38),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.15,
                ),
                SvgPicture.asset(
                  AppImagePath.splashLogo,
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.47,
                ),
                SizedBox(
                  height: screenHeight * 0.07,
                ),
                CustomButtonWidget(
                  buttonText: AppLocalizations.of(context)!.enrollment,
                 bGColor: AppColors.mainColor,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteDefine.loginScreen.name,arguments: {"isRegister": true});
                    },
                ),
                const SizedBox(
                  height: AppConstants.padding_20,
                ),
                CustomButtonWidget(
                  buttonText: AppLocalizations.of(context)!.connection,
                  fontColors: AppColors.mainColor,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteDefine.loginScreen.name , arguments: {"isRegister": false});
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}
