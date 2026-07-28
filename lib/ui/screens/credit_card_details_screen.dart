import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/res_model/my_account_card_invoices_res_model/my_account_card_invoices_res_model.dart';
import '../../ui/utils/app_utils.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/credit_card_details/credit_card_details_bloc.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';

class CreditCardDetailsRoute {
  static Widget get route => const CreditCardDetailsScreen();
}

class CreditCardDetailsScreen extends StatelessWidget {
  const CreditCardDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    final MyCardInvoice? invoiceData = args?[AppStrings.invoiceData];
    final bool isFromInvoicePayment =
        args?[AppStrings.isFromInvoicePayment] ?? false;
    return BlocProvider(
      create: (context) => CreditCardDetailsBloc()
        ..add(CreditCardDetailsEvent.getArgumentEvent(
          isFromRegFlow: args?[AppStrings.isFromRegFlow] ?? false,
          termsReqModel: args?[AppStrings.termsConditionParamString] ??
              const TermsConditionReqModel(),
          isPaymentFail: args?[AppStrings.isPaymentFail] ?? false,
          invoiceData: invoiceData,
        )),
      child: CreditCardDetailsScreenWidget(
          isPaymentToNext: args?[AppStrings.isPaymentToNext],
          invoiceData: invoiceData!,
          isFromInvoicePayment: isFromInvoicePayment),
    );
  }
}

class CreditCardDetailsScreenWidget extends StatelessWidget {
  CreditCardDetailsScreenWidget(
      {super.key,
      required this.isPaymentToNext,
      required this.invoiceData,
      required this.isFromInvoicePayment});

  final bool isPaymentToNext;
  final MyCardInvoice invoiceData;
  final bool isFromInvoicePayment;
  final _formKey = GlobalKey<FormState>();

  static const double _horizontalPadding = 16;
  static const double _fieldRadius = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<CreditCardDetailsBloc, CreditCardDetailsState>(
        builder: (context, state) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            if (isFromInvoicePayment) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context, true);
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: l10n.credit_card_details,
              iconData: Icons.arrow_back_ios_new_rounded,
              trailingWidget: _buildAppBarIcon(),
              onTap: () {
                if (isFromInvoicePayment) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context, true);
                }
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  _horizontalPadding, 8, _horizontalPadding, 100),
              child: Form(
                key: _formKey,
                child: _buildFormCard(
                  context: context,
                  state: state,
                  l10n: l10n,
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  _horizontalPadding, 8, _horizontalPadding, 16),
              child: CustomButtonWidget(
                buttonText: l10n.next.toUpperCase(),
                bGColor: AppColors.mainColor,
                isLoading: state.isLoading,
                radius: 14,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (validateMonth(
                        state.selectedMonth, state.validityController.text)) {
                      context
                          .read<CreditCardDetailsBloc>()
                          .add(CreditCardDetailsEvent.addCreditCardEvent(
                            context: context,
                            isPaymentToNext: isPaymentToNext,
                            invoiceData: invoiceData.orderId != null
                                ? invoiceData
                                : const MyCardInvoice(),
                          ));
                    } else {
                      CustomSnackBar.showSnackBar(
                          context: context,
                          title: l10n.select_valid_month,
                          type: SnackBarType.failure);
                    }
                  }
                },
                fontColors: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.credit_card_outlined,
          size: 21, color: AppColors.mainColor),
    );
  }

  Widget _buildFormCard(
      {required BuildContext context,
      required CreditCardDetailsState state,
      required AppLocalizations l10n}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel(l10n.credit_card_number),
          CustomFormField(
            inputFormat: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16)
            ],
            context: context,
            controller: state.creditCardNumberController,
            keyboardType: TextInputType.number,
            hint: '',
            fillColor: AppColors.pageColor,
            textInputAction: TextInputAction.next,
            validator: AppStrings.creditCardNumberString,
            border: _fieldRadius,
            cursorColor: AppColors.mainColor,
          ),
          14.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(l10n.year),
                    CustomFormField(
                      inputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
                      context: context,
                      controller: state.validityController,
                      keyboardType: TextInputType.number,
                      hint: 'YY',
                      fillColor: AppColors.pageColor,
                      textInputAction: TextInputAction.done,
                      validator: AppStrings.creditCardValidityString,
                      border: _fieldRadius,
                      cursorColor: AppColors.mainColor,
                    ),
                  ],
                ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(l10n.month),
                    CommonDropDownButton(
                      items: state.monthList.map((value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value.toString()));
                      }).toList(),
                      onChanged: (month) {
                        if (validateMonth(month.toString(),
                            state.validityController.text.toString())) {
                          context.read<CreditCardDetailsBloc>().add(
                              CreditCardDetailsEvent.selectMonthEvent(
                                  month: month ?? ''));
                        } else {
                          CustomSnackBar.showSnackBar(
                              context: context,
                              title: l10n.select_valid_month,
                              type: SnackBarType.failure);
                        }
                      },
                      value: state.selectedMonth,
                      color: AppColors.lightBorderColor,
                      borderRadius: _fieldRadius,
                      useFilledBackground: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppStyles.rkRegularTextStyle(
          size: AppConstants.font_13,
          color: AppColors.blackColor.withValues(alpha: 0.55),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool validateMonth(String month, String year) {
    if (DateTime.now().year.toString().substring(2, 4) == year) {
      if (int.parse(month.toString()) <
          int.parse((DateTime.now().month - 1).toString())) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
