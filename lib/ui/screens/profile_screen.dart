import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';

import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/profile_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../routes/app_routes.dart';

import '../widget/common_alert_dialog.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfileRoute {
  static Widget get route => const ProfileScreen();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    debugPrint(
        "isUpdate : ${args?.containsKey(AppStrings.isUpdateParamString)}\nmobileNumber : ${args?.containsKey(AppStrings.contactString)}");
    return BlocProvider(
      create: (context) => ProfileBloc()
        ..add(
          ProfileEvent.getBusinessTypeListEvent(context: context),
        )
        ..add(
          ProfileEvent.getProfileDetailsEvent(
              context: context,
              isUpdate:
                  args?.containsKey(AppStrings.isUpdateParamString) ?? false
                      ? true
                      : false,
              mobileNo: args?.containsKey(AppStrings.contactString) ?? false
                  ? args![AppStrings.contactString]
                  : ''),
        ),
      child: ProfileScreenWidget(),
    );
  }
}

class ProfileScreenWidget extends StatelessWidget {
  ProfileScreenWidget({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context1) {
    ProfileBloc bloc = context1.read<ProfileBloc>();
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isFileSizeExceeds) {
          CustomSnackBar.showSnackBar(
              context: context,
              title:
                  AppLocalizations.of(context)!.file_size_must_be_less_then,
              type: SnackBarType.failure);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              surfaceTintColor: AppColors.whiteColor,
              leading: GestureDetector(
                  onTap: () {
                    if (!state.isUpdate) {
                      Navigator.pushNamed(
                          context, RouteDefine.connectScreen.name);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
              title: Align(
                alignment:
                    context.rtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.business_details,
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
            body: state.isShimmering
                ? const ProfileScreenShimmerWidget()
                : SingleChildScrollView(
                  child: Column(
                      children: [
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: getScreenWidth(context1) * 0.1,
                                right: getScreenWidth(context1) * 0.1),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  10.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .type_of_business,
                                  ),

                                  CommonDropDownButton(
                                    items: state
                                        .businessTypeList
                                        .map((businessType) {
                                      return DropdownMenuItem<String>(
                                        value: businessType.businessType,
                                        child: Text(
                                            businessType.businessType??''),
                                      );
                                    }).toList(),
                                    onChanged: (newBusinessType) {
                                      bloc.add(ProfileEvent
                                          .changeBusinessTypeEvent(
                                          newBusinessType:
                                          newBusinessType??''));
                                    },
                                    value: state.selectedBusinessType,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .business_name,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.businessNameController,
                                    keyboardType: TextInputType.text,
                                    hint: "",
                                    fillColor: Colors.transparent,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.businessNameValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .business_id,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.businessIdController,
                                    inputFormat: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(9)
                                    ],
                                    keyboardType: TextInputType.number,
                                    hint: "",
                                    fillColor: Colors.transparent,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.hpValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .name_of_owner,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.ownerNameController,
                                    inputFormat: [
                                      LengthLimitingTextInputFormatter(20)
                                    ],
                                    keyboardType: TextInputType.text,
                                    hint: "",
                                    fillColor: Colors.transparent,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.ownerNameValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name:
                                        AppLocalizations.of(context)!.israel_id,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.israelIdController,
                                    inputFormat: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(9)
                                    ],
                                    keyboardType: TextInputType.number,
                                    hint: "",
                                    fillColor: Colors.transparent,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.idValString,
                                  ),
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .contact_name,
                                  ),
                                  7.height,
                                  CustomFormField(
                                    controller: state.contactController,
                                    inputFormat: [
                                      LengthLimitingTextInputFormatter(20)
                                    ],
                                    keyboardType: TextInputType.text,
                                    hint: "",
                                    fillColor: Colors.transparent,
                                    textInputAction: TextInputAction.done,
                                    validator: AppStrings.contactNameValString,
                                    context: context,
                                  ),
                                  40.height,
                                  CustomButtonWidget(
                                    buttonText: state.isUpdate
                                        ? AppLocalizations.of(context)!
                                            .save
                                            .toUpperCase()
                                        : AppLocalizations.of(context)!
                                            .next
                                            .toUpperCase(),
                                    bGColor: AppColors.mainColor,
                                    isLoading: state.isLoading,
                                    onPressed: state.isLoading
                                        ? null
                                        : () {
                                            if (state.selectedBusinessType!= AppLocalizations.of(context)?.type_of_business) {
                                              if(isValidIsraeliID(state.businessIdController.text.toString().trim())) {
                                                   if(isValidIsraeliID(state.israelIdController.text.toString().trim())) {
                                                if (_formKey.currentState
                                                    ?.validate() ??
                                                    false) {
                                                  if (state.isUpdate) {
                                                    bloc.add(ProfileEvent
                                                        .updateProfileDetailsEvent(
                                                        context: context1));
                                                  } else {
                                                    bloc.add(ProfileEvent
                                                        .navigateToMoreDetailsScreenEvent(
                                                        context: context1));
                                                  }
                                                }
                                                }else{
                                                     CustomSnackBar.showSnackBar(
                                                         context: context,
                                                         title: AppLocalizations.of(
                                                             context)!
                                                             .please_enter_valid_israel_id,
                                                         type: SnackBarType.failure);
                                                   }
                                              }else{
                                                CustomSnackBar.showSnackBar(
                                                    context: context,
                                                    title: AppLocalizations.of(
                                                        context)!
                                                        .please_enter_valid_business_id,
                                                    type: SnackBarType.failure);
                                              }
                                            } else {
                                              CustomSnackBar.showSnackBar(
                                                  context: context,
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .select_business_type,
                                                  type: SnackBarType.failure);
                                            }
                                          },
                                    fontColors: AppColors.whiteColor,
                                  ),
                                  10.height,
                                 state.isUpdate ?  CustomButtonWidget(
                                    isFromConnectScreen: true,
                                    fontColors: AppColors.mainColor,
                                    borderColor: AppColors.mainColor,
                                    buttonText: AppLocalizations.of(context)!
                                        .delete_account
                                        .toUpperCase(),
                                    onPressed: () {
                                      deleteConfirmDialog(
                                          bloc: bloc,
                                          context: context,
                                          directionality: state.language);
                                    },
                                  ) : 0.width,
                                  20.height,
                                ],
                              ),
                            ),
                          ),
                        ),
                        state.isUpdating
                            ? Container(
                                color: const Color.fromARGB(10, 0, 0, 0),
                                height: getScreenHeight(context),
                                width: getScreenWidth(context),
                                alignment: Alignment.center,
                                child: CupertinoActivityIndicator(
                                  color: AppColors.blackColor,
                                ),
                              )
                            : 0.width,
                      ],
                    ),
                ),
          );
        },
      ),
    );
  }

  void deleteConfirmDialog({
    required ProfileBloc bloc,
    required BuildContext context,
    required String directionality,
  }) {
    showDialog(
        context: context,
        builder: (context1) => CommonAlertDialog(
              directionality: directionality,
              title: AppLocalizations.of(context)!.delete_account,
              subTitle: AppLocalizations.of(context)!.are_you_sure,
              positiveTitle: AppLocalizations.of(context)!.yes,
              negativeTitle: AppLocalizations.of(context)!.no,
              negativeOnTap: () {
                Navigator.pop(context);
              },
              positiveOnTap: () async {
                Navigator.pop(context);
                deleteDialog(
                    context: context,
                    directionality: directionality,
                    bloc: bloc);
              },
            ));
  }

  void deleteDialog({
    required ProfileBloc bloc,
    required BuildContext context,
    required String directionality,
  }) {
    showDialog(
        context: context,
        builder: (context1) => CommonAlertDialog(
              directionality: directionality,
              title: AppLocalizations.of(context)!.delete_account,
              subTitle: AppLocalizations.of(context)!.delete_pop_up_msg,
              positiveTitle: AppLocalizations.of(context)!.close,
              positiveOnTap: () async {
                Navigator.pop(context1);
                bloc.add(ProfileEvent.deleteAccountEvent(context: context));
                //Navigator.pushAndRemoveUntil(context, Routes.lo, (route) => false);
              },
            ));
  }
}
