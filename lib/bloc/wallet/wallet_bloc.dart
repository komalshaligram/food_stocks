import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
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
import '../../data/model/res_model/total_expense_res/total_expense_res_model.dart'
    as expense;
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

part 'wallet_bloc.freezed.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial()) {
    on<WalletEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      var date = new DateTime.now().toString();
      var date1 = new DateTime.now();
      var dateParse = DateTime.parse(date.toString());
      DateTime firstDayCurrentMonth = DateTime.utc(DateTime.now().year, DateTime.now().month, 1);

      DateTime lastDayCurrentMonth = DateTime.utc(DateTime.now().year, DateTime.now().month + 1).subtract(Duration(days: 1));
      if (event is _checkLanguage) {
        emit(state.copyWith(language: preferencesHelper.getAppLanguage()));
      } else if (event is _getYearListEvent) {
        emit(state.copyWith(isShimmering: true));
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
        emit(state.copyWith(isProcess: true));
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
          //    debugPrint('WalletRecordResModel  = $response');

          if (response.status == 200) {
            emit(state.copyWith(
                thisMonthExpense:
                    response.data?.currentMonth?.totalExpenses?.toDouble() ?? 0,
                lastMonthExpense:
                    response.data?.previousMonth?.totalExpenses?.toDouble() ??
                        0,
                balance: response.data?.balanceAmount?.toDouble() ?? 0,
                totalCredit: response.data?.totalCredit?.toDouble() ?? 0,
                expensePercentage: double.parse(
                    response.data?.currentMonth?.expensePercentage ?? ''),
              isProcess: false
            ));
          } else {emit(state.copyWith(isProcess: false));}
        } on ServerException {
          emit(state.copyWith(isProcess: false));
        } catch (e) {emit(state.copyWith(isProcess: false));}
      } else if (event is _getTotalExpenseEvent) {
        print('year_____${event.year}');
        emit(state.copyWith(isGraphProcess: true));
        try {
          TotalExpenseReqModel reqMap = TotalExpenseReqModel(
            userId: preferencesHelper.getUserId(),
            year: event.year,
          );

          debugPrint('TotalExpenseReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.totalExpenseByYearUrl,
            data: reqMap,
          );

          debugPrint(
              'totalExpenseByYearUrl url  = ${AppUrls.totalExpenseByYearUrl}');
          expense.TotalExpenseResModel response =
              expense.TotalExpenseResModel.fromJson(res);
          //  debugPrint('TotalExpenseResModel  = $response');

          if (response.status == 200) {

            List<FlSpot> temp = [];
            List<int> number = List<int>.generate(12, (i) => i);
            List<int> reverseList;
            List<String> reverseList1;
            if (preferencesHelper.getAppLanguage() == 'he') {
              reverseList = number.reversed.toList();
            } else {
              reverseList = number.toList();
            }

            response.data?.forEach((element) {
              temp.add(FlSpot(
                  reverseList[element.month!.toInt() - 1].toDouble(),
                  element.totalExpenses?.toDouble() ?? 0));
            });
            List<String>graphList = [];
            response.data?.forEach((element) {
              graphList.add((
                  element.totalExpenses?.toString() ?? '0'));
            });

            if (preferencesHelper.getAppLanguage() == 'he') {
              reverseList1 = graphList.reversed.toList();
            } else {
              reverseList1 = graphList.toList();
            }

            emit(state.copyWith(monthlyExpenseList: temp,graphDataList: reverseList1));
            emit(state.copyWith(isGraphProcess: false));
          } else {
            emit(state.copyWith(isGraphProcess: false));

            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message?.toLocalization() ??
                      response.message!,
                  event.context),
              type: SnackBarType.FAILURE,
            );
          }

        } on ServerException {
          emit(state.copyWith(isGraphProcess: false));

        }
      } else if (event is _getAllWalletTransactionEvent) {
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
          AllWalletTransactionReqModel reqMap = AllWalletTransactionReqModel(
              userId: preferencesHelper.getUserId(),
              pageNum: state.pageNum + 1,
              pageLimit: AppConstants.walletLimit,
              startDate: event.startDate ?? firstDayCurrentMonth,
              endDate: event.endDate ?? lastDayCurrentMonth);

          debugPrint('AllWalletTransactionReqModel = $reqMap}');

          final res = await DioClient(event.context).post(
            AppUrls.getAllWalletTransactionUrl,
            data: reqMap,
          );

          debugPrint(
              'AllWalletTransaction url  = ${AppUrls.getAllWalletTransactionUrl}');
          AllWalletTransactionResModel response =
              AllWalletTransactionResModel.fromJson(res);
          // debugPrint('AllWalletTransactionResModel  = $response');

          if (response.status == 200) {
            //   debugPrint('[filter count]     ${response.metaData?.totalFilteredCount}');

            List<Datum> temp =
                state.walletTransactionsList.toList(growable: true);
            if ((response.metaData?.totalFilteredCount ?? 1) >
                state.walletTransactionsList.length) {
              temp.addAll(response.data ?? []);
              emit(state.copyWith(
                balanceSheetList: response,
                pageNum: state.pageNum + 1,
                walletTransactionsList: temp,
                isLoadMore: false,
                isShimmering: false,
              ));

              emit(state.copyWith(
                  isBottomOfProducts: temp.length ==
                          (response.metaData?.totalFilteredCount ?? 1)
                      ? true
                      : false));
            } else {
              emit(state.copyWith(isShimmering: false, isLoadMore: false));
            }
          } else {
            emit(state.copyWith(isLoadMore: false, isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false, isShimmering: false));
        }
      } else if (event is _getDateRangeEvent) {
        if (event.range != state.selectedDateRange) {
          List<Datum> temp =
              state.walletTransactionsList.toList(growable: true);
          temp.clear();
          emit(state.copyWith(
            selectedDateRange: event.range,
            walletTransactionsList: temp,
            pageNum: 0,
            isLoadMore: false,
            isShimmering: false,
          ));

          emit(state.copyWith(
              isBottomOfProducts: temp.length ==
                      (state.balanceSheetList.metaData?.totalFilteredCount ?? 1)
                  ? true
                  : false));
        } else {
          emit(state.copyWith(
              selectedDateRange: event.range,
              walletTransactionsList: state.walletTransactionsList,
              isLoadMore: false,
              isShimmering: false));
        }
      } else if (event is _getDropDownElementEvent) {
        emit(state.copyWith(year: event.year));
      } else if (event is _exportWalletTransactionEvent) {
        emit(state.copyWith(isExportShimmering: true));
        try {
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
            exportType: AppStrings.pdfString,
            responseType: AppStrings.jsonString,
            startDate: event.startDate.toString(),
            endDate: event.endDate.toString(),
          );

          debugPrint('ExportWalletTransactions  ReqModel = $reqMap}');
          final res = await DioClient(event.context)
              .post(AppUrls.exportWalletTransactionUrl, data: reqMap);

          debugPrint(
              'exportWalletTransaction url  = ${AppUrls.exportWalletTransactionUrl}');

          ExportWalletTransactionsResModel response =
              ExportWalletTransactionsResModel.fromJson(res);
          //   debugPrint('ExportWalletTransactions response  = ${response}');
          if (response.status == 200) {
            emit(state.copyWith(isExportShimmering: false));
            Uint8List pdf = base64.decode(response.data.toString());
            filePath =
                '${dir.path}/${preferencesHelper.getUserName()}${'.'}${(DateTime.now()).hour}${'.'}${(DateTime.now()).minute}${'.'}${DateTime.now().second}${'.pdf'}';
            file = File(filePath);
            // debugPrint('[path]   ${filePath}');
            await file.writeAsBytes(pdf.buffer.asUint8List()).then((value) {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.SUCCESS,
              );
            });
          } else {
            emit(state.copyWith(isExportShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message?.toLocalization() ??
                      response.message!,
                  event.context),
              type: SnackBarType.FAILURE,
            );
          }
        } on ServerException {
          emit(state.copyWith(isExportShimmering: false));
        } catch (e) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: e.toString(),
            type: SnackBarType.FAILURE,
          );
          emit(state.copyWith(isExportShimmering: false));
        }
      } else if (event is _getOrderCountEvent) {
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

          final res = await DioClient(event.context).post(
            AppUrls.getOrdersCountUrl,
            data: reqMap,
          );

          debugPrint('getOrdersCountUrl url  = ${AppUrls.getOrdersCountUrl}');
          GetOrderCountResModel response = GetOrderCountResModel.fromJson(res);
          //   debugPrint('getOrdersCount response  = ${response}');
          if (response.status == 200) {
            emit(state.copyWith(orderThisMonth: response.data!.toInt()));
          }
        } on ServerException {
        } catch (e) {}
      }
    });
  }
}
