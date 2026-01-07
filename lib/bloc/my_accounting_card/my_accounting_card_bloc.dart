import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/my_account_card_res/my_account_card_res_model.dart';
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

      if (event is _getRefundDataEvent) {
        try {
          final String statusData = preferences.getPaymentStatusInfo();
          final List<StatusData> statusList = StatusData.decode(statusData);

          printData("check here id ${preferences.getUserId()}");
          clientId = preferences.getUserId();

          emit(state.copyWith(
            statusList: statusList,
            language: preferences.getAppLanguage(),
            isShimmering: true,
          ));

          final res = await DioClient(event.context).get(path: AppUrlEndPoints.getMyAccountingCardClientInvoicesFromRivchit + clientId);

          MyAccountCardResModel response = MyAccountCardResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            printData("check here response ${response.toJson()}");

            emit(state.copyWith(
              isShimmering: false,
              clientBalance: response.data!.clientBalance!,
              totalInvoiceAmount: response.data!.totalOpenInvoiceAmount!,
              totalRefundAmount: response.data!.totalOpenRefundInvoiceAmount!,
              invoiceCardList: response.data!.invoices!,
              refundInvoicesCardList: response.data!.refundInvoices!,
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

        final String statusData = preferences.getOrderStatusInfo();
        final List<StatusData> statusList = StatusData.decode(statusData);
        emit(state.copyWith(statusList: statusList, language: preferences.getAppLanguage()));
      }
    });
    on<_changeTab>((event, emit) {
      emit(state.copyWith(selectedTabIndex: event.index));
    });
  }
}
