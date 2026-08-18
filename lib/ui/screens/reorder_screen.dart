import '../../ui/utils/club_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/widget/related_product_title.dart';
import '../../bloc/reorder/reorder_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/widget/refresh_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
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
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_sale_item_widget.dart';
import '../widget/dialogs/common_sale_description_dialog.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/confetti.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/sale_promotion_sheet.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';
import '../widget/supplier_products_screen_shimmer_widget.dart';

class ReorderRoute {
  static Widget get route => const ReorderScreen();
}

class ReorderScreen extends StatelessWidget {
  const ReorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ReorderBloc()
          ..add(ReorderEvent.getPreviousOrderProductsEvent(context: context))
          ..add(ReorderEvent.userApproveEvent(context: context))
          ..add(const ReorderEvent.getPreferencesDataEvent()),
        child: const ReorderScreenWidget());
  }
}

class ReorderScreenWidget extends StatelessWidget {
  const ReorderScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ReorderBloc bloc = context.read<ReorderBloc>();
    return BlocListener<ReorderBloc, ReorderState>(
      listener: (context, state) {},
      child: BlocBuilder<ReorderBloc, ReorderState>(builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
          floatingActionButton: floatingButtonWidget(context, state),
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.previous_order_products,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: Row(children: [
                5.width,
                GestureDetector(
                    onTap: () {
                      context.read<ReorderBloc>().add(const ReorderEvent.getGridListView());
                    },
                    child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
              ]),
            ),
          ),
          body: FocusDetector(
            onFocusGained: () {
              bloc.add(const ReorderEvent.getCartCountEvent());
              bloc.add(ReorderEvent.getPermissionList(context: context));
            },
            child: SafeArea(
              child: NotificationListener<ScrollNotification>(
                  child: Stack(children: [
                    SmartRefresher(
                      physics: const ClampingScrollPhysics(),
                      enablePullDown: true,
                      controller: state.refreshController,
                      header: const RefreshWidget(),
                      footer: CustomFooter(
                          builder: (context, mode) =>
                              state.isGridView ? const SupplierProductsScreenShimmerWidget() : const StoreCategoryScreenSubcategoryShimmerWidget()),
                      enablePullUp: !state.isBottomOfProducts,
                      onRefresh: () {
                        context.read<ReorderBloc>().add(ReorderEvent.refreshListEvent(context: context));
                        context.read<ReorderBloc>().add(const ReorderEvent.getPreferencesDataEvent());
                      },
                      child: SingleChildScrollView(
                        physics: state.previousOrderProductsList.isEmpty ? const NeverScrollableScrollPhysics() : null,
                        child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          100.height,
                          state.isShimmering
                              ? state.isGridView
                                  ? const SupplierProductsScreenShimmerWidget()
                                  : const StoreCategoryScreenSubcategoryShimmerWidget()
                              : state.previousOrderProductsList.isEmpty
                                  ? Container(
                                      height: getScreenHeight(context) - 80,
                                      width: getScreenWidth(context),
                                      alignment: Alignment.center,
                                      child: noDataWidget(AppLocalizations.of(context)!.no_data))
                                  : state.isGridView
                                      ? gridViewWidget(context, state)
                                      : listViewWidget(context, state)
                        ]),
                      ),
                    ),
                    searchWidget(context, bloc, state),
                  ]),
                  onNotification: (notification) {
                    if (notification.metrics.pixels > (notification.metrics.maxScrollExtent - 400)) {
                      if (!state.isBottomOfProducts) {
                        context.read<ReorderBloc>().add(ReorderEvent.getPreviousOrderProductsEvent(context: context));
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

  void _updateQuantity({required BuildContext context, required ReorderState state, required int index}) {
    final product = state.previousOrderProductsList[index];

    context.read<ReorderBloc>().add(ReorderEvent.updateListQuantityOfProduct(
        context: context,
        quantity: state.productStockList[1][index].quantity.toString(),
        productListIndex: 1,
        productStockUpdateIndex: index,
        productSupplierIds: product.supplierId.toString()));
  }

  void _addToCart({required BuildContext context, required ReorderState state, required int index}) {
    final product = state.previousOrderProductsList[index];

    context.read<ReorderBloc>().add(ReorderEvent.addToCartListProductEvent(
        context: context,
        productId: product.id.toString(),
        productListIndex: 1,
        productStockUpdateIndex: index,
        productSupplierIds: product.supplierId.toString()));
  }

  void _increaseQuantity({required BuildContext context, required ReorderState state, required int index}) {
    final product = state.previousOrderProductsList[index];
    final quantity = state.productStockList[1][index].quantity;
    final minQty = int.tryParse(product.sale?.saleMinQuantity ?? '0') ?? 0;
    final isMixedSale = product.sale?.isMixedSale ?? false;

    if (!isMixedSale && minQty <= quantity + 1) {
      context.read<ReorderBloc>().add(ReorderEvent.increaseListQuantityOfProduct(
          context: context, productListIndex: 1, productStockUpdateIndex: index, productSupplierIds: product.supplierId.toString()));
      _addToCart(context: context, state: state, index: index);
    } else {
      _showDialog(context, product, index, true);
    }
  }

  void _decreaseQuantity({required BuildContext context, required ReorderState state, required int index}) {
    final product = state.previousOrderProductsList[index];
    final quantity = state.productStockList[1][index].quantity;
    final minQty = int.tryParse(product.sale?.saleMinQuantity ?? '0') ?? 0;
    final isMixedSale = product.sale?.isMixedSale ?? false;

    if (quantity == 0) return;

    if (!isMixedSale && minQty <= quantity - 1) {
      context.read<ReorderBloc>().add(ReorderEvent.decreaseListQuantityOfProduct(
          context: context, productListIndex: 1, productStockUpdateIndex: index, productSupplierIds: product.supplierId.toString()));
      _addToCart(context: context, state: state, index: index);
    } else {
      _showDialog(context, product, index, false);
    }
  }

  void _showDialog(BuildContext context, product, int index, bool isIncrease) {
    showMinMaxQtyConfirmDialog(context: context, productId: product.id.toString(), index: index, productListIndex: 1, isIncrease: isIncrease);
  }

  Widget gridViewWidget(BuildContext context, ReorderState state) {
    return GridView.builder(
        itemCount: state.previousOrderProductsList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: getChildAspectRatio(context, state.isSaleOn)),
        itemBuilder: (context, index) {
          final product = state.previousOrderProductsList[index];
          final stock = state.productStockList[1][index];

          return CommonProductSaleItemWidget(
              isSale: product.sale?.isSale ?? false,
              isGuestUser: false,
              height: AppConstants.salesProductItemHeight,
              width: 140,
              productName: product.productName ?? '',
              saleImage: product.mainImage ?? '',
              title: product.name,
              description: parse(product.sale?.saleDescription ?? '').body?.text ?? '',
              discountedPrice: double.tryParse(product.sale?.salePrice ?? '') ?? 0.0,
              originalPrice: product.productPrice,
              productStock: product.productStock.toString(),
              lowStock: product.lowStock ?? '',
              isPesach: product.isPesach,
              quantity: stock.quantity,
              minQuantity: product.sale?.saleMinQuantity,
              maxQuantity: product.sale?.saleMaxQuantity,
              isMixedSale: product.sale?.isMixedSale,
              numberOfUnits: product.numberOfUnit.toString(),
              scaleType: product.scaleType,
              onQuantityChanged: () => _updateQuantity(context: context, state: state, index: index),
              onQuantityIncreaseTap: () => _increaseQuantity(context: context, state: state, index: index),
              onQuantityDecreaseTap: () => _decreaseQuantity(context: context, state: state, index: index),
              onButtonTap: () {
                showProductDetails(
                    context: context,
                    productId: product.id ?? '',
                    productListIndex: 1,
                    isBarcode: false,
                    productStock: product.productStock.toString(),
                    isSaleOn: state.isSaleOn);
              });
        });
  }

  Widget listViewWidget(BuildContext context, ReorderState state) {
    return ListView.builder(
        itemCount: state.previousOrderProductsList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
        itemBuilder: (context, index) {
          final product = state.previousOrderProductsList[index];
          final stock = state.productStockList[1][index];

          return CommonSaleListView(
              context: context,
              discountedPrice: double.tryParse(product.sale?.salePrice ?? '') ?? 0.0,
              isFromSale: product.sale?.isSale,
              salesDesc: product.sale?.saleDescription,
              isGuestUser: false,
              isPesach: product.isPesach,
              numberOfUnits: product.numberOfUnit.toString(),
              scaleType: product.scaleType,
              lowStock: product.lowStock.toString(),
              productStock: product.productStock.toString(),
              productImage: product.mainImage ?? '',
              productName: product.productName ?? '',
              price: double.tryParse(product.productPrice.toString()) ?? 0.0,
              quantity: stock.quantity,
              minQuantity: product.sale?.saleMinQuantity,
              maxQuantity: product.sale?.saleMaxQuantity,
              isMixedSale: product.sale?.isMixedSale,
              onQuantityChanged: () => _updateQuantity(context: context, state: state, index: index),
              onQuantityIncreaseTap: () => _increaseQuantity(context: context, state: state, index: index),
              onQuantityDecreaseTap: () => _decreaseQuantity(context: context, state: state, index: index),
              onButtonTap: () {
                showProductDetails(
                    context: context,
                    productId: product.id ?? '',
                    productStock: product.productStock.toString(),
                    productListIndex: 1,
                    isSaleOn: state.isSaleOn);
              });
        });
  }

  searchWidget(BuildContext context, ReorderBloc bloc, ReorderState state) => CommonSearchWidget(
      onCloseTap: () {
        bloc.add(const ReorderEvent.changeCategoryExpansion(isOpened: false));
        context.read<ReorderBloc>().add(ReorderEvent.getPreviousOrderProductsEvent(context: context));
      },
      isFilterTap: true,
      isCategoryExpand: state.isCategoryExpand,
      isSearching: state.isSearching,
      onFilterTap: () {
        bloc.add(const ReorderEvent.changeCategoryExpansion());
      },
      onSearchTap: () {
        if (state.searchController.text != '') {
          bloc.add(const ReorderEvent.changeCategoryExpansion(isOpened: true));
        }
      },
      onSearch: (String search) {
        if (search.length > 1) {
          bloc.add(const ReorderEvent.changeCategoryExpansion(isOpened: true));
          bloc.add(ReorderEvent.globalSearchEvent(context: context));
        }
      },
      onSearchSubmit: (String search) {
        Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name,
            arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()});
      },
      onOutSideTap: () {
        state.searchController.clear();
        bloc.add(const ReorderEvent.changeCategoryExpansion(isOpened: false));
      },
      onSearchItemTap: () {
        bloc.add(const ReorderEvent.changeCategoryExpansion());
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
                        isShowSeeAll: index == state.searchList.length ? true : false,
                        salePrice: state.searchList[index].salePrice,
                        saleDesc: state.searchList[index].salesDesc,
                        isPesach: state.searchList[index].isPesach,
                        lowStock: state.searchList[index].lowStock.toString(),
                        numberOfUnits: state.searchList[index].numberOfUnits,
                        scaleType: state.searchList[index].scaleType,
                        priceOfBox: state.searchList[index].priceOfBox,
                        productStock: state.searchList[index].productStock,
                        context: context,
                        isGuestUser: false,
                        searchName: state.searchList[index].name,
                        searchImage: state.searchList[index].image,
                        searchType: state.searchList[index].searchType,
                        isMoreResults:
                            state.searchList.where((search) => search.searchType == state.searchList[index].searchType).toList().isNotEmpty,
                        isLastItem: state.searchList.length - 1 == index,
                        quantity: state.productStockList[0][index].quantity,
                        isSale: state.searchList[index].isSale,
                        minQuantity: state.searchList[index].saleMinQuantity,
                        maxQuantity: state.searchList[index].saleMaxQuantity,
                        isMixedSale: state.searchList[index].isMixedSale,
                        onQuantityChanged: () {
                          context.read<ReorderBloc>().add(ReorderEvent.updateListQuantityOfProduct(
                              context: context,
                              quantity: state.productStockList[0][index].quantity.toString(),
                              productListIndex: 0,
                              productStockUpdateIndex: index,
                              productSupplierIds: state.searchList[index].supplierId.toString()));
                        },
                        onQuantityIncreaseTap: () {
                          if (!(state.searchList[index].isMixedSale ?? false) &&
                              int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity + 1) {
                            context.read<ReorderBloc>().add(ReorderEvent.increaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: state.searchList[index].supplierId.toString()));

                            context.read<ReorderBloc>().add(ReorderEvent.addToCartListProductEvent(
                                context: context,
                                productId: state.searchList[index].searchId,
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: state.searchList[index].supplierId.toString()));
                          } else {
                            showMinMaxQtyConfirmDialog(
                                context: context, productId: state.searchList[index].searchId, index: index, productListIndex: 0, isIncrease: true);
                          }
                        },
                        onQuantityDecreaseTap: () {
                          if (state.productStockList[0][index].quantity != 0) {
                            if (!(state.searchList[index].isMixedSale ?? false) &&
                                int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity - 1) {
                              context.read<ReorderBloc>().add(ReorderEvent.decreaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.searchList[index].supplierId.toString()));

                              context.read<ReorderBloc>().add(ReorderEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: state.searchList[index].searchId,
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.searchList[index].supplierId.toString()));
                            } else {
                              showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: state.searchList[index].searchId,
                                  index: index,
                                  productListIndex: 0,
                                  isIncrease: false);
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
                              AppStrings.searchResultString: state.searchList
                            });
                            if (searchResult != null) {
                              bloc.add(ReorderEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else if (state.searchList[index].searchType == SearchTypes.subCategory) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: state.searchList[index].categoryId,
                              AppStrings.categoryNameString: state.searchList[index].categoryName,
                              AppStrings.searchString: state.search,
                              AppStrings.searchResultString: state.searchList
                            });
                            if (searchResult != null) {
                              bloc.add(ReorderEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            state.searchList[index].searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyScreen.name, arguments: {AppStrings.searchString: state.search})
                                : state.searchList[index].searchType == SearchTypes.supplier
                                    ? Navigator.pushNamed(context, RouteDefine.supplierScreen.name,
                                        arguments: {AppStrings.searchString: state.search})
                                    : state.searchList[index].searchType == SearchTypes.sale
                                        ? Navigator.pushNamed(context, RouteDefine.productSaleScreen.name,
                                            arguments: {AppStrings.searchString: state.search})
                                        : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                            AppStrings.searchString: state.search,
                                            AppStrings.searchType: SearchTypes.product.toString()
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
                                isSaleOn: state.isSaleOn);
                          } else if (state.searchList[index].searchType == SearchTypes.category) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: state.searchList[index].searchId,
                              AppStrings.categoryNameString: state.searchList[index].name,
                              AppStrings.searchString: state.searchController.text,
                              AppStrings.searchResultString: state.searchList
                            });
                            if (searchResult != null) {
                              bloc.add(ReorderEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            state.searchList[index].searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name,
                                    arguments: {AppStrings.companyIdString: state.searchList[index].searchId})
                                : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name,
                                    arguments: {AppStrings.supplierIdString: state.searchList[index].searchId});
                          }
                          bloc.add(const ReorderEvent.changeCategoryExpansion());
                        });
                  }),
      onScanTap: () async {
        String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
        if (scanResult != '-1') {
          showProductDetails(
              context: context, productId: scanResult, isBarcode: true, productStock: '1', productListIndex: 0, isSaleOn: state.isSaleOn);
        }
      });

  void showProductDetails(
      {required BuildContext context,
      required String productId,
      bool? isBarcode,
      String productStock = '0',
      required int productListIndex,
      required bool isSaleOn}) async {
    context.read<ReorderBloc>().add(ReorderEvent.getProductDetailsEvent(
        context: context, productId: productId, isBarcode: isBarcode ?? false, productListIndex: productListIndex));
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
                    value: context.read<ReorderBloc>(),
                    child: BlocBuilder<ReorderBloc, ReorderState>(builder: (blocContext, state) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                            color: AppColors.whiteColor),
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
                                          totalBottleDeposit: (state.bottleDeposit *
                                              (state.productDetails.first.numberOfUnit ?? 1).toDouble() *
                                              state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                          isBottle: (state.productDetails.first.isBottle ?? false),
                                          addToOrderTap: () {
                                            final isMixedSale = state.productDetails.first.sale?.isMixedSale ?? false;
                                            if (!isMixedSale &&
                                                int.parse(state.productDetails.first.sale!.saleMinQuantity!) <=
                                                    state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
                                              context
                                                  .read<ReorderBloc>()
                                                  .add(ReorderEvent.addToCartProductEvent(context: context1, productId: productId));
                                            } else {
                                              showMinQtyConfirmDialog(context, productId,
                                                  initialQuantity:
                                                      state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity);
                                            }
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
                                                              '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}'),
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
                                          recommendedRetailConsumerPricerOffer: ClubAgent.isClubClient(state.clubAgentId)
                                              ? state.productDetails.first.sale?.isSale == true
                                                  ? state.productDetails.first.recommendedConsumerOffer
                                                  : state.productDetails.first.recommendedRetailPrice
                                              : '',
                                          onQuantityChanged: (quantity) {
                                            context
                                                .read<ReorderBloc>()
                                                .add(ReorderEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                          },
                                          onQuantityIncreaseTap: () {
                                            context.read<ReorderBloc>().add(ReorderEvent.increaseQuantityOfProduct(context: context1));
                                          },
                                          onQuantityDecreaseTap: () {
                                            if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                              context.read<ReorderBloc>().add(ReorderEvent.decreaseQuantityOfProduct(context: context1));
                                            }
                                          },
                                          onCloseTap: () {
                                            context.read<ReorderBloc>().add(ReorderEvent.getPreviousOrderProductsEvent(context: context1));
                                            Navigator.pop(context);
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
                                                  productStockList: state.productStockList,
                                                  state.clubAgentId!)
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
      BuildContext prevContext, List<RelatedProductDatum> relatedProductList, BuildContext context, isSaleOn, String clubAgentId,
      {required List<List<ProductStockModel>> productStockList}) {
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
                    context.read<ReorderBloc>().add(ReorderEvent.updateListQuantityOfProduct(
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
                      context.read<ReorderBloc>().add(ReorderEvent.increaseListQuantityOfProduct(
                          context: context,
                          productListIndex: 2,
                          productStockUpdateIndex: productStockList[2]
                              .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString()));

                      context.read<ReorderBloc>().add(ReorderEvent.addToCartListProductEvent(
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
                        context.read<ReorderBloc>().add(ReorderEvent.decreaseListQuantityOfProduct(
                            context: context,
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2]
                                .indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString()));

                        context.read<ReorderBloc>().add(ReorderEvent.addToCartListProductEvent(
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
                        productListIndex: 2,
                        context: context,
                        productId: relatedProductList[i].id ?? '',
                        isBarcode: false,
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
    final stockState = context.read<ReorderBloc>().state;
    int? qty = initialQuantity;
    try {
      final current = stockState.productStockList[productListIndex][index].quantity;
      qty ??= isIncrease ? current + 1 : (current > 0 ? current - 1 : 0);
    } catch (_) {}
    _openSalePromotionSheet(context, productId, initialQuantity: qty);
  }

  Future<void> _openSalePromotionSheet(BuildContext context, String productId, {int? initialQuantity, bool closeParentBeforeOpen = false}) async {
    final ReorderBloc bloc = context.read<ReorderBloc>();
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
    bloc.add(ReorderEvent.applyCartQuantitiesEvent(cartQuantities: cartMap));
    bloc.add(ReorderEvent.getCartCountNoEvent(context: context));
  }

  Widget floatingButtonWidget(BuildContext context, ReorderState state) => FloatingActionButton(
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
