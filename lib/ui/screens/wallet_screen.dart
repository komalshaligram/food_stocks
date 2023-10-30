import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/wallet/wallet_bloc.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../data/model/wallet_model/wallet_model.dart';
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

extension NewMap on Map {
  Map reverse() => Map.fromEntries(entries.toList().reversed);
}

class WalletRoute {
  static Widget get route => const WalletScreen();
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc()..add(WalletEvent.checkLanguage()),
      child: WalletScreenWidget(),
    );
  }
}

class WalletScreenWidget extends StatelessWidget {
  WalletScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> chartData = [
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
    ];
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

    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {},
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          // WalletBloc bloc = context.read<WalletBloc>();
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  color:
                                      AppColors.shadowColor.withOpacity(0.15),
                                  blurRadius: AppConstants.blur_10)
                            ],
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppConstants.radius_10))),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      balance: 7550,
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
                                            title: AppLocalizations.of(context)!
                                                .total_credit,
                                            value:
                                                '20,000${AppLocalizations.of(context)!.currency}'),
                                      ),
                                      10.width,
                                      Flexible(
                                        child: DashBoardStatsWidget(
                                            context: context,
                                            image: AppImagePath.expense,
                                            title: AppLocalizations.of(context)!
                                                .this_months_expenses,
                                            value:
                                                '7,550${AppLocalizations.of(context)!.currency}'),
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
                                            title: AppLocalizations.of(context)!
                                                .last_months_expenses,
                                            value:
                                                '18,360${AppLocalizations.of(context)!.currency}'),
                                      ),
                                      10.width,
                                      Flexible(
                                        child: DashBoardStatsWidget(
                                            context: context,
                                            image: AppImagePath.orders,
                                            title: AppLocalizations.of(context)!
                                                .this_months_orders,
                                            value: '23'),
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
                            AppLocalizations.of(context)!.monthly_expense_graph,
                            style: AppStyles.rkRegularTextStyle(
                                size: state.language == 'en'
                                    ? AppConstants.font_14
                                    : AppConstants.smallFont,
                                color: AppColors.blackColor),
                          ),
                          dropDownWidget(
                              index: 1,
                              date: state.date,
                              dateList: state.dateList,
                              context1: context)
                        ],
                      ),
                    ),
                    20.height,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                        height: 185,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: false),
                              lineTouchData: LineTouchData(
                                getTouchLineEnd: (barData, spotIndex) {
                                  return 46;
                                },
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipItems: (value) {
                                    return value.map((e) {
                                      return LineTooltipItem(
                                          "${monthMap[e.x]} ${AppLocalizations.of(context)!.total} :  ${e.y}",
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
                                  spots: chartData,
                                  color: AppColors.mainColor.withOpacity(0.8),
                                  isCurved: false,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.mainColor.withOpacity(0.5),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.graphColor.withOpacity(0.2),
                                        AppColors.graphColor.withOpacity(0.01),
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
                                        textDirection: TextDirection.ltr,
                                        style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_8,
                                          color: AppColors.navSelectedColor,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
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
                          horizontal: AppConstants.padding_15),
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
                              Container(
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
                              10.width,
                              dropDownWidget(
                                  index: 2,
                                  date: state.date1,
                                  dateList: state.dateList1,
                                  context1: context),
                            ],
                          ),
                        ],
                      ),
                    ),
                    10.height,
                    SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ListView.builder(
                          itemCount: state.balanceSheetList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              color: AppColors.whiteColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_10,
                                        horizontal: AppConstants.padding_15),
                                    child: listWidget(
                                        context: context,
                                        balanceSheetList: state.balanceSheetList,
                                        listIndex: index),
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    height: 1,
                                    color: AppColors.borderColor,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dropDownWidget(
      {required int index,
      required String date,
      required List<String> dateList,
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
      child: DropdownButton<String>(
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
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e,
                style:
                    AppStyles.rkRegularTextStyle(size: AppConstants.font_12)),
          );
        }).toList(),
        onChanged: (value) {
          bloc.add(WalletEvent.dropDownEvent(date: value!, index: index));
        },
      ),
    );
  }

  Widget listWidget(
      {required BuildContext context,
      required List<OrderBalance> balanceSheetList,
      required int listIndex}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppConstants.padding_5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                balanceSheetList[listIndex].date.toString(),
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_12, color: AppColors.blackColor),
              ),
              10.height,
              Text(
                '${AppLocalizations.of(context)!.order} : ${balanceSheetList[listIndex].orderPayment.toString()}',
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
                  '${balanceSheetList[listIndex].difference.toString()}${AppLocalizations.of(context)!.currency}',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: balanceSheetList[listIndex].difference > 0
                          ? AppColors.mainColor
                          : AppColors.redColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              10.width,
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, RouteDefine.orderSuccessfulScreen.name),
                child: CircularButtonWidget(
                  buttonName: AppLocalizations.of(context)!.balance_status,
                  buttonValue:
                      '${balanceSheetList[listIndex].balance.toString()}${AppLocalizations.of(context)!.currency}',
                ),
              ),
            ],
          ),
        ],
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
