import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/bloc/planogram_product/planogram_product_bloc.dart';
import 'package:food_stock/data/model/res_model/planogram_res_model/planogram_res_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
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

class PlanogramProductRoute {
  static Widget get route => const PlanogramProductScreen();
}

class PlanogramProductScreen extends StatelessWidget {
  const PlanogramProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => PlanogramProductBloc()
        ..add(PlanogramProductEvent.getPlanogramProductsEvent(
            planogram:
                args?[AppStrings.planogramProductsParamString] ?? Datum())),
      child: PlanogramProductScreenWidget(),
    );
  }
}

class PlanogramProductScreenWidget extends StatelessWidget {
  const PlanogramProductScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: state.planogramName,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: GridView.builder(
            itemCount: state.planogramProductList.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 9 / 11),
            itemBuilder: (context, index) => buildPlanoGramProductItem(
                context: context,
                index: index,
                isRTL: isRTLContent(context: context)),
          )),
        );
      },
    );
  }

  Widget buildPlanoGramProductItem(
      {required BuildContext context,
      required int index,
      required bool isRTL}) {
    return BlocProvider.value(
      value: context.read<PlanogramProductBloc>(),
      child: BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
        builder: (context1, state) {
          return Container(
            // height: 170,
            // width: 140,
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
                    "${AppUrls.baseFileUrl}${state.planogramProductList[index]
                        .mainImage}",
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
                  "${state.planogramProductList[index].productName}",
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_12,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                5.height,
                Expanded(
                  child: state.planogramProductList[index].totalSale == 0
                      ? 0.width
                      : Text(
                    "${state.planogramProductList[index]
                        .totalSale} ${AppLocalizations.of(context)!.discount}",
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
                    "${state.planogramProductList[index].productPrice
                        ?.toStringAsFixed(0)}${AppLocalizations.of(context)!
                        .currency}",
                    onPressed: () {
                      showProductDetails(
                          context: context,
                          productId:
                              state.planogramProductList[index].id ?? '');
                    },
                    textColor: AppColors.whiteColor,
                    bgColor: AppColors.mainColor,
                    borderRadius: AppConstants.radius_3,
                    textSize: AppConstants.font_12,
                  ),
                )
                // Center(
                //   child: Container(
                //     height: AppConstants.buttonHeightSmall,
                //     width: double.maxFinite,
                //     margin: EdgeInsets.symmetric(
                //         horizontal: AppConstants.padding_10),
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //         color: AppColors.mainColor,
                //         borderRadius: BorderRadius.all(
                //             Radius.circular(AppConstants.radius_3))),
                //     padding: EdgeInsets.symmetric(
                //         vertical: AppConstants.padding_5,
                //         horizontal: AppConstants.padding_10),
                //     child: Text(
                //       "${state.planogramProductList[index].productPrice?.toStringAsFixed(0)}${AppLocalizations.of(context)!.currency}",
                //       style: AppStyles.rkRegularTextStyle(
                //           size: AppConstants.font_12,
                //           fontWeight: FontWeight.bold,
                //           color: AppColors.whiteColor),
                //     ),
                //   ),
                // )
              ],
            ),
          );
        },
      ),
    );
  }
  void showProductDetails(
      {required BuildContext context, required String productId}) async {
    context.read<PlanogramProductBloc>().add(
        PlanogramProductEvent.getProductDetailsEvent(
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
          value: context.read<PlanogramProductBloc>(),
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
                  value: context.read<PlanogramProductBloc>(),
                  child:
                      BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
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
                                      state.productDetails.first.mainImage ??
                                          '',
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
                                  productPrice: state
                                          .productStockList[
                                              state.productStockUpdateIndex]
                                          .totalPrice *
                                      state.productStockList[state.productStockUpdateIndex].quantity,
                                  productScaleType: state.productDetails.first.scales?.scaleType ?? '',
                                  productWeight: state.productDetails.first.itemsWeight?.toDouble() ?? 0.0,
                                  supplierWidget: buildSupplierSelection(context: context),
                                  productStock: state.productStockList[state.productStockUpdateIndex].stock,
                                  isRTL: isRTLContent(context: context),
                                  scrollController: scrollController,
                                  productQuantity: state.productStockList[state.productStockUpdateIndex].quantity,
                                  onQuantityIncreaseTap: () {
                                    context.read<PlanogramProductBloc>().add(
                                        PlanogramProductEvent
                                            .increaseQuantityOfProduct(
                                                context: context1));
                                  },
                                  onQuantityDecreaseTap: () {
                                    context.read<PlanogramProductBloc>().add(
                                        PlanogramProductEvent
                                            .decreaseQuantityOfProduct(
                                                context: context1));
                                  },
                                  noteController: TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note)..selection = TextSelection.fromPosition(TextPosition(offset: state.productStockList[state.productStockUpdateIndex].note.length)),
                                  onNoteChanged: (newNote) {
                                    context.read<PlanogramProductBloc>().add(
                                        PlanogramProductEvent
                                            .changeNoteOfProduct(
                                                newNote: newNote));
                                  },
                                  isLoading: state.isLoading,
                                  onAddToOrderPressed: state.isLoading
                                      ? null
                                      : () {
                                          context
                                              .read<PlanogramProductBloc>()
                                              .add(PlanogramProductEvent
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
      value: context.read<PlanogramProductBloc>(),
      child: BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
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
                          context.read<PlanogramProductBloc>().add(
                              PlanogramProductEvent
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
                              context.read<PlanogramProductBloc>().add(
                                  PlanogramProductEvent
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
                                                      'Price : ${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex == -2).basePrice.toStringAsFixed(2)}${AppLocalizations.of(context)!.currency}'),
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
                                                      '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].saleName}'),
                                                  2.height,
                                                  Text(
                                                      'Price : ${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].salePrice.toStringAsFixed(2)}${AppLocalizations.of(context)!.currency}(${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].saleDiscount}%)'),
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
                        'Suppliers not available',
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
                                  context.read<PlanogramProductBloc>().add(
                                      PlanogramProductEvent
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
                                                                PlanogramProductBloc>()
                                                            .add(PlanogramProductEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    supplierSaleIndex:
                                                                        -2));
                                                        context
                                                            .read<
                                                                PlanogramProductBloc>()
                                                            .add(PlanogramProductEvent
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
                                                              'Price : ${state.productSupplierList[index].basePrice.toStringAsFixed(2)}${AppLocalizations.of(context)!.currency}',
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
                                                                PlanogramProductBloc>()
                                                            .add(PlanogramProductEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    supplierSaleIndex:
                                                                        subIndex));
                                                        context
                                                            .read<
                                                                PlanogramProductBloc>()
                                                            .add(PlanogramProductEvent
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
                                                              'Price : ${state.productSupplierList[index].supplierSales[subIndex].salePrice.toStringAsFixed(2)}${AppLocalizations.of(context)!.currency}(${state.productSupplierList[index].supplierSales[subIndex].saleDiscount}%)',
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
