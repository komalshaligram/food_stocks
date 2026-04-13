import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/refund_invoice_req_model/refund_invoice_req_model.dart';
import '../../data/model/res_model/refund_invoice/refund_invoice_res_model.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'refund_pdf_state.dart';
part 'refund_pdf_event.dart';
part 'refund_pdf_bloc.freezed.dart';

class RefundPdfBloc extends Bloc<RefundPdfEvent, RefundPdfState> {
  RefundPdfBloc() : super(RefundPdfState.initial()) {
    on<_GetArgumentEvent>(_onGetArgument);
    on<_VerifyInvoiceLink>(_onVerifyInvoiceLink);
  }

  SharedPreferencesHelper? preferencesHelper;
  Future<void> _initPrefs() async {
    if (preferencesHelper == null) {
      final prefs = await SharedPreferences.getInstance();
      preferencesHelper = SharedPreferencesHelper(prefs: prefs);
    }
  }

  Future<void> _onGetArgument(
    _GetArgumentEvent event,
    Emitter<RefundPdfState> emit,
  ) async {
    await _initPrefs();

    emit(state.copyWith(invoiceDetailsList: event.invoiceDetailsList, hasValidLink: null));
    add(RefundPdfEvent.verifyInvoiceLink(context: event.context));
  }

  Future<void> _onVerifyInvoiceLink(_VerifyInvoiceLink event, Emitter<RefundPdfState> emit) async {
    await _initPrefs();
    final currentInvoice = state.invoiceDetailsList;
    if (currentInvoice == null) {
      emit(state.copyWith(hasValidLink: false));
      return;
    }

    final initialLink = currentInvoice.invoiceLink;
    if (isValidLink(initialLink)) {
      emit(state.copyWith(hasValidLink: true, invoiceDetailsList: currentInvoice.copyWith(invoiceLink: initialLink)));
      return;
    }

    try {
      final res = await DioClient(event.context).post(
        AppUrlEndPoints.getRefundInvoiceCopy,
        data: RefundInvoiceReqModel(
          clientId: preferencesHelper!.getUserId(),
          invoiceNumber: int.tryParse(currentInvoice.invoiceNumber ?? '') ?? 0,
          rivchitApiKey: currentInvoice.rivchitApiKey,
        ),
      );

      final response = RefundInvoiceResModel.fromJson(res);
      if (response.status == AppConstants.code_200 && isValidLink(response.data)) {
        emit(state.copyWith(hasValidLink: true, invoiceDetailsList: currentInvoice.copyWith(invoiceLink: response.data)));
      } else {
        emit(state.copyWith(hasValidLink: false, invoiceDetailsList: currentInvoice.copyWith(invoiceLink: "")));
      }
    } catch (_) {
      emit(state.copyWith(hasValidLink: false, invoiceDetailsList: currentInvoice.copyWith(invoiceLink: "")));
    }
  }

  bool isValidLink(String? link) {
    if (link == null) return false;
    final trimmed = link.trim();
    return trimmed.isNotEmpty && trimmed.toLowerCase() != "null";
  }
}
