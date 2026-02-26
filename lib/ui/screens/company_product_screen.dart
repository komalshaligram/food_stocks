import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/data/model/product_stock_model/product_stock_model.dart';
import '../../bloc/company_products/company_products_bloc.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
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
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_sale_item_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/confetti.dart';
import '../widget/custom_dialog.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';
import '../widget/supplier_products_screen_shimmer_widget.dart';

class CompanyProductsRoute {
  static Widget get route => const CompanyProductsScreen();
}

class CompanyProductsScreen extends StatelessWidget {
  const CompanyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    final String? companyName = args?[AppStrings.companyName];
    final String? companyLogo = args?[AppStrings.companyLogo];
    return BlocProvider(
      create: (context) => CompanyProductsBloc()
        ..add(CompanyProductsEvent.getCompanyProductsIdEvent(companyId: args?[AppStrings.companyIdString]))
        ..add(CompanyProductsEvent.getCompanyProductsListEvent(context: context))
        ..add(CompanyProductsEvent.getPermissionList(context: context))
        ..add(CompanyProductsEvent.userApproveEvent(context: context)),
      child: CompanyProductsScreenWidget(companyName: companyName, companyLogo: companyLogo),
    );
  }
}

class CompanyProductsScreenWidget extends StatelessWidget {
  const CompanyProductsScreenWidget({super.key, required this.companyName, required this.companyLogo});
  final String? companyName;
  final String? companyLogo;

