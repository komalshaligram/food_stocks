import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/custom_form_field_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/login/log_in_bloc.dart';
import '../utils/themes/app_strings.dart';


class LogInRoute {
  static Widget get route => LogInScreen();
}

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final temp =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    return BlocProvider(
      create: (context) => LogInBloc(),
      child: LogInScreenWidget(isRegister: temp[AppStrings.isRegisterString]),
    );
  }
}

class LogInScreenWidget extends StatelessWidget {
 final bool isRegister;
 LogInScreenWidget({required this.isRegister});

  final TextEditingController phoneController = TextEditingController();
 final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocListener<LogInBloc, LogInState>(
      listener: (context, state) async {

       if(state.isLoginSuccess){
          Navigator.pushNamed(
              context, RouteDefine.otpScreen.name ,arguments: {AppStrings.contactString : phoneController.text.toString(),
            AppStrings.isRegisterString: isRegister
          });
        }else{
         SnackBarShow(context ,state.errorMessage,AppColors.redColor);
         await Future.delayed(const Duration(seconds: 1));
         Navigator.pushNamed(context, RouteDefine.connectScreen.name);
       }

      },
      child: BlocBuilder<LogInBloc, LogInState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: AppLocalizations.of(context)!.connection,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: getScreenWidth(context) * 0.1,
                      right: getScreenWidth(context) * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.height,
                      Text(AppLocalizations.of(context)!.enter_your_phone,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont, color: Colors.black)),
                      30.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_5))),
                            padding: EdgeInsets.only(
                                top: AppConstants.padding_5,
                                bottom: AppConstants.padding_5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: AppConstants.padding_10, left: AppConstants.padding_10),
                                  child: Text(
                                    AppLocalizations.of(context)!.phone,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_14,
                                        color: AppColors.blackColor),
                                  ),
                                ),
                                CustomFormField(
                                    fillColor: AppColors.whiteColor,
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    isBorderVisible: false,
                                    textInputAction: TextInputAction.done,
                                    hint: AppStrings.hintNumberString, validator: AppStrings.mobileValString,),
                              ],
                            ),
                          ),
                        ),
                          10.width,
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_5),
                                  ),
                                  border: Border.all(
                                      color: AppColors.borderColor, width: 1)),
                              padding: EdgeInsets.only(
                                  top: AppConstants.padding_5,
                                  bottom: AppConstants.padding_5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: AppConstants.padding_10, left: AppConstants.padding_10),
                                    child: Text(
                                      AppLocalizations.of(context)!.country,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_14,
                                          color: AppColors.blackColor),
                                    ),
                                  ),
                                  DropdownButtonFormField<String>(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.blackColor,
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.only(left: 10, right: 10),
                                        border: InputBorder.none),
                                    isExpanded: true,
                                    elevation: 0,
                                    style: const TextStyle(
                                      fontSize: AppConstants.smallFont,
                                      color: Colors.black,
                                    ),
                                    value: '+972',
                                    // hint: const Text(
                                    //   'select tag',
                                    // ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: '+972',
                                        child: Text('+972', textDirection: TextDirection.ltr,),
                                      )
                                    ].toList(),
                                    onChanged: (countryCode) {
                                      var temp = countryCode;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      30.height,
                      CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.continued,
                        bGColor: AppColors.mainColor,
                        onPressed: () {
                          if(_formKey.currentState?.validate() ?? false){
                            context.read<LogInBloc>().add(LogInEvent.logInApiDataEvent(
                                contactNumber: phoneController.text,
                                isRegister: isRegister
                            ));
                          }
                        },
                        fontColors: AppColors.whiteColor,
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
