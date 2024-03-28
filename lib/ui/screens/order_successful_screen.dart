 import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/wallet_screen_shimmer_widget.dart';
import '../../bloc/order_successful/order_successful_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../widget/balance_indicator.dart';
import '../widget/confetti.dart';
import '../widget/dashboard_stats_widget.dart';


class OrderSuccessfulRoute {
  static Widget get route => const OrderSuccessfulScreen();
}

class OrderSuccessfulScreen extends StatelessWidget {
  const OrderSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderSuccessfulBloc()..add(OrderSuccessfulEvent.getOrderCountEvent(context: context))
      ..add(OrderSuccessfulEvent.getWalletRecordEvent(context: context))..add(OrderSuccessfulEvent.celebrationEvent()),
      child: OrderSuccessfulScreenWidget(),
    );
  }
}

class OrderSuccessfulScreenWidget extends StatefulWidget {
  const OrderSuccessfulScreenWidget({super.key});

  @override
  State<OrderSuccessfulScreenWidget> createState() => _OrderSuccessfulScreenWidgetState();
}

class _OrderSuccessfulScreenWidgetState extends State<OrderSuccessfulScreenWidget> {

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.play(AssetSource('audio/success_sound.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSuccessfulBloc, OrderSuccessfulState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
              return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_10,
                          vertical: AppConstants.padding_50),
                      child: Column(
                        children: [
                          state.orderThisMonth < 0 ? WalletScreenShimmerWidget() : Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.shadowColor.withOpacity(0.10),
                                    blurRadius: AppConstants.blur_10),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    height: 180,
                                    width: 180,
                                    child: Image.asset(AppImagePath.successIcon)
                                ),
                              Text(
                                  AppLocalizations.of(context)!.order_sent_successfully,
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_22,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                10.height,
                              ],
                            ),
                          ),
                          20.height,
                          Container(
                            width: getScreenWidth(context),
                            clipBehavior: Clip.hardEdge,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding_10,
                                horizontal: AppConstants.padding_10),
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor.withOpacity(0.15),
                                      blurRadius: AppConstants.blur_10)
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10.0))),
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
                                          style:
                                          AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont,
                                            color: AppColors.blackColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        6.height,
                                        BalanceIndicator(
                                            pendingBalance: formatNumber(
                                                value: state.balance.toString(),local: AppStrings.hebrewLocal),
                                            expense:
                                            state.expensePercentage.round(),
                                            totalBalance: 100),
                                        6.height,
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text(
                                            '${formatNumber( value: state.balance.toString(),local: AppStrings.hebrewLocal)}',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.font_14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blackColor),
                                            textAlign: TextAlign.center,
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
                                            child: DashBoardStatsWidget(
                                                fontSize:  AppConstants.font_14,
                                                context: context,
                                                image: AppImagePath.credits,
                                                title: AppLocalizations.of(
                                                    context)!.total_credit,
                                                value: '${formatNumber(value: state.totalCredit.toString() ,local: AppStrings.hebrewLocal) }'),
                                          ),
                                          10.width,
                                          Flexible(
                                            child: DashBoardStatsWidget(
                                                fontSize:  AppConstants.font_14,
                                                context: context,
                                                image: AppImagePath.expense,
                                                title: AppLocalizations.of(
                                                    context)!
                                                    .this_months_expenses,
                                                value:
                                                '${formatNumber(value: state.thisMonthExpense.toString() ,local: AppStrings.hebrewLocal) }'),

                                          ),
                                        ],
                                      ),
                                      10.height,
                                      Row(
                                        children: [
                                          Flexible(
                                            child: DashBoardStatsWidget(
                                                fontSize:  AppConstants.font_14,
                                                context: context,
                                                image: AppImagePath.orders,
                                                title: AppLocalizations.of(
                                                    context)!
                                                    .this_months_orders,
                                                value: state.orderThisMonth.toString()),
                                          ),
                                          10.width,
                                          Flexible(
                                            child: DashBoardStatsWidget(
                                                fontSize:  AppConstants.font_14,
                                                context: context,
                                                image: AppImagePath.expense,
                                                title: AppLocalizations.of(
                                                    context)!
                                                    .last_months_expenses,
                                                value:
                                                '${formatNumber(value: state.lastMonthExpense.toString(),local:AppStrings.hebrewLocal)}'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 50,
                                    right: 50,
                                   ),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor.withOpacity(0.95),
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.shadowColor.withOpacity(0.20),
                                        blurRadius: AppConstants.blur_10),
                                  ],
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(AppConstants.radius_40)),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppConstants.padding_5,
                                      horizontal: AppConstants.padding_5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppConstants.radius_40),
                                    color: AppColors.whiteColor,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(AppConstants.padding_10),
                                    height: AppConstants.containerHeight_60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.navSelectedColor,
                                        borderRadius:
                                        BorderRadius.circular(AppConstants.radius_40)),
                                    child: Text(
                                      AppLocalizations.of(context)!.back_to_home_page,
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox.expand(
                    child: Visibility(
                      visible:state.duringCelebration,
                      child: IgnorePointer(
                        child: Confetti(
                          isStopped:!state.duringCelebration,
                          snippingsCount: 200,
                          snipSize: 7.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ),
        );
      },
    );
  }
}
