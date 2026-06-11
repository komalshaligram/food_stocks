import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/widget/related_product_title.dart';
import '../../bloc/recommendation_products/recommendation_products_bloc.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../ui/widget/refresh_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/search_model/search_model.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_sale_item_widget.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/confetti.dart';
import '../widget/custom_dialog.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';
import '../widget/supplier_products_screen_shimmer_widget.dart';

class RecommendationProductsRoute {
  static Widget get route => const RecommendationProductsScreen();
}

class RecommendationProductsScreen extends StatefulWidget {
  const RecommendationProductsScreen({super.key});

  @override
  State<RecommendationProductsScreen> createState() => _RecommendationProductsScreenState();
}

class _RecommendationProductsScreenState extends State<RecommendationProductsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RecommendationProductsBloc().add(RecommendationProductsEvent.getRecommendationProductsEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendationProductsBloc()
        ..add(RecommendationProductsEvent.getRecommendationProductsEvent(context: context))
        ..add(RecommendationProductsEvent.userApproveEvent(context: context))
        ..add(const RecommendationProductsEvent.getPreferencesDataEvent()),
      child: const RecommendationProductsScreenWidget(),
    );
  }
}

class RecommendationProductsScreenWidget extends StatelessWidget {
  const RecommendationProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    RecommendationProductsBloc bloc = context.read<RecommendationProductsBloc>();
    return BlocListener<RecommendationProductsBloc, RecommendationProductsState>(
      listener: (context, state) {},
      child: BlocBuilder<RecommendationProductsBloc, RecommendationProductsState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.recommended_for_you,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: GestureDetector(
                  onTap: () {
                    context.read<RecommendationProductsBloc>().add(const RecommendationProductsEvent.getGridListView());
                  },
                  child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
          floatingActionButton: floatingButtonWidget(context, state),
          body: FocusDetector(
            onFocusGained: () {
              bloc.add(const RecommendationProductsEvent.getCartCountEvent());
              bloc.add(RecommendationProductsEvent.getPermissionList(context: context));
            },
            child: SafeArea(
              child: NotificationListener<ScrollNotification>(
                  child: Stack(children: [
                    Column(children: [
                      100.height,
                      Expanded(
                        child: state.isShimmering
                            ? state.isGridView
                                ? const SupplierProductsScreenShimmerWidget()
                                : const StoreCategoryScreenSubcategoryShimmerWidget()
                            : state.recommendationProductsList.isEmpty
                                ? Container(
                                    height: getScreenHeight(context) - 80,
                                    width: getScreenWidth(context),
                                    margin: const EdgeInsets.only(top: AppConstants.padding_30),
                                    alignment: Alignment.center,
                                    child: noDataWidget(AppLocalizations.of(context)!.recommendation_products_are_not_available),
                                  )
                                : SmartRefresher(
                                    physics: const ClampingScrollPhysics(),
                                    enablePullDown: true,
                                    controller: state.refreshController,
                                    header: const RefreshWidget(),
                                    footer: CustomFooter(
                                      builder: (context, mode) => state.isGridView ? const SupplierProductsScreenShimmerWidget() : const StoreCategoryScreenSubcategoryShimmerWidget(),
                                    ),
                                    enablePullUp: !state.isBottomOfProducts,
                                    onRefresh: () {
                                      context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.refreshListEvent(context: context));
                                      bloc.add(const RecommendationProductsEvent.getPreferencesDataEvent());
                                    },
                                    child: SingleChildScrollView(
                                      physics: state.recommendationProductsList.isEmpty ? const NeverScrollableScrollPhysics() : null,
                                      child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        state.isGridView ? gridViewWidget(context, state) : listViewWidget(context, state),
                                      ]),
                                    ),
                                  ),
                      )
                    ]),
                    searchWidget(context, bloc, state),
                  ]),
                  onNotification: (notification) {
                    if (notification.metrics.pixels > (notification.metrics.maxScrollExtent - 400)) {
                      if (!state.isBottomOfProducts) {
                        context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.getRecommendationProductsEvent(context: context));
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

  void _updateQuantity({required BuildContext context, required RecommendationProductsState state, required int index}) {
    final product = state.recommendationProductsList[index];

    context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.updateListQuantityOfProduct(
          context: context,
          quantity: state.productStockList[1][index].quantity.toString(),
          productListIndex: 1,
          productStockUpdateIndex: index,
          productSupplierIds: product.supplierId.toString(),
        ));
  }

  void _addToCart({required BuildContext context, required RecommendationProductsState state, required int index}) {
    final product = state.recommendationProductsList[index];

    context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.addToCartListProductEvent(
          context: context,
          productId: product.id.toString(),
          productListIndex: 1,
          productStockUpdateIndex: index,
          productSupplierIds: product.supplierId.toString(),
        ));
  }

  void _increaseQuantity({required BuildContext context, required RecommendationProductsState state, required int index}) {
    final product = state.recommendationProductsList[index];
    final quantity = state.productStockList[1][index].quantity;
    final minQty = int.tryParse(product.sale?.saleMinQuantity ?? '0') ?? 0;

    if (minQty <= quantity + 1) {
      context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.increaseListQuantityOfProduct(
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

  void _decreaseQuantity({required BuildContext context, required RecommendationProductsState state, required int index}) {
    final product = state.recommendationProductsList[index];
    final quantity = state.productStockList[1][index].quantity;
    final minQty = int.tryParse(product.sale?.saleMinQuantity ?? '0') ?? 0;

    if (quantity == 0) return;

    if (minQty <= quantity - 1) {
      context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.decreaseListQuantityOfProduct(
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

  Widget gridViewWidget(BuildContext context, RecommendationProductsState state) {
    return GridView.builder(
        itemCount: state.recommendationProductsList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: getChildAspectRatio(context, state.isSaleOn)),
        itemBuilder: (context, index) {
          final productSaleData = state.recommendationProductsList[index];
          final productStockData = state.productStockList[1][index];

          return CommonProductSaleItemWidget(
              isSale: productSaleData.sale?.isSale,
              height: AppConstants.salesProductItemHeight,
              width: 140,
              productName: productSaleData.productName ?? '',
              saleImage: productSaleData.mainImage ?? '',
              title: productSaleData.name,
              description: parse(productSaleData.sale?.saleDescription ?? '').body?.text ?? '',
              discountedPrice: double.tryParse(productSaleData.sale?.salePrice ?? '') ?? 0.0,
              originalPrice: productSaleData.productPrice,
              productStock: productSaleData.productStock.toString(),
              lowStock: productSaleData.lowStock ?? '',
              isPesach: productSaleData.isPesach,
              quantity: productStockData.quantity,
              minQuantity: productSaleData.sale?.saleMinQuantity,
              maxQuantity: productSaleData.sale?.saleMaxQuantity,
              isMixedSale: productSaleData.sale?.isMixedSale,
              numberOfUnits: productSaleData.numberOfUnit.toString(),
              scaleType: productSaleData.scaleType,
              onQuantityChanged: () => _updateQuantity(context: context, state: state, index: index),
              onQuantityIncreaseTap: () => _increaseQuantity(context: context, state: state, index: index),
              onQuantityDecreaseTap: () => _decreaseQuantity(context: context, state: state, index: index),
              onButtonTap: () {
                showProductDetails(
                  context: context,
                  productId: productSaleData.id ?? '',
                  productStock: productSaleData.productStock.toString(),
                  productListIndex: 1,
                  isSaleOn: state.isSaleOn,
                );
              });
        });
  }

  Widget listViewWidget(BuildContext context, RecommendationProductsState state) {
    return ListView.builder(
        itemCount: state.recommendationProductsList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
        itemBuilder: (context, index) {
          final productSaleData = state.recommendationProductsList[index];
          final productStockData = state.productStockList[1][index];

          return CommonSaleListView(
            context: context,
            discountedPrice: double.tryParse(productSaleData.sale?.salePrice ?? '') ?? 0.0,
            isFromSale: productSaleData.sale?.isSale ?? false,
            salesDesc: productSaleData.sale?.saleDescription ?? '',
            isPesach: productSaleData.isPesach,
            lowStock: productSaleData.lowStock.toString(),
            productStock: productSaleData.productStock.toString(),
            productImage: productSaleData.mainImage ?? '',
            productName: productSaleData.productName ?? '',
            price: double.tryParse(productSaleData.productPrice.toString()) ?? 0.0,
            quantity: productStockData.quantity,
            minQuantity: productSaleData.sale?.saleMinQuantity,
            maxQuantity: productSaleData.sale?.saleMaxQuantity,
            isMixedSale: productSaleData.sale?.isMixedSale,
            numberOfUnits: productSaleData.numberOfUnit.toString(),
            scaleType: productSaleData.scaleType,
            onQuantityChanged: () => _updateQuantity(context: context, state: state, index: index),
            onQuantityIncreaseTap: () => _increaseQuantity(context: context, state: state, index: index),
            onQuantityDecreaseTap: () => _decreaseQuantity(context: context, state: state, index: index),
            onButtonTap: () {
              showProductDetails(
                context: context,
                productId: productSaleData.id ?? '',
                productStock: productSaleData.productStock.toString(),
                productListIndex: 1,
                isSaleOn: state.isSaleOn,
              );
            },
            isGuestUser: false,
          );
        });
  }

  Widget searchWidget(BuildContext context, RecommendationProductsBloc bloc, RecommendationProductsState state) => CommonSearchWidget(
      onCloseTap: () {
        bloc.add(const RecommendationProductsEvent.changeCategoryExpansion(isOpened: false));
        context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.getRecommendationProductsEvent(context: context));
      },
      isFilterTap: true,
      isCategoryExpand: state.isCategoryExpand,
      isSearching: state.isSearching,
      onFilterTap: () {
        bloc.add(const RecommendationProductsEvent.changeCategoryExpansion());
      },
      onSearchTap: () {
        if (state.searchController.text != '') {
          bloc.add(const RecommendationProductsEvent.changeCategoryExpansion(isOpened: true));
        }
      },
      onSearch: (String search) {
        if (search.length > 1) {
          bloc.add(const RecommendationProductsEvent.changeCategoryExpansion(isOpened: true));
          bloc.add(RecommendationProductsEvent.globalSearchEvent(context: context));
        }
      },
      onSearchSubmit: (String search) {
        Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
          AppStrings.searchString: state.search,
          AppStrings.searchType: SearchTypes.product.toString(),
        });
      },
      onOutSideTap: () {
        state.searchController.clear();
        bloc.add(const RecommendationProductsEvent.changeCategoryExpansion(isOpened: false));
      },
      onSearchItemTap: () {
        bloc.add(const RecommendationProductsEvent.changeCategoryExpansion());
      },
      controller: state.searchController,
      searchList: state.searchList,
      searchResultWidget: state.isSearching
          ? const SizedBox()
          : state.searchList.isEmpty
              ? noDataWidget(AppLocalizations.of(context)!.search_result_not_found)
              : ListView.builder(
                  itemCount: state.searchList.length,
                  shrinkWrap: true,
                  itemBuilder: (listViewContext, index) {
                    return SearchItemWidget(
                      isShowSeeAll: index == state.searchList.length - 1 ? true : false,
                      salePrice: state.searchList[index].salePrice,
                      saleDesc: state.searchList[index].salesDesc,
                      isPesach: state.searchList[index].isPesach,
                      lowStock: state.searchList[index].lowStock,
                      numberOfUnits: state.searchList[index].numberOfUnits,
                      scaleType: state.searchList[index].scaleType,
                      priceOfBox: state.searchList[index].priceOfBox,
                      productStock: state.searchList[index].productStock,
                      context: context,
                      searchName: state.searchList[index].name,
                      searchImage: state.searchList[index].image,
                      searchType: state.searchList[index].searchType,
                      isMoreResults: state.searchList.where((search) => search.searchType == state.searchList[index].searchType).toList().isNotEmpty,
                      isLastItem: state.searchList.length - 1 == index,
                      quantity: state.productStockList[0][index].quantity,
                      isSale: state.searchList[index].isSale,
                      minQuantity: state.searchList[index].saleMinQuantity,
                      maxQuantity: state.searchList[index].saleMaxQuantity,
                      isMixedSale: state.searchList[index].isMixedSale,
                      onQuantityChanged: () {
                        context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.updateListQuantityOfProduct(
                              context: context,
                              quantity: state.productStockList[0][index].quantity.toString(),
                              productListIndex: 0,
                              productStockUpdateIndex: index,
                              productSupplierIds: state.searchList[index].supplierId.toString(),
                            ));
                      },
                      onQuantityIncreaseTap: () {
                        if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity + 1) {
                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.increaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: state.searchList[index].supplierId.toString(),
                              ));
                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.addToCartListProductEvent(
                                context: context,
                                productId: state.searchList[index].searchId,
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: state.searchList[index].supplierId.toString(),
                              ));
                        } else {
                          showMinMaxQtyConfirmDialog(
                            context: context,
                            productId: state.searchList[index].searchId,
                            minBox: state.searchList[index].saleMinQuantity.toString(),
                            index: index,
                            supplierId: state.searchList[index].supplierId.toString(),
                            productListIndex: 0,
                            isIncrease: true,
                            isMixedSale: state.searchList[index].isMixedSale,
                            sameSaleProducts: state.searchList[index].sameSaleProducts,
                          );
                        }
                      },
                      onQuantityDecreaseTap: () {
                        if (state.productStockList[0][index].quantity != 0) {
                          if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity - 1) {
                            context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.decreaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.searchList[index].supplierId.toString(),
                                ));
                            context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: state.searchList[index].searchId,
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.searchList[index].supplierId.toString(),
                                ));
                          } else {
                            showMinMaxQtyConfirmDialog(
                              context: context,
                              productId: state.searchList[index].searchId,
                              minBox: state.searchList[index].saleMinQuantity.toString(),
                              index: index,
                              supplierId: state.searchList[index].supplierId.toString(),
                              productListIndex: 0,
                              isIncrease: false,
                              isMixedSale: state.searchList[index].isMixedSale,
                              sameSaleProducts: state.searchList[index].sameSaleProducts,
                            );
                          }
                        }
                      },
                      isShowSearchLabel: index == 0
                          ? true
                          : state.searchList[index].searchType != state.searchList[index - 1].searchType
                              ? true
                              : false,
                      onSeeAllTap: () async {
                        if (state.searchList[index].searchType == SearchTypes.category) {
                          dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.productCategoryScreen.name, arguments: {
                            AppStrings.searchString: state.search,
                            AppStrings.reqSearchString: state.search,
                            AppStrings.searchResultString: state.searchList,
                          });
                          if (searchResult != null) {
                            bloc.add(RecommendationProductsEvent.updateGlobalSearchEvent(
                              search: searchResult[AppStrings.searchString],
                              searchList: searchResult[AppStrings.searchResultString],
                            ));
                          }
                        } else if (state.searchList[index].searchType == SearchTypes.subCategory) {
                          dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                            AppStrings.categoryIdString: state.searchList[index].categoryId,
                            AppStrings.categoryNameString: state.searchList[index].categoryName,
                            AppStrings.searchString: state.search,
                            AppStrings.searchResultString: state.searchList,
                          });
                          if (searchResult != null) {
                            bloc.add(RecommendationProductsEvent.updateGlobalSearchEvent(
                              search: searchResult[AppStrings.searchString],
                              searchList: searchResult[AppStrings.searchResultString],
                            ));
                          }
                        } else {
                          state.searchList[index].searchType == SearchTypes.company
                              ? Navigator.pushNamed(context, RouteDefine.companyScreen.name, arguments: {
                                  AppStrings.searchString: state.search,
                                })
                              : state.searchList[index].searchType == SearchTypes.supplier
                                  ? Navigator.pushNamed(context, RouteDefine.supplierScreen.name, arguments: {
                                      AppStrings.searchString: state.search,
                                    })
                                  : state.searchList[index].searchType == SearchTypes.sale
                                      ? Navigator.pushNamed(context, RouteDefine.productSaleScreen.name, arguments: {
                                          AppStrings.searchString: state.search,
                                        })
                                      : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                          AppStrings.searchString: state.search,
                                          AppStrings.searchType: SearchTypes.product.toString(),
                                        });
                        }
                      },
                      onTap: () async {
                        if (state.searchList[index].searchType == SearchTypes.subCategory) {
                          inProgressSnackBarWidget(context);
                          return;
                        }
                        if (state.searchList[index].searchType == SearchTypes.sale || state.searchList[index].searchType == SearchTypes.product) {
                          showProductDetails(
                            context: context,
                            productStock: state.searchList[index].productStock.toString(),
                            productId: state.searchList[index].searchId,
                            isBarcode: true,
                            productListIndex: 0,
                            isSaleOn: state.isSaleOn,
                          );
                        } else if (state.searchList[index].searchType == SearchTypes.category) {
                          dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                            AppStrings.categoryIdString: state.searchList[index].searchId,
                            AppStrings.categoryNameString: state.searchList[index].name,
                            AppStrings.searchString: state.searchController.text,
                            AppStrings.searchResultString: state.searchList,
                          });
                          if (searchResult != null) {
                            bloc.add(RecommendationProductsEvent.updateGlobalSearchEvent(
                              search: searchResult[AppStrings.searchString],
                              searchList: searchResult[AppStrings.searchResultString],
                            ));
                          }
                        } else {
                          state.searchList[index].searchType == SearchTypes.company
                              ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {
                                  AppStrings.companyIdString: state.searchList[index].searchId,
                                })
                              : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                  AppStrings.supplierIdString: state.searchList[index].searchId,
                                });
                        }
                        bloc.add(const RecommendationProductsEvent.changeCategoryExpansion());
                      },
                      isGuestUser: false,
                    );
                  }),
      onScanTap: () async {
        String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
        if (scanResult != '-1') {
          showProductDetails(context: context, productId: scanResult, isBarcode: true, productStock: '1', productListIndex: 0, isSaleOn: state.isSaleOn);
        }
      });

  void showProductDetails({
    required BuildContext context,
    required String productId,
    bool? isBarcode,
    String productStock = '0',
    int productListIndex = -1,
    required bool isSaleOn,
  }) async {
    context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.getProductDetailsEvent(
          context: context,
          productId: productId,
          isBarcode: isBarcode ?? false,
          productListIndex: productListIndex,
        ));
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        clipBehavior: Clip.hardEdge,
        enableDrag: false,
        builder: (context1) {
          return SafeArea(
            bottom: false,
            child: DraggableScrollableSheet(
                expand: true,
                maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                minChildSize: productStock == '0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                initialChildSize: productStock == '0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                builder: (BuildContext context1, ScrollController scrollController) {
                  return BlocProvider.value(
                    value: context.read<RecommendationProductsBloc>(),
                    child: BlocBuilder<RecommendationProductsBloc, RecommendationProductsState>(builder: (blocContext, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                          color: AppColors.whiteColor,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: state.isProductLoading
                            ? const ProductDetailsShimmerWidget()
                            : state.productDetails.isEmpty
                                ? NoDataBottomSheet(dialogContext: context)
                                : SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: ModalScrollController.of(context),
                                    child: Column(children: [
                                      CommonProductDetailsWidget(
                                        isIncludedVat: state.isIncludedVat,
                                        productDetails: state.productDetails,
                                        isSubUserAddToBasket: state.isSubUserAddToBasket,
                                        bottleTax: state.bottleDeposit,
                                        totalBottleDeposit: (state.bottleDeposit * (state.productDetails.first.numberOfUnit ?? 1) * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                        isBottle: (state.productDetails.first.isBottle ?? false),
                                        addToOrderTap: () {
                                          if (int.parse(state.productDetails.first.sale!.saleMinQuantity!) <= state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
                                            context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.addToCartProductEvent(context: context1, productId: productId));
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
                                        isLoading: state.isLoading,
                                        imageOnTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (dialogContext) {
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
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: PhotoView(
                                                          imageProvider: NetworkImage('${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}'),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: AppConstants.padding_10),
                                                          child: Icon(Icons.close, color: AppColors.whiteColor),
                                                        )),
                                                  ]),
                                                );
                                              });
                                        },
                                        context: context,
                                        productImages: [state.productDetails.first.mainImage ?? ''],
                                        productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? ''),
                                        scaleType: state.productDetails.first.scaleType,
                                        productPrice: (state.productDetails.first.sale?.isSale ?? false) ? double.parse(state.productDetails.first.sale?.salePrice ?? '') * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1) : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                        productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                        scrollController: scrollController,
                                        productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                        isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                        recommendedRetailConsumerPricerOffer: state.clubAgentId == AppStrings.clubAgentIdText
                                            ? state.productDetails.first.sale?.isSale == true
                                                ? state.productDetails.first.recommendedConsumerOffer
                                                : state.productDetails.first.recommendedRetailPrice
                                            : '',
                                        onQuantityChanged: (quantity) {
                                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.updateQuantityOfProduct(
                                                context: context1,
                                                quantity: quantity,
                                              ));
                                        },
                                        onQuantityIncreaseTap: () {
                                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.increaseQuantityOfProduct(context: context1));
                                        },
                                        onQuantityDecreaseTap: () {
                                          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                            context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.decreaseQuantityOfProduct(context: context1));
                                          }
                                        },
                                        onCloseTap: () {
                                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.getRecommendationProductsEvent(context: context1));
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
                                                  isSaleOn,
                                                  productStockList: state.productStockList,
                                                )
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
    BuildContext context,
    bool isSaleOn, {
    required List<List<ProductStockModel>> productStockList,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
      relatedProductTitle(context),
      Container(
        height: getItemHeight(context, isSaleOn),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
        child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context2, i) {
            return CommonProductSaleItemWidget(
                isSale: relatedProductList.elementAt(i).sale?.isSale,
                isGuestUser: false,
                height: isSaleOn ? AppConstants.salesProductItemHeight : AppConstants.withoutSaleItemHeight,
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
                  context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.updateListQuantityOfProduct(
                        context: context,
                        quantity: productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity.toString(),
                        productListIndex: 2,
                        productStockUpdateIndex: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                        productSupplierIds: relatedProductList[i].supplierId.toString(),
                      ));
                },
                onQuantityIncreaseTap: () {
                  if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity + 1) {
                    context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.increaseListQuantityOfProduct(
                          context: context,
                          productListIndex: 2,
                          productStockUpdateIndex: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString(),
                        ));

                    context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.addToCartListProductEvent(
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
                      context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.decreaseListQuantityOfProduct(
                            context: context,
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString(),
                          ));

                      context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.addToCartListProductEvent(
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
                  Navigator.pop(prevContext);
                  showProductDetails(
                    isSaleOn: isSaleOn,
                    context: context,
                    productId: relatedProductList[i].id ?? '',
                    isBarcode: false,
                    productListIndex: 2,
                    productStock: (relatedProductList[i].productStock.toString()),
                  );
                });
          },
          itemCount: relatedProductList.length,
        ),
      )
    ]);
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox, bool? isMixedSale, List? sameSaleProducts) {
    RecommendationProductsBloc bloc = context.read<RecommendationProductsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<RecommendationProductsBloc>(),
        child: BlocBuilder<RecommendationProductsBloc, RecommendationProductsState>(builder: (context1, state) {
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
                bloc.add(RecommendationProductsEvent.addToCartProductEvent(context: context, productId: productId));
              },
              positiveOnTap: () async {
                Navigator.pop(context);
                bloc.add(RecommendationProductsEvent.getCartCountNoEvent(context: context));
              });
        }),
      ),
    );
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
    final RecommendationProductsBloc bloc = context.read<RecommendationProductsBloc>();
    final bool mixedSaleFlag = isMixedSale ?? false;

    showDialog(
        context: context,
        builder: (dialogContext) => BlocProvider.value(
              value: bloc,
              child: BlocBuilder<RecommendationProductsBloc, RecommendationProductsState>(builder: (context1, state) {
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
                        bloc.add(RecommendationProductsEvent.increaseListQuantityOfProduct(
                          context: context,
                          productListIndex: productListIndex,
                          productStockUpdateIndex: index,
                          productSupplierIds: supplierId,
                        ));
                      } else {
                        bloc.add(RecommendationProductsEvent.decreaseListQuantityOfProduct(
                          context: context,
                          productListIndex: productListIndex,
                          productStockUpdateIndex: index,
                          productSupplierIds: supplierId,
                        ));
                      }

                      bloc.add(RecommendationProductsEvent.addToCartListProductEvent(
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

  Widget floatingButtonWidget(BuildContext context, RecommendationProductsState state) => FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.isBasketScreenString: 'true'});
        },
        child: Stack(children: [
          cartImageWidget(),
          state.cartCount != 0
              ? Positioned(
                  top: 5,
                  right: context.rtl ? null : 0,
                  left: context.rtl ? 0 : null,
                  child: Stack(children: [
                    Container(
                      height: 18,
                      width: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                        border: Border.all(color: AppColors.whiteColor, width: 1),
                      ),
                      child: Text('${state.cartCount}', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.whiteColor)),
                    ),
                  ]),
                )
              : 0.width,
          SizedBox(
            height: 50,
            width: 25,
            child: Visibility(
              visible: state.duringCelebration,
              child: IgnorePointer(child: Confetti(isStopped: !state.duringCelebration, snippingCount: 10, snipSize: 3.0, colors: [AppColors.mainColor])),
            ),
          ),
        ]),
      );
}
