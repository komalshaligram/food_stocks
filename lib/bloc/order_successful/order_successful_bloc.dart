
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/wallet_record_req/wallet_record_req_model.dart';
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_urls.dart';



part 'order_successful_event.dart';

part 'order_successful_state.dart';

part 'order_successful_bloc.freezed.dart';

class OrderSuccessfulBloc extends Bloc<OrderSuccessfulEvent, OrderSuccessfulState> {
  OrderSuccessfulBloc() : super(OrderSuccessfulState.initial()) {
    on<OrderSuccessfulEvent>((event, emit) async {
      if (event is _getWalletRecordEvent) {
        SharedPreferencesHelper preferencesHelper =
        SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
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
                thisMonthExpense: response.data!.currentMonth!.totalExpenses!,
              //  orderThisMonth: response.data!.totalOrders!,
                lastMonthExpense: response.data!.previousMonth!.totalExpenses!,
                balance: response.data!.balanceAmount!,
                totalCredit: response.data!.totalCredit!));
            //    showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      }


    });
  }
}

