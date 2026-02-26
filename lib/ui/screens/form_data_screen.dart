import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/form_data/form_data_bloc.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
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
  final String ownerName = '';

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
                                    /*    state.guarantee1NameController.text = '';
                                    state.guarantee1addressController.text = '';
                                    state.guarantee1idController.text = '';
                                    state.guarantee1PhoneController.text = '';
                                    state.guarantee2NameController.text = '';
                                    state.guarantee2addressController.text = '';
                                    state.guarantee2idController.text = '';
                                    state.guarantee2PhoneController.text = '';
                                    state.owner2NameController.text = '';
                                    state.owner2israelIdController.text = '';*/
                                  }
                                },
                                value: state.business,
                              ),
                              7.height,
                              state.haveMultiple
                                  ? CustomContainerWidget(
                                      name: AppLocalizations.of(context)!.select_number_of_owners,
                                    )
                                  : 0.height,
                              state.haveMultiple
                                  ? CommonDropDownButton(
                                      items: state.ownerList.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        debugPrint('owners:$v');
                                        bloc.add(FormDataEvent.selectOwnerNoEvent(owner: v ?? ''));
                                      },
                                      value: state.owner,
                                    )
                                  : 0.height,
                              30.height,
                              CustomButtonWidget(
                                buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
                                bGColor: AppColors.mainColor,
                                onPressed: () {
                                  if (state.business != AppLocalizations.of(context)!.type_of_business) {
                                    if (_formKey.currentState!.validate()) {
                                      bloc.add(FormDataEvent.verifyAgentEvent(context: context));
                                    }
                                  } else {
                                    CustomSnackBar.showSnackBar(
                                      context: context,
                                      title: AppLocalizations.of(context)!.select_business_type,
                                      type: SnackBarType.failure,
                                    );
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
