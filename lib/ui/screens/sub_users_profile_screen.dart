import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/profile_screen_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/sub_users_profile/sub_users_profile_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';

class SubUsersProfileRoute {
  static Widget get route => const SubUserProfileScreen();
}

class SubUserProfileScreen extends StatelessWidget {
  const SubUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => SubUsersProfileBloc()
        ..add(SubUsersProfileEvent.getSubUserByIdEvent(
          context: context,
          isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false ? true : false,
          subUserId: args?[AppStrings.subUserIdString] ?? '',
        ))
        ..add(SubUsersProfileEvent.getAppLanguageEvent(context: context)),
      child: SubUserProfileScreenWidget(),
    );
  }
}

class SubUserProfileScreenWidget extends StatelessWidget {
  SubUserProfileScreenWidget({super.key});
  final _formKey = GlobalKey<FormState>();
  String email = '';

  @override
  Widget build(BuildContext context) {
    SubUsersProfileBloc bloc = context.read<SubUsersProfileBloc>();
    return BlocBuilder<SubUsersProfileBloc, SubUsersProfileState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.new_sub_user,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child: state.isShimmering && state.isUpdate
              ? const ProfileScreenShimmerWidget(isProfileImage: false)
              : Padding(
                  padding: EdgeInsets.only(left: getScreenWidth(context) * 0.1, right: getScreenWidth(context) * 0.1),
                  child: SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        CustomContainerWidget(name: AppLocalizations.of(context)!.full_name, star: '*'),
                        CustomFormField(
                          context: context,
                          controller: state.nameController,
                          keyboardType: TextInputType.text,
                          hint: "",
                          fillColor: AppColors.whiteColor,
                          textInputAction: TextInputAction.next,
                          validator: AppStrings.subUserValString,
                        ),
                        7.height,
                        CustomContainerWidget(name: AppLocalizations.of(context)!.phone_number, star: '*'),
                        CustomFormField(
                          context: context,
                          controller: state.phoneNumberController,
                          keyboardType: TextInputType.number,
                          hint: "",
                          fillColor: AppColors.whiteColor,
                          textInputAction: TextInputAction.next,
                          validator: AppStrings.mobileValString,
                        ),
                        7.height,
                        CustomContainerWidget(name: AppLocalizations.of(context)!.email, star: ''),
                        CustomFormField(
                            context: context,
                            controller: state.emailController,
                            keyboardType: TextInputType.emailAddress,
                            hint: "",
                            fillColor: AppColors.whiteColor,
                            textInputAction: TextInputAction.next,
                            validator: email.isEmpty ? '' : AppStrings.emailValString,
                            onChangeValue: (value) {
                              email = value;
                            }),
                        7.height,
                        CustomContainerWidget(name: AppLocalizations.of(context)!.israel_id, star: '*'),
                        CustomFormField(
                          context: context,
                          controller: state.israelIdController,
                          keyboardType: TextInputType.number,
                          hint: "",
                          fillColor: AppColors.whiteColor,
                          textInputAction: TextInputAction.done,
                          validator: AppStrings.idValString,
                        ),
                        20.height,
                        state.isUpdate || state.isEnable
                            ? CustomButtonWidget(
                                buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
                                bGColor: AppColors.mainColor,
                                isLoading: state.isLoading,
                                onPressed: () {
                                  if (isValidIsraeliID(state.israelIdController.text.toString().trim())) {
                                    if (_formKey.currentState!.validate()) {
                                      if (!state.isUpdate && !state.isEnable) {
                                        bloc.add(SubUsersProfileEvent.createSubUserEvent(context: context));
                                      } else if (state.isUpdate || state.isEnable) {
                                        bloc.add(SubUsersProfileEvent.updateSubUserEvent(context: context));
                                      }
                                    }
                                  } else {
                                    CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id, type: SnackBarType.failure);
                                  }
                                },
                                fontColors: AppColors.whiteColor,
                              )
                            : 0.width,
                        10.height,
                        state.isEnable
                            ? profileMenuTiles(
                                title: AppLocalizations.of(context)!.account_permission.toCapitalized(),
                                onTap: () {
                                  if (state.isUpdate || state.isEnable) {
                                    Navigator.pushNamed(context, RouteDefine.accountPermissionScreen.name, arguments: {AppStrings.subUserIdString: state.subUserId});
                                  }
                                })
                            : 0.width,
                        10.height,
                        state.isEnable
                            ? profileMenuTiles(
                                title: AppLocalizations.of(context)!.categories_permissions.toCapitalized(),
                                onTap: () {
                                  if (state.isUpdate || state.isEnable) {
                                    Navigator.pushNamed(context, RouteDefine.categoriesPermissionScreen.name, arguments: {AppStrings.subUserIdString: state.subUserId});
                                  }
                                })
                            : 0.width,
                        10.height,
                        state.isEnable
                            ? profileMenuTiles(
                                title: AppLocalizations.of(context)!.brand_permissions.toCapitalized(),
                                onTap: () {
                                  if (state.isUpdate || state.isEnable) {
                                    Navigator.pushNamed(context, RouteDefine.brandPermissionScreen.name, arguments: {AppStrings.subUserIdString: state.subUserId});
                                  }
                                })
                            : 0.width,
                        10.height,
                        state.isEnable
                            ? profileMenuTiles(
                                title: AppLocalizations.of(context)!.supplier_permissions.toCapitalized(),
                                onTap: () {
                                  if (state.isUpdate || state.isEnable) {
                                    Navigator.pushNamed(context, RouteDefine.supplierPermissionScreen.name, arguments: {AppStrings.subUserIdString: state.subUserId});
                                  }
                                })
                            : 0.width,
                        15.height,
                        state.isEnable
                            ? GestureDetector(
                                onTap: () {
                                  deleteConfirmDialog(bloc: bloc, context: context, directionality: state.language, isDeleteProcess: state.isDeleteProcess);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.delete_sub_user_account.toUpperCase(),
                                  style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.redColor, fontWeight: FontWeight.w400),
                                ),
                              )
                            : 0.width,
                        20.height,
                      ]),
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: !state.isUpdate && !state.isEnable
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_35, vertical: AppConstants.padding_20),
                child: CustomButtonWidget(
                  buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
                  bGColor: AppColors.mainColor,
                  isLoading: state.isLoading,
                  onPressed: () {
                    if (isValidIsraeliID(state.israelIdController.text.toString().trim())) {
                      if (_formKey.currentState!.validate()) {
                        if (!state.isUpdate && !state.isEnable) {
                          bloc.add(SubUsersProfileEvent.createSubUserEvent(context: context));
                        } else if (state.isUpdate) {
                          bloc.add(SubUsersProfileEvent.updateSubUserEvent(context: context));
                        }
                      }
                    } else {
                      CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id, type: SnackBarType.failure);
                    }
                  },
                  fontColors: AppColors.whiteColor,
                ),
              )
            : 0.width,
      );
    });
  }

  Widget profileMenuTiles({required title, required void Function() onTap, bool isDelete = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
      ),
      margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_3, horizontal: AppConstants.padding_3),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: isDelete ? AppColors.redColor : AppColors.blackColor)),
            Icon(isDelete ? Icons.delete : Icons.arrow_forward_ios, color: isDelete ? AppColors.redColor : AppColors.blackColor),
          ]),
        ),
      ),
    );
  }

  void deleteConfirmDialog({required SubUsersProfileBloc bloc, required BuildContext context, required String directionality, required bool isDeleteProcess}) {
    showDialog(
        context: context,
        builder: (context1) {
          return BlocProvider.value(
            value: context.read<SubUsersProfileBloc>(),
            child: BlocBuilder<SubUsersProfileBloc, SubUsersProfileState>(builder: (context, state) {
              return CommonAlertDialog(
                  isLogOutProcess: state.isDeleteProcess,
                  directionality: directionality,
                  title: AppLocalizations.of(context)!.delete_account,
                  subTitle: AppLocalizations.of(context)!.are_you_sure,
                  positiveTitle: AppLocalizations.of(context)!.yes,
                  negativeTitle: AppLocalizations.of(context)!.no,
                  negativeOnTap: () {
                    Navigator.pop(context);
                  },
                  positiveOnTap: () async {
                    bloc.add(SubUsersProfileEvent.deleteAccountEvent(context: context, dialogContext: context1));
                  });
            }),
          );
        });
  }
}
