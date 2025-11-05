import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/owner2_form/owner2_form_bloc.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';

class Owner2FormRoute {
  static Widget get route => const Owner2FormScreen();
}

class Owner2FormScreen extends StatelessWidget {
  const Owner2FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => Owner2FormBloc()..add(Owner2FormEvent.getArgumentEvent(
          reqModel: args?[AppStrings.termsConditionParamString] ??const TermsConditionReqModel()
      )),
      child: Owner2FormScreenWidget(),
    );
  }
}

class Owner2FormScreenWidget extends StatelessWidget {
  Owner2FormScreenWidget({super.key});
  final _formKey = GlobalKey<FormState>();
  String ownerName = '';

  @override
  Widget build(BuildContext context) {

    Owner2FormBloc bloc = context.read<Owner2FormBloc>();
    return BlocBuilder<Owner2FormBloc, Owner2FormState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
            if (!preferencesHelper.getUserLoggedIn()) {
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
                    SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                    if (!preferencesHelper.getUserLoggedIn()) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
              title: Align(
                alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.data_for_form,
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
            body: SafeArea(
              child: SingleChildScrollView(
                child:Padding(
                        padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.1),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.height,
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.owner2_full_name,
                              ),
                              CustomFormField(
                                context: context,
                                controller: state.owner2NameController,
                                keyboardType: TextInputType.text,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: AppStrings.ownerName2ValString,
                                onChangeValue: (t) {
                                  ownerName = t;
                                },
                              ),
                              7.height,
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.owner_2_israel_id,
                              ),
                              CustomFormField(
                                context: context,
                                controller: state.owner2israelIdController,
                                keyboardType: TextInputType.number,
                                inputFormat: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: AppStrings.idValString,
                              ),
                              7.height,
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.guarantee_2_full_name,
                              ),
                              CustomFormField(
                                context: context,
                                controller: state.guarantee2NameController,
                                keyboardType: TextInputType.text,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: AppStrings.guaranteeName2String,
                              ),
                              7.height,
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.guarantee_2_israel_id,

                              ),
                              CustomFormField(
                                context: context,
                                controller: state.guarantee2idController,
                                keyboardType: TextInputType.number,
                                inputFormat: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator:AppStrings.idValString,
                              ),
                              7.height,
                              CustomContainerWidget(
                                name: state.language == AppStrings.hebrewString ? '${AppLocalizations.of(context)!.guarantee_2_address}${2}' : AppLocalizations.of(context)!.guarantee_2_address,

                              ),
                              CustomFormField(
                                context: context,
                                controller: state.guarantee2addressController,
                                keyboardType: TextInputType.text,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: '',
                              ),
                              7.height,
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.guarantee_2_phone_number,
                              ),
                              CustomFormField(
                                inputFormat: [LengthLimitingTextInputFormatter(10)],
                                context: context,
                                controller: state.guarantee2PhoneController,
                                keyboardType: TextInputType.number,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.done,
                                validator: AppStrings.mobileValString,
                              ),
                              40.height,
                              CustomButtonWidget(
                                buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
                                bGColor: AppColors.mainColor,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    bloc.add(Owner2FormEvent.navigateToNextScreenEvent(context: context));
                                  }
                                },
                                fontColors: AppColors.whiteColor,
                              ),
                              20.height,
                            ],
                          ),
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
