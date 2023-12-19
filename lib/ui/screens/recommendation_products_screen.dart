import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/bloc/recommendation_products/recommendation_products_bloc.dart';
import 'package:food_stock/ui/widget/common_product_item_widget.dart';
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/refresh_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/supplier_products_screen_shimmer_widget.dart';

class RecommendationProductsRoute {
  static Widget get route => RecommendationProductsScreen();
}

class RecommendationProductsScreen extends StatelessWidget {
  const RecommendationProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendationProductsBloc()
        ..add(RecommendationProductsEvent.getRecommendationProductsEvent(
            context: context)),
      child: RecommendationProductsScreenWidget(),
    );
  }
}

class RecommendationProductsScreenWidget extends StatelessWidget {
  const RecommendationProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationProductsBloc, RecommendationProductsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.recommended_for_you,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: SmartRefresher(
              enablePullDown: /*state.isShimmering || state.isLoading ? false : */
                  true,
              controller: state.refreshController,
              header: RefreshWidget(),
              footer: CustomFooter(
                builder: (context, mode) =>
                    SupplierProductsScreenShimmerWidget(),
              ),
              enablePullUp: !state.isBottomOfProducts,
              onRefresh: () {
                context.read<RecommendationProductsBloc>().add(
                    RecommendationProductsEvent.refreshListEvent(
                        context: context));
              },
              onLoading: () {
                context.read<RecommendationProductsBloc>().add(
                    RecommendationProductsEvent.getRecommendationProductsEvent(
                        context: context));
              },
              child:
                  // NotificationListener<ScrollNotification>(
                  // onNotification: (notification) {
                  //   if (notification.metrics.pixels ==
                  //       notification.metrics.maxScrollExtent) {
                  //     if (!state.isLoadMore) {
                  //       context.read<RecommendationProductsBloc>().add(
                  //           RecommendationProductsEvent
                  //               .getRecommendationProductsEvent(
                  //                   context: context));
                  //     }
                  //   }
                  //   return true;
                  // },
                  // child:
                  SingleChildScrollView(
                physics: state.recommendationProductsList.isEmpty
                    ? const NeverScrollableScrollPhysics()
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    state.isShimmering
                        ? SupplierProductsScreenShimmerWidget()
                        : state.recommendationProductsList.isEmpty
                            ? Container(
                                height: getScreenHeight(context) - 80,
                                width: getScreenWidth(context),
                                alignment: Alignment.center,
                                child: Text(
                                  '${AppLocalizations.of(context)!.recommendation_products_are_not_available}',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor),
                                ),
                              )
                            : GridView.builder(
                                itemCount:
                                    state.recommendationProductsList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppConstants.padding_5),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: AppConstants
                                            .productGridAspectRatio),
                                itemBuilder: (context, index) => DelayedWidget(
                                      child: CommonProductItemWidget(
                                          productImage: state
                                                  .recommendationProductsList[
                                                      index]
                                                  .mainImage ??
                                              '',
                                          productName: state
                                                  .recommendationProductsList[
                                                      index]
                                                  .productName ??
                                              '',
                                          totalSaleCount: state
                                                  .recommendationProductsList[
                                                      index]
                                                  .totalSale ??
                                              0,
                                          price: state
                                                  .recommendationProductsList[
                                                      index]
                                                  .productPrice ??
                                              0.0,
                                          onButtonTap: () {
                                            showProductDetails(
                                                context: context,
                                                productId: state
                                                        .recommendationProductsList[
                                                            index]
                                                        .id ??
                                                    '');
                                          }),
                                    )
                                // buildRecommendationProducts(
                                // context: context,
                                // totalSale: state
                                //     .recommendationProductsList[
                                // index]
                                //     .totalSale ??
                                //     0,
                                // productImage: state
                                //     .recommendationProductsList[
                                // index]
                                //     .mainImage ??
                                //     '',
                                // productName: state
                                //     .recommendationProductsList[
                                // index]
                                //     .productName ??
                                //     '',
                                // productPrice: state
                                //     .recommendationProductsList[
                                // index]
                                //     .productPrice ??
                                //     0.0,
                                // onPressed: () {
                                //   showProductDetails(
                                //       context: context,
                                //       productId: state
                                //           .recommendationProductsList[
                                //       index]
                                //           .id ??
                                //           '');
                                // }),
                                ),
                    // state.isLoadMore
                    //     ? SupplierProductsScreenShimmerWidget()
                    //     : 0.width,
                  ],
                ),
              ),
              // ),
            ),
          ),
        );
      },
    );
  }

  Widget buildRecommendationProducts({
    required BuildContext context,
    required int totalSale,
    required String productImage,
    required String productName,
    required double productPrice,
    required void Function() onPressed,
  }) {
    return DelayedWidget(
      child: Container(
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
                "${AppUrls.baseFileUrl}$productImage",
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
                        height: 70, width: double.maxFinite, fit: BoxFit.cover),
                  );
                },
              ),
            ),
            5.height,
            Text(
              productName,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            5.height,
            Expanded(
              child: totalSale == 0
                  ? 0.width
                  : Text(
                      "${totalSale} ${AppLocalizations.of(context)!.discount}",
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_10,
                          color: AppColors.saleRedColor,
                          fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            5.height,
            Center(
              child: CommonProductButtonWidget(
                title:
                    "${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(AppConstants.amountFrLength)}${AppLocalizations.of(context)!.currency}",
                onPressed: onPressed,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_12,
              ),
            )
          ],
        ),
      ),
    );
  }

  void showProductDetails(
      {required BuildContext context, required String productId}) async {
    context.read<RecommendationProductsBloc>().add(
        RecommendationProductsEvent.getProductDetailsEvent(
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
          value: context.read<RecommendationProductsBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: 0.7,
            //  shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<RecommendationProductsBloc>(),
                  child: BlocBuilder<RecommendationProductsBloc,
                      RecommendationProductsState>(
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
                                  productImageIndex: state.imageIndex,
                                  onPageChanged: (index, p1) {
                                    context
                                        .read<RecommendationProductsBloc>()
                                        .add(RecommendationProductsEvent
                                            .updateImageIndexEvent(
                                                index: index));
                                  },
                                  productImages: [
                                    state.productDetails.first.mainImage ?? '',
                                    ...state.productDetails.first.images?.map(
                                            (image) => image.imageUrl ?? '') ??
                                        []
                                  ],
                                  productName:
                                      state.productDetails.first.productName ??
                                          '',
                                  productCompanyName:
                                      state.productDetails.first.brandName ??
                                          '',
                                  productDescription: state.productDetails.first
                                          .productDescription ??
                                      '',
                                  productSaleDescription: state.productDetails
                                          .first.productDescription ??
                                      '',
                                  productPrice:
                                      state.productStockList[state.productStockUpdateIndex].totalPrice *
                                          state
                                              .productStockList[
                                                  state.productStockUpdateIndex]
                                              .quantity,
                                  productScaleType:
                                      state.productDetails.first.scales?.scaleType ??
                                          '',
                                  productWeight: state.productDetails.first.itemsWeight?.toDouble() ?? 0.0,
                                  isNoteOpen: state.productStockList[state.productStockUpdateIndex].isNoteOpen,
                                  onNoteToggleChanged: () {
                                    context
                                        .read<RecommendationProductsBloc>()
                                        .add(RecommendationProductsEvent
                                            .toggleNoteEvent());
                                  },
                                  supplierWidget: state.productSupplierList.isEmpty
                                      ? Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: AppColors
                                                          .borderColor
                                                          .withOpacity(0.5),
                                                      width: 1))),
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  AppConstants.padding_30),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${AppLocalizations.of(context)!.suppliers_not_available}',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.smallFont,
                                                color: AppColors.textColor),
                                          ),
                                        )
                                      : buildSupplierSelection(context: context),
                                  productStock: state.productStockList[state.productStockUpdateIndex].stock,
                                  isRTL: context.rtl,
                                  isSupplierAvailable: state.productSupplierList.isEmpty ? false : true,
                                  scrollController: scrollController,
                                  productQuantity: state.productStockList[state.productStockUpdateIndex].quantity,
                                  onQuantityChanged: (quantity) {
                                    context
                                        .read<RecommendationProductsBloc>()
                                        .add(RecommendationProductsEvent
                                            .updateQuantityOfProduct(
                                                context: context1,
                                                quantity: quantity));
                                  },
                                  onQuantityIncreaseTap: () {
                                    context
                                        .read<RecommendationProductsBloc>()
                                        .add(RecommendationProductsEvent
                                            .increaseQuantityOfProduct(
                                                context: context1));
                                  },
                                  onQuantityDecreaseTap: () {
                                    context
                                        .read<RecommendationProductsBloc>()
                                        .add(RecommendationProductsEvent
                                            .decreaseQuantityOfProduct(
                                                context: context1));
                                  },
                                  noteController: state.noteController,
                                  // TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note)..selection = TextSelection.fromPosition(TextPosition(offset: state.productStockList[state.productStockUpdateIndex].note.length)),
                                  onNoteChanged: (newNote) {
                                    context
                                        .read<RecommendationProductsBloc>()
                                        .add(RecommendationProductsEvent
                                            .changeNoteOfProduct(
                                                newNote: newNote));
                                  },
                                  isLoading: state.isLoading,
                                  onAddToOrderPressed: state.isLoading
                                      ? null
                                      : () {
                                          context
                                              .read<
                                                  RecommendationProductsBloc>()
                                              .add(RecommendationProductsEvent
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
      value: context.read<RecommendationProductsBloc>(),
      child:
      BlocBuilder<RecommendationProductsBloc, RecommendationProductsState>(
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
                          context.read<RecommendationProductsBloc>().add(
                              RecommendationProductsEvent
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
                            .where((supplier) => supplier.selectedIndex != -1)
                            .isEmpty
                        ? InkWell(
                            onTap: () {
                              context.read<RecommendationProductsBloc>().add(
                                  RecommendationProductsEvent
                                      .changeSupplierSelectionExpansionEvent());
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: 60,
                              width: getScreenWidth(context),
                              alignment: Alignment.center,
                              child: Text(
                                '${AppLocalizations.of(context)!.select_supplier}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.blackColor),
                              ),
                            ))
                        : ListView.builder(
                            itemCount: state.productSupplierList
                                    .where((supplier) =>
                                        supplier.selectedIndex != -1)
                                    .isNotEmpty
                                ? 1
                                : 0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 85,
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5,
                                    horizontal: AppConstants.padding_10),
                                margin: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5),
                                decoration: BoxDecoration(
                                  color: AppColors.iconBGColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppConstants.radius_5)),
                                  border: Border.all(
                                      color: AppColors.borderColor
                                          .withOpacity(0.8),
                                      width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex != -1).companyName}',
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: getScreenWidth(context),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.borderColor
                                                    .withOpacity(0.5),
                                                width: 1),
                                            color: AppColors.whiteColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    AppConstants.radius_5))),
                                        padding: EdgeInsets.symmetric(
                                            vertical: AppConstants.padding_3,
                                            horizontal: AppConstants.padding_5),
                                        margin: EdgeInsets.only(
                                          top: AppConstants.padding_5,
                                        ),
                                        child: state.productSupplierList
                                                    .firstWhere(
                                                      (supplier) =>
                                                          supplier
                                                              .selectedIndex ==
                                                          -2,
                                                      orElse: () =>
                                                          ProductSupplierModel(
                                                              supplierId: '',
                                                              companyName: ''),
                                                    )
                                                    .selectedIndex ==
                                                -2
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'Price : ${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex == -2).basePrice.toStringAsFixed(AppConstants.amountFrLength)}${AppLocalizations.of(context)!.currency}',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                            size: AppConstants
                                                                .font_14,
                                                            color: AppColors
                                                                .blackColor),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].saleName}',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                            size: AppConstants
                                                                .font_12,
                                                            color: AppColors
                                                                .saleRedColor),
                                                  ),
                                                  2.height,
                                                  Text(
                                                    'Price : ${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].salePrice.toStringAsFixed(AppConstants.amountFrLength)}${AppLocalizations.of(context)!.currency}(${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].saleDiscount.toStringAsFixed(0)}%)',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                            size: AppConstants
                                                                .font_14,
                                                            color: AppColors
                                                                .blackColor),
                                                  ),
                                                ],
                                              ),
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
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.5),
                                  width: 1))),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.padding_30),
                      alignment: Alignment.center,
                      child: Text(
                        '${AppLocalizations.of(context)!.suppliers_not_available}',
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont,
                            color: AppColors.textColor),
                      ),
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: getScreenHeight(context) * 0.5,
                          maxWidth: getScreenWidth(context)),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.5),
                                    width: 1))),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.padding_10,
                            horizontal: AppConstants.padding_30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppConstants.padding_5),
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<RecommendationProductsBloc>()
                                      .add(RecommendationProductsEvent
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
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.productSupplierList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 105,
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
                                                      .selectedIndex !=
                                                  -1
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
                                          child: ListView.builder(
                                            itemCount: state
                                                    .productSupplierList[index]
                                                    .supplierSales
                                                    .length +
                                                1,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, subIndex) {
                                              return subIndex ==
                                                      state
                                                          .productSupplierList[
                                                              index]
                                                          .supplierSales
                                                          .length
                                                  ? InkWell(
                                                      onTap: () {
                                                        //for base price selection /without sale pass -2
                                                        context
                                                            .read<
                                                                RecommendationProductsBloc>()
                                                            .add(RecommendationProductsEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    context:
                                                                        context,
                                                                    supplierSaleIndex:
                                                                        -2));
                                                        context
                                                            .read<
                                                                RecommendationProductsBloc>()
                                                            .add(RecommendationProductsEvent
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
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    AppConstants
                                                                        .radius_10)),
                                                            border: Border.all(
                                                                color: state
                                                                            .productSupplierList[
                                                                                index]
                                                                            .selectedIndex ==
                                                                        -2
                                                                    ? AppColors
                                                                        .mainColor
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : Colors
                                                                        .transparent,
                                                                width: 1.5)),
                                                        padding: EdgeInsets.symmetric(
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
                                                              'Price : ${state.productSupplierList[index].basePrice.toStringAsFixed(AppConstants.amountFrLength)}${AppLocalizations.of(context)!.currency}',
                                                              style: AppStyles.rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .font_14,
                                                                  color: AppColors
                                                                      .blackColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                RecommendationProductsBloc>()
                                                            .add(RecommendationProductsEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    context:
                                                                        context,
                                                                    supplierSaleIndex:
                                                                        subIndex));
                                                        context
                                                            .read<
                                                                RecommendationProductsBloc>()
                                                            .add(RecommendationProductsEvent
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
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    AppConstants
                                                                        .radius_10)),
                                                            border: Border.all(
                                                                color: state.productSupplierList[index].selectedIndex ==
                                                                        subIndex
                                                                    ? AppColors
                                                                        .mainColor
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : Colors
                                                                        .transparent,
                                                                width: 1.5)),
                                                        padding: EdgeInsets.symmetric(
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
                                                                  size: AppConstants
                                                                      .font_12,
                                                                  color: AppColors
                                                                      .saleRedColor),
                                                            ),
                                                            2.height,
                                                            Text(
                                                              'Price : ${state.productSupplierList[index].supplierSales[subIndex].salePrice.toStringAsFixed(AppConstants.amountFrLength)}${AppLocalizations.of(context)!.currency}(${state.productSupplierList[index].supplierSales[subIndex].saleDiscount.toStringAsFixed(0)}%)',
                                                              style: AppStyles.rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .font_14,
                                                                  color: AppColors
                                                                      .blackColor),
                                                            ),
                                                            2.height,
                                                            GestureDetector(
                                                                onTap: () {
                                                                  showConditionDialog(
                                                                      context:
                                                                          context,
                                                                      saleCondition:
                                                                          '${state.productSupplierList[index].supplierSales[subIndex].saleDescription}');
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
                    ),
              crossFadeState: state.isSelectSupplier
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300));
        },
      ),
    );
  }

  void showConditionDialog(
      {required BuildContext context, required String saleCondition}) {
    showDialog(
        context: context,
        builder: (context) => CommonSaleDescriptionDialog(
            title: saleCondition,
            onTap: () {
              Navigator.pop(context);
            },
            buttonTitle: "OK"));
  }
}
