import 'package:flutter/material.dart';
import '../../utils/constants/app_strings.dart';
import '../../../bloc/basket_summary/basket_summary_bloc.dart';
import 'common_dialog_with_one_button.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../../data/model/res_model/my_account_card_invoices_res_model/my_account_card_invoices_res_model.dart';
import '../../widget/dialogs/bank_transfer_dialog.dart';
import '../../../routes/app_routes.dart';

threeOptionPaymentDialog(BuildContext context, BasketSummaryState state, BasketSummaryBloc bloc, BuildContext context1) {
  return CustomOneButtonDialog(
      width: MediaQuery.of(context).size.width,
      title: state.errorString,
      subTitle: AppLocalizations.of(context)!.payment_dialog_option_title,
      directionality: state.language,
      positiveTitle: state.paymentTypesList.any((e) => e == AppStrings.creditCard)
          ? state.isPaymentFail && !state.isWalletRelatedError
              ? AppLocalizations.of(context)!.change_credit_card
              : AppLocalizations.of(context)!.pay_with_credit_card
          : null,
      positiveOnTap: () {
        Navigator.pop(context);
        if (state.isPaymentFail &&
            state.errorString != AppStrings.getLocalizedStrings(AppLocalizations.of(context)!.credit_card_not_found, context)) {
          bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.creditCard));
        } else {
          Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name,
              arguments: {AppStrings.isPaymentFail: state.isPaymentFail, AppStrings.invoiceData: const MyCardInvoice()});
        }
      },
      positiveOnTap1: () {
        Navigator.pop(context);
        if (state.isPaymentFail && state.bankTransferInfo.isNotEmpty) {
          bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.wallet));
        } else {
          Navigator.pushNamed(context1, RouteDefine.bankInfoScreen.name, arguments: {AppStrings.isPaymentFail: false, AppStrings.updateString: true});
        }
      },
      positiveOnTap2: () {
        Navigator.pop(context);
        bankTransferDialog(
            context: context1,
            language: state.language,
            text: state.bankTransferInfo,
            function: () {
              bloc.add(BasketSummaryEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: false));
            });
      },
      positiveOnTap3: () {
        Navigator.pop(context);
        bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.bankCheck));
      },
      positiveTitle1: state.paymentTypesList.any((e) => e == AppStrings.wallet) ? AppLocalizations.of(context)!.change_to_wallet_payment : null,
      positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
      positiveTitle3: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null);
}
