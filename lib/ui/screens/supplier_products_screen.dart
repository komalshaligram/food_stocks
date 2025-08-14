import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/supplier_products/supplier_products_bloc.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/widget/common_product_sale_item_widget.dart';
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
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/custom_dialog.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';

class SupplierProductsRoute {
  static Widget get route => const SupplierProductsScreen();
}

class SupplierProductsScreen extends StatelessWidget {
  const SupplierProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => SupplierProductsBloc()
        ..add(SupplierProductsEvent.getSupplierProductsIdEvent(supplierId: args?[AppStrings.supplierIdString] ?? '', search: args?[AppStrings.searchString] ?? ''))
        ..add(SupplierProductsEvent.getSupplierProductsListEvent(
          context: context,
          searchType: args?[AppStrings.searchType] ?? '',
        ))
        ..add(SupplierProductsEvent.userApproveEvent(context: context)),
      child: const SupplierProductsScreenWidget(),
    );
  }
}

class SupplierProductsScreenWidget extends StatelessWidget {
  const SupplierProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SupplierProductsBloc bloc = context.read<SupplierProductsBloc>();
    return BlocListener<SupplierProductsBloc, SupplierProductsState>(
      listener: (context, state) {},
      child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: state.searchArg.isNotEmpty ? AppLocalizations.of(context)!.search_result : AppLocalizations.of(context)!.products,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                trailingWidget: GestureDetector(
                    onTap: () {
                      context.read<SupplierProductsBloc>().add(const SupplierProductsEvent.getGridListView());
                    },
                    child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
              ),
            ),
            body: FocusDetector(
              onFocusGained: () {
                bloc.add(SupplierProductsEvent.getPermissionList(context: context));
              },
              child: SafeArea(
                child: NotificationListener<ScrollNotification>(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          100.height,
                          Expanded(
                            child: SmartRefresher(
                              enablePullDown: true,
                              controller: state.refreshController,
                              header: const RefreshWidget(),
                              footer: CustomFooter(
                                builder: (context, mode) => state.isGridView ? SupplierProductsScreenShimmerWidget() : StoreCategoryScreenSubcategoryShimmerWidget(),
                              ),
                              enablePullUp: !state.isBottomOfProducts,
                              onRefresh: () {
                                context.read<SupplierProductsBloc>().add(SupplierProductsEvent.refreshListEvent(context: context));
                              },
                              /*  onLoading: () {
                                context.read<SupplierProductsBloc>().add(
                                    SupplierProductsEvent
                                        .getSupplierProductsListEvent(
                                            context: context,
                                            searchType: state.searchType));
                              },*/
                              child: SingleChildScrollView(
                                physics: state.productList.isEmpty ? const NeverScrollableScrollPhysics() : null,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    state.isShimmering
                                        ? state.isGridView
                                            ? SupplierProductsScreenShimmerWidget()
                                            : StoreCategoryScreenSubcategoryShimmerWidget()
                                        : state.productList.isEmpty
                                            ? Container(
                                                height: getScreenHeight(context) - 80,
                                                width: getScreenWidth(context),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  AppLocalizations.of(context)!.no_data,
                                                  style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor),
                                                ),
                                              )
                                            : state.isGridView
                                                ? GridView.builder(
                                                    itemCount: state.productList.length,
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: getChildAspectRatio(context, state.isSaleOn)),
                                                    itemBuilder: (context, index) {
                                                      return CommonProductSaleItemWidget(
                                                          //  imageHeight: isTablet(context) ? 100 : 70,
                                                          isGuestUser: state.isGuestUser,
                                                          height: AppConstants.salesProductItemHeight,
                                                          width: 140,
                                                          isSale: state.productList[index].sale!.isSale,
                                                          productName: state.productList[index].productName ?? '',
                                                          saleImage: state.productList[index].mainImage ?? '',
                                                          title: state.productList[index].name,
                                                          description: parse(state.productList[index].sale!.saleDescription).body?.text ?? '',
                                                          discountedPrice: double.parse(state.productList[index].sale!.salePrice),
                                                          originalPrice: double.parse(state.productList[index].productPrice.toString()),
                                                          productStock: state.productList[index].productStock.toString(),
                                                          lowStock: state.productList[index].lowStock ?? '',
                                                          isPesach: state.productList[index].isPesach,
                                                          quantity: state.productStockList[1][index].quantity,
                                                          minQuantity: state.productList[index].sale?.saleMinQuantity,
                                                          maxQuantity: state.productList[index].sale?.saleMaxQuantity,
                                                          onQuantityChanged: () {
                                                            context.read<SupplierProductsBloc>().add(
                                                                  SupplierProductsEvent.updateListQuantityOfProduct(
                                                                    context: context,
                                                                    quantity: state.productStockList[1][index].quantity.toString(),
                                                                    productListIndex: 1,
                                                                    productStockUpdateIndex: index,
                                                                    productSupplierIds: state.productList[index].supplierId.toString(),
                                                                  ),
                                                                );
                                                          },
                                                          onQuantityIncreaseTap: () {
                                                            if (int.parse(state.productList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity + 1) {
                                                              context.read<SupplierProductsBloc>().add(
                                                                    SupplierProductsEvent.increaseListQuantityOfProduct(
                                                                      context: context,
                                                                      productListIndex: 1,
                                                                      productStockUpdateIndex: index,
                                                                      productSupplierIds: state.productList[index].supplierId.toString(),
                                                                    ),
                                                                  );

                                                              context.read<SupplierProductsBloc>().add(
                                                                    SupplierProductsEvent.addToCartListProductEvent(
                                                                      context: context,
                                                                      productId: state.searchType == SearchTypes.product.toString() ? state.productList[index].id ?? '' : state.productList[index].productId ?? '',
                                                                      productListIndex: 1,
                                                                      productStockUpdateIndex: index,
                                                                      productSupplierIds: state.productList[index].supplierId.toString(),
                                                                    ),
                                                                  );
                                                            } else {
                                                              showMinMaxIncreaseQtyConfirmDialog(
                                                                context,
                                                                state.productList[index].id.toString(),
                                                                state.productList[index].sale?.saleMinQuantity.toString() ?? '0',
                                                                index,
                                                                state.productList[index].supplierId.toString(),
                                                                1,
                                                              );
                                                            }
                                                          },
                                                          onQuantityDecreaseTap: () {
                                                            if (state.productStockList[1][index].quantity != 0) {
                                                              if (int.parse(state.productList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity - 1) {
                                                                context.read<SupplierProductsBloc>().add(
                                                                      SupplierProductsEvent.decreaseListQuantityOfProduct(
                                                                        context: context,
                                                                        productListIndex: 1,
                                                                        productStockUpdateIndex: index,
                                                                        productSupplierIds: state.productList[index].supplierId.toString(),
                                                                      ),
                                                                    );

                                                                context.read<SupplierProductsBloc>().add(
                                                                      SupplierProductsEvent.addToCartListProductEvent(
                                                                        context: context,
                                                                        productId: state.searchType == SearchTypes.product.toString() ? state.productList[index].id ?? '' : state.productList[index].productId ?? '',
                                                                        productListIndex: 1,
                                                                        productStockUpdateIndex: index,
                                                                        productSupplierIds: state.productList[index].supplierId.toString(),
                                                                      ),
                                                                    );
                                                              } else {
                                                                showMinMaxDecreaseQtyConfirmDialog(
                                                                  context,
                                                                  state.productList[index].id.toString(),
                                                                  state.productList[index].sale?.saleMinQuantity.toString() ?? '0',
                                                                  index,
                                                                  state.productList[index].supplierId.toString(),
                                                                  1,
                                                                );
                                                              }
                                                            }
                                                          },
                                                          onButtonTap: () {
                                                            if (!state.isGuestUser) {
                                                              showProductDetails(
                                                                isSaleOn: state.isSaleOn,
                                                                productListIndex: 1,
                                                                context: context,
                                                                productId: state.searchType == SearchTypes.product.toString() ? state.productList[index].id ?? '' : state.productList[index].productId ?? '',
                                                                productStock: state.productList[index].productStock.toString(),
                                                              );
                                                              // context.read<SupplierProductsBloc>().add(
                                                              //     SupplierProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
                                                            } else {
                                                              Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                            }
                                                          });
                                                    })
                                                : ListView.builder(
                                                    itemCount: state.productList.length,
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                                                    itemBuilder: (context, index) => CommonSaleListView(
                                                      context: context,
                                                      discountedPrice: double.parse(state.productList[index].sale!.salePrice),
                                                      isFromSale: state.productList[index].sale?.isSale,
                                                      salesDesc: state.productList[index].sale?.saleDescription,
                                                      isPesach: state.productList[index].isPesach,
                                                      numberOfUnits: state.productList[index].numberOfUnit.toString(),
                                                      lowStock: state.productList[index].lowStock.toString(),
                                                      productStock: state.productList[index].productStock.toString(),
                                                      productImage: state.productList[index].mainImage ?? '',
                                                      productName: state.productList[index].productName ?? '',
                                                      price: double.parse(state.productList[index].productPrice.toString()),
                                                      quantity: state.productStockList[1][index].quantity,
                                                      minQuantity: state.productList[index].sale?.saleMinQuantity,
                                                      maxQuantity: state.productList[index].sale?.saleMaxQuantity,
                                                      onQuantityChanged: () {
                                                        context.read<SupplierProductsBloc>().add(
                                                              SupplierProductsEvent.updateListQuantityOfProduct(
                                                                context: context,
                                                                quantity: state.productStockList[1][index].quantity.toString(),
                                                                productListIndex: 1,
                                                                productStockUpdateIndex: index,
                                                                productSupplierIds: state.productList[index].supplierId.toString(),
                                                              ),
                                                            );
                                                      },
                                                      onQuantityIncreaseTap: () {
                                                        if (int.parse(state.productList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity + 1) {
                                                          context.read<SupplierProductsBloc>().add(
                                                                SupplierProductsEvent.increaseListQuantityOfProduct(
                                                                  context: context,
                                                                  productListIndex: 1,
                                                                  productStockUpdateIndex: index,
                                                                  productSupplierIds: state.productList[index].supplierId.toString(),
                                                                ),
                                                              );

                                                          context.read<SupplierProductsBloc>().add(
                                                                SupplierProductsEvent.addToCartListProductEvent(
                                                                  context: context,
                                                                  productId: state.searchType == SearchTypes.product.toString() ? state.productList[index].id ?? '' : state.productList[index].productId ?? '',
                                                                  productListIndex: 1,
                                                                  productStockUpdateIndex: index,
                                                                  productSupplierIds: state.productList[index].supplierId.toString(),
                                                                ),
                                                              );
                                                        } else {
                                                          showMinMaxIncreaseQtyConfirmDialog(
                                                            context,
                                                            state.productList[index].id.toString(),
                                                            state.productList[index].sale?.saleMinQuantity.toString() ?? '0',
                                                            index,
                                                            state.productList[index].supplierId.toString(),
                                                            1,
                                                          );
                                                        }
                                                      },
                                                      onQuantityDecreaseTap: () {
                                                        if (state.productStockList[1][index].quantity != 0) {
                                                          if (int.parse(state.productList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity - 1) {
                                                            context.read<SupplierProductsBloc>().add(
                                                                  SupplierProductsEvent.decreaseListQuantityOfProduct(
                                                                    context: context,
                                                                    productListIndex: 1,
                                                                    productStockUpdateIndex: index,
                                                                    productSupplierIds: state.productList[index].supplierId.toString(),
                                                                  ),
                                                                );

                                                            context.read<SupplierProductsBloc>().add(
                                                                  SupplierProductsEvent.addToCartListProductEvent(
                                                                    context: context,
                                                                    productId: state.searchType == SearchTypes.product.toString() ? state.productList[index].id ?? '' : state.productList[index].productId ?? '',
                                                                    productListIndex: 1,
                                                                    productStockUpdateIndex: index,
                                                                    productSupplierIds: state.productList[index].supplierId.toString(),
                                                                  ),
                                                                );
                                                          } else {
                                                            showMinMaxDecreaseQtyConfirmDialog(
                                                              context,
                                                              state.productList[index].id.toString(),
                                                              state.productList[index].sale?.saleMinQuantity.toString() ?? '0',
                                                              index,
                                                              state.productList[index].supplierId.toString(),
                                                              1,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      onButtonTap: () {
                                                        if (!state.isGuestUser) {
                                                          showProductDetails(
                                                            productListIndex: 1,
                                                            context: context,
                                                            productId: state.searchType == SearchTypes.product.toString() ? state.productList[index].id ?? '' : state.productList[index].productId ?? '',
                                                            productStock: state.productList[index].productStock.toString(),
                                                            isSaleOn: state.isSaleOn,
                                                          );
                                                          // context.read<SupplierProductsBloc>().add(
                                                          //     SupplierProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
                                                        } else {
                                                          Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                        }
                                                      },
                                                      isGuestUser: false,
                                                    ),
                                                  ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CommonSearchWidget(
                        onCloseTap: () {
                          bloc.add(const SupplierProductsEvent.changeCategoryExpansion(isOpened: false));
                          context.read<SupplierProductsBloc>().add(SupplierProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
                        },
                        isFilterTap: true,
                        isCategoryExpand: state.isCategoryExpand,
                        isSearching: state.isSearching,
                        onFilterTap: () {
                          bloc.add(const SupplierProductsEvent.changeCategoryExpansion());
                        },
                        onSearchTap: () {
                          if (state.searchController.text != '') {
                            bloc.add(const SupplierProductsEvent.changeCategoryExpansion(isOpened: true));
                          }
                        },
                        onSearch: (String search) {
                          if (search.length > 1) {
                            bloc.add(const SupplierProductsEvent.changeCategoryExpansion(isOpened: true));
                            bloc.add(SupplierProductsEvent.globalSearchEvent(context: context));
                          }
                        },
                        onSearchSubmit: (String search) {
                          Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()});
                        },
                        onOutSideTap: () {
                          state.searchController.clear();
                          bloc.add(const SupplierProductsEvent.changeCategoryExpansion(isOpened: false));
                        },
                        onSearchItemTap: () {
                          bloc.add(const SupplierProductsEvent.changeCategoryExpansion());
                        },
                        controller: state.searchController,
                        searchList: state.searchList,
                        searchResultWidget: state.isSearching
                            ? const SizedBox()
                            : state.searchList.isEmpty
                                ? Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.search_result_not_found,
                                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: state.searchList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (listViewContext, index) {
                                      return SearchItemWidget(
                                          isShowSeeAll: index == state.searchList.length - 1 ? true : false,
                                          saleDesc: state.searchList[index].salesDesc,
                                          salePrice: state.searchList[index].salePrice,
                                          isPesach: state.searchList[index].isPesach,
                                          lowStock: state.searchList[index].lowStock.toString(),
                                          isGuestUser: state.isGuestUser,
                                          numberOfUnits: state.searchList[index].numberOfUnits,
                                          priceOfBox: state.searchList[index].priceOfBox,
                                          productStock: state.searchList[index].productStock.toString(),
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
                                          onQuantityChanged: () {
                                            context.read<SupplierProductsBloc>().add(
                                                  SupplierProductsEvent.updateListQuantityOfProduct(
                                                    context: context,
                                                    quantity: state.productStockList[0][index].quantity.toString(),
                                                    productListIndex: 0,
                                                    productStockUpdateIndex: index,
                                                    productSupplierIds: state.searchList[index].supplierId.toString(),
                                                  ),
                                                );
                                          },
                                          onQuantityIncreaseTap: () {
          if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity + 1) {
                                            context.read<SupplierProductsBloc>().add(
                                                  SupplierProductsEvent.increaseListQuantityOfProduct(
                                                    context: context,
                                                    productListIndex: 0,
                                                    productStockUpdateIndex: index,
                                                    productSupplierIds: state.searchList[index].supplierId.toString(),
                                                  ),
                                                );

                                            context.read<SupplierProductsBloc>().add(
                                                  SupplierProductsEvent.addToCartListProductEvent(
                                                    context: context,
                                                    productId: state.searchList[index].searchId,
                                                    productListIndex: 0,
                                                    productStockUpdateIndex: index,
                                                    productSupplierIds: state.searchList[index].supplierId.toString(),
                                                  ),
                                                );
          } else {
            showMinMaxIncreaseQtyConfirmDialog(
              context,
              state.searchList[index].searchId,
              state.searchList[index].saleMinQuantity.toString() ?? '0',
              index,
              state.searchList[index].supplierId.toString(),
              0,
            );
          }
                                          },
                                          onQuantityDecreaseTap: () {
                                            if (state.productStockList[0][index].quantity != 0) {
          if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity - 1) {
                                              context.read<SupplierProductsBloc>().add(
                                                    SupplierProductsEvent.decreaseListQuantityOfProduct(
                                                      context: context,
                                                      productListIndex: 0,
                                                      productStockUpdateIndex: index,
                                                      productSupplierIds: state.searchList[index].supplierId.toString(),
                                                    ),
                                                  );

                                              context.read<SupplierProductsBloc>().add(
                                                    SupplierProductsEvent.addToCartListProductEvent(
                                                      context: context,
                                                      productId: state.searchList[index].searchId,
                                                      productListIndex: 0,
                                                      productStockUpdateIndex: index,
                                                      productSupplierIds: state.searchList[index].supplierId.toString(),
                                                    ),
                                                  );
          } else {
            showMinMaxDecreaseQtyConfirmDialog(
              context,
              state.searchList[index].searchId,
              state.searchList[index].saleMinQuantity.toString() ?? '0',
              index,
              state.searchList[index].supplierId.toString(),
              0,
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
                                              dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.productCategoryScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.reqSearchString: state.search, AppStrings.searchResultString: state.searchList});
                                              if (searchResult != null) {
                                                bloc.add(SupplierProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                              }
                                            } else if (state.searchList[index].searchType == SearchTypes.subCategory) {
                                              dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.categoryIdString: state.searchList[index].categoryId, AppStrings.categoryNameString: state.searchList[index].categoryName, AppStrings.searchString: state.search, AppStrings.searchResultString: state.searchList});
                                              if (searchResult != null) {
                                                bloc.add(SupplierProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                              }
                                            } else {
                                              state.searchList[index].searchType == SearchTypes.company
                                                  ? Navigator.pushNamed(context, RouteDefine.companyScreen.name, arguments: {AppStrings.searchString: state.search})
                                                  : state.searchList[index].searchType == SearchTypes.supplier
                                                      ? Navigator.pushNamed(context, RouteDefine.supplierScreen.name, arguments: {AppStrings.searchString: state.search})
                                                      : state.searchList[index].searchType == SearchTypes.sale
                                                          ? Navigator.pushNamed(context, RouteDefine.productSaleScreen.name, arguments: {AppStrings.searchString: state.search})
                                                          : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()});
                                            }
                                          },
                                          onTap: () async {
                                            if (state.searchList[index].searchType == SearchTypes.subCategory) {
                                              CustomSnackBar.showSnackBar(
                                                context: context,
                                                title: AppStrings.getLocalizedStrings('Oops! in progress', context),
                                                type: SnackBarType.success,
                                              );
                                              return;
                                            }
                                            if (state.searchList[index].searchType == SearchTypes.sale || state.searchList[index].searchType == SearchTypes.product) {
                                              if (!state.isGuestUser) {
                                                showProductDetails(productListIndex: 0, context: context, productStock: state.searchList[index].productStock.toString(), productId: state.searchList[index].searchId, isBarcode: true, isSaleOn: state.isSaleOn);
                                              } else {
                                                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                              }
                                            } else if (state.searchList[index].searchType == SearchTypes.category) {
                                              dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.categoryIdString: state.searchList[index].searchId, AppStrings.categoryNameString: state.searchList[index].name, AppStrings.searchString: state.searchController.text, AppStrings.searchResultString: state.searchList});
                                              if (searchResult != null) {
                                                bloc.add(SupplierProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                              }
                                            } else {
                                              state.searchList[index].searchType == SearchTypes.company ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {AppStrings.companyIdString: state.searchList[index].searchId}) : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.supplierIdString: state.searchList[index].searchId});
                                            }
                                            bloc.add(const SupplierProductsEvent.changeCategoryExpansion());
                                          });
                                    },
                                  ),
                        onScanTap: () async {
                          String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
                          if (scanResult != '-1') {
                            // -1 result for cancel scanning
                            if (!state.isGuestUser) {
                              showProductDetails(productListIndex: 0, context: context, productId: scanResult, isBarcode: true, productStock: '1', isSaleOn: state.isSaleOn);
                            } else {
                              Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  onNotification: (notification) {
                    if (notification.metrics.pixels > (notification.metrics.maxScrollExtent - 400)) {
                      if (!state.isBottomOfProducts) {
                        context.read<SupplierProductsBloc>().add(SupplierProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
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

  Widget buildSupplierProducts({required BuildContext context, required int index, required String productImage, required String productName, required double productPrice, required void Function() onPressed, required bool isRTL}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_5),
      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: productImage.isNotEmpty
                ? Image.network(
                    "${AppUrlEndPoints.baseFileUrl}$productImage",
                    height: 70,
                    fit: BoxFit.fitHeight,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress?.cumulativeBytesLoaded != loadingProgress?.expectedTotalBytes) {
                        return CommonShimmerWidget(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
                            ),
                          ),
                        );
                      }
                      return child;
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(AppImagePath.imageNotAvailable5, height: 70, width: double.maxFinite, fit: BoxFit.cover);
                    },
                  )
                : Image.asset(AppImagePath.imageNotAvailable5, height: 70, width: double.maxFinite, fit: BoxFit.cover),
          ),
          5.height,
          Text(
            productName,
            style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          5.height,
          Expanded(
            child: 0.width,
          ),
          5.height,
          Center(
            child: CommonProductButtonWidget(
              title: "${AppLocalizations.of(context)!.currency}${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(AppConstants.amountFrLength)}",
              onPressed: onPressed,
              textColor: AppColors.whiteColor,
              bgColor: AppColors.mainColor,
              borderRadius: AppConstants.radius_3,
              textSize: AppConstants.font_12,
            ),
          )
        ],
      ),
    );
  }

  void showProductDetails({required BuildContext context, required String productId, required int productListIndex, required bool isSaleOn, bool? isBarcode, String productStock = '0'}) async {
    context.read<SupplierProductsBloc>().add(SupplierProductsEvent.getProductDetailsEvent(context: context, productId: productId, productListIndex: productListIndex, isBarcode: isBarcode ?? false));
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
                value: context.read<SupplierProductsBloc>(),
                child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
                  builder: (blocContext, state) {
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
                          : state.productDetails.isEmpty
                              ? NoDataBottomSheet(dialogContext: context)
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
                                        addToOrderTap: () {
                                          if (int.parse(state.productDetails.first.sale!.saleMinQuantity!) <= state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
                                            context.read<SupplierProductsBloc>().add(SupplierProductsEvent.addToCartProductEvent(context: context1, productId: productId));
                                          } else {
                                            showMinQtyConfirmDialog(context, productId, state.productDetails.first.sale!.saleMinQuantity.toString());
                                          }
                                          // context.read<SupplierProductsBloc>().add(SupplierProductsEvent.addToCartProductEvent(context: context1, productId: productId));
                                        },
                                        isLoading: state.isLoading,
                                        imageOnTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (dialogContext) {
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
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: state.productDetails[state.imageIndex].mainImage != ''
                                                            ? PhotoView(
                                                                imageProvider: NetworkImage(
                                                                  '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets.only(top: 10.0),
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
                                        productImages: [
                                          state.productDetails.first.mainImage ?? '',
                                        ],
                                        productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? ''),
                                        productPrice: (state.productDetails.first.sale?.isSale ?? false) ? double.parse(state.productDetails.first.sale?.salePrice ?? '') * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1) : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                        productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                        scrollController: scrollController,
                                        productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                        onQuantityChanged: (quantity) {
                                          context.read<SupplierProductsBloc>().add(SupplierProductsEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                        },
                                        onQuantityIncreaseTap: () {
                                          context.read<SupplierProductsBloc>().add(SupplierProductsEvent.increaseQuantityOfProduct(context: context1));
                                        },
                                        onQuantityDecreaseTap: () {
                                          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                            context.read<SupplierProductsBloc>().add(SupplierProductsEvent.decreaseQuantityOfProduct(context: context1));
                                          }
                                        },
                                        onCloseTap: () {
                                          context.read<SupplierProductsBloc>().add(SupplierProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
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
                                                ),
                                      10.height
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
    BuildContext context,
    bool isSaleOn, {
    required List<List<ProductStockModel>> productStockList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
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
          height: getItemHeight(context, isSaleOn),
          padding: const EdgeInsets.only(left: 10, right: 10),
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
                onQuantityChanged: () {
                  context.read<SupplierProductsBloc>().add(
                        SupplierProductsEvent.updateListQuantityOfProduct(
                          context: context,
                          quantity: productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity.toString(),
                          productListIndex: 2,
                          productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString(),
                        ),
                      );
                },
                onQuantityIncreaseTap: () {
                  if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity + 1) {
                    context.read<SupplierProductsBloc>().add(
                          SupplierProductsEvent.increaseListQuantityOfProduct(
                            context: context,
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString(),
                          ),
                        );

                    context.read<SupplierProductsBloc>().add(
                          SupplierProductsEvent.addToCartListProductEvent(
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
                    );
                  }
                },
                onQuantityDecreaseTap: () {
                  if (productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity != 0) {
                    if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity - 1) {
                      context.read<SupplierProductsBloc>().add(
                            SupplierProductsEvent.decreaseListQuantityOfProduct(
                              context: context,
                              productListIndex: 2,
                              productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                              productSupplierIds: relatedProductList[i].supplierId.toString(),
                            ),
                          );

                      context.read<SupplierProductsBloc>().add(
                            SupplierProductsEvent.addToCartListProductEvent(
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
                      );
                    }
                  }
                },
                onButtonTap: () {
                  Navigator.pop(prevContext);
                  showProductDetails(
                    isSaleOn: isSaleOn,
                    context: context,
                    productListIndex: 2,
                    productId: relatedProductList[i].id ?? '',
                    isBarcode: false,
                    productStock: (relatedProductList[i].productStock.toString()),
                  );

                  // context.read<SupplierProductsBloc>().add(
                  //     SupplierProductsEvent.getSupplierProductsListEvent(context: context, searchType: ''));
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

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox) {
    SupplierProductsBloc bloc = context.read<SupplierProductsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<SupplierProductsBloc>(),
        child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
          builder: (context1, state) {
            return CustomDialog(
              directionality: state.language,
              title: '${AppLocalizations.of(context)?.minimum_box_title}$minBox${AppLocalizations.of(context)?.confirm_minimum_box}',
              positiveTitle: AppLocalizations.of(context)!.yes,
              negativeTitle: AppLocalizations.of(context)!.no,
              negativeOnTap: () async {
                Navigator.pop(context);
              },
              positiveOnTap: () async {
                Navigator.pop(dialogContext);

                bloc.add(SupplierProductsEvent.addToCartProductEvent(context: context, productId: productId));
              },
            );
          },
        ),
      ),
    );
  }

  showMinMaxIncreaseQtyConfirmDialog(BuildContext context, String productId, String minBox, int index, supplierId, productListIndex) {
    SupplierProductsBloc bloc = context.read<SupplierProductsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<SupplierProductsBloc>(),
        child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
          builder: (context1, state) {
            return CustomDialog(
              directionality: state.language,
              title: '${AppLocalizations.of(context)?.minimum_box_title}$minBox${AppLocalizations.of(context)?.confirm_minimum_box}',
              positiveTitle: AppLocalizations.of(context)!.yes,
              negativeTitle: AppLocalizations.of(context)!.no,
              negativeOnTap: () async {
                Navigator.pop(context);
              },
              positiveOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(SupplierProductsEvent.increaseListQuantityOfProduct(
                  context: context,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));

                bloc.add(SupplierProductsEvent.addToCartListProductEvent(
                  context: context,
                  productId: productId,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));
                // Navigator.pop(dialogContext);
              },
            );
          },
        ),
      ),
    );
  }

