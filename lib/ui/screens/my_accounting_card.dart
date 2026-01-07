import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/status_info_res_model/status_info_res_model.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/my_accounting_card/my_accounting_card_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/model/res_model/my_account_card_res/my_account_card_res_model.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class MyAccountingCardRoute {
  static Widget get route => const MyAccountingCardScreen();
}

class MyAccountingCardScreen extends StatelessWidget {
  const MyAccountingCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAccountingCardBloc()..add(MyAccountingCardEvent.getRefundDataEvent(context: context)),
      child: const MyAccountingCardScreenWidget(),
    );
  }
}

class MyAccountingCardScreenWidget extends StatelessWidget {
  const MyAccountingCardScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAccountingCardBloc, MyAccountingCardState>(
      builder: (context, state) {
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
                            boxShadow: [
                              BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
                            ],
                            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                          ),
                          child: const SizedBox(
                            height: 30,
                            width: 150,
                            // width: 50,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.appMainGradientColor,
                          borderRadius: BorderRadius.circular(AppConstants.padding_10),
                        ),
                        padding: const EdgeInsets.all(AppConstants.padding_10),
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.remaining_to_pay}: ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.rkBoldTextStyle(
                                  size: AppConstants.normalFont,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  '${state.clientBalance}₪',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.normalFont,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              )),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: state.isShimmering
                  ? const OrderSummaryScreenShimmerWidget(
                      containerHeight: 140,
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _topSquareTabBar(context, state),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state.selectedTabIndex == 0 ? _invoicesTab(context, state) : _ordersTab(context, state),
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

  Widget _topSquareTabBar(BuildContext context, MyAccountingCardState state) {
    String formatAmount(double amount) {
      final isNegative = amount < 0;
      final value = amount.abs().toStringAsFixed(1);
      final sign = isNegative ? '-' : '';
      final text = '$sign$value₪';
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
      padding: const EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        gradient: AppColors.appMainGradientColor,
        color: AppColors.pageColor,
        borderRadius: BorderRadius.circular(10),
      ),
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.mediumFont,
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
      return const OrderSummaryScreenShimmerWidget(
        containerHeight: 140,
      );
    }

    if (!state.isShimmering && state.invoiceCardList.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.no_invoice_data,
          style: AppStyles.pVRegularTextStyle(
            size: AppConstants.normalFont,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.invoiceCardList.length,
      itemBuilder: (context, index) {
        Widget keyTextWidget(String key) => Text(
              key,
              style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.smallFont, fontWeight: FontWeight.w700),
            );

        Widget valueTextWidget(String value) => Text(
              value,
              style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.smallFont, fontWeight: FontWeight.w400),
            );

        Widget itemOne(MyAccountingCardState state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    keyTextWidget(AppLocalizations.of(context)!.invoice),
                    GestureDetector(
                      onTap: () {
                        final refundInvoiceData = MyCardRefundInvoice(
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
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Text(
                            state.invoiceCardList[index].invoiceNumber.toString(),
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.notificationColor,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: AppColors.notificationColor,
                              margin: const EdgeInsets.only(top: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                state.invoiceCardList[index].paymentStatus != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: state.invoiceCardList[index].paymentStatus == AppStrings.openText ? AppColors.statusOpenColor : AppColors.statusCloseColor,
                        ),
                        child: Text(
                          state.invoiceCardList[index].paymentStatus == AppStrings.openText ? AppLocalizations.of(context)!.invoice_open : AppLocalizations.of(context)!.invoice_close,
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w700),
                        ),
                      )
                    : 0.width
              ],
            );

        Widget itemTwo(MyAccountingCardState state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      keyTextWidget(AppLocalizations.of(context)!.invoice_date),
                      valueTextWidget((state.invoiceCardList[index].invoiceDate ?? '').isNotEmpty ? state.invoiceCardList[index].invoiceDate!.substring(0, 10) : ''),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      keyTextWidget(AppLocalizations.of(context)!.due_date),
                      valueTextWidget((state.invoiceCardList[index].dueDate ?? '').isNotEmpty ? state.invoiceCardList[index].dueDate!.substring(0, 10) : '---'),
                    ],
                  ),
                ),
              ],
            );

        Widget itemThree(MyAccountingCardState state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      keyTextWidget(AppLocalizations.of(context)!.for_order),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                                  statusList: state.statusList,
                                  orderNumber: state.invoiceCardList[index].orderNumber.toString() ?? '',
                                  orderId: state.invoiceCardList[index].orderId.toString() ?? '',
                                  isNavigateToProductDetailString: true,
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.bounceIn;
                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));
                        },
                        child: state.invoiceCardList[index].orderNumber == null
                            ? const Text('---')
                            : Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  Text(
                                    state.invoiceCardList[index].orderNumber.toString(),
                                    style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.notificationColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 1,
                                      color: AppColors.notificationColor,
                                      margin: const EdgeInsets.only(top: 4),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      keyTextWidget(AppLocalizations.of(context)!.total_invoice_amount),
                      valueTextWidget('${state.invoiceCardList[index].invoiceAmount}₪'),
                    ],
                  ),
                ),
              ],
            );

        return Container(
          margin: const EdgeInsets.all(AppConstants.padding_8),
          padding: const EdgeInsets.all(AppConstants.padding_8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.borderColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                AppConstants.radius_10,
              ),
            ),
          ),
          child: Column(
            children: [
              itemOne(state),
              Divider(
                height: 20.0,
                color: AppColors.borderColor,
              ),
              itemTwo(state),
              Divider(
                height: 20.0,
                color: AppColors.borderColor,
              ),
              itemThree(state),
            ],
          ),
        );
      },
    );
  }

  Widget _ordersTab(BuildContext context, MyAccountingCardState state) {
    if (!state.isShimmering && state.refundInvoicesCardList.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.no_refund_data,
          style: AppStyles.pVRegularTextStyle(
            size: AppConstants.normalFont,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.refundInvoicesCardList.length,
      itemBuilder: (context, index) {
        return refundList(
          index: index,
          invoicesList: state.refundInvoicesCardList,
          context: context,
          invoiceNumber: state.refundInvoicesCardList[index].invoiceNumber.toString(),
          invoiceLink: state.refundInvoicesCardList[index].invoiceLink.toString(),
          invoiceDate: state.refundInvoicesCardList[index].invoiceDate.toString(),
          invoiceStatus: state.refundInvoicesCardList[index].status.toString(),
          refundedOnOrders: state.refundInvoicesCardList[index].refundedOnOrders!,
          refundedOnInvoice: state.refundInvoicesCardList[index].refundedOnInvoice!,
          totalAmount: state.refundInvoicesCardList[index].totalAmount.toString(),
          remainingAmount: state.refundInvoicesCardList[index].remainingAmount.toString(),
          statusList: state.statusList,
        );
      },
    );
  }

  Widget refundList({
    required BuildContext context,
    required String remainingAmount,
    required String totalAmount,
    required List<RefundedInvoiceCommon> refundedOnInvoice,
    required List<RefundedOrderCommon> refundedOnOrders,
    required String invoiceDate,
    required String invoiceLink,
    required String invoiceStatus,
    required String invoiceNumber,
    required List<RefundInvoiceCommon> invoicesList,
    required int index,
    required List<StatusData> statusList,
  }) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.padding_8),
      padding: const EdgeInsets.all(AppConstants.padding_8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _refundInvoiceWidget(invoicesList, index, context, invoiceNumber, statusList, invoiceDate, invoiceStatus),
          invoiceStatus != AppStrings.closedText || refundedOnInvoice.isNotEmpty ? Divider(height: 20.0, color: AppColors.borderColor) : const IgnorePointer(),
          (refundedOnOrders.isEmpty && invoiceStatus != AppStrings.openText) ? const IgnorePointer() : titleText(context, AppLocalizations.of(context)!.refunded_on_order),
          (refundedOnOrders.isEmpty && invoiceStatus == AppStrings.openText) ? const Text('---') : _refundedOnOrderWidget(invoicesList, index, invoiceNumber, statusList),
          refundedOnInvoice.isEmpty ? const IgnorePointer() : titleText(context, AppLocalizations.of(context)!.refunded_on_invoices),
          refundedOnInvoice.isEmpty ? const IgnorePointer() : _refundedOnInvoiceWidget(invoicesList, index, invoiceNumber, refundedOnInvoice),
          Divider(height: 20.0, color: AppColors.borderColor),
          _totalRefundWidget(context, totalAmount, remainingAmount),
        ],
      ),
    );
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(context, AppLocalizations.of(context)!.invoice_number),
              invoiceNumber.isEmpty
                  ? const IgnorePointer()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteDefine.refundPdfScreen.name,
                          arguments: {
                            AppStrings.invoiceListString: invoicesList[index],
                            AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_refunds,
                          },
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Text(
                            invoiceNumber,
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.notificationColor,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: AppColors.notificationColor,
                              margin: const EdgeInsets.only(top: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(context, AppLocalizations.of(context)!.invoice_date),
              subTitleValueText(context, _formatInvoiceDate(invoiceDate)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: invoiceStatus == AppStrings.openText
                  ? AppColors.statusOpenColor
                  : invoiceStatus == AppStrings.closedText
                      ? AppColors.statusCloseColor
                      : invoiceStatus == AppStrings.inProgressText
                          ? AppColors.statusInProgressColor
                          : AppColors.statusPartiallyClosedColor,
            ),
            child: Text(
              invoiceStatus == AppStrings.openText
                  ? AppLocalizations.of(context)!.open_text
                  : invoiceStatus == AppStrings.closedText
                      ? AppLocalizations.of(context)!.closed_text
                      : invoiceStatus == AppStrings.inProgressText
                          ? AppLocalizations.of(context)!.in_progress_text
                          : invoiceStatus == AppStrings.partiallyClosedText
                              ? AppLocalizations.of(context)!.partially_closed_text
                              : '',
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );

  Widget _refundedOnOrderWidget(
    List<RefundInvoiceCommon> invoicesList,
    int index,
    String invoiceNumber,
    List<StatusData> statusList,
  ) =>
      ListView.builder(
        itemCount: invoicesList[index].refundedOnOrders?.length ?? 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, orderIndex) {
          final order = invoicesList[index].refundedOnOrders![orderIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  },
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Text(
                                  order.orderNumber ?? '',
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.notificationColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 1,
                                    color: AppColors.notificationColor,
                                    margin: const EdgeInsets.only(top: 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
                Expanded(
                  child: titleGreenText(context, '${order.orderAdjustAmount ?? ''}₪'),
                ),
                2.height,
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.statusInProgressColor,
                  ),
                  child: Text(
                    order.status == AppStrings.inProgressText ? AppLocalizations.of(context)!.in_progress_text : '',
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        },
      );

  Widget _refundedOnInvoiceWidget(
    List<RefundInvoiceCommon> invoicesList,
    int index,
    String invoiceNumber,
    List<RefundedInvoiceCommon> refundedOnInvoice,
  ) =>
      ListView.builder(
        itemCount: refundedOnInvoice.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, invoiceIndex) {
          final inv = refundedOnInvoice[invoiceIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                invoiceNumber.isEmpty
                    ? const IgnorePointer()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                arguments: {
                                  AppStrings.invoiceListString: invoiceData,
                                  AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_invoices,
                                },
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Text(
                                  inv.invoiceNumber ?? '',
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.notificationColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 1,
                                    color: AppColors.notificationColor,
                                    margin: const EdgeInsets.only(top: 4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                Expanded(
                  child: titleGreenText(context, '${inv.invoiceAdjustAmount ?? ''} ₪'),
                ),
                2.height,
                Container(
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.statusCloseColor,
                  ),
                  child: Text(
                    inv.status == AppStrings.closedText ? AppLocalizations.of(context)!.closed_text : '',
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        },
      );

  Widget _totalRefundWidget(BuildContext context, String totalAmount, String remainingAmount) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(context, AppLocalizations.of(context)!.total_refunds),
              subTitleText(context, formatNumber(value: totalAmount, local: AppStrings.hebrewLocal)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppConstants.padding_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText(context, AppLocalizations.of(context)!.remaining_refund),
                titleGreenText(context, formatNumber(value: remainingAmount, local: AppStrings.hebrewLocal)),
              ],
            ),
          )
        ],
      );

  Widget titleText(BuildContext context, String title) => Text(
        title,
        style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget titleValueText(BuildContext context, String title) => Text(
        title,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget subTitleText(BuildContext context, String subTitle) => Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        subTitle,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));

  Widget subTitleValueText(BuildContext context, String subTitle) => Text(
        subTitle,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget titleGreenText(BuildContext context, String title) => Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.notificationColor, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  String? getType(String type, BuildContext context) {
    if (type == AppStrings.pending) {
      return AppLocalizations.of(context)!.pending;
    } else if (type == AppStrings.paid) {
      return AppLocalizations.of(context)!.paid;
    }
    return '';
  }

  String _formatInvoiceDate(String date) {
    if (date.isEmpty) return '';

    if (date.length > 10) {
      return date.substring(0, 10);
    }

    return date;
  }
}
