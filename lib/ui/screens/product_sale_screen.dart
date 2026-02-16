import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/product_sale/product_sale_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/widget/common_product_sale_item_widget.dart';
import '../../ui/widget/common_sale_description_dialog.dart';
import '../../ui/widget/common_sale_listview.dart';
import '../../ui/widget/product_sale_screen_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../ui/widget/store_category_screen_subcategory_shimmer_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/custom_dialog.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class ProductSaleRoute {
  static Widget get route => const ProductSaleScreen();
}

class ProductSaleScreen extends StatelessWidget {
  const ProductSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => ProductSaleBloc()
        ..add(ProductSaleEvent.setSearchEvent(search: args?[AppStrings.searchString] ?? ''))
        ..add(ProductSaleEvent.getProductSalesListEvent(context: context))
        ..add(ProductSaleEvent.userApproveEvent(context: context)),
      child: ProductSaleScreenWidget(saleProductId: args?[AppStrings.companyIdString] ?? ''),
    );
  }
}

class ProductSaleScreenWidget extends StatelessWidget {
  final String saleProductId;
  const ProductSaleScreenWidget({super.key, this.saleProductId = ''});

  @override
  Widget build(BuildContext context) {
    ProductSaleBloc bloc = context.read<ProductSaleBloc>();
    return BlocListener<ProductSaleBloc, ProductSaleState>(
      listener: (context, state) {},
      child: BlocBuilder<ProductSaleBloc, ProductSaleState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.sales,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                trailingWidget: GestureDetector(
                    onTap: () {
                      context.read<ProductSaleBloc>().add(const ProductSaleEvent.getGridListView());
                    },
                    child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
              ),
            ),
            body: FocusDetector(
              onFocusGained: () {
                if (saleProductId != '') {
                  showProductDetails(context: context, productId: saleProductId, productStock: '1', isBarcode: true, productListIndex: 0);
                }
              },
              child: SafeArea(
                child: NotificationListener<ScrollNotification>(
                  child: SmartRefresher(
                    enablePullDown: true,
                    controller: state.refreshController,
                    header: const RefreshWidget(),
                    footer: CustomFooter(
                      builder: (context, mode) => const ProductSaleScreenShimmerWidget(),
                    ),
                    enablePullUp: !state.isBottomOfProducts,
                    onRefresh: () {
                      context.read<ProductSaleBloc>().add(ProductSaleEvent.refreshListEvent(context: context));
                    },
                    /*    onLoading: () {
                      context.read<ProductSaleBloc>().add(ProductSaleEvent.getProductSalesListEvent(context: context));
                                        },*/
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          state.isShimmering
                              ? state.isGridView
                                  ? const ProductSaleScreenShimmerWidget()
                                  : StoreCategoryScreenSubcategoryShimmerWidget()
                              : state.productSalesList.isEmpty
                                  ? Container(
                                      height: getScreenHeight(context) - 80,
                                      width: getScreenWidth(context),
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context)!.currently_products_are_not_on_sale,
                                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor),
                                      ),
                                    )
                                  : state.isGridView
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.productSalesList.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: getScreenHeight(context) > 1000 && getScreenWidth(context) > 700
                                                ? 0.70
                                                : getScreenHeight(context) > 850 && getScreenHeight(context) < 1000 && getScreenWidth(context) > 550
                                                    ? 0.67
                                                    : 0.42,
                                          ),
                                          //getChildAspectRatio(context)),
                                          itemBuilder: (context, index) {
                                            return buildProductSaleGridViewItem(
                                              productStock: state.productSalesList[index].productStock.toString(),
                                              isPesach: state.productSalesList[index].isPesach ?? false,
                                              lowStock: state.productSalesList[index].lowStock ?? '',
                                              originalPrice: state.productSalesList[index].productPrice ?? 0.0,
                                              isGuestUser: state.isGuestUser,
                                              index: index,
                                              context: context,
                                              saleImage: state.productSalesList[index].mainImage ?? '',
                                              title: state.productSalesList[index].name,
                                              productName: state.productSalesList[index].productName ?? '',
                                              description: parse(state.productSalesList[index].sale?.saleDescription ?? '').body?.text ?? '',
                                              discountedPrice: double.parse(state.productSalesList[index].sale?.salePrice ?? ''),
                                              quantity: state.productStockList[1][index].quantity,
                                              minQuantity: state.productSalesList[index].sale?.saleMinQuantity,
                                              maxQuantity: state.productSalesList[index].sale?.saleMaxQuantity,
                                              isMixedSale: state.productSalesList[index].sale?.isMixedSale,
                                              onQuantityChanged: () {
                                                context.read<ProductSaleBloc>().add(
                                                      ProductSaleEvent.updateListQuantityOfProduct(
                                                        context: context,
                                                        quantity: state.productStockList[1][index].quantity.toString(),
                                                        productListIndex: 1,
                                                        productStockUpdateIndex: index,
                                                        productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                      ),
                                                    );
                                              },
                                              onQuantityIncreaseTap: () {
                                                if (int.parse(state.productSalesList[index].sale?.saleMinQuantity ?? '0')
                                                    <= state.productStockList[1][index].quantity + 1) {
                                                  context.read<ProductSaleBloc>().add(
                                                        ProductSaleEvent.increaseListQuantityOfProduct(
                                                          context: context,
                                                          productListIndex: 1,
                                                          productStockUpdateIndex: index,
                                                          productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                        ),
                                                      );

                                                  context.read<ProductSaleBloc>().add(
                                                        ProductSaleEvent.addToCartListProductEvent(
                                                          context: context,
                                                          productId: state.productSalesList[index].id.toString(),
                                                          productListIndex: 1,
                                                          productStockUpdateIndex: index,
                                                          productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                        ),
                                                      );
                                                } else {
                                                  showMinMaxIncreaseQtyConfirmDialog(
                                                    context,
                                                    state.productSalesList[index].id.toString(),
                                                    state.productSalesList[index].sale?.saleMinQuantity.toString() ?? '0',
                                                    index,
                                                    state.productSalesList[index].supplierId.toString(),
                                                    1,
                                                    state.productSalesList[index].sale?.isMixedSale,
                                                    state.productSalesList[index].sale?.sameSaleProducts,
                                                  );
                                                }
                                              },
                                              onQuantityDecreaseTap: () {
                                                if (state.productStockList[1][index].quantity != 0) {
                                                  if (int.parse(state.productSalesList[index].sale?.saleMinQuantity ?? '0')
                                                      <= state.productStockList[1][index].quantity - 1) {
                                                    context.read<ProductSaleBloc>().add(
                                                          ProductSaleEvent.decreaseListQuantityOfProduct(
                                                            context: context,
                                                            productListIndex: 1,
                                                            productStockUpdateIndex: index,
                                                            productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                          ),
                                                        );

                                                    context.read<ProductSaleBloc>().add(
                                                          ProductSaleEvent.addToCartListProductEvent(
                                                            context: context,
                                                            productId: state.productSalesList[index].id.toString(),
                                                            productListIndex: 1,
                                                            productStockUpdateIndex: index,
                                                            productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                          ),
                                                        );
                                                  } else {
                                                    showMinMaxDecreaseQtyConfirmDialog(
                                                      context,
                                                      state.productSalesList[index].id.toString(),
                                                      state.productSalesList[index].sale?.saleMinQuantity.toString() ?? '0',
                                                      index,
                                                      state.productSalesList[index].supplierId.toString(),
                                                      1,
                                                      state.productSalesList[index].sale?.isMixedSale,
                                                      state.productSalesList[index].sale?.sameSaleProducts,
                                                    );
                                                  }
                                                }
                                              },
                                              onButtonTap: () {
                                                if (!state.isGuestUser) {
                                                  showProductDetails(
                                                    context: context,
                                                    productId: state.productSalesList[index].id ?? '',
                                                    productStock: state.productSalesList[index].productStock.toString(),
                                                    productListIndex: 1,
                                                  );
                                                } else {
                                                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                }
                                              },
                                            );
                                          },
                                        )
                                      : ListView.builder(
                                          itemCount: state.productSalesList.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                                          itemBuilder: (context, index) => CommonSaleListView(
                                              context: context,
                                              discountedPrice: double.parse(state.productSalesList[index].sale?.salePrice ?? ''),
                                              isFromSale: state.productSalesList[index].sale?.isSale ?? false,
                                              salesDesc: state.productSalesList[index].sale?.saleDescription ?? '',
                                              isGuestUser: state.isGuestUser,
                                              isPesach: state.productSalesList[index].isPesach,
                                              numberOfUnits: state.productSalesList[index].numberOfUnit.toString(),
                                              lowStock: state.productSalesList[index].lowStock.toString(),
                                              productStock: state.productSalesList[index].productStock.toString(),
                                              productImage: state.productSalesList[index].mainImage ?? '',
                                              productName: state.productSalesList[index].productName ?? '',
                                              price: double.parse(state.productSalesList[index].productPrice.toString()),
                                              quantity: state.productStockList[1][index].quantity,
                                              minQuantity: state.productSalesList[index].sale?.saleMinQuantity,
                                              maxQuantity: state.productSalesList[index].sale?.saleMaxQuantity,
                                              isMixedSale: state.productSalesList[index].sale?.isMixedSale,
                                              onQuantityChanged: () {
                                                context.read<ProductSaleBloc>().add(
                                                      ProductSaleEvent.updateListQuantityOfProduct(
                                                        context: context,
                                                        quantity: state.productStockList[1][index].quantity.toString(),
                                                        productListIndex: 1,
                                                        productStockUpdateIndex: index,
                                                        productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                      ),
                                                    );
                                              },
                                              onQuantityIncreaseTap: () {
                                                if (int.parse(state.productSalesList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity + 1) {
                                                  context.read<ProductSaleBloc>().add(
                                                        ProductSaleEvent.increaseListQuantityOfProduct(
                                                          context: context,
                                                          productListIndex: 1,
                                                          productStockUpdateIndex: index,
                                                          productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                        ),
                                                      );

                                                  context.read<ProductSaleBloc>().add(
                                                        ProductSaleEvent.addToCartListProductEvent(
                                                          context: context,
                                                          productId: state.productSalesList[index].id.toString(),
                                                          productListIndex: 1,
                                                          productStockUpdateIndex: index,
                                                          productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                        ),
                                                      );
                                                } else {
                                                  showMinMaxIncreaseQtyConfirmDialog(
                                                    context,
                                                    state.productSalesList[index].id.toString(),
                                                    state.productSalesList[index].sale?.saleMinQuantity.toString() ?? '0',
                                                    index,
                                                    state.productSalesList[index].supplierId.toString(),
                                                    1,
                                                    state.productSalesList[index].sale?.isMixedSale,
                                                    state.productSalesList[index].sale?.sameSaleProducts,
                                                  );
                                                }
                                              },
                                              onQuantityDecreaseTap: () {
                                                if (state.productStockList[1][index].quantity != 0) {
                                                  if (int.parse(state.productSalesList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity - 1) {
                                                    context.read<ProductSaleBloc>().add(
                                                          ProductSaleEvent.decreaseListQuantityOfProduct(
                                                            context: context,
                                                            productListIndex: 1,
                                                            productStockUpdateIndex: index,
                                                            productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                          ),
                                                        );

                                                    context.read<ProductSaleBloc>().add(
                                                          ProductSaleEvent.addToCartListProductEvent(
                                                            context: context,
                                                            productId: state.productSalesList[index].id.toString(),
                                                            productListIndex: 1,
                                                            productStockUpdateIndex: index,
                                                            productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                                          ),
                                                        );
                                                  } else {
                                                    showMinMaxDecreaseQtyConfirmDialog(
                                                      context,
                                                      state.productSalesList[index].id.toString(),
                                                      state.productSalesList[index].sale?.saleMinQuantity.toString() ?? '0',
                                                      index,
                                                      state.productSalesList[index].supplierId.toString(),
                                                      1,
                                                      state.productSalesList[index].sale?.isMixedSale,
                                                      state.productSalesList[index].sale?.sameSaleProducts,
                                                    );
                                                  }
                                                }
                                              },
                                              onButtonTap: () {
                                                showProductDetails(
                                                  context: context,
                                                  productId: state.productSalesList[index].id ?? '',
                                                  productStock: state.productSalesList[index].toString(),
                                                  productListIndex: 1,
                                                );

                                                // bloc.add(ProductSaleEvent.getProductSalesListEvent(context: context));
                                              }),
                                        ),
                        ],
                      ),
                    ),
                  ),
                  onNotification: (notification) {
                    if (notification.metrics.pixels > (notification.metrics.maxScrollExtent - 400)) {
                      if (!state.isBottomOfProducts) {
                        context.read<ProductSaleBloc>().add(ProductSaleEvent.getProductSalesListEvent(context: context));
                      } else {
                        return false;
                      }
                    }
                    return true;
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProductSaleGridViewItem({
    required int index,
    required BuildContext context,
    required String saleImage,
    required String title,
    required String description,
    required String productName,
    required double discountedPrice,
    required void Function() onButtonTap,
    required bool isGuestUser,
    required double originalPrice,
    required bool isPesach,
    required String lowStock,
    required String productStock,
    required int quantity,
    required void Function() onQuantityChanged,
    required void Function() onQuantityIncreaseTap,
    required void Function() onQuantityDecreaseTap,
    String? minQuantity,
    String? maxQuantity,
    required bool? isMixedSale,
  }) {
    return CommonProductSaleItemWidget(
      isSale: true,
      height: AppConstants.salesProductItemHeight,
      width: 140,
      isGuestUser: isGuestUser,
      saleImage: saleImage,
      title: title,
      description: description,
      onButtonTap: onButtonTap,
      productName: productName,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      isPesach: isPesach,
      lowStock: lowStock,
      productStock: productStock,
      quantity: quantity,
      onQuantityChanged: onQuantityChanged,
      onQuantityIncreaseTap: onQuantityIncreaseTap,
      onQuantityDecreaseTap: onQuantityDecreaseTap,
      minQuantity: minQuantity,
      maxQuantity: maxQuantity,
        isMixedSale : isMixedSale,
    );
  }

  void showProductDetails({
    required BuildContext context,
    required String productId,
    String productStock = '0',
    bool isBarcode = false,
    required int productListIndex,
  }) async {
    context.read<ProductSaleBloc>().add(
          ProductSaleEvent.getProductDetailsEvent(
            context: context,
            productId: productId,
            isBarcode: isBarcode,
            productListIndex: productListIndex,
          ),
        );
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      clipBehavior: Clip.hardEdge,
      enableDrag: false,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<ProductSaleBloc>(),
          child: BlocBuilder<ProductSaleBloc, ProductSaleState>(
            builder: (blocContext, state) {
              return SafeArea(
                bottom: false,
                child: DraggableScrollableSheet(
                  expand: true,
                  maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                  minChildSize: productStock == '0' || productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                  initialChildSize: productStock == '0' || productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                  builder: (BuildContext context1, ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppConstants.radius_30),
                          topRight: Radius.circular(AppConstants.radius_30),
                        ),
                        color: AppColors.whiteColor,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: state.isProductLoading
                          ? const ProductDetailsShimmerWidget()
                          : SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: Column(
                                children: [
                                  CommonProductDetailsWidget(
                                    isIncludedVat: state.isIncludedVat,
                                    productDetails: state.productDetails,
                                    isSubUserAddToBasket: state.isSubUserAddToBasket,
                                    bottleTax: state.bottleDeposit,
                                    totalBottleDeposit: (state.bottleDeposit * (state.productDetails.first.numberOfUnit ?? 1).toDouble() * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                    isBottle: (state.productDetails.first.isBottle ?? false),
                                    isLoading: state.isLoading,
                                    addToOrderTap: () {
                                      if (int.parse(state.productDetails.first.sale!.saleMinQuantity!) <= state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
                                        context.read<ProductSaleBloc>().add(ProductSaleEvent.addToCartProductEvent(context: context1, productId: productId));
                                      } else {
                                        showMinQtyConfirmDialog(context, productId, state.productDetails.first.sale!.saleMinQuantity.toString(),
                                          state.productDetails.first.sale!.isMixedSale,
                                          state.productDetails.first.sale!.sameSaleProducts,);
                                      }
                                      // context.read<ProductSaleBloc>().add(ProductSaleEvent.addToCartProductEvent(context: context1, productId: productId));
                                    },
                                    imageOnTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SafeArea(
                                            bottom: false,
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: getScreenHeight(context) - MediaQuery.of(context).padding.top,
                                                  width: getScreenWidth(context),
                                                  child: GestureDetector(
                                                    onVerticalDragStart: (dragDetails) {},
                                                    onVerticalDragUpdate: (dragDetails) {},
                                                    onVerticalDragEnd: (endDetails) {
                                                      Navigator.pop(context);
                                                    },
                                                    child: PhotoView(
                                                      imageProvider: NetworkImage(
                                                        '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(top: AppConstants.padding_10),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    context: context,
                                    productUnitPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                                    productImages: [state.productDetails.first.mainImage ?? ''],
                                    productPrice: (state.productDetails.first.sale?.isSale ?? false) ? double.parse(state.productDetails.first.sale?.salePrice ?? '') * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1) : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 0),
                                    productStock: state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString(),
                                    scrollController: scrollController,
                                    productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                    isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                    onQuantityChanged: (quantity) {
                                      context.read<ProductSaleBloc>().add(ProductSaleEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                    },
                                    onQuantityIncreaseTap: () {
                                      context.read<ProductSaleBloc>().add(ProductSaleEvent.increaseQuantityOfProduct(context: context1));
                                    },
                                    onQuantityDecreaseTap: () {
                                      if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                        context.read<ProductSaleBloc>().add(ProductSaleEvent.decreaseQuantityOfProduct(context: context1));
                                      }
                                    },
                                    onCloseTap: () {
                                      context.read<ProductSaleBloc>().add(ProductSaleEvent.getProductSalesListEvent(
                                            context: context1,
                                          ));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  state.isRelatedShimmering
                                      ? const RelatedProductShimmerWidget()
                                      : state.relatedProductList.isEmpty
                                          ? 0.width
                                          : relatedProductWidget(
                                              context1,
                                              state.relatedProductList,
                                              context,
                                              productStockList: state.productStockList,
                                            )
                                ],
                              ),
                            ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget relatedProductWidget(
    BuildContext prevContext,
    List<RelatedProductDatum> relatedProductList,
    BuildContext context, {
    required List<List<ProductStockModel>> productStockList,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8),
            child: Text(
              AppLocalizations.of(context)!.related_products,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.blackColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          height: getItemHeight(context, true),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2, i) {
              return CommonProductSaleItemWidget(
                isSale: relatedProductList.elementAt(i).sale?.isSale,
                isGuestUser: false,
                height: AppConstants.salesProductItemHeight,
                width: getItemWidth(context),
                productName: relatedProductList.elementAt(i).productName ?? '',
                saleImage: relatedProductList.elementAt(i).mainImage ?? '',
                title: relatedProductList.elementAt(i).name,
                description: parse(relatedProductList.elementAt(i).sale?.saleDescription).body?.text ?? '',
                discountedPrice: double.parse(relatedProductList.elementAt(i).sale?.salePrice ?? '0'),
                originalPrice: relatedProductList.elementAt(i).productPrice,
                productStock: relatedProductList.elementAt(i).productStock.toString(),
                lowStock: relatedProductList.elementAt(i).lowStock ?? '',
                isPesach: relatedProductList.elementAt(i).isPesach,
                quantity: productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity, //[i].quantity,
                minQuantity: relatedProductList.elementAt(i).sale?.saleMinQuantity,
                maxQuantity: relatedProductList.elementAt(i).sale?.saleMaxQuantity,
                isMixedSale: relatedProductList.elementAt(i).sale?.isMixedSale,
                onQuantityChanged: () {
                  context.read<ProductSaleBloc>().add(
                        ProductSaleEvent.updateListQuantityOfProduct(
                          context: context,
                          quantity: productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity.toString(),
                          productListIndex: 2,
                          productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString(),
                        ),
                      );
                },
                onQuantityIncreaseTap: () {
                  if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0')
                      <= productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity + 1) {
                    context.read<ProductSaleBloc>().add(
                          ProductSaleEvent.increaseListQuantityOfProduct(
                            context: context,
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString(),
                          ),
                        );

                    context.read<ProductSaleBloc>().add(
                          ProductSaleEvent.addToCartListProductEvent(
                            context: context,
                            productId: relatedProductList[i].id.toString(),
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString(),
                          ),
                        );
                  } else {
                    showMinMaxIncreaseQtyConfirmDialog(
                      context,
                      relatedProductList[i].id.toString(),
                      relatedProductList.elementAt(i).sale?.saleMinQuantity.toString() ?? '0',
                        productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                      relatedProductList[i].supplierId.toString(),
                      2,
                      relatedProductList[i].sale?.isMixedSale,
                      relatedProductList[i].sale?.sameSaleProducts,
                    );
                  }
                },
                onQuantityDecreaseTap: () {
                  if (productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity != 0) {
                    if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <=
                        productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity - 1) {
                      context.read<ProductSaleBloc>().add(
                            ProductSaleEvent.decreaseListQuantityOfProduct(
                              context: context,
                              productListIndex: 2,
                              productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                              productSupplierIds: relatedProductList[i].supplierId.toString(),
                            ),
                          );

                      context.read<ProductSaleBloc>().add(
                            ProductSaleEvent.addToCartListProductEvent(
                              context: context,
                              productId: relatedProductList[i].id.toString(),
                              productListIndex: 2,
                              productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                              productSupplierIds: relatedProductList[i].supplierId.toString(),
                            ),
                          );
                    } else {
                      showMinMaxDecreaseQtyConfirmDialog(
                        context,
                        relatedProductList[i].id.toString(),
                        relatedProductList.elementAt(i).sale?.saleMinQuantity.toString() ?? '0',
                        productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                        relatedProductList[i].supplierId.toString(),
                        2,
                        relatedProductList[i].sale?.isMixedSale,
                        relatedProductList[i].sale?.sameSaleProducts,
                      );
                    }
                  }
                },
                onButtonTap: () {
                  Navigator.of(prevContext).pop();
                  showProductDetails(
                    context: context,
                    productId: relatedProductList[i].id ?? '',
                    productStock: relatedProductList.elementAt(i).productStock.toString(),
                    productListIndex: 2,
                  );
                },
              );
            },
            itemCount: relatedProductList.length,
          ),
        )
      ],
    );
  }

  void showConditionDialog({required BuildContext context, required String saleCondition}) {
    showDialog(
        context: context,
        builder: (context) => CommonSaleDescriptionDialog(
            title: saleCondition,
            onTap: () {
              Navigator.pop(context);
            },
            buttonTitle: AppLocalizations.of(context)!.ok));
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox,bool? isMixedSale,
      List? sameSaleProducts,) {
    ProductSaleBloc bloc = context.read<ProductSaleBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ProductSaleBloc>(),
        child: BlocBuilder<ProductSaleBloc, ProductSaleState>(
          builder: (context1, state) {
            String mixedSale = '';
            if (isMixedSale!) {
              mixedSale = '${AppLocalizations.of(context)?.minimum_box_title}$minBox \n${AppLocalizations.of(context)?.mix_sale_text}\n${AppLocalizations.of(context)?.mixed_sale_other_text}\n${AppLocalizations.of(context)?.sale_other_text} $minBox ${AppLocalizations.of(context)?.sale_other_text1}';
            } else {
              mixedSale = '${AppLocalizations.of(context)?.minimum_box_title}$minBox\n${AppLocalizations.of(context)?.sale_other_text} $minBox ${AppLocalizations.of(context)?.sale_other_text1}';
            }
            return CustomDialog(
              directionality: state.language,
              title: mixedSale,
              content: isMixedSale ? sameSaleProducts! : [],
              isMixedSale : isMixedSale,
              positiveTitle: AppLocalizations.of(context)!.closeText,
              negativeTitle: AppLocalizations.of(context)!.addText,
              negativeOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(ProductSaleEvent.addToCartProductEvent(context: context, productId: productId));
              },
              positiveOnTap: () async {
                Navigator.pop(context);
                bloc.add(ProductSaleEvent.getCartCountEvent(context: context,));

              },
            );
          },
        ),
      ),
    );
  }

  showMinMaxIncreaseQtyConfirmDialog(BuildContext context, String productId, String minBox, int index, supplierId, productListIndex,
      bool? isMixedSale,
      List? sameSaleProducts,) {
    ProductSaleBloc bloc = context.read<ProductSaleBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ProductSaleBloc>(),
        child: BlocBuilder<ProductSaleBloc, ProductSaleState>(
          builder: (context1, state) {
            String mixedSale = '';
            if (isMixedSale!) {
              mixedSale = '${AppLocalizations.of(context)?.minimum_box_title}$minBox \n${AppLocalizations.of(context)?.mix_sale_text}\n${AppLocalizations.of(context)?.mixed_sale_other_text}\n${AppLocalizations.of(context)?.sale_other_text} $minBox ${AppLocalizations.of(context)?.sale_other_text1}';
            } else {
              mixedSale = '${AppLocalizations.of(context)?.minimum_box_title}$minBox\n${AppLocalizations.of(context)?.sale_other_text} $minBox ${AppLocalizations.of(context)?.sale_other_text1}';
            }
            return CustomDialog(
              directionality: state.language,
              title: mixedSale,
              content: isMixedSale ? sameSaleProducts! : [],
              isMixedSale : isMixedSale,
              positiveTitle: AppLocalizations.of(context)!.closeText,
              negativeTitle: AppLocalizations.of(context)!.addText,
              negativeOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(ProductSaleEvent.increaseListQuantityOfProduct(
                  context: context,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));

                bloc.add(ProductSaleEvent.addToCartListProductEvent(
                  context: context,
                  productId: productId,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));

              },
              positiveOnTap: () async {
                Navigator.pop(context);
                // Navigator.pop(dialogContext);
              },
            );
          },
        ),
      ),
    );
  }

  showMinMaxDecreaseQtyConfirmDialog(BuildContext context, String productId, String minBox, int index, supplierId, productListIndex,
      bool? isMixedSale,
      List? sameSaleProducts,) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ProductSaleBloc>(),
        child: BlocBuilder<ProductSaleBloc, ProductSaleState>(
          builder: (context1, state) {
            String mixedSale = '';
            if (isMixedSale!) {
              mixedSale = '${AppLocalizations.of(context)?.minimum_box_title}$minBox \n${AppLocalizations.of(context)?.mix_sale_text}\n${AppLocalizations.of(context)?.mixed_sale_other_text}\n${AppLocalizations.of(context)?.sale_other_text} $minBox ${AppLocalizations.of(context)?.sale_other_text1}';
            } else {
              mixedSale = '${AppLocalizations.of(context)?.minimum_box_title}$minBox\n${AppLocalizations.of(context)?.sale_other_text} $minBox ${AppLocalizations.of(context)?.sale_other_text1}';
            }
            ProductSaleBloc bloc = context.read<ProductSaleBloc>();
            return CustomDialog(
              directionality: state.language,
              title: mixedSale,
              content: isMixedSale ? sameSaleProducts! : [],
              isMixedSale : isMixedSale,
              positiveTitle: AppLocalizations.of(context)!.closeText,
              negativeTitle: AppLocalizations.of(context)!.addText,
              negativeOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(
                  ProductSaleEvent.decreaseListQuantityOfProduct(
                    context: context,
                    productListIndex: productListIndex,
                    productStockUpdateIndex: index,
                    productSupplierIds: supplierId,
                  ),
                );

                bloc.add(
                  ProductSaleEvent.addToCartListProductEvent(
                    context: context,
                    productId: productId,
                    productListIndex: productListIndex,
                    productStockUpdateIndex: index,
                    productSupplierIds: supplierId,
                  ),
                );

              },
              positiveOnTap: () async {
                Navigator.pop(context);
                // Navigator.pop(dialogContext);
              },
            );
          },
        ),
      ),
    );
  }
}
