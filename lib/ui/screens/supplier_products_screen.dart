import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/supplier_products/supplier_products_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/supplier_products_screen_shimmer_widget.dart';

import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/product_details_shimmer_widget.dart';

class SupplierProductsRoute {
  static Widget get route => SupplierProductsScreen();
}

class SupplierProductsScreen extends StatelessWidget {
  const SupplierProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => SupplierProductsBloc()
        ..add(SupplierProductsEvent.getSupplierProductsIdEvent(
            supplierId: args?[AppStrings.supplierIdString]))
        ..add(SupplierProductsEvent.getSupplierProductsListEvent(
            context: context)),
      child: SupplierProductsScreenWidget(),
    );
  }
}

class SupplierProductsScreenWidget extends StatelessWidget {
  const SupplierProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: AppLocalizations.of(context)!.products,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: NotificationListener<ScrollNotification>(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Stack(
                    //   children: [
                    //     Container(
                    //       height: getScreenWidth(context) / 3,
                    //       width: getScreenWidth(context) / 3,
                    //       clipBehavior: Clip.hardEdge,
                    //       margin: EdgeInsets.symmetric(
                    //           vertical: AppConstants.padding_10,
                    //           horizontal: AppConstants.padding_5),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.all(
                    //             Radius.circular(AppConstants.radius_10)),
                    //         color: AppColors.whiteColor,
                    //         boxShadow: [
                    //           BoxShadow(
                    //               color: AppColors.shadowColor.withOpacity(0.15),
                    //               blurRadius: AppConstants.blur_10)
                    //         ],
                    //       ),
                    //       child: Image.network(
                    //         "${AppUrls.baseFileUrl}",
                    //         fit: BoxFit.cover,
                    //         loadingBuilder: (context, child, loadingProgress) {
                    //           if (loadingProgress?.cumulativeBytesLoaded !=
                    //               loadingProgress?.expectedTotalBytes) {
                    //             return Container(
                    //               height: getScreenWidth(context) / 3,
                    //               width: getScreenWidth(context) / 3,
                    //               alignment: Alignment.center,
                    //               color: AppColors.whiteColor,
                    //               child: CupertinoActivityIndicator(
                    //                 color: AppColors.blackColor,
                    //               ),
                    //             );
                    //           }
                    //           return child;
                    //         },
                    //         errorBuilder: (context, error, stackTrace) {
                    //           // debugPrint('product category list image error : $error');
                    //           return Container(
                    //             color: AppColors.whiteColor,
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //     Positioned(
                    //       bottom: 0,
                    //       left: AppConstants.padding_5,
                    //       right: AppConstants.padding_5,
                    //       child: Container(
                    //         // height: 20,
                    //         // width: 80,
                    //         alignment: Alignment.center,
                    //         padding: EdgeInsets.symmetric(
                    //             vertical: AppConstants.padding_5,
                    //             horizontal: AppConstants.padding_5),
                    //         decoration: BoxDecoration(
                    //           color: AppColors.mainColor,
                    //           borderRadius: BorderRadius.only(
                    //               bottomLeft:
                    //                   Radius.circular(AppConstants.radius_10),
                    //               bottomRight:
                    //                   Radius.circular(AppConstants.radius_10)),
                    //           // border: Border.all(color: AppColors.whiteColor, width: 1),
                    //         ),
                    //         child: Text(
                    //           'supplierName',
                    //           style: AppStyles.rkRegularTextStyle(
                    //               size: AppConstants.font_12,
                    //               color: AppColors.whiteColor),
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // 10.height,
                    state.isShimmering
                        ? SupplierProductsScreenShimmerWidget()
                        : state.productList.isEmpty
                            ? Container(
                                height: getScreenHeight(context) - 56,
                                width: getScreenWidth(context),
                                alignment: Alignment.center,
                                child: Text(
                                  'Currently this Supplier has no products',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor),
                                ),
                              )
                            : GridView.builder(
                                itemCount: state.productList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppConstants.padding_5),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 9 / 11),
                                itemBuilder: (context, index) =>
                                    buildSupplierProducts(
                                        context: context,
                                        index: index,
                                        isRTL: isRTLContent(context: context)),
                              ),
                    state.isLoadMore
                        ? Container(
                            height: 50,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            child: CupertinoActivityIndicator(
                              color: AppColors.blackColor,
                            ),
                          )
                        : 0.width,
                  ],
                ),
              ),
              onNotification: (notification) {
                if (notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
                  if (!state.isLoadMore) {
                    context.read<SupplierProductsBloc>().add(
                        SupplierProductsEvent.getSupplierProductsListEvent(
                            context: context));
                  }
                }
                return true;
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildSupplierProducts(
      {required BuildContext context,
      required int index,
      required bool isRTL}) {
    return BlocProvider.value(
      value: context.read<SupplierProductsBloc>(),
      child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
        builder: (context, state) {
          return Container(
            // height: 150,
            // width: 130,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.radius_10)),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.15),
                    blurRadius: AppConstants.blur_10),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(
                vertical: AppConstants.padding_10,
                horizontal: AppConstants.padding_5),
            padding: EdgeInsets.symmetric(
                vertical: AppConstants.padding_5,
                horizontal: AppConstants.padding_10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.network(
                    "${AppUrls.baseFileUrl}${state.productList[index].mainImage}",
                    height: 70,
                    fit: BoxFit.fitHeight,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress?.cumulativeBytesLoaded !=
                          loadingProgress?.expectedTotalBytes) {
                        return CommonShimmerWidget(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConstants.radius_10)),
                            ),
                          ),
                        );
                      }
                      return child;
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // debugPrint('sale list image error : $error');
                      return Container(
                        child: Image.asset(AppImagePath.imageNotAvailable5,
                            height: 70,
                            width: double.maxFinite,
                            fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
                5.height,
                Text(
                  "${state.productList[index].productName}",
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_12,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                5.height,
                Expanded(
                  child: 0.width,
                  // child: state.planoGramsList[index].planogramproducts?[subIndex].totalSale == 0
                  //     ? 0.width
                  //     : Text(
                  //   "${state.planoGramsList[index].planogramproducts?[subIndex].totalSale} ${AppLocalizations.of(context)!.discount}",
                  //   style: AppStyles.rkRegularTextStyle(
                  //       size: AppConstants.font_10,
                  //       color: AppColors.saleRedColor,
                  //       fontWeight: FontWeight.w600),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ),
                5.height,
                Center(
                  child: CommonProductButtonWidget(
                    title:
                        "${state.productList[index].productPrice?.toStringAsFixed(0)}${AppLocalizations.of(context)!.currency}",
                    onPressed: () {
                      showProductDetails(
                          context: context,
                          productId: state.productList[index].productId ?? '',
                          index: index);
                    },
                    textColor: AppColors.whiteColor,
                    bgColor: AppColors.mainColor,
                    borderRadius: AppConstants.radius_3,
                    textSize: AppConstants.font_12,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void showProductDetails(
      {required BuildContext context,
      required int index,
      required String productId}) async {
    context.read<SupplierProductsBloc>().add(
        SupplierProductsEvent.getProductDetailsEvent(
            context: context, productId: productId));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      // showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<SupplierProductsBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: 0.7,
            shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<SupplierProductsBloc>(),
                  child:
                      BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppConstants.radius_30),
                            topRight: Radius.circular(AppConstants.radius_30),
                          ),
                          color: AppColors.whiteColor,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Scaffold(
                          body: state.isProductLoading
                              ? ProductDetailsShimmerWidget()
                              : CommonProductDetailsWidget(
                              context: context,
                                  productImage:
                                      state.productDetails.product?.first.mainImage ??
                                          '',
                                  productName: state.productDetails.product
                                          ?.first.productName ??
                                      '',
                                  productCompanyName:
                                      state.productDetails.product?.first.brandName ??
                                          '',
                                  productDescription: state.productDetails
                                          .product?.first.productDescription ??
                                      '',
                                  productSaleDescription: state.productDetails
                                          .product?.first.productDescription ??
                                      '',
                                  productPrice: state.productDetails.product
                                          ?.first.numberOfUnit
                                          ?.toDouble() ??
                                      0.0,
                                  productScaleType: state.productDetails.product
                                          ?.first.scales?.scaleType ??
                                      '',
                                  supplierWidget: buildSupplierSelection(context: context),
                                  productWeight: state.productDetails.product?.first.itemsWeight?.toDouble() ?? 0.0,
                                  productStock: state.productStockList[state.productStockUpdateIndex].stock,
                                  isRTL: isRTLContent(context: context),
                                  scrollController: scrollController,
                                  productQuantity: state.productStockList[state.productStockUpdateIndex].quantity,
                                  onQuantityIncreaseTap: () {
                                    context.read<SupplierProductsBloc>().add(
                                        SupplierProductsEvent
                                            .increaseQuantityOfProduct(
                                                context: context1));
                                  },
                                  onQuantityDecreaseTap: () {
                                    context.read<SupplierProductsBloc>().add(
                                        SupplierProductsEvent
                                            .decreaseQuantityOfProduct(
                                                context: context1));
                                  },
                                  noteController: TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note),
                                  onNoteChanged: (newNote) {
                                    context.read<SupplierProductsBloc>().add(
                                        SupplierProductsEvent
                                            .changeNoteOfProduct(
                                                newNote: newNote));
                                  },
                                  isLoading: state.isLoading,
                                  onAddToOrderPressed: state.isLoading
                                      ? null
                                      : () {
                                          context
                                              .read<SupplierProductsBloc>()
                                              .add(SupplierProductsEvent
                                                  .addToCartProductEvent(
                                                      context: context1));
                                        }),
                        ),
                      );
                    },
                  ));
            },
          ),
        );
      },
    );
  }

  Widget buildSupplierSelection({required BuildContext context}) {
    return BlocProvider.value(
      value: context.read<SupplierProductsBloc>(),
      child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
        builder: (context, state) {
          return AnimatedCrossFade(
              firstChild: Container(
                width: getScreenWidth(context),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: AppColors.borderColor.withOpacity(0.5),
                            width: 1))),
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding_10,
                    horizontal: AppConstants.padding_30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppConstants.padding_5),
                      child: InkWell(
                        onTap: () {
                          context.read<SupplierProductsBloc>().add(
                              SupplierProductsEvent
                                  .changeSupplierSelectionExpansionEvent());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.suppliers,
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.smallFont,
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 26,
                              color: AppColors.blackColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    state.productSupplierList
                            .where((supplier) => supplier.selectedIndex >= 0)
                            .isEmpty
                        ? InkWell(
                            onTap: () {
                              context.read<SupplierProductsBloc>().add(
                                  SupplierProductsEvent
                                      .changeSupplierSelectionExpansionEvent());
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: 60,
                              width: getScreenWidth(context),
                              alignment: Alignment.center,
                              child: Text(
                                'Select supplier',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.blackColor),
                              ),
                            ))
                        : ListView.builder(
                            itemCount: state.productSupplierList
                                    .where((supplier) =>
                                        supplier.selectedIndex >= 0)
                                    .isNotEmpty
                                ? 1
                                : 0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5,
                                    horizontal: AppConstants.padding_10),
                                margin: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5),
                                decoration: BoxDecoration(
                                  color: AppColors.iconBGColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppConstants.radius_5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).companyName}',
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_12,
                                          color: AppColors.blackColor),
                                    ),
                                    Container(
                                      width: getScreenWidth(context),
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  AppConstants.radius_3))),
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.padding_3,
                                          horizontal: AppConstants.padding_5),
                                      margin: EdgeInsets.only(
                                        top: AppConstants.padding_5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).selectedIndex].saleName}'),
                                          2.height,
                                          Text(
                                              'Discount : ${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).selectedIndex].saleDiscount}${AppLocalizations.of(context)!.currency}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                  ],
                ),
              ),
              secondChild: state.productSupplierList.isEmpty
                  ? Center(
                      child: Text(
                        'Suppliers not available',
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont,
                            color: AppColors.textColor),
                      ),
                    )
                  : Container(
                      height: getScreenHeight(context) * 0.5,
                      width: getScreenWidth(context),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.5),
                                  width: 1))),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.padding_10,
                          horizontal: AppConstants.padding_30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppConstants.padding_5),
                            child: InkWell(
                              onTap: () {
                                context.read<SupplierProductsBloc>().add(
                                    SupplierProductsEvent
                                        .changeSupplierSelectionExpansionEvent());
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.suppliers,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.smallFont,
                                        color: AppColors.mainColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.remove,
                                    size: 26,
                                    color: AppColors.blackColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.productSupplierList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 95,
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppConstants.padding_5,
                                      horizontal: AppConstants.padding_10),
                                  margin: EdgeInsets.symmetric(
                                      vertical: AppConstants.padding_10),
                                  decoration: BoxDecoration(
                                      color: AppColors.iconBGColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppConstants.radius_10)),
                                      boxShadow: [
                                        state.productSupplierList[index]
                                                    .selectedIndex >=
                                                0
                                            ? BoxShadow(
                                                color: AppColors.shadowColor
                                                    .withOpacity(0.15),
                                                blurRadius:
                                                    AppConstants.blur_10)
                                            : BoxShadow()
                                      ],
                                      border: Border.all(
                                          color: AppColors.lightBorderColor,
                                          width: 1)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${state.productSupplierList[index].companyName}',
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.font_14,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Expanded(
                                        child: state.productSupplierList[index]
                                                .supplierSales.isEmpty
                                            ? Container(
                                                height: 95,
                                                width: getScreenWidth(context),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Sale not available',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .smallFont,
                                                          color: AppColors
                                                              .textColor),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount: state
                                                    .productSupplierList[index]
                                                    .supplierSales
                                                    .length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (context, subIndex) {
                                                  return InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              SupplierProductsBloc>()
                                                          .add(SupplierProductsEvent
                                                              .supplierSelectionEvent(
                                                                  supplierIndex:
                                                                      index,
                                                                  supplierSaleIndex:
                                                                      subIndex));
                                                      context
                                                          .read<
                                                              SupplierProductsBloc>()
                                                          .add(SupplierProductsEvent
                                                              .changeSupplierSelectionExpansionEvent());
                                                    },
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .whiteColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      AppConstants
                                                                          .radius_10)),
                                                          border: Border.all(
                                                              color: state
                                                                          .productSupplierList[
                                                                              index]
                                                                          .selectedIndex ==
                                                                      subIndex
                                                                  ? AppColors
                                                                      .mainColor
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : Colors.transparent,
                                                              width: 1.5)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  AppConstants
                                                                      .padding_3,
                                                              horizontal:
                                                                  AppConstants
                                                                      .padding_5),
                                                      margin: EdgeInsets.only(
                                                          top: AppConstants
                                                              .padding_5,
                                                          left: AppConstants
                                                              .padding_5,
                                                          right: AppConstants
                                                              .padding_5),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            '${state.productSupplierList[index].supplierSales[subIndex].saleName}',
                                                            style: AppStyles.rkRegularTextStyle(
                                                                size:
                                                                    AppConstants
                                                                        .font_12,
                                                                color: AppColors
                                                                    .saleRedColor),
                                                          ),
                                                          2.height,
                                                          Text(
                                                            'Discount : ${state.productSupplierList[index].supplierSales[subIndex].saleDiscount}${AppLocalizations.of(context)!.currency}',
                                                            style: AppStyles.rkRegularTextStyle(
                                                                size:
                                                                    AppConstants
                                                                        .font_14,
                                                                color: AppColors
                                                                    .blackColor),
                                                          ),
                                                          2.height,
                                                          GestureDetector(
                                                              onTap: () {
                                                                debugPrint(
                                                                    'please open dialog');
                                                              },
                                                              child: Text(
                                                                'Read condition',
                                                                style: AppStyles.rkRegularTextStyle(
                                                                    size: AppConstants
                                                                        .font_10,
                                                                    color: AppColors
                                                                        .blueColor),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
              crossFadeState: state.isSelectSupplier
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300));
        },
      ),
    );
  }
}
