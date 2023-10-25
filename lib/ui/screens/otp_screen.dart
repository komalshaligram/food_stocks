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
import '../utils/themes/app_strings.dart';
import '../widget/common_app_bar.dart';

class OTPRoute {
  static Widget get route => OTPScreen();
}

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final temp = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return BlocProvider(
      create: (context) => OtpBloc()..add(OtpEvent.setOtpTimer()),
      child: OTPScreenWidget(
        isRegister: temp[AppStrings.isRegisterString],
        contact: temp[AppStrings.contactString],
      ),
    );
  }
}

class OTPScreenWidget extends StatelessWidget {
  final bool isRegister;
  final String contact;

  OTPScreenWidget({required this.isRegister, required this.contact});

  // String otpCode = '';

  @override
  Widget build(BuildContext context) {
    OtpBloc bloc = context.read<OtpBloc>();
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) async {
        if (state.isLoginSuccess) {
          Navigator.popUntil(
              context, (route) => route.name == RouteDefine.connectScreen.name);
          Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name);
        }
        if (state.isLoginFail) {
          showSnackBar(
              context: context,
              title: state.errorMessage,
              bgColor: AppColors.redColor);
        }
      },
      child: BlocBuilder<OtpBloc, OtpState>(
        builder: (context, state) {
          print(getScreenWidth(context) * 0.097);
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: isRegister
                    ? AppLocalizations.of(context)!.register
                    : AppLocalizations.of(context)!.login,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  bloc.add(OtpEvent.cancelOtpTimerSubscription());
                  Navigator.pushNamed(context, RouteDefine.loginScreen.name);
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.padding_35,
                    ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.height,
                      Text(
                          AppLocalizations.of(context)!
                              .enter_the_code_sent_to_phone_num,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: Colors.black)),
                      30.height,
                      OtpTextField(
                        autoFocus: true,
                        fieldWidth: (getScreenWidth(context) -
                                (getScreenWidth(context) * 0.2)) /
                            5.55,
                        numberOfFields: 4,
                        borderWidth: 1,
                        disabledBorderColor: AppColors.borderColor,
                        enabledBorderColor: AppColors.borderColor,
                        fillColor: AppColors.whiteColor,
                        cursorColor: AppColors.mainColor,
                        borderColor: AppColors.greyColor,
                        focusedBorderColor: AppColors.mainColor,
                        showCursor: false,
                        keyboardType: TextInputType.number,
                        showFieldAsBox: true,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radius_5),
                        margin: EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_10),
                        textStyle: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        onCodeChanged: (String code) {
                          bloc.add(OtpEvent.updateOtpCodeEvent(
                              codeLength: code.length));
                        },
                        onSubmit: (verificationCode) {
                          // otpCode = verificationCode;
                          bloc.add(
                              OtpEvent.changeOtpEvent(otp: verificationCode));
                        }, // end onSubmit
                      ),
                      15.height,
                      CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.next,
                        bGColor: AppColors.mainColor,
                        isLoading: state.isLoading,
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (state.otp.length != 4 &&
                                    state.codeLength == 1) {
                                  showSnackBar(
                                      context: context,
                                      title: AppStrings.enter4DigitOtpCode,
                                      bgColor: AppColors.redColor);
                                } else if (state.otp.length == 4 &&
                                    state.codeLength != 0) {
                                  if (isRegister == true) {
                                    Navigator.pushNamed(
                                        context, RouteDefine.profileScreen.name,
                                        arguments: {
                                          AppStrings.contactString: contact
                                        });
                                  } else {
                                    bloc.add(OtpEvent.otpApiEvent(
                                        contact: contact,
                                        otp: state.otp,
                                        isRegister: isRegister,
                                        context: context));
                                  }
                                } else if (state.otp.length == 0) {
                                  showSnackBar(
                                      context: context,
                                      title: AppStrings.enterOtpString,
                                      bgColor: AppColors.redColor);
                                } else {
                                  showSnackBar(
                                      context: context,
                                      title: AppStrings.enter4DigitOtpCode,
                                      bgColor: AppColors.redColor);
                                }
                              },
                        fontColors: AppColors.whiteColor,
                      ),
                      20.height,
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .not_receive_verification_code,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: Colors.black),
                        ),
                      ),
                      20.height,
                      Container(
                        width: double.maxFinite,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: state.otpTimer != 0
                              ? AppColors.pageColor
                              : AppColors.whiteColor,
                          border:
                              Border.all(color: AppColors.mainColor, width: 1),
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_10)),
                        ),
                        child: MaterialButton(
                          elevation: 0,
                          height: AppConstants.buttonHeight,
                          onPressed: state.otpTimer != 0
                              ? null
                              : () {
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
                                AppLocalizations.of(context)!
                                    .send_again
                                    .toUpperCase(),
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
            ),
          );
        },
      ),
    );
  }
}
