import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/all_wallet_transaction_req/all_wallet_transaction_req_model.dart';
import '../../data/model/req_model/export_wallet_transaction/export_wallet_transactions_req_model.dart';
import '../../data/model/req_model/total_expense_req/total_expense_req_model.dart';
import '../../data/model/req_model/wallet_record_req/wallet_record_req_model.dart';
import '../../data/model/res_model/all_wallet_transaction_res/all_wallet_transaction_res_model.dart';
import '../../data/model/res_model/total_expense_res/total_expense_res_model.dart';
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

part 'wallet_bloc.freezed.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial()) {
    on<WalletEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _checkLanguage) {
        emit(state.copyWith(language: preferencesHelper.getAppLanguage()));
      } else if (event is _dropDownListEvent) {
        var date = new DateTime.now().toString();
        var dateParse = DateTime.parse(date);
        int formattedYear = dateParse.year.toInt();
        List<int> temp = [
          formattedYear,
          formattedYear - 1,
          formattedYear - 2,
          formattedYear - 3
        ];
        emit(state.copyWith(
          yearList: temp,
          year: temp.first,
          year1: temp.first,
        ));
      } else if (event is _getWalletRecordEvent) {
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
             //   orderThisMonth: response.data!.totalOrders!,
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
      } else if (event is _getTotalExpenseEvent) {
        try {
          TotalExpenseReqModel reqMap = TotalExpenseReqModel(
              userId: preferencesHelper.getUserId(), year: event.year);

          debugPrint('TotalExpenseReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.totalExpenseByYearUrl,
            data: reqMap,
          );

          debugPrint(
              'totalExpenseByYearUrl url  = ${AppUrls.totalExpenseByYearUrl}');
          TotalExpenseResModel response = TotalExpenseResModel.fromJson(res);
          debugPrint('TotalExpenseResModel  = $response');

          if (response.status == 200) {
            List<FlSpot> temp = [];
            List<int> number = List<int>.generate(12, (i) => i);

            number.reversed.toList();

            response.data!.forEach((element) {
              temp.add(FlSpot(number[element.month!.toInt() - 1].toDouble(),
                  element.totalExpenses!.toDouble()));
            });
            emit(state.copyWith(monthlyExpenseList: temp));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _getAllWalletTransactionEvent) {
        try {
          AllWalletTransactionReqModel reqMap = AllWalletTransactionReqModel(
            userId: preferencesHelper.getUserId(),
            //   userId: '654b8bc117ded10bbebf1fff',
            year: state.year,
            month: 1,
          );

          debugPrint('AllWalletTransactionReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.getAllWalletTransactionUrl,
            data: reqMap,
          );

          debugPrint(
              'AllWalletTransaction url  = ${AppUrls.getAllWalletTransactionUrl}');
          AllWalletTransactionResModel response =
              AllWalletTransactionResModel.fromJson(res);
          debugPrint('AllWalletTransactionResModel  = $response');

          if (response.status == 200) {
            /* if ((response.metaData?.totalFilteredCount ?? 0) > 0) {
             for (int i = 0; i < (response.data?.length ?? 0); i++) {

             }
           }*/
            emit(state.copyWith(balanceSheetList: response));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _getDateRangeEvent) {
        emit(state.copyWith(selectedDateRange: event.range));
      } else if (event is _getDropDownElementEvent) {
        emit(state.copyWith(year: event.year));
      }

      else if(event is _exportWalletTransactionEvent){
        try {

          ExportWalletTransactionsReqModel reqMap = ExportWalletTransactionsReqModel(
            userId: preferencesHelper.getUserId(),
           exportType: "PDF",
           responseType : "File",
          );

          debugPrint('ExportWalletTransactionsReqModel = $reqMap}');
          final response = await DioClient(event.context).post(
            AppUrls.exportWalletTransactionUrl,
            data: reqMap,
          );

          debugPrint(
              'exportWalletTransaction url  = ${AppUrls.exportWalletTransactionUrl}');
          debugPrint(
              'response export  = ${response}');

          final bytes = response.bodyBytes;
          // print(response.bodyBytes);
          var dir = await getTemporaryDirectory();
          File file = File(dir.path + "/data.pdf");
          await file.writeAsBytes(bytes, flush: true);





  /*        AllWalletTransactionResModel response =
          AllWalletTransactionResModel.fromJson(res);
          debugPrint('AllWalletTransactionResModel  = $response');

          if (response.status == 200) {
            *//* if ((response.metaData?.totalFilteredCount ?? 0) > 0) {
             for (int i = 0; i < (response.data?.length ?? 0); i++) {

             }
           }*//*
            emit(state.copyWith(balanceSheetList: response));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          }*/
        } on ServerException {}
      }
    });
  }





}