  showMinMaxDecreaseQtyConfirmDialog(BuildContext context, String productId, String minBox, int index, supplierId, productListIndex) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<SupplierProductsBloc>(),
        child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
          builder: (context1, state) {
            SupplierProductsBloc bloc = context.read<SupplierProductsBloc>();
            return CustomDialog(
              directionality: state.language,
              title: '${AppLocalizations.of(context)?.minimum_box_title}$minBox${AppLocalizations.of(context)?.confirm_minimum_box}',
              positiveTitle: AppLocalizations.of(context)!.yes,
              negativeTitle: AppLocalizations.of(context)!.no,
              negativeOnTap: () async {
                Navigator.pop(context);
              },
              positiveOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(
                  SupplierProductsEvent.decreaseListQuantityOfProduct(
                    context: context,
                    productListIndex: productListIndex,
                    productStockUpdateIndex: index,
                    productSupplierIds: supplierId,
                  ),
                );

                bloc.add(
                  SupplierProductsEvent.addToCartListProductEvent(
                    context: context,
                    productId: productId,
                    productListIndex: productListIndex,
                    productStockUpdateIndex: index,
                    productSupplierIds: supplierId,
                  ),
                );
                // Navigator.pop(dialogContext);
              },
            );
          },
        ),
      ),
    );
  }
}
