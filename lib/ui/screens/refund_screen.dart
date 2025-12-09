import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/status_info_res_model/status_info_res_model.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/model/res_model/refund_res/refund_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/refund/refund_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class RefundRoute {
  static Widget get route => const RefundScreen();
}

class RefundScreen extends StatelessWidget {
  const RefundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RefundBloc()..add(RefundEvent.getRefundDataEvent(context: context)),
      child: const RefundScreenWidget(),
    );
  }
}

class RefundScreenWidget extends StatelessWidget {
  const RefundScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundBloc, RefundState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.my_refunds,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child:
                // SmartRefresher(
                //   enablePullDown: true,
                //   controller: state.refreshController,
                //   header: const RefreshWidget(),
                //   footer: CustomFooter(
                //       builder: (context, mode) => const OrderSummaryScreenShimmerWidget(
                //             containerHeight: 140,
                //           )),
                //   enablePullUp: !state.isBottomOfProducts,
                //   onRefresh: () {
                //     context.read<RefundBloc>().add(RefundEvent.refreshListEvent(context: context));
                //   },
                //   onLoading: () {
                //     context.read<RefundBloc>().add(RefundEvent.getRefundDataEvent(context: context));
                //   },
                //   child:
                state.isShimmering
                    ? Column(
                        children: [
                          CommonShimmerWidget(
                            child: Container(
                              margin: const EdgeInsets.all(AppConstants.padding_10),
                              padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                // boxShadow: [
                                //   BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
                                // ],
                                borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5),),

                              ),
                              child: Container(
                                height: 50,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: OrderSummaryScreenShimmerWidget(
                              containerHeight: 140,
                            ),
                          ),
                        ],
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
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(AppConstants.radius_10),
                                  ),
                                  border: Border.all(color: AppColors.borderColor, width: 1),
                                ),
                                margin: const EdgeInsets.all(AppConstants.padding_8),
                                padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.total_refund,
                                      style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_8, horizontal: AppConstants.padding_10),
                                      decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(5.0)),
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          '${state.openTotalAmount}₪',
                                          // formatNumber(value: state.openTotalAmount, local: AppStrings.hebrewLocal),
                                          style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor),
                                        ),
                                      ),
                                    ),
                                    // 5.w,
                                  ],
                                ),
                              ),
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
    required List<RefundedInvoice> refundedOnInvoice,
    required List<RefundedOrder> refundedOnOrders,
    required String invoiceDate,
    required String invoiceLink,
    required String invoiceStatus,
    required String invoiceNumber,
    required List<RefundInvoice> invoicesList,
    required int index,
    required List<StatusData> statusList,
  }) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.padding_8),
      padding: const EdgeInsets.all(AppConstants.padding_8),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.borderColor),
          // boxShadow: [
          //   BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
          // ],
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _refundInvoiceWidget(invoicesList, index, context, invoiceNumber, statusList, invoiceDate, invoiceStatus),
          invoiceStatus != AppStrings.closedText || refundedOnInvoice.isNotEmpty
              ? Divider(
                  height: 20.0,
                  color: AppColors.borderColor,
                )
              : const IgnorePointer(),
          (refundedOnOrders.isEmpty && invoiceStatus != AppStrings.openText)
              ? const IgnorePointer()
              : subTitleText(
                  context,
                  AppLocalizations.of(context)!.refunded_on_order,
                ),
          (refundedOnOrders.isEmpty && invoiceStatus == AppStrings.openText)
              ? const Text('---')
              : _refundedOnOrderWidget(
                  invoicesList,
                  index,
                  invoiceNumber,
                  statusList,
                ),
          refundedOnInvoice.isEmpty ? const IgnorePointer() : subTitleText(context, AppLocalizations.of(context)!.refunded_on_invoices),
          refundedOnInvoice.isEmpty ? const IgnorePointer() : _refundedOnInvoiceWidget(invoicesList, index, invoiceNumber, refundedOnInvoice),
           Divider(
            height: 20.0,
            color: AppColors.borderColor,
          ),
          _totalRefundWidget(context, totalAmount, remainingAmount),
        ],
      ),
    );
  }

  Widget _refundInvoiceWidget(
    List<RefundInvoice> invoicesList,
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
              invoiceNumber == ''
                  ? const IgnorePointer()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteDefine.refundPdfScreen.name, arguments: {
                          AppStrings.invoiceListString: invoicesList[index],
                          AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_refunds,
                        });
                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Text(
                            invoiceNumber,
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14,
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
              subTitleText(context, AppLocalizations.of(context)!.invoice_date),
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
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );

  Widget _refundedOnOrderWidget(List<RefundInvoice> invoicesList, int index, String invoiceNumber, List<StatusData> statusList) => ListView.builder(
        itemCount: invoicesList[index].refundedOnOrders?.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, orderIndex) => Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  invoiceNumber == ''
                      ? const IgnorePointer()
                      : GestureDetector(
                          onTap: () async {
                            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                            preferencesHelper.setOrderId(productOrderId: invoicesList[index].refundedOnOrders?[orderIndex].orderId ?? '');
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                                    statusList: statusList,
                                    orderNumber: invoicesList[index].refundedOnOrders?[orderIndex].orderNumber ?? '',
                                    orderId: invoicesList[index].refundedOnOrders?[orderIndex].orderId ?? '',
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
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Text(
                                invoicesList[index].refundedOnOrders![orderIndex].orderNumber ?? '',
                                style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.font_14,
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
                child: titleGreenText(
                  context,
                  '${invoicesList[index].refundedOnOrders?[orderIndex].orderAdjustAmount ?? ''}₪',
                ),
              ),
              2.height,
              Container(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.statusInProgressColor,
                ),
                child: Text(
                  invoicesList[index].refundedOnOrders?[orderIndex].status == AppStrings.inProgressText ? AppLocalizations.of(context)!.in_progress_text ?? '' : '',
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      );

  Widget _refundedOnInvoiceWidget(List<RefundInvoice> invoicesList, int index, String invoiceNumber, List<RefundedInvoice> refundedOnInvoice) => ListView.builder(
        itemCount: invoicesList[index].refundedOnInvoice?.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, invoiceIndex) => Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.padding_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              invoiceNumber == ''
                  ? const IgnorePointer()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            printData("check here data ${refundedOnInvoice![invoiceIndex].toJson()}");

                            final refundInvoiceData = RefundedInvoice(
                              id: refundedOnInvoice![invoiceIndex].id,
                              link: refundedOnInvoice![invoiceIndex].link,
                              invoiceNumber: refundedOnInvoice![invoiceIndex].invoiceNumber,
                              invoiceAmount: refundedOnInvoice![invoiceIndex].invoiceAmount,
                              paymentStatus: refundedOnInvoice![invoiceIndex].paymentStatus,
                              invoiceDate: refundedOnInvoice![invoiceIndex].invoiceDate,
                              invoiceType: refundedOnInvoice![invoiceIndex].invoiceType,
                              dueDate: refundedOnInvoice![invoiceIndex].dueDate,
                              supplierName: refundedOnInvoice![invoiceIndex].supplierName,
                            );

                            final invoiceData = Invoice(
                              id: refundInvoiceData.id,
                              link: refundInvoiceData.link,
                              invoiceNumber: refundInvoiceData.invoiceNumber,
                              invoiceAmount: refundInvoiceData.invoiceAmount,
                              paymentStatus: refundInvoiceData.paymentStatus,
                              invoiceDate: refundInvoiceData.invoiceDate,
                              invoiceType: refundInvoiceData.invoiceType,
                              dueDate: refundInvoiceData.dueDate,
                              supplierName: refundInvoiceData.supplierName,
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
                                refundedOnInvoice![invoiceIndex].invoiceNumber ?? '',
                                style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.font_14,
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
                child: titleGreenText(
                  context,
                  '${refundedOnInvoice?[invoiceIndex].invoiceAmount ?? ''} ₪',
                ),
              ),
              2.height,
              Container(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.statusCloseColor,
                ),
                child: Text(
                  refundedOnInvoice?[invoiceIndex].status == AppStrings.closedText ? AppLocalizations.of(context)!.closed_text ?? '' : '',
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
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
        style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.blackColor, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget titleValueText(BuildContext context, String title) => Text(
        title,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget subTitleText(BuildContext context, String subTitle) => Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        subTitle,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));

  Widget subTitleValueText(BuildContext context, String subTitle) => Text(
        subTitle,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.lightGreyColor, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget titleGreenText(BuildContext context, String title) => Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.notificationColor, fontWeight: FontWeight.bold),
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
