import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/form_data/form_data_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';

class FormDataRoute {
  static Widget get route => const FormDataScreen();
}


class FormDataScreen extends StatelessWidget {
  const FormDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormDataBloc(),
      child: FormDataScreenWidget(),
    );
  }
}

class FormDataScreenWidget extends StatelessWidget {
  FormDataScreenWidget({super.key});
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    FormDataBloc bloc = context.read<FormDataBloc>();
    return BlocBuilder<FormDataBloc, FormDataState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            surfaceTintColor: AppColors.whiteColor,
            leading: GestureDetector(
                onTap: () {
                 Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Align(
              alignment:
              context.rtl ? Alignment.centerRight : Alignment.centerLeft,
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(context) * 0.1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!
                            .select_agent,
                      ),
                      CommonDropDownButton(
                          onChanged: (newAgent) {
                            bloc.add(FormDataEvent.selectAgentEvent(agent: newAgent ?? ''));
                          },
                        items: state.agentList.map((agent) {
                          return DropdownMenuItem<String>(
                            value: agent,
                            child: Text(
                                agent),
                          );
                        }).toList(),
                        value: state.agent,
                      ),

                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!
                            .type_of_business,
                      ),
                      CommonDropDownButton(
                        items: state.BusinessTypeList.map((business) {
                          return DropdownMenuItem<String>(
                            value: business,
                            child: Text(
                                business),
                          );
                        }).toList(),
                        onChanged: (newBusiness) {
                          bloc.add(FormDataEvent.selectBusinessTypeEvent(business: newBusiness ?? ''));
                        },
                        value: state.business,
                      ),
                      7.height,
                      int.parse(state.business) > 20 ? Column(
                        children: [
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
                            hint: "",
                            fillColor: Colors.transparent,
                            textInputAction: TextInputAction.next,
                            validator: AppStrings.idValString,
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
                              validator: ''
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
                            hint: "",
                            fillColor: Colors.transparent,
                            textInputAction: TextInputAction.next,
                            validator: '',
                          ),
                          7.height,
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
                            keyboardType: TextInputType.number,
                            hint: "",
                            fillColor: Colors.transparent,
                            textInputAction: TextInputAction.next,
                            validator: AppStrings.idValString,
                          ),
                          7.height,
                          CustomContainerWidget(
                            name: AppLocalizations.of(context)!.guarantee_1_address,
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
                            star: '*',
                          ),
                          CustomFormField(
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
                            validator: '',
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
                            hint: "",
                            fillColor: Colors.transparent,
                            textInputAction: TextInputAction.next,
                            validator: '',
                          ),
                          7.height,
                          CustomContainerWidget(
                            name: AppLocalizations.of(context)!.guarantee_2_address,
                            star: '',
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
                            star: '',
                          ),
                          CustomFormField(
                            context: context,
                            controller: state.guarantee2PhoneController,
                            keyboardType: TextInputType.number,
                            hint: "",
                            fillColor: Colors.transparent,
                            textInputAction: TextInputAction.done,
                            validator: '',
                          ),
                        ],
                      ) : SizedBox(),

                      40.height,
                      CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!
                            .next
                            .toUpperCase(),
                        bGColor: AppColors.mainColor,
                        onPressed:  () {
                          if (state.agent.isNotEmpty) {
                            if (_formKey.currentState
                                ?.validate() ??
                                false) {
                              Navigator.pushNamed(context, RouteDefine.bankInfoScreen.name);
                            }
                          }
                          else{
                            CustomSnackBar.showSnackBar(
                                context: context,
                                title: AppLocalizations.of(
                                    context)!
                                    .please_select_agent,
                                type: SnackBarType.FAILURE);
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
        );
      },
    );
  }
}
