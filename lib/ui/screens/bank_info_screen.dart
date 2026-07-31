import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/bank_info/bank_info_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/bank_info_shimmer_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';

class BankInfoRoute {
  static Widget get route => const BankInfoScreen();
}

class BankInfoScreen extends StatelessWidget {
  const BankInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
        create: (context) => BankInfoBloc()
          ..add(BankInfoEvent.getBankNameEvent(context: context))
          ..add(BankInfoEvent.getTermsConditionModelEvent(
              context: context, termsConditionReqModel: args?[AppStrings.termsConditionParamString] ?? const TermsConditionReqModel()))
          ..add(BankInfoEvent.getArgumentEvent(
              isPaymentFail: args?[AppStrings.isPaymentFail] ?? false, isUpdate: args?[AppStrings.updateString] ?? false)),
        child: BankInfoWidget());
  }
}

class BankInfoWidget extends StatelessWidget {
  BankInfoWidget({super.key});

  final _formKey = GlobalKey<FormState>();

  static const double _horizontalPadding = 16;
  static const double _fieldRadius = 12;

  @override
  Widget build(BuildContext context) {
    BankInfoBloc bloc = context.read<BankInfoBloc>();
    return BlocBuilder<BankInfoBloc, BankInfoState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.bank_info,
                iconData: Icons.arrow_back_ios_new_rounded,
                trailingWidget: _buildAppBarIcon(),
                onTap: () => Navigator.pop(context)),
          ),
          body: state.isShimmering
              ? const BankInfoScreenShimmerWidget()
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(_horizontalPadding, 12, _horizontalPadding, 120),
                  child: Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      _buildInfoNote(context),
                      16.height,
                      _buildFormCard(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _buildFieldLabel(context, AppLocalizations.of(context)!.name_of_bank),
                        CommonDropDownButton(
                            items: state.bankList.map((element) {
                              return DropdownMenuItem<String>(value: element.bankName, child: Text(element.bankName ?? ''));
                            }).toList(),
                            onChanged: (newBankName) {
                              bloc.add(BankInfoEvent.selectBankEvent(bankName: newBankName ?? ''));
                            },
                            value: state.bankName,
                            color: AppColors.lightBorderColor,
                            borderRadius: _fieldRadius,
                            useFilledBackground: true),
                        16.height,
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              _buildFieldLabel(context, AppLocalizations.of(context)!.branch_number),
                              _buildTextField(
                                  context: context,
                                  controller: state.branchController,
                                  validator: AppStrings.branchValString,
                                  textInputAction: TextInputAction.next,
                                  inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)])
                            ]),
                          ),
                          12.width,
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              _buildFieldLabel(context, AppLocalizations.of(context)!.account_number),
                              _buildTextField(
                                  context: context,
                                  controller: state.accountNumberController,
                                  validator: AppStrings.accountValString,
                                  textInputAction: TextInputAction.done,
                                  inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)])
                            ]),
                          ),
                        ]),
                      ]))
                    ]),
                  ),
                ),
          bottomSheet: !state.isShimmering
              ? Container(
                  color: AppColors.pageColor,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: CustomButtonWidget(
                      isLoading: state.isApiShimmering,
                      buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
                      bGColor: AppColors.mainColor,
                      radius: 14,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (!state.isUpdate) {
                            bloc.add(BankInfoEvent.termsConditionApiEvent(context: context));
                          } else {
                            bloc.add(BankInfoEvent.addBankInfoEvent(context: context));
                          }
                        }
                      },
                      fontColors: AppColors.whiteColor),
                )
              : const SizedBox());
    });
  }

  Widget _buildInfoNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: AppColors.blueColor.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(Icons.account_balance_outlined, size: 22, color: AppColors.blueColor.withValues(alpha: 0.8)),
        10.width,
        Expanded(
          child: Text(AppLocalizations.of(context)!.bank_info_note,
              style:
                  AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.blueColor.withValues(alpha: 0.85)).copyWith(height: 1.4)),
        ),
      ]),
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
        padding: const EdgeInsets.all(16),
        child: child);
  }

  Widget _buildAppBarIcon() {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.account_balance_outlined, size: 21, color: AppColors.mainColor));
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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

  Widget _buildTextField(
      {required BuildContext context,
      required TextEditingController controller,
      required String validator,
      TextInputAction? textInputAction,
      List<TextInputFormatter>? inputFormat}) {
    return CustomFormField(
        context: context,
        controller: controller,
        keyboardType: TextInputType.number,
        hint: '',
        fillColor: AppColors.pageColor,
        textInputAction: textInputAction,
        validator: validator,
        inputFormat: inputFormat,
        border: _fieldRadius,
        cursorColor: AppColors.mainColor);
  }
}
