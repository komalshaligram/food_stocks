import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/status_info_res_model/status_info_res_model.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/order_refunds/order_refunds_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/model/res_model/refund_res/refund_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';


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
    return BlocBuilder<OrderRefundsBloc, OrderRefundsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.refunds_for_order + (state.orderNumber.toString() ?? ''),
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: state.isShimmering
                ? const OrderSummaryScreenShimmerWidget(
                    containerHeight: 140,
                  )
                : !state.isShimmering && state.invoiceDetailsList.isEmpty
                    ? SizedBox(
                        height: getScreenHeight(context) * 0.8,
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)!.no_data,
                          style: AppStyles.pVRegularTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.w400),
                        )),
                      )
                    : Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                              itemCount: state.invoiceDetailsList.length,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) => refundList(
                                index: index,
                                invoicesList: state.invoiceDetailsList,
                                context: context,
                                invoiceNumber: state.invoiceDetailsList[index].invoiceNumber.toString(),
                                invoiceLink: state.invoiceDetailsList[index].invoiceLink.toString(),
                                invoiceDate: state.invoiceDetailsList[index].invoiceDate.toString(),
                                invoiceStatus: state.invoiceDetailsList[index].status.toString(),
                                refundedOnOrders: state.invoiceDetailsList[index].refundedOnOrders!,
                                refundedOnInvoice: state.invoiceDetailsList[index].refundedOnInvoice!,
                                totalAmount: state.invoiceDetailsList[index].totalAmount.toString(),
                                remainingAmount: state.invoiceDetailsList[index].remainingAmount.toString(),
                                statusList: state.statusList,
                              ),
                            ),
                          ),
                        ],
                      ),
            // ),
          )),
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
          invoiceStatus != AppStrings.closedText || refundedOnInvoice.isNotEmpty
              ? Divider(height: 20.0, color: AppColors.borderColor)
              : const IgnorePointer(),
          (refundedOnOrders.isEmpty && invoiceStatus != AppStrings.openText)
              ? const IgnorePointer()
              : titleText(context, AppLocalizations.of(context)!.refunded_on_order),
          (refundedOnOrders.isEmpty && invoiceStatus == AppStrings.openText)
              ? const Text('---')
              : _refundedOnOrderWidget(invoicesList, index, invoiceNumber, statusList),
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
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
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
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
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
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
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
