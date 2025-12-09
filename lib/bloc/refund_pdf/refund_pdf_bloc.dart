import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/refund_invoice_req_model/refund_invoice_req_model.dart';
import '../../data/model/res_model/refund_invoice/refund_invoice_res_model.dart';
import '../../data/model/res_model/refund_res/refund_res_model.dart';
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

    emit(
      state.copyWith(
        invoiceDetailsList: event.invoiceDetailsList,
        hasValidLink: null, // API loading / PDF loader
      ),
    );

    add(RefundPdfEvent.verifyInvoiceLink(context: event.context));
  }

  Future<void> _onVerifyInvoiceLink(
      _VerifyInvoiceLink event,
      Emitter<RefundPdfState> emit,
      ) async {
    await _initPrefs();

    final initialLink = state.invoiceDetailsList.invoiceLink;

    // 1️⃣ If initial link exists, just show PDF
    if (isValidLink(initialLink)) {
      emit(
        state.copyWith(
          hasValidLink: true,
          invoiceDetailsList: state.invoiceDetailsList.copyWith(invoiceLink: initialLink),
        ),
      );
      return;
    }

    // 2️⃣ Call API if link invalid or null
    try {
      final res = await DioClient(event.context).post(
        AppUrlEndPoints.getRefundInvoiceCopy,
        data: RefundInvoiceReqModel(
          clientId: preferencesHelper!.getUserId(),
          invoiceNumber: state.invoiceDetailsList.invoiceNumber,
          rivchitApiKey: state.invoiceDetailsList.rivchitApiKey,
        ),
      );

      final response = RefundInvoiceResModel.fromJson(res);

      if (response.status == AppConstants.code_200 && isValidLink(response.data)) {
        emit(
          state.copyWith(
            hasValidLink: true,
            invoiceDetailsList: state.invoiceDetailsList.copyWith(invoiceLink: response.data),
          ),
        );
        return;
      }

      // API returned no link
      emit(
        state.copyWith(
          hasValidLink: false,
          invoiceDetailsList: state.invoiceDetailsList.copyWith(invoiceLink: ""),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          hasValidLink: false,
          invoiceDetailsList: state.invoiceDetailsList.copyWith(invoiceLink: ""),
        ),
      );
    }
  }

  bool isValidLink(String? link) {
    if (link == null) return false;
    final trimmed = link.trim();
    return trimmed.isNotEmpty && trimmed.toLowerCase() != "null";
  }
}
