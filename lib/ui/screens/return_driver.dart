import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/return_driver/return_driver_bloc.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/dialogs/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
import '../widget/file_selection_option_widget.dart';
import '../widget/product_details_screen_shimmer_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ReturnDriverRoute {
  static Widget get route => const ReturnDriverScreen();
}

class ReturnDriverScreen extends StatelessWidget {
  final String orderId;
  final String issue;
  final String orderNumber;
  final bool isNavigateToProductDetailString;
  final OrdersBySupplier productData;
  final OrderDatum orderData;
  final List<StatusData> statusList;

  const ReturnDriverScreen({
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
      create: (context) => ReturnDriverBloc()
        ..add(ReturnDriverEvent.getOrderByIdEvent(
            context: context, orderId: orderId))
        ..add(ReturnDriverEvent.getProductDataEvent(
            context: context,
            orderId: orderId,
            orderData: orderData,
            orderBySupplierProduct: productData))
        ..add(ReturnDriverEvent.getReturnListEvent(context: context)),
      child: ReturnDriverScreenWidget(
          orderId: orderId, orderNumber: orderNumber, statusList: statusList),
    );
  }
}

class ReturnDriverScreenWidget extends StatefulWidget {
  final String orderId;
  final String orderNumber;
  final List<StatusData> statusList;
  const ReturnDriverScreenWidget(
      {super.key,
      required this.orderId,
      required this.orderNumber,
      required this.statusList});

  @override
  State<ReturnDriverScreenWidget> createState() =>
      _ReturnDriverScreenWidgetState();
}

class _ReturnDriverScreenWidgetState extends State<ReturnDriverScreenWidget> {
  TextEditingController addProblemController = TextEditingController();
  String skuNumber = "5321";

