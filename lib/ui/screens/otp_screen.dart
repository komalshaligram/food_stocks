import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:food_stock/bloc/otp/otp_bloc.dart';
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
    return BlocProvider(
      create: (context) => OtpBloc()..add(OtpEvent.setOtpTimer()),
      child: OTPScreenWidget(),
    );
  }
}

class OTPScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OtpBloc bloc = context.read<OtpBloc>();
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {},
      child: BlocBuilder<OtpBloc, OtpState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: AppLocalizations.of(context)!.connection,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  bloc.add(OtpEvent.cancelOtpTimerSubscription());
                  Navigator.pushNamed(context, RouteDefine.loginScreen.name);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: getScreenWidth(context) * 0.1,
                    right: getScreenWidth(context) * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.height,
                    Text(
                        AppLocalizations.of(context)!
                            .enter_the_code_sent_to_phone_num,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont, color: Colors.black)),
                    30.height,
                    OtpTextField(
                      autoFocus: true,
                      fieldWidth: (getScreenWidth(context) -
                              (getScreenWidth(context) * 0.2)) /
                          5.5,
                      decoration: InputDecoration(
                          //  border: Border.all(color: )
                          ),
                      numberOfFields: 4,
                      cursorColor: AppColors.mainColor,
                      borderColor: AppColors.greyColor,
                      focusedBorderColor: AppColors.mainColor,
                      showCursor: false,
                      showFieldAsBox: true,
                      borderRadius: BorderRadius.circular(8),
                      margin: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_10),
                      textStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      onCodeChanged: (String code) {
                        print(code);
                      },
                      onSubmit: (String verificationCode) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Verification Code"),
                                content:
                                    Text('Code entered is $verificationCode'),
                              );
                            });
                      }, // end onSubmit
                    ),
                    30.height,
                    CustomButtonWidget(
                      buttonText: AppLocalizations.of(context)!.continued,
                      bGColor: AppColors.mainColor,
                      onPressed: () {
                        bloc.add(OtpEvent.cancelOtpTimerSubscription());
                        Navigator.pushNamed(
                            context, RouteDefine.homeScreen.name);
                      },
                      fontColors: AppColors.whiteColor,
                    ),
                    20.height,
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .not_receive_verification_code,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont, color: Colors.black),
                      ),
                    ),
                    20.height,
                    Container(
                      width: double.maxFinite,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border:
                            Border.all(color: AppColors.mainColor, width: 1),
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_10)),
                      ),
                      child: MaterialButton(
                        elevation: 0,
                        height: AppConstants.buttonHeight,
                        onPressed: () {
                          bloc.add(OtpEvent.setOtpTimer());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: AppColors.mainColor, width: 1),
                                  shape: BoxShape.circle),
                              padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.padding_5,
                                  horizontal: AppConstants.padding_5),
                              child: Text(
                                '${state.otpTimer}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.mainColor),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.send_again,
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.mediumFont,
                                  color: AppColors.mainColor),
                            ),
                            40.width,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
