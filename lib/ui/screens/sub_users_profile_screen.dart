import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
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
import '../widget/custom_form_field_widget.dart';

class SubUsersProfileRoute {
  static Widget get route => const SubUserProfileScreen();
}

class SubUserProfileScreen extends StatelessWidget {
  const SubUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => SubUsersProfileBloc()
        ..add(SubUsersProfileEvent.getSubUserByIdEvent(
          context: context,
          isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
              ? true
              : false,
          subUserId: args?[AppStrings.subUserIdString] ?? '',
        ))
        ..add(SubUsersProfileEvent.getAppLanguageEvent(context: context)),
      child: const SubUserProfileScreenWidget(),
    );
  }
}

class SubUserProfileScreenWidget extends StatefulWidget {
  const SubUserProfileScreenWidget({super.key});

  @override
  State<SubUserProfileScreenWidget> createState() =>
      _SubUserProfileScreenWidgetState();
}

class _SubUserProfileScreenWidgetState
    extends State<SubUserProfileScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  static const double _horizontalPadding = 16;
  static const double _fieldRadius = 12;

  @override
  Widget build(BuildContext context) {
    SubUsersProfileBloc bloc = context.read<SubUsersProfileBloc>();
    return BlocBuilder<SubUsersProfileBloc, SubUsersProfileState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: state.isUpdate ? l10n.edit_sub_user : l10n.new_sub_user,
              iconData: Icons.arrow_back_ios_new_rounded,
              trailingWidget: _buildAppBarIcon(),
              onTap: () => Navigator.pop(context),
            ),
          ),
          body: state.isShimmering && state.isUpdate
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(
                      _horizontalPadding, 8, _horizontalPadding, 32),
                  child: ProfileScreenShimmerWidget(isProfileImage: false),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      _horizontalPadding,
                      8,
                      _horizontalPadding,
                      state.isUpdate || state.isEnable ? 32 : 100),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFormCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel(context, l10n.full_name),
                              _buildTextField(
                                context: context,
                                controller: state.nameController,
                                keyboardType: TextInputType.text,
                                validator: AppStrings.subUserValString,
                                textInputAction: TextInputAction.next,
                              ),
                              14.height,
                              _buildFieldLabel(context, l10n.phone_number),
                              _buildTextField(
                                context: context,
                                controller: state.phoneNumberController,
                                keyboardType: TextInputType.number,
                                validator: AppStrings.mobileValString,
                                textInputAction: TextInputAction.next,
                              ),
                              14.height,
                              _buildFieldLabel(context, l10n.email,
                                  required: false),
                              _buildTextField(
                                context: context,
                                controller: state.emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _email.isEmpty
                                    ? ''
                                    : AppStrings.emailValString,
                                textInputAction: TextInputAction.next,
                                onChangeValue: (value) =>
                                    setState(() => _email = value),
                              ),
                              14.height,
                              _buildFieldLabel(context, l10n.israel_id),
                              _buildTextField(
                                context: context,
                                controller: state.israelIdController,
                                keyboardType: TextInputType.number,
                                validator: AppStrings.idValString,
                                textInputAction: TextInputAction.done,
                              ),
                            ],
                          ),
                        ),
                        if (state.isUpdate || state.isEnable) ...[
                          24.height,
                          _buildSaveButton(context, bloc, state),
                        ],
                        if (state.isEnable) ...[
                          20.height,
                          _buildPermissionsGroup(context, state),
                          20.height,
                          _buildDeleteButton(context, bloc, state),
                        ],
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: !state.isUpdate && !state.isEnable
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        _horizontalPadding, 8, _horizontalPadding, 16),
                    child: _buildSaveButton(context, bloc, state),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.person_outline_rounded,
          size: 21, color: AppColors.mainColor),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label,
      {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (required)
            Text('* ',
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_13, color: AppColors.redColor)),
          Expanded(
            child: Text(
              label,
              style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_13,
                color: AppColors.blackColor.withValues(alpha: 0.55),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String validator,
    TextInputAction? textInputAction,
    void Function(String)? onChangeValue,
  }) {
    return CustomFormField(
      context: context,
      controller: controller,
      keyboardType: keyboardType,
      hint: '',
      fillColor: AppColors.pageColor,
      textInputAction: textInputAction,
      validator: validator,
      onChangeValue: onChangeValue,
      border: _fieldRadius,
      cursorColor: AppColors.mainColor,
    );
  }

  Widget _buildSaveButton(BuildContext context, SubUsersProfileBloc bloc,
      SubUsersProfileState state) {
    return CustomButtonWidget(
      buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
      bGColor: AppColors.mainColor,
      isLoading: state.isLoading,
      radius: 14,
      onPressed: () => _onSavePressed(context, bloc, state),
      fontColors: AppColors.whiteColor,
    );
  }

  void _onSavePressed(BuildContext context, SubUsersProfileBloc bloc,
      SubUsersProfileState state) {
    if (!isValidIsraeliID(state.israelIdController.text.toString().trim())) {
      CustomSnackBar.showSnackBar(
          context: context,
          title: AppLocalizations.of(context)!.please_enter_valid_israel_id,
          type: SnackBarType.failure);
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    if (!state.isUpdate && !state.isEnable) {
      bloc.add(SubUsersProfileEvent.createSubUserEvent(context: context));
    } else if (state.isUpdate || state.isEnable) {
      bloc.add(SubUsersProfileEvent.updateSubUserEvent(context: context));
    }
  }

  Widget _buildPermissionsGroup(
      BuildContext context, SubUsersProfileState state) {
    final l10n = AppLocalizations.of(context)!;
    final tiles = <Widget>[
      _permissionTile(
        title: l10n.account_permission.toCapitalized(),
        icon: Icons.admin_panel_settings_outlined,
        onTap: () => _openPermission(
            context, state, RouteDefine.accountPermissionScreen.name),
      ),
      _permissionTile(
        title: l10n.categories_permissions.toCapitalized(),
        icon: Icons.category_outlined,
        onTap: () => _openPermission(
            context, state, RouteDefine.categoriesPermissionScreen.name),
      ),
      _permissionTile(
        title: l10n.brand_permissions.toCapitalized(),
        icon: Icons.branding_watermark_outlined,
        onTap: () => _openPermission(
            context, state, RouteDefine.brandPermissionScreen.name),
      ),
      _permissionTile(
        title: l10n.supplier_permissions.toCapitalized(),
        icon: Icons.local_shipping_outlined,
        onTap: () => _openPermission(
            context, state, RouteDefine.supplierPermissionScreen.name),
      ),
    ];

    return _buildFormCard(
      child: Column(
        children: _intersperseDividers(tiles),
      ),
    );
  }

  void _openPermission(
      BuildContext context, SubUsersProfileState state, String routeName) {
    if (state.isUpdate || state.isEnable) {
      Navigator.pushNamed(context, routeName,
          arguments: {AppStrings.subUserIdString: state.subUserId});
    }
  }

  List<Widget> _intersperseDividers(List<Widget> children) {
    if (children.length <= 1) return children;
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(Divider(
            height: 1,
            thickness: 1,
            indent: 68,
            color: AppColors.lightBorderColor.withValues(alpha: 0.6)));
      }
    }
    return result;
  }

  Widget _permissionTile(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 21, color: AppColors.mainColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_15,
                    color: AppColors.blackColor.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right,
                  size: 22,
                  color: AppColors.blackColor.withValues(alpha: 0.25)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, SubUsersProfileBloc bloc,
      SubUsersProfileState state) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => deleteConfirmDialog(
            bloc: bloc,
            context: context,
            directionality: state.language,
            isDeleteProcess: state.isDeleteProcess),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: AppColors.redColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            AppLocalizations.of(context)!.delete_sub_user_account,
            style: AppStyles.rkRegularTextStyle(
              size: AppConstants.font_14,
              color: AppColors.redColor.withValues(alpha: 0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void deleteConfirmDialog(
      {required SubUsersProfileBloc bloc,
      required BuildContext context,
      required String directionality,
      required bool isDeleteProcess}) {
    showDialog(
      context: context,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<SubUsersProfileBloc>(),
          child: BlocBuilder<SubUsersProfileBloc, SubUsersProfileState>(
            builder: (context, state) {
              return CommonAlertDialog(
                isLogOutProcess: state.isDeleteProcess,
                directionality: directionality,
                title: AppLocalizations.of(context)!.delete_account,
                subTitle: AppLocalizations.of(context)!.are_you_sure,
                positiveTitle: AppLocalizations.of(context)!.yes,
                negativeTitle: AppLocalizations.of(context)!.no,
                negativeOnTap: () => Navigator.pop(context),
                positiveOnTap: () async {
                  bloc.add(SubUsersProfileEvent.deleteAccountEvent(
                      context: context, dialogContext: context1));
                },
              );
            },
          ),
        );
      },
    );
  }
}
