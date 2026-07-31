import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/profile_screen_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../routes/app_routes.dart';
import '../widget/dialogs/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

class ProfileRoute {
  static Widget get route => const ProfileScreen();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    final isUpdate = args?.containsKey(AppStrings.isUpdateParamString) ?? false;
    final mobileNumber = args?[AppStrings.contactString]?.toString() ?? '';

    return BlocProvider(
        create: (context) => ProfileBloc()
          ..add(ProfileEvent.getBusinessTypeListEvent(context: context))
          ..add(ProfileEvent.getProfileDetailsEvent(context: context, isUpdate: isUpdate, mobileNo: mobileNumber)),
        child: ProfileScreenWidget());
  }
}

class ProfileScreenWidget extends StatelessWidget {
  ProfileScreenWidget({super.key});

  final _formKey = GlobalKey<FormState>();

  static const double _horizontalPadding = 16;
  static const double _fieldRadius = 12;

  @override
  Widget build(BuildContext context1) {
    ProfileBloc bloc = context1.read<ProfileBloc>();
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isFileSizeExceeds) {
          CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.file_size_must_be_less_then, type: SnackBarType.failure);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        PreferredSizeWidget appBarWidget() => PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                  bgColor: AppColors.pageColor,
                  title: AppLocalizations.of(context)!.business_details,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  trailingWidget: _buildAppBarIcon(),
                  onTap: () {
                    if (!state.isUpdate) {
                      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                    } else {
                      Navigator.pop(context);
                    }
                  }),
            );

        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: appBarWidget(),
          body: state.isShimmering
              ? const ProfileScreenShimmerWidget()
              : Stack(children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(_horizontalPadding, AppConstants.padding_8, _horizontalPadding, 32),
                    child: Form(
                      key: _formKey,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        _buildFormCard(context,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              _buildFieldLabel(context, AppLocalizations.of(context)!.type_of_business),
                              businessTypeField(state, bloc),
                              14.height,
                              _buildFieldLabel(context, AppLocalizations.of(context)!.business_name),
                              businessNameField(state, context),
                              14.height,
                              _buildFieldLabel(context, AppLocalizations.of(context)!.business_id),
                              businessIdField(state, context),
                              14.height,
                              _buildFieldLabel(context, AppLocalizations.of(context)!.owner_first_name),
                              ownerFirstNameField(state, context),
                              14.height,
                              _buildFieldLabel(context, AppLocalizations.of(context)!.owner_last_name),
                              ownerLastNameField(state, context),
                              14.height,
                              _buildFieldLabel(context, AppLocalizations.of(context)!.israel_id),
                              israelIdField(state, context),
                              14.height,
                              _buildFieldLabel(context, AppLocalizations.of(context)!.contact_name),
                              contactField(state, context)
                            ])),
                        24.height,
                        saveButtonWidget(state, context, bloc, context1),
                        if (state.isUpdate) ...[
                          20.height,
                          _buildDeleteAccountButton(
                              context: context,
                              onPressed: () {
                                deleteConfirmDialog(bloc: bloc, context: context, directionality: state.language);
                              })
                        ]
                      ]),
                    ),
                  ),
                  if (state.isUpdating)
                    Positioned.fill(
                      child: ColoredBox(
                          color: AppColors.blackColor.withValues(alpha: 0.04),
                          child: Center(child: CupertinoActivityIndicator(color: AppColors.mainColor, radius: AppConstants.radius_20))),
                    ),
                ]),
        );
      }),
    );
  }

  Widget _buildFormCard(BuildContext context, {required Widget child}) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
        padding: const EdgeInsets.all(AppConstants.padding_15),
        child: child);
  }

  Widget _buildDeleteAccountButton({required BuildContext context, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.redColor.withValues(alpha: 0.3))),
          child: Text(AppLocalizations.of(context)!.delete_account,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14, color: AppColors.redColor.withValues(alpha: 0.75), fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildAppBarIcon() {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.person_outline_rounded, size: 21, color: AppColors.mainColor));
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.padding_6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('* ', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.redColor)),
        Expanded(
          child: Text(label,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_13, color: AppColors.blackColor.withValues(alpha: 0.55), fontWeight: FontWeight.w500)),
        ),
      ]),
    );
  }

  Widget businessTypeField(ProfileState state, ProfileBloc bloc) => CommonDropDownButton(
      items: state.businessTypeList.map((businessType) {
        return DropdownMenuItem<String>(value: businessType.businessType, child: Text(businessType.businessType ?? ''));
      }).toList(),
      onChanged: (newBusinessType) {
        bloc.add(ProfileEvent.changeBusinessTypeEvent(newBusinessType: newBusinessType ?? ''));
      },
      value: state.selectedBusinessType,
      color: AppColors.lightBorderColor,
      borderRadius: _fieldRadius);

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String validator,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormat,
  }) {
    return CustomFormField(
        context: context,
        controller: controller,
        keyboardType: keyboardType,
        hint: '',
        fillColor: AppColors.pageColor,
        textInputAction: textInputAction,
        validator: validator,
        inputFormat: inputFormat,
        border: _fieldRadius,
        cursorColor: AppColors.mainColor);
  }

  Widget businessNameField(ProfileState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.businessNameController,
      keyboardType: TextInputType.text,
      validator: AppStrings.businessNameValString,
      textInputAction: TextInputAction.next);

  Widget businessIdField(ProfileState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.businessIdController,
      inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
      keyboardType: TextInputType.number,
      validator: AppStrings.hpValString,
      textInputAction: TextInputAction.next);

  Widget ownerFirstNameField(ProfileState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.ownerFirstNameController,
      inputFormat: [LengthLimitingTextInputFormatter(20)],
      keyboardType: TextInputType.text,
      validator: AppStrings.ownerFirstNameValString,
      textInputAction: TextInputAction.next);

  Widget ownerLastNameField(ProfileState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.ownerLastNameController,
      inputFormat: [LengthLimitingTextInputFormatter(20)],
      keyboardType: TextInputType.text,
      validator: AppStrings.ownerFirstNameValString,
      textInputAction: TextInputAction.next);

  Widget israelIdField(ProfileState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.israelIdController,
      inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
      keyboardType: TextInputType.number,
      validator: AppStrings.idValString,
      textInputAction: TextInputAction.next);

  Widget contactField(ProfileState state, BuildContext context) => _buildTextField(
      context: context,
      controller: state.contactController,
      inputFormat: [LengthLimitingTextInputFormatter(20)],
      keyboardType: TextInputType.text,
      validator: AppStrings.contactNameValString,
      textInputAction: TextInputAction.done);

  Widget saveButtonWidget(ProfileState state, BuildContext context, ProfileBloc bloc, BuildContext context1) => CustomButtonWidget(
      buttonText: state.isUpdate ? AppLocalizations.of(context)!.save.toUpperCase() : AppLocalizations.of(context)!.next.toUpperCase(),
      bGColor: AppColors.mainColor,
      isLoading: state.isLoading,
      radius: 14,
      fontColors: AppColors.whiteColor,
      onPressed: state.isLoading
          ? null
          : () {
              if (state.selectedBusinessType.isEmpty || state.selectedBusinessType != AppLocalizations.of(context)?.type_of_business) {
                if (isValidIsraeliID(state.businessIdController.text.toString().trim())) {
                  if (isValidIsraeliID(state.israelIdController.text.toString().trim())) {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (state.isUpdate) {
                        bloc.add(ProfileEvent.updateProfileDetailsEvent(context: context1));
                      } else {
                        bloc.add(ProfileEvent.navigateToMoreDetailsScreenEvent(context: context1));
                      }
                    }
                  } else {
                    CustomSnackBar.showSnackBar(
                        context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id, type: SnackBarType.failure);
                  }
                } else {
                  CustomSnackBar.showSnackBar(
                      context: context, title: AppLocalizations.of(context)!.please_enter_valid_business_id, type: SnackBarType.failure);
                }
              } else {
                CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.select_business_type, type: SnackBarType.failure);
              }
            });

  void deleteConfirmDialog({required ProfileBloc bloc, required BuildContext context, required String directionality}) {
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
              deleteDialog(context: context, directionality: directionality, bloc: bloc);
            }));
  }

  void deleteDialog({required ProfileBloc bloc, required BuildContext context, required String directionality}) {
    showDialog(
        context: context,
        builder: (context1) => CommonAlertDialog(
            directionality: directionality,
            title: AppLocalizations.of(context)!.delete_account,
            subTitle: AppLocalizations.of(context)!.delete_pop_up_msg,
            positiveTitle: AppLocalizations.of(context)!.closeText,
            positiveOnTap: () async {
              Navigator.pop(context1);
              bloc.add(ProfileEvent.deleteAccountEvent(context: context));
            }));
  }
}
