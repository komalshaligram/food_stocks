import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/common_app_bar.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/login/log_in_bloc.dart';
import '../utils/constants/app_strings.dart';
import '../widget/custom_form_field_widget.dart';

class LogInRoute {
  static Widget get route => const LogInScreen();
}

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => LogInBloc()..add(LogInEvent.changeAuthEvent(isRegister: args?[AppStrings.isRegisterString] ?? false)),
      child: LogInScreenWidget(),
    );
  }
}

class LogInScreenWidget extends StatelessWidget {
  LogInScreenWidget({super.key});

  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.whiteColor,
              title: state.isRegister ? AppLocalizations.of(context)!.register : AppLocalizations.of(context)!.login,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(left: getScreenWidth(context) * 0.1, right: getScreenWidth(context) * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.height,
                      Text(AppLocalizations.of(context)!.enter_your_phone, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: Colors.black)),
                      30.height,
                      CustomFormField(
                        inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        context: context,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        hint: AppStrings.hintNumberString,
                        fillColor: AppColors.whiteColor,
                        textInputAction: TextInputAction.done,
                        validator: AppStrings.mobileValString,
                      ),
                      30.height,
                      CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.next,
                        bGColor: AppColors.mainColor,
                        isLoading: state.isLoading,
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  context.read<LogInBloc>().add(LogInEvent.logInApiDataEvent(contactNumber: phoneController.text, context: context));
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
    );
  }
}
