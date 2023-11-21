import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/all_wallet_transaction_req/all_wallet_transaction_req_model.dart';
import '../../data/model/req_model/export_wallet_transaction/export_wallet_transactions_req_model.dart';
import '../../data/model/req_model/get_order_count/get_order_count_req_model.dart';
import '../../data/model/req_model/total_expense_req/total_expense_req_model.dart';
import '../../data/model/req_model/wallet_record_req/wallet_record_req_model.dart';
import '../../data/model/res_model/all_wallet_transaction_res/all_wallet_transaction_res_model.dart';
import '../../data/model/res_model/export_wallet_res/export_wallet_transactions_res_model.dart';
import '../../data/model/res_model/order_count/get_order_count_res_model.dart';
import '../../data/model/res_model/total_expense_res/total_expense_res_model.dart' as expense;
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
      } else if (event is _getYearListEvent) {
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
                lastMonthExpense: response.data!.previousMonth!.totalExpenses!,
                balance: response.data!.balanceAmount!,
                totalCredit: response.data!.totalCredit!));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      }
      else if (event is _getTotalExpenseEvent) {
        try {
          TotalExpenseReqModel reqMap = TotalExpenseReqModel(
              userId: preferencesHelper.getUserId(), year: event.year,
          );

          debugPrint('TotalExpenseReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.totalExpenseByYearUrl,
            data: reqMap,
          );

          debugPrint(
              'totalExpenseByYearUrl url  = ${AppUrls.totalExpenseByYearUrl}');
          expense.TotalExpenseResModel response = expense.TotalExpenseResModel.fromJson(res);
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
      }
      else if (event is _getAllWalletTransactionEvent) {
        emit(state.copyWith(
            isShimmering: state.pageNum == 0 ? true : false,
            isLoadMore: state.pageNum == 0 ? false : true));

        try {

          AllWalletTransactionReqModel reqMap = AllWalletTransactionReqModel(
            userId: preferencesHelper.getUserId(),
            pageNum: state.pageNum + 1,
            pageLimit: 5,
            startDate: event.startDate,
            endDate: event.endDate
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
            List<Datum>temp = state.walletTransactionsList.toList(growable: true);
            if ((response.metaData?.totalFilteredCount ?? 0) >
                state.walletTransactionsList.length){
              temp.addAll(response.data ?? []);
              emit(state.copyWith(balanceSheetList: response,pageNum: state.pageNum + 1 ,walletTransactionsList: temp,
                  isLoadMore: false,isShimmering: false
              ));
            }
          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
            emit(state.copyWith(isLoadMore: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
      } else if (event is _getDateRangeEvent) {
        emit(state.copyWith(selectedDateRange: event.range));
      } else if (event is _getDropDownElementEvent) {
        emit(state.copyWith(year: event.year));
      }
      else if (event is _exportWalletTransactionEvent) {
        try {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.storage,
          ].request();

          File file;
          Directory dir;
          String filePath = '';
          if (defaultTargetPlatform == TargetPlatform.android) {
            dir = Directory('/storage/emulated/0/Documents');
          } else {
            dir = await getApplicationDocumentsDirectory();
          }

          ExportWalletTransactionsReqModel reqMap =
              ExportWalletTransactionsReqModel(
            userId: preferencesHelper.getUserId(),
            exportType: "PDF",
            responseType: "JSON",
          );

          debugPrint('ExportWalletTransactions  ReqModel = $reqMap}');
          final res = await DioClient(event.context)
              .post(AppUrls.exportWalletTransactionUrl, data: reqMap);

          debugPrint(
              'exportWalletTransaction url  = ${AppUrls.exportWalletTransactionUrl}');

          ExportWalletTransactionsResModel response =
              ExportWalletTransactionsResModel.fromJson(res);
          debugPrint('ExportWalletTransactions response  = ${response}');
          if (response.status == 200) {
            Uint8List pdf = base64.decode(response.data.toString());
            filePath =
                '${dir.path}/${preferencesHelper.getUserName()}${'_'}${TimeOfDay.fromDateTime(DateTime.now()).hour}${'.'}${TimeOfDay.fromDateTime(DateTime.now()).minute}${'.pdf'}';
            file = File(filePath);
            debugPrint('path______${filePath}');
            await file.writeAsBytes(pdf.buffer.asUint8List()).then((value) {
              showSnackBar(
                  context: event.context,
                  title: response.message!,
                  bgColor: AppColors.mainColor);
            });
          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      }
      else if (event is _getOrderCountEvent) {
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
                  options: Options(
                    headers: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${preferencesHelper.getAuthToken()}',
                    },
                  ));

          debugPrint('getOrdersCountUrl url  = ${AppUrls.getOrdersCountUrl}');
          GetOrderCountResModel response = GetOrderCountResModel.fromJson(res);
          debugPrint('getOrdersCount response  = ${response}');
          if (response.status == 200) {
            emit(state.copyWith(orderThisMonth: response.data!.toInt()));
          }
        } on ServerException {}
      }
    });
  }
}