  @override
  Widget build(BuildContext context) {
    ReturnDriverBloc bloc = context.read<ReturnDriverBloc>();
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocBuilder<ReturnDriverBloc, ReturnDriverState>(
        builder: (context, state) {
      final bool isOrderStatusCardType = state
                  .orderData.orderstatus?.orderStatusNumber ==
              AppConstants.onTheWayStatus ||
          state.orderData.orderstatus?.orderStatusNumber ==
                  AppConstants.paidStatus &&
              state.orderData.pendingDeliveryConfirmation! == true &&
              state.orderData.paymentMethod.toString() == AppStrings.creditCard;

      return FocusDetector(
        onFocusGained: () {
          bloc.add(ReturnDriverEvent.getPermissionList(context: context));
        },
        child: Scaffold(
          backgroundColor: AppColors.pageColor,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.driver_return,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                }),
          ),
          body: state.isShimmering && state.isLoading ||
                  (state.orderBySupplierProduct.products?.isEmpty ?? false)
              ? const ProductDetailsScreenShimmerWidget()
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: SafeArea(
                    child: AnimationLimiter(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(seconds: 1),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                    horizontalOffset:
                                        MediaQuery.of(context).size.width / 2,
                                    child: FadeInAnimation(child: widget),
                                  ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppConstants.padding_5,
                                      horizontal: AppConstants.padding_15),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .return_products_list,
                                          style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.smallFont,
                                              color: AppColors.blackColor),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bloc.add(const ReturnDriverEvent
                                                .checkAllEvent());
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                                AppConstants.padding_5),
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius
                                                  .all(Radius.circular(
                                                      AppConstants.radius_3)),
                                              color: state.isAllCheck
                                                  ? AppColors.mainColor
                                                  : AppColors.lightBorderColor,
                                              border: Border.all(
                                                  color:
                                                      AppColors.lightGreyColor),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .check_all,
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                      size:
                                                          AppConstants.font_14,
                                                      color: state.isAllCheck
                                                          ? AppColors.whiteColor
                                                          : AppColors
                                                              .blackColor),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                ListView.builder(
                                    itemCount:
                                        state.returnDriverData.data?.length ??
                                            0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                        top: AppConstants.padding_5,
                                        bottom: AppConstants.padding_70),
                                    itemBuilder: (context, dataIndex) {
                                      final returnDataItem = state
                                          .returnDriverData.data![dataIndex];
                                      final bool isChecked =
                                          state.checkedItems[dataIndex] ??
                                              false;

                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Checkbox(
                                                  value: isChecked,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppConstants
                                                                  .radius_3)),
                                                  side: BorderSide(
                                                      width: 1.0,
                                                      color:
                                                          AppColors.greyColor),
                                                  activeColor:
                                                      AppColors.mainColor,
                                                  onChanged: (value) {
                                                    bloc.add(ReturnDriverEvent
                                                        .toggleItemChecked(
                                                            index: dataIndex,
                                                            isChecked: value ??
                                                                false));
                                                  }),
                                              Text(
                                                '${AppLocalizations.of(context)!.return_number_text} ${returnDataItem.returnNumber}',
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                        size: AppConstants
                                                            .font_14,
                                                        color: AppColors
                                                            .blackColor),
                                              ),
                                            ]),
                                            ListView.builder(
                                                itemCount: returnDataItem
                                                        .returnProducts
                                                        ?.length ??
                                                    0,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: const EdgeInsets.only(
                                                    bottom:
                                                        AppConstants.padding_5,
                                                    left:
                                                        AppConstants.padding_5),
                                                itemBuilder:
                                                    (context, productIndex) {
                                                  final product = returnDataItem
                                                          .returnProducts![
                                                      productIndex];
                                                  return productListItem(
                                                    productName:
                                                        product.productName,
                                                    productImage:
                                                        product.productImage,
                                                    totalUnit:
                                                        product.totalUnits,
                                                    createdAt:
                                                        product.createdAt,
                                                    index: productIndex,
                                                  );
                                                }),
                                            if (isChecked) ...[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: AppConstants
                                                            .padding_8,
                                                        vertical: AppConstants
                                                            .padding_5),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .driver_return_delivery_document_img,
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .font_14),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: AppConstants
                                                            .padding_8,
                                                        vertical: AppConstants
                                                            .padding_5),
                                                child: Text(
                                                  '${AppLocalizations.of(context)!.note}: ${AppLocalizations.of(context)!.driver_return_delivery_document_img_note}',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .font_12,
                                                          color: AppColors
                                                              .redColor),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: AppConstants
                                                            .padding_15),
                                                child: SingleChildScrollView(
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: List.generate(3,
                                                        (imageIndex) {
                                                      final List<
                                                          File?> files = List<
                                                              File?>.from(
                                                          state.driverDeliveryProofFilesMap[
                                                                  dataIndex] ??
                                                              List.filled(
                                                                  3, null));
                                                      final File? file =
                                                          files[imageIndex];
                                                      return Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right: AppConstants
                                                                .padding_8),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (file != null) {
                                                              uploadDriverProofBottomSheet(
                                                                context:
                                                                    context,
                                                                file: file,
                                                                index:
                                                                    dataIndex,
                                                                imageIndex:
                                                                    imageIndex,
                                                                language: state
                                                                    .language,
                                                                productIssueData: {},
                                                              );
                                                            } else {
                                                              cameraDriverProofEvent(
                                                                  context:
                                                                      context,
                                                                  index:
                                                                      dataIndex,
                                                                  imageIndex:
                                                                      imageIndex,
                                                                  productIssueData: {});
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 120,
                                                            width: 120,
                                                            color: AppColors
                                                                .whiteColor,
                                                            child: file != null
                                                                ? Image.file(
                                                                    file,
                                                                    fit: BoxFit
                                                                        .cover)
                                                                : const Icon(
                                                                    Icons.add,
                                                                    size: 50),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            ]
                                          ]);
                                    }),
                              ])),
                    ),
                  ),
                ),
          bottomSheet: isOrderStatusCardType
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.padding_20,
                      horizontal: AppConstants.padding_30),
                  color: AppColors.pageColor,
                  child: CustomButtonWidget(
                    onPressed: () {
                      final checkedItems = state.checkedItems;

                      final sentReturnData = <Map<String, dynamic>>[];
                      checkedItems.forEach((index, isChecked) {
                        if (isChecked) {
                          final returnDataItem =
                              state.returnDriverData.data?[index];
                          if (returnDataItem == null) return;
                          final sentReturnId = returnDataItem.id ?? '';
                          final urls =
                              state.driverDeliveryProofUrlsMap[index] ?? [];
                          final signedReturnReceiptImages = urls
                              .where((url) => url != null && url.isNotEmpty)
                              .map((url) => url!)
                              .toList();
                          if (signedReturnReceiptImages.isNotEmpty) {
                            sentReturnData.add({
                              'sentReturnId': sentReturnId,
                              'signedReturnReceiptImages':
                                  signedReturnReceiptImages
                            });
                          }
                        }
                      });

                      Navigator.pushNamed(
                          context, RouteDefine.shipmentVerificationScreen.name,
                          arguments: {
                            AppStrings.supplierNameString: state
                                    .orderBySupplierProduct.supplierName
                                    ?.toString() ??
                                '',
                            AppStrings.deliveryStatusString:
                                args?[AppStrings.deliveryStatusString],
                            AppStrings.totalOrderString:
                                state.orderData.totalVatAmount?.toStringAsFixed(
                                        AppConstants.amountFrLength) ??
                                    '0',
                            AppStrings.quantityString: state
                                    .orderBySupplierProduct.products?.length
                                    .toString() ??
                                '',
                            AppStrings.totalAmountString:
                                state.orderData.totalVatAmount?.toStringAsFixed(
                                        AppConstants.amountFrLength) ??
                                    0,
                            AppStrings.orderIdString:
                                args?[AppStrings.orderIdString],
                            AppStrings.supplierIdString:
                                state.orderBySupplierProduct.id,
                            AppStrings.orderStatusNo: state
                                    .orderData.orderstatus?.orderStatusNumber ??
                                2,
                            AppStrings.deliveryDateString:
                                state.orderBySupplierProduct.orderDeliveryDate,
                            AppStrings.supplierOrderNumberString:
                                state.orderData.orderNumber,
                            AppStrings.driverDeliveryDocumentsImages:
                                args?[AppStrings.driverDeliveryDocumentsImages],
                            AppStrings.sentReturnData: sentReturnData,
                            AppStrings.orderIssueReturnId:
                                args?[AppStrings.orderIssueReturnId],
                            AppStrings.availableSurfaceQuantityToReturn: args?[
                                AppStrings.availableSurfaceQuantityToReturn]
                          });
                    },
                    buttonText: AppLocalizations.of(context)!.next,
                    bGColor: AppColors.mainColor,
                  ),
                )
              : 0.width,
        ),
      );
    });
  }

  Widget productListItem(
      {String? productName,
      String? productImage,
      int? totalUnit,
      String? createdAt,
      int? index}) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.padding_10),
      padding: EdgeInsets.symmetric(
          vertical: AppConstants.padding_5,
          horizontal:
              getScreenHeight(context) >= 730 ? AppConstants.padding_3 : 0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.15),
              blurRadius: AppConstants.blur_10)
        ],
        borderRadius:
            const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding_5),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            productImage != ''
                ? Image.network(productImage ?? '',
                    width: AppConstants.containerHeight_80,
                    height: AppConstants.containerHeight_80,
                    fit: BoxFit.contain, loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                  ) {
                    if (loadingProgress == null) return child;
                    return loaderWidget(AppConstants.containerHeight_80);
                  }, errorBuilder: (context, error, stackTrace) {
                    return imageNotAvailableWidget(
                        AppConstants.containerHeight_80);
                  })
                : Image.asset(AppImagePath.imageNotAvailable5,
                    fit: BoxFit.cover,
                    width: AppConstants.containerHeight_80,
                    height: AppConstants.containerHeight_80),
            15.width,
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: MediaQuery.of(context).size.width > 370
                    ? MediaQuery.of(context).size.width / 2
                    : 160,
                child: Text(
                  productName.toString(),
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_14,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 370
                    ? MediaQuery.of(context).size.width / 2
                    : 160,
                child: Text('$totalUnit ${AppLocalizations.of(context)!.units}',
                    style: AppStyles.rkRegularTextStyle(
                        color: AppColors.blackColor,
                        size: AppConstants.font_12)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 370
                    ? MediaQuery.of(context).size.width / 2
                    : 160,
                child: Text(formatDate(createdAt.toString()),
                    style: AppStyles.rkRegularTextStyle(
                        color: AppColors.blackColor,
                        size: AppConstants.font_12)),
              ),
              3.height,
            ]),
            10.width,
          ]),
        ]),
      ),
    );
  }

  uploadDriverProofBottomSheet({
    required BuildContext context,
    required File file,
    required int index,
    required int imageIndex,
    required String language,
    required Map<int, Map<String, dynamic>> productIssueData,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context1) => Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(AppConstants.radius_20),
              topLeft: Radius.circular(AppConstants.radius_20)),
        ),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.padding_30,
            vertical: AppConstants.padding_20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          FileSelectionOptionWidget(
              title: AppLocalizations.of(context)!.camera,
              icon: Icons.camera_alt_rounded,
              onTap: () {
                Navigator.pop(context);
                cameraDriverProofEvent(
                    context: context,
                    index: index,
                    imageIndex: imageIndex,
                    productIssueData: productIssueData);
              }),
          file.existsSync()
              ? FileSelectionOptionWidget(
                  title: AppLocalizations.of(context)!.delete,
                  icon: Icons.delete,
                  iconColor: AppColors.redColor,
                  lastItem: true,
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
                            context.read<ReturnDriverBloc>().add(
                                ReturnDriverEvent.deleteProofFileEvent(
                                    context: context,
                                    index: index,
                                    fileIndex: imageIndex));
                            Navigator.pop(context2);
                          }),
                    );
                  })
              : const SizedBox.shrink(),
        ]),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  cameraDriverProofEvent(
      {required BuildContext context,
      required int index,
      required int imageIndex,
      required Map<int, Map<String, dynamic>> productIssueData}) async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera].request();
    if (Platform.isAndroid) {
      if (!statuses[Permission.camera]!.isGranted) {
        Navigator.pop(context);
        CustomSnackBar.showSnackBar(
            context: context,
            title: AppLocalizations.of(context)!.camera_permission,
            type: SnackBarType.failure);
        return;
      }
    } else if (Platform.isIOS) {}
    context.read<ReturnDriverBloc>().add(
        ReturnDriverEvent.pickProofDocumentEvent(
            context: context,
            isFromCamera: true,
            value: imageIndex,
            index: index));
  }

  String formatDate(String rawDate) {
    final DateTime parsedDate = DateTime.parse(rawDate);
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(parsedDate);
  }
}
