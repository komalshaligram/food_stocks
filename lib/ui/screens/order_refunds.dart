import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/status_info_res_model/status_info_res_model.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/order_refunds/order_refunds_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_divider_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';
import '../widget/refresh_widget.dart';

class OrderRefundsRoute {
  static Widget get route => const OrderRefundsScreen();
}

class OrderRefundsScreen extends StatelessWidget {
  const OrderRefundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderRefundsBloc()..add(OrderRefundsEvent.getRefundDataEvent(context: context)),
      child: const OrderRefundsScreenWidget(),
    );
  }
}

class OrderRefundsScreenWidget extends StatelessWidget {
  const OrderRefundsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderRefundsBloc, OrderRefundsState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: '${AppLocalizations.of(context)!.refunds_for_order}${state.orderNumber}',
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SmartRefresher(
            enablePullDown: true,
            controller: state.refreshController,
            header: const RefreshWidget(),
            footer: CustomFooter(builder: (context, mode) => const OrderSummaryScreenShimmerWidget(itemCount: 2)),
            enablePullUp: !state.isBottomOfProducts,
            onRefresh: () {
              context.read<OrderRefundsBloc>().add(OrderRefundsEvent.refreshListEvent(context: context));
            },
            onLoading: () {
              context.read<OrderRefundsBloc>().add(OrderRefundsEvent.getRefundDataEvent(context: context));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
              child: state.isShimmering
                  ? const OrderSummaryScreenShimmerWidget(containerHeight: 140)
                  : state.invoiceDetailsList.isEmpty
                      ? _buildNoData(context)
                      : ListView.builder(
                          itemCount: state.invoiceDetailsList.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final invoice = state.invoiceDetailsList[index];
                            return RefundInvoiceCard(invoice: invoice, statusList: state.statusList, index: index);
                          }),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNoData(BuildContext context) {
    return SizedBox(height: getScreenHeight(context) * 0.8, child: noDataWidget(AppLocalizations.of(context)!.no_data));
  }
}

class RefundInvoiceCard extends StatelessWidget {
  final RefundInvoiceCommon invoice;
  final List<StatusData> statusList;
  final int index;

  const RefundInvoiceCard({super.key, required this.invoice, required this.statusList, required this.index});

  @override
  Widget build(BuildContext context) {
    final hasRefundedOrders = invoice.refundedOnOrders?.isNotEmpty ?? false;
    final hasRefundedInvoices = invoice.refundedOnInvoice?.isNotEmpty ?? false;
    final isOpen = invoice.status == AppStrings.openText;
    final isClosed = invoice.status == AppStrings.closedText;

    return Container(
      margin: const EdgeInsets.all(AppConstants.padding_8),
      padding: const EdgeInsets.all(AppConstants.padding_8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildMainInvoiceRow(context),
        if (!isClosed || hasRefundedInvoices) const DividerWidget(height: 20.0),
        if (hasRefundedOrders || isOpen) ...[
          _sectionTitle(context, AppLocalizations.of(context)!.refunded_on_order),
          if (hasRefundedOrders) _buildRefundedOrdersList(context) else Text('---', style: TextStyle(color: AppColors.blackColor)),
        ],
        if (hasRefundedInvoices) ...[_sectionTitle(context, AppLocalizations.of(context)!.refunded_on_invoices), _buildRefundedInvoicesList(context)],
        const DividerWidget(height: 20.0),
        _buildTotalRefundRow(context),
      ]),
    );
  }

  Widget _buildMainInvoiceRow(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        titleText(context, AppLocalizations.of(context)!.invoice_number),
        if (invoice.invoiceNumber?.isNotEmpty ?? false)
          _clickableUnderlinedText(
              context: context,
              text: invoice.invoiceNumber!,
              onTap: () => Navigator.pushNamed(
                    context,
                    RouteDefine.refundPdfScreen.name,
                    arguments: {AppStrings.invoiceListString: invoice, AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_refunds},
                  ))
      ]),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleText(context, AppLocalizations.of(context)!.invoice_date), _valueText(context, formatInvoiceDate(invoice.invoiceDate ?? ''))],
      ),
      getPaymentStatusWidget(invoice.status ?? '', context)
    ]);
  }

  Widget _buildRefundedOrdersList(BuildContext context) {
    return ListView.builder(
        itemCount: invoice.refundedOnOrders?.length ?? 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          final order = invoice.refundedOnOrders![i];
          return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
              child: _refundEntryRow(
                  context: context,
                  label: order.orderNumber ?? '',
                  amount: order.orderAdjustAmount ?? '',
                  status: order.status ?? '',
                  onLabelTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final helper = SharedPreferencesHelper(prefs: prefs);
                    await helper.setOrderId(productOrderId: order.orderId ?? '');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ProductDetailsScreen(
                                statusList: statusList,
                                orderNumber: order.orderNumber ?? '',
                                orderId: order.orderId ?? '',
                                isNavigateToProductDetailString: true,
                              ),
                          transitionsBuilder: (_, animation, __, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.bounceIn;
                            return SlideTransition(position: animation.drive(Tween(begin: begin, end: end).chain(CurveTween(curve: curve))), child: child);
                          }),
                    );
                  }));
        });
  }

  Widget _buildRefundedInvoicesList(BuildContext context) {
    return ListView.builder(
        itemCount: invoice.refundedOnInvoice?.length ?? 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          final inv = invoice.refundedOnInvoice![i];
          return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
              child: _refundEntryRow(
                  context: context,
                  label: inv.invoiceNumber ?? '',
                  amount: inv.invoiceAdjustAmount ?? '',
                  status: inv.status ?? '',
                  onLabelTap: () {
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
                  }));
        });
  }

  Widget _buildTotalRefundRow(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleText(context, AppLocalizations.of(context)!.total_refunds), _valueText(context, formatSignedNumber(invoice.totalAmount.toString()))],
      ),
      Padding(
        padding: const EdgeInsets.only(right: AppConstants.padding_5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleText(context, AppLocalizations.of(context)!.remaining_refund),
          titleGreenText(context, formatSignedNumber(invoice.remainingAmount.toString()), TextDirection.ltr),
        ]),
      ),
    ]);
  }

  Widget _sectionTitle(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.only(top: AppConstants.padding_4, bottom: AppConstants.padding_6),
        child: titleText(context, title),
      );

  Widget _valueText(BuildContext context, String text) => Directionality(
        textDirection: TextDirection.ltr,
        child: Text(text, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor), maxLines: 1, overflow: TextOverflow.ellipsis),
      );

  Widget _clickableUnderlinedText({required BuildContext context, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(alignment: Alignment.bottomLeft, children: [
        Text(text, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.notificationColor, fontWeight: FontWeight.w400), maxLines: 2, overflow: TextOverflow.ellipsis),
        Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 1, color: AppColors.notificationColor, margin: const EdgeInsets.only(top: AppConstants.padding_3))),
      ]),
    );
  }

  Widget _refundEntryRow({required BuildContext context, required String label, required String amount, required String status, required VoidCallback onLabelTap}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
      _clickableUnderlinedText(context: context, text: label, onTap: onLabelTap),
      Expanded(
        flex: 2,
        child: titleGreenText(context, formatSignedNumber(amount), TextDirection.ltr),
      ),
      getPaymentStatusWidget(status, context)
    ]);
  }
}
