import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/owner1_form/owner1_form_bloc.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';

class Owner1FormRoute {
  static Widget get route => const Owner1FormScreen();
}

class Owner1FormScreen extends StatelessWidget {
  const Owner1FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => Owner1FormBloc()
        ..add(Owner1FormEvent.getArgumentEvent(
          owner: args?[AppStrings.owner] ?? '',
          businessTypeId: args?[AppStrings.businessTypeIdString] ?? '0',
          isFreelancer: args?[AppStrings.isFreelancer] ?? '',
        )),
      child: Owner1FormScreenWidget(),
    );
  }
}

class Owner1FormScreenWidget extends StatelessWidget {
  Owner1FormScreenWidget({super.key});
  final _formKey = GlobalKey<FormState>();
  final String ownerName = '';

  @override
  Widget build(BuildContext context) {
    Owner1FormBloc bloc = context.read<Owner1FormBloc>();
    return BlocBuilder<Owner1FormBloc, Owner1FormState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
          if (!preferences.getUserLoggedIn()) {
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            surfaceTintColor: AppColors.whiteColor,
            leading: GestureDetector(
                onTap: () async {
                  SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                  if (!preferences.getUserLoggedIn()) {
                    Navigator.pop(context);
                  }
                },
                child:  Icon(Icons.arrow_back_ios, color: AppColors.blackColor)),
            title: Align(
              alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(AppLocalizations.of(context)!.data_for_form, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
            ),
            backgroundColor: AppColors.whiteColor,
            titleSpacing: 0,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.1),
                child: Form(
                  key: _formKey,
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    10.height,
                    CustomContainerWidget(name: AppLocalizations.of(context)!.owner1_full_name),
                    CustomFormField(
                      context: context,
                      controller: state.owner1NameController,
                      keyboardType: TextInputType.text,
                      hint: "",
                      fillColor: Colors.transparent,
                      textInputAction: TextInputAction.next,
                      validator: AppStrings.ownerNameValString,
                    ),
                    7.height,
                    CustomContainerWidget(name: AppLocalizations.of(context)!.owner_1_israel_id),
                    CustomFormField(
                      context: context,
                      controller: state.owner1israelIdController,
                      keyboardType: TextInputType.number,
                      inputFormat: [FilteringTextInputFormatter.digitsOnly],
                      hint: "",
                      fillColor: Colors.transparent,
                      textInputAction: TextInputAction.next,
                      validator: AppStrings.idValString,
                    ),
                    7.height,
                    state.haveMultiple
                        ? Column(
                            children: [
                              CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_1_full_name),
                              CustomFormField(
                                context: context,
                                controller: state.guarantee1NameController,
                                keyboardType: TextInputType.text,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: AppStrings.guaranteeNameString,
                              ),
                              7.height,
                              CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_1_israel_id),
                              CustomFormField(
                                context: context,
                                controller: state.guarantee1idController,
                                inputFormat: [FilteringTextInputFormatter.digitsOnly],
                                keyboardType: TextInputType.number,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: AppStrings.idValString,
                              ),
                              7.height,
                              CustomContainerWidget(
                                name: state.language == AppStrings.hebrewString ? '${AppLocalizations.of(context)!.guarantee_1_address}${1}' : AppLocalizations.of(context)!.guarantee_1_address,
                              ),
                              CustomFormField(
                                context: context,
                                controller: state.guarantee1addressController,
                                keyboardType: TextInputType.text,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: AppStrings.addressValString,
                              ),
                              7.height,
                              CustomContainerWidget(name: AppLocalizations.of(context)!.guarantee_1_phone_number),
                              CustomFormField(
                                inputFormat: [LengthLimitingTextInputFormatter(10)],
                                context: context,
                                controller: state.guarantee1PhoneController,
                                keyboardType: TextInputType.number,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: AppStrings.mobileValString,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    40.height,
                    CustomButtonWidget(
                      buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
                      bGColor: AppColors.mainColor,
                      onPressed: () {
                        if (state.business != AppLocalizations.of(context)!.type_of_business) {
                          if (isValidIsraeliID(state.owner1israelIdController.text.toString().trim())) {
                            if (_formKey.currentState!.validate()) {
                              bool success = validation(state, context);
                              if (success) {
                                bloc.add(Owner1FormEvent.navigateToNextScreenEvent(context: context));
                              }
                            }
                          } else {
                            CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_owner1, type: SnackBarType.failure);
                          }
                        } else {
                          CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.select_business_type, type: SnackBarType.failure);
                        }
                      },
                      fontColors: AppColors.whiteColor,
                    ),
                    20.height,
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  bool validation(Owner1FormState state, BuildContext context) {
    if (state.haveMultiple) {
      if (isValidIsraeliID(state.guarantee1idController.text.toString().trim())) {
        return true;
      } else {
        CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_guarantee1, type: SnackBarType.failure);
        return false;
      }
    } else {
      return true;
    }
  }
}
