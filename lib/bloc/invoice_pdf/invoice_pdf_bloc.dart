import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/refund_invoice_req_model/refund_invoice_req_model.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/model/res_model/refund_invoice/refund_invoice_res_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'invoice_pdf_state.dart';
part 'invoice_pdf_event.dart';
part 'invoice_pdf_bloc.freezed.dart';

class InvoicePdfBloc extends Bloc<InvoicePdfEvent, InvoicePdfState> {
  InvoicePdfBloc() : super(InvoicePdfState.initial()) {
    on<_getArgumentEvent>(_onGetArgument);
    on<_VerifyInvoiceLink>(_onVerifyInvoiceLink);
  }

  String screenTitleName = '';
  SharedPreferencesHelper? preferencesHelper;

  Future<void> _initPrefs() async {
    if (preferencesHelper == null) {
      final prefs = await SharedPreferences.getInstance();
      preferencesHelper = SharedPreferencesHelper(prefs: prefs);
    }
  }

  /// ---------------------------
  /// 1️⃣ Handle arguments
  /// ---------------------------
  Future<void> _onGetArgument(
      _getArgumentEvent event,
      Emitter<InvoicePdfState> emit,
      ) async {
    await _initPrefs();

    final args =
    ModalRoute.of(event.context)!.settings.arguments as Map<String, dynamic>;

    screenTitleName =
    args[AppStrings.invoiceTitleNameString] as String;

    final String statusData = preferencesHelper!.getOrderStatusInfo();
    final List<StatusData> statusList = StatusData.decode(statusData);

    emit(
      state.copyWith(
        invoiceDetailsList: event.invoiceDetailsList,
        statusList: statusList,
        hasValidLink: null, // loading state
      ),
    );

    printData("check here ${event.invoiceDetailsList.toJson()}");

    add(InvoicePdfEvent.verifyInvoiceLink(context: event.context));
  }

  /// ---------------------------
  /// 2️⃣ Verify / fetch invoice PDF link
  /// ---------------------------
  Future<void> _onVerifyInvoiceLink(
      _VerifyInvoiceLink event,
      Emitter<InvoicePdfState> emit,
      ) async {
    await _initPrefs();

    final initialLink = state.invoiceDetailsList.invoiceLink;

    // 1️⃣ If link already valid → show PDF
    if (isValidLink(initialLink)) {
      emit(
        state.copyWith(
          hasValidLink: true,
          invoiceDetailsList:
          state.invoiceDetailsList.copyWith(invoiceLink: initialLink),
        ),
      );
      return;
    }

    // 2️⃣ Call API if link is invalid or missing
    try {
      final res = await DioClient(event.context).post(
        AppUrlEndPoints.getRefundInvoiceCopy,
        data: RefundInvoiceReqModel(
          clientId: preferencesHelper!.getUserId(),
          invoiceNumber:
          int.parse(state.invoiceDetailsList.invoiceNumber.toString()),
          rivchitApiKey: state.invoiceDetailsList.rivchitApiKey,
        ),
      );

      final response = RefundInvoiceResModel.fromJson(res);

      if (response.status == AppConstants.code_200 &&
          isValidLink(response.data)) {
        emit(
          state.copyWith(
            hasValidLink: true,
            invoiceDetailsList: state.invoiceDetailsList
                .copyWith(invoiceLink: response.data),
          ),
        );
        return;
      }

      // API returned no valid link
      emit(
        state.copyWith(
          hasValidLink: false,
          invoiceDetailsList:
          state.invoiceDetailsList.copyWith(invoiceLink: ""),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          hasValidLink: false,
          invoiceDetailsList:
          state.invoiceDetailsList.copyWith(invoiceLink: ""),
        ),
      );
    }
  }

  /// ---------------------------
  /// Helper
  /// ---------------------------
  bool isValidLink(String? link) {
    if (link == null) return false;
    final trimmed = link.trim();
    return trimmed.isNotEmpty && trimmed.toLowerCase() != "null";
  }
}
