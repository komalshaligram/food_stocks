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
import '../../ui/widget/common_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../ui/widget/supplier_products_screen_shimmer_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_sale_item_widget.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/confetti.dart';
import '../widget/custom_dialog.dart';
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
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => PesachProductsBloc()
        ..add(PesachProductsEvent.getSupplierProductsListEvent(
            context: context, searchType: args?[AppStrings.searchType] ?? ''))
        ..add(PesachProductsEvent.userApproveEvent(context: context))
        ..add(const PesachProductsEvent.getPreferencesDataEvent()),
      child: const PesachProductsScreenWidget(),
    );
  }
}

class PesachProductsScreenWidget extends StatelessWidget {
  const PesachProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PesachProductsBloc bloc = context.read<PesachProductsBloc>();
    return BlocListener<PesachProductsBloc, PesachProductsState>(
      listener: (context, state) {},
      child: BlocBuilder<PesachProductsBloc, PesachProductsState>(
          builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
          floatingActionButton: !state.isGuestUser
              ? floatingButtonWidget(context, state)
              : 0.width,
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
                    context
                        .read<PesachProductsBloc>()
                        .add(const PesachProductsEvent.getGridListView());
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
                            builder: (context, mode) => state.isGridView
                                ? const SupplierProductsScreenShimmerWidget()
                                : const StoreCategoryScreenSubcategoryShimmerWidget(),
                          ),
                          enablePullUp: !state.isBottomOfProducts,
                          onRefresh: () {
                            context.read<PesachProductsBloc>().add(
                                PesachProductsEvent.refreshListEvent(
                                    context: context));
                            context.read<PesachProductsBloc>().add(
                                const PesachProductsEvent
                                    .getPreferencesDataEvent());
                          },
                          onLoading: () {
                            context.read<PesachProductsBloc>().add(
                                PesachProductsEvent
                                    .getSupplierProductsListEvent(
                                        context: context,
                                        searchType: state.searchType));
                          },
                          child: SingleChildScrollView(
                            physics: state.productList.isEmpty
                                ? const NeverScrollableScrollPhysics()
                                : null,
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  state.isShimmering
                                      ? state.isGridView
                                          ? const SupplierProductsScreenShimmerWidget()
                                          : const StoreCategoryScreenSubcategoryShimmerWidget()
                                      : state.productList.isEmpty
                                          ? Container(
                                              height:
                                                  getScreenHeight(context) - 80,
                                              width: getScreenWidth(context),
                                              alignment: Alignment.center,
                                              child: noDataWidget(
                                                  AppLocalizations.of(context)!
                                                      .no_product),
                                            )
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
                    if (notification.metrics.pixels >
                        (notification.metrics.maxScrollExtent - 400)) {
                      if (!state.isBottomOfProducts) {
                        context.read<PesachProductsBloc>().add(
                            PesachProductsEvent.getSupplierProductsListEvent(
                                context: context,
                                searchType: state.searchType));
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

  String getProductId(PesachProductsState state, int index) {
    return state.productList[index].id ?? '';
  }

  int getMinQty(PesachProductsState state, int index) {
    return int.parse(state.productList[index].sale?.saleMinQuantity ?? '0');
  }

  void updateQty(BuildContext context, PesachProductsState state, int index) {
    final product = state.productList[index];
    final stock = state.productStockList[1][index];

    context
        .read<PesachProductsBloc>()
        .add(PesachProductsEvent.updateListQuantityOfProduct(
          context: context,
          quantity: stock.quantity.toString(),
          productListIndex: 1,
          productStockUpdateIndex: index,
          productSupplierIds: product.supplierId.toString(),
        ));
  }

  void handleIncrease(
      BuildContext context, PesachProductsState state, int index) {
    if (state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    final product = state.productList[index];
    final stock = state.productStockList[1][index];
    final minQty = getMinQty(state, index);

    if (minQty <= stock.quantity + 1) {
      context
          .read<PesachProductsBloc>()
          .add(PesachProductsEvent.increaseListQuantityOfProduct(
            context: context,
            productListIndex: 1,
            productStockUpdateIndex: index,
            productSupplierIds: product.supplierId.toString(),
          ));

      context
          .read<PesachProductsBloc>()
          .add(PesachProductsEvent.addToCartListProductEvent(
            context: context,
            productId: getProductId(state, index),
            productListIndex: 1,
            productStockUpdateIndex: index,
            productSupplierIds: product.supplierId.toString(),
          ));
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

  void handleDecrease(
      BuildContext context, PesachProductsState state, int index) {
    if (state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    final product = state.productList[index];
    final stock = state.productStockList[1][index];
    final minQty = getMinQty(state, index);

    if (stock.quantity == 0) return;

    if (minQty <= stock.quantity - 1) {
      context
          .read<PesachProductsBloc>()
          .add(PesachProductsEvent.decreaseListQuantityOfProduct(
            context: context,
            productListIndex: 1,
            productStockUpdateIndex: index,
            productSupplierIds: product.supplierId.toString(),
          ));

      context
          .read<PesachProductsBloc>()
          .add(PesachProductsEvent.addToCartListProductEvent(
            context: context,
            productId: getProductId(state, index),
            productListIndex: 1,
            productStockUpdateIndex: index,
            productSupplierIds: product.supplierId.toString(),
          ));
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

  Widget gridViewWidget(BuildContext context, PesachProductsState state) =>
      GridView.builder(
          itemCount: state.productList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: getChildAspectRatio(context, state.isSaleOn)),
          itemBuilder: (context, index) {
            final product = state.productList[index];
            final stock = state.productStockList[1][index];

            return CommonProductSaleItemWidget(
                isSale: product.sale?.isSale,
                isGuestUser: state.isGuestUser,
                onGuestLoginRequired: () => Navigator.pushNamed(
                    context, RouteDefine.connectScreen.name),
                height: AppConstants.salesProductItemHeight,
                width: 140,
                productName: product.productName ?? '',
                saleImage: product.mainImage ?? '',
                title: product.name,
                description:
                    parse(product.sale?.saleDescription ?? '').body?.text ?? '',
                discountedPrice: double.parse(product.sale?.salePrice ?? '0'),
                originalPrice: product.productPrice ?? 0,
                productStock: product.productStock.toString(),
                lowStock: product.lowStock ?? '',
                isPesach: product.isPesach,
                quantity: stock.quantity,
                minQuantity: product.sale?.saleMinQuantity,
                maxQuantity: product.sale?.saleMaxQuantity,
                isMixedSale: product.sale?.isMixedSale,
                numberOfUnits: product.numberOfUnit.toString(),
                scaleType: product.scaleType,
                onQuantityChanged: () => updateQty(context, state, index),
                onQuantityIncreaseTap: () =>
                    handleIncrease(context, state, index),
                onQuantityDecreaseTap: () =>
                    handleDecrease(context, state, index),
                onButtonTap: () {
                  if (!state.isGuestUser) {
                    showProductDetails(
                      context: context,
                      productListIndex: 1,
                      productId: product.id ?? '',
                      productStock: product.productStock.toString(),
                      isSaleOn: state.isSaleOn,
                      maxQty: int.parse(product.sale?.saleMaxQuantity ?? '0'),
                    );
                  } else {
                    Navigator.pushNamed(
                        context, RouteDefine.connectScreen.name);
                  }
                });
          });

  Widget listViewWidget(BuildContext context, PesachProductsState state) =>
      ListView.builder(
          itemCount: state.productList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
          itemBuilder: (context, index) {
            final product = state.productList[index];
            final stock = state.productStockList[1][index];

            return CommonSaleListView(
                context: context,
                isFromSale: product.sale?.isSale,
                salesDesc: product.sale?.saleDescription,
                isPesach: product.isPesach,
                lowStock: product.lowStock.toString(),
                isGuestUser: state.isGuestUser,
                numberOfUnits: product.numberOfUnit ?? '0',
                scaleType: product.scaleType,
                productStock: product.productStock.toString(),
                productImage: product.mainImage ?? '',
                productName: product.productName ?? '',
                price: double.parse(product.productPrice.toString()),
                discountedPrice: double.parse(product.sale?.salePrice ?? '0'),
                quantity: stock.quantity,
                minQuantity: product.sale?.saleMinQuantity,
                maxQuantity: product.sale?.saleMaxQuantity,
                isMixedSale: product.sale?.isMixedSale,
                onQuantityChanged: () => updateQty(context, state, index),
                onQuantityIncreaseTap: () =>
                    handleIncrease(context, state, index),
                onQuantityDecreaseTap: () =>
                    handleDecrease(context, state, index),
                onButtonTap: () {
                  if (!state.isGuestUser) {
                    showProductDetails(
                      context: context,
                      productListIndex: 1,
                      productId: product.id ?? '',
                      productStock: product.productStock.toString(),
                      isSaleOn: state.isSaleOn,
                    );
                  } else {
                    Navigator.pushNamed(
                        context, RouteDefine.connectScreen.name);
                  }
                });
          });

  Widget buildSupplierProducts({
    required BuildContext context,
    required int index,
    required String productImage,
    required String productName,
    required double productPrice,
    required void Function() onPressed,
    required bool isRTL,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.15),
                blurRadius: AppConstants.blur_10),
          ]),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      padding: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_5,
          horizontal: AppConstants.padding_10),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: productImage.isNotEmpty
                  ? Image.network("${AppUrlEndPoints.baseFileUrl}$productImage",
                      height: 70, fit: BoxFit.fitHeight,
                      loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress?.cumulativeBytesLoaded !=
                          loadingProgress?.expectedTotalBytes) {
                        return CommonShimmerWidget(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppConstants.radius_10))),
                          ),
                        );
                      }
                      return child;
                    }, errorBuilder: (context, error, stackTrace) {
                      return Image.asset(AppImagePath.imageNotAvailable5,
                          height: 70,
                          width: double.maxFinite,
                          fit: BoxFit.cover);
                    })
                  : Image.asset(AppImagePath.imageNotAvailable5,
                      height: 70, width: double.maxFinite, fit: BoxFit.cover),
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
            Expanded(child: 0.width),
            5.height,
            Center(
              child: CommonProductButtonWidget(
                title:
                    "${AppLocalizations.of(context)!.currency}${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(AppConstants.amountFrLength)}",
                onPressed: onPressed,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_12,
              ),
            )
          ]),
    );
  }

  Widget searchWidget(BuildContext context, PesachProductsBloc bloc,
          PesachProductsState state) =>
      CommonSearchWidget(
          onCloseTap: () {
            bloc.add(const PesachProductsEvent.changeCategoryExpansion(
                isOpened: false));
            context.read<PesachProductsBloc>().add(
                PesachProductsEvent.getSupplierProductsListEvent(
                    context: context, searchType: state.searchType));
          },
          isFilterTap: true,
          isCategoryExpand: state.isCategoryExpand,
          isSearching: state.isSearching,
          onFilterTap: () {
            bloc.add(const PesachProductsEvent.changeCategoryExpansion());
          },
          onSearchTap: () {
            if (state.searchController.text != '') {
              bloc.add(const PesachProductsEvent.changeCategoryExpansion(
                  isOpened: true));
            }
          },
          onSearch: (String search) {
            if (search.length > 1) {
              bloc.add(const PesachProductsEvent.changeCategoryExpansion(
                  isOpened: true));
              bloc.add(PesachProductsEvent.globalSearchEvent(context: context));
            }
          },
          onSearchSubmit: (String search) {
            Navigator.pushNamed(
                context, RouteDefine.supplierProductsScreen.name,
                arguments: {
                  AppStrings.searchString: state.search,
                  AppStrings.searchType: SearchTypes.product.toString(),
                });
          },
          onOutSideTap: () {
            state.searchController.clear();
            bloc.add(const PesachProductsEvent.changeCategoryExpansion(
                isOpened: false));
          },
          onSearchItemTap: () {
            bloc.add(const PesachProductsEvent.changeCategoryExpansion());
          },
          controller: state.searchController,
          searchList: state.searchList,
          searchResultWidget: state.isSearching
              ? const SizedBox()
              : state.searchList.isEmpty
                  ? noDataWidget(
                      AppLocalizations.of(context)!.search_result_not_found)
                  : ListView.builder(
                      itemCount: state.searchList.length,
                      shrinkWrap: true,
                      itemBuilder: (listViewContext, index) {
                        return SearchItemWidget(
                            isShowSeeAll: index == state.searchList.length - 1
                                ? true
                                : false,
                            salePrice: state.searchList[index].salePrice,
                            saleDesc: state.searchList[index].salesDesc,
                            isPesach: state.searchList[index].isPesach,
                            lowStock:
                                state.searchList[index].lowStock.toString(),
                            isGuestUser: state.isGuestUser,
                            numberOfUnits:
                                state.searchList[index].numberOfUnits,
                            scaleType: state.searchList[index].scaleType,
                            priceOfBox: state.searchList[index].priceOfBox,
                            productStock:
                                state.searchList[index].productStock.toString(),
                            context: context,
                            searchName: state.searchList[index].name,
                            searchImage: state.searchList[index].image,
                            searchType: state.searchList[index].searchType,
                            isMoreResults: state.searchList
                                .where((search) =>
                                    search.searchType ==
                                    state.searchList[index].searchType)
                                .toList()
                                .isNotEmpty,
                            isLastItem: state.searchList.length - 1 == index,
                            quantity: state.productStockList[0][index].quantity,
                            isSale: state.searchList[index].isSale,
                            minQuantity:
                                state.searchList[index].saleMinQuantity,
                            maxQuantity:
                                state.searchList[index].saleMaxQuantity,
                            isMixedSale: state.searchList[index].isMixedSale,
                            onQuantityChanged: () {
                              context.read<PesachProductsBloc>().add(
                                      PesachProductsEvent
                                          .updateListQuantityOfProduct(
                                    context: context,
                                    quantity: state
                                        .productStockList[0][index].quantity
                                        .toString(),
                                    productListIndex: 0,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state
                                        .searchList[index].supplierId
                                        .toString(),
                                  ));
                            },
                            onQuantityIncreaseTap: () {
                              if (int.parse(
                                      state.searchList[index].saleMinQuantity ??
                                          '0') <=
                                  state.productStockList[0][index].quantity +
                                      1) {
                                context.read<PesachProductsBloc>().add(
                                        PesachProductsEvent
                                            .increaseListQuantityOfProduct(
                                      context: context,
                                      productListIndex: 0,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: state
                                          .searchList[index].supplierId
                                          .toString(),
                                    ));

                                context.read<PesachProductsBloc>().add(
                                        PesachProductsEvent
                                            .addToCartListProductEvent(
                                      context: context,
                                      productId:
                                          state.searchList[index].searchId,
                                      productListIndex: 0,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: state
                                          .searchList[index].supplierId
                                          .toString(),
                                    ));
                              } else {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: state.searchList[index].searchId,
                                  minBox: state
                                      .searchList[index].saleMinQuantity
                                      .toString(),
                                  index: index,
                                  supplierId: state.searchList[index].supplierId
                                      .toString(),
                                  productListIndex: 0,
                                  isIncrease: true,
                                  isMixedSale:
                                      state.searchList[index].isMixedSale,
                                  sameSaleProducts:
                                      state.searchList[index].sameSaleProducts,
                                );
                              }
                            },
                            onQuantityDecreaseTap: () {
                              if (state.productStockList[0][index].quantity !=
                                  0) {
                                if (int.parse(state.searchList[index]
                                            .saleMinQuantity ??
                                        '0') <=
                                    state.productStockList[0][index].quantity -
                                        1) {
                                  context.read<PesachProductsBloc>().add(
                                          PesachProductsEvent
                                              .decreaseListQuantityOfProduct(
                                        context: context,
                                        productListIndex: 0,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: state
                                            .searchList[index].supplierId
                                            .toString(),
                                      ));

                                  context.read<PesachProductsBloc>().add(
                                          PesachProductsEvent
                                              .addToCartListProductEvent(
                                        context: context,
                                        productId:
                                            state.searchList[index].searchId,
                                        productListIndex: 0,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: state
                                            .searchList[index].supplierId
                                            .toString(),
                                      ));
                                } else {
                                  showMinMaxQtyConfirmDialog(
                                    context: context,
                                    productId: state.searchList[index].searchId,
                                    minBox: state
                                        .searchList[index].saleMinQuantity
                                        .toString(),
                                    index: index,
                                    supplierId: state
                                        .searchList[index].supplierId
                                        .toString(),
                                    productListIndex: 0,
                                    isIncrease: false,
                                    isMixedSale:
                                        state.searchList[index].isMixedSale,
                                    sameSaleProducts: state
                                        .searchList[index].sameSaleProducts,
                                  );
                                }
                              }
                            },
                            isShowSearchLabel: index == 0
                                ? true
                                : state.searchList[index].searchType !=
                                        state.searchList[index - 1].searchType
                                    ? true
                                    : false,
                            onSeeAllTap: () async {
                              if (state.searchList[index].searchType ==
                                  SearchTypes.category) {
                                dynamic searchResult =
                                    await Navigator.pushNamed(context,
                                        RouteDefine.productCategoryScreen.name,
                                        arguments: {
                                      AppStrings.searchString: state.search,
                                      AppStrings.reqSearchString: state.search,
                                      AppStrings.searchResultString:
                                          state.searchList,
                                    });
                                if (searchResult != null) {
                                  bloc.add(PesachProductsEvent
                                      .updateGlobalSearchEvent(
                                    search:
                                        searchResult[AppStrings.searchString],
                                    searchList: searchResult[
                                        AppStrings.searchResultString],
                                  ));
                                }
                              } else if (state.searchList[index].searchType ==
                                  SearchTypes.subCategory) {
                                dynamic searchResult =
                                    await Navigator.pushNamed(context,
                                        RouteDefine.storeCategoryScreen.name,
                                        arguments: {
                                      AppStrings.categoryIdString:
                                          state.searchList[index].categoryId,
                                      AppStrings.categoryNameString:
                                          state.searchList[index].categoryName,
                                      AppStrings.searchString: state.search,
                                      AppStrings.searchResultString:
                                          state.searchList,
                                    });
                                if (searchResult != null) {
                                  bloc.add(PesachProductsEvent
                                      .updateGlobalSearchEvent(
                                    search:
                                        searchResult[AppStrings.searchString],
                                    searchList: searchResult[
                                        AppStrings.searchResultString],
                                  ));
                                }
                              } else {
                                state.searchList[index].searchType ==
                                        SearchTypes.company
                                    ? Navigator.pushNamed(
                                        context, RouteDefine.companyScreen.name,
                                        arguments: {
                                            AppStrings.searchString:
                                                state.search,
                                          })
                                    : state.searchList[index].searchType ==
                                            SearchTypes.supplier
                                        ? Navigator.pushNamed(context,
                                            RouteDefine.supplierScreen.name,
                                            arguments: {
                                                AppStrings.searchString:
                                                    state.search,
                                              })
                                        : state.searchList[index].searchType ==
                                                SearchTypes.sale
                                            ? Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .productSaleScreen.name,
                                                arguments: {
                                                    AppStrings.searchString:
                                                        state.search,
                                                  })
                                            : Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .supplierProductsScreen
                                                    .name,
                                                arguments: {
                                                    AppStrings.searchString:
                                                        state.search,
                                                    AppStrings.searchType:
                                                        SearchTypes.product
                                                            .toString(),
                                                  });
                              }
                            },
                            onTap: () async {
                              if (state.searchList[index].searchType ==
                                  SearchTypes.subCategory) {
                                inProgressSnackBarWidget(context);
                                return;
                              }
                              if (state.searchList[index].searchType ==
                                      SearchTypes.sale ||
                                  state.searchList[index].searchType ==
                                      SearchTypes.product) {
                                if (!state.isGuestUser) {
                                  showProductDetails(
                                    productListIndex: 0,
                                    context: context,
                                    productStock: state
                                        .searchList[index].productStock
                                        .toString(),
                                    productId: state.searchList[index].searchId,
                                    isBarcode: true,
                                    isSaleOn: state.isSaleOn,
                                  );
                                } else {
                                  Navigator.pushNamed(
                                      context, RouteDefine.connectScreen.name);
                                }
                              } else if (state.searchList[index].searchType ==
                                  SearchTypes.category) {
                                dynamic searchResult =
                                    await Navigator.pushNamed(context,
                                        RouteDefine.storeCategoryScreen.name,
                                        arguments: {
                                      AppStrings.categoryIdString:
                                          state.searchList[index].searchId,
                                      AppStrings.categoryNameString:
                                          state.searchList[index].name,
                                      AppStrings.searchString:
                                          state.searchController.text,
                                      AppStrings.searchResultString:
                                          state.searchList,
                                    });
                                if (searchResult != null) {
                                  bloc.add(PesachProductsEvent
                                      .updateGlobalSearchEvent(
                                    search:
                                        searchResult[AppStrings.searchString],
                                    searchList: searchResult[
                                        AppStrings.searchResultString],
                                  ));
                                }
                              } else {
                                state.searchList[index].searchType ==
                                        SearchTypes.company
                                    ? Navigator.pushNamed(context,
                                        RouteDefine.companyProductsScreen.name,
                                        arguments: {
                                            AppStrings.companyIdString: state
                                                .searchList[index].searchId,
                                          })
                                    : Navigator.pushNamed(context,
                                        RouteDefine.supplierProductsScreen.name,
                                        arguments: {
                                            AppStrings.supplierIdString: state
                                                .searchList[index].searchId,
                                          });
                              }
                              bloc.add(const PesachProductsEvent
                                  .changeCategoryExpansion());
                            });
                      }),
          onScanTap: () async {
            String scanResult = await scanBarcodeOrQRCode(
                context: context,
                cancelText: AppLocalizations.of(context)!.cancel,
                scanMode: ScanMode.BARCODE);
            if (scanResult != '-1') {
              if (!state.isGuestUser) {
                showProductDetails(
                    context: context,
                    productListIndex: 0,
                    productId: scanResult,
                    isBarcode: true,
                    productStock: '1',
                    isSaleOn: state.isSaleOn);
              } else {
                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
              }
            }
          });

  void showProductDetails({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    int maxQty = 0,
    bool? isBarcode,
    String productStock = '0',
    required bool isSaleOn,
  }) async {
    context
        .read<PesachProductsBloc>()
        .add(PesachProductsEvent.getProductDetailsEvent(
          context: context,
          productId: productId,
          productListIndex: productListIndex,
          isBarcode: isBarcode ?? false,
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
                maxChildSize: 1 -
                    (MediaQuery.of(context).viewPadding.top /
                        getScreenHeight(context) *
                        0.2),
                minChildSize: productStock == '0' || productStock == '0.0'
                    ? 0.9
                    : 1 -
                        (MediaQuery.of(context).viewPadding.top /
                            getScreenHeight(context) *
                            0.2),
                initialChildSize: productStock == '0' || productStock == '0.0'
                    ? 0.9
                    : 1 -
                        (MediaQuery.of(context).viewPadding.top /
                            getScreenHeight(context) *
                            0.2),
                builder:
                    (BuildContext context1, ScrollController scrollController) {
                  return BlocProvider.value(
                    value: context.read<PesachProductsBloc>(),
                    child: BlocBuilder<PesachProductsBloc, PesachProductsState>(
                        builder: (blocContext, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppConstants.radius_30),
                              topRight:
                                  Radius.circular(AppConstants.radius_30)),
                          color: AppColors.whiteColor,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: state.isProductLoading
                            ? const ProductDetailsShimmerWidget()
                            : state.productDetails.isEmpty
                                ? NoDataBottomSheet(dialogContext: context)
                                : SingleChildScrollView(
                                    controller:
                                        ModalScrollController.of(context),
                                    child: Column(children: [
                                      CommonProductDetailsWidget(
                                          isIncludedVat: state.isIncludedVat,
                                          productDetails: state.productDetails,
                                          isSubUserAddToBasket:
                                              state.isSubUserAddToBasket,
                                          totalBottleDeposit: (state.bottleDeposit *
                                              (state.productDetails.first.numberOfUnit ??
                                                  1) *
                                              state
                                                  .productStockList[state.productListIndex][state
                                                      .productStockUpdateIndex]
                                                  .quantity),
                                          bottleTax: state.bottleDeposit,
                                          isBottle: state.productDetails.first
                                                  .isBottle ??
                                              false,
                                          addToOrderTap: () {
                                            if (int.parse(state
                                                    .productDetails
                                                    .first
                                                    .sale!
                                                    .saleMinQuantity!) <=
                                                state
                                                    .productStockList[
                                                        state.productListIndex][
                                                        state
                                                            .productStockUpdateIndex]
                                                    .quantity) {
                                              context
                                                  .read<PesachProductsBloc>()
                                                  .add(PesachProductsEvent
                                                      .addToCartProductEvent(
                                                          context: context1,
                                                          productId:
                                                              productId));
                                            } else {
                                              showMinQtyConfirmDialog(
                                                context,
                                                productId,
                                                state.productDetails.first.sale!
                                                    .saleMinQuantity
                                                    .toString(),
                                                state.productDetails.first.sale!
                                                    .isMixedSale,
                                                state.productDetails.first.sale!
                                                    .sameSaleProducts,
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
                                                        height: getScreenHeight(
                                                                context) -
                                                            MediaQuery.of(
                                                                    context)
                                                                .padding
                                                                .top,
                                                        width: getScreenWidth(
                                                            context),
                                                        child: GestureDetector(
                                                          onVerticalDragStart:
                                                              (dragDetails) {},
                                                          onVerticalDragUpdate:
                                                              (dragDetails) {},
                                                          onVerticalDragEnd:
                                                              (endDetails) {
                                                            Navigator.pop(
                                                                dialogContext);
                                                          },
                                                          child: state
                                                                      .productDetails[
                                                                          state
                                                                              .imageIndex]
                                                                      .mainImage !=
                                                                  ''
                                                              ? PhotoView(
                                                                  imageProvider:
                                                                      NetworkImage(
                                                                    '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                dialogContext);
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                top: AppConstants
                                                                    .padding_10),
                                                            child: Icon(
                                                                Icons.close,
                                                                color: AppColors
                                                                    .whiteColor),
                                                          )),
                                                    ]),
                                                  );
                                                });
                                          },
                                          context: context,
                                          productImages: [
                                            state.productDetails.first
                                                    .mainImage ??
                                                ''
                                          ],
                                          productUnitPrice: double.parse(state
                                                  .productDetails
                                                  .first
                                                  .supplierSales
                                                  ?.first
                                                  .productPrice
                                                  .toString() ??
                                              '0'),
                                          scaleType: state
                                              .productDetails.first.scaleType,
                                          productPrice: (state.productDetails.first.sale?.isSale ?? false)
                                              ? double.parse(state.productDetails.first.sale?.salePrice ?? '') *
                                                  state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity *
                                                  (state.productDetails.first.numberOfUnit ?? 1)
                                              : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
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
                                            context
                                                .read<PesachProductsBloc>()
                                                .add(PesachProductsEvent
                                                    .updateQuantityOfProduct(
                                                        context: context1,
                                                        quantity: quantity));
                                          },
                                          onQuantityIncreaseTap: () {
                                            context
                                                .read<PesachProductsBloc>()
                                                .add(PesachProductsEvent
                                                    .increaseQuantityOfProduct(
                                                        context: context1));
                                          },
                                          onQuantityDecreaseTap: () {
                                            if (state
                                                    .productStockList[
                                                        state.productListIndex][
                                                        state
                                                            .productStockUpdateIndex]
                                                    .quantity >
                                                1) {
                                              context
                                                  .read<PesachProductsBloc>()
                                                  .add(PesachProductsEvent
                                                      .decreaseQuantityOfProduct(
                                                          context: context1));
                                            }
                                          },
                                          onCloseTap: () async {
                                            context
                                                .read<PesachProductsBloc>()
                                                .add(PesachProductsEvent
                                                    .getSupplierProductsListEvent(
                                                        context: context1,
                                                        searchType:
                                                            state.searchType));
                                            Navigator.pop(context1);
                                          }),
                                      state.isRelatedShimmering
                                          ? const RelatedProductShimmerWidget()
                                          : state.relatedProductList.isEmpty
                                              ? 0.width
                                              : relatedProductWidget(
                                                  context1,
                                                  state.relatedProductList,
                                                  context,
                                                  isSaleOn,
                                                  productStockList:
                                                      state.productStockList),
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

  Widget relatedProductWidget(
    BuildContext prevContext,
    List<RelatedProductDatum> relatedProductList,
    BuildContext context,
    bool isSaleOn, {
    required List<List<ProductStockModel>> productStockList,
  }) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          relatedProductTitle(context),
          Container(
            height: getItemHeight(context, isSaleOn),
            padding:
                const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context2, i) {
                return CommonProductSaleItemWidget(
                    isSale: relatedProductList.elementAt(i).sale?.isSale,
                    isGuestUser:
                        context.read<PesachProductsBloc>().state.isGuestUser,
                    onGuestLoginRequired: () => Navigator.pushNamed(
                        context, RouteDefine.connectScreen.name),
                    height: AppConstants.salesProductItemHeight,
                    width: getItemWidth(context),
                    productName:
                        relatedProductList.elementAt(i).productName ?? '',
                    saleImage: relatedProductList.elementAt(i).mainImage ?? '',
                    title: relatedProductList.elementAt(i).name,
                    description:
                        parse(relatedProductList.elementAt(i).sale?.saleDescription)
                                .body
                                ?.text ??
                            '',
                    discountedPrice: double.parse(
                        relatedProductList.elementAt(i).sale?.salePrice ?? '0'),
                    originalPrice: relatedProductList.elementAt(i).productPrice,
                    productStock:
                        relatedProductList.elementAt(i).productStock.toString(),
                    lowStock: relatedProductList.elementAt(i).lowStock ?? '',
                    isPesach: relatedProductList.elementAt(i).isPesach,
                    quantity: productStockList[2]
                        .firstWhere((relatedProductStockList) =>
                            relatedProductStockList.productId ==
                            relatedProductList.elementAt(i).id)
                        .quantity,
                    minQuantity:
                        relatedProductList.elementAt(i).sale?.saleMinQuantity,
                    maxQuantity:
                        relatedProductList.elementAt(i).sale?.saleMaxQuantity,
                    isMixedSale:
                        relatedProductList.elementAt(i).sale?.isMixedSale,
                    numberOfUnits:
                        relatedProductList.elementAt(i).numberOfUnit.toString(),
                    scaleType: relatedProductList.elementAt(i).scaleType,
                    onQuantityChanged: () {
                      context
                          .read<PesachProductsBloc>()
                          .add(PesachProductsEvent.updateListQuantityOfProduct(
                            context: context,
                            quantity: productStockList[2]
                                .firstWhere((relatedProductStockList) =>
                                    relatedProductStockList.productId ==
                                    relatedProductList.elementAt(i).id)
                                .quantity
                                .toString(),
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2]
                                .indexWhere((relatedProductStockList) =>
                                    relatedProductStockList.productId ==
                                    relatedProductList.elementAt(i).id),
                            productSupplierIds:
                                relatedProductList[i].supplierId.toString(),
                          ));
                    },
                    onQuantityIncreaseTap: () {
                      if (int.parse(
                              relatedProductList[i].sale?.saleMinQuantity ??
                                  '0') <=
                          productStockList[2]
                                  .firstWhere((relatedProductStockList) =>
                                      relatedProductStockList.productId ==
                                      relatedProductList.elementAt(i).id)
                                  .quantity +
                              1) {
                        context.read<PesachProductsBloc>().add(
                                PesachProductsEvent
                                    .increaseListQuantityOfProduct(
                              context: context,
                              productListIndex: 2,
                              productStockUpdateIndex: productStockList[2]
                                  .indexWhere((relatedProductStockList) =>
                                      relatedProductStockList.productId ==
                                      relatedProductList.elementAt(i).id),
                              productSupplierIds:
                                  relatedProductList[i].supplierId.toString(),
                            ));

                        context
                            .read<PesachProductsBloc>()
                            .add(PesachProductsEvent.addToCartListProductEvent(
                              context: context,
                              productId: relatedProductList[i].id.toString(),
                              productListIndex: 2,
                              productStockUpdateIndex: productStockList[2]
                                  .indexWhere((relatedProductStockList) =>
                                      relatedProductStockList.productId ==
                                      relatedProductList.elementAt(i).id),
                              productSupplierIds:
                                  relatedProductList[i].supplierId.toString(),
                            ));
                      } else {
                        showMinMaxQtyConfirmDialog(
                          context: context,
                          productId: relatedProductList[i].id.toString(),
                          minBox: relatedProductList
                                  .elementAt(i)
                                  .sale
                                  ?.saleMinQuantity
                                  .toString() ??
                              '0',
                          index: productStockList[2].indexWhere(
                              (relatedProductStockList) =>
                                  relatedProductStockList.productId ==
                                  relatedProductList.elementAt(i).id),
                          supplierId:
                              relatedProductList[i].supplierId.toString(),
                          productListIndex: 2,
                          isIncrease: true,
                          isMixedSale: relatedProductList[i].sale?.isMixedSale,
                          sameSaleProducts:
                              relatedProductList[i].sale?.sameSaleProducts,
                        );
                      }
                    },
                    onQuantityDecreaseTap: () {
                      if (productStockList[2]
                              .firstWhere((relatedProductStockList) =>
                                  relatedProductStockList.productId ==
                                  relatedProductList.elementAt(i).id)
                              .quantity !=
                          0) {
                        if (int.parse(
                                relatedProductList[i].sale?.saleMinQuantity ??
                                    '0') <=
                            productStockList[2]
                                    .firstWhere((relatedProductStockList) =>
                                        relatedProductStockList.productId ==
                                        relatedProductList.elementAt(i).id)
                                    .quantity -
                                1) {
                          context.read<PesachProductsBloc>().add(
                                  PesachProductsEvent
                                      .decreaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 2,
                                productStockUpdateIndex: productStockList[2]
                                    .indexWhere((relatedProductStockList) =>
                                        relatedProductStockList.productId ==
                                        relatedProductList.elementAt(i).id),
                                productSupplierIds:
                                    relatedProductList[i].supplierId.toString(),
                              ));

                          context.read<PesachProductsBloc>().add(
                                  PesachProductsEvent.addToCartListProductEvent(
                                context: context,
                                productId: relatedProductList[i].id.toString(),
                                productListIndex: 2,
                                productStockUpdateIndex: productStockList[2]
                                    .indexWhere((relatedProductStockList) =>
                                        relatedProductStockList.productId ==
                                        relatedProductList.elementAt(i).id),
                                productSupplierIds:
                                    relatedProductList[i].supplierId.toString(),
                              ));
                        } else {
                          showMinMaxQtyConfirmDialog(
                            context: context,
                            productId: relatedProductList[i].id.toString(),
                            minBox: relatedProductList
                                    .elementAt(i)
                                    .sale
                                    ?.saleMinQuantity
                                    .toString() ??
                                '0',
                            index: productStockList[2].indexWhere(
                                (relatedProductStockList) =>
                                    relatedProductStockList.productId ==
                                    relatedProductList.elementAt(i).id),
                            supplierId:
                                relatedProductList[i].supplierId.toString(),
                            productListIndex: 2,
                            isIncrease: false,
                            isMixedSale:
                                relatedProductList[i].sale?.isMixedSale,
                            sameSaleProducts:
                                relatedProductList[i].sale?.sameSaleProducts,
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
                        productStock:
                            (relatedProductList[i].productStock.toString()),
                      );
                    });
              },
              itemCount: relatedProductList.length,
            ),
          )
        ]);
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox,
      bool? isMixedSale, List? sameSaleProducts) {
    PesachProductsBloc bloc = context.read<PesachProductsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PesachProductsBloc>(),
        child: BlocBuilder<PesachProductsBloc, PesachProductsState>(
            builder: (context1, state) {
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
                bloc.add(PesachProductsEvent.addToCartProductEvent(
                    context: context, productId: productId));
              },
              positiveOnTap: () async {
                Navigator.pop(context);
                bloc.add(
                    PesachProductsEvent.getCartCountNoEvent(context: context));
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
    final bloc = context.read<PesachProductsBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<PesachProductsBloc, PesachProductsState>(
            builder: (context1, state) {
          final mixedSaleText = (isMixedSale ?? false)
              ? AppStrings.minSaleText(context, minBox)
              : AppStrings.otherSaleText(context, minBox);

          return CustomDialog(
            directionality: state.language,
            title: mixedSaleText,
            content: (isMixedSale ?? false) ? (sameSaleProducts ?? []) : [],
            isMixedSale: isMixedSale!,
            positiveTitle: AppLocalizations.of(context)!.closeText,
            negativeTitle: AppLocalizations.of(context)!.addText,
            negativeOnTap: () async {
              Navigator.pop(dialogContext);

              if (state.isGuestUser) {
                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                return;
              }

              if (isIncrease) {
                bloc.add(PesachProductsEvent.increaseListQuantityOfProduct(
                  context: context,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));
              } else {
                bloc.add(PesachProductsEvent.decreaseListQuantityOfProduct(
                  context: context,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));
              }

              bloc.add(PesachProductsEvent.addToCartListProductEvent(
                context: context,
                productId: productId,
                productListIndex: productListIndex,
                productStockUpdateIndex: index,
                productSupplierIds: supplierId,
              ));
            },
            positiveOnTap: () => Navigator.pop(dialogContext),
          );
        }),
      ),
    );
  }

  Widget floatingButtonWidget(
          BuildContext context, PesachProductsState state) =>
      FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name,
              arguments: {AppStrings.isBasketScreenString: 'true'});
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
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppConstants.radius_100)),
                        border:
                            Border.all(color: AppColors.whiteColor, width: 1),
                      ),
                      child: Text('${state.cartCount}',
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_10,
                              color: AppColors.whiteColor)),
                    ),
                  ]),
                )
              : 0.width,
          SizedBox(
            height: 50,
            width: 25,
            child: Visibility(
              visible: state.duringCelebration,
              child: IgnorePointer(
                  child: Confetti(
                      isStopped: !state.duringCelebration,
                      snippingCount: 10,
                      snipSize: 3.0,
                      colors: [AppColors.mainColor])),
            ),
          ),
        ]),
      );
}
