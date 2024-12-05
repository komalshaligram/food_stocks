import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/form_data/form_data_bloc.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import '../widget/form_data_screen_shimmer_widget.dart';

class FormDataRoute {
  static Widget get route => const FormDataScreen();
}

class FormDataScreen extends StatelessWidget {
  const FormDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormDataBloc()..add(FormDataEvent.getBusinessTypeEvent(context: context)),
      child: FormDataScreenWidget(),
    );
  }
}

class FormDataScreenWidget extends StatelessWidget {
  FormDataScreenWidget({super.key});
  final _formKey = GlobalKey<FormState>();
  String ownerName = '';

  @override
  Widget build(BuildContext context) {
    FormDataBloc bloc = context.read<FormDataBloc>();
    return BlocBuilder<FormDataBloc, FormDataState>(
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
                child: state.isShimmering || state.isAgentListShimmering
                    ? const FormDataScreenShimmerWidget()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.1),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.height,
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.my_agent_code,
                              ),
                              CustomFormField(
                                inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                                context: context,
                                controller: state.agentCodeController,
                                keyboardType: TextInputType.number,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                maxLimits: 6,
                                validator: AppStrings.agentCodeString,
                              ),
                              7.height,
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.type_of_business,
                              ),
                              CommonDropDownButton(
                                items: state.businessTypeList.map((business) {
                                  return DropdownMenuItem<String>(
                                    value: business.businessTypeName,
                                    child: Text(business.businessTypeName ?? ''),
                                  );
                                }).toList(),
                                onChanged: (newBusiness) {
                                  bloc.add(FormDataEvent.selectBusinessTypeEvent(business: newBusiness ?? '', haveMultiple: true));
                                  if (!state.haveMultiple) {
                                    state.guarantee1NameController.text = '';
                                    state.guarantee1addressController.text = '';
                                    state.guarantee1idController.text = '';
                                    state.guarantee1PhoneController.text = '';
                                    state.guarantee2NameController.text = '';
                                    state.guarantee2addressController.text = '';
                                    state.guarantee2idController.text = '';
                                    state.guarantee2PhoneController.text = '';
                                    state.owner2NameController.text = '';
                                    state.owner2israelIdController.text = '';
                                  }
                                },
                                value: state.business,
                              ),
                              7.height,
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.owner1_full_name,
                              ),
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
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!.owner_1_israel_id,
                              ),
                              CustomFormField(
                                context: context,
                                controller: state.owner1israelIdController,
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
                              state.haveMultiple
                                  ? Column(
                                      children: [
                                        CustomContainerWidget(
                                          name: AppLocalizations.of(context)!.guarantee_1_full_name,
                                        ),
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
                                        CustomContainerWidget(
                                          name: AppLocalizations.of(context)!.guarantee_1_israel_id,
                                        ),
                                        CustomFormField(
                                          context: context,
                                          controller: state.guarantee1idController,
                                          inputFormat: [
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
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
                                        CustomContainerWidget(
                                          name: AppLocalizations.of(context)!.guarantee_1_phone_number,
                                        ),
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
                                        7.height,
                                        CustomContainerWidget(
                                          name: AppLocalizations.of(context)!.owner2_full_name,
                                          star: '',
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
                                          star: '',
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
                                          validator: state.owner2NameController.text.toString().isNotEmpty ? AppStrings.idValString : '',
                                        ),
                                        7.height,
                                        CustomContainerWidget(
                                          name: AppLocalizations.of(context)!.guarantee_2_full_name,
                                          star: '',
                                        ),
                                        CustomFormField(
                                          context: context,
                                          controller: state.guarantee2NameController,
                                          keyboardType: TextInputType.text,
                                          hint: "",
                                          fillColor: Colors.transparent,
                                          textInputAction: TextInputAction.next,
                                          validator: state.owner2NameController.text.toString().isNotEmpty ? AppStrings.guaranteeName2String : '',
                                        ),
                                        7.height,
                                        CustomContainerWidget(
                                          name: AppLocalizations.of(context)!.guarantee_2_israel_id,
                                          star: '',
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
                                          validator: ownerName.isNotEmpty ? AppStrings.idValString : '',
                                        ),
                                        7.height,
                                        CustomContainerWidget(
                                          name: state.language == AppStrings.hebrewString ? '${AppLocalizations.of(context)!.guarantee_2_address}${2}' : AppLocalizations.of(context)!.guarantee_2_address,
                                          star: '',
                                        ),
                                        CustomFormField(
                                          context: context,
                                          controller: state.guarantee2addressController,
                                          keyboardType: TextInputType.text,
                                          hint: "",
                                          fillColor: Colors.transparent,
                                          textInputAction: TextInputAction.next,
                                          validator: ownerName.isNotEmpty ? AppStrings.addressValString : '',
                                        ),
                                        7.height,
                                        CustomContainerWidget(
                                          name: AppLocalizations.of(context)!.guarantee_2_phone_number,
                                          star: '',
                                        ),
                                        CustomFormField(
                                          inputFormat: [LengthLimitingTextInputFormatter(10)],
                                          context: context,
                                          controller: state.guarantee2PhoneController,
                                          keyboardType: TextInputType.number,
                                          hint: "",
                                          fillColor: Colors.transparent,
                                          textInputAction: TextInputAction.done,
                                          validator: ownerName.isNotEmpty ? AppStrings.mobileValString : '',
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
                                          bloc.add(FormDataEvent.verifyAgentEvent(context: context));
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

  bool validation(FormDataState state, BuildContext context) {
    if (state.haveMultiple) {
      if (isValidIsraeliID(state.guarantee1idController.text.toString().trim())) {
        if (ownerName.isNotEmpty) {
          if (isValidIsraeliID(state.owner2israelIdController.text.toString().trim())) {
            if (isValidIsraeliID(state.guarantee2idController.text.toString().trim())) {
              if (state.guarantee2NameController.text.toString().isNotEmpty) {
                if (state.guarantee2addressController.text.toString().isNotEmpty) {
                  if (state.guarantee2PhoneController.text.toString().isNotEmpty) {
                    return true;
                  } else {
                    CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.phone_number_cant_be_empty, type: SnackBarType.failure);
                    return false;
                  }
                } else {
                  CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_address, type: SnackBarType.failure);
                  return false;
                }
              } else {
                CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_guarantee2_name, type: SnackBarType.failure);
                return false;
              }
            } else {
              CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_guarantee2, type: SnackBarType.failure);
              return false;
            }
          } else {
            CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_owner2, type: SnackBarType.failure);
            return false;
          }
        } else {
          return true;
        }
      } else {
        CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_guarantee1, type: SnackBarType.failure);
        return false;
      }
    } else {
      return true;
    }
  }
}