  @override
  Widget build(BuildContext context) {
    CompanyProductsBloc bloc = context.read<CompanyProductsBloc>();
    return BlocListener<CompanyProductsBloc, CompanyProductsState>(
      listener: (context, state) {},
      child: BlocBuilder<CompanyProductsBloc, CompanyProductsState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
            floatingActionButton: !state.isGuestUser
                ? FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.isBasketScreenString: 'true'});
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent, width: 1),
                              gradient: AppColors.appMainGradientColor,
                              borderRadius: const BorderRadius.all(Radius.circular(
                                AppConstants.radius_100,
                              ))),
                          child: Center(
                            child: SvgPicture.asset(
                              AppImagePath.cart,
                              height: 26,
                              width: 26,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                        state.cartCount != 0
                            ? Positioned(
                                top: 5,
                                right: context.rtl ? null : 0,
                                left: context.rtl ? 0 : null,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 24,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                                        border: Border.all(color: AppColors.whiteColor, width: 1),
                                      ),
                                      child: Text(
                                        '${state.cartCount}',
                                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.whiteColor),
                                      ),
                                    ),
                                  ],
                                ),
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
                                colors: [AppColors.mainColor],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : 0.width,
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: state.productList.isNotEmpty ? state.productList.elementAt(0).product?.brandId ?? '' : companyName ?? '',
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                trailingWidget: GestureDetector(
                    onTap: () {
                      context.read<CompanyProductsBloc>().add(const CompanyProductsEvent.getGridListView());
                    },
                    child: Icon(state.isCompanyProductGrid ? Icons.list : Icons.grid_view)),
              ),
            ),
            body: FocusDetector(
              onFocusGained: () {
                bloc.add(const CompanyProductsEvent.getCartCountEvent());
              },
              child: SafeArea(
                child: NotificationListener<ScrollNotification>(
                  child: Stack(children: [
                    Column(
                      children: [
                        100.height,
                        Expanded(
                          child: state.isShimmering
                              ? state.isCompanyProductGrid
                                  ? const SupplierProductsScreenShimmerWidget()
                                  : const StoreCategoryScreenSubcategoryShimmerWidget()
                              : state.productList.isEmpty && state.isShimmering
                                  ? const SupplierProductsScreenShimmerWidget()
                                  : state.productList.isEmpty && !state.isShimmering
                                      ? Container(
                                          height: getScreenHeight(context) - 80,
                                          width: getScreenWidth(context),
                                          margin: const EdgeInsets.only(top: AppConstants.padding_30),
                                          alignment: Alignment.center,
                                          child: Text(
                                            AppLocalizations.of(context)!.this_company_has_no_product,
                                            style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor),
                                          ),
                                        )
                                      : SmartRefresher(
                                          enablePullDown: true,
                                          controller: state.refreshController,
                                          header: const RefreshWidget(),
                                          footer: CustomFooter(
                                            builder: (context, mode) => (state.isCompanyProductGrid && !state.isShimmering && state.isRefreshingProduct)
                                                ? const SupplierProductsScreenShimmerWidget()
                                                : (!state.isCompanyProductGrid && !state.isShimmering && state.isRefreshingProduct)
                                                    ? const StoreCategoryScreenSubcategoryShimmerWidget()
                                                    : const SizedBox(),
                                          ),
                                          enablePullUp: !state.isBottomOfProducts,
                                          onRefresh: () {
                                            context.read<CompanyProductsBloc>().add(CompanyProductsEvent.refreshListEvent(context: context));
                                          },
                                          child: state.isCompanyProductGrid
                                              ? GridView.builder(
                                                  itemCount: state.productList.length,
                                                  shrinkWrap: true,
                                                  physics: const AlwaysScrollableScrollPhysics(),
                                                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      childAspectRatio: getChildAspectRatio(
                                                        context,
                                                        state.isSaleOn,
                                                      )),
                                                  itemBuilder: (context, index) => CommonProductSaleItemWidget(
                                                        title: state.productList[index].product?.productName ?? '',
                                                        description: state.productList[index].product?.sale?.saleDescription ?? '',
                                                        isPesach: state.productList[index].product?.isPesach,
                                                        isGuestUser: state.isGuestUser,
                                                        lowStock: (state.productList[index].product?.lowStock.toString() ?? ''),
                                                        height: AppConstants.relatedProductItemHeight,
                                                        width: 140,
                                                        productStock: (state.productList[index].product?.productStock.toString() ?? '0'),
                                                        saleImage: state.productList[index].product?.mainImage ?? '',
                                                        productName: state.productList[index].product?.productName ?? '',
                                                        originalPrice: state.productList[index].product?.productPrice ?? 0.0,
                                                        isSale: state.productList[index].product?.sale?.isSale,
                                                        discountedPrice: double.parse(state.productList[index].product?.sale?.salePrice ?? '0'),
                                                        quantity: state.productStockList[1][index].quantity,
                                                        minQuantity: state.productList[index].product?.sale?.saleMinQuantity,
                                                        maxQuantity: state.productList[index].product?.sale?.saleMaxQuantity,
                                                        isMixedSale: state.productList[index].product?.sale?.isMixedSale,
                                                        onQuantityChanged: () {
                                                          context.read<CompanyProductsBloc>().add(
                                                                CompanyProductsEvent.updateListQuantityOfProduct(
                                                                  context: context,
                                                                  quantity: state.productStockList[1][index].quantity.toString(),
                                                                  productListIndex: 1,
                                                                  productStockUpdateIndex: index,
                                                                  productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                ),
                                                              );
                                                        },
                                                        onQuantityIncreaseTap: () {
                                                          if (int.parse(state.productList[index].product?.sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity + 1) {
                                                            context.read<CompanyProductsBloc>().add(
                                                                  CompanyProductsEvent.increaseListQuantityOfProduct(
                                                                    context: context,
                                                                    productListIndex: 1,
                                                                    productStockUpdateIndex: index,
                                                                    productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                  ),
                                                                );

                                                            context.read<CompanyProductsBloc>().add(
                                                                  CompanyProductsEvent.addToCartListProductEvent(
                                                                    context: context,
                                                                    productId: state.productList[index].productId.toString(),
                                                                    productListIndex: 1,
                                                                    productStockUpdateIndex: index,
                                                                    productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                  ),
                                                                );
                                                          } else {
                                                            showMinMaxIncreaseQtyConfirmDialog(
                                                              context,
                                                              state.productList[index].productId ?? '',
                                                              state.productList[index].product?.sale?.saleMinQuantity.toString() ?? '0',
                                                              index,
                                                              state.productList[index].product?.supplierId.toString(),
                                                              1,
                                                              state.productList[index].product?.sale?.isMixedSale,
                                                              state.productList[index].product?.sale?.sameSaleProducts,
                                                            );
                                                          }
                                                        },
                                                        onQuantityDecreaseTap: () {
                                                          if (state.productStockList[1][index].quantity != 0) {
                                                            if (int.parse(state.productList[index].product?.sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity - 1) {
                                                              context.read<CompanyProductsBloc>().add(
                                                                    CompanyProductsEvent.decreaseListQuantityOfProduct(
                                                                      context: context,
                                                                      productListIndex: 1,
                                                                      productStockUpdateIndex: index,
                                                                      productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                    ),
                                                                  );

                                                              context.read<CompanyProductsBloc>().add(
                                                                    CompanyProductsEvent.addToCartListProductEvent(
                                                                      context: context,
                                                                      productId: state.productList[index].productId.toString(),
                                                                      productListIndex: 1,
                                                                      productStockUpdateIndex: index,
                                                                      productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                    ),
                                                                  );
                                                            } else {
                                                              showMinMaxDecreaseQtyConfirmDialog(
                                                                context,
                                                                state.productList[index].productId ?? '',
                                                                state.productList[index].product?.sale?.saleMinQuantity.toString() ?? '0',
                                                                index,
                                                                state.productList[index].product?.supplierId.toString(),
                                                                1,
                                                                state.productList[index].product?.sale?.isMixedSale,
                                                                state.productList[index].product?.sale?.sameSaleProducts,
                                                              );
                                                            }
                                                          }
                                                        },
                                                        onButtonTap: () {
                                                          if (!state.isGuestUser) {
                                                            showProductDetails(
                                                              context: context,
                                                              productId: state.productList[index].productId ?? '',
                                                              productStock: (state.productList[index].product?.productStock.toString() ?? '0'),
                                                              productListIndex: 1,
                                                              isSaleOn: state.isSaleOn,
                                                            );
                                                          } else {
                                                            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                          }
                                                        },
                                                      ))
                                              : ListView.builder(
                                                  itemCount: state.productList.length,
                                                  shrinkWrap: true,
                                                  physics: const AlwaysScrollableScrollPhysics(),
                                                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                                                  itemBuilder: (context, index) => CommonSaleListView(
                                                      context: context,
                                                      isPesach: state.productList[index].product?.isPesach ?? false,
                                                      isGuestUser: state.isGuestUser,
                                                      lowStock: (state.productList[index].product?.lowStock.toString() ?? ''),
                                                      numberOfUnits: state.productList[index].product?.numberOfUnit ?? '0',
                                                      productStock: (state.productList[index].product?.productStock.toString() ?? '0'),
                                                      productImage: state.productList[index].product?.mainImage ?? '',
                                                      productName: state.productList[index].product?.productName ?? '',
                                                      price: state.productList[index].product?.productPrice ?? 0.0,
                                                      discountedPrice: (state.productList[index].product?.sale?.isSale ?? false) ? double.parse(state.productList[index].product?.sale?.salePrice.toString() ?? '0') : 0.0,
                                                      isFromSale: state.productList[index].product?.sale?.isSale,
                                                      salesDesc: state.productList[index].product?.sale?.saleDescription,
                                                      quantity: state.productStockList[1][index].quantity,
                                                      minQuantity: state.productList[index].product?.sale?.saleMinQuantity,
                                                      maxQuantity: state.productList[index].product?.sale?.saleMaxQuantity,
                                                      isMixedSale: state.productList[index].product?.sale?.isMixedSale,
                                                      onQuantityChanged: () {
                                                        context.read<CompanyProductsBloc>().add(
                                                              CompanyProductsEvent.updateListQuantityOfProduct(
                                                                context: context,
                                                                quantity: state.productStockList[1][index].quantity.toString(),
                                                                productListIndex: 1,
                                                                productStockUpdateIndex: index,
                                                                productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                              ),
                                                            );
                                                      },
                                                      onQuantityIncreaseTap: () {
                                                        if (int.parse(state.productList[index].product?.sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity + 1) {
                                                          context.read<CompanyProductsBloc>().add(
                                                                CompanyProductsEvent.increaseListQuantityOfProduct(
                                                                  context: context,
                                                                  productListIndex: 1,
                                                                  productStockUpdateIndex: index,
                                                                  productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                ),
                                                              );

                                                          context.read<CompanyProductsBloc>().add(
                                                                CompanyProductsEvent.addToCartListProductEvent(
                                                                  context: context,
                                                                  productId: state.productList[index].productId.toString(),
                                                                  productListIndex: 1,
                                                                  productStockUpdateIndex: index,
                                                                  productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                ),
                                                              );
                                                        } else {
                                                          showMinMaxIncreaseQtyConfirmDialog(
                                                            context,
                                                            state.productList[index].productId ?? '',
                                                            state.productList[index].product?.sale?.saleMinQuantity.toString() ?? '0',
                                                            index,
                                                            state.productList[index].product?.supplierId.toString(),
                                                            1,
                                                            state.productList[index].product?.sale?.isMixedSale,
                                                            state.productList[index].product?.sale?.sameSaleProducts,
                                                          );
                                                        }
                                                      },
                                                      onQuantityDecreaseTap: () {
                                                        if (state.productStockList[1][index].quantity != 0) {
                                                          if (int.parse(state.productList[index].product?.sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity - 1) {
                                                            context.read<CompanyProductsBloc>().add(
                                                                  CompanyProductsEvent.decreaseListQuantityOfProduct(
                                                                    context: context,
                                                                    productListIndex: 1,
                                                                    productStockUpdateIndex: index,
                                                                    productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                  ),
                                                                );

                                                            context.read<CompanyProductsBloc>().add(
                                                                  CompanyProductsEvent.addToCartListProductEvent(
                                                                    context: context,
                                                                    productId: state.productList[index].productId.toString(),
                                                                    productListIndex: 1,
                                                                    productStockUpdateIndex: index,
                                                                    productSupplierIds: state.productList[index].product!.supplierId.toString(),
                                                                  ),
                                                                );
                                                          } else {
                                                            showMinMaxDecreaseQtyConfirmDialog(
                                                              context,
                                                              state.productList[index].productId ?? '',
                                                              state.productList[index].product?.sale?.saleMinQuantity.toString() ?? '0',
                                                              index,
                                                              state.productList[index].product?.supplierId.toString(),
                                                              1,
                                                              state.productList[index].product?.sale?.isMixedSale,
                                                              state.productList[index].product?.sale?.sameSaleProducts,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      onButtonTap: () {
                                                        if (!state.isGuestUser) {
                                                          showProductDetails(
                                                            context: context,
                                                            productId: state.productList[index].productId ?? '',
                                                            productStock: (state.productList[index].product?.productStock.toString() ?? '0'),
                                                            productListIndex: 1,
                                                            isSaleOn: state.isSaleOn,
                                                          );
                                                        } else {
                                                          Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                        }
                                                      }),
                                                ),
                                        ),
                        ),
                      ],
                    ),
                    CommonSearchWidget(
                      onCloseTap: () {
                        bloc.add(const CompanyProductsEvent.changeCategoryExpansion(isOpened: false));
                        context.read<CompanyProductsBloc>().add(CompanyProductsEvent.getCompanyProductsListEvent(context: context));
                      },
                      isFilterTap: true,
                      isCategoryExpand: state.isCategoryExpand,
                      isSearching: state.isSearching,
                      onFilterTap: () {
                        bloc.add(const CompanyProductsEvent.changeCategoryExpansion());
                      },
                      onSearchTap: () {
                        if (state.searchController.text != '') {
                          bloc.add(const CompanyProductsEvent.changeCategoryExpansion(isOpened: true));
                        }
                      },
                      onSearch: (String search) {
                        if (search.length > 1) {
                          bloc.add(const CompanyProductsEvent.changeCategoryExpansion(isOpened: true));
                          bloc.add(CompanyProductsEvent.globalSearchEvent(context: context));
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
                        bloc.add(const CompanyProductsEvent.changeCategoryExpansion(isOpened: false));
                      },
                      onSearchItemTap: () {
                        bloc.add(const CompanyProductsEvent.changeCategoryExpansion());
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
                                        priceOfBox: state.searchList[index].priceOfBox,
                                        salePrice: state.searchList[index].salePrice,
                                        saleDesc: state.searchList[index].salesDesc,
                                        isPesach: state.searchList[index].isPesach,
                                        lowStock: state.searchList[index].lowStock.toString(),
                                        isGuestUser: state.isGuestUser,
                                        numberOfUnits: state.searchList[index].numberOfUnits,
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
                                        isMixedSale: state.searchList[index].isMixedSale,
                                        onQuantityChanged: () {
                                          context.read<CompanyProductsBloc>().add(
                                                CompanyProductsEvent.updateListQuantityOfProduct(
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
                                            context.read<CompanyProductsBloc>().add(
                                                  CompanyProductsEvent.increaseListQuantityOfProduct(
                                                    context: context,
                                                    productListIndex: 0,
                                                    productStockUpdateIndex: index,
                                                    productSupplierIds: state.searchList[index].supplierId.toString(),
                                                  ),
                                                );

                                            context.read<CompanyProductsBloc>().add(
                                                  CompanyProductsEvent.addToCartListProductEvent(
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
                                              state.searchList[index].saleMinQuantity.toString(),
                                              index,
                                              state.searchList[index].supplierId.toString(),
                                              0,
                                              state.searchList[index].isMixedSale,
                                              state.searchList[index].sameSaleProducts,
                                            );
                                          }
                                        },
                                        onQuantityDecreaseTap: () {
                                          if (state.productStockList[0][index].quantity != 0) {
                                            if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity - 1) {
                                              context.read<CompanyProductsBloc>().add(
                                                    CompanyProductsEvent.decreaseListQuantityOfProduct(
                                                      context: context,
                                                      productListIndex: 0,
                                                      productStockUpdateIndex: index,
                                                      productSupplierIds: state.searchList[index].supplierId.toString(),
                                                    ),
                                                  );

                                              context.read<CompanyProductsBloc>().add(
                                                    CompanyProductsEvent.addToCartListProductEvent(
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
                                                state.searchList[index].saleMinQuantity.toString(),
                                                index,
                                                state.searchList[index].supplierId.toString(),
                                                0,
                                                state.searchList[index].isMixedSale,
                                                state.searchList[index].sameSaleProducts,
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
                                              bloc.add(CompanyProductsEvent.updateGlobalSearchEvent(
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
                                              bloc.add(CompanyProductsEvent.updateGlobalSearchEvent(
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
                                            CustomSnackBar.showSnackBar(
                                              context: context,
                                              title: AppStrings.getLocalizedStrings('Oops! in progress', context),
                                              type: SnackBarType.success,
                                            );
                                            return;
                                          }
                                          if (state.searchList[index].searchType == SearchTypes.sale || state.searchList[index].searchType == SearchTypes.product) {
                                            if (!state.isGuestUser) {
                                              showProductDetails(
                                                context: context,
                                                productStock: state.searchList[index].productStock.toString(),
                                                productId: state.searchList[index].searchId,
                                                isBarcode: true,
                                                productListIndex: 0,
                                                isSaleOn: state.isSaleOn,
                                              );
                                            } else {
                                              Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                            }
                                          } else if (state.searchList[index].searchType == SearchTypes.category) {
                                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                                              AppStrings.categoryIdString: state.searchList[index].searchId,
                                              AppStrings.categoryNameString: state.searchList[index].name,
                                              AppStrings.searchString: state.searchController.text,
                                              AppStrings.searchResultString: state.searchList,
                                            });
                                            if (searchResult != null) {
                                              bloc.add(CompanyProductsEvent.updateGlobalSearchEvent(
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
                                          bloc.add(const CompanyProductsEvent.changeCategoryExpansion());
                                        });
                                  },
                                ),
                      onScanTap: () async {
                        String scanResult = await scanBarcodeOrQRCode(
                          context: context,
                          cancelText: AppLocalizations.of(context)!.cancel,
                          scanMode: ScanMode.BARCODE,
                        );
                        if (scanResult != '-1') {
                          if (!state.isGuestUser) {
                            showProductDetails(context: context, productId: scanResult, isBarcode: true, productStock: '1', productListIndex: 0, isSaleOn: state.isSaleOn);
                          } else {
                            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                          }
                        }
                      },
                    ),
                  ]),
                  onNotification: (notification) {
                    if (notification.metrics.pixels > (notification.metrics.maxScrollExtent - 400)) {
                      if (!state.isBottomOfProducts) {
                        context.read<CompanyProductsBloc>().add(CompanyProductsEvent.getCompanyProductsListEvent(context: context));
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

  Widget buildCompanyProducts({
    required BuildContext context,
    required int index,
    required String productImage,
    required String productName,
    required double productPrice,
    required int totalSale,
    required void Function() onPressed,
    required bool isRTL,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10),
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
            child: Image.network(
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
            ),
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
            child: totalSale == 0
                ? 0.width
                : Text(
                    "$totalSale ${AppLocalizations.of(context)!.discount}",
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.saleRedColor, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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

  void showProductDetails({
    required BuildContext context,
    required String productId,
    bool? isBarcode,
    String productStock = '0',
    bool isRelated = false,
    required int productListIndex,
    required bool isSaleOn,
  }) async {
    context.read<CompanyProductsBloc>().add(CompanyProductsEvent.getProductDetailsEvent(
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
            snap: true,
            maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
            minChildSize: productStock == '0' || productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
            initialChildSize: productStock == '0' || productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
            builder: (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                value: context.read<CompanyProductsBloc>(),
                child: BlocBuilder<CompanyProductsBloc, CompanyProductsState>(
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
                                        totalBottleDeposit: (state.bottleDeposit * (state.productDetails.first.numberOfUnit ?? 1) * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                        bottleTax: state.bottleDeposit,
                                        isBottle: state.productDetails.first.isBottle ?? false,
                                        addToOrderTap: () {
                                          if (int.parse(state.productDetails.first.sale!.saleMinQuantity!) <= state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
                                            context.read<CompanyProductsBloc>().add(CompanyProductsEvent.addToCartProductEvent(context: context1, productId: productId));
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
                                                        child: PhotoView(
                                                          imageProvider: NetworkImage(
                                                            '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(dialogContext);
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
                                        productImages: [state.productDetails.first.mainImage ?? ''],
                                        productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'), //state.productDetails.first.sale?.isSale == true ? state.productDetails.first.sale?.salePrice.toString() ?? '' :
                                        productPrice: (state.productDetails.first.sale?.isSale ?? false) ? double.parse(state.productDetails.first.sale?.salePrice ?? '') * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1) : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                        productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                        scrollController: scrollController,
                                        productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                        isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                        onQuantityChanged: (quantity) {
                                          context.read<CompanyProductsBloc>().add(CompanyProductsEvent.updateQuantityOfProduct(
                                                context: context1,
                                                quantity: quantity,
                                              ));
                                        },
                                        onQuantityIncreaseTap: () {
                                          context.read<CompanyProductsBloc>().add(CompanyProductsEvent.increaseQuantityOfProduct(context: context1));
                                        },
                                        onQuantityDecreaseTap: () {
                                          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                            context.read<CompanyProductsBloc>().add(CompanyProductsEvent.decreaseQuantityOfProduct(context: context1));
                                          }
                                        },
                                        onCloseTap: () {
                                          context.read<CompanyProductsBloc>().add(CompanyProductsEvent.getCompanyProductsListEvent(context: context));
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
          height: getItemHeight(context, isSaleOn),
          padding: const EdgeInsets.only(bottom: AppConstants.padding_10, left: AppConstants.padding_10, right: AppConstants.padding_10),
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
                quantity: productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity,
                minQuantity: relatedProductList.elementAt(i).sale?.saleMinQuantity,
                maxQuantity: relatedProductList.elementAt(i).sale?.saleMaxQuantity,
                isMixedSale: relatedProductList.elementAt(i).sale?.isMixedSale,
                onQuantityChanged: () {
                  context.read<CompanyProductsBloc>().add(
                        CompanyProductsEvent.updateListQuantityOfProduct(
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
                    context.read<CompanyProductsBloc>().add(
                          CompanyProductsEvent.increaseListQuantityOfProduct(
                            context: context,
                            productListIndex: 2,
                            productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString(),
                          ),
                        );

                    context.read<CompanyProductsBloc>().add(
                          CompanyProductsEvent.addToCartListProductEvent(
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
                    if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= productStockList[2].firstWhere((test) => test.productId == relatedProductList.elementAt(i).id).quantity - 1) {
                      context.read<CompanyProductsBloc>().add(
                            CompanyProductsEvent.decreaseListQuantityOfProduct(
                              context: context,
                              productListIndex: 2,
                              productStockUpdateIndex: productStockList[2].indexWhere((test) => test.productId == relatedProductList.elementAt(i).id),
                              productSupplierIds: relatedProductList[i].supplierId.toString(),
                            ),
                          );

                      context.read<CompanyProductsBloc>().add(
                            CompanyProductsEvent.addToCartListProductEvent(
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
                  Navigator.pop(prevContext);
                  showProductDetails(
                    isSaleOn: isSaleOn,
                    context: context,
                    productId: relatedProductList[i].id ?? '',
                    isBarcode: false,
                    productStock: relatedProductList[i].productStock.toString(),
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

  showMinQtyConfirmDialog(
    BuildContext context,
    String productId,
    String minBox,
    bool? isMixedSale,
    List? sameSaleProducts,
  ) {
    CompanyProductsBloc bloc = context.read<CompanyProductsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CompanyProductsBloc>(),
        child: BlocBuilder<CompanyProductsBloc, CompanyProductsState>(
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
              isMixedSale: isMixedSale,
              positiveTitle: AppLocalizations.of(context)!.closeText,
              negativeTitle: AppLocalizations.of(context)!.addText,
              negativeOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(CompanyProductsEvent.addToCartProductEvent(context: context, productId: productId));
              },
              positiveOnTap: () async {
                Navigator.pop(context);
                bloc.add(CompanyProductsEvent.getCartCountNoEvent(
                  context: context,
                ));
              },
            );
          },
        ),
      ),
    );
  }

  showMinMaxIncreaseQtyConfirmDialog(
    BuildContext context,
    String productId,
    String minBox,
    int index,
    supplierId,
    productListIndex,
    bool? isMixedSale,
    List? sameSaleProducts,
  ) {
    CompanyProductsBloc bloc = context.read<CompanyProductsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CompanyProductsBloc>(),
        child: BlocBuilder<CompanyProductsBloc, CompanyProductsState>(
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
              isMixedSale: isMixedSale,
              positiveTitle: AppLocalizations.of(context)!.closeText,
              negativeTitle: AppLocalizations.of(context)!.addText,
              negativeOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(CompanyProductsEvent.increaseListQuantityOfProduct(
                  context: context,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));

                bloc.add(CompanyProductsEvent.addToCartListProductEvent(
                  context: context,
                  productId: productId,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));
              },
              positiveOnTap: () async {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  showMinMaxDecreaseQtyConfirmDialog(
    BuildContext context,
    String productId,
    String minBox,
    int index,
    supplierId,
    productListIndex,
    bool? isMixedSale,
    List? sameSaleProducts,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CompanyProductsBloc>(),
        child: BlocBuilder<CompanyProductsBloc, CompanyProductsState>(
          builder: (context1, state) {
            String mixedSale = '';
            if (isMixedSale!) {
              mixedSale = '${AppLocalizations.of(context)?.minimum_box_title}$minBox \n${AppLocalizations.of(context)?.mix_sale_text}\n${AppLocalizations.of(context)?.mixed_sale_other_text}\n${AppLocalizations.of(context)?.sale_other_text} $minBox ${AppLocalizations.of(context)?.sale_other_text1}';
            } else {
              mixedSale = '${AppLocalizations.of(context)?.minimum_box_title}$minBox\n${AppLocalizations.of(context)?.sale_other_text} $minBox ${AppLocalizations.of(context)?.sale_other_text1}';
            }
            CompanyProductsBloc bloc = context.read<CompanyProductsBloc>();
            return CustomDialog(
              directionality: state.language,
              title: mixedSale,
              content: isMixedSale ? sameSaleProducts! : [],
              isMixedSale: isMixedSale,
              positiveTitle: AppLocalizations.of(context)!.closeText,
              negativeTitle: AppLocalizations.of(context)!.addText,
              negativeOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(
                  CompanyProductsEvent.decreaseListQuantityOfProduct(
                    context: context,
                    productListIndex: productListIndex,
                    productStockUpdateIndex: index,
                    productSupplierIds: supplierId,
                  ),
                );

                bloc.add(
                  CompanyProductsEvent.addToCartListProductEvent(
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
              },
            );
          },
        ),
      ),
    );
  }
}
