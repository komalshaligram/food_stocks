import '../../data/services/club_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/widget/related_product_title.dart';
import '../../bloc/pesach_products/pesach_products_bloc.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../ui/widget/supplier_products_screen_shimmer_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_sale_item_widget.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/confetti.dart';
import '../widget/sale_promotion_sheet.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';

class PesachProductsRoute {
  static Widget get route => const PesachProductsScreen();
}

class PesachProductsScreen extends StatelessWidget {
  const PesachProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
        create: (context) => PesachProductsBloc()
          ..add(PesachProductsEvent.getSupplierProductsListEvent(context: context, searchType: args?[AppStrings.searchType] ?? ''))
          ..add(PesachProductsEvent.userApproveEvent(context: context))
          ..add(const PesachProductsEvent.getPreferencesDataEvent()),
        child: const PesachProductsScreenWidget());
  }
}

class PesachProductsScreenWidget extends StatelessWidget {
  const PesachProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PesachProductsBloc bloc = context.read<PesachProductsBloc>();
    return BlocBuilder<PesachProductsBloc, PesachProductsState>(builder: (context, state) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: !state.isGuestUser ? floatingButtonWidget(context, state) : 0.width,
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.pesach_products,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () {
              Navigator.pop(context);
            },
            trailingWidget: GestureDetector(
                onTap: () {
                  context.read<PesachProductsBloc>().add(const PesachProductsEvent.getGridListView());
                },
                child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
          ),
        ),
        body: FocusDetector(
          onFocusGained: () {
            bloc.add(const PesachProductsEvent.getCartCountEvent());
            bloc.add(PesachProductsEvent.getPermissionList(context: context));
          },
          child: SafeArea(
            child: NotificationListener<ScrollNotification>(
                child: Stack(children: [
                  Column(children: [
                    100.height,
                    Expanded(
                      child: SmartRefresher(
                        physics: const ClampingScrollPhysics(),
                        enablePullDown: true,
                        controller: state.refreshController,
                        header: const RefreshWidget(),
                        footer: CustomFooter(
                          builder: (context, mode) =>
                              state.isGridView ? const SupplierProductsScreenShimmerWidget() : const StoreCategoryScreenSubcategoryShimmerWidget(),
                        ),
                        enablePullUp: !state.isBottomOfProducts,
                        onRefresh: () {
                          context.read<PesachProductsBloc>().add(PesachProductsEvent.refreshListEvent(context: context));
                          context.read<PesachProductsBloc>().add(const PesachProductsEvent.getPreferencesDataEvent());
                        },
                        onLoading: () {
                          context
                              .read<PesachProductsBloc>()
                              .add(PesachProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
                        },
                        child: SingleChildScrollView(
                          physics: state.productList.isEmpty ? const NeverScrollableScrollPhysics() : null,
                          child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            state.isShimmering
                                ? state.isGridView
                                    ? const SupplierProductsScreenShimmerWidget()
                                    : const StoreCategoryScreenSubcategoryShimmerWidget()
                                : state.productList.isEmpty
                                    ? Container(
                                        height: getScreenHeight(context) - 80,
                                        width: getScreenWidth(context),
                                        alignment: Alignment.center,
                                        child: noDataWidget(AppLocalizations.of(context)!.no_product))
                                    : state.isGridView
                                        ? gridViewWidget(context, state)
                                        : listViewWidget(context, state)
                          ]),
                        ),
                      ),
                    ),
                  ]),
                  searchWidget(context, bloc, state),
                ]),
                onNotification: (notification) {
                  if (notification.metrics.pixels > (notification.metrics.maxScrollExtent - 400)) {
                    if (!state.isBottomOfProducts) {
                      context
                          .read<PesachProductsBloc>()
                          .add(PesachProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
                    } else {
                      return false;
                    }
                  }
                  return true;
                }),
          ),
        ),
      );
    });
  }

  String getProductId(PesachProductsState state, int index) {
    return state.productList[index].id ?? '';
  }

  int getMinQty(PesachProductsState state, int index) {
    return int.parse(state.productList[index].sale?.saleMinQuantity ?? '0');
  }

  void updateQty(BuildContext context, PesachProductsState state, int index) {
    final product = state.productList[index];
    final stock = state.productStockList[1][index];

    context.read<PesachProductsBloc>().add(PesachProductsEvent.updateListQuantityOfProduct(
        context: context,
        quantity: stock.quantity.toString(),
        productListIndex: 1,
        productStockUpdateIndex: index,
        productSupplierIds: product.supplierId.toString()));
  }

  void handleIncrease(BuildContext context, PesachProductsState state, int index) {
    if (state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    final product = state.productList[index];
    final stock = state.productStockList[1][index];
    final minQty = getMinQty(state, index);
    final isMixedSale = product.sale?.isMixedSale ?? false;

    if (!isMixedSale && minQty <= stock.quantity + 1) {
      context.read<PesachProductsBloc>().add(PesachProductsEvent.increaseListQuantityOfProduct(
          context: context, productListIndex: 1, productStockUpdateIndex: index, productSupplierIds: product.supplierId.toString()));

      context.read<PesachProductsBloc>().add(PesachProductsEvent.addToCartListProductEvent(
          context: context,
          productId: getProductId(state, index),
          productListIndex: 1,
          productStockUpdateIndex: index,
          productSupplierIds: product.supplierId.toString()));
    } else {
      showMinMaxQtyConfirmDialog(context: context, productId: product.id.toString(), index: index, productListIndex: 1, isIncrease: true);
    }
  }

  void handleDecrease(BuildContext context, PesachProductsState state, int index) {
    if (state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    final product = state.productList[index];
    final stock = state.productStockList[1][index];
    final minQty = getMinQty(state, index);
    final isMixedSale = product.sale?.isMixedSale ?? false;

    if (stock.quantity == 0) return;

    if (!isMixedSale && minQty <= stock.quantity - 1) {
      context.read<PesachProductsBloc>().add(PesachProductsEvent.decreaseListQuantityOfProduct(
          context: context, productListIndex: 1, productStockUpdateIndex: index, productSupplierIds: product.supplierId.toString()));

      context.read<PesachProductsBloc>().add(PesachProductsEvent.addToCartListProductEvent(
          context: context,
          productId: getProductId(state, index),
          productListIndex: 1,
          productStockUpdateIndex: index,
          productSupplierIds: product.supplierId.toString()));
    } else {
      showMinMaxQtyConfirmDialog(context: context, productId: product.id.toString(), index: index, productListIndex: 1, isIncrease: false);
    }
  }

  Widget gridViewWidget(BuildContext context, PesachProductsState state) => GridView.builder(
      itemCount: state.productList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: getChildAspectRatio(context, state.isSaleOn)),
      itemBuilder: (context, index) {
        final gridProductData = state.productList[index];
        final productStockData = state.productStockList[1][index];

        return CommonProductSaleItemWidget(
            isSale: gridProductData.sale?.isSale,
            isGuestUser: state.isGuestUser,
            onGuestLoginRequired: () => Navigator.pushNamed(context, RouteDefine.connectScreen.name),
            height: AppConstants.salesProductItemHeight,
            width: 140,
            productName: gridProductData.productName ?? '',
            saleImage: gridProductData.mainImage ?? '',
            title: gridProductData.name,
            description: parse(gridProductData.sale?.saleDescription ?? '').body?.text ?? '',
            discountedPrice: double.parse(gridProductData.sale?.salePrice ?? '0'),
            originalPrice: gridProductData.productPrice ?? 0,
            productStock: gridProductData.productStock.toString(),
            lowStock: gridProductData.lowStock ?? '',
            isPesach: gridProductData.isPesach,
            quantity: productStockData.quantity,
            minQuantity: gridProductData.sale?.saleMinQuantity,
            maxQuantity: gridProductData.sale?.saleMaxQuantity,
            isMixedSale: gridProductData.sale?.isMixedSale,
            numberOfUnits: gridProductData.numberOfUnit.toString(),
            scaleType: gridProductData.scaleType,
            onQuantityChanged: () => updateQty(context, state, index),
            onQuantityIncreaseTap: () => handleIncrease(context, state, index),
            onQuantityDecreaseTap: () => handleDecrease(context, state, index),
            onButtonTap: () {
              if (!state.isGuestUser) {
                showProductDetails(
                    context: context,
                    productListIndex: 1,
                    productId: gridProductData.id ?? '',
                    productStock: gridProductData.productStock.toString(),
                    isSaleOn: state.isSaleOn,
                    maxQty: int.parse(gridProductData.sale?.saleMaxQuantity ?? '0'));
              } else {
                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
              }
            });
      });

  Widget listViewWidget(BuildContext context, PesachProductsState state) => ListView.builder(
      itemCount: state.productList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
      itemBuilder: (context, index) {
        final listProductData = state.productList[index];
        final productStockData = state.productStockList[1][index];

        return CommonSaleListView(
            context: context,
            isFromSale: listProductData.sale?.isSale,
            salesDesc: listProductData.sale?.saleDescription,
            isPesach: listProductData.isPesach,
            lowStock: listProductData.lowStock.toString(),
            isGuestUser: state.isGuestUser,
            numberOfUnits: listProductData.numberOfUnit ?? '0',
            scaleType: listProductData.scaleType,
            productStock: listProductData.productStock.toString(),
            productImage: listProductData.mainImage ?? '',
            productName: listProductData.productName ?? '',
            price: double.parse(listProductData.productPrice.toString()),
            discountedPrice: double.parse(listProductData.sale?.salePrice ?? '0'),
            quantity: productStockData.quantity,
            minQuantity: listProductData.sale?.saleMinQuantity,
            maxQuantity: listProductData.sale?.saleMaxQuantity,
            isMixedSale: listProductData.sale?.isMixedSale,
            onQuantityChanged: () => updateQty(context, state, index),
            onQuantityIncreaseTap: () => handleIncrease(context, state, index),
            onQuantityDecreaseTap: () => handleDecrease(context, state, index),
            onButtonTap: () {
              if (!state.isGuestUser) {
                showProductDetails(
                    context: context,
                    productListIndex: 1,
                    productId: listProductData.id ?? '',
                    productStock: listProductData.productStock.toString(),
                    isSaleOn: state.isSaleOn);
              } else {
                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
              }
            });
      });

  Widget searchWidget(BuildContext context, PesachProductsBloc bloc, PesachProductsState state) => CommonSearchWidget(
      onCloseTap: () {
        bloc.add(const PesachProductsEvent.changeCategoryExpansion(isOpened: false));
        context.read<PesachProductsBloc>().add(PesachProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
      },
      isFilterTap: true,
      isCategoryExpand: state.isCategoryExpand,
      isSearching: state.isSearching,
      onFilterTap: () {
        bloc.add(const PesachProductsEvent.changeCategoryExpansion());
      },
      onSearchTap: () {
        if (state.searchController.text != '') {
          bloc.add(const PesachProductsEvent.changeCategoryExpansion(isOpened: true));
        }
      },
      onSearch: (String search) {
        if (search.length > 1) {
          bloc.add(const PesachProductsEvent.changeCategoryExpansion(isOpened: true));
          bloc.add(PesachProductsEvent.globalSearchEvent(context: context));
        }
      },
      onSearchSubmit: (String search) {
        Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name,
            arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()});
      },
      onOutSideTap: () {
        state.searchController.clear();
        bloc.add(const PesachProductsEvent.changeCategoryExpansion(isOpened: false));
      },
      onSearchItemTap: () {
        bloc.add(const PesachProductsEvent.changeCategoryExpansion());
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
                    var productSearchData = state.searchList[index];
                    var productStockData = state.productStockList[0][index];
                    return SearchItemWidget(
                        isShowSeeAll: index == state.searchList.length - 1 ? true : false,
                        salePrice: productSearchData.salePrice,
                        saleDesc: productSearchData.salesDesc,
                        isPesach: productSearchData.isPesach,
                        lowStock: productSearchData.lowStock.toString(),
                        isGuestUser: state.isGuestUser,
                        numberOfUnits: productSearchData.numberOfUnits,
                        scaleType: productSearchData.scaleType,
                        priceOfBox: productSearchData.priceOfBox,
                        productStock: productSearchData.productStock.toString(),
                        context: context,
                        searchName: productSearchData.name,
                        searchImage: productSearchData.image,
                        searchType: productSearchData.searchType,
                        isMoreResults: state.searchList.where((search) => search.searchType == productSearchData.searchType).toList().isNotEmpty,
                        isLastItem: state.searchList.length - 1 == index,
                        quantity: productStockData.quantity,
                        isSale: productSearchData.isSale,
                        minQuantity: productSearchData.saleMinQuantity,
                        maxQuantity: productSearchData.saleMaxQuantity,
                        isMixedSale: productSearchData.isMixedSale,
                        onQuantityChanged: () {
                          context.read<PesachProductsBloc>().add(PesachProductsEvent.updateListQuantityOfProduct(
                              context: context,
                              quantity: productStockData.quantity.toString(),
                              productListIndex: 0,
                              productStockUpdateIndex: index,
                              productSupplierIds: productSearchData.supplierId.toString()));
                        },
                        onQuantityIncreaseTap: () {
                          if (!(productSearchData.isMixedSale ?? false) &&
                              int.parse(productSearchData.saleMinQuantity ?? '0') <= productStockData.quantity + 1) {
                            context.read<PesachProductsBloc>().add(PesachProductsEvent.increaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: productSearchData.supplierId.toString()));

                            context.read<PesachProductsBloc>().add(PesachProductsEvent.addToCartListProductEvent(
                                context: context,
                                productId: productSearchData.searchId,
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: productSearchData.supplierId.toString()));
                          } else {
                            showMinMaxQtyConfirmDialog(
                                context: context, productId: productSearchData.searchId, index: index, productListIndex: 0, isIncrease: true);
                          }
                        },
                        onQuantityDecreaseTap: () {
                          if (productStockData.quantity != 0) {
                            if (!(productSearchData.isMixedSale ?? false) &&
                                int.parse(productSearchData.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                              context.read<PesachProductsBloc>().add(PesachProductsEvent.decreaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: productSearchData.supplierId.toString()));

                              context.read<PesachProductsBloc>().add(PesachProductsEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: productSearchData.searchId,
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: productSearchData.supplierId.toString()));
                            } else {
                              showMinMaxQtyConfirmDialog(
                                  context: context, productId: productSearchData.searchId, index: index, productListIndex: 0, isIncrease: false);
                            }
                          }
                        },
                        isShowSearchLabel: index == 0
                            ? true
                            : productSearchData.searchType != state.searchList[index - 1].searchType
                                ? true
                                : false,
                        onSeeAllTap: () async {
                          if (productSearchData.searchType == SearchTypes.category) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.productCategoryScreen.name, arguments: {
                              AppStrings.searchString: state.search,
                              AppStrings.reqSearchString: state.search,
                              AppStrings.searchResultString: state.searchList
                            });
                            if (searchResult != null) {
                              bloc.add(PesachProductsEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else if (productSearchData.searchType == SearchTypes.subCategory) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: productSearchData.categoryId,
                              AppStrings.categoryNameString: productSearchData.categoryName,
                              AppStrings.searchString: state.search,
                              AppStrings.searchResultString: state.searchList
                            });
                            if (searchResult != null) {
                              bloc.add(PesachProductsEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            productSearchData.searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyScreen.name, arguments: {AppStrings.searchString: state.search})
                                : productSearchData.searchType == SearchTypes.supplier
                                    ? Navigator.pushNamed(context, RouteDefine.supplierScreen.name,
                                        arguments: {AppStrings.searchString: state.search})
                                    : productSearchData.searchType == SearchTypes.sale
                                        ? Navigator.pushNamed(context, RouteDefine.productSaleScreen.name,
                                            arguments: {AppStrings.searchString: state.search})
                                        : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                            AppStrings.searchString: state.search,
                                            AppStrings.searchType: SearchTypes.product.toString()
                                          });
                          }
                        },
                        onTap: () async {
                          if (productSearchData.searchType == SearchTypes.subCategory) {
                            inProgressSnackBarWidget(context);
                            return;
                          }
                          if (productSearchData.searchType == SearchTypes.sale || productSearchData.searchType == SearchTypes.product) {
                            if (!state.isGuestUser) {
                              showProductDetails(
                                  productListIndex: 0,
                                  context: context,
                                  productStock: productSearchData.productStock.toString(),
                                  productId: productSearchData.searchId,
                                  isBarcode: true,
                                  isSaleOn: state.isSaleOn);
                            } else {
                              Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                            }
                          } else if (productSearchData.searchType == SearchTypes.category) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: productSearchData.searchId,
                              AppStrings.categoryNameString: productSearchData.name,
                              AppStrings.searchString: state.searchController.text,
                              AppStrings.searchResultString: state.searchList
                            });
                            if (searchResult != null) {
                              bloc.add(PesachProductsEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            productSearchData.searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name,
                                    arguments: {AppStrings.companyIdString: productSearchData.searchId})
                                : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name,
                                    arguments: {AppStrings.supplierIdString: productSearchData.searchId});
                          }
                          bloc.add(const PesachProductsEvent.changeCategoryExpansion());
                        });
                  }),
      onScanTap: () async {
        String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
        if (scanResult != '-1') {
          if (!state.isGuestUser) {
            showProductDetails(
                context: context, productListIndex: 0, productId: scanResult, isBarcode: true, productStock: '1', isSaleOn: state.isSaleOn);
          } else {
            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
          }
        }
      });

  void showProductDetails(
      {required BuildContext context,
      required String productId,
      required int productListIndex,
      int maxQty = 0,
      bool? isBarcode,
      String productStock = '0',
      required bool isSaleOn}) async {
    context.read<PesachProductsBloc>().add(PesachProductsEvent.getProductDetailsEvent(
        context: context, productId: productId, productListIndex: productListIndex, isBarcode: isBarcode ?? false));
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
                minChildSize: productStock == '0' || productStock == '0.0'
                    ? 0.9
                    : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                initialChildSize: productStock == '0' || productStock == '0.0'
                    ? 0.9
                    : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                builder: (BuildContext context1, ScrollController scrollController) {
                  return BlocProvider.value(
                    value: context.read<PesachProductsBloc>(),
                    child: BlocBuilder<PesachProductsBloc, PesachProductsState>(builder: (blocContext, state) {
                      if (state.isProductLoading) {
                        return Container(
                            height: getScreenHeight(blocContext),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                                color: AppColors.whiteColor),
                            child: const ProductDetailsShimmerWidget());
                      }
                      if (state.productDetails.isEmpty) {
                        return Container(
                            height: getScreenHeight(blocContext),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                                color: AppColors.whiteColor),
                            child: NoDataBottomSheet(dialogContext: context));
                      }

                      var productDetailsData = state.productDetails.first;
                      var productStockData = state.productStockList[state.productListIndex][state.productStockUpdateIndex];

                      return Container(
                        height: getScreenHeight(blocContext),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                            color: AppColors.whiteColor),
                        child: SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: Column(children: [
                            CommonProductDetailsWidget(
                                isIncludedVat: state.isIncludedVat,
                                productDetails: state.productDetails,
                                isSubUserAddToBasket: state.isSubUserAddToBasket,
                                totalBottleDeposit: (state.bottleDeposit * (productDetailsData.numberOfUnit ?? 1) * productStockData.quantity),
                                bottleTax: state.bottleDeposit,
                                isBottle: productDetailsData.isBottle ?? false,
                                addToOrderTap: () {
                                  final isMixedSale = productDetailsData.sale?.isMixedSale ?? false;
                                  if (!isMixedSale && int.parse(productDetailsData.sale!.saleMinQuantity!) <= productStockData.quantity) {
                                    context
                                        .read<PesachProductsBloc>()
                                        .add(PesachProductsEvent.addToCartProductEvent(context: context1, productId: productId));
                                  } else {
                                    showMinQtyConfirmDialog(context, productId, initialQuantity: productStockData.quantity);
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
                                                  child: state.productDetails[state.imageIndex].mainImage != ''
                                                      ? PhotoView(
                                                          imageProvider: NetworkImage(
                                                              '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}'),
                                                        )
                                                      : const SizedBox()),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(dialogContext);
                                              },
                                              child: Padding(
                                                  padding: const EdgeInsets.only(top: AppConstants.padding_10),
                                                  child: Icon(Icons.close, color: AppColors.whiteColor)),
                                            ),
                                          ]),
                                        );
                                      });
                                },
                                context: context,
                                productImages: [productDetailsData.mainImage ?? ''],
                                productUnitPrice: double.parse(productDetailsData.supplierSales?.first.productPrice.toString() ?? '0'),
                                scaleType: productDetailsData.scaleType,
                                productPrice: (productDetailsData.sale?.isSale ?? false)
                                    ? double.parse(productDetailsData.sale?.salePrice ?? '') *
                                        productStockData.quantity *
                                        (productDetailsData.numberOfUnit ?? 1)
                                    : productStockData.totalPrice * productStockData.quantity * (productDetailsData.numberOfUnit ?? 1),
                                productStock: (productStockData.stock.toString()),
                                scrollController: scrollController,
                                productQuantity: productStockData.quantity,
                                isMixedSale: productDetailsData.sale!.isMixedSale,
                                recommendedRetailConsumerPricerOffer: ClubAgent.isClubClient(state.clubAgentId)
                                    ? productDetailsData.sale?.isSale == true
                                        ? productDetailsData.recommendedConsumerOffer
                                        : productDetailsData.recommendedRetailPrice
                                    : '',
                                onQuantityChanged: (quantity) {
                                  context
                                      .read<PesachProductsBloc>()
                                      .add(PesachProductsEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                },
                                onQuantityIncreaseTap: () {
                                  context.read<PesachProductsBloc>().add(PesachProductsEvent.increaseQuantityOfProduct(context: context1));
                                },
                                onQuantityDecreaseTap: () {
                                  if (productStockData.quantity > 1) {
                                    context.read<PesachProductsBloc>().add(PesachProductsEvent.decreaseQuantityOfProduct(context: context1));
                                  }
                                },
                                onCloseTap: () async {
                                  context
                                      .read<PesachProductsBloc>()
                                      .add(PesachProductsEvent.getSupplierProductsListEvent(context: context1, searchType: state.searchType));
                                  Navigator.pop(context1);
                                }),
                            state.isRelatedShimmering
                                ? const RelatedProductShimmerWidget()
                                : state.relatedProductList.isEmpty
                                    ? 0.width
                                    : relatedProductWidget(context1, state.relatedProductList, context, isSaleOn,
                                        productStockList: state.productStockList),
                            10.height
                          ]),
                        ),
                      );
                    }),
                  );
                }),
          );
        });
  }

  Widget relatedProductWidget(BuildContext prevContext, List<RelatedProductDatum> relatedProductList, BuildContext context, bool isSaleOn,
      {required List<List<ProductStockModel>> productStockList}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
      relatedProductTitle(context),
      Container(
        height: getItemHeight(context, isSaleOn),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2, i) {
              return CommonProductSaleItemWidget(
                  isSale: relatedProductList.elementAt(i).sale?.isSale,
                  isGuestUser: context.read<PesachProductsBloc>().state.isGuestUser,
                  onGuestLoginRequired: () => Navigator.pushNamed(context, RouteDefine.connectScreen.name),
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
                  quantity: productStockList[2]
                      .firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id)
                      .quantity,
                  minQuantity: relatedProductList.elementAt(i).sale?.saleMinQuantity,
                  maxQuantity: relatedProductList.elementAt(i).sale?.saleMaxQuantity,
                  isMixedSale: relatedProductList.elementAt(i).sale?.isMixedSale,
                  numberOfUnits: relatedProductList.elementAt(i).numberOfUnit.toString(),
                  scaleType: relatedProductList.elementAt(i).scaleType,
                  onQuantityChanged: () {
                    context.read<PesachProductsBloc>().add(PesachProductsEvent.updateListQuantityOfProduct(
                        context: context,
                        quantity: productStockList[2]
                            .firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id)
                            .quantity
                            .toString(),
                        productListIndex: 2,
                        productStockUpdateIndex: productStockList[2]
                            .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                        productSupplierIds: relatedProductList[i].supplierId.toString()));
                  },
                  onQuantityIncreaseTap: () {
                    if (!(relatedProductList[i].sale?.isMixedSale ?? false) &&
                        int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <=
                            productStockList[2]
                                    .firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id)
                                    .quantity +
                                1) {
                      context.read<PesachProductsBloc>().add(PesachProductsEvent.increaseListQuantityOfProduct(
                          context: context,
                          productListIndex: 2,
                          productStockUpdateIndex: productStockList[2]
                              .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString()));

                      context.read<PesachProductsBloc>().add(PesachProductsEvent.addToCartListProductEvent(
                          context: context,
                          productId: relatedProductList[i].id.toString(),
                          productListIndex: 2,
                          productStockUpdateIndex: productStockList[2]
                              .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString()));
                    } else {
                      showMinMaxQtyConfirmDialog(
                          context: context,
                          productId: relatedProductList[i].id.toString(),
                          index: productStockList[2]
                              .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                          productListIndex: 2,
                          isIncrease: true);
                    }
                  },
                  onQuantityDecreaseTap: () {
                    if (productStockList[2]
                            .firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id)
                            .quantity !=
                        0) {
                      if (!(relatedProductList[i].sale?.isMixedSale ?? false) &&
                          int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <=
                              productStockList[2]
                                      .firstWhere(
                                          (relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id)
                                      .quantity -
                                  1) {
                        context.read<PesachProductsBloc>().add(PesachProductsEvent.decreaseListQuantityOfProduct(
                            context: context,
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2]
                                .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString()));

                        context.read<PesachProductsBloc>().add(PesachProductsEvent.addToCartListProductEvent(
                            context: context,
                            productId: relatedProductList[i].id.toString(),
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2]
                                .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString()));
                      } else {
                        showMinMaxQtyConfirmDialog(
                            context: context,
                            productId: relatedProductList[i].id.toString(),
                            index: productStockList[2]
                                .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            productListIndex: 2,
                            isIncrease: false);
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
                        productStock: (relatedProductList[i].productStock.toString()));
                  });
            },
            itemCount: relatedProductList.length),
      )
    ]);
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, {int? initialQuantity}) {
    _openSalePromotionSheet(context, productId, initialQuantity: initialQuantity, closeParentBeforeOpen: true);
  }

  void showMinMaxQtyConfirmDialog(
      {required BuildContext context,
      required String productId,
      required int index,
      required int productListIndex,
      required bool isIncrease,
      int? initialQuantity}) {
    final stockState = context.read<PesachProductsBloc>().state;
    int? qty = initialQuantity;
    try {
      final current = stockState.productStockList[productListIndex][index].quantity;
      qty ??= isIncrease ? current + 1 : (current > 0 ? current - 1 : 0);
    } catch (_) {}
    _openSalePromotionSheet(context, productId, initialQuantity: qty);
  }

  Future<void> _openSalePromotionSheet(BuildContext context, String productId, {int? initialQuantity, bool closeParentBeforeOpen = false}) async {
    final PesachProductsBloc bloc = context.read<PesachProductsBloc>();
    if (bloc.state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    if (closeParentBeforeOpen && context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (!context.mounted) return;
    final bool changed = await showSalePromotionSheet(context: context, productId: productId, l10n: l10n, initialQuantity: initialQuantity);
    if (!changed || !context.mounted) return;
    final cartMap = await fetchCartQuantities(context);
    if (!context.mounted) return;
    bloc.add(PesachProductsEvent.applyCartQuantitiesEvent(cartQuantities: cartMap));
    bloc.add(PesachProductsEvent.getCartCountNoEvent(context: context));
  }

  Widget floatingButtonWidget(BuildContext context, PesachProductsState state) => FloatingActionButton(
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
                            border: Border.all(color: AppColors.whiteColor, width: 1)),
                        child:
                            Text('${state.cartCount}', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.whiteColor))),
                  ]),
                )
              : 0.width,
          SizedBox(
            height: 50,
            width: 25,
            child: Visibility(
              visible: state.duringCelebration,
              child: IgnorePointer(
                  child: Confetti(isStopped: !state.duringCelebration, snippingCount: 10, snipSize: 3.0, colors: [AppColors.mainColor])),
            ),
          ),
        ]),
      );
}
