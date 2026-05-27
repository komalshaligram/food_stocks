import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/widget/related_product_title.dart';
import '../../bloc/product_sale/product_sale_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/widget/common_product_sale_item_widget.dart';
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
        ..add(ProductSaleEvent.userApproveEvent(context: context))
        ..add(const ProductSaleEvent.getPreferencesDataEvent()),
      child: ProductSaleScreenWidget(saleProductId: args?[AppStrings.companyIdString] ?? ''),
    );
  }
}

class ProductSaleScreenWidget extends StatelessWidget {
  final String saleProductId;
  const ProductSaleScreenWidget({super.key, this.saleProductId = ''});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductSaleBloc, ProductSaleState>(
      listener: (context, state) {},
      child: BlocBuilder<ProductSaleBloc, ProductSaleState>(builder: (context, state) {
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
                    physics: const ClampingScrollPhysics(),
                    enablePullDown: true,
                    controller: state.refreshController,
                    header: const RefreshWidget(),
                    footer: CustomFooter(builder: (context, mode) => const ProductSaleScreenShimmerWidget()),
                    enablePullUp: !state.isBottomOfProducts,
                    onRefresh: () {
                      context.read<ProductSaleBloc>().add(ProductSaleEvent.refreshListEvent(context: context));
                      context.read<ProductSaleBloc>().add(const ProductSaleEvent.getPreferencesDataEvent());
                    },
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(children: [
                        state.isShimmering
                            ? state.isGridView
                                ? const ProductSaleScreenShimmerWidget()
                                : const StoreCategoryScreenSubcategoryShimmerWidget()
                            : state.productSalesList.isEmpty
                                ? Container(
                                    height: getScreenHeight(context) - 80,
                                    width: getScreenWidth(context),
                                    alignment: Alignment.center,
                                    child: noDataWidget(AppLocalizations.of(context)!.currently_products_are_not_on_sale),
                                  )
                                : state.isGridView
                                    ? gridViewWidget(context, state)
                                    : listViewWidget(context, state)
                      ]),
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
                  }),
            ),
          ),
        );
      }),
    );
  }

  void _updateQuantity({required BuildContext context, required ProductSaleState state, required int index}) {
    context.read<ProductSaleBloc>().add(ProductSaleEvent.updateListQuantityOfProduct(
          context: context,
          quantity: state.productStockList[1][index].quantity.toString(),
          productListIndex: 1,
          productStockUpdateIndex: index,
          productSupplierIds: state.productSalesList[index].supplierId.toString(),
        ));
  }

  void _addToCart({required BuildContext context, required ProductSaleState state, required int index}) {
    context.read<ProductSaleBloc>().add(ProductSaleEvent.addToCartListProductEvent(
          context: context,
          productId: state.productSalesList[index].id.toString(),
          productListIndex: 1,
          productStockUpdateIndex: index,
          productSupplierIds: state.productSalesList[index].supplierId.toString(),
        ));
  }

  void _increaseQuantity({required BuildContext context, required ProductSaleState state, required int index}) {
    final product = state.productSalesList[index];
    final quantity = state.productStockList[1][index].quantity;
    final minQty = int.tryParse(product.sale?.saleMinQuantity ?? '0') ?? 0;

    if (minQty <= quantity + 1) {
      context.read<ProductSaleBloc>().add(ProductSaleEvent.increaseListQuantityOfProduct(
            context: context,
            productListIndex: 1,
            productStockUpdateIndex: index,
            productSupplierIds: product.supplierId.toString(),
          ));
      _addToCart(context: context, state: state, index: index);
    } else {
      showMinMaxQtyConfirmDialog(
        context: context,
        productId: product.id.toString(),
        minBox: minQty.toString(),
        index: index,
        supplierId: product.supplierId.toString(),
        productListIndex: 1,
        isIncrease: true,
        isMixedSale: product.sale?.isMixedSale,
        sameSaleProducts: product.sale?.sameSaleProducts,
      );
    }
  }

  void _decreaseQuantity({required BuildContext context, required ProductSaleState state, required int index}) {
    final product = state.productSalesList[index];
    final quantity = state.productStockList[1][index].quantity;
    final minQty = int.tryParse(product.sale?.saleMinQuantity ?? '0') ?? 0;

    if (quantity == 0) return;

    if (minQty <= quantity - 1) {
      context.read<ProductSaleBloc>().add(ProductSaleEvent.decreaseListQuantityOfProduct(
            context: context,
            productListIndex: 1,
            productStockUpdateIndex: index,
            productSupplierIds: product.supplierId.toString(),
          ));
      _addToCart(context: context, state: state, index: index);
    } else {
      showMinMaxQtyConfirmDialog(
        context: context,
        productId: product.id.toString(),
        minBox: minQty.toString(),
        index: index,
        supplierId: product.supplierId.toString(),
        productListIndex: 1,
        isIncrease: false,
        isMixedSale: product.sale?.isMixedSale,
        sameSaleProducts: product.sale?.sameSaleProducts,
      );
    }
  }

  Widget gridViewWidget(BuildContext context, ProductSaleState state) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: state.productSalesList.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: getChildAspectRatio(context, state.isSaleOn)),
        itemBuilder: (context, index) {
          final productSaleData = state.productSalesList[index];
          final productStockData = state.productStockList[1][index];

          return CommonProductSaleItemWidget(
              isSale: true,
              height: AppConstants.salesProductItemHeight,
              width: 140,
              isGuestUser: state.isGuestUser,
              saleImage: productSaleData.mainImage ?? '',
              title: productSaleData.name,
              description: parse(productSaleData.sale?.saleDescription ?? '').body?.text ?? '',
              productName: productSaleData.productName ?? '',
              originalPrice: productSaleData.productPrice ?? 0.0,
              discountedPrice: double.tryParse(productSaleData.sale?.salePrice ?? '') ?? 0.0,
              isPesach: productSaleData.isPesach ?? false,
              lowStock: productSaleData.lowStock ?? '',
              productStock: productSaleData.productStock.toString(),
              quantity: productStockData.quantity,
              onQuantityChanged: () => _updateQuantity(context: context, state: state, index: index),
              onQuantityIncreaseTap: () => _increaseQuantity(context: context, state: state, index: index),
              onQuantityDecreaseTap: () => _decreaseQuantity(context: context, state: state, index: index),
              minQuantity: productSaleData.sale?.saleMinQuantity,
              maxQuantity: productSaleData.sale?.saleMaxQuantity,
              isMixedSale: productSaleData.sale?.isMixedSale,
              numberOfUnits: productSaleData.numberOfUnit.toString(),
              scaleType: productSaleData.scaleType,
              onButtonTap: () {
                if (!state.isGuestUser) {
                  showProductDetails(context: context, productId: productSaleData.id ?? '', productStock: productSaleData.productStock.toString(), productListIndex: 1);
                } else {
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                }
              });
        });
  }

  Widget listViewWidget(BuildContext context, ProductSaleState state) {
    return ListView.builder(
        itemCount: state.productSalesList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
        itemBuilder: (context, index) {
          final productSaleData = state.productSalesList[index];
          final productStockData = state.productStockList[1][index];

          return CommonSaleListView(
              context: context,
              discountedPrice: double.tryParse(productSaleData.sale?.salePrice ?? '') ?? 0.0,
              isFromSale: productSaleData.sale?.isSale ?? false,
              salesDesc: productSaleData.sale?.saleDescription ?? '',
              isGuestUser: state.isGuestUser,
              isPesach: productSaleData.isPesach,
              numberOfUnits: productSaleData.numberOfUnit.toString(),
              scaleType: productSaleData.scaleType,
              lowStock: productSaleData.lowStock.toString(),
              productStock: productSaleData.productStock.toString(),
              productImage: productSaleData.mainImage ?? '',
              productName: productSaleData.productName ?? '',
              price: double.tryParse(productSaleData.productPrice.toString()) ?? 0.0,
              quantity: productStockData.quantity,
              minQuantity: productSaleData.sale?.saleMinQuantity,
              maxQuantity: productSaleData.sale?.saleMaxQuantity,
              isMixedSale: productSaleData.sale?.isMixedSale,
              onQuantityChanged: () => _updateQuantity(context: context, state: state, index: index),
              onQuantityIncreaseTap: () => _increaseQuantity(context: context, state: state, index: index),
              onQuantityDecreaseTap: () => _decreaseQuantity(context: context, state: state, index: index),
              onButtonTap: () {
                if (!state.isGuestUser) {
                  showProductDetails(context: context, productId: productSaleData.id ?? '', productStock: productSaleData.productStock.toString(), productListIndex: 1);
                } else {
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                }
              });
        });
  }

  void showProductDetails({required BuildContext context, required String productId, String productStock = '0', bool isBarcode = false, required int productListIndex}) async {
    context.read<ProductSaleBloc>().add(ProductSaleEvent.getProductDetailsEvent(context: context, productId: productId, isBarcode: isBarcode, productListIndex: productListIndex));
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        clipBehavior: Clip.hardEdge,
        enableDrag: false,
        builder: (context1) {
          return BlocProvider.value(
            value: context.read<ProductSaleBloc>(),
            child: BlocBuilder<ProductSaleBloc, ProductSaleState>(builder: (blocContext, state) {
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
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                          color: AppColors.whiteColor,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: state.isProductLoading
                            ? const ProductDetailsShimmerWidget()
                            : SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                controller: ModalScrollController.of(context),
                                child: Column(children: [
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
                                          showMinQtyConfirmDialog(
                                            context,
                                            productId,
                                            state.productDetails.first.sale!.saleMinQuantity.toString(),
                                            state.productDetails.first.sale!.isMixedSale,
                                            state.productDetails.first.sale!.sameSaleProducts,
                                          );
                                        }
                                      },
                                      imageOnTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SafeArea(
                                                bottom: false,
                                                child: Stack(children: [
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
                                                        imageProvider: NetworkImage('${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}'),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(padding: const EdgeInsets.only(top: AppConstants.padding_10), child: Icon(Icons.close, color: AppColors.whiteColor))),
                                                ]),
                                              );
                                            });
                                      },
                                      context: context,
                                      productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'),
                                      scaleType: state.productDetails.first.scaleType,
                                      productImages: [state.productDetails.first.mainImage ?? ''],
                                      productPrice: (state.productDetails.first.sale?.isSale ?? false) ? double.parse(state.productDetails.first.sale?.salePrice ?? '') * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1) : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 0),
                                      productStock: state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString(),
                                      scrollController: scrollController,
                                      productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                      isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                      recommendedRetailConsumerPricerOffer: state.clubAgentId == AppStrings.clubAgentIdText
                                          ? state.productDetails.first.sale?.isSale == true
                                              ? state.productDetails.first.recommendedConsumerOffer
                                              : state.productDetails.first.recommendedRetailPrice
                                          : '',
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
                                        context.read<ProductSaleBloc>().add(ProductSaleEvent.getProductSalesListEvent(context: context1));
                                        Navigator.pop(context);
                                      }),
                                  state.isRelatedShimmering
                                      ? const RelatedProductShimmerWidget()
                                      : state.relatedProductList.isEmpty
                                          ? 0.width
                                          : relatedProductWidget(context1, state.relatedProductList, context, productStockList: state.productStockList)
                                ]),
                              ),
                      );
                    }),
              );
            }),
          );
        });
  }

  Widget relatedProductWidget(
    BuildContext prevContext,
    List<RelatedProductDatum> relatedProductList,
    BuildContext context, {
    required List<List<ProductStockModel>> productStockList,
  }) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
      relatedProductTitle(context),
      Container(
        height: getItemHeight(context, true),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
        child: ListView.builder(
          physics: const ClampingScrollPhysics(),
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
                quantity: productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity,
                minQuantity: relatedProductList.elementAt(i).sale?.saleMinQuantity,
                maxQuantity: relatedProductList.elementAt(i).sale?.saleMaxQuantity,
                isMixedSale: relatedProductList.elementAt(i).sale?.isMixedSale,
                numberOfUnits: relatedProductList.elementAt(i).numberOfUnit.toString(),
                scaleType: relatedProductList.elementAt(i).scaleType,
                onQuantityChanged: () {
                  context.read<ProductSaleBloc>().add(ProductSaleEvent.updateListQuantityOfProduct(
                        context: context,
                        quantity: productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity.toString(),
                        productListIndex: 2,
                        productStockUpdateIndex: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                        productSupplierIds: relatedProductList[i].supplierId.toString(),
                      ));
                },
                onQuantityIncreaseTap: () {
                  if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity + 1) {
                    context.read<ProductSaleBloc>().add(ProductSaleEvent.increaseListQuantityOfProduct(
                          context: context,
                          productListIndex: 2,
                          productStockUpdateIndex: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString(),
                        ));

                    context.read<ProductSaleBloc>().add(ProductSaleEvent.addToCartListProductEvent(
                          context: context,
                          productId: relatedProductList[i].id.toString(),
                          productListIndex: 2,
                          productStockUpdateIndex: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString(),
                        ));
                  } else {
                    showMinMaxQtyConfirmDialog(
                      context: context,
                      productId: relatedProductList[i].id.toString(),
                      minBox: relatedProductList.elementAt(i).sale?.saleMinQuantity.toString() ?? '0',
                      index: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                      supplierId: relatedProductList[i].supplierId.toString(),
                      productListIndex: 2,
                      isIncrease: true,
                      isMixedSale: relatedProductList[i].sale?.isMixedSale,
                      sameSaleProducts: relatedProductList[i].sale?.sameSaleProducts,
                    );
                  }
                },
                onQuantityDecreaseTap: () {
                  if (productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity != 0) {
                    if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity - 1) {
                      context.read<ProductSaleBloc>().add(ProductSaleEvent.decreaseListQuantityOfProduct(
                            context: context,
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString(),
                          ));

                      context.read<ProductSaleBloc>().add(ProductSaleEvent.addToCartListProductEvent(
                            context: context,
                            productId: relatedProductList[i].id.toString(),
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString(),
                          ));
                    } else {
                      showMinMaxQtyConfirmDialog(
                        context: context,
                        productId: relatedProductList[i].id.toString(),
                        minBox: relatedProductList.elementAt(i).sale?.saleMinQuantity.toString() ?? '0',
                        index: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                        supplierId: relatedProductList[i].supplierId.toString(),
                        productListIndex: 2,
                        isIncrease: false,
                        isMixedSale: relatedProductList[i].sale?.isMixedSale,
                        sameSaleProducts: relatedProductList[i].sale?.sameSaleProducts,
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
                });
          },
          itemCount: relatedProductList.length,
        ),
      )
    ]);
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox, bool? isMixedSale, List? sameSaleProducts) {
    ProductSaleBloc bloc = context.read<ProductSaleBloc>();
    showDialog(
        context: context,
        builder: (dialogContext) => BlocProvider.value(
              value: context.read<ProductSaleBloc>(),
              child: BlocBuilder<ProductSaleBloc, ProductSaleState>(builder: (context1, state) {
                String mixedSale = '';
                if (isMixedSale!) {
                  mixedSale = AppStrings.minSaleText(context, minBox);
                } else {
                  mixedSale = AppStrings.otherSaleText(context, minBox);
                }
                return CustomDialog(
                    directionality: state.language,
                    title: mixedSale,
                    content: isMixedSale ? sameSaleProducts! : [],
                    isMixedSale: isMixedSale,
                    positiveTitle: AppLocalizations.of(context)!.closeText,
                    negativeTitle: AppLocalizations.of(context)!.addText,
                    negativeOnTap: () async {
                      Navigator.pop(dialogContext);
                      bloc.add(ProductSaleEvent.addToCartProductEvent(context: context, productId: productId));
                    },
                    positiveOnTap: () async {
                      Navigator.pop(context);
                      bloc.add(ProductSaleEvent.getCartCountEvent(context: context));
                    });
              }),
            ));
  }

  void showMinMaxQtyConfirmDialog({
    required BuildContext context,
    required String productId,
    required String minBox,
    required int index,
    required dynamic supplierId,
    required int productListIndex,
    required bool isIncrease,
    bool? isMixedSale,
    List? sameSaleProducts,
  }) {
    final ProductSaleBloc bloc = context.read<ProductSaleBloc>();
    final bool mixedSaleFlag = isMixedSale ?? false;

    showDialog(
        context: context,
        builder: (dialogContext) => BlocProvider.value(
              value: bloc,
              child: BlocBuilder<ProductSaleBloc, ProductSaleState>(builder: (context1, state) {
                final String mixedSale = mixedSaleFlag ? AppStrings.minSaleText(context, minBox) : AppStrings.otherSaleText(context, minBox);

                return CustomDialog(
                    directionality: state.language,
                    title: mixedSale,
                    content: mixedSaleFlag ? (sameSaleProducts ?? []) : [],
                    isMixedSale: mixedSaleFlag,
                    positiveTitle: AppLocalizations.of(context)!.closeText,
                    negativeTitle: AppLocalizations.of(context)!.addText,
                    negativeOnTap: () {
                      Navigator.pop(dialogContext);

                      if (isIncrease) {
                        bloc.add(ProductSaleEvent.increaseListQuantityOfProduct(
                          context: context,
                          productListIndex: productListIndex,
                          productStockUpdateIndex: index,
                          productSupplierIds: supplierId,
                        ));
                      } else {
                        bloc.add(ProductSaleEvent.decreaseListQuantityOfProduct(
                          context: context,
                          productListIndex: productListIndex,
                          productStockUpdateIndex: index,
                          productSupplierIds: supplierId,
                        ));
                      }

                      bloc.add(ProductSaleEvent.addToCartListProductEvent(
                        context: context,
                        productId: productId,
                        productListIndex: productListIndex,
                        productStockUpdateIndex: index,
                        productSupplierIds: supplierId,
                      ));
                    },
                    positiveOnTap: () {
                      Navigator.pop(dialogContext);
                    });
              }),
            ));
  }
}
