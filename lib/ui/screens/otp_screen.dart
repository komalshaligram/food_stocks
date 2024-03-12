import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/otp/otp_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:sms_autofill/sms_autofill.dart';
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


class OTPScreenWidget extends StatefulWidget {
  final bool isRegister;
  final String contact;

  OTPScreenWidget({required this.isRegister, required this.contact});

  @override
  State<OTPScreenWidget> createState() => _OTPScreenWidgetState();
}

class _OTPScreenWidgetState extends State<OTPScreenWidget> {
  String _code="";
  FocusNode inputNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    OtpBloc bloc = context.read<OtpBloc>();
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) async {
         debugPrint("state:$state");
        await SmsAutoFill().listenForCode();
      },
      child: BlocBuilder<OtpBloc, OtpState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.whiteColor,
                title: widget.isRegister
                    ? AppLocalizations.of(context)!.register
                    : AppLocalizations.of(context)!.login,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  debugPrint('register ${widget.isRegister}');
                  bloc.add(OtpEvent.cancelOtpTimerSubscription());

                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.height,
                    Padding(
                      padding: EdgeInsets.only(
                          left: getScreenWidth(context) * 0.12,
                          right: getScreenWidth(context) * 0.12),
                      child: Text(
                          AppLocalizations.of(context)!.enter_the_code_sent_to_phone_num,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: Colors.black)),
                    ),
                    30.height,
                    Padding(
                      padding: EdgeInsets.only(
                          left: getScreenWidth(context) * 0.09,
                          right: getScreenWidth(context) * 0.09),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child:SizedBox(
                          height: 80,
                          child: PinFieldAutoFill(
                            decoration: BoxLooseDecoration(
                              textStyle: const TextStyle(fontSize: AppConstants.font_30, color: Colors.black),
                              strokeColorBuilder: FixedColorBuilder(AppColors.mainColor),
                            ),
                            currentCode: _code,
                            autoFocus: true,
                            focusNode: inputNode,
                            enableInteractiveSelection:false ,
                            codeLength: 4,
                            onCodeSubmitted: (code) {
                              bloc.add(OtpEvent.changeOtpEvent(otp: code));
                              SystemChannels.textInput.invokeMethod("TextInput.show");
                            },
                            onCodeChanged: (code) {
                              _code= code!;
                              if(code.length==4){
                                if (widget.isRegister == true) {
                                  bloc.add(OtpEvent.registerApiEvent(
                                      contact: widget.contact,
                                      otp: _code,
                                      isRegister: widget.isRegister,
                                      context: context));
                                } else {
                                  bloc.add(OtpEvent.otpApiEvent(
                                      contact: widget.contact,
                                      otp: _code,
                                      isRegister: widget.isRegister,
                                      context: context));
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    15.height,
                    Padding(
                      padding: EdgeInsets.only(
                          left: getScreenWidth(context) * 0.11,
                          right: getScreenWidth(context) * 0.11),
                      child: CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.next,
                        bGColor: AppColors.mainColor,
                        isLoading: state.isLoading,
                        onPressed: state.isLoading
                            ? null
                            : () {
                          FocusScope.of(context).unfocus();
                          debugPrint('otp1 = ${state.otp}');
                          debugPrint('otp1 = ${_code.length}');
                          if (_code.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                context: context,
                                title:
                                '${AppLocalizations.of(context)!.please_enter_otp}',
                                type: SnackBarType.FAILURE);
                          } else if (_code.length != 4) {
                            CustomSnackBar.showSnackBar(
                                context: context,
                                title:
                                '${AppLocalizations.of(context)!.enter_4digit_otp}',
                                type: SnackBarType.FAILURE);
                          } else {
                            if (widget.isRegister == true) {
                              bloc.add(OtpEvent.registerApiEvent(
                                  contact: widget.contact,
                                  otp: _code,
                                  isRegister: widget.isRegister,
                                  context: context));
                            } else {
                              bloc.add(OtpEvent.otpApiEvent(
                                  contact: widget.contact,
                                  otp: _code,
                                  isRegister: widget.isRegister,
                                  context: context));
                            }
                          }

                        },
                        fontColors: AppColors.whiteColor,
                      ),
                    ),
                    20.height,
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.not_receive_verification_code,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont, color: Colors.black),
                      ),
                    ),
                    20.height,
                    Padding(
                      padding: EdgeInsets.only(
                          left: getScreenWidth(context) * 0.11,
                          right: getScreenWidth(context) * 0.11),
                      child: Container(
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
                            bloc.add(OtpEvent.logInApiDataEvent(
                                context: context,isRegister: widget.isRegister,contactNumber: widget.contact));
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
                                AppLocalizations.of(context)!.send_again
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
