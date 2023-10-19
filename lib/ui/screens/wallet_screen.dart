import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/wallet/wallet_bloc.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../data/model/wallet_model/wallet_model.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/balance_indicator.dart';
import '../widget/circular_button_widget.dart';
import '../widget/dashboard_stats_widget.dart';

class WalletRoute {
  static Widget get route => const WalletScreen();
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(),
      child: WalletScreenWidget(),
    );
  }
}

class WalletScreenWidget extends StatelessWidget {
  WalletScreenWidget({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

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

    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {},
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          // WalletBloc bloc = context.read<WalletBloc>();
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
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
                                color: AppColors.shadowColor.withOpacity(0.15),
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
                                              '20,000${AppLocalizations.of(context)!.price}'),
                                    ),
                                    10.width,
                                    Flexible(
                                      child: DashBoardStatsWidget(
                                          context: context,
                                          image: AppImagePath.expense,
                                          title: AppLocalizations.of(context)!
                                              .this_months_expenses,
                                          value:
                                              '7,550${AppLocalizations.of(context)!.price}'),
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
                                              '18,360${AppLocalizations.of(context)!.price}'),
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
                              size: AppConstants.smallFont,
                              color: AppColors.blackColor),
                        ),
                        dropDownWidget(
                            date: state.date,
                            dateList: state.dateList,
                            context1: context)
                      ],
                    ),
                  ),
                  15.height,
                  SizedBox(
                    height: 186,
                    child: SfCartesianChart(
                      margin: EdgeInsets.all(0),

                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        majorTickLines: const MajorTickLines(size: 0),
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
                  ),
                  25.height,
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
                                  vertical: AppConstants.padding_5,horizontal: AppConstants.padding_8),
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
                                date: state.date,
                                dateList: state.dateList,
                                context1: context),
                          ],
                        ),
                      ],
                    ),
                  ),
                  10.height,
                  Expanded(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dropDownWidget(
      {required String date,
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
          bloc.add(WalletEvent.dropDownEvent(date: value!));
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
            crossAxisAlignment: CrossAxisAlignment.end,
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
              Text(
                '${balanceSheetList[listIndex].difference.toString()}${AppLocalizations.of(context)!.price}',
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont,
                    color: balanceSheetList[listIndex].difference > 0
                        ? AppColors.mainColor
                        : AppColors.redColor,
                    fontWeight: FontWeight.w600),
              ),
              10.width,
              CircularButtonWidget(
                buttonName:AppLocalizations.of(context)!.balance_status,
                buttonValue:'${balanceSheetList[listIndex].balance.toString()}${AppLocalizations.of(context)!.price}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
