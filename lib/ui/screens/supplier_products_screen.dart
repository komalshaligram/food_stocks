
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/supplier_products/supplier_products_bloc.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
import 'package:food_stock/data/model/search_model/search_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_product_item_widget.dart';
import 'package:food_stock/ui/widget/common_product_sale_item_widget.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/supplier_products_screen_shimmer_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../routes/app_routes.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_list_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';

class SupplierProductsRoute {
  static Widget get route => SupplierProductsScreen();
}

class SupplierProductsScreen extends StatelessWidget {
  const SupplierProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint('supplier products args = $args');
    return BlocProvider(
      create: (context) => SupplierProductsBloc()
        ..add(SupplierProductsEvent.getSupplierProductsIdEvent(
            supplierId: args?[AppStrings.supplierIdString] ?? '',
            search: args?[AppStrings.searchString] ?? ''))
        ..add(SupplierProductsEvent.getSupplierProductsListEvent(
            context: context, searchType: args?[AppStrings.searchType] ?? '')),
      child: SupplierProductsScreenWidget(),
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
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: state.searchArg.isNotEmpty
                    ? AppLocalizations.of(context)!.search_result
                    : AppLocalizations.of(context)!.products,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                trailingWidget: GestureDetector(
                    onTap: () {
                      context
                          .read<SupplierProductsBloc>()
                          .add(SupplierProductsEvent.getGridListView());
                    },
                    child:
                        Icon(state.isGridView ? Icons.list : Icons.grid_view)),
              ),
            ),
            body: FocusDetector(
              onFocusGained: (){
                bloc.add(SupplierProductsEvent.setCartCountEvent());

                  bloc.add(SupplierProductsEvent.getPermissionList(context: context));

              },
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        100.height,
                        Expanded(
                          child: SmartRefresher(
                            enablePullDown: true,
                            controller: state.refreshController,
                            header: RefreshWidget(),
                            footer: CustomFooter(
                              builder: (context, mode) => state.isGridView
                                  ? SupplierProductsScreenShimmerWidget()
                                  : StoreCategoryScreenSubcategoryShimmerWidget(),
                            ),
                            enablePullUp: !state.isBottomOfProducts,
                            onRefresh: () {
                              context.read<SupplierProductsBloc>().add(
                                  SupplierProductsEvent.refreshListEvent(
                                      context: context));
                            },
                            onLoading: () {
                              context.read<SupplierProductsBloc>().add(
                                  SupplierProductsEvent
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
                                          ? SupplierProductsScreenShimmerWidget()
                                          : StoreCategoryScreenSubcategoryShimmerWidget()
                                      : state.productList.isEmpty
                                          ? Container(
                                              height:
                                                  getScreenHeight(context) - 80,
                                              width: getScreenWidth(context),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${AppLocalizations.of(context)!.currently_this_Supplier_has_no_products}',
                                                style:
                                                    AppStyles.rkRegularTextStyle(
                                                        size: AppConstants
                                                            .smallFont,
                                                        color:
                                                            AppColors.textColor),
                                              ),
                                            )
                                          : state.isGridView
                                              ? GridView.builder(
                                                  itemCount:
                                                      state.productList.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          AppConstants.padding_5),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: getChildAspectRatio(context)),
                                                  itemBuilder: (context, index) {
                                                    return CommonProductSaleItemWidget(
                                                        isGuestUser: state.isGuestUser,
                                                        height: AppConstants.salesProductItemHeight,
                                                        width: 140,
                                                        isSale:state.productList[index].sale!.isSale ,
                                                        productName: state.productList[index].productName??'',
                                                        saleImage: state
                                                            .productList[
                                                        index]
                                                            .mainImage ??
                                                            '',
                                                        title: state
                                                            .productList[
                                                        index]
                                                            .name ??
                                                            '',
                                                        description: parse(state
                                                            .productList[
                                                        index].sale!
                                                            .saleDescription ??
                                                            '')
                                                            .body
                                                            ?.text ??
                                                            '',
                                                        discountedPrice:
                                                        double.parse(state
                                                            .productList[
                                                        index].sale!.salePrice)??0.0,

                                                        originalPrice:double.parse(state
                                                            .productList[
                                                        index]
                                                            .productPrice.toString()) ??
                                                            0.0 ,
                                                        productStock: state.productList[
                                                        index]
                                                            .productStock.toString()??'0',
                                                        lowStock: state
                                                            .productList[
                                                        index]
                                                            .lowStock??'',
                                                        isPesach: state
                                                            .productList[
                                                        index]
                                                            .isPesach,
                                                        onButtonTap: () {
                                                          if (!state
                                                              .isGuestUser) {
                                                            showProductDetails(
                                                              productListIndex: 1,
                                                              context:
                                                              context,
                                                              productId: state
                                                                  .searchType ==
                                                                  SearchTypes
                                                                      .product
                                                                      .toString()
                                                                  ? state.productList[index].id ??
                                                                  ''
                                                                  : state.productList[index]
                                                                  .productId ??
                                                                  '',
                                                              productStock: state
                                                                  .productList[
                                                              index]
                                                                  .productStock.toString(),
                                                            );
                                                          } else {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RouteDefine
                                                                    .connectScreen
                                                                    .name);
                                                          }
                                                        });
                                               /*     return CommonProductItemWidget(
                                                      discountedPrice: state.productList[index].brandName,
                                                      isPesach: state.productList[index].isPesach,
                                                        lowStock: state
                                                            .productList[index]
                                                            .lowStock
                                                            .toString(),
                                                        imageHeight:
                                                            getScreenHeight(context) >= 1000
                                                                ? getScreenHeight(context) *
                                                                    0.17
                                                                : 70,
                                                        imageWidth:
                                                            getScreenWidth(context) >= 700
                                                                ? getScreenWidth(context) *
                                                                    100
                                                                : 70,
                                                        isGuestUser: state
                                                            .isGuestUser,
                                                        productStock: state
                                                            .productList[
                                                                index]
                                                            .productStock.toString(),
                                                        productImage:
                                                            state.productList[index].mainImage ??
                                                                '',
                                                        productName:
                                                            state.productList[index].productName ??
                                                                '',
                                                        totalSaleCount: 0,
                                                        price: double.parse(state
                                                            .productList[index]
                                                            .productPrice
                                                            .toString()),
                                                        onButtonTap: () {
                                                          if (!state
                                                              .isGuestUser) {
                                                            showProductDetails(
                                                              productListIndex: 1,
                                                              context:
                                                                  context,
                                                              productId: state
                                                                          .searchType ==
                                                                      SearchTypes
                                                                          .product
                                                                          .toString()
                                                                  ? state.productList[index].id ??
                                                                      ''
                                                                  : state.productList[index]
                                                                          .productId ??
                                                                      '',
                                                              productStock: state
                                                                  .productList[
                                                                      index]
                                                                  .productStock.toString(),
                                                            );
                                                          } else {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RouteDefine
                                                                    .connectScreen
                                                                    .name);
                                                          }
                                                        });*/
                                                  })
                                              : ListView.builder(
                                                  itemCount:
                                                      state.productList.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          AppConstants.padding_5),
                                                  itemBuilder: (context, index) =>
                                                      CommonSaleListView(
                                                        context: context,
                                                        discountedPrice: double.parse(state.productList[index].sale!.salePrice),
                                                        isFromSale: state.productList[index].sale?.isSale,
                                                        salesDesc: state.productList[index].sale?.saleDescription,
                                                        isPesach: state.productList[index].isPesach,
                                                        numberOfUnits: state.productList[index].numberOfUnit.toString(),
                                                        lowStock: state.productList[index].lowStock.toString(),
                                                        productStock:  state.productList[index].productStock.toString(),
                                                        productImage: state.productList[index].mainImage??'' ,
                                                        productName: state.productList[index].productName ??'',
                                                        price: double.parse(state.productList[index].productPrice.toString()),
                                                        onButtonTap: () {
                                                          if (!state.isGuestUser) {
                                                            showProductDetails(
                                                              productListIndex: 1,
                                                              context: context,
                                                              productId: state
                                                                  .searchType ==
                                                                  SearchTypes
                                                                      .product
                                                                      .toString()
                                                                  ? state.productList[index].id ??
                                                                  ''
                                                                  : state.productList[index]
                                                                  .productId ??
                                                                  '',
                                                              productStock: state
                                                                  .productList[index]
                                                                  .productStock
                                                                  .toString(),
                                                            );
                                                          } else {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RouteDefine
                                                                    .connectScreen
                                                                    .name);
                                                          }
                                                        }, isGuestUser: false,),
                                                    /*  CommonProductListWidget(
                                                        isPesach: state.productList[index].isPesach,
                                                    lowStock: state
                                                        .productList[index]
                                                        .lowStock
                                                        .toString(),
                                                    isGuestUser:
                                                        state.isGuestUser,
                                                    numberOfUnits: state
                                                            .productList[index]
                                                            .numberOfUnit ??
                                                        '0',
                                                    productStock: state
                                                        .productList[index]
                                                        .productStock
                                                        .toString(),
                                                    productImage: state
                                                            .productList[index]
                                                            .mainImage ??
                                                        '',
                                                    productName: state
                                                            .productList[index]
                                                            .productName ??
                                                        '',
                                                    price: double.parse(state
                                                        .productList[index]
                                                        .productPrice
                                                        .toString()),
                                                    onButtonTap: () {
                                                      if (!state.isGuestUser) {
                                                        showProductDetails(
                                                          productListIndex: 1,
                                                          context: context,
                                                          productId: state
                                                              .searchType ==
                                                              SearchTypes
                                                                  .product
                                                                  .toString()
                                                              ? state.productList[index].id ??
                                                              ''
                                                              : state.productList[index]
                                                              .productId ??
                                                              '',
                                                          productStock: state
                                                              .productList[index]
                                                              .productStock
                                                              .toString(),
                                                        );
                                                      } else {
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteDefine
                                                                .connectScreen
                                                                .name);
                                                      }
                                                    },
                                                    totalSaleCount: 0,
                                                  ),*/
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
                        bloc.add(SupplierProductsEvent.changeCategoryExpansion(
                            isOpened: false));
                      },
                      isFilterTap: true,
                      isCategoryExpand: state.isCategoryExpand,
                      isSearching: state.isSearching,
                      onFilterTap: () {
                        bloc.add(SupplierProductsEvent.changeCategoryExpansion());
                      },
                      onSearchTap: () {
                        if (state.searchController.text != '') {
                          bloc.add(SupplierProductsEvent.changeCategoryExpansion(
                              isOpened: true));
                        }
                      },
                      onSearch: (String search) {
                        if (search.length > 1) {
                          bloc.add(SupplierProductsEvent.changeCategoryExpansion(
                              isOpened: true));
                          bloc.add(SupplierProductsEvent.globalSearchEvent(
                              context: context));
                        }
                      },
                      onSearchSubmit: (String search) {
                        Navigator.pushNamed(
                            context, RouteDefine.supplierProductsScreen.name,
                            arguments: {
                              AppStrings.searchString: state.search,
                              AppStrings.searchType:
                                  SearchTypes.product.toString()
                            });
                      },
                      onOutSideTap: () {
                        bloc.add(SupplierProductsEvent.changeCategoryExpansion(
                            isOpened: false));
                      },
                      onSearchItemTap: () {
                        bloc.add(SupplierProductsEvent.changeCategoryExpansion());
                      },
                      controller: state.searchController,
                      searchList: state.searchList,
                      searchResultWidget: state.searchList.isEmpty
                          ? Center(
                              child: Text(
                                '${AppLocalizations.of(context)!.search_result_not_found}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.textColor),
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.searchList.length,
                              shrinkWrap: true,
                              itemBuilder: (listViewContext, index) {
                                return _buildSearchItem(
                                  saleDesc: state.searchList[index].salesDesc,
                                  salePrice: state.searchList[index].salePrice,
                                  isPesach: state.searchList[index].isPesach,
                                    lowStock: state.searchList[index].lowStock
                                        .toString(),
                                    isGuestUser: state.isGuestUser,
                                    numberOfUnits:
                                        state.searchList[index].numberOfUnits,
                                    priceOfBox:
                                        state.searchList[index].priceOfBox,
                                    productStock: state.searchList[index].productStock.toString(),
                                    context: context,
                                    searchName: state.searchList[index].name,
                                    searchImage: state.searchList[index].image,
                                    searchType:
                                        state.searchList[index].searchType,
                                    isMoreResults: state.searchList
                                            .where((search) =>
                                                search.searchType ==
                                                state
                                                    .searchList[index].searchType)
                                            .toList()
                                            .length >=
                                        1,
                                    isLastItem:
                                        state.searchList.length - 1 == index,
                                    isShowSearchLabel: index == 0
                                        ? true
                                        : state.searchList[index].searchType !=
                                                state.searchList[index - 1]
                                                    .searchType
                                            ? true
                                            : false,
                                    onSeeAllTap: () async {
                                      debugPrint(
                                          "searchType: ${state.searchList[index].searchType}");
                                      if (state.searchList[index].searchType ==
                                          SearchTypes.category) {
                                        dynamic searchResult =
                                            await Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .productCategoryScreen.name,
                                                arguments: {
                                              AppStrings.searchString:
                                                  state.search,
                                              AppStrings.reqSearchString:
                                                  state.search,
                                              AppStrings.searchResultString:
                                                  state.searchList
                                            });
                                        if (searchResult != null) {
                                          bloc.add(SupplierProductsEvent
                                              .updateGlobalSearchEvent(
                                                  search: searchResult[
                                                      AppStrings.searchString],
                                                  searchList: searchResult[
                                                      AppStrings
                                                          .searchResultString]));
                                        }
                                      } else if (state
                                              .searchList[index].searchType ==
                                          SearchTypes.subCategory) {
                                        dynamic searchResult =
                                            await Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .storeCategoryScreen.name,
                                                arguments: {
                                              AppStrings.categoryIdString: state
                                                  .searchList[index].categoryId,
                                              AppStrings.categoryNameString: state
                                                  .searchList[index].categoryName,
                                              AppStrings.searchString:
                                                  state.search,
                                              AppStrings.searchResultString:
                                                  state.searchList
                                            });
                                        if (searchResult != null) {
                                          bloc.add(SupplierProductsEvent
                                              .updateGlobalSearchEvent(
                                                  search: searchResult[
                                                      AppStrings.searchString],
                                                  searchList: searchResult[
                                                      AppStrings
                                                          .searchResultString]));
                                        }
                                      } else {
                                        state.searchList[index].searchType ==
                                                SearchTypes.company
                                            ? Navigator.pushNamed(
                                                context, RouteDefine.companyScreen.name,
                                                arguments: {AppStrings.searchString: state.search})
                                            : state.searchList[index].searchType ==
                                                    SearchTypes.supplier
                                                ? Navigator.pushNamed(
                                                    context, RouteDefine.supplierScreen.name,
                                                    arguments: {
                                                        AppStrings.searchString:
                                                            state.search
                                                      })
                                                : state.searchList[index].searchType ==
                                                        SearchTypes.sale
                                                    ? Navigator.pushNamed(context,
                                                        RouteDefine.productSaleScreen.name, arguments: {
                                                        AppStrings.searchString:
                                                            state.search
                                                      })
                                                    : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                                        AppStrings.searchString:
                                                            state.search,
                                                        AppStrings.searchType:
                                                            SearchTypes.product
                                                                .toString()
                                                      });
                                      }
                                    },
                                    onTap: () async {
                                      if (state.searchList[index].searchType ==
                                          SearchTypes.subCategory) {
                                        CustomSnackBar.showSnackBar(
                                          context: context,
                                          title: AppStrings.getLocalizedStrings(
                                              'Oops! in progress', context),
                                          type: SnackBarType.SUCCESS,
                                        );
                                        return;
                                      }
                                      if (state.searchList[index].searchType ==
                                              SearchTypes.sale ||
                                          state.searchList[index].searchType ==
                                              SearchTypes.product) {
                                         debugPrint("tap 4");
                                        if (!state.isGuestUser) {
                                          showProductDetails(
                                            productListIndex: 0,
                                              context: context,
                                              productStock: state
                                                  .searchList[index].productStock
                                                  .toString(),
                                              productId: state
                                                  .searchList[index].searchId,
                                              isBarcode: true);
                                        } else {
                                          Navigator.pushNamed(context,
                                              RouteDefine.connectScreen.name);
                                        }
                                      } else if (state
                                              .searchList[index].searchType ==
                                          SearchTypes.category) {
                                        dynamic searchResult =
                                            await Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .storeCategoryScreen.name,
                                                arguments: {
                                              AppStrings.categoryIdString: state
                                                  .searchList[index].searchId,
                                              AppStrings.categoryNameString:
                                                  state.searchList[index].name,
                                              AppStrings.searchString:
                                                  state.searchController.text,
                                              AppStrings.searchResultString:
                                                  state.searchList
                                            });
                                        if (searchResult != null) {
                                          bloc.add(SupplierProductsEvent
                                              .updateGlobalSearchEvent(
                                                  search: searchResult[
                                                      AppStrings.searchString],
                                                  searchList: searchResult[
                                                      AppStrings
                                                          .searchResultString]));
                                        }
                                      } else {
                                        state.searchList[index].searchType ==
                                                SearchTypes.company
                                            ? Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .companyProductsScreen.name,
                                                arguments: {
                                                    AppStrings.companyIdString:
                                                        state.searchList[index]
                                                            .searchId
                                                  })
                                            : Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .supplierProductsScreen.name,
                                                arguments: {
                                                    AppStrings.supplierIdString:
                                                        state.searchList[index]
                                                            .searchId
                                                  });
                                      }
                                      bloc.add(SupplierProductsEvent
                                          .changeCategoryExpansion());
                                    });
                              },
                            ),
                      onScanTap: () async {
                        String scanResult = await scanBarcodeOrQRCode(
                            context: context,
                            cancelText: AppLocalizations.of(context)!.cancel,
                            scanMode: ScanMode.BARCODE);
                        if (scanResult != '-1') {
                          // -1 result for cancel scanning
                          debugPrint('result = $scanResult');
                           debugPrint("tap 5");
                          if (!state.isGuestUser) {
                            showProductDetails(
                              productListIndex: 0,
                                context: context,
                                // productStock: '1',
                                productId: scanResult,
                                isBarcode: true,
                                productStock: '1');
                          } else {
                            Navigator.pushNamed(
                                context, RouteDefine.connectScreen.name);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSupplierProducts(
      {required BuildContext context,
      required int index,
      required String productImage,
      required String productName,
      required double productPrice,
      required void Function() onPressed,
      required bool isRTL}) {
    return Container(
      // height: 150,
      // width: 130,
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
            child: productImage.isNotEmpty
                ? Image.network(
                    "${AppUrls.baseFileUrl}$productImage",
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
                  )
                : Container(
                    child: Image.asset(AppImagePath.imageNotAvailable5,
                        height: 70,
                        width: double.maxFinite,
                        fit: BoxFit.cover),
                  ),
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
          Expanded(
            child: 0.width,
          ),
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
        ],
      ),
    );
  }

  void showProductDetails(
      {required BuildContext context,
      required String productId,
        required int productListIndex,
      bool? isBarcode,
      String productStock = '0'}) async {
    context.read<SupplierProductsBloc>().add(
        SupplierProductsEvent.getProductDetailsEvent(
            context: context,
            productId: productId,
            productListIndex: productListIndex,
            isBarcode: isBarcode ?? false));
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
    //  isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
     // showDragHandle: true,
     // useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return SafeArea(
          bottom: false,
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)*0.2),
            minChildSize:  productStock == '0' ? 0.9 :  1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)*0.2),
            initialChildSize:  productStock == '0' ? 0.9 :  1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)*0.2),
            builder: (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                value: context.read<SupplierProductsBloc>(),
                child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
                  builder: (blocContext, state) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppConstants.radius_30),
                          topRight: Radius.circular(AppConstants.radius_30),
                        ),
                        color: AppColors.whiteColor,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: state.isProductLoading
                          ? ProductDetailsShimmerWidget()
                          : state.productDetails.isEmpty
                              ? Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.no_product,
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.redColor,
                                        fontWeight: FontWeight.w500,
                                      )),
                                )
                              : SingleChildScrollView(
                        controller:  ModalScrollController.of(context),
                                  child: Column(
                                    children: [
                                      CommonProductDetailsWidget(
                                        salePrice: double.parse(state.productDetails.first.sale.salePrice),
                                        maxQty: state.productDetails.first.sale.saleMaxQuantity,
                                        endDate: state.productDetails.first.sale.saleUntilDate,
                                        startDate: state.productDetails.first.sale.saleFromDate,
                                        isSaleOn: state.productDetails.first.sale.isSale,
                                        isSubUserAddToBasket: state.isSubUserAddToBasket,
                                        bottleTax: state.bottleDeposit,
                                        totalBottleDeposit: (state.bottleDeposit* state.productDetails.first.numberOfUnit!.toDouble()* state
                                            .productStockList[state.productListIndex][
                                        state.productStockUpdateIndex]
                                            .quantity),
                                        isBottle:state.productDetails.first.isBottle,
                                        nmMashlim: state.productDetails.first.nmMashlim,
                                        isPesach: state.productDetails.first.isPesach,
                                        lowStock: state.productDetails.first
                                                .supplierSales?.first.lowStock
                                                .toString() ??
                                            '',
                                        qrCode:
                                            state.productDetails.first.qrcode ,
                                        addToOrderTap: () {
                                          context
                                              .read<SupplierProductsBloc>()
                                              .add(SupplierProductsEvent
                                                  .addToCartProductEvent(
                                                      context: context1,
                                                      productId: productId));
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
                                                    Container(
                                                      height: getScreenHeight(
                                                              context) -
                                                          MediaQuery.of(context)
                                                              .padding
                                                              .top,
                                                      width:
                                                          getScreenWidth(context),
                                                      child: GestureDetector(
                                                        onVerticalDragStart:
                                                            (dragDetails) {
                                                           debugPrint(
                                                              'onVerticalDragStart');
                                                        },
                                                        onVerticalDragUpdate:
                                                            (dragDetails) {
                                                           debugPrint(
                                                              'onVerticalDragUpdate');
                                                        },
                                                        onVerticalDragEnd:
                                                            (endDetails) {
                                                           debugPrint(
                                                              'onVerticalDragEnd');
                                                          Navigator.pop(
                                                              dialogContext);
                                                        },
                                                        child:state.productDetails[state.imageIndex].mainImage != '' ?PhotoView(
                                                          imageProvider:
                                                              NetworkImage(
                                                            '${AppUrls.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                                          ),
                                                        ) : SizedBox(),
                                                      ),
                                                    ),
                                                    GestureDetector (
                                                        onTap: () {
                                                          Navigator.pop(
                                                              dialogContext);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top:10.0),
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
                                        productImageIndex: state.imageIndex,
                                        onPageChanged: (index, p1) {
                                          context
                                              .read<SupplierProductsBloc>()
                                              .add(SupplierProductsEvent
                                                  .updateImageIndexEvent(
                                                      index: index));
                                        },
                                        productImages: [
                                          state.productDetails.first
                                                  .mainImage ,
                                          ...state.productDetails.first.images
                                                  .map((image) =>
                                                      image.imageUrl ?? '')
                                        ],
                                        productPerUnit: state.productDetails
                                                .first.numberOfUnit ,
                                        productUnitPrice: double.parse(state.productDetails.first.supplierSales.first.productPrice.toString()??'0'),
                                        productName: state.productDetails.first
                                                .productName,

                                        productSaleDescription: parse(state
                                                        .productDetails
                                                        .first
                                                        .sale.saleDescription ??
                                                    '')
                                                .body
                                                ?.text ??
                                            '',
                                        productPrice: state.productDetails.first.sale.isSale?
                                        double.parse(state.productDetails.first.sale.salePrice) *
                                            state
                                                .productStockList[state.productListIndex][state
                                                .productStockUpdateIndex]
                                                .quantity *
                                            (state.productDetails.first
                                                .numberOfUnit)
                                            : state
                                                .productStockList[state.productListIndex][state
                                                    .productStockUpdateIndex]
                                                .totalPrice *
                                            state
                                                .productStockList[state.productListIndex][state
                                                    .productStockUpdateIndex]
                                                .quantity *
                                            (state.productDetails.first
                                                    .numberOfUnit),

                                        productWeight: state.productDetails
                                                .first.itemsWeight.toDouble(),
                                        productStock: (state
                                            .productStockList[state.productListIndex][
                                                state.productStockUpdateIndex]
                                            .stock.toString()),
                                        isRTL: context.rtl,
                                        isSupplierAvailable:
                                            state.productSupplierList.isEmpty
                                                ? false
                                                : true,
                                        scrollController: scrollController,
                                        productQuantity: state
                                            .productStockList[state.productListIndex][
                                                state.productStockUpdateIndex]
                                            .quantity,
                                        onQuantityChanged: (quantity) {
                                          context
                                              .read<SupplierProductsBloc>()
                                              .add(SupplierProductsEvent
                                                  .updateQuantityOfProduct(
                                                      context: context1,
                                                      quantity: quantity));
                                        },
                                        onQuantityIncreaseTap: () {
                                          context
                                              .read<SupplierProductsBloc>()
                                              .add(SupplierProductsEvent
                                                  .increaseQuantityOfProduct(
                                                      context: context1));
                                        },
                                        onQuantityDecreaseTap: () {
                                          if (state
                                                  .productStockList[state.productListIndex][state
                                                      .productStockUpdateIndex]
                                                  .quantity >
                                              1) {
                                            context
                                                .read<SupplierProductsBloc>()
                                                .add(SupplierProductsEvent
                                                    .decreaseQuantityOfProduct(
                                                        context: context1));
                                          }
                                        },
                                      ),
                                      state.relatedProductList.isEmpty
                                          ? 0.width
                                          : relatedProductWidget(
                                              context1,
                                              state.relatedProductList,
                                              context),
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

  Widget relatedProductWidget(BuildContext prevContext,
      List<RelatedProductDatum> relatedProductList, BuildContext context) {
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
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.mediumFont, color: AppColors.blackColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          height: AppConstants.salesProductItemHeight,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2, i) {
              return CommonProductSaleItemWidget(
                isSale:  relatedProductList.elementAt(i).sale.isSale,
                isGuestUser: false,
                height: AppConstants.salesProductItemHeight,
                width: 140,
                productName: relatedProductList.elementAt(i).productName??'',
                saleImage: relatedProductList.elementAt(i)
                    .mainImage ??
                    '',
                title:  relatedProductList.elementAt(i)
                    .name ??
                    '',
                description: parse( relatedProductList.elementAt(i).sale
                    .saleDescription ??
                    '')
                    .body
                    ?.text ??
                    '',
                discountedPrice:
                double.parse( relatedProductList.elementAt(i).sale.salePrice),

                originalPrice: relatedProductList.elementAt(i)
                    .productPrice ??
                    0 ,
                productStock: relatedProductList.elementAt(i)
                    .productStock.toString()??'0',
                lowStock: relatedProductList.elementAt(i)
                    .lowStock??'',
                isPesach: relatedProductList.elementAt(i)
                    .isPesach,

                onButtonTap: () {
                  Navigator.pop(prevContext);
                  showProductDetails(
                      context: context,
                      productListIndex: 2,
                      productId: relatedProductList[i].id,
                      isBarcode: false,
                      productStock:
                      (relatedProductList[i].productStock.toString()));
                },);
            },
            itemCount: relatedProductList.length,
          ),
        )
      ],
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
            buttonTitle: "${AppLocalizations.of(context)!.ok}"));
  }

  Widget _buildSearchItem({
    required String lowStock,
    required BuildContext context,
    required String searchName,
    required String searchImage,
    required SearchTypes searchType,
    required bool isShowSearchLabel,
    required bool isMoreResults,
    required void Function() onTap,
    required void Function() onSeeAllTap,
    bool? isLastItem,
    required String productStock,
    bool isGuestUser = false,
    required int numberOfUnits,
    required double priceOfBox,
    required bool isPesach,
    required double salePrice,
    required String saleDesc
  }) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isShowSearchLabel
            ? Padding(
          padding: const EdgeInsets.only(
              left: AppConstants.padding_20,
              right: AppConstants.padding_20,
              top: AppConstants.padding_15,
              bottom: AppConstants.padding_5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                searchType == SearchTypes.category
                    ? AppLocalizations.of(context)!.categories
                    : searchType == SearchTypes.subCategory
                    ? AppLocalizations.of(context)!.sub_categories
                    : searchType == SearchTypes.company
                    ? AppLocalizations.of(context)!.companies
                    : searchType == SearchTypes.sale
                    ? AppLocalizations.of(context)!.sales
                    : searchType == SearchTypes.supplier
                    ? AppLocalizations.of(context)!
                    .suppliers
                    : AppLocalizations.of(context)!
                    .products,
                style: AppStyles.rkBoldTextStyle(
                    size: AppConstants.smallFont,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500),
              ),

              isMoreResults
                  ? GestureDetector(
                onTap: onSeeAllTap,
                child: Text(
                  AppLocalizations.of(context)!.see_all,
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_14,
                      color: AppColors.mainColor),
                ),
              )
                  : 0.width,
            ],
          ),
        )
            : 0.width,
        InkWell(
          onTap: onTap,
          child: Container(
            height: (productStock) != '0' || lowStock.isEmpty ? isPesach?130: 110 : isPesach?130: 110,
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border(
                    bottom: (isLastItem ?? false)
                        ? BorderSide.none
                        : BorderSide(
                        color: AppColors.borderColor.withOpacity(0.5),
                        width: 1))),
            padding: EdgeInsets.only(
                top: AppConstants.padding_5,
                left: getScreenHeight(context)>850?AppConstants.padding_20:AppConstants.padding_10,
                right: getScreenHeight(context)>850?AppConstants.padding_20:AppConstants.padding_10,
                bottom: AppConstants.padding_5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70,
                  width: 50,
                  child: Image.network(
                    '${AppUrls.baseFileUrl}$searchImage',
                    fit: BoxFit.scaleDown,
                    height: 60,
                    width: 50,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                            height: 60,
                            width: 50,
                            child: CupertinoActivityIndicator())
                        ;
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return searchType == SearchTypes.subCategory
                          ? Image.asset(AppImagePath.imageNotAvailable5,
                          height: 60, width: 50, fit: BoxFit.cover)
                          : SvgPicture.asset(
                        AppImagePath.splashLogo,
                        fit: BoxFit.scaleDown,
                        width: 60,
                        height: 50,
                      );
                    },
                  ),
                ),
                10.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: getScreenWidth(context) /1.5,
                      child: Text(
                        searchName,
                        style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_12,
                          color: AppColors.blackColor,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              double.parse(productStock) > 0  && lowStock.isEmpty ? 0.width : productStock == '0' && lowStock.isNotEmpty ? Text(
                                AppLocalizations.of(context)!
                                    .out_of_stock1,
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.redColor,
                                    fontWeight: FontWeight.w400),
                              ) : Text(lowStock,
                                  style: AppStyles.rkBoldTextStyle(
                                      size: AppConstants.font_12,
                                      color: AppColors.orangeColor,
                                      fontWeight: FontWeight.w400)
                              ),
                              numberOfUnits != 0 ? Text(
                                '${numberOfUnits.toString()}${' '}${AppLocalizations.of(context)!.unit_in_box}',
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w400),
                              ) : 0.width,
                              numberOfUnits != 0 && priceOfBox != 0.0 ?
                              salePrice!=0.0 ?   Text.rich(TextSpan(
                                text: '${AppLocalizations
                                    .of(context)
                                    ?.price_par_box} ',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.blackColor),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${AppLocalizations
                                        .of(context)
                                        ?.currency}${(priceOfBox *
                                        (numberOfUnits)).toStringAsFixed(
                                        2)} ',
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_12,
                                        color: AppColors.blackColor).copyWith(
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  TextSpan(
                                    text: ' ${AppLocalizations
                                        .of(context)
                                        ?.currency}${(salePrice *
                                        (numberOfUnits)).toStringAsFixed(
                                        2)}',
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_12,
                                        color: AppColors.redColor),
                                  ),
                                ],
                              ),) :Text(
                                '${AppLocalizations.of(context)?.price_par_box}${' '}${AppLocalizations.of(context)?.currency}${(priceOfBox * numberOfUnits).toStringAsFixed(2)}',
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.blueColor,
                                    fontWeight: FontWeight.w400),): 0.width
                            ],
                          ),
                        ),
                        salePrice!=0.0? Container(
                          child: Column(
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.currency}${priceOfBox.toString()}',
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.blueColor,
                                    fontWeight: FontWeight.w400).copyWith(decoration: TextDecoration.lineThrough),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.currency}${salePrice.toString()}',
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.redColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ):
                        priceOfBox != 0.0 ? Container(
                          width: 60,
                          child: Text(
                            '${AppLocalizations.of(context)!.currency}${priceOfBox.toString()}',
                            style: AppStyles.rkBoldTextStyle(
                                size: AppConstants.font_12,
                                color: AppColors.blueColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ) : 0.width,
                      ],
                    ),
                    3.height,
                    isPesach?
                    isPesachLabelShow(isPesach,context)
                        :0.height,
                    saleDesc.isNotEmpty?
                    Container(
                      width:getScreenWidth(context)/1.5,
                      padding: EdgeInsets.all(3),
                      margin: EdgeInsets.only(top:5),
                      decoration: BoxDecoration(color: AppColors.saleBGColor, border: Border.all(color: AppColors.saleBGColor), borderRadius: BorderRadius.circular(AppConstants.radius_3)),
                      child: Center(
                        child: Text(
                          "${parse(saleDesc).body?.text}",
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.whiteColor,),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        :0.height
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}