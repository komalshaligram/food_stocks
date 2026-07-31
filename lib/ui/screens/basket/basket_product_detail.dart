import 'dart:io';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants/app_styles.dart';
import '../../utils/constants/app_urls.dart';
import '../../widget/common_product_details_widget.dart';
import '../../widget/common_product_sale_item_widget.dart';
import '../../widget/product_details_shimmer_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import '../../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../../widget/no_data_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/basket/basket_bloc.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../utils/constants/app_strings.dart';

void showProductDetails({
  required BuildContext context,
  bool isBarcode = false,
  String productStock = '0',
  int productListIndex = 0,
  required bool isSaleOn,
  required String cartProductId,
  String? clubAgentId,
}) async {
  context
      .read<BasketBloc>()
      .add(BasketEvent.getProductDetailsEvent(context: context, productId: cartProductId, isBarcode: isBarcode, productListIndex: productListIndex));
  showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radius_10))),
      isDismissible: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: false,
      builder: (modalContext) {
        return BlocProvider.value(
          value: context.read<BasketBloc>(),
          child: SafeArea(
            bottom: false,
            child: DraggableScrollableSheet(
                shouldCloseOnMinExtent: false,
                expand: true,
                maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
                minChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
                initialChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
                builder: (BuildContext sheetContext, ScrollController scrollController) {
                  return BlocBuilder<BasketBloc, BasketState>(builder: (blocContext, state) {
                    return AbsorbPointer(
                      absorbing: state.isLoading ? true : false,
                      child: Container(
                        height: getScreenHeight(sheetContext),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                            color: AppColors.whiteColor),
                        child: state.isProductLoading
                            ? const ProductDetailsShimmerWidget()
                            : state.productDetails.isEmpty
                                ? NoDataBottomSheet(dialogContext: context)
                                : SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: ModalScrollController.of(sheetContext),
                                    child: Column(children: [
                                      CommonProductDetailsWidget(
                                          isFromBasketScreen: true,
                                          isIncludedVat: state.isIncludedVat,
                                          productDetails: state.productDetails,
                                          isSubUserAddToBasket: state.isSubUserAddToBasket,
                                          bottleTax: state.bottleTax,
                                          totalBottleDeposit: (state.bottleTax *
                                              (state.productDetails.first.numberOfUnit ?? 1).toDouble() *
                                              state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                          isBottle: (state.productDetails.first.isBottle ?? false),
                                          addToOrderTap: () {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            context
                                                .read<BasketBloc>()
                                                .add(BasketEvent.addToCartProductEvent(context: sheetContext, productId: cartProductId));
                                          },
                                          isLoading: state.isLoading,
                                          imageOnTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Stack(children: [
                                                    SizedBox(
                                                      height: getScreenHeight(context) - MediaQuery.of(context).padding.top,
                                                      width: getScreenWidth(context),
                                                      child: GestureDetector(
                                                        onVerticalDragStart: (dragDetails) {},
                                                        onVerticalDragUpdate: (dragDetails) {},
                                                        onVerticalDragEnd: (endDetails) {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: PhotoView(
                                                          imageProvider: NetworkImage(
                                                              '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.productImageIndex].mainImage}'),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(dialogContext);
                                                      },
                                                      child: Padding(
                                                          padding: const EdgeInsets.only(top: AppConstants.padding_10),
                                                          child: Icon(Icons.close, color: AppColors.whiteColor)),
                                                    ),
                                                  ]);
                                                });
                                          },
                                          context: context,
                                          productImages: [state.productDetails.first.mainImage ?? ''],
                                          productUnitPrice:
                                              double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'),
                                          scaleType: state.productDetails.first.scaleType,
                                          productPrice: (state.productDetails.first.sale?.isSale ?? false)
                                              ? double.parse(state.productDetails.first.sale?.salePrice ?? '') *
                                                  state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity *
                                                  (state.productDetails.first.numberOfUnit ?? 1)
                                              : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice *
                                                  state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity *
                                                  (state.productDetails.first.numberOfUnit ?? 1),
                                          productStock:
                                              (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                          scrollController: scrollController,
                                          productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                          isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                          recommendedRetailConsumerPricerOffer: clubAgentId == AppStrings.clubAgentIdText
                                              ? state.productDetails.first.sale?.isSale == true
                                                  ? state.productDetails.first.recommendedConsumerOffer
                                                  : state.productDetails.first.recommendedRetailPrice
                                              : '',
                                          onQuantityChanged: (quantity) {
                                            context
                                                .read<BasketBloc>()
                                                .add(BasketEvent.updateQuantityOfProduct(context: sheetContext, quantity: quantity));
                                          },
                                          onQuantityIncreaseTap: () {
                                            context.read<BasketBloc>().add(BasketEvent.increaseQuantityOfProduct(context: sheetContext));
                                          },
                                          onQuantityDecreaseTap: () {
                                            if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                              context.read<BasketBloc>().add(BasketEvent.decreaseQuantityOfProduct(context: sheetContext));
                                            }
                                          },
                                          onCloseTap: () {
                                            context.read<BasketBloc>().add(BasketEvent.getAllCartEvent(context: context, isFromUpdate: false));
                                            Navigator.pop(context);
                                          }),
                                      state.isRelatedShimmering
                                          ? const RelatedProductShimmerWidget()
                                          : state.relatedProductList.isEmpty
                                              ? 0.height
                                              : relatedProductWidget(context, state, sheetContext, isSaleOn)
                                    ]),
                                  ),
                      ),
                    );
                  });
                }),
          ),
        );
      });
}

Widget relatedProductWidget(BuildContext prevContext, BasketState state, BuildContext context, bool isSaleOn) {
  return AbsorbPointer(
    absorbing: state.isLoading,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
      Align(
        alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: AppConstants.padding_8, right: AppConstants.padding_8),
          child: Text(AppLocalizations.of(context)!.related_products,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.blackColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center),
        ),
      ),
      Container(
        height: getItemHeight(context, isSaleOn),
        padding: const EdgeInsets.only(bottom: AppConstants.padding_10, left: AppConstants.padding_10, right: AppConstants.padding_10),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context2, i) {
              return CommonProductSaleItemWidget(
                  isSale: state.relatedProductList.elementAt(i).sale?.isSale,
                  isGuestUser: false,
                  height: AppConstants.salesProductItemHeight,
                  width: getItemWidth(context),
                  productName: state.relatedProductList.elementAt(i).productName ?? '',
                  saleImage: state.relatedProductList.elementAt(i).mainImage ?? '',
                  title: state.relatedProductList.elementAt(i).name,
                  description: parse(state.relatedProductList.elementAt(i).sale?.saleDescription).body?.text ?? '',
                  discountedPrice: double.parse(state.relatedProductList.elementAt(i).sale?.salePrice ?? '0'),
                  originalPrice: state.relatedProductList.elementAt(i).productPrice,
                  productStock: state.relatedProductList.elementAt(i).productStock.toString(),
                  lowStock: state.relatedProductList.elementAt(i).lowStock ?? '',
                  isPesach: state.relatedProductList.elementAt(i).isPesach,
                  quantity: state.productStockList[1].firstWhere((test) => test.productId == state.relatedProductList.elementAt(i).id).quantity,
                  isMixedSale: state.relatedProductList.elementAt(i).sale?.isMixedSale,
                  numberOfUnits: state.relatedProductList.elementAt(i).numberOfUnit.toString(),
                  scaleType: state.relatedProductList.elementAt(i).scaleType,
                  onQuantityChanged: () {
                    context2.read<BasketBloc>().add(BasketEvent.updateListQuantityOfProduct(
                        context: context2,
                        quantity: state.productStockList[1]
                            .firstWhere((test) => test.productId == state.relatedProductList.elementAt(i).id)
                            .quantity
                            .toString(),
                        productListIndex: 1,
                        productStockUpdateIndex:
                            state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                        productSupplierIds: state.relatedProductList[i].supplierId.toString()));
                  },
                  onQuantityIncreaseTap: () {
                    context2.read<BasketBloc>().add(BasketEvent.increaseListQuantityOfProduct(
                        context: context2,
                        productListIndex: 1,
                        productStockUpdateIndex:
                            state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                        productSupplierIds: state.relatedProductList[i].supplierId.toString()));

                    context2.read<BasketBloc>().add(BasketEvent.addToCartListProductEvent(
                        context: context2,
                        productId: state.relatedProductList[i].id.toString(),
                        productListIndex: 1,
                        productStockUpdateIndex:
                            state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                        productSupplierIds: state.relatedProductList[i].supplierId.toString()));
                  },
                  onQuantityDecreaseTap: () {
                    if (state.productStockList[1].firstWhere((test) => test.productId == state.relatedProductList.elementAt(i).id).quantity != 0) {
                      context2.read<BasketBloc>().add(BasketEvent.decreaseListQuantityOfProduct(
                          context: context2,
                          productListIndex: 1,
                          productStockUpdateIndex:
                              state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                          productSupplierIds: state.relatedProductList[i].supplierId.toString()));

                      context2.read<BasketBloc>().add(BasketEvent.addToCartListProductEvent(
                          context: context2,
                          productId: state.relatedProductList[i].id.toString(),
                          productListIndex: 1,
                          productStockUpdateIndex:
                              state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                          productSupplierIds: state.relatedProductList[i].supplierId.toString()));
                    }
                  },
                  onButtonTap: () {
                    Navigator.pop(prevContext);
                    showProductDetails(
                        isSaleOn: isSaleOn,
                        context: Platform.isIOS ? (state.context ?? context) : context,
                        cartProductId: state.relatedProductList[i].id ?? '',
                        isBarcode: false,
                        productStock: state.relatedProductList[i].productStock.toString(),
                        productListIndex: 1,
                        clubAgentId: state.clubAgentId!);
                  });
            },
            itemCount: state.relatedProductList.length),
      )
    ]),
  );
}
