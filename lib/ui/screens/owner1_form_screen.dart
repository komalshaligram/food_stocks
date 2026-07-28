import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../bloc/owner1_form/owner1_form_bloc.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
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
      child: const Owner1FormScreenWidget(),
    );
  }
}

class Owner1FormScreenWidget extends StatefulWidget {
  const Owner1FormScreenWidget({super.key});

  @override
  State<Owner1FormScreenWidget> createState() => _Owner1FormScreenWidgetState();
}

class _Owner1FormScreenWidgetState extends State<Owner1FormScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _owner2NameController = TextEditingController();
  final TextEditingController _owner2IdController = TextEditingController();

  static const double _horizontalPadding = 16;
  static const double _fieldRadius = 12;

  @override
  void dispose() {
    _owner2NameController.dispose();
    _owner2IdController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context, Owner1FormState state) async {
    FocusScope.of(context).unfocus();
    if (state.business == AppLocalizations.of(context)!.type_of_business) {
      CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.select_business_type, type: SnackBarType.failure);
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!isValidIsraeliID(state.owner1israelIdController.text.trim())) {
      CustomSnackBar.showSnackBar(
          context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_owner1, type: SnackBarType.failure);
      return;
    }
    if (state.owner == '2' && !isValidIsraeliID(_owner2IdController.text.trim())) {
      CustomSnackBar.showSnackBar(
          context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_owner2, type: SnackBarType.failure);
      return;
    }
    if (state.haveMultiple && !isValidIsraeliID(state.guarantee1idController.text.trim())) {
      CustomSnackBar.showSnackBar(
          context: context, title: AppLocalizations.of(context)!.please_enter_valid_israel_id_guarantee1, type: SnackBarType.failure);
      return;
    }

    final preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    final termsConditionReqModel = TermsConditionReqModel(
      id: preferences.getUserId(),
      businessTypeId: state.businessID,
      owner1FullName: state.owner1NameController.text.trim(),
      owner1IsraelId: state.owner1israelIdController.text.trim(),
      owner2FullName: state.owner == '2' ? _owner2NameController.text.trim() : '',
      owner2IsraelId: state.owner == '2' ? _owner2IdController.text.trim() : '',
      guarantee1FullName: state.guarantee1NameController.text.trim(),
      guarantee1IsraelId: state.guarantee1idController.text.trim(),
      guarantee1Address: state.guarantee1addressController.text.trim(),
      guarantee1PhoneNumber: state.guarantee1PhoneController.text.trim(),
      guarantee2FullName: '',
      guarantee2IsraelId: '',
      guarantee2Address: '',
      guarantee2PhoneNumber: '',
    );
    if (!context.mounted) return;
    Navigator.pushNamed(context, RouteDefine.wayOfPaymentScreen.name, arguments: {AppStrings.termsConditionParamString: termsConditionReqModel});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Owner1FormBloc, Owner1FormState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          return Future.value(Navigator.canPop(context));
        },
        child: Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.data_for_form,
              iconData: Icons.arrow_back_ios_new_rounded,
              trailingWidget: _buildAppBarIcon(),
              onTap: () async {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildOwnersCard(context, state),
                  if (state.haveMultiple) ...[
                    16.height,
                    _buildGuarantorCard(context, state),
                  ],
                  24.height,
                  CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
                    bGColor: AppColors.mainColor,
                    radius: 14,
                    onPressed: () => _onSubmit(context, state),
                    fontColors: AppColors.whiteColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildOwnersCard(BuildContext context, Owner1FormState state) {
    final bool twoOwners = state.owner == '2';
    return _buildFormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, AppLocalizations.of(context)!.owner_details),
          16.height,
          if (twoOwners) ...[
            _buildSubHeader('${AppLocalizations.of(context)!.owner_label} 1'),
            10.height,
            _buildOwnerFields(context, nameController: state.owner1NameController, idController: state.owner1israelIdController),
            const _SectionDivider(),
            _buildSubHeader('${AppLocalizations.of(context)!.owner_label} 2'),
            10.height,
            _buildOwnerFields(context, nameController: _owner2NameController, idController: _owner2IdController),
          ] else
            _buildOwnerFields(context, nameController: state.owner1NameController, idController: state.owner1israelIdController),
        ],
      ),
    );
  }

  Widget _buildOwnerFields(BuildContext context, {required TextEditingController nameController, required TextEditingController idController}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(context, AppLocalizations.of(context)!.full_name),
        _buildTextField(context: context, controller: nameController, keyboardType: TextInputType.text, validator: AppStrings.ownerNameValString),
        14.height,
        _buildFieldLabel(context, AppLocalizations.of(context)!.israel_id),
        _buildTextField(
          context: context,
          controller: idController,
          keyboardType: TextInputType.number,
          inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
          validator: AppStrings.idValString,
        ),
      ],
    );
  }

  Widget _buildGuarantorCard(BuildContext context, Owner1FormState state) {
    return _buildFormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, AppLocalizations.of(context)!.guarantor_details),
          16.height,
          _buildFieldLabel(context, AppLocalizations.of(context)!.full_name),
          _buildTextField(
              context: context,
              controller: state.guarantee1NameController,
              keyboardType: TextInputType.text,
              validator: AppStrings.guaranteeNameString),
          14.height,
          _buildFieldLabel(context, AppLocalizations.of(context)!.israel_id),
          _buildTextField(
            context: context,
            controller: state.guarantee1idController,
            keyboardType: TextInputType.number,
            inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
            validator: AppStrings.idValString,
          ),
          14.height,
          _buildFieldLabel(context, AppLocalizations.of(context)!.address_label),
          _buildTextField(
              context: context,
              controller: state.guarantee1addressController,
              keyboardType: TextInputType.text,
              validator: AppStrings.addressValString),
          14.height,
          _buildFieldLabel(context, AppLocalizations.of(context)!.phone_label),
          _buildTextField(
            context: context,
            controller: state.guarantee1PhoneController,
            keyboardType: TextInputType.number,
            inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
            validator: AppStrings.mobileValString,
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(2))),
        8.width,
        Text(title, style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildSubHeader(String title) {
    return Text(title, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.mainColor, fontWeight: FontWeight.w600));
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      child: Icon(Icons.groups_outlined, size: 21, color: AppColors.mainColor),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('* ', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.redColor)),
          Expanded(
            child: Text(
              label,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_13, color: AppColors.blackColor.withValues(alpha: 0.55), fontWeight: FontWeight.w500),
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
    List<TextInputFormatter>? inputFormat,
  }) {
    return CustomFormField(
      context: context,
      controller: controller,
      keyboardType: keyboardType,
      hint: '',
      fillColor: AppColors.pageColor,
      textInputAction: TextInputAction.next,
      validator: validator,
      inputFormat: inputFormat,
      border: _fieldRadius,
      cursorColor: AppColors.mainColor,
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: AppColors.borderColor, height: 1),
    );
  }
}
