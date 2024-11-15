import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/invoices/invoices_req_model.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'invoice_state.dart';
part 'invoice_event.dart';
part 'invoice_bloc.freezed.dart';


class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceState.initial()) {
    on<InvoiceEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());



      if (event is _getInvoicesDataEvent) {

        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfProducts) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          InvoicesReqModel request =
          InvoicesReqModel(
            pageLimit: AppConstants.recommendationProductPageLimit,
            pageNum: state.pageNum + 1,
            id: preferences.getUserId()
          );

          debugPrint('Invoices req = ${request.toJson()}');
          final res = await DioClient(event.context)
              .post(AppUrlEndPoints.clientInvoicesUrl,
              data: request.toJson(),
           );
          InvoicesResModel response =
          InvoicesResModel.fromJson(res);
          debugPrint('Invoices res = ${response.data}');
          if (response.status == 200) {
            List<Invoice> invoiceDetailsList =
            state.invoiceDetailsList.toList(growable: true);
            invoiceDetailsList.addAll(response.data?.invoices ?? []);
            emit(state.copyWith(
                invoiceDetailsList: invoiceDetailsList,
                pageNum: state.pageNum + 1,
                isShimmering: false,
                isLoadMore: false));
            emit(state.copyWith(
                isBottomOfProducts: state.invoiceDetailsList.length >=
                    (response.data?.totalRecords ?? 0)
                    ? true
                    : false));
          } else {
            emit(state.copyWith(isLoadMore: false,isShimmering : false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false , isShimmering : false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      }

      else if (event is _refreshListEvent) {
        emit(state.copyWith(
            pageNum: 0,
            invoiceDetailsList : [],
            isBottomOfProducts: false));
        add(InvoiceEvent.getInvoicesDataEvent(
            context: event.context));
      }

    });
  }
}