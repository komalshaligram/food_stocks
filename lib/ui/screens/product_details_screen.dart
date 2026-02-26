import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/product_details/product_details_bloc.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_divider_widget.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_dialog.dart';
import '../widget/custom_form_field_widget.dart';
import '../widget/file_selection_option_widget.dart';
import '../widget/product_details_screen_shimmer_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProductDetailsRoute {
  static Widget get route => const ProductDetailsScreen();
}

class ProductDetailsScreen extends StatelessWidget {
  final String orderId;
  final String issue;
  final String orderNumber;
  final bool isNavigateToProductDetailString;
  final OrdersBySupplier productData;
  final OrderDatum orderData;
  final List<StatusData> statusList;

  const ProductDetailsScreen({
    super.key,
    this.orderId = '',
    this.orderNumber = '',
    this.isNavigateToProductDetailString = false,
    this.productData = const OrdersBySupplier(),
    this.orderData = const OrderDatum(),
    this.statusList = const <StatusData>[],
    this.issue = '',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc()
        ..add(isNavigateToProductDetailString
            ? ProductDetailsEvent.getOrderByIdEvent(context: context, orderId: orderId)
            : ProductDetailsEvent.getProductDataEvent(
                context: context,
                orderId: orderId,
                orderData: orderData,
                orderBySupplierProduct: productData,
                statusList: statusList,
              )),
      child: ProductDetailsScreenWidget(
        orderId: orderId,
        orderNumber: orderNumber,
        statusList: statusList,
      ),
    );
  }
}

class ProductDetailsScreenWidget extends StatefulWidget {
  final String orderId;
  final String orderNumber;
  final List<StatusData> statusList;
  const ProductDetailsScreenWidget({super.key, required this.orderId, required this.orderNumber, required this.statusList});

  @override
  State<ProductDetailsScreenWidget> createState() => _ProductDetailsScreenWidgetState();
}

class _ProductDetailsScreenWidgetState extends State<ProductDetailsScreenWidget> {
  TextEditingController addProblemController = TextEditingController();

  String skuNumber = "5321";

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();

    Widget itemOne(ProductDetailsState state) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText(context, AppLocalizations.of(context)!.supplier),
                subTitleValueText(context, state.orderBySupplierProduct.supplierName?.toString() ?? ''),
              ],
            ),
            state.orderData.orderstatus != null
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.radius_50),
                      color: getStatusColor(widget.statusList, state.orderData.orderstatus?.statusName ?? ''),
                    ),
                    child: Text(
                      getStatus(widget.statusList, state.orderData.orderstatus?.statusName ?? '', state.language).toTitleCase(),
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
                    ),
                  )
                : 0.width
          ],
        );

    Widget itemTwo(ProductDetailsState state) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(context, AppLocalizations.of(context)!.order_number),
                  subTitleValueText(context, state.orderData.orderNumber.toString()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  titleText(context, AppLocalizations.of(context)!.order_date),
                  subTitleValueText(context, state.orderBySupplierProduct.orderDate.toString()),
                ],
              ),
            ),
          ],
        );

    Widget itemThree(ProductDetailsState state) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(context, AppLocalizations.of(context)!.order_amount),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: subTitleValueText(context, formatSignedNumber(state.orderData.totalVatAmount.toString())),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(context, AppLocalizations.of(context)!.payment_type),
                  subTitleValueText(
                      context,
                      state.orderData.paymentMethod.toString() == AppStrings.wallet
                          ? AppLocalizations.of(context)!.payment_wallet
                          : state.orderData.paymentMethod.toString() == AppStrings.creditCard
                              ? AppLocalizations.of(context)!.payment_credit_card
                              : state.orderData.paymentMethod.toString() == AppStrings.bankTransfer
                                  ? AppLocalizations.of(context)!.payment_bank_transfer
                                  : AppLocalizations.of(context)!.payment_bank_check)
                ],
              ),
            ),
          ],
        );

    Widget invoiceRefundAmountItem({
      required String title,
      required String value,
      required orderId,
      int? orderNumber,
      required InvoiceDetails orderData,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.8,
            child: titleText(context, title),
          ),
          GestureDetector(
            onTap: () async {
              if (title == AppLocalizations.of(context)!.invoice_amount) {
                final refundInvoiceData = InvoiceDetails(
                  invoiceLink: orderData.invoiceLink,
                  invoiceNumber: orderData.invoiceNumber,
                  invoiceAmount: orderData.invoiceAmount,
                  status: orderData.status,
                  invoiceDate: orderData.invoiceDate,
                  dueDate: orderData.dueDate,
                  orderNumber: orderData.orderNumber,
                  orderId: orderData.orderId,
                  rivchitApiKey: orderData.rivchitApiKey,
                );
                //
                final invoiceData = Invoice(
                  invoiceLink: refundInvoiceData.invoiceLink,
                  invoiceNumber: refundInvoiceData.invoiceNumber.toString(),
                  invoiceAmount: refundInvoiceData.invoiceAmount,
                  paymentStatus: refundInvoiceData.status,
                  invoiceDate: refundInvoiceData.invoiceDate,
                  dueDate: refundInvoiceData.dueDate,
                  orderNumber: refundInvoiceData.orderNumber.toString(),
                  orderId: refundInvoiceData.orderId,
                  rivchitApiKey: refundInvoiceData.rivchitApiKey,
                );

                Navigator.pushNamed(
                  context,
                  RouteDefine.invoicePdfScreen.name,
                  arguments: {
                    AppStrings.invoiceListString: invoiceData,
                    AppStrings.invoiceTitleNameString: AppLocalizations.of(context)!.my_invoices,
                  },
                );
              } else {
                Navigator.pushNamed(
                  context,
                  RouteDefine.orderRefundsScreen.name,
                  arguments: {
                    AppStrings.orderIdString: orderId,
                    AppStrings.orderNumberString: orderNumber,
                  },
                );
              }
            },
            child: value == '0 ₪' || value == '0.0 ₪'
                ? Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      value,
                      style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          value,
                          style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont,
                            color: AppColors.notificationColor,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1,
                          color: AppColors.notificationColor,
                          margin: const EdgeInsets.only(top: AppConstants.padding_5),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      );
    }

    Widget itemFour(totalAmount, InvoiceDetails? invoiceDetails) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText(context, AppLocalizations.of(context)!.total_payment),
            Directionality(
              textDirection: TextDirection.ltr,
              child: subTitleValueText(
                context,
                invoiceDetails == null || invoiceDetails.invoiceNumber == null ? '---' : formatSignedNumber(totalAmount),
              ),
            ),
          ],
        );

    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        final double invoiceAmount = state.orderData.rivchitInvoicePrice ?? 0;

        final double refundAmount = state.orderData.adjustedRefundAmount ?? 0.0;

        final double totalAmount = invoiceAmount + refundAmount;

        final bool showDriverProofSection = state.orderData.orderstatus?.statusName == 'ORDERSTATUS_5' || state.orderData.orderstatus?.statusName == 'ORDERSTATUS_6' || (state.orderData.orderstatus?.orderStatusNumber == AppConstants.paidStatus && state.orderData.pendingDeliveryConfirmation! == true && state.orderData.paymentMethod.toString() == AppStrings.creditCard);

        final bool disableDriverProofTap = state.orderData.orderstatus?.statusName == 'ORDERSTATUS_5' || (state.orderData.orderstatus?.orderStatusNumber == AppConstants.paidStatus && state.orderData.pendingDeliveryConfirmation! == true && state.orderData.paymentMethod.toString() == AppStrings.creditCard);

        final bool isOrderStatusCardType = state.orderData.orderstatus?.orderStatusNumber == AppConstants.onTheWayStatus || state.orderData.orderstatus?.orderStatusNumber == AppConstants.paidStatus && state.orderData.pendingDeliveryConfirmation! == true && state.orderData.paymentMethod.toString() == AppStrings.creditCard;

        Widget buildDriverProofSlot({
          required File file,
          required int index,
          required bool isDisabled,
          required String language,
        }) {
          return InkWell(
            onTap: isDisabled
                ? null
                : () async {
                    if (file != null && await file.exists() || file.path.contains("https")) {
                      uploadDriverProofBottomSheet(
                        context: context,
                        file: file,
                        index: index,
                        language: language,
                        productIssueData: {},
                        selectedRadio: state.selectedRadioTile,
                      );
                      return;
                    }
                    cameraDriverProofEvent(context: context, index: index, productIssueData: {}, selectedRadio: state.selectedRadioTile);
                  },
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(color: AppColors.whiteColor),
              alignment: Alignment.center,
              child: file.path.contains("https")
                  ? Image.network(
                      file.path,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: SizedBox(
                                width: AppConstants.containerHeight_80,
                                height: AppConstants.containerHeight_80,
                                child: CupertinoActivityIndicator(
                                  color: AppColors.blackColor,
                                )));
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                          width: 100,
                          height: 100,
                          color: AppColors.whiteColor,
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppImagePath.imageNotAvailable5,
                          )),
                    )
                  : file.existsSync()
                      ? Image.file(file, fit: BoxFit.cover, height: 120, width: 120)
                      : const Icon(Icons.add, size: 60),
            ),
          );
        }

        return FocusDetector(
          onFocusGained: () {
            bloc.add(ProductDetailsEvent.getPermissionList(context: context));
          },
          child: Scaffold(
            backgroundColor: AppColors.pageColor,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: '',
                iconData: Icons.arrow_back_ios_sharp,
                trailingWidget: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.padding_10,
                        ),
                        child: state.orderBySupplierProduct.totalPayment == 0.0
                            ? const CupertinoActivityIndicator()
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_5),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                                    border: Border.all(
                                      color: AppColors.whiteColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${AppLocalizations.of(context)!.total}:',
                                        style: TextStyle(color: AppColors.whiteColor, fontSize: AppConstants.font_14, fontWeight: FontWeight.w400),
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          state.orderData.comaxInvoicePrice != 0.0
                                              ? formatNumber(
                                                  value: (state.orderData.comaxInvoicePrice?.toStringAsFixed(AppConstants.amountFrLength)) ?? '0',
                                                  local: AppStrings.hebrewLocal,
                                                )
                                              : formatNumber(
                                                  value: (state.orderData.totalVatAmount?.toStringAsFixed(AppConstants.amountFrLength)) ?? '0',
                                                  local: AppStrings.hebrewLocal,
                                                ),
                                          style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.font_14,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                    state.isSubUserCreateDuplicateOrder
                        ? GestureDetector(
                            onTap: () {
                              duplicateOrderDialog(context: context, directionality: state.language);
                            },
                            child: Container(
                              height: 35,
                              margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                              padding: const EdgeInsets.all(AppConstants.padding_5),
                              decoration: BoxDecoration(
                                  gradient: AppColors.appMainGradientColor,
                                  border: Border.all(color: AppColors.borderColor),
                                  borderRadius: const BorderRadius.all(Radius.circular(
                                    AppConstants.radius_3,
                                  ))),
                              child: Text(
                                AppLocalizations.of(context)!.duplicate_order,
                                style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.smallFont,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : 0.width
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: state.isShimmering && state.isLoading || (state.orderBySupplierProduct.products?.isEmpty ?? false)
                ? const ProductDetailsScreenShimmerWidget()
                : SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SafeArea(
                      child: AnimationLimiter(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(seconds: 1),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                horizontalOffset: MediaQuery.of(context).size.width / 2,
                                child: FadeInAnimation(child: widget),
                              ),
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(AppConstants.padding_10),
                                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(color: AppColors.borderColor),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(AppConstants.radius_10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      itemOne(state),
                                      const DividerWidget(
                                        height: 20.0,
                                      ),
                                      itemTwo(state),
                                      const DividerWidget(
                                        height: 20.0,
                                      ),
                                      itemThree(state),
                                      const DividerWidget(
                                        height: 20.0,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          invoiceRefundAmountItem(
                                            title: AppLocalizations.of(context)!.invoice_amount,
                                            value: formatSignedNumber(state.orderData.rivchitInvoicePrice),
                                            orderId: state.orderData.id,
                                            orderNumber: state.orderData.orderNumber,
                                            orderData: state.orderData.invoiceDetails ?? const InvoiceDetails(),
                                          ),
                                          10.height,
                                          invoiceRefundAmountItem(
                                            title: AppLocalizations.of(context)!.refund_amount,
                                            value: state.orderData.adjustedRefundAmount.toString() == 'null' || state.orderData.adjustedRefundAmount == null ? '0.0₪' : formatSignedNumber(state.orderData.adjustedRefundAmount),
                                            orderId: state.orderData.id,
                                            orderNumber: state.orderData.orderNumber,
                                            orderData: state.orderData.invoiceDetails ?? const InvoiceDetails(),
                                          ),
                                        ],
                                      ),
                                      const DividerWidget(
                                        height: 20.0,
                                      ),
                                      itemFour(totalAmount, state.orderData.invoiceDetails),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.order_products_list,
                                        style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.smallFont,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      isOrderStatusCardType
                                          ? GestureDetector(
                                              onTap: () {
                                                bloc.add(const ProductDetailsEvent.checkAllEvent());
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(AppConstants.padding_5),
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(AppConstants.padding_3)),
                                                  color: state.isAllCheck ? AppColors.mainColor : AppColors.lightBorderColor,
                                                  border: Border.all(color: AppColors.lightGreyColor),
                                                ),
                                                child: Text(
                                                  AppLocalizations.of(context)!.check_all,
                                                  style: AppStyles.rkRegularTextStyle(
                                                    size: AppConstants.font_14,
                                                    color: state.isAllCheck ? AppColors.whiteColor : AppColors.blackColor,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: AppConstants.padding_85),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                          itemCount: state.orderBySupplierProduct.products?.length ?? 0,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                                          itemBuilder: (context, index) {
                                            return productListItem(
                                                numberOfUnit: state.orderBySupplierProduct.products?[index].numberOfUnit ?? 0,
                                                quantity: state.orderBySupplierProduct.products?[index].quantity ?? 0,
                                                updatedUnitQuantity: state.orderBySupplierProduct.products?[index].updatedUnitQuantity ?? 0,
                                                unitQuantity: state.orderBySupplierProduct.products?[index].unitQuantity ?? 0,
                                                sku: state.orderBySupplierProduct.products?[index].sku ?? '',
                                                isUpdated: state.orderBySupplierProduct.products?[index].isUpdated ?? false,
                                                index: index,
                                                context: context,
                                                statusNumber: state.orderData.orderstatus?.orderStatusNumber ?? 0,
                                                issue: state.orderBySupplierProduct.products?[index].issue ?? '',
                                                isIssue: state.orderBySupplierProduct.products?[index].isIssue ?? false,
                                                missingQuantity: state.orderBySupplierProduct.products?[index].missingQuantity ?? 0,
                                                issueStatus: state.orderBySupplierProduct.products?[index].issueStatus!.statusName.toString().toTitleCase() ?? '',
                                                barcode: state.orderBySupplierProduct.products?[index].barcode,
                                                orderId: state.orderBySupplierProduct.id,
                                                language: state.language,
                                                orderSupplierProduct: state.orderBySupplierProduct,
                                                isOrderStatusCardType: isOrderStatusCardType);
                                          }),
                                      showDriverProofSection
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8, vertical: AppConstants.padding_5),
                                              child: Text(
                                                AppLocalizations.of(context)!.add_driver_delivery_document_img,
                                                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14),
                                                textAlign: TextAlign.start,
                                              ),
                                            )
                                          : const IgnorePointer(),
                                      showDriverProofSection
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8, vertical: AppConstants.padding_5),
                                              child: Text(
                                                '${AppLocalizations.of(context)!.note}: ${AppLocalizations.of(context)!.add_driver_delivery_document_img_note}',
                                                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.redColor),
                                                textAlign: TextAlign.start,
                                              ),
                                            )
                                          : const IgnorePointer(),
                                      showDriverProofSection ? 5.height : const IgnorePointer(),
                                      showDriverProofSection
                                          ? Padding(
                                              padding: const EdgeInsets.all(AppConstants.padding_8),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    buildDriverProofSlot(
                                                      file: state.driverDeliveryProofFile,
                                                      index: 1,
                                                      isDisabled: disableDriverProofTap,
                                                      language: state.language,
                                                    ),
                                                    8.width,
                                                    buildDriverProofSlot(
                                                      file: state.driverDeliveryProofFile1,
                                                      index: 2,
                                                      isDisabled: disableDriverProofTap,
                                                      language: state.language,
                                                    ),
                                                    8.width,
                                                    buildDriverProofSlot(
                                                      file: state.driverDeliveryProofFile2,
                                                      index: 3,
                                                      isDisabled: disableDriverProofTap,
                                                      language: state.language,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const IgnorePointer(),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
            bottomSheet: isOrderStatusCardType
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_20, horizontal: AppConstants.padding_30),
                    color: AppColors.pageColor,
                    child: CustomButtonWidget(
                      onPressed: () {
                        if (!state.isAllCheck) {
                          CustomSnackBar.showSnackBar(
                            context: context,
                            title: AppLocalizations.of(context)!.select_checkbox,
                            type: SnackBarType.failure,
                          );
                        } else {
                          printData("check here value ${state.orderData.availableSurfaceQuantityToReturn}");
                          if (state.orderData.hasReturnProducts == true) {
                            Navigator.pushNamed(context, RouteDefine.returnDriverScreen.name, arguments: {
                              AppStrings.supplierNameString: state.orderBySupplierProduct.supplierName?.toString() ?? '',
                              AppStrings.deliveryStatusString: getStatus(widget.statusList, state.orderData.orderstatus?.statusName ?? '', state.language).toTitleCase(),
                              AppStrings.totalOrderString: state.orderData.totalVatAmount?.toStringAsFixed(AppConstants.amountFrLength) ?? '0',
                              AppStrings.quantityString: state.orderBySupplierProduct.products?.length.toString() ?? '',
                              AppStrings.totalAmountString: state.orderData.totalVatAmount?.toStringAsFixed(AppConstants.amountFrLength) ?? 0,
                              AppStrings.orderIdString: widget.orderId,
                              AppStrings.supplierIdString: state.orderBySupplierProduct.id,
                              AppStrings.orderStatusNo: state.orderData.orderstatus?.orderStatusNumber ?? 2,
                              AppStrings.deliveryDateString: state.orderBySupplierProduct.orderDeliveryDate,
                              AppStrings.supplierOrderNumberString: state.orderData.orderNumber,
                              AppStrings.driverDeliveryDocumentsImages: state.driverDeliveryProofImagesList,
                              AppStrings.vatString: state.orderData.vatAmount,
                              AppStrings.usersIdString: state.userId,
                              AppStrings.statusList: widget.statusList,
                              AppStrings.orderIssueReturnId: state.returnList.data?.id ?? '',
                              AppStrings.availableSurfaceQuantityToReturn: state.orderData.availableSurfaceQuantityToReturn,
                            });
                          } else {
                            Navigator.pushNamed(context, RouteDefine.shipmentVerificationScreen.name, arguments: {
                              AppStrings.supplierNameString: state.orderBySupplierProduct.supplierName?.toString() ?? '',
                              AppStrings.deliveryStatusString: getStatus(widget.statusList, state.orderData.orderstatus?.statusName ?? '', state.language).toTitleCase(),
                              AppStrings.totalOrderString: state.orderData.totalVatAmount?.toStringAsFixed(AppConstants.amountFrLength) ?? '0',
                              AppStrings.quantityString: state.orderBySupplierProduct.products?.length.toString() ?? '',
                              AppStrings.totalAmountString: state.orderData.totalVatAmount?.toStringAsFixed(AppConstants.amountFrLength) ?? 0,
                              AppStrings.orderIdString: widget.orderId,
                              AppStrings.supplierIdString: state.orderBySupplierProduct.id,
                              AppStrings.orderStatusNo: state.orderData.orderstatus?.orderStatusNumber ?? 2,
                              AppStrings.deliveryDateString: state.orderBySupplierProduct.orderDeliveryDate,
                              AppStrings.supplierOrderNumberString: state.orderData.orderNumber,
                              AppStrings.driverDeliveryDocumentsImages: state.driverDeliveryProofImagesList,
                              AppStrings.vatString: state.orderData.vatAmount,
                              AppStrings.usersIdString: state.userId,
                              AppStrings.statusList: widget.statusList,
                              AppStrings.sentReturnData: [],
                              AppStrings.orderIssueReturnId: state.returnList.data?.id ?? '',
                              AppStrings.availableSurfaceQuantityToReturn: state.orderData.availableSurfaceQuantityToReturn,
                            });
                          }
                        }
                      },
                      buttonText: AppLocalizations.of(context)!.next,
                      bGColor: AppColors.mainColor,
                    ),
                  )
                : 0.width,
          ),
        );
      },
    );
  }

  Widget productListItem({
    required int index,
    required BuildContext context,
    required int statusNumber,
    String? issue,
    bool? isIssue,
    int? missingQuantity,
    String issueStatus = '',
    bool isUpdated = false,
    required String sku,
    required int unitQuantity,
    required int updatedUnitQuantity,
    required int quantity,
    required int numberOfUnit,
    String? barcode,
    String? orderId,
    required String language,
    required OrdersBySupplier orderSupplierProduct,
    required bool isOrderStatusCardType,
  }) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();

        final matchedProductList = state.returnList.data?.returnProducts?.where((test) => test.barcode == barcode);

        final matchedProduct = matchedProductList != null && matchedProductList.isNotEmpty ? matchedProductList.first : null;
        final matchedProductIndex = matchedProduct != null ? state.returnList.data?.returnProducts?.indexOf(matchedProduct) : -1;

        final Map<String, String> reasonsMap = {
          'Product did not arrive at all': AppLocalizations.of(context)!.product_did_not_arrive_at_all,
          'המוצר לא הגיע בכלל': AppLocalizations.of(context)!.product_did_not_arrive_at_all,
          'Product arrived damaged': AppLocalizations.of(context)!.product_arrived_damaged,
          'המוצר הגיע פגום': AppLocalizations.of(context)!.product_arrived_damaged,
          'Product arrived incomplete': AppLocalizations.of(context)!.product_arrived_incomplete,
          'המוצר הגיע לא שלם': AppLocalizations.of(context)!.product_arrived_incomplete,
          'Expiration date issue': AppLocalizations.of(context)!.expiration_date_issue,
          'בעיית תאריך תפוגה': AppLocalizations.of(context)!.expiration_date_issue,
          'Wrong product received': AppLocalizations.of(context)!.wrong_product_received,
          'התקבל מוצר שגוי': AppLocalizations.of(context)!.wrong_product_received,
        };

        String getLocalizedReason(String reasonCode, BuildContext context) {
          return reasonsMap[reasonCode] ?? '';
        }

        return !(state.orderBySupplierProduct.products?[index].isBottle ?? false) || ((state.orderBySupplierProduct.products?[index].isBottle ?? false) ? sku == skuNumber : false)
            ? Container(
                margin: const EdgeInsets.all(AppConstants.padding_10),
                padding: EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: getScreenHeight(context) >= 730 ? AppConstants.padding_3 : 0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.padding_5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: statusNumber == AppConstants.onTheWayStatus || state.orderData.orderstatus?.orderStatusNumber == AppConstants.paidStatus && state.orderData.pendingDeliveryConfirmation! == true && state.orderData.paymentMethod.toString() == AppStrings.creditCard ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                        children: [
                          isOrderStatusCardType
                              ? SizedBox(
                                  width: 30,
                                  child: Checkbox(
                                    value: state.productListIndex.contains(index),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppConstants.radius_3),
                                    ),
                                    side: BorderSide(width: 1.0, color: AppColors.greyColor),
                                    activeColor: AppColors.mainColor,
                                    onChanged: (value) {
                                      bloc.add(
                                        ProductDetailsEvent.productProblemEvent(
                                          isProductProblem: value!,
                                          index: matchedProductIndex! != -1 ? matchedProductIndex : index,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : 10.width,
                          state.orderBySupplierProduct.products?[index].mainImage != ''
                              ? Image.network(
                                  '${AppUrlEndPoints.baseFileUrl}${state.orderBySupplierProduct.products?[index].mainImage ?? ''}',
                                  width: AppConstants.containerHeight_80,
                                  height: AppConstants.containerHeight_80,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: SizedBox(
                                          width: AppConstants.containerHeight_80,
                                          height: AppConstants.containerHeight_80,
                                          child: CupertinoActivityIndicator(
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: AppConstants.containerHeight_80,
                                      height: AppConstants.containerHeight_80,
                                      color: AppColors.whiteColor,
                                      alignment: Alignment.center,
                                      child: Image.asset(AppImagePath.imageNotAvailable5),
                                    );
                                  },
                                )
                              : Image.asset(
                                  AppImagePath.imageNotAvailable5,
                                  fit: BoxFit.cover,
                                  width: AppConstants.containerHeight_80,
                                  height: AppConstants.containerHeight_80,
                                ),
                          15.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width > 370 ? MediaQuery.of(context).size.width / 2 : 160,
                                child: Text(
                                  state.orderBySupplierProduct.products?[index].productName.toString() ?? '',
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  isOrderStatusCardType
                                      ? Text(
                                          '${(updatedUnitQuantity / numberOfUnit).round()}${' '}${state.orderBySupplierProduct.products?[index].scale.toString()}',
                                          style: AppStyles.rkRegularTextStyle(
                                            color: AppColors.blackColor,
                                            size: AppConstants.font_12,
                                          ),
                                        )
                                      : sku == skuNumber
                                          ? Text(
                                              '${(state.orderBySupplierProduct.products?[index].quantity.toString() ?? '')}${' '}${AppLocalizations.of(context)!.units}',
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: AppStyles.rkRegularTextStyle(
                                                color: AppColors.blackColor,
                                                size: AppConstants.font_12,
                                              ),
                                            )
                                          : Text(
                                              '${(state.orderBySupplierProduct.products?[index].quantity.toString() ?? '')}${' '}${state.orderBySupplierProduct.products?[index].scale.toString()}',
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: AppStyles.rkRegularTextStyle(
                                                color: AppColors.blackColor,
                                                size: AppConstants.font_12,
                                              ),
                                            ),
                                  5.width,
                                  isOrderStatusCardType
                                      ? Text(
                                          '(${AppLocalizations.of(context)!.original_was}${' '}${(state.orderBySupplierProduct.products?[index].quantity.toString() ?? '')}${' '}${state.orderBySupplierProduct.products?[index].scale.toString()})',
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                          style: AppStyles.rkRegularTextStyle(
                                            color: AppColors.redColor,
                                            size: AppConstants.font_12,
                                          ),
                                        )
                                      : 0.width,
                                ],
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Transform.translate(
                                  offset: state.language == 'en' ? const Offset(-3, 0) : const Offset(0, 0),
                                  child: Text(
                                    formatNumber(
                                      value: (state.orderBySupplierProduct.products![index].discountedPrice) != 0
                                          ? (vatCalculation(price: state.orderBySupplierProduct.products![index].discountedPrice ?? 0, vat: state.orderData.vatPercentage ?? 0).toStringAsFixed(
                                              AppConstants.amountFrLength,
                                            ))
                                          : (vatCalculation(price: state.orderBySupplierProduct.products![index].totalPayment ?? 0, vat: state.orderData.vatPercentage ?? 0).toStringAsFixed(2)),
                                      local: AppStrings.hebrewLocal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.font_14, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              3.height,
                              isOrderStatusCardType
                                  ? GestureDetector(
                                      onTap: () async {
                                        final product = state.orderBySupplierProduct.products?[index];
                                        final productQuantity = product?.quantity ?? 1;

                                        ProductDetailsState updatedState;

                                        try {
                                          updatedState = await bloc.stream
                                              .firstWhere(
                                                (s) => s != state,
                                              )
                                              .timeout(const Duration(seconds: 0));
                                        } catch (e) {
                                          updatedState = state;
                                        }

                                        final returnProducts = updatedState.returnList.data?.returnProducts ?? [];

                                        final Map<int, String> reasonsMap = {
                                          1: AppLocalizations.of(context)!.product_did_not_arrive_at_all,
                                          2: AppLocalizations.of(context)!.product_arrived_damaged,
                                          3: AppLocalizations.of(context)!.product_arrived_incomplete,
                                          4: AppLocalizations.of(context)!.expiration_date_issue,
                                          5: AppLocalizations.of(context)!.wrong_product_received,
                                        };

                                        int? selectedRadio;
                                        Map<int, int> quantitiesPerRadio = {};

                                        int getQuantityForReason(String reason, int radioVal) {
                                          try {
                                            final returnData = returnProducts.firstWhere((item) => item.reasonToReturn == reason);
                                            if (returnData.totalUnits != null) return returnData.totalUnits!;
                                          } catch (_) {}
                                          if (radioVal == 1 || radioVal == 5) return productQuantity;
                                          return 1;
                                        }

                                        var returnIndex = returnProducts.indexWhere((returnProduct) => returnProduct.barcode == barcode);

                                        for (var entry in reasonsMap.entries) {
                                          final qty = getQuantityForReason(entry.value, entry.key);
                                          quantitiesPerRadio[entry.key] = qty;
                                          if (returnIndex != -1) {
                                            if (selectedRadio == null && returnProducts[returnIndex].reasonToReturn == entry.value) {
                                              selectedRadio = entry.key;
                                            }
                                          } else {
                                            selectedRadio = 0;
                                          }
                                        }

                                        final radioValue = selectedRadio ?? 0;

                                        bloc.add(
                                          ProductDetailsEvent.getArgumentEvent(
                                            arguments: returnIndex != -1 ? returnProducts[returnIndex] : null,
                                            context: context,
                                            productQuantity: productQuantity * (product?.numberOfUnit ?? 1),
                                          ),
                                        );
                                        bloc.add(ProductDetailsEvent.radioButtonEvent(selectRadioTile: radioValue));

                                        final newState = await bloc.stream.firstWhere((s) => s.productIssueData != null);

                                        productProblemBottomSheet(
                                            productIssueData: newState.productIssueData,
                                            radioValue: radioValue,
                                            context: context,
                                            productName: product?.productName.toString() ?? '',
                                            weight: product?.itemWeight?.toDouble() ?? 0.0,
                                            price: double.parse((product?.totalPayment?.toStringAsFixed(AppConstants.amountFrLength) ?? '0')),
                                            image: product?.mainImage ?? '',
                                            listIndex: index,
                                            productId: product?.productId ?? '',
                                            supplierId: state.orderBySupplierProduct.id.toString(),
                                            scale: product?.scale.toString() ?? '',
                                            isIssue: isIssue,
                                            issue: issue,
                                            missingQuantity: missingQuantity,
                                            quantity: product?.quantity ?? 0,
                                            numberOfUnit: product?.numberOfUnit ?? 0,
                                            isDeliver: (state.orderBySupplierProduct.orderDeliveryDate != '') ? true : false,
                                            barcode: barcode,
                                            returnProducts: returnProducts,
                                            notes: returnIndex != -1 ? returnProducts[returnIndex].notes : '',
                                            returnProductId: returnIndex != -1 ? returnProducts[returnIndex].returnProductId : '',
                                            returnId: returnIndex != -1 ? returnProducts[returnIndex].returnId : '',
                                            orderId: orderId,
                                            language: language,
                                            orderSupplierProduct: orderSupplierProduct);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_5),
                                        decoration: BoxDecoration(
                                          color: (matchedProduct?.reasonToReturn?.isNotEmpty ?? false) ? AppColors.mainColor : AppColors.lightBorderColor,
                                          border: Border.all(color: AppColors.lightGreyColor),
                                          borderRadius: BorderRadius.circular(AppConstants.radius_3),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.product_issue,
                                          style: AppStyles.rkRegularTextStyle(
                                            color: (matchedProduct?.reasonToReturn?.isNotEmpty ?? false) ? AppColors.whiteColor : AppColors.blackColor,
                                            size: AppConstants.font_12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    )
                                  : (isUpdated ? state.orderBySupplierProduct.products![index].updatedUnitQuantity == 0 : false)
                                      ? Text(
                                          AppLocalizations.of(context)!.was_not_in_stock,
                                          style: AppStyles.rkRegularTextStyle(
                                            color: AppColors.redColor,
                                            size: AppConstants.font_12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      : const SizedBox(),
                              (matchedProduct?.reasonToReturn?.isNotEmpty ?? false)
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width > 370 ? MediaQuery.of(context).size.width / 2 : 160,
                                      child: Text(
                                        '${AppLocalizations.of(context)!.issue_text} '
                                        '${getLocalizedReason(matchedProduct!.reasonToReturn.toString(), context)}',
                                        maxLines: 2,
                                        style: AppStyles.rkRegularTextStyle(
                                          color: AppColors.redColor,
                                          size: AppConstants.font_14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ))
                                  : const IgnorePointer(),
                              (matchedProduct?.totalUnits != null)
                                  ? Text(
                                      '${matchedProduct?.totalUnits?.toString() ?? ''} ${AppLocalizations.of(context)!.units} ',
                                      maxLines: 2,
                                      style: AppStyles.rkRegularTextStyle(
                                        color: AppColors.redColor,
                                        size: AppConstants.font_14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : const IgnorePointer(),
                            ],
                          ),
                          10.width,
                          // : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : 0.width;
      },
    );
  }

  productProblemBottomSheet({
    required BuildContext context,
    required String productName,
    required double weight,
    required double price,
    required String image,
    required int listIndex,
    required String productId,
    required String supplierId,
    required String scale,
    bool? isIssue,
    String? issue,
    required int radioValue,
    int? missingQuantity,
    required int quantity,
    required bool isDeliver,
    String? barcode,
    required List<ReturnProduct> returnProducts,
    required Map<int, Map<String, dynamic>> productIssueData,
    String? notes,
    String? returnProductId,
    required int numberOfUnit,
    String? returnId,
    String? orderId,
    required String language,
    required OrdersBySupplier orderSupplierProduct,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return DraggableScrollableSheet(
          expand: true,
          maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
          minChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
          initialChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
          builder: (context, scrollController) {
            return BlocProvider(
              create: (context) => ProductDetailsBloc()
                ..add(ProductDetailsEvent.radioButtonEvent(selectRadioTile: radioValue))
                ..add(ProductDetailsEvent.getBottomSheetDataEvent(context: context, notes: notes!)),
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: BoxDecoration(
                      color: AppColors.pageColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.radius_30),
                        topRight: Radius.circular(AppConstants.radius_30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                0.width,
                                Text(
                                  AppLocalizations.of(context)!.product_issue,
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context1, {AppStrings.issueString: '', 'refresh': false});
                                    },
                                    child: const Icon(Icons.close)),
                              ],
                            ),
                          ),
                          15.height,
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              boxShadow: [
                                BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10),
                              ],
                              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                image != ''
                                    ? Image.network(
                                        '${AppUrlEndPoints.baseFileUrl}$image',
                                        width: AppConstants.containerSize_50,
                                        height: AppConstants.containerSize_50,
                                        fit: BoxFit.fill,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: SizedBox(
                                                width: AppConstants.containerSize_50,
                                                height: AppConstants.containerSize_50,
                                                child: CupertinoActivityIndicator(
                                                  color: AppColors.blackColor,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: AppConstants.containerSize_50,
                                            height: AppConstants.containerSize_50,
                                            color: AppColors.whiteColor,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              AppImagePath.imageNotAvailable5,
                                            ),
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        AppImagePath.imageNotAvailable5,
                                        fit: BoxFit.cover,
                                        width: AppConstants.containerSize_50,
                                        height: AppConstants.containerSize_50,
                                      ),
                                SizedBox(
                                  width: AppConstants.containerHeight_100,
                                  child: Text(
                                    productName,
                                    style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.blackColor,
                                      size: AppConstants.font_14,
                                    ),
                                  ),
                                ),
                                //10.width,
                                Column(
                                  children: [
                                    Text(
                                      '${quantity.toString()}${' '}$scale',
                                      style: AppStyles.rkRegularTextStyle(
                                        color: AppColors.blackColor,
                                        size: AppConstants.font_12,
                                      ),
                                    ),
                                    Text(
                                      '${quantity * numberOfUnit}${' '}${AppLocalizations.of(context)!.units}',
                                      style: AppStyles.rkRegularTextStyle(
                                        color: AppColors.blackColor,
                                        size: AppConstants.font_12,
                                      ),
                                    ),
                                  ],
                                ),
                                //  10.width,
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    formatNumber(value: price.toStringAsFixed(AppConstants.amountFrLength), local: AppStrings.hebrewLocal),
                                    style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.blackColor,
                                      size: AppConstants.font_14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          20.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                            child: Text(
                              AppLocalizations.of(context)!.problem_detected,
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                          20.height,
                          radioButtonWidget(
                            context: context,
                            problem: AppLocalizations.of(context)!.product_did_not_arrive_at_all,
                            value: 1,
                            listIndex: listIndex,
                            scale: scale,
                            groupValue: radioValue,
                            missingQuantity: missingQuantity,
                            radioQuantity: productIssueData[1]!['quantity'],
                            totalQuantity: quantity * numberOfUnit,
                            bottomSheetContext: context1,
                            returnList: returnProducts,
                            barcode: AppLocalizations.of(context)!.product_did_not_arrive_at_all,
                            proofImage: [],
                            productIssueData: productIssueData,
                            language: language,
                          ),
                          10.height,
                          radioButtonWidget(
                            context: context,
                            problem: AppLocalizations.of(context)!.product_arrived_damaged,
                            value: 2,
                            listIndex: listIndex,
                            scale: scale,
                            groupValue: radioValue,
                            missingQuantity: missingQuantity,
                            radioQuantity: productIssueData[2]!['quantity'],
                            totalQuantity: quantity * numberOfUnit,
                            bottomSheetContext: context1,
                            returnList: returnProducts,
                            barcode: AppLocalizations.of(context)!.product_arrived_damaged,
                            proofImage: productIssueData[2]!['proofImage'],
                            productIssueData: productIssueData,
                            language: language,
                          ),
                          10.height,
                          radioButtonWidget(
                            context: context,
                            problem: AppLocalizations.of(context)!.product_arrived_incomplete,
                            value: 3,
                            listIndex: listIndex,
                            scale: scale,
                            groupValue: radioValue,
                            missingQuantity: missingQuantity,
                            radioQuantity: productIssueData[3]!['quantity'],
                            totalQuantity: quantity * numberOfUnit,
                            bottomSheetContext: context1,
                            returnList: returnProducts,
                            barcode: AppLocalizations.of(context)!.product_arrived_incomplete,
                            proofImage: [],
                            productIssueData: productIssueData,
                            language: language,
                          ),
                          10.height,
                          radioButtonWidget(
                            context: context,
                            problem: AppLocalizations.of(context)!.expiration_date_issue,
                            value: 4,
                            listIndex: listIndex,
                            scale: scale,
                            groupValue: radioValue,
                            missingQuantity: missingQuantity,
                            radioQuantity: productIssueData[4]!['quantity'],
                            totalQuantity: quantity * numberOfUnit,
                            bottomSheetContext: context1,
                            returnList: returnProducts,
                            barcode: AppLocalizations.of(context)!.expiration_date_issue,
                            proofImage: productIssueData[4]!['proofImage'],
                            productIssueData: productIssueData,
                            language: language,
                          ),
                          10.height,
                          radioButtonWidget(
                            context: context,
                            problem: AppLocalizations.of(context)!.wrong_product_received,
                            value: 5,
                            listIndex: listIndex,
                            scale: scale,
                            groupValue: radioValue,
                            missingQuantity: missingQuantity,
                            radioQuantity: productIssueData[5]!['quantity'],
                            totalQuantity: quantity * numberOfUnit,
                            bottomSheetContext: context1,
                            returnList: returnProducts,
                            barcode: AppLocalizations.of(context)!.wrong_product_received,
                            proofImage: [],
                            productIssueData: productIssueData,
                            language: language,
                          ),
                          10.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_3),
                            child: Text(
                              AppLocalizations.of(context)!.notes, //'Notes',
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                          5.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_3),
                            child: CustomFormField(
                              context: context,
                              fillColor: AppColors.whiteColor,
                              validator: '',
                              inputFormat: [LengthLimitingTextInputFormatter(150)],
                              controller: state.addNoteController,
                              keyboardType: TextInputType.text,
                              hint: AppLocalizations.of(context)!.add_text,
                              maxLines: 4,
                              isEnabled: true,
                              isBorderVisible: false,
                              textInputAction: TextInputAction.done,
                              contentPaddingTop: AppConstants.padding_8,
                            ),
                          ),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (state.selectedRadioTile == 0) {
                                    CustomSnackBar.showSnackBar(
                                      context: context,
                                      title: AppLocalizations.of(context)!.select_issue,
                                      type: SnackBarType.failure,
                                    );
                                  } else if (state.selectedRadioTile == 2 && state.proofImagesList.isEmpty || state.selectedRadioTile == 4 && state.proofImagesList.isEmpty) {
                                    CustomSnackBar.showSnackBar(
                                      context: context,
                                      title: AppLocalizations.of(context)!.add_one_proof_img,
                                      type: SnackBarType.failure,
                                    );
                                  } else {
                                    if (returnProducts.isEmpty) {
                                      context.read<ProductDetailsBloc>().add(ProductDetailsEvent.createReturnEvent(
                                            context: context,
                                            bottomSheetContext: context1,
                                            supplierId: supplierId,
                                            productId: productId,
                                            totalRefund: 0,
                                            proofImages: productIssueData[state.selectedRadioTile]!['proofImage'],
                                            notes: state.addNoteController.text,
                                            productName: productName,
                                            productImage: "${AppUrlEndPoints.baseFileUrl}$image",
                                            barcode: barcode!,
                                            totalUnits: productIssueData[state.selectedRadioTile]!['quantity'],
                                            isApproved: false,
                                            orderId: widget.orderId,
                                            reasonToReturn: state.selectedRadioTile == 1
                                                ? AppLocalizations.of(context)!.product_did_not_arrive_at_all
                                                : state.selectedRadioTile == 2
                                                    ? AppLocalizations.of(context)!.product_arrived_damaged
                                                    : state.selectedRadioTile == 3
                                                        ? AppLocalizations.of(context)!.product_arrived_incomplete
                                                        : state.selectedRadioTile == 4
                                                            ? AppLocalizations.of(context)!.expiration_date_issue
                                                            : state.selectedRadioTile == 5
                                                                ? AppLocalizations.of(context)!.wrong_product_received
                                                                : '',
                                          ));
                                    } else {
                                      context.read<ProductDetailsBloc>().add(ProductDetailsEvent.updateReturnEvent(
                                            context: context,
                                            bottomSheetContext: context1,
                                            supplierId: supplierId,
                                            productId: productId,
                                            totalRefund: 0,
                                            proofImages: productIssueData[state.selectedRadioTile]!['proofImage'],
                                            notes: state.addNoteController.text,
                                            productName: productName,
                                            productImage: "${AppUrlEndPoints.baseFileUrl}$image",
                                            barcode: barcode!,
                                            totalUnits: productIssueData[state.selectedRadioTile]!['quantity'],
                                            isApproved: false,
                                            orderId: widget.orderId,
                                            returnProduct: returnProducts,
                                            returnProductId: returnProductId,
                                            isRemoved: false,
                                            reasonToReturn: state.selectedRadioTile == 1
                                                ? AppLocalizations.of(context)!.product_did_not_arrive_at_all
                                                : state.selectedRadioTile == 2
                                                    ? AppLocalizations.of(context)!.product_arrived_damaged
                                                    : state.selectedRadioTile == 3
                                                        ? AppLocalizations.of(context)!.product_arrived_incomplete
                                                        : state.selectedRadioTile == 4
                                                            ? AppLocalizations.of(context)!.expiration_date_issue
                                                            : state.selectedRadioTile == 5
                                                                ? AppLocalizations.of(context)!.wrong_product_received
                                                                : '',
                                          ));
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_20, horizontal: AppConstants.padding_30),
                                  child: CustomButtonWidget(
                                    width: returnProducts.any((item) => item.barcode == barcode) ? 120 : MediaQuery.of(context).size.width * 0.8,
                                    buttonText: AppLocalizations.of(context)!.save,
                                    bGColor: AppColors.mainColor,
                                    isLoading: state.isLoading,
                                  ),
                                ),
                              ),
                              returnProducts.any((item) => item.barcode == barcode)
                                  ? GestureDetector(
                                      onTap: () {
                                        if (returnProducts.length > 1) {
                                          context.read<ProductDetailsBloc>().add(ProductDetailsEvent.updateReturnEvent(
                                                context: context,
                                                bottomSheetContext: context1,
                                                supplierId: supplierId,
                                                productId: productId,
                                                totalRefund: 0,
                                                proofImages: productIssueData[state.selectedRadioTile]!['proofImage'],
                                                notes: state.addNoteController.text,
                                                productName: productName,
                                                productImage: "${AppUrlEndPoints.baseFileUrl}$image",
                                                barcode: barcode!,
                                                totalUnits: productIssueData[state.selectedRadioTile]!['quantity'],
                                                isApproved: false,
                                                orderId: widget.orderId,
                                                returnProduct: returnProducts,
                                                returnProductId: returnProductId,
                                                isRemoved: true,
                                                reasonToReturn: state.selectedRadioTile == 1
                                                    ? AppLocalizations.of(context)!.product_did_not_arrive_at_all
                                                    : state.selectedRadioTile == 2
                                                        ? AppLocalizations.of(context)!.product_arrived_damaged
                                                        : state.selectedRadioTile == 3
                                                            ? AppLocalizations.of(context)!.product_arrived_incomplete
                                                            : state.selectedRadioTile == 4
                                                                ? AppLocalizations.of(context)!.expiration_date_issue
                                                                : state.selectedRadioTile == 5
                                                                    ? AppLocalizations.of(context)!.wrong_product_received
                                                                    : '',
                                              ));
                                        } else {
                                          context.read<ProductDetailsBloc>().add(ProductDetailsEvent.deleteEvent(
                                              context: context,
                                              bottomSheetContext: context1,
                                              returnId: returnId,
                                              reasonToReturn: state.selectedRadioTile == 1
                                                  ? AppLocalizations.of(context)!.product_did_not_arrive_at_all
                                                  : state.selectedRadioTile == 2
                                                      ? AppLocalizations.of(context)!.product_arrived_damaged
                                                      : state.selectedRadioTile == 3
                                                          ? AppLocalizations.of(context)!.product_arrived_incomplete
                                                          : state.selectedRadioTile == 4
                                                              ? AppLocalizations.of(context)!.expiration_date_issue
                                                              : state.selectedRadioTile == 5
                                                                  ? AppLocalizations.of(context)!.wrong_product_received
                                                                  : '',
                                              barcode: barcode!,
                                              orderSupplierProduct: orderSupplierProduct));
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_20, horizontal: AppConstants.padding_30),
                                        child: CustomButtonWidget(
                                          isFromConnectScreen: true,
                                          width: 120,
                                          buttonText: AppLocalizations.of(context)!.issue_remove,
                                          bGColor: AppColors.redColor,
                                          isLoading: state.isRemoveProcess,
                                          fontColors: AppColors.redColor,
                                          borderColor: AppColors.redColor,
                                          loadingColor: AppColors.mainColor,
                                        ),
                                      ),
                                    )
                                  : 0.height,
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    ).then((onValue) {
      if (onValue['refresh']) {
        final deletedBarcode = onValue['deletedBarcode'] as String?;

        context.read<ProductDetailsBloc>().add(
              ProductDetailsEvent.getReturnListEvent(
                context: context,
                excludeBarcodes: deletedBarcode != null ? [deletedBarcode] : null,
              ),
            );
      }
    });
  }

  Widget radioButtonWidget({
    required BuildContext context,
    required BuildContext bottomSheetContext,
    required String problem,
    required int value,
    required int listIndex,
    required String scale,
    required int groupValue,
    int? missingQuantity,
    String? note,
    int? totalQuantity,
    required int radioQuantity,
    required List<ReturnProduct> returnList,
    String? barcode,
    required List<String> proofImage,
    required Map<int, Map<String, dynamic>> productIssueData,
    required String language,
  }) {
    ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();

    return BlocProvider.value(
      value: context.read<ProductDetailsBloc>(),
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          var currentQty = productIssueData[value]!['quantity'] ?? radioQuantity;

          if ((value == 2 || value == 4) && state.selectedRadioTile == value) {
            if (state.proofImagesList.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                bloc.add(ProductDetailsEvent.getPickDocumentEvent(context: context, proofImages: proofImage));
              });
            }
          }

          return Container(
            height: ((value == 2 || value == 4) && state.selectedRadioTile == value) ? 240 : 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_3),
            decoration: BoxDecoration(
              color: AppColors.pageColor,
              boxShadow: [
                BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.10), blurRadius: AppConstants.blur_10),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: value,
                          fillColor: WidgetStateColor.resolveWith(
                            (states) => AppColors.mainColor,
                          ),
                          groupValue: state.selectedRadioTile,
                          onChanged: (val) async {
                            addProblemController.clear();
                            bloc.add(ProductDetailsEvent.radioButtonEvent(selectRadioTile: val!));
                            bloc.add(ProductDetailsEvent.getPickDocumentEvent(context: context, proofImages: proofImage));
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              problem,
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor,
                              ),
                            ),
                            8.height,
                            if (state.selectedRadioTile == value)
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      bloc.add(
                                        ProductDetailsEvent.productIncrementEvent(
                                          productQuantity: totalQuantity!,
                                          listIndex: listIndex,
                                          context: bottomSheetContext,
                                          messingQuantity: currentQty!,
                                          radioValue: value,
                                          productIssueData: productIssueData,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppConstants.radius_2),
                                        border: Border.all(color: AppColors.greyColor),
                                        color: AppColors.pageColor,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  10.width,
                                  Text(
                                    '${currentQty.toString()}${' '}${AppLocalizations.of(context)!.units}',
                                    style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.blackColor,
                                      size: AppConstants.font_12,
                                    ),
                                  ),
                                  10.width,
                                  GestureDetector(
                                    onTap: () {
                                      bloc.add(
                                        ProductDetailsEvent.productDecrementEvent(
                                          productQuantity: totalQuantity!,
                                          listIndex: listIndex,
                                          messingQuantity: currentQty,
                                          context: context,
                                          radioValue: value,
                                          productIssueData: productIssueData,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppConstants.radius_3),
                                        border: Border.all(color: AppColors.greyColor),
                                        color: AppColors.pageColor,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        )
                      ],
                    ),
                    5.width,
                  ],
                ),
                if ((value == 2 || value == 4) && state.selectedRadioTile == value) ...[
                  if (value == 2 || value == 4) 15.height,
                  if (value == 2 || value == 4)
                    Text(
                      AppLocalizations.of(context)!.add_proof_img,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont),
                      textAlign: TextAlign.start,
                    ),
                  if (value == 2 || value == 4) 15.height,
                  if (value == 2 || value == 4)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (state.proofFile != null && await state.proofFile.exists() || state.proofFile.path.contains("https")) {
                                uploadProofBottomSheet(
                                  context: context,
                                  file: state.proofFile,
                                  index: 1,
                                  language: language,
                                  productIssueData: productIssueData,
                                  selectedRadio: state.selectedRadioTile,
                                );
                                return;
                              }

                              cameraEvent(
                                context: context,
                                index: 1,
                                productIssueData: productIssueData,
                                selectedRadio: state.selectedRadioTile,
                              );
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                              ),
                              alignment: Alignment.center,
                              child: state.proofFile.path.contains("https")
                                  ? Image.network(
                                      state.proofFile.path,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: SizedBox(
                                              width: AppConstants.containerHeight_80,
                                              height: AppConstants.containerHeight_80,
                                              child: CupertinoActivityIndicator(
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: AppColors.whiteColor,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            AppImagePath.imageNotAvailable5,
                                          ),
                                        );
                                      },
                                    )
                                  : state.proofFile.existsSync()
                                      ? Image.file(
                                          state.proofFile,
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 120,
                                        )
                                      : const Icon(
                                          Icons.add,
                                          size: 60,
                                        ),
                            ),
                          ),
                          8.width,
                          InkWell(
                            onTap: () async {
                              if (state.proofFile1 != null && await state.proofFile1.exists() || state.proofFile1.path.contains("https")) {
                                uploadProofBottomSheet(
                                  context: context,
                                  file: state.proofFile1,
                                  index: 2,
                                  language: language,
                                  productIssueData: productIssueData,
                                  selectedRadio: state.selectedRadioTile,
                                );
                                return;
                              }

                              cameraEvent(
                                context: context,
                                index: 2,
                                productIssueData: productIssueData,
                                selectedRadio: state.selectedRadioTile,
                              );
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                              ),
                              alignment: Alignment.center,
                              child: state.proofFile1.path.contains("https")
                                  ? Image.network(
                                      state.proofFile1.path,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: SizedBox(
                                              width: AppConstants.containerHeight_80,
                                              height: AppConstants.containerHeight_80,
                                              child: CupertinoActivityIndicator(
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: AppColors.whiteColor,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            AppImagePath.imageNotAvailable5,
                                          ),
                                        );
                                      },
                                    )
                                  : state.proofFile1.existsSync()
                                      ? Image.file(
                                          state.proofFile1,
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 120,
                                        )
                                      : const Icon(
                                          Icons.add,
                                          size: 60,
                                        ),
                            ),
                          ),
                          8.width,
                          InkWell(
                            onTap: () async {
                              if (state.proofFile2 != null && await state.proofFile2.exists() || state.proofFile2.path.contains("https")) {
                                uploadProofBottomSheet(
                                  context: context,
                                  file: state.proofFile2,
                                  index: 3,
                                  language: language,
                                  productIssueData: productIssueData,
                                  selectedRadio: state.selectedRadioTile,
                                );
                                return;
                              }

                              cameraEvent(
                                context: context,
                                index: 3,
                                productIssueData: productIssueData,
                                selectedRadio: state.selectedRadioTile,
                              );
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                              ),
                              alignment: Alignment.center,
                              child: state.proofFile2.path.contains("https")
                                  ? Image.network(
                                      state.proofFile2.path,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: SizedBox(
                                              width: AppConstants.containerHeight_80,
                                              height: AppConstants.containerHeight_80,
                                              child: CupertinoActivityIndicator(
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: AppColors.whiteColor,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            AppImagePath.imageNotAvailable5,
                                          ),
                                        );
                                      },
                                    )
                                  : state.proofFile2.existsSync()
                                      ? Image.file(
                                          state.proofFile2,
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 120,
                                        )
                                      : const Icon(
                                          Icons.add,
                                          size: 60,
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  uploadProofBottomSheet({
    required BuildContext context,
    required File file,
    required int index,
    required String language,
    required Map<int, Map<String, dynamic>> productIssueData,
    required int selectedRadio,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context1) => Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(AppConstants.radius_20),
            topLeft: Radius.circular(AppConstants.radius_20),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_30, vertical: AppConstants.padding_20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.upload_photo,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.w600),
            ),
            30.height,
            FileSelectionOptionWidget(
              title: AppLocalizations.of(context)!.camera,
              icon: Icons.camera_alt_rounded,
              onTap: () {
                Navigator.pop(context);
                cameraEvent(context: context, index: index, productIssueData: productIssueData, selectedRadio: selectedRadio);
              },
            ),

            FileSelectionOptionWidget(
              title: AppLocalizations.of(context)!.delete,
              icon: Icons.delete,
              lastItem: true,
              iconColor: Colors.red,
              onTap: () async {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context2) => CommonAlertDialog(
                    directionality: language,
                    title: AppLocalizations.of(context)!.remove,
                    subTitle: AppLocalizations.of(context)!.are_you_sure,
                    positiveTitle: AppLocalizations.of(context)!.yes,
                    negativeTitle: AppLocalizations.of(context)!.no,
                    negativeOnTap: () {
                      Navigator.pop(context2);
                    },
                    positiveOnTap: () async {
                      context.read<ProductDetailsBloc>().add(ProductDetailsEvent.deleteFileEvent(
                            context: context,
                            index: index,
                            productIssueData: productIssueData,
                            selectedRadio: selectedRadio,
                          ));
                      Navigator.pop(context2);
                    },
                  ),
                );
              },
            )
            // : 0.height,
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  cameraEvent({
    required BuildContext context,
    required int index,
    required Map<int, Map<String, dynamic>> productIssueData,
    required int selectedRadio,
  }) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (Platform.isAndroid) {
      if (!statuses[Permission.camera]!.isGranted) {
        Navigator.pop(context);
        CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.camera_permission, type: SnackBarType.failure);
        return;
      }
    } else if (Platform.isIOS) {
      // Navigator.pop(context);
    }
    context.read<ProductDetailsBloc>().add(ProductDetailsEvent.pickDocumentEvent(
          context: context,
          isFromCamera: true,
          value: index,
          productIssueData: productIssueData,
          selectedRadio: selectedRadio,
        ));
  }

  uploadDriverProofBottomSheet({
    required BuildContext context,
    required File file,
    required int index,
    required String language,
    required Map<int, Map<String, dynamic>> productIssueData,
    required int selectedRadio,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context1) => Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(AppConstants.radius_20),
            topLeft: Radius.circular(AppConstants.radius_20),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_30, vertical: AppConstants.padding_20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.upload_photo,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.w600),
            ),
            30.height,
            FileSelectionOptionWidget(
              title: AppLocalizations.of(context)!.camera,
              icon: Icons.camera_alt_rounded,
              onTap: () {
                Navigator.pop(context);
                cameraDriverProofEvent(context: context, index: index, productIssueData: {}, selectedRadio: 0);
              },
            ),
            // (file.existsSync()) // <--- Changed here
            //     ?
            FileSelectionOptionWidget(
              title: AppLocalizations.of(context)!.delete,
              icon: Icons.delete,
              lastItem: true,
              iconColor: Colors.red,
              onTap: () async {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context2) => CommonAlertDialog(
                    directionality: language,
                    title: AppLocalizations.of(context)!.remove,
                    subTitle: AppLocalizations.of(context)!.are_you_sure,
                    positiveTitle: AppLocalizations.of(context)!.yes,
                    negativeTitle: AppLocalizations.of(context)!.no,
                    negativeOnTap: () {
                      Navigator.pop(context2);
                    },
                    positiveOnTap: () async {
                      context.read<ProductDetailsBloc>().add(ProductDetailsEvent.deleteProofFileEvent(
                            context: context,
                            index: index,
                          ));
                      Navigator.pop(context2);
                    },
                  ),
                );
              },
            )
            // : 0.height,
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  cameraDriverProofEvent({
    required BuildContext context,
    required int index,
    required Map<int, Map<String, dynamic>> productIssueData,
    required int selectedRadio,
  }) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (Platform.isAndroid) {
      if (!statuses[Permission.camera]!.isGranted) {
        Navigator.pop(context);
        CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.camera_permission, type: SnackBarType.failure);
        return;
      }
    } else if (Platform.isIOS) {
      // Navigator.pop(context);
    }
    context.read<ProductDetailsBloc>().add(ProductDetailsEvent.pickProofDocumentEvent(
          context: context,
          isFromCamera: true,
          value: index,
        ));
  }

  Widget basketRow(String title, String amount, {bool isTitle = false, Color color = Colors.black}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: color, fontWeight: FontWeight.bold),
        ),
        20.width,
        Text(
          amount,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: color, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void duplicateOrderDialog({required BuildContext context, required String directionality}) {
    showDialog(
      context: context,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<ProductDetailsBloc>(),
          child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
            builder: (context, state) {
              return AbsorbPointer(
                absorbing: state.isDuplicateOrderProcess ? true : false,
                child: CustomDialog(
                  isProcessing: state.isDuplicateOrderProcess,
                  title: AppLocalizations.of(context)!.you_want_to_duplicate_this_order,
                  content: const [],
                  isMixedSale: false,
                  directionality: state.language,
                  positiveTitle: AppLocalizations.of(context)!.yes,
                  negativeTitle: AppLocalizations.of(context)!.no,
                  positiveOnTap: () {
                    context.read<ProductDetailsBloc>().add(ProductDetailsEvent.duplicateOrderEvent(
                          context: context,
                          orderId: widget.orderId,
                          dialogContext: context1,
                        ));
                  },
                  negativeOnTap: () {
                    Navigator.pop(context1);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
