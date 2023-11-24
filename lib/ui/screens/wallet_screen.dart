import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/wallet/wallet_bloc.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/wallet_screen_shimmer_widget.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
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
        ..add(WalletEvent.getOrderCountEvent(context: context)),
      child: WalletScreenWidget(),
    );
  }
}

class WalletScreenWidget extends StatelessWidget {
  WalletScreenWidget({Key? key}) : super(key: key);
  DateRange? selectedDateRange;
  DateTime? minDate;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
/*    final List<FlSpot> chartData = [
      FlSpot(0, 15),
      FlSpot(1, 33),
      FlSpot(2, 15),
      FlSpot(3, 40),
      FlSpot(4, 30),
      FlSpot(5, 35),
      FlSpot(6, 25),
      FlSpot(7, 30),
      FlSpot(8, 15),
      FlSpot(9, 40),
      FlSpot(10, 10),
      FlSpot(11, 15),
    ];*/

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
                        50.height,
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
                                          balance: state.balance,
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
                                                    '${state.totalCredit}${AppLocalizations.of(context)!.currency}'),
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
                                                    '${state.thisMonthExpense}${AppLocalizations.of(context)!.currency}'),
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
                                                    '${state.lastMonthExpense}${AppLocalizations.of(context)!.currency}'),
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
                                    size: /*  state.language == 'en'
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
                        20.height,
                        state.monthlyExpenseList.isEmpty
                            ? WalletScreenShimmerWidget()
                            : Padding(
                                padding: const EdgeInsets.all(2.0),
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
                                        touchSpotThreshold: 30.0,
                                          getTouchLineEnd:
                                              (barData, spotIndex) {
                                            return 46;
                                          },
                                          enabled: true,
                                          touchTooltipData: LineTouchTooltipData(
                                                fitInsideHorizontally: true,
                                            getTooltipItems: (value) {
                                              return value.map((e) {
                                                return LineTooltipItem(
                                                    "${monthMap1[e.x]} ${state.year} ${AppLocalizations.of(context)!.total} : ${AppLocalizations.of(context)!.currency}${e.y}",
                                                    TextStyle(fontSize: 8));
                                              }).toList();
                                            },
                                            tooltipBgColor: Colors.transparent,
                                            showOnTopOfTheChartBoxArea: true,
                                            tooltipMargin: 5,
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
                                                  textDirection:
                                                      TextDirection.ltr,
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
                        15.width,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.history,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.blackColor),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      bloc.add(WalletEvent
                                          .exportWalletTransactionEvent(
                                              context: context));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.padding_5,
                                          horizontal: AppConstants.padding_8),
                                      decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.radius_3)),
                                      child: Text(
                                        AppLocalizations.of(context)!.export,
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont,
                                            color: AppColors.whiteColor),
                                      ),
                                    ),
                                  ),
                                  10.width,
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppConstants.padding_5,
                                          vertical: AppConstants.padding_5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.radius_7),
                                        border: Border.all(
                                            color: AppColors.borderColor),
                                        color: AppColors.whiteColor,
                                      ),
                                      child: Container(
                                        width:  getScreenWidth(context) * 0.56,
                                        height: 30,
                                        child: DateRangeField(
                                          decoration: InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              prefixIcon: Icon(
                                                  Icons.keyboard_arrow_down),
                                              contentPadding:
                                                  EdgeInsets.all(0),

                                          ),
                                          showDateRangePicker: (
                                              {required pickerBuilder,
                                              required widgetContext}) {
                                            return showDateRangePickerDialog(
                                                context: context,
                                                offset: Offset(65, 200),
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.6),
                                                builder: datePickerBuilder);
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

                                            //  minDate = DateTime(state.yearList.last ,1,1);
                                          },
                                          selectedDateRange: state.selectedDateRange,
                                          pickerBuilder: (BuildContext context,
                                              dynamic Function(DateRange?)
                                                  onDateRangeChanged) {
                                            return Text('');
                                          },
                                          // pickerBuilder: datePickerBuilder,
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        10.height,
                        Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(bottom: getScreenHeight(context) * 0.1),
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
                                          height: 200,
                                          child: Center(
                                              child: Text(
                                                AppLocalizations.of(context)!.no_data,
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.normalFont,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                        ),
                            ),
                            state.isLoadMore
                                ? OrderSummaryScreenShimmerWidget()
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
          horizontal: AppConstants.padding_5, vertical: AppConstants.padding_5),
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
        underline: SizedBox(),
        value: date,
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
        },
      ),
    );
  }

  Widget listWidget({required BuildContext context, required int listIndex}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppConstants.padding_5),
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.walletTransactionsList[listIndex].createdAt!
                        .replaceRange(11, 16, '')
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
              Row(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      state.walletTransactionsList[listIndex].type.toString() ==
                              'Order'
                          ? '${'-'}${state.walletTransactionsList[listIndex].amount.toString()}${AppLocalizations.of(context)!.currency}'
                          : '${state.walletTransactionsList[listIndex].amount.toString()}${AppLocalizations.of(context)!.currency}',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: state.walletTransactionsList[listIndex].type
                                      .toString() ==
                                  'Monthly Credits'
                              ? AppColors.mainColor
                              : AppColors.redColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  20.width,
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteDefine.orderSuccessfulScreen.name),
                    child: CircularButtonWidget(
                      buttonName: AppLocalizations.of(context)!.balance_status,
                      buttonValue:
                          '${state.walletTransactionsList[listIndex].balance.toString()}${AppLocalizations.of(context)!.currency}',
                    ),
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
      height: getScreenHeight(context) * 0.41,
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

/*SideTitles get _bottomTitles => SideTitles(
  showTitles: true,
  getTitlesWidget: (value, meta) {
    String text = '';
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
    }

    return Text(text);
  },
);*/
/*class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}*/
/*LineChart(
                      LineChartData(

                        borderData: FlBorderData(show: false,
                        ),
                        lineTouchData: LineTouchData(enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              fitInsideHorizontally: true,
                              getTooltipItems: (value) {
                                return value
                                    .map((e) => LineTooltipItem(
                                    "${e.y < 0 ? 'Expense:' : 'Income:'} ${e.y.toStringAsFixed(2)} \n Diff: ",
                                    TextStyle(fontSize: 10)))
                                    .toList();
                              },
                              tooltipBgColor: Colors.transparent,
                            ),

                        ),
                        lineBarsData: [
                          LineChartBarData(
                             gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.graphColor,
                          AppColors.graphColor,
                          AppColors.whiteColor
                        ],
                      ) ,
                            spots: [
                              FlSpot(0, 1),
                              FlSpot(1, 1),
                              FlSpot(2, 3),
                              FlSpot(3, 4),
                              FlSpot(4, 5),
                              FlSpot(5, 8),
                              FlSpot(6, 2),
                              FlSpot(7, 7),
                              FlSpot(8, 10),
                              FlSpot(9, 21),
                              FlSpot(10, 6),
                              FlSpot(11, 3),
                            ],
                            isCurved: false,
                            barWidth: 2,
                          //  color:AppColors.mainColor,

                            belowBarData: BarAreaData(
                              show: false,

                              cutOffY: 5,
                              applyCutOffY: false,
                            ),
                            aboveBarData: BarAreaData(
                              show: false,
                            ),
                            dotData: FlDotData(
                              show: false,
                            ),
                          ),
                        ],
                        minY: -2,
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(sideTitles: _bottomTitles,),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                  ),
          ),*/
