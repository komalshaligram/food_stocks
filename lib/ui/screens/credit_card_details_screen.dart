import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/res_model/my_account_card_invoices_res_model/my_account_card_invoices_res_model.dart';
import '../../ui/utils/app_utils.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/widget/container_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/credit_card_details/credit_card_details_bloc.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
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
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    final MyCardInvoice? invoiceData = args?[AppStrings.invoiceData];
    final bool isFromInvoicePayment = args?[AppStrings.isFromInvoicePayment] ?? false;
    return BlocProvider(
      create: (context) => CreditCardDetailsBloc()
        ..add(CreditCardDetailsEvent.getArgumentEvent(
          isFromRegFlow: args?[AppStrings.isFromRegFlow] ?? false,
          termsReqModel: args?[AppStrings.termsConditionParamString] ?? const TermsConditionReqModel(),
          isPaymentFail: args?[AppStrings.isPaymentFail] ?? false,
          invoiceData: invoiceData,
        )),
      child: CreditCardDetailsScreenWidget(isPaymentToNext: args?[AppStrings.isPaymentToNext], invoiceData: invoiceData!, isFromInvoicePayment: isFromInvoicePayment),
    );
  }
}

class CreditCardDetailsScreenWidget extends StatelessWidget {
  CreditCardDetailsScreenWidget({super.key, required this.isPaymentToNext, required this.invoiceData, required this.isFromInvoicePayment});
  final bool isPaymentToNext;
  final MyCardInvoice invoiceData;
  final bool isFromInvoicePayment;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditCardDetailsBloc, CreditCardDetailsState>(builder: (context, state) {
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
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
              surfaceTintColor: AppColors.whiteColor,
              leading: GestureDetector(
                  onTap: () {
                    if (isFromInvoicePayment) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context, true);
                    }
                  },
                  child: Icon(Icons.arrow_back_ios, color: AppColors.blackColor)),
              title: Align(
                alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.credit_card_details, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
              ),
              backgroundColor: AppColors.whiteColor,
              titleSpacing: 0,
              elevation: 0),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.1),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  ContainerWidget(name: AppLocalizations.of(context)!.credit_card_number),
                  CustomFormField(
                    inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                    context: context,
                    controller: state.creditCardNumberController,
                    keyboardType: TextInputType.number,
                    hint: "",
                    fillColor: Colors.transparent,
                    textInputAction: TextInputAction.next,
                    validator: AppStrings.creditCardNumberString,
                  ),
                  7.height,
                  Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                      flex: 3,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        ContainerWidget(name: AppLocalizations.of(context)!.year),
                        CustomFormField(
                          inputFormat: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                          context: context,
                          controller: state.validityController,
                          keyboardType: TextInputType.number,
                          hint: "YY",
                          fillColor: Colors.transparent,
                          textInputAction: TextInputAction.done,
                          validator: AppStrings.creditCardValidityString,
                        ),
                      ]),
                    ),
                    10.width,
                    Expanded(
                      flex: 3,
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ContainerWidget(name: AppLocalizations.of(context)!.month),
                        CommonDropDownButton(
                          items: state.monthList.map((value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value.toString()));
                          }).toList(),
                          onChanged: (month) {
                            if (validateMonth(month.toString(), state.validityController.text.toString())) {
                              context.read<CreditCardDetailsBloc>().add(CreditCardDetailsEvent.selectMonthEvent(month: month ?? ''));
                            } else {
                              CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.select_valid_month, type: SnackBarType.failure);
                            }
                          },
                          value: state.selectedMonth,
                        ),
                      ]),
                    ),
                    Expanded(flex: 4, child: Container())
                  ]),
                ]),
              ),
            ),
          ),
          bottomSheet: Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.padding_30),
              child: CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
                bGColor: AppColors.mainColor,
                isLoading: state.isLoading,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (validateMonth(state.selectedMonth, state.validityController.text)) {
                      context.read<CreditCardDetailsBloc>().add(CreditCardDetailsEvent.addCreditCardEvent(
                            context: context,
                            isPaymentToNext: isPaymentToNext,
                            invoiceData: invoiceData.orderId != null ? invoiceData : const MyCardInvoice(),
                          ));
                    } else {
                      CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.select_valid_month, type: SnackBarType.failure);
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

  bool validateMonth(String month, String year) {
    if (DateTime.now().year.toString().substring(2, 4) == year) {
      if (int.parse(month.toString()) < int.parse((DateTime.now().month - 1).toString())) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
