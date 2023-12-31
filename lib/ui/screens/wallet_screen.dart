import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/wallet/wallet_bloc.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/wallet_screen_shimmer_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/balance_indicator.dart';
import '../widget/circular_button_widget.dart';
import '../widget/dashboard_stats_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class WalletRoute {
  static Widget get route => const WalletScreen();
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc()
        ..add(WalletEvent.getYearListEvent())
        ..add(WalletEvent.getWalletRecordEvent(context: context))
        ..add(WalletEvent.getOrderCountEvent(context: context))
      ..add(WalletEvent.checkLanguage()),
      child: WalletScreenWidget(),
    );
  }
}

class WalletScreenWidget extends StatefulWidget {
  WalletScreenWidget({Key? key}) : super(key: key);

  @override
  State<WalletScreenWidget> createState() => _WalletScreenWidgetState();
}

class _WalletScreenWidgetState extends State<WalletScreenWidget> with SingleTickerProviderStateMixin{
  DateRange? selectedDateRange;

  DateTime? minDate;

  DateTime? startDate;

  DateTime? endDate;



  @override
  Widget build(BuildContext context) {

    Map<int, String> monthMap = {
      0: AppLocalizations.of(context)!.dec,
      1: AppLocalizations.of(context)!.nov,
      2: AppLocalizations.of(context)!.oct,
      3: AppLocalizations.of(context)!.sep,
      4: AppLocalizations.of(context)!.aug,
      5: AppLocalizations.of(context)!.jul,
      6: AppLocalizations.of(context)!.jun,
      7: AppLocalizations.of(context)!.may,
      8: AppLocalizations.of(context)!.apr,
      9: AppLocalizations.of(context)!.mar,
      10: AppLocalizations.of(context)!.feb,
      11: AppLocalizations.of(context)!.jan,
    };

    Map<int, String> monthMap1 = {
      0: AppLocalizations.of(context)!.december,
      1: AppLocalizations.of(context)!.november,
      2: AppLocalizations.of(context)!.october,
      3: AppLocalizations.of(context)!.september,
      4: AppLocalizations.of(context)!.august,
      5: AppLocalizations.of(context)!.july,
      6: AppLocalizations.of(context)!.jun,
      7: AppLocalizations.of(context)!.may,
      8: AppLocalizations.of(context)!.april,
      9: AppLocalizations.of(context)!.march,
      10: AppLocalizations.of(context)!.february,
      11: AppLocalizations.of(context)!.january,
    };

    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {},
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          WalletBloc bloc = context.read<WalletBloc>();
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: FocusDetector(
              onFocusGained: () {
                  if((state.walletTransactionsList.length) == 0){
                 bloc.add(
                      WalletEvent.getAllWalletTransactionEvent(
                        context: context,
                        endDate: endDate,
                        startDate: startDate,
                      ));
                 bloc.add(WalletEvent.getWalletRecordEvent(context: context));
               }
                bloc.add(WalletEvent.getTotalExpenseEvent(
                    year: state.year, context: context));
                bloc.add(WalletEvent.getDropDownElementEvent(
                    year: state.yearList.first));
                minDate = DateTime(state.yearList.last, 1, 1);

              },
              child: SafeArea(
                child: NotificationListener<ScrollNotification>(
                  child: SingleChildScrollView(
                    physics: state.walletTransactionsList.isEmpty ? NeverScrollableScrollPhysics(): AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        45.height,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_15),
                          child: Container(
                            width: getScreenWidth(context),
                            clipBehavior: Clip.hardEdge,
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding_10,
                                horizontal: AppConstants.padding_10),
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor
                                          .withOpacity(0.15),
                                      blurRadius: AppConstants.blur_10)
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppConstants.radius_10))),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .balance_status,
                                          style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont,
                                            color: AppColors.blackColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        6.height,
                                        BalanceIndicator(
                                          pendingBalance: formatter(state.balance.toString()),
                                          expense: state.expensePercentage,
                                          totalBalance: 100
                                        ),
                                      ],
                                    )),
                                5.width,
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: DashBoardStatsWidget(
                                                context: context,
                                                image: AppImagePath.credits,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .total_credit,
                                                value:
                                                    '${formatter(state.totalCredit.toString())}${AppLocalizations.of(context)!.currency}'),
                                          ),
                                          10.width,
                                          Flexible(
                                            child: DashBoardStatsWidget(
                                                context: context,
                                                image: AppImagePath.expense,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .this_months_expenses,
                                                value:
                                                    '${formatter(state.thisMonthExpense.toString())}${AppLocalizations.of(context)!.currency}'),
                                          ),
                                        ],
                                      ),
                                      10.height,
                                      Row(
                                        children: [
                                          Flexible(
                                            child: DashBoardStatsWidget(
                                                context: context,
                                                image: AppImagePath.expense,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .last_months_expenses,
                                                value:
                                                    '${formatter(state.lastMonthExpense.toString())}${AppLocalizations.of(context)!.currency}'),
                                          ),
                                          10.width,
                                          Flexible(
                                            child: DashBoardStatsWidget(
                                                context: context,
                                                image: AppImagePath.orders,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .this_months_orders,
                                                value:
                                                    '${state.orderThisMonth}'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        30.height,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .monthly_expense_graph,
                                style: AppStyles.rkRegularTextStyle(
                                    size: /*  state.language == AppStrings.englishString
                                        ? AppConstants.font_14
                                        : */
                                        AppConstants.smallFont,
                                    color: AppColors.blackColor),
                              ),
                              dropDownWidget(
                                  date: state.year,
                                  dateList: state.yearList,
                                  context1: context),
                            ],
                          ),
                        ),
                        30.height,
                        state.monthlyExpenseList.isEmpty
                            ? WalletScreenShimmerWidget()
                            : Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: getScreenHeight(context) * 0.21,
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: LineChart(
                                        LineChartData(
                                        borderData: FlBorderData(show: false),
                                        lineTouchData: LineTouchData(
                                          enabled: true,
                                          touchTooltipData: LineTouchTooltipData(
                                                fitInsideHorizontally: true,
                                            getTooltipItems: (value) {
                                              return value.map((e) {
                                                return LineTooltipItem(
                                                    "${monthMap1[e.x]} ${state.year} ${AppLocalizations.of(context)!.total}: ${e.y}${AppLocalizations.of(context)!.currency}",
                                                    TextStyle(fontSize: 8));
                                              }).toList();
                                            },
                                            tooltipBgColor: Colors.transparent,
                                            showOnTopOfTheChartBoxArea: false,
                                            tooltipMargin: 3,
                                            tooltipPadding: EdgeInsets.only(bottom: 6)
                                          ),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: state.monthlyExpenseList,
                                            color: AppColors.mainColor
                                                .withOpacity(0.8),
                                            isCurved: false,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  AppColors.graphColor
                                                      .withOpacity(0.2),
                                                  AppColors.graphColor
                                                      .withOpacity(0.01),
                                                ],
                                              ),
                                              cutOffY: 0.0,
                                              applyCutOffY: false,
                                            ),
                                            dotData: FlDotData(
                                              show: false,
                                            ),
                                          ),
                                        ],
                                        minY: 0,
                                        gridData: FlGridData(show: false),
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: ((value, meta) {
                                                String? month = monthMap[value];
                                                return Text(
                                                  month.toString(),
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                    size: AppConstants.font_8,
                                                    color: AppColors
                                                        .navSelectedColor,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        15.height,
                        20.width,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: getScreenWidth(context) <= 370 ? 2:3,
                                child: Text(
                                  AppLocalizations.of(context)!.history,
                                  style: AppStyles.rkRegularTextStyle(
                                      size:  getScreenWidth(context) <= 370 ? AppConstants.font_14 : AppConstants.smallFont,
                                      color: AppColors.blackColor),
                                ),
                              ),
                              2.width,
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () async {
                                    Map<Permission, PermissionStatus>
                                    statuses = await [
                                      Permission.storage,
                                    ].request();

                                    if (Platform.isAndroid) {
                                      DeviceInfoPlugin deviceInfo =
                                      DeviceInfoPlugin();
                                      AndroidDeviceInfo androidInfo =
                                      await deviceInfo.androidInfo;
                                      print(
                                          'Running on android version ${androidInfo.version.sdkInt}');
                                      if (androidInfo.version.sdkInt < 33) {
                                        if (!statuses[Permission.storage]!
                                            .isGranted) {
                                          CustomSnackBar.showSnackBar(
                                              context: context,
                                              title:
                                                  '${AppLocalizations.of(context)!.storage_permission}',
                                              type: SnackBarType.FAILURE);
                                          return;
                                        }
                                      }
                                    } else {
                                      //for ios permission
                                    }

                                    state.walletTransactionsList.isNotEmpty ? bloc.add(WalletEvent
                                        .exportWalletTransactionEvent(
                                      context: context,
                                      startDate: startDate ?? DateTime.now(),
                                      endDate: endDate ?? DateTime.now(),


                                    )) : SizedBox();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_5,
                                        horizontal: AppConstants.padding_3),
                                    decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.radius_3)),
                                    child: state.isExportShimmering ? CupertinoActivityIndicator(color: Colors.white,):Text(
                                      AppLocalizations.of(context)!.export,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: state.language == AppStrings.englishString ?  AppConstants.font_12 : AppConstants.font_14,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                              5.width,
                              Expanded(
                                flex: 9,
                                child: Container(
                                  height: 45,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:AppConstants.padding_5,
                                        vertical: AppConstants.padding_5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radius_7),
                                      border: Border.all(
                                          color: AppColors.borderColor),
                                      color: AppColors.whiteColor,
                                    ),
                                    child: DateRangeField(
                                      decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        prefixIcon: Icon(
                                            Icons.keyboard_arrow_down),
                                        contentPadding: EdgeInsets.all(0),

                                      ),
                                      showDateRangePicker: (
                                          {required pickerBuilder,
                                            required widgetContext,
                                          }) {
                                        return showDateRangePickerDialog(
                                          context: context,
                                          offset: Offset(65, 200),
                                          barrierColor: AppColors
                                              .whiteColor
                                              .withOpacity(0.6),
                                          builder: datePickerBuilder,
                                        );

                                      },
                                      onDateRangeSelected:
                                          (DateRange? value) {
                                        startDate = value?.start;
                                        endDate = value?.end;

                                        if (value == null) {
                                          selectedDateRange =
                                              state.selectedDateRange;
                                          bloc.add(
                                              WalletEvent.getDateRangeEvent(
                                                  context: context,
                                                  range: state.selectedDateRange));
                                        } else {
                                          selectedDateRange = value;
                                          bloc.add(
                                              WalletEvent.getDateRangeEvent(
                                                  context: context,
                                                  range: value));

                                          bloc.add(WalletEvent
                                              .getAllWalletTransactionEvent(
                                            context: context,
                                            endDate: value.end,
                                            startDate: value.start,
                                          ));
                                        }
                                      },
                                      selectedDateRange: state.selectedDateRange,
                                      pickerBuilder: (BuildContext context,
                                          dynamic Function(DateRange?)
                                          onDateRangeChanged) {
                                        return Text('');
                                      },
                                      // pickerBuilder: datePickerBuilder,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        10.height,
                        Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(bottom: getScreenHeight(context) * 0.12),
                              child: state.isShimmering
                                  ? OrderSummaryScreenShimmerWidget()
                                  : state.walletTransactionsList.length != 0
                                      ? ListView.builder(
                                          itemCount: state
                                              .walletTransactionsList.length,
                                          // scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              color: AppColors.whiteColor,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: AppConstants
                                                            .padding_10,
                                                        horizontal: AppConstants
                                                            .padding_15),
                                                    child: listWidget(
                                                        context: context,
                                                        listIndex: index),
                                                  ),
                                                  Container(
                                                    width: double.maxFinite,
                                                    height: 1,
                                                    color:
                                                        AppColors.borderColor,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          height: getScreenHeight(context) >= 725 ?  getScreenHeight(context) /5 :getScreenHeight(context)/9,
                                          child: Center(
                                              child: Text(
                                                AppLocalizations.of(context)!.no_data,
                                            style: AppStyles.pVRegularTextStyle(
                                                size: AppConstants.normalFont,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                        ),
                            ),
                            state.isLoadMore
                                ? OrderSummaryScreenShimmerWidget(itemCount: 2)
                                : 0.width,
                          ],
                        ),
                      ],
                    ),
                  ),
                  onNotification: (notification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                        if ((state.balanceSheetList.metaData
                            ?.totalFilteredCount ?? 1) >
                            state.walletTransactionsList.length) {
                          context.read<WalletBloc>().add(
                              WalletEvent.getAllWalletTransactionEvent(
                                context: context,
                                startDate: startDate,
                                endDate: endDate,
                              ));
                        } else {
                          return false;
                        }
                    }
                    return true;
                  },

                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dropDownWidget(
      {required int date,
      required List<int> dateList,
      required BuildContext context1}) {
    WalletBloc bloc = context1.read<WalletBloc>();
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.padding_5,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radius_7),
        border: Border.all(color: AppColors.borderColor),
        color: AppColors.whiteColor,
      ),
      child: DropdownButton<int>(
        icon: Padding(
          padding: const EdgeInsets.only(left: AppConstants.padding_3),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.blackColor,
          ),
        ),
        elevation: 0,
        isDense: true,
        value: date,
    underline: SizedBox(),
    borderRadius: BorderRadius.all(Radius.zero),
        padding: EdgeInsets.all(5),
        dropdownColor: AppColors.whiteColor,
       alignment: Alignment.bottomCenter,
        items: dateList.map((e) {
          return DropdownMenuItem<int>(
            value: e,
            child: Text(e.toString(),
                style:
                    AppStyles.rkRegularTextStyle(size: AppConstants.font_12)),
          );
        }).toList(),
        onChanged: (value) {
          bloc.add(WalletEvent.getDropDownElementEvent(year: value!));
          bloc.add(
              WalletEvent.getTotalExpenseEvent(year: value, context: context1));
        }
    ));
  }

  Widget listWidget({required BuildContext context, required int listIndex}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
         /* WalletBloc bloc = context.read<WalletBloc>();*/
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    state.walletTransactionsList[listIndex].createdAt!.replaceRange(11, 16, '')
                        .toString(),
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.blackColor),
                  ),
                  10.height,
                  Text(
                    '${state.walletTransactionsList[listIndex].type.toString()} : ${state.walletTransactionsList[listIndex].orderId}',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12, color: AppColors.blueColor),
                  ),
                ],
              ),
            //  10.width,

            //  10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      state.walletTransactionsList[listIndex].type.toString() ==
                          AppStrings.orderString
                          ? '${'-'}${formatNumber(value: double.parse(state.walletTransactionsList[listIndex].amount ?? '0').toString(),local: AppStrings.hebrewLocal)}':'${'-'}${formatNumber(value: (double.parse(state.walletTransactionsList[listIndex].amount ?? '0').toString()),local: AppStrings.hebrewLocal)}',
                      //  : '${formatter(double.parse(state.walletTransactionsList[listIndex].amount ?? '0').toString())}',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: state.walletTransactionsList[listIndex].type
                              .toString() ==
                              AppStrings.monthlyCreditString
                              ? AppColors.mainColor
                              : AppColors.redColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  3.height,
                  CircularButtonWidget(
                      buttonName: AppLocalizations.of(context)!.balance_status,
                      buttonValue:
                      '${formatNumber(value: double.parse(state.walletTransactionsList[listIndex].balance.toString()).toString(),local: AppStrings.hebrewLocal)}'
                  ),
                ],
              ),

            ],
          );
        },
      ),
    );
  }

  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false]) {
    DateTime now = new DateTime.now();

    return Container(
       height: getScreenHeight(context) >= 725 ?  getScreenHeight(context) /2.3 :getScreenHeight(context)/1.9,
        child: DateRangePickerWidget(
          doubleMonth: doubleMonth,
          initialDateRange: selectedDateRange,
          initialDisplayedDate: selectedDateRange?.end ?? DateTime.now(),
          onDateRangeChanged: onDateRangeChanged,
          minDate: minDate,
          maxDate: DateTime(now.year, now.month, now.day),
        ),
      );
  }
}