/* SizedBox(
                    height: 186,
                    child: SfCartesianChart(
                      tooltipBehavior:  TooltipBehavior(
                          enable: true,
                         opacity: 0.01,
                         //  duration: 0,
                          tooltipPosition: TooltipPosition.auto,
                          color: AppColors.lightGreyColor.withOpacity(0.01),
                          canShowMarker: true,
                          textAlignment: ChartAlignment.center,
                         builder: (data, point, series, pointIndex, seriesIndex) {
                           return Text("${point.x} total : ${point.y}",
                           style: TextStyle(
                             color: AppColors.greyColor,
                             fontSize: AppConstants.padding_10,
                           ),
                           );
                        },
                      ),
                      margin: EdgeInsets.all(0),
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        majorTickLines: const MajorTickLines(size:0),
                        majorGridLines: MajorGridLines(width: 0),
                          axisLine: AxisLine(width: 0),
                        axisLabelFormatter: (AxisLabelRenderDetails args) {
                          late String text;
                          late TextStyle textStyle =
                              AppStyles.rkRegularTextStyle(
                                  size: AppConstants.font_8,
                                  color: AppColors.navSelectedColor);
                          text = '${args.text}';
                          return ChartAxisLabel(text, textStyle);
                        },
                      ),
                      primaryYAxis: CategoryAxis(

                        isVisible: false,
                        desiredIntervals: 2,
                        rangePadding: ChartRangePadding.none,
                      ),
                      legend: Legend(isVisible: false),
                      series: <ChartSeries<_ChartData, String>>[

                        AreaSeries<_ChartData, String>(
                          borderWidth: 1.2,

                          borderColor: AppColors.mainColor,
                          dataSource: data,
                          xValueMapper: (_ChartData sales, _) => sales.x,
                          yValueMapper: (_ChartData sales, _) => sales.y,
                          dataLabelSettings: DataLabelSettings(isVisible: false),
                         enableTooltip: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.graphColor.withOpacity(0.3),
                              AppColors.graphColor.withOpacity(0.01),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),*/
/*
final List<_ChartData> data = [

  _ChartData(AppLocalizations.of(context)!.dec, 12),
  _ChartData(AppLocalizations.of(context)!.nov, 40),
  _ChartData(AppLocalizations.of(context)!.oct, 30),
  _ChartData(AppLocalizations.of(context)!.sep, 6.4),
  _ChartData(AppLocalizations.of(context)!.aug, 14),
  _ChartData(AppLocalizations.of(context)!.jul, 40),
  _ChartData(AppLocalizations.of(context)!.jun, 20),
  _ChartData(AppLocalizations.of(context)!.may, 35),
  _ChartData(AppLocalizations.of(context)!.apr, 5),
  _ChartData(AppLocalizations.of(context)!.mar, 25),
  _ChartData(AppLocalizations.of(context)!.feb, 7),
  _ChartData(AppLocalizations.of(context)!.jan, 38),
];
*/
