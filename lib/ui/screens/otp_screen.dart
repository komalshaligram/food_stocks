import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../widget/common_app_bar.dart';

class OTPRoute {
  static Widget get route => OTPScreen();
}

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OTPScreenWidget();
  }
}

class OTPScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: CommonAppBar(
          title: AppLocalizations.of(context)!.connection,
          iconData: Icons.arrow_back_ios_sharp,
          onTap: () {
            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: getScreenWidth(context) * 0.1,
              right: getScreenWidth(context) * 0.1),
          child: Column(
            children: [
              Text(
                  AppLocalizations.of(context)!
                      .enter_the_code_sent_to_phone_num,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: Colors.black)),
              50.height,
              OtpTextField(
                autoFocus: true,
                decoration: InputDecoration(
                //  border: Border.all(color: )
                ),

                numberOfFields: 4,
                cursorColor: AppColors.mainColor,
                borderColor: AppColors.greyColor,
                focusedBorderColor: AppColors.mainColor,
                margin: EdgeInsets.all(8),
                showCursor: false,
                showFieldAsBox: false,
                borderRadius: BorderRadius.circular(8),
                textStyle: TextStyle(fontSize: 20),
                onCodeChanged: (String code) {
                  print(code);
                },
                onSubmit: (String verificationCode) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      });
                }, // end onSubmit
              ),
              40.height,
              CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!.continued,
                bGColor: AppColors.mainColor,
                onPressed: () {
                  Navigator.pushNamed(context, RouteDefine.profileScreen3.name);
                },
                fontColors: AppColors.whiteColor,
              ),
              20.height,
              Text(AppLocalizations.of(context)!.not_receive_verification_code,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: Colors.black)),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
