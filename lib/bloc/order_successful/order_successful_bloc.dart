import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/get_order_count/get_order_count_req_model.dart';
import '../../data/model/req_model/wallet_record_req/wallet_record_req_model.dart';
import '../../data/model/res_model/order_count/get_order_count_res_model.dart';
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'order_successful_event.dart';

part 'order_successful_state.dart';

part 'order_successful_bloc.freezed.dart';

class OrderSuccessfulBloc
    extends Bloc<OrderSuccessfulEvent, OrderSuccessfulState> {

  OrderSuccessfulBloc() : super(OrderSuccessfulState.initial()) {
    on<OrderSuccessfulEvent>((event, emit) async {

      if (event is _getWalletRecordEvent) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        try {
          WalletRecordReqModel reqMap =
              WalletRecordReqModel(userId: preferencesHelper.getUserId());
          debugPrint('WalletRecordReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.walletRecordUrl,
            data: reqMap,
          );

          debugPrint('WalletRecord url  = ${AppUrls.walletRecordUrl}');
          WalletRecordResModel response = WalletRecordResModel.fromJson(res);
          debugPrint('WalletRecordResModel  = $response');

          if (response.status == 200) {
            emit(state.copyWith(
                thisMonthExpense: response.data?.currentMonth?.totalExpenses?.toDouble() ?? 0,
                lastMonthExpense: response.data?.previousMonth?.totalExpenses?.toDouble() ?? 0,
                balance: response.data?.balanceAmount?.toDouble() ?? 0,
                totalCredit: response.data?.totalCredit?.toDouble() ?? 0,
                expensePercentage : double.parse(response.data?.currentMonth!.expensePercentage ?? '')
            ));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE);
          }
        } on ServerException {}
      }

      if(event is _getOrderCountEvent){
        try {
          int daysInMonth(DateTime date) => DateTimeRange(
              start: DateTime(date.year, date.month, 1),
              end: DateTime(date.year, date.month + 1))
              .duration
              .inDays;

          var now = DateTime.now();

          GetOrderCountReqModel reqMap = GetOrderCountReqModel(
            startDate: DateTime(now.year, now.month, 1),
            endDate: DateTime(now.year, now.month, daysInMonth(DateTime.now())),
          );

          debugPrint('getOrdersCount reqMap = $reqMap}');

          final res =
          await DioClient(event.context).post(AppUrls.getOrdersCountUrl,
            data: reqMap,
          );

          debugPrint('getOrdersCountUrl url  = ${AppUrls.getOrdersCountUrl}');
          GetOrderCountResModel response = GetOrderCountResModel.fromJson(res);
          debugPrint('getOrdersCount response  = ${response}');

          if (response.status == 200) {
            emit(state.copyWith(orderThisMonth: response.data!.toInt()));
          }
        } on ServerException {}
      }

      if(event is _celebrationEvent){

        await Future.delayed(const Duration(milliseconds: 2000));
          emit(state.copyWith(duringCelebration:false ));
      }
    });
  }
}
