import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/app_utils.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/form_data/form_data_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';
import '../widget/customer_service_contact_widget.dart';
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

  static const double _horizontalPadding = 16;
  static const double _fieldRadius = 12;

  @override
  Widget build(BuildContext context) {
    FormDataBloc bloc = context.read<FormDataBloc>();
    return BlocBuilder<FormDataBloc, FormDataState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          // Registration screens are always pushed onto a stack — going back to the
          // previous step must always work. Only the stack root has nowhere to go.
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
          body: state.isShimmering || state.isAgentListShimmering
              ? const FormDataScreenShimmerWidget()
              : SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFormCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(context, AppLocalizations.of(context)!.my_agent_code),
                        _buildTextField(
                          context: context,
                          controller: state.agentCodeController,
                          keyboardType: TextInputType.number,
                          validator: AppStrings.agentCodeString,
                          textInputAction: TextInputAction.next,
                          maxLimits: 6,
                          inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                        ),
                        14.height,
                        _buildFieldLabel(context, AppLocalizations.of(context)!.type_of_business),
                        CommonDropDownButton(
                          items: state.businessTypeList.map((business) {
                            return DropdownMenuItem<String>(value: business.businessTypeName, child: Text(business.businessTypeName ?? ''));
                          }).toList(),
                          onChanged: (newBusiness) {
                            bloc.add(FormDataEvent.selectBusinessTypeEvent(business: newBusiness ?? '', haveMultiple: true));
                          },
                          value: state.business,
                          color: AppColors.lightBorderColor,
                          borderRadius: _fieldRadius,
                          useFilledBackground: true,
                        ),
                        if (state.haveMultiple) ...[
                          14.height,
                          _buildFieldLabel(context, AppLocalizations.of(context)!.select_number_of_owners),
                          CommonDropDownButton(
                            items: state.ownerList.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (v) {
                              bloc.add(FormDataEvent.selectOwnerNoEvent(owner: v ?? ''));
                            },
                            value: state.owner,
                            color: AppColors.lightBorderColor,
                            borderRadius: _fieldRadius,
                            useFilledBackground: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                  16.height,
                  _buildAgentCodeHelp(context, state),
                  24.height,
                  CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
                    bGColor: AppColors.mainColor,
                    radius: 14,
                    onPressed: () {
                      if (state.business != AppLocalizations.of(context)!.type_of_business) {
                        if (_formKey.currentState!.validate()) {
                          bloc.add(FormDataEvent.verifyAgentEvent(context: context));
                        }
                      } else {
                        CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.select_business_type, type: SnackBarType.failure);
                      }
                    },
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

  Widget _buildFormCard(BuildContext context, {required Widget child}) {
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

  /// Friendly help block shown under the agent-code field: users who don't know
  /// their agent code (or who their agent is) can reach customer service. Opens
  /// the same WhatsApp/phone bottom sheet used across the app.
  Widget _buildAgentCodeHelp(BuildContext context, FormDataState state) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mainColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.help_outline_rounded, size: 22, color: AppColors.mainColor),
              ),
              12.width,
              Expanded(
                child: Text(
                  l10n.agent_code_help_message,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_13,
                    color: AppColors.blackColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          14.height,
          _buildContactSupportButton(context, state),
        ],
      ),
    );
  }

  Widget _buildContactSupportButton(BuildContext context, FormDataState state) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(_fieldRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(_fieldRadius),
        onTap: () {
          showCustomerServiceBottomSheet(
            context: context,
            customerServicePhone: state.customerServicePhone,
            customerServiceWhatsApp: state.customerServiceWhatsApp,
          );
        },
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_fieldRadius),
            border: Border.all(color: AppColors.mainColor, width: 1.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.headset_mic_rounded, size: 20, color: AppColors.mainColor),
              8.width,
              Text(
                l10n.agent_code_contact_support,
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_15,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
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
      child: Icon(Icons.assignment_outlined, size: 21, color: AppColors.mainColor),
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
    int? maxLimits,
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
      maxLimits: maxLimits,
      inputFormat: inputFormat,
      border: _fieldRadius,
      cursorColor: AppColors.mainColor,
    );
  }
}