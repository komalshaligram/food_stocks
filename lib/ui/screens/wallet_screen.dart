
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/bloc/wallet/wallet_bloc.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../data/model/wallet_model/wallet_model.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class WalletRoute {
  static Widget get route => const WalletScreen();
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(),
      child:  WalletScreenWidget(),
    );
  }
}


class WalletScreenWidget extends StatelessWidget {
   WalletScreenWidget({Key? key}) : super(key: key);
 double   cutOffYValue = 0.0;
    TextStyle yearTextStyle =
   TextStyle(fontSize: 12, color: Colors.black);
   List<PricePoint> list =[
     PricePoint('Jan', 10.0),
     PricePoint('Feb', 20.0),
     PricePoint('March', 30.0),
   ];
   static Map<int, String> monthMap = const {
     0: 'JAN',
     1: 'FEB',
     2: 'MAR',
     3: 'APR',
     4: 'MAY',
     5: 'JUN',
     6: 'JUL',
     7: 'AUG',
     8: 'SEP',
     9: 'OCT',
     10: 'NOV',
     11: 'DEC',
   };


   @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
      },
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          // WalletBloc bloc = context.read<WalletBloc>();
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   50.height,
                    Container(
                      width: getScreenWidth(context),
                      clipBehavior: Clip.hardEdge,
                      padding:  EdgeInsets.symmetric(
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
                              Radius.circular(10.0))),
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
                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: SfRadialGauge(
                                      backgroundColor:
                                      Colors.transparent,
                                      axes: [
                                        RadialAxis(
                                          minimum: 0,
                                          maximum: 10000,
                                          showLabels: false,
                                          showTicks: false,
                                          startAngle: 270,
                                          endAngle: 270,
                                          // radiusFactor: 0.8,
                                          axisLineStyle: AxisLineStyle(
                                              thicknessUnit:
                                              GaugeSizeUnit.factor,
                                              thickness: 0.2,
                                              color: AppColors
                                                  .borderColor),
                                          annotations: [
                                            GaugeAnnotation(
                                              angle: 270,
                                              widget: Text(
                                                '7550\n${AppLocalizations.of(context)!.currency}',
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                    size:
                                                    AppConstants
                                                        .font_14,
                                                    color: AppColors
                                                        .blackColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600),
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                            ),
                                          ],
                                          pointers: [
                                            RangePointer(
                                              color:
                                              AppColors.mainColor,
                                              enableAnimation: true,
                                              animationDuration: 300,
                                              animationType:
                                              AnimationType.ease,
                                              cornerStyle:
                                              CornerStyle.bothCurve,
                                              value: 7550,
                                              width: 6,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                      child: dashboardStatsWidget(
                                          context: context,
                                          image: AppImagePath.credits,
                                          title: AppLocalizations.of(
                                              context)!
                                              .total_credit,
                                          value:
                                          '20,000${AppLocalizations.of(context)!.currency}'),
                                    ),
                                    10.width,
                                    Flexible(
                                      child: dashboardStatsWidget(
                                          context: context,
                                          image: AppImagePath.expense,
                                          title: AppLocalizations.of(
                                              context)!
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
                                      child: dashboardStatsWidget(
                                          context: context,
                                          image: AppImagePath.expense,
                                          title: AppLocalizations.of(
                                              context)!
                                              .last_months_expenses,
                                          value:
                                          '18,360${AppLocalizations.of(context)!.currency}'),
                                    ),
                                    10.width,
                                    Flexible(
                                      child: dashboardStatsWidget(
                                          context: context,
                                          image: AppImagePath.orders,
                                          title: AppLocalizations.of(
                                              context)!
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
                    30.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.monthly_expense_graph,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.blackColor),
                        ),
                        dropDownWidget(date: state.date,dateList:state.dateList,context1: context)
                      ],
                    ),
                    15.height,

            /*        SizedBox(
                      width: double.maxFinite,
                      height: 155,
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(enabled: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [

                                  FlSpot(0, 3),
                                  FlSpot(2.6, 2),
                                  FlSpot(4.9, 5),
                                  FlSpot(6.8, 3.1),
                                  FlSpot(8, 4),
                                  FlSpot(9.5, 3),
                                  FlSpot(11, 4),

                              ],

                              isCurved: false,
                              barWidth: 2,
                              belowBarData: BarAreaData(
                                show: true,
                                color:AppColors.mainColor,
                                cutOffY: cutOffYValue,
                                applyCutOffY: true,
                              ),
                              dotData: FlDotData(
                                show: false,
                              ),
                            ),
                          ],

                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  String? month = monthMap[meta];
                                  if (month == '') {
                                    return SizedBox();
                                  }
                                  return Text(value.toString());
                                },
                              ),

                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false, ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false,),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),

                          minY: 0,

                      ),
                    )

                    ),*/
                    180.height,
                    15.width,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            dropDownWidget(date: state.date,dateList: state.dateList,context1: context),
                            10.width,
                            Container(
                              padding: EdgeInsets.symmetric(vertical:AppConstants.padding_5),
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(3)
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.export,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.whiteColor),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          AppLocalizations.of(context)!.history,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.blackColor),
                        ),
                      ],
                    ),
                    10.height,
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.balanceSheetList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: listWidget(context: context , balanceSheetList: state.balanceSheetList,
                              listIndex: index
                              ),
                            );
                          },
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





  Widget dashboardStatsWidget(
      {required BuildContext context,
        required String image,
        required String title,
        required String value}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          color: AppColors.iconBGColor),
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_10),
      child: Row(
        children: [
          SvgPicture.asset(image),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_10, color: AppColors.mainColor),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  value,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


 Widget dropDownWidget({required String date , required List<String> dateList , required BuildContext context1}) {
   WalletBloc bloc = context1.read<WalletBloc>();
     return  Container(
       padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_5,vertical: AppConstants.padding_5),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(7),
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
             child: Text(e,style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12)),
           );
         }).toList(),
         onChanged: (value) {
           bloc.add(WalletEvent.dropDownEvent(
               date: value!
           ));
         },
       ),
     );

  }

  Widget listWidget({required BuildContext context , required List<OrderBalance> balanceSheetList,
  required int listIndex
  }) {
     return  Container(
                       child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor.withOpacity(0.95),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(AppConstants.radius_40)
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_5,
                                        horizontal: AppConstants.padding_5
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppConstants.radius_40),
                                      color: AppColors.whiteColor,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(AppConstants.padding_5),
                                      height:27,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.navSelectedColor,
                                          borderRadius: BorderRadius.circular(AppConstants.radius_40)
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          text: AppLocalizations.of(context)!.balance_status ,
                                          style: TextStyle(
                                              color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
                                          children: <TextSpan>[
                                            TextSpan(text: ' : ${balanceSheetList[listIndex].balance}',
                                                style: TextStyle(
                                                    color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w700)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                 balanceSheetList[listIndex].difference.toString(),
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.blackColor),
                                ),
                              ],
                            ),
                          );
  }
}

class PricePoint {
  PricePoint(this.month, this.y);

  final String month;
  final double y;
}