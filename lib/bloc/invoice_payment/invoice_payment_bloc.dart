import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'invoice_payment_state.dart';
part 'invoice_payment_event.dart';
part 'invoice_payment_bloc.freezed.dart';

class InvoicePaymentBloc extends Bloc<InvoicePaymentEvent, InvoicePaymentState> {
  String screenTitleName = '';

  InvoicePaymentBloc() : super(InvoicePaymentState.initial()) {
    on<InvoicePaymentEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getStatusDataEvent) {
        final String statusData = preferences.getOrderStatusInfo();
        final List<StatusData> statusList = StatusData.decode(statusData);
        emit(state.copyWith(statusList: statusList, language: preferences.getAppLanguage()));
      } else if (event is _addCreditCardEvent) {
        emit(state.copyWith(isLoading: true));

        try {
          final payInvoiceCreditCardRequest = {
            "supplierId": event.supplierId,
            "invoiceNumber": event.invoiceNumber,
            if ((event.orderId ?? '').trim().isNotEmpty && event.orderId != 'null' && event.orderId != null) "orderId": event.orderId,
          };
          // PayInvoiceCreditCardRequestModel reqMap = PayInvoiceCreditCardRequestModel(orderId: event.orderId == null ? , invoiceNumber: event.invoiceNumber);
          final res = await DioClient(event.context).post(AppUrlEndPoints.payInvoiceByCreditCard, data: payInvoiceCreditCardRequest);
          if (res[AppStrings.statusString] == AppConstants.code_200) {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.credit_card_payment_success, type: SnackBarType.success);
            Navigator.pop(event.context, true);
          } else {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.credit_card_payment_error, type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        } catch (e) {
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}
