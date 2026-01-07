import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/res_model/refund_res/refund_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'refund_state.dart';
part 'refund_event.dart';
part 'refund_bloc.freezed.dart';

class RefundBloc extends Bloc<RefundEvent, RefundState> {
  String screenTitleName = '';

  RefundBloc() : super(RefundState.initial()) {
    on<RefundEvent>((event, emit) async {
      SharedPreferencesHelper preferences =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getRefundDataEvent) {
        if (state.isBottomOfProducts) {
          return;
        }

        try {
          final String statusData = preferences.getPaymentStatusInfo();
          final List<StatusData> statusList = StatusData.decode(statusData);

          final args = ModalRoute.of(event.context)!.settings.arguments
          as Map<String, dynamic>;
          screenTitleName =
          args[AppStrings.invoiceTitleNameString] as String;

          emit(state.copyWith(
            statusList: statusList,
            language: preferences.getAppLanguage(),
            isShimmering: state.pageNum == 0 ? true : false,
          ));

          final res = await DioClient(event.context)
              .get(path: AppUrlEndPoints.clientRefundUrl + preferences.getUserId());

          RefundResModel response = RefundResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            List<RefundInvoiceCommon> invoiceDetailsList =
            state.invoiceDetailsList.toList(growable: true);

            /// NEW API: response.data is directly the list
            invoiceDetailsList.addAll(response.data!);

            /// No openTotalAmount in new API
            emit(state.copyWith(
              invoiceDetailsList: invoiceDetailsList,
              pageNum: state.pageNum + 1,
              isShimmering: false,
              // openTotalAmount: response.data?.totalOpenRefundAmount ?? '0', // or remove if not needed
            ));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                response.message?.toLocalization() ?? response.message!,
                event.context,
              ),
              type: SnackBarType.failure,
            );
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        }

        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();

        final String statusData = preferences.getOrderStatusInfo();
        final List<StatusData> statusList = StatusData.decode(statusData);
        emit(state.copyWith(statusList: statusList, language: preferences.getAppLanguage()));
      }

      // Pull-to-refresh
      else if (event is _refreshListEvent) {
        emit(state.copyWith(
          pageNum: 0,
          invoiceDetailsList: [],
          isBottomOfProducts: false,
        ));
        add(RefundEvent.getRefundDataEvent(context: event.context));
      }
    });
  }
}
