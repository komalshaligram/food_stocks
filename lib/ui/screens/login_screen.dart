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
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/login/log_in_bloc.dart';
import '../utils/themes/app_strings.dart';
import '../utils/validation/auth_form_validation.dart';

class LogInRoute {
  static Widget get route => LogInScreen();
}

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final temp = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (temp[AppStrings.isRegisterString] == null) {
      temp[AppStrings.isRegisterString] = true;
    } else {
      temp[AppStrings.isRegisterString];
    }
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
        if (state.isLoginSuccess) {
          Navigator.pushNamed(context, RouteDefine.otpScreen.name, arguments: {
            AppStrings.contactString: phoneController.text.toString(),
            AppStrings.isRegisterString: isRegister
          });
        } else if (state.isLoginFail) {
          showSnackBar(
              context: context,
              title: state.errorMessage,
              bgColor: AppColors.redColor);
        }
      },
      child: BlocBuilder<LogInBloc, LogInState>(
        builder: (context, state) {
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
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
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
                                size: AppConstants.smallFont,
                                color: Colors.black)),
                        30.height,
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.borderColor,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      AppConstants.radius_5))),
                          padding: EdgeInsets.only(
                              top: AppConstants.padding_5,
                              bottom: AppConstants.padding_5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: AppConstants.padding_10,
                                    left: AppConstants.padding_10),
                                child: Text(
                                  AppLocalizations.of(context)!.phone,
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_14,
                                      color: AppColors.blackColor),
                                ),
                              ),
                              TextFormField(
                                controller: phoneController,
                                // maxLength: 10,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.blackColor,
                                    size: AppConstants.smallFont,
                                ),
                                validator: (value) {
                                  context.read<LogInBloc>().add(
                                      LogInEvent.validateMobileEvent(
                                          errorMsg: AuthFormValidation()
                                                  .formValidation(
                                                      value!,
                                                      AppStrings
                                                          .mobileValString) ??
                                              ''));
                                  return null;
                                },
                                decoration: InputDecoration(
                                  // counterText: '',
                                    errorStyle: TextStyle(
                                        color: AppColors.redColor,
                                       ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedErrorBorder:
                                        OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        state.mobileErrorMessage.isEmpty
                            ? 10.height
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(state.mobileErrorMessage,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.smallFont,
                                          color: AppColors.redColor)),
                                ],
                              ),
                        10.height,
                        CustomButtonWidget(
                          buttonText: AppLocalizations.of(context)!.next,
                          bGColor: AppColors.mainColor,
                          isLoading: state.isLoading,
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    if (state.mobileErrorMessage.isEmpty) {
                                      context.read<LogInBloc>().add(
                                          LogInEvent.logInApiDataEvent(
                                              contactNumber:
                                                  phoneController.text,
                                              isRegister: isRegister,
                                              context: context));
                                    }
                                  }
                                },
                          fontColors: AppColors.whiteColor,
                        ),
                      ],
                    ),
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
