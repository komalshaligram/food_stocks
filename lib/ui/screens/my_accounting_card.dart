import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/status_info_res_model/status_info_res_model.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/my_accounting_card/my_accounting_card_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/model/res_model/my_account_card_invoices_res_model/my_account_card_invoices_res_model.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_divider_widget.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import 'package:flutter/widgets.dart' as widgets;

class MyAccountingCardRoute {
  static Widget get route => const MyAccountingCardScreen();
}

class MyAccountingCardScreen extends StatelessWidget {
  const MyAccountingCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAccountingCardBloc()
        ..add(MyAccountingCardEvent.getClientInvoicesFromRivchitDataEvent(context: context))
        ..add(MyAccountingCardEvent.getClientRefundInvoicesFromRivchitDataEvent(context: context)),
      child: const MyAccountingCardScreenContent(),
    );
  }
}

class MyAccountingCardScreenContent extends StatelessWidget {
  const MyAccountingCardScreenContent({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _showDatePickerBottomSheet(BuildContext context) async {
    final bloc = context.read<MyAccountingCardBloc>();
    final state = bloc.state;
    final isInvoicesTab = state.selectedTabIndex == 0;

    DateTime tempFrom = isInvoicesTab
        ? state.invoicesFrom ??
            DateTime.now().subtract(const Duration(
              days: 90,
            ))
        : state.refundsFrom ?? DateTime.now().subtract(const Duration(days: 90));

    DateTime tempTo = isInvoicesTab ? state.invoicesTo ?? DateTime.now() : state.refundsTo ?? DateTime.now();

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radius_20))),
        builder: (sheetContext) {
          return StatefulBuilder(builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(AppConstants.padding_20, AppConstants.padding_20, AppConstants.padding_20, MediaQuery.of(sheetContext).viewInsets.bottom + 20),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    isInvoicesTab ? AppLocalizations.of(context)!.invoice_date_range : AppLocalizations.of(context)!.refunds_date_range,
                    style: AppStyles.rkBoldTextStyle(size: AppConstants.mediumFont, color: AppColors.blackColor),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(sheetContext)),
                ]),
                10.height,
                Row(children: [
                  Expanded(child: Text(AppLocalizations.of(context)!.form_date, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.blackColor))),
                  5.width,
                  Expanded(child: Text(AppLocalizations.of(context)!.to_date, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.blackColor))),
                ]),
                10.height,
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(context: sheetContext, initialDate: tempFrom, firstDate: DateTime(2023), lastDate: DateTime.now());
                        if (picked != null) {
                          setSheetState(() {
                            tempFrom = picked;
                            if (tempTo.isBefore(tempFrom)) {
                              tempTo = tempFrom;
                            }
                          });
                        }
                      },
                      child: _buildDateTile(_formatDate(tempFrom), AppLocalizations.of(context)!.select_date),
                    ),
                  ),
                  5.width,
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(context: sheetContext, initialDate: tempTo, firstDate: tempFrom, lastDate: DateTime.now());
                        if (picked != null) {
                          setSheetState(() => tempTo = picked);
                        }
                      },
                      child: _buildDateTile(_formatDate(tempTo), AppLocalizations.of(context)!.select_date),
                    ),
                  ),
                ]),
                15.height,
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(sheetContext);
                      },
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.whiteColor, border: Border.all(color: AppColors.redColor), borderRadius: BorderRadius.circular(AppConstants.radius_10)),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(AppConstants.padding_8),
                        child: Text(AppLocalizations.of(context)!.closeText, style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.redColor)),
                      ),
                    ),
                  ),
                  16.width,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final days = tempTo.difference(tempFrom).inDays;

                        if (days > 92) {
                          Navigator.pop(sheetContext);
                          CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.maximum_three_month_date_range_required, type: SnackBarType.failure);
                          return;
                        }

                        if (isInvoicesTab) {
                          bloc.add(MyAccountingCardEvent.updateInvoicesDateRange(from: tempFrom, to: tempTo, context: context));
                        } else {
                          bloc.add(MyAccountingCardEvent.updateRefundsDateRange(from: tempFrom, to: tempTo, context: context));
                        }
                        Navigator.pop(sheetContext);
                      },
                      child: Container(
                        decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(AppConstants.padding_10),
                        child: Text(AppLocalizations.of(context)!.apply, style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor)),
                      ),
                    ),
                  ),
                ]),
                16.height,
              ]),
            );
          });
        });
  }

  Widget _buildDateTile(String text, String hint) {
    final isSelected = text.isNotEmpty && text != hint;
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding_11),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(AppConstants.radius_10),
        color: isSelected ? AppColors.notificationColor.withValues(alpha: 0.08) : null,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(isSelected ? text : hint, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: isSelected ? AppColors.blackColor : AppColors.greyColor)),
        const Icon(Icons.calendar_today_outlined, size: AppConstants.font_20),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyAccountingCardBloc, MyAccountingCardState>(
        listenWhen: (previous, current) => previous.selectedTabIndex != current.selectedTabIndex,
        listener: (context, state) {},
        builder: (context, state) {
          final isInvoicesTab = state.selectedTabIndex == 0;
          final fromDate = isInvoicesTab ? state.invoicesFrom : state.refundsFrom;
          final toDate = isInvoicesTab ? state.invoicesTo : state.refundsTo;
          final periodText = '${_formatDate(fromDate)} – ${_formatDate(toDate)}';

          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(AppConstants.containerHeight_60),
                child: AppBar(
                  backgroundColor: AppColors.pageColor,
                  leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_sharp)),
                  title: state.isShimmering
                      ? CommonShimmerWidget(
                          child: Container(
                            margin: const EdgeInsets.all(AppConstants.padding_10),
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
                              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                            ),
                            child: const SizedBox(height: 30, width: 150),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
                          padding: const EdgeInsets.all(AppConstants.padding_10),
                          child: IntrinsicWidth(
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                '${AppLocalizations.of(context)!.remaining_to_pay}: ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                              ),
                              Directionality(
                                textDirection: widgets.TextDirection.ltr,
                                child: Text(
                                  formatSignedNumber(state.clientBalance),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ]),
                          ),
                        ),
                )),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.zero,
                child: state.isShimmering
                    ? const OrderSummaryScreenShimmerWidget(containerHeight: 140)
                    : Column(children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8), child: _topSquareTabBar(context, state)),
                        8.height,
                        GestureDetector(
                          onTap: () => _showDatePickerBottomSheet(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8, vertical: AppConstants.padding_8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8, vertical: AppConstants.padding_15),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(AppConstants.radius_10),
                                border: Border.all(color: AppColors.borderColor),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  '${AppLocalizations.of(context)!.date_range}: $periodText',
                                  style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.greyColor),
                                ),
                                Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.greyColor, size: AppConstants.font_20),
                              ]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state.selectedTabIndex == 0 ? _invoicesTab(context, state) : _refundsTab(context, state),
                          ),
                        ),
                      ]),
              ),
            ),
          );
        });
  }

  Widget _topSquareTabBar(BuildContext context, MyAccountingCardState state) {
    String formatAmount(double amount) {
      final isNegative = amount < 0;
      final value = NumberFormat.decimalPattern('en_IN').format(amount.abs());
      final sign = isNegative ? '-' : '';
      final text = '$sign$value ₪';
      return '\u202A$text\u202C';
    }

    String amountWithParentheses(double amount) {
      return '(${formatAmount(amount)})';
    }

    final tabs = [
      '${AppLocalizations.of(context)!.invoices} ${amountWithParentheses(state.totalInvoiceAmount)}',
      '${AppLocalizations.of(context)!.refunds} ${amountWithParentheses(state.totalRefundAmount)}',
    ];

    return Container(
      padding: const EdgeInsets.all(AppConstants.padding_5),
      height: 50,
      decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, color: AppColors.pageColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final bool selected = state.selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<MyAccountingCardBloc>().add(MyAccountingCardEvent.changeTab(index));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: selected ? AppColors.whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.radius_10),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_15,
                      color: selected ? AppColors.blackColor : AppColors.whiteColor,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _invoicesTab(BuildContext context, MyAccountingCardState state) {
    if (state.isShimmering) {
      return const OrderSummaryScreenShimmerWidget(containerHeight: 140);
    }

    if (!state.isShimmering && state.invoiceCardList.isEmpty) {
      return noDataWidget(AppLocalizations.of(context)!.no_invoice_data);
    }

    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        key: const ValueKey('invoices_tab_list'),
        controller: state.invoicesScrollController,
        itemCount: state.invoiceCardList.length,
        itemBuilder: (context, index) {
          Widget itemOne(MyAccountingCardState state) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleText(context, AppLocalizations.of(context)!.invoice),
                  GestureDetector(
                    onTap: () {
                      final refundInvoiceData = MyCardInvoice(
                        invoiceLink: state.invoiceCardList[index].invoiceLink,
                        invoiceNumber: state.invoiceCardList[index].invoiceNumber,
                        invoiceAmount: state.invoiceCardList[index].invoiceAmount,
                        paymentStatus: state.invoiceCardList[index].paymentStatus,
                        invoiceDate: state.invoiceCardList[index].invoiceDate,
                        dueDate: state.invoiceCardList[index].dueDate,
                        orderNumber: state.invoiceCardList[index].orderNumber,
                        orderId: state.invoiceCardList[index].orderId,
                        rivchitApiKey: state.invoiceCardList[index].rivchitApiKey,
                      );

                      final invoiceData = Invoice(
                        invoiceLink: refundInvoiceData.invoiceLink,
                        invoiceNumber: refundInvoiceData.invoiceNumber.toString(),
                        invoiceAmount: refundInvoiceData.invoiceAmount,
                        paymentStatus: refundInvoiceData.paymentStatus,
                        invoiceDate: refundInvoiceData.invoiceDate,
                        dueDate: refundInvoiceData.dueDate,
                        orderNumber: refundInvoiceData.orderNumber,
                        orderId: state.invoiceCardList[index].orderId,
                        rivchitApiKey: state.invoiceCardList[index].rivchitApiKey,
                      );

                      Navigator.pushNamed(context, RouteDefine.invoicePdfScreen.name, arguments: {
                        AppStrings.invoiceListString: invoiceData,
                        AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_invoices,
                      });
                    },
                    child: invoiceOrderNumberWidget(state.invoiceCardList[index].invoiceNumber.toString()),
                  ),
                ]),
                state.invoiceCardList[index].paymentStatus != null ? getPaymentStatusWidget(state.invoiceCardList[index].paymentStatus!, context) : 0.width
              ]);

          Widget itemTwo(MyAccountingCardState state) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    titleText(context, AppLocalizations.of(context)!.invoice_date),
                    subTitleValueText(
                      context,
                      (state.invoiceCardList[index].invoiceDate ?? '').isNotEmpty ? state.invoiceCardList[index].invoiceDate!.substring(0, 10) : '---',
                    ),
                  ]),
                ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    titleText(context, AppLocalizations.of(context)!.due_date),
                    subTitleValueText(
                      context,
                      (state.invoiceCardList[index].dueDate ?? '').isNotEmpty ? state.invoiceCardList[index].dueDate!.substring(0, 10) : '---',
                    ),
                  ]),
                ),
              ]);

          Widget itemThree(MyAccountingCardState state) {
            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleText(context, AppLocalizations.of(context)!.for_order),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                      preferences.setOrderId(productOrderId: state.invoiceCardList[index].orderId.toString());
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                                    statusList: state.statusList,
                                    orderNumber: state.invoiceCardList[index].orderNumber.toString(),
                                    orderId: state.invoiceCardList[index].orderId.toString(),
                                    isNavigateToProductDetailString: true,
                                  ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.bounceIn;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                return SlideTransition(position: animation.drive(tween), child: child);
                              }));
                    },
                    child: state.invoiceCardList[index].orderNumber == null ? const Text('---') : invoiceOrderNumberWidget(state.invoiceCardList[index].orderNumber.toString()),
                  ),
                ]),
              ),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleText(context, AppLocalizations.of(context)!.total_invoice_amount),
                  Directionality(
                    textDirection: widgets.TextDirection.ltr,
                    child: subTitleValueText(context, formatSignedNumber(state.invoiceCardList[index].invoiceAmount)),
                  ),
                ]),
              ),
            ]);
          }

          return Container(
            margin: const EdgeInsets.all(AppConstants.padding_8),
            padding: const EdgeInsets.all(AppConstants.padding_8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.borderColor),
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
            ),
            child: Column(children: [itemOne(state), const DividerWidget(height: 20.0), itemTwo(state), const DividerWidget(height: 20.0), itemThree(state)]),
          );
        });
  }

  Widget _refundsTab(BuildContext context, MyAccountingCardState state) {
    if (!state.isShimmering && state.refundInvoicesCardList.isEmpty) {
      return noDataWidget(AppLocalizations.of(context)!.no_refund_data);
    }

    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        key: const ValueKey('refunds_tab_list'),
        controller: state.refundsScrollController,
        itemCount: state.refundInvoicesCardList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(AppConstants.padding_8),
            padding: const EdgeInsets.all(AppConstants.padding_8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.borderColor),
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              _refundInvoiceWidget(
                state.refundInvoicesCardList,
                index,
                context,
                state.refundInvoicesCardList[index].invoiceNumber.toString(),
                state.statusList,
                state.refundInvoicesCardList[index].invoiceDate.toString(),
                state.refundInvoicesCardList[index].status.toString(),
              ),
              state.refundInvoicesCardList[index].status.toString() != AppStrings.closedText || state.refundInvoicesCardList[index].refundedOnInvoice!.isNotEmpty
                  ? const DividerWidget(
                      height: 20.0,
                    )
                  : const IgnorePointer(),
              (state.refundInvoicesCardList[index].refundedOnOrders!.isEmpty && state.refundInvoicesCardList[index].status.toString() != AppStrings.openText)
                  ? const IgnorePointer()
                  : titleText(
                      context,
                      AppLocalizations.of(context)!.refunded_on_order,
                    ),
              (state.refundInvoicesCardList[index].refundedOnOrders!.isEmpty && state.refundInvoicesCardList[index].status.toString() == AppStrings.openText)
                  ? const Text('---')
                  : _refundedOnOrderWidget(
                      state.refundInvoicesCardList,
                      index,
                      state.refundInvoicesCardList[index].invoiceNumber.toString(),
                      state.statusList,
                    ),
              state.refundInvoicesCardList[index].refundedOnInvoice!.isEmpty ? const IgnorePointer() : titleText(context, AppLocalizations.of(context)!.refunded_on_invoices),
              state.refundInvoicesCardList[index].refundedOnInvoice!.isEmpty
                  ? const IgnorePointer()
                  : _refundedOnInvoiceWidget(
                      state.refundInvoicesCardList,
                      index,
                      state.refundInvoicesCardList[index].invoiceNumber.toString(),
                      state.refundInvoicesCardList[index].refundedOnInvoice!,
                    ),
              const DividerWidget(height: 20.0),
              _totalRefundWidget(context, state.refundInvoicesCardList[index].totalAmount.toString(), state.refundInvoicesCardList[index].remainingAmount.toString()),
            ]),
          );
        });
  }

  Widget _refundInvoiceWidget(
    List<RefundInvoiceCommon> invoicesList,
    int index,
    BuildContext context,
    String invoiceNumber,
    List<StatusData> statusList,
    String invoiceDate,
    String invoiceStatus,
  ) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleText(context, AppLocalizations.of(context)!.invoice_number),
          invoiceNumber.isEmpty
              ? const IgnorePointer()
              : GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteDefine.refundPdfScreen.name, arguments: {
                      AppStrings.invoiceListString: invoicesList[index],
                      AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_refunds,
                    });
                  },
                  child: invoiceOrderNumberWidget(invoiceNumber),
                ),
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [titleText(context, AppLocalizations.of(context)!.invoice_date), subTitleValueText(context, formatInvoiceDate(invoiceDate))],
        ),
        getPaymentStatusWidget(invoiceStatus, context)
      ]);

  Widget _refundedOnOrderWidget(List<RefundInvoiceCommon> invoicesList, int index, String invoiceNumber, List<StatusData> statusList) => ListView.builder(
      itemCount: invoicesList[index].refundedOnOrders?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, orderIndex) {
        final order = invoicesList[index].refundedOnOrders![orderIndex];

        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              invoiceNumber.isEmpty
                  ? const IgnorePointer()
                  : GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final helper = SharedPreferencesHelper(prefs: prefs);
                        helper.setOrderId(productOrderId: order.orderId ?? '');
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                                    statusList: statusList,
                                    orderNumber: order.orderNumber ?? '',
                                    orderId: order.orderId ?? '',
                                    isNavigateToProductDetailString: true,
                                  ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.bounceIn;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                return SlideTransition(position: animation.drive(tween), child: child);
                              }),
                        );
                      },
                      child: invoiceOrderNumberWidget(order.orderNumber ?? ''),
                    ),
            ]),
            Expanded(child: titleGreenText(context, formatSignedNumber(order.orderAdjustAmount), widgets.TextDirection.ltr)),
            2.height,
            getPaymentStatusWidget(order.status!, context)
          ]),
        );
      });

  Widget _refundedOnInvoiceWidget(List<RefundInvoiceCommon> invoicesList, int index, String invoiceNumber, List<RefundedInvoiceCommon> refundedOnInvoice) => ListView.builder(
      itemCount: refundedOnInvoice.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, invoiceIndex) {
        final inv = refundedOnInvoice[invoiceIndex];

        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
            invoiceNumber.isEmpty
                ? const IgnorePointer()
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GestureDetector(
                      onTap: () {
                        final invoiceData = Invoice(
                          invoiceLink: inv.invoiceLink,
                          invoiceNumber: inv.invoiceNumber ?? '',
                          invoiceAmount: inv.invoiceAmount,
                          paymentStatus: inv.paymentStatus,
                          invoiceDate: inv.invoiceDate,
                          dueDate: inv.dueDate,
                          invoiceAdjustAmount: double.tryParse(inv.invoiceAdjustAmount ?? '0') ?? 0.0,
                          status: inv.status,
                          orderNumber: inv.orderNumber,
                          orderId: inv.orderId,
                          rivchitApiKey: inv.rivchitApiKey,
                        );

                        Navigator.pushNamed(
                          context,
                          RouteDefine.invoicePdfScreen.name,
                          arguments: {AppStrings.invoiceListString: invoiceData, AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_invoices},
                        );
                      },
                      child: invoiceOrderNumberWidget(inv.invoiceNumber ?? ''),
                    ),
                  ]),
            Expanded(child: titleGreenText(context, formatSignedNumber(inv.invoiceAdjustAmount), widgets.TextDirection.ltr)),
            2.height,
            getPaymentStatusWidget(inv.status!, context)
          ]),
        );
      });

  Widget invoiceOrderNumberWidget(String title) => Stack(alignment: Alignment.bottomLeft, children: [
        Text(
          title,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.notificationColor, fontWeight: FontWeight.w400),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(height: 1, color: AppColors.notificationColor, margin: const EdgeInsets.only(top: AppConstants.padding_3)),
        ),
      ]);

  Widget _totalRefundWidget(BuildContext context, String totalAmount, String remainingAmount) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [titleText(context, AppLocalizations.of(context)!.total_refunds), subTitleText(context, formatSignedNumber(totalAmount))],
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppConstants.padding_5),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            titleText(context, AppLocalizations.of(context)!.remaining_refund),
            titleGreenText(context, formatSignedNumber(remainingAmount), widgets.TextDirection.ltr),
          ]),
        )
      ]);

  Widget subTitleText(BuildContext context, String subTitle) => Directionality(
      textDirection: widgets.TextDirection.ltr,
      child: Text(
        subTitle,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));
}
