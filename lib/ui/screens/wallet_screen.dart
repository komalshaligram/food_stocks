import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../ui/widget/wallet_screen_shimmer_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../widget/balance_indicator.dart';
import '../widget/common_dialog_with_one_button.dart';
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
        ..add(const WalletEvent.getYearListEvent())
        ..add(WalletEvent.getOrderCountEvent(context: context))
        ..add(const WalletEvent.checkLanguage())
        ..add(WalletEvent.getAllWalletTransactionEvent(
          context: context,
          endDate: DateTime.utc(DateTime.now().year, DateTime.now().month + 1).subtract(const Duration(days: 1)),
          startDate: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
        )),
      child: const WalletScreenWidget(),
    );
  }
}

class WalletScreenWidget extends StatefulWidget {
  const WalletScreenWidget({Key? key}) : super(key: key);

  @override
  State<WalletScreenWidget> createState() => _WalletScreenWidgetState();
}

class _WalletScreenWidgetState extends State<WalletScreenWidget> with SingleTickerProviderStateMixin {
  static const double _horizontalPadding = 16;
  static const double _cardRadius = 16;

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
      listener: (context, state) {
        if (state.isExportComplete) {
          showDialog(
            context: context,
            builder: (context1) {
              return CustomOneButtonDialog(
                title: state.userEmail,
                directionality: state.language,
                width: 80,
                positiveTitle: AppLocalizations.of(context)!.closeText,
                positiveOnTap: () => Navigator.pop(context1),
                subTitle: AppLocalizations.of(context)!.wallet_information_sent_to_your_email,
              );
            },
          ).then((value) {
            context.read<WalletBloc>().add(const WalletEvent.checkLanguage());
          });
        } else if (state.isAccountPermissionShimmering) {
          BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.seeWalletPermissionUpdateEvent(context: context));
        }
      },
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          WalletBloc bloc = context.read<WalletBloc>();
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: FocusDetector(
              onFocusGained: () {
                bloc.add(WalletEvent.userApproveEvent(context: context));
                if (state.walletTransactionsList.isEmpty) {
                  bloc.add(WalletEvent.getAllWalletTransactionEvent(context: context, endDate: endDate, startDate: startDate));
                }
                bloc.add(WalletEvent.getWalletRecordEvent(context: context));
                bloc.add(WalletEvent.getTotalExpenseEvent(year: state.year, context: context));
                bloc.add(WalletEvent.getDropDownElementEvent(year: state.year));
                bloc.add(WalletEvent.getPermissionList(context: context));
                bloc.add(const WalletEvent.checkLanguage());
                if (state.yearList.isNotEmpty) {
                  minDate = DateTime(state.yearList.last, 1, 1);
                }
              },
              child: AnimationLimiter(
                child: SafeArea(
                  child: NotificationListener<ScrollNotification>(
                    child: SingleChildScrollView(
                      physics: state.walletTransactionsList.isEmpty ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 400),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            duration: const Duration(milliseconds: 400),
                            verticalOffset: 24,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            _buildPageHeader(context),
                            16.height,
                            _buildSummaryCard(context, state),
                            20.height,
                            _buildGraphSection(context, state, monthMap, monthMap1),
                            20.height,
                            _buildHistorySection(context, state, bloc),
                            12.height,
                            _buildTransactionList(context, state),
                            state.isLoadMore
                                ? const Padding(padding: EdgeInsets.only(bottom: 10), child: OrderSummaryScreenShimmerWidget(itemCount: 2))
                                : 0.width,
                            AppConstants.bottomNavSpace.height,
                          ],
                        ),
                      ),
                    ),
                    onNotification: (notification) {
                      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                        if ((state.balanceSheetList.metaData?.totalFilteredCount ?? 1) > state.walletTransactionsList.length) {
                          context.read<WalletBloc>().add(WalletEvent.getAllWalletTransactionEvent(
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.wallet,
              style: AppStyles.rkBoldTextStyle(size: AppConstants.font_20, color: AppColors.blackColor),
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.account_balance_wallet_outlined, size: 21, color: AppColors.mainColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, WalletState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.balance_status,
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.blackColor.withValues(alpha: 0.55)),
                    textAlign: TextAlign.center,
                  ),
                  8.height,
                  BalanceIndicator(
                    pendingBalance: formatNumberForWallet(value: state.balance.toString(), local: AppStrings.hebrewLocal, context: context),
                    expense: state.expensePercentage.round(),
                    totalBalance: 100,
                  ),
                  8.height,
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      formatNumberForWallet(value: state.balance.toString(), local: AppStrings.hebrewLocal, context: context),
                      style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.blackColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            8.width,
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: DashBoardStatsWidget(
                          fontSize: AppConstants.font_12,
                          context: context,
                          image: AppImagePath.credits,
                          title: AppLocalizations.of(context)!.total_credit,
                          value: formatNumberForWallet(value: state.totalCredit.toString(), local: AppStrings.hebrewLocal, context: context),
                        ),
                      ),
                      8.width,
                      Flexible(
                        child: DashBoardStatsWidget(
                          fontSize: AppConstants.font_12,
                          context: context,
                          image: AppImagePath.expense,
                          title: AppLocalizations.of(context)!.this_months_expenses,
                          value: formatNumberForWallet(value: state.thisMonthExpense.toString(), local: AppStrings.hebrewLocal, context: context),
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  Row(
                    children: [
                      Flexible(
                        child: DashBoardStatsWidget(
                          fontSize: AppConstants.font_12,
                          context: context,
                          image: AppImagePath.orders,
                          title: AppLocalizations.of(context)!.this_months_orders,
                          value: state.orderThisMonth.toString(),
                        ),
                      ),
                      8.width,
                      Flexible(
                        child: DashBoardStatsWidget(
                          fontSize: AppConstants.font_12,
                          context: context,
                          image: AppImagePath.expense,
                          title: AppLocalizations.of(context)!.last_months_expenses,
                          value: formatNumberForWallet(
                              value: state.lastMonthExpense.toStringAsFixed(0), local: AppStrings.hebrewLocal, context: context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphSection(BuildContext context, WalletState state, Map<int, String> monthMap, Map<int, String> monthMap1) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.monthly_expense_graph,
                  style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.blackColor),
                ),
                dropDownWidget(date: state.year, dateList: state.yearList, context1: context),
              ],
            ),
            12.height,
            state.isGraphProcess
                ? const WalletScreenShimmerWidget()
                : SizedBox(
                    height: getScreenHeight(context) * 0.21,
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
                                  "${monthMap1[e.x]} ${state.year} ${AppLocalizations.of(context)!.total}: "
                                  "${AppLocalizations.of(context)!.currency}${e.y.toStringAsFixed(2)}",
                                  const TextStyle(fontSize: 8),
                                );
                              }).toList();
                            },
                            tooltipBgColor: Colors.transparent,
                            showOnTopOfTheChartBoxArea: false,
                            tooltipMargin: 15,
                            tooltipPadding: const EdgeInsets.only(bottom: AppConstants.padding_5),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: state.monthlyExpenseList,
                            color: AppColors.mainColor,
                            isCurved: true,
                            curveSmoothness: 0.25,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColors.mainColor.withValues(alpha: 0.18), AppColors.mainColor.withValues(alpha: 0.01)],
                              ),
                              cutOffY: 0.0,
                              applyCutOffY: false,
                            ),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        minY: 0,
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: ((value, meta) {
                                final month = monthMap[value];
                                if (month == null) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: AppConstants.padding_5),
                                  child: Text(
                                    month.toString(),
                                    style:
                                        AppStyles.rkRegularTextStyle(size: AppConstants.font_8, color: AppColors.blackColor.withValues(alpha: 0.45)),
                                  ),
                                );
                              }),
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: ((value, meta) {
                                final index = value.round();
                                if (index < 0 || index >= state.graphDataList.length) {
                                  return const SizedBox.shrink();
                                }
                                final month = state.graphDataList[index];
                                return Text(
                                  month.toString() == "0.00" ? '0' : month.toString(),
                                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_8, color: AppColors.blackColor.withValues(alpha: 0.45)),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, WalletState state, WalletBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.history,
            style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.blackColor),
          ),
          12.height,
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final statuses = await [Permission.storage].request();

                    if (Platform.isAndroid) {
                      final deviceInfo = DeviceInfoPlugin();
                      final androidInfo = await deviceInfo.androidInfo;
                      if (androidInfo.version.sdkInt < 33) {
                        if (!statuses[Permission.storage]!.isGranted) {
                          CustomSnackBar.showSnackBar(
                              context: context, title: AppLocalizations.of(context)!.storage_permission, type: SnackBarType.failure);
                          return;
                        }
                      }
                    }

                    if (state.walletTransactionsList.isNotEmpty) {
                      bloc.add(WalletEvent.exportWalletTransactionEvent(
                        context: context,
                        startDate: startDate ?? state.firstDateOfMonth,
                        endDate: endDate ?? DateTime.now(),
                      ));
                    }
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: AppColors.appMainGradientColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: state.isExportShimmering
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                            AppLocalizations.of(context)!.export,
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              10.width,
              Expanded(
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lightBorderColor),
                    color: AppColors.whiteColor,
                  ),
                  child: DateRangeField(
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.blackColor.withValues(alpha: 0.4)),
                      suffixIconConstraints: const BoxConstraints(minHeight: 22, minWidth: 28),
                    ),
                    childBuilder: (context, range) {
                      return Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          range?.toString() ?? '',
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.blackColor),
                        ),
                      );
                    },
                    showDateRangePicker: ({required pickerBuilder, required widgetContext}) {
                      return showDateRangePickerDialog(
                        context: context,
                        offset: const Offset(65, 200),
                        barrierColor: Colors.black.withValues(alpha: 0.45),
                        builder: datePickerBuilder,
                      );
                    },
                    onDateRangeSelected: (DateRange? value) {
                      startDate = value?.start;
                      endDate = value?.end;

                      if (value == null) {
                        selectedDateRange = state.selectedDateRange;
                        bloc.add(WalletEvent.getDateRangeEvent(context: context, range: state.selectedDateRange));
                      } else {
                        selectedDateRange = value;
                        bloc.add(WalletEvent.getDateRangeEvent(context: context, range: value));
                        bloc.add(WalletEvent.getAllWalletTransactionEvent(context: context, endDate: value.end, startDate: value.start));
                      }
                    },
                    selectedDateRange: state.selectedDateRange,
                    pickerBuilder: (BuildContext context, dynamic Function(DateRange?) onDateRangeChanged) {
                      return const Text('');
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, WalletState state) {
    if (state.isShimmering) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: OrderSummaryScreenShimmerWidget(),
      );
    }

    if (state.walletTransactionsList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 24),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.no_data,
            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_15, color: AppColors.blackColor.withValues(alpha: 0.45)),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.walletTransactionsList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: listWidget(context: context, listIndex: index),
          ),
        );
      },
    );
  }

  Widget dropDownWidget({required int date, required List<int> dateList, required BuildContext context1}) {
    if (dateList.isEmpty) {
      return const SizedBox.shrink();
    }
    final selectedYear = dateList.contains(date) ? date : dateList.first;
    WalletBloc bloc = context1.read<WalletBloc>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightBorderColor),
        color: AppColors.pageColor,
      ),
      child: DropdownButton<int>(
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.blackColor.withValues(alpha: 0.5), size: 20),
        elevation: 0,
        isDense: true,
        value: selectedYear,
        underline: const SizedBox(),
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        dropdownColor: AppColors.whiteColor,
        alignment: Alignment.center,
        items: dateList.map((e) {
          return DropdownMenuItem<int>(
            value: e,
            child: Text(e.toString(), style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, fontWeight: FontWeight.w500)),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null) return;
          bloc.add(WalletEvent.getDropDownElementEvent(year: value));
          bloc.add(WalletEvent.getTotalExpenseEvent(year: value, context: context1));
        },
      ),
    );
  }

  Widget listWidget({required BuildContext context, required int listIndex}) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        final transaction = state.walletTransactionsList[listIndex];
        final typeLabel = getType(transaction.type.toString());
        final l10n = AppLocalizations.of(context)!;
        final isOrder = typeLabel == l10n.order || typeLabel == l10n.surfaces_order;
        final isCredit = typeLabel == l10n.monthly_credit || typeLabel == l10n.refund_for_order;
        final amountColor = isCredit ? AppColors.mainColor : AppColors.redColor;
        final description = typeLabel == l10n.order || typeLabel == l10n.refund_for_order || typeLabel == l10n.surfaces_order
            ? '$typeLabel: ${transaction.orderId}'
            : typeLabel;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatTransactionTime(transaction.createdAt),
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor.withValues(alpha: 0.45)),
                  ),
                  8.height,
                  Text(
                    description ?? '',
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.mainColor, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    isOrder
                        ? '- ${formatNumberForWallet(value: double.parse(transaction.amount ?? '0').toString(), local: AppStrings.hebrewLocal, context: context)}'
                        : formatNumberForWallet(
                            value: double.parse(transaction.amount ?? '0').toString(), local: AppStrings.hebrewLocal, context: context),
                    style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: amountColor),
                  ),
                ),
                8.height,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.pageColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: RichText(
                      text: TextSpan(
                        text: '${l10n.balance_status}: ',
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor.withValues(alpha: 0.55)),
                        children: [
                          TextSpan(
                            text: formatNumberForWallet(value: transaction.balance.toString(), local: AppStrings.hebrewLocal, context: context),
                            style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatTransactionTime(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '';
    if (createdAt.length >= 16) {
      return createdAt.replaceRange(11, 16, '');
    }
    return createdAt;
  }

  String? getType(String type) {
    if (type == AppStrings.credit) {
      return AppLocalizations.of(context)!.monthly_credit;
    } else if (type == AppStrings.debit) {
      return AppLocalizations.of(context)!.order;
    } else if (type == AppStrings.refund) {
      return AppLocalizations.of(context)!.refund_for_order;
    } else if (type == AppStrings.surfaceAmount) {
      return AppLocalizations.of(context)!.surfaces_order;
    } else {
      return AppLocalizations.of(context)!.refund;
    }
  }

  Widget datePickerBuilder(BuildContext context, dynamic Function(DateRange?) onDateRangeChanged, [bool doubleMonth = false]) {
    DateTime now = DateTime.now();

    return SizedBox(
      height: getScreenHeight(context) >= 725 ? getScreenHeight(context) / 2.3 : getScreenHeight(context) / 1.9,
      child: DateRangePickerWidget(
        doubleMonth: doubleMonth,
        initialDateRange: selectedDateRange,
        initialDisplayedDate: selectedDateRange?.end ?? DateTime.now(),
        onDateRangeChanged: onDateRangeChanged,
        minDate: minDate,
        theme: CalendarTheme(
          selectedColor: AppColors.mainColor,
          dayNameTextStyle: const TextStyle(color: Colors.black45, fontSize: AppConstants.font_10),
          inRangeColor: AppColors.lightMainColor,
          inRangeTextStyle: const TextStyle(color: Colors.black),
          selectedTextStyle: const TextStyle(color: Colors.white),
          todayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          defaultTextStyle: const TextStyle(color: Colors.black, fontSize: 12),
          radius: AppConstants.radius_10,
          tileSize: 40,
          selectedQuickDateRangeColor: AppColors.mainColor,
          disabledTextStyle: const TextStyle(color: Colors.grey),
        ),
        maxDate: DateTime(now.year, now.month, now.day),
      ),
    );
  }
}
