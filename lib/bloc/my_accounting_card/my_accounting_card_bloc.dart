import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/my_account_card_invoices_res_model/my_account_card_invoices_res_model.dart';
import '../../data/model/res_model/my_account_card_refund_res_model/my_account_card_refund_res_model.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
part 'my_accounting_card_state.dart';
part 'my_accounting_card_event.dart';
part 'my_accounting_card_bloc.freezed.dart';

class MyAccountingCardBloc extends Bloc<MyAccountingCardEvent, MyAccountingCardState> {
  String clientId = '';

  MyAccountingCardBloc() : super(MyAccountingCardState.initial()) {
    on<MyAccountingCardEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getClientInvoicesFromRivchitDataEvent) {
        try {
          final String statusData = preferences.getPaymentStatusInfo();
          final List<StatusData> statusList = StatusData.decode(statusData);
          clientId = preferences.getUserId();
          emit(state.copyWith(statusList: statusList, language: preferences.getAppLanguage(), isShimmering: true));
          final fromInvoice = state.invoicesFrom ?? DateTime.now().subtract(const Duration(days: 90));
          final toInvoice = state.invoicesTo ?? DateTime.now();
          final resInvoice = await DioClient(event.context)
              .get(path: AppUrlEndPoints.getMyAccountingCardClientInvoicesFromRivchit + clientId, query: _dateRange(fromInvoice, toInvoice));
          MyAccountCardInvoicesResModel responseInvoice = MyAccountCardInvoicesResModel.fromJson(resInvoice);
          if (responseInvoice.status == AppConstants.code_200) {
            emit(state.copyWith(
                isShimmering: false,
                totalInvoiceAmount: responseInvoice.data?.totalOpenInvoiceAmount! ?? 0,
                clientBalance: responseInvoice.data?.clientBalance! ?? 0,
                invoiceCardList: responseInvoice.data?.invoices! ?? []));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(responseInvoice.message?.toLocalization() ?? responseInvoice.message!, event.context),
                type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        }
        final String statusData = preferences.getOrderStatusInfo();
        final List<StatusData> statusList = StatusData.decode(statusData);
        emit(state.copyWith(statusList: statusList, language: preferences.getAppLanguage()));
      } else if (event is _getClientRefundInvoicesFromRivchitDataEvent) {
        try {
          final String statusData = preferences.getPaymentStatusInfo();
          final List<StatusData> statusList = StatusData.decode(statusData);
          clientId = preferences.getUserId();
          emit(state.copyWith(statusList: statusList, language: preferences.getAppLanguage(), isShimmering: true));
          final fromRefund = state.refundsFrom ?? DateTime.now().subtract(const Duration(days: 90));
          final toRefund = state.refundsTo ?? DateTime.now();
          final resRefund = await DioClient(event.context)
              .get(path: AppUrlEndPoints.getMyAccountingCardClientRefundInvoicesFromRivchit + clientId, query: _dateRange(fromRefund, toRefund));
          MyAccountCardRefundResModel responseRefund = MyAccountCardRefundResModel.fromJson(resRefund);
          if (responseRefund.status == AppConstants.code_200) {
            emit(state.copyWith(
                isShimmering: false,
                totalRefundAmount: responseRefund.data?.totalOpenRefundInvoiceAmount ?? 0,
                clientBalance: responseRefund.data?.clientBalance! ?? 0,
                refundInvoicesCardList: responseRefund.data?.refundInvoices! ?? []));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(responseRefund.message?.toLocalization() ?? responseRefund.message!, event.context),
                type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        }
        final String statusData = preferences.getOrderStatusInfo();
        final List<StatusData> statusList = StatusData.decode(statusData);
        emit(state.copyWith(statusList: statusList, language: preferences.getAppLanguage()));
      } else if (event is _changeTab) {
        emit(state.copyWith(selectedTabIndex: event.index));
      } else if (event is _updateInvoicesDateRange) {
        emit(state.copyWith(invoicesFrom: event.from, invoicesTo: event.to, isShimmering: true, invoiceCardList: []));
        add(MyAccountingCardEvent.getClientInvoicesFromRivchitDataEvent(context: event.context));
      } else if (event is _updateRefundsDateRange) {
        emit(state.copyWith(refundsFrom: event.from, refundsTo: event.to));
        add(MyAccountingCardEvent.getClientRefundInvoicesFromRivchitDataEvent(context: event.context));
      }
    });
  }

  Map<String, String> _dateRange(DateTime from, DateTime to) {
    return {"fromDate": DateFormat('dd/MM/yyyy').format(from), "toDate": DateFormat('dd/MM/yyyy').format(to)};
  }
}
