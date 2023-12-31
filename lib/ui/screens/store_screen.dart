import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/data/model/search_model/search_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_marquee_widget.dart';
import 'package:food_stock/ui/widget/common_product_button_widget.dart';
import 'package:food_stock/ui/widget/common_product_item_widget.dart';
import 'package:food_stock/ui/widget/common_product_sale_item_widget.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';

import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../bloc/store/store_bloc.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_strings.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_search_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/store_screen_shimmer_widget.dart';

class StoreRoute {
  static Widget get route => const StoreScreen();
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      StoreBloc()
        ..add(StoreEvent.getProductCategoriesListEvent(context: context))..add(
          StoreEvent.getCompaniesListEvent(context: context))..add(
          StoreEvent.getSuppliersListEvent(context: context))..add(
          StoreEvent.getProductSalesListEvent(context: context))..add(
          StoreEvent.getRecommendationProductsListEvent(context: context))..add(
          StoreEvent.getPreviousOrderProductsListEvent(context: context)),
      child: StoreScreenWidget(),
    );
  }
}

class StoreScreenWidget extends StatelessWidget {
  const StoreScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreBloc bloc = context.read<StoreBloc>();
    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {
        if (state.isCartCountChange) {
          BlocProvider.of<BottomNavBloc>(context)
              .add(BottomNavEvent.updateCartCountEvent());
        }
      },
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: FocusDetector(
              onFocusGained: () {
                // if (state.productCategoryList.isEmpty) {
                //   bloc.add(StoreEvent.getProductCategoriesListEvent(
                //       context: context));
                // }
                // if (state.companiesList.isEmpty) {
                //   bloc.add(StoreEvent.getCompaniesListEvent(context: context));
                // }
                // if (state.suppliersList.data?.isEmpty ?? true) {
                //   bloc.add(StoreEvent.getSuppliersListEvent(context: context));
                // }
                // if (state.productSalesList.isEmpty) {
                //   bloc.add(
                //       StoreEvent.getProductSalesListEvent(context: context));
                // }
                // if (state.recommendedProductsList.isEmpty) {
                //   bloc.add(StoreEvent.getRecommendationProductsListEvent(
                //       context: context));
                // }
                // if (state.previousOrderProductsList.isEmpty) {
                //   bloc.add(
                //       StoreEvent.getPreviousOrderProductsListEvent(
                //           context: context));
                // }
              },
              child: SafeArea(
                child: Stack(
                  children: [
                    state.isShimmering
                        ? StoreScreenShimmerWidget()
                        : SingleChildScrollView(
                      child: Column(
                        children: [
                          80.height,
                          AnimatedCrossFade(
                              firstChild: getScreenWidth(context).width,
                              secondChild: Column(
                                children: [
                                  buildListTitles(
                                      context: context,
                                      title: AppLocalizations.of(context)!
                                          .categories,
                                      subTitle: state.productCategoryList
                                          .length <
                                          6
                                          ? ''
                                          : AppLocalizations.of(context)!
                                          .all_categories,
                                      onTap: () async {
                                        dynamic searchResult =
                                        await Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .productCategoryScreen
                                                .name,
                                            arguments: {
                                              AppStrings.searchString:
                                              state.search,
                                              AppStrings
                                                  .searchResultString:
                                              state.searchList
                                            });
                                        if (searchResult != null) {
                                          bloc.add(StoreEvent
                                              .updateGlobalSearchEvent(
                                              search: searchResult[
                                              AppStrings
                                                  .searchString],
                                              searchList: searchResult[
                                              AppStrings
                                                  .searchResultString]));
                                        }
                                      }),
                                  SizedBox(
                                    width: getScreenWidth(context),
                                    height: 110,
                                    child: ListView.builder(
                                      itemCount: state
                                          .productCategoryList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          AppConstants.padding_5),
                                      itemBuilder: (context, index) {
                                        return buildCategoryListItem(
                                            categoryImage: state
                                                .productCategoryList[
                                            index]
                                                .categoryImage ??
                                                '',
                                            categoryName: state
                                                .productCategoryList[
                                            index]
                                                .categoryName ??
                                                '',
                                            isHomePreference: state
                                                .productCategoryList[
                                            index]
                                                .isHomePreference ??
                                                false,
                                            onTap: () async {
                                              dynamic searchResult =
                                              await Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .storeCategoryScreen
                                                      .name,
                                                  arguments: {
                                                    AppStrings
                                                        .categoryIdString:
                                                    state
                                                        .productCategoryList[
                                                    index]
                                                        .id,
                                                    AppStrings
                                                        .categoryNameString:
                                                    state
                                                        .productCategoryList[
                                                    index]
                                                        .categoryName,
                                                    AppStrings
                                                        .searchString:
                                                    state.search,
                                                    AppStrings
                                                        .searchResultString:
                                                    state.searchList
                                                  });
                                              if (searchResult != null) {
                                                bloc.add(StoreEvent
                                                    .updateGlobalSearchEvent(
                                                    search: searchResult[
                                                    AppStrings
                                                        .searchString],
                                                    searchList:
                                                    searchResult[
                                                    AppStrings
                                                        .searchResultString]));
                                              }
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              crossFadeState:
                              state.productCategoryList.isEmpty
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: Duration(milliseconds: 300)),
                          AnimatedCrossFade(
                              firstChild: getScreenWidth(context).width,
                              secondChild: Column(
                                children: [
                                  buildListTitles(
                                      context: context,
                                      title: AppLocalizations.of(context)!.companies,
                                      subTitle: state
                                          .companiesList.length <
                                          6
                                          ? ''
                                          : AppLocalizations.of(context)!
                                          .all_companies,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .companyScreen.name);
                                      }),
                                  SizedBox(
                                    width: getScreenWidth(context),
                                    height: 110,
                                    child: ListView.builder(
                                      itemCount: state.companiesList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          AppConstants.padding_5),
                                      itemBuilder: (context, index) {
                                        return buildCompanyListItem(
                                            companyLogo: state
                                                .companiesList[index]
                                                .brandLogo ??
                                                '',
                                            companyName: state
                                                .companiesList[index]
                                                .brandName ??
                                                '',
                                            isHomePreference: state
                                                .companiesList[index]
                                                .isHomePreference ??
                                                false,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .companyProductsScreen
                                                      .name,
                                                  arguments: {
                                                    AppStrings
                                                        .companyIdString: state
                                                        .companiesList[
                                                    index]
                                                        .id ??
                                                        ''
                                                  });
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              crossFadeState: state.companiesList.isEmpty
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: Duration(milliseconds: 300)),
                          AnimatedCrossFade(
                              firstChild: getScreenWidth(context).width,
                              secondChild: Column(
                                children: [
                                  buildListTitles(
                                      context: context,
                                      title: AppLocalizations.of(context)!
                                          .suppliers,
                                      subTitle: (state.suppliersList.data
                                          ?.length ??
                                          0) <
                                          6
                                          ? ''
                                          : AppLocalizations.of(context)!
                                          .all_suppliers,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .supplierScreen.name);
                                      }),
                                  SizedBox(
                                    width: getScreenWidth(context),
                                    height: 110,
                                    child: ListView.builder(
                                      itemCount: state
                                          .suppliersList.data?.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          AppConstants.padding_5),
                                      itemBuilder: (context, index) {
                                        return buildCompanyListItem(
                                            companyLogo: state
                                                .suppliersList
                                                .data?[index]
                                                .logo ??
                                                '',
                                            companyName: state
                                                .suppliersList
                                                .data?[index]
                                                .supplierDetail
                                                ?.companyName ??
                                                '',
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .supplierProductsScreen
                                                      .name,
                                                  arguments: {
                                                    AppStrings
                                                        .supplierIdString: state
                                                        .suppliersList
                                                        .data?[index]
                                                        .id ??
                                                        ''
                                                  });
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              crossFadeState:
                              state.suppliersList.data?.isEmpty ??
                                  true
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: Duration(milliseconds: 300)),
                          AnimatedCrossFade(
                              firstChild: getScreenWidth(context).width,
                              secondChild: Column(
                                children: [
                                  buildListTitles(
                                      context: context,
                                      title: AppLocalizations.of(context)!
                                          .sales,
                                      subTitle: state.productSalesList
                                          .length <
                                          6
                                          ? ''
                                          : AppLocalizations.of(context)!
                                          .all_sales,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .productSaleScreen.name);
                                      }),
                                  SizedBox(
                                    width: getScreenWidth(context),
                                    height: 190,
                                    child: ListView.builder(
                                      itemCount:
                                      state.productSalesList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          AppConstants.padding_5),
                                      itemBuilder: (context, index) {
                                        return CommonProductSaleItemWidget(
                                            height: 170,
                                            width: 140,
                                            saleImage: state
                                                .productSalesList[index]
                                                .mainImage ??
                                                '',
                                            title: state
                                                .productSalesList[index]
                                                .salesName ??
                                                '',
                                            description: parse(state
                                                .productSalesList[
                                            index]
                                                .salesDescription ??
                                                '')
                                                .body
                                                ?.text ??
                                                '',
                                            salePercentage: double.parse(state
                                                .productSalesList[index]
                                                .discountPercentage ??
                                                '0.0'),
                                            onButtonTap: () {
                                              showProductDetails(
                                                  context: context,
                                                  productId: state
                                                      .productSalesList[
                                                  index]
                                                      .id ??
                                                      '');
                                            });
                                        // return buildProductSaleListItem(
                                        //   context: context,
                                        //   saleImage: state
                                        //       .productSalesList[index]
                                        //       .mainImage ??
                                        //       '',
                                        //   title: state
                                        //       .productSalesList[index]
                                        //       .salesName ??
                                        //       '',
                                        //   description: parse(state
                                        //       .productSalesList[
                                        //   index]
                                        //       .salesDescription ??
                                        //       '')
                                        //       .body
                                        //       ?.text ??
                                        //       '',
                                        //   price: double.parse(state
                                        //       .productSalesList[index]
                                        //       .discountPercentage ??
                                        //       '0.0'),
                                        //   onButtonTap: () {
                                        //     showProductDetails(
                                        //         context: context,
                                        //         productId: state
                                        //             .productSalesList[
                                        //         index]
                                        //             .id ??
                                        //             '');
                                        //   },
                                        // );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              crossFadeState:
                              state.productSalesList.isEmpty
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: Duration(milliseconds: 300)),
                          AnimatedCrossFade(
                              firstChild: getScreenWidth(context).width,
                              secondChild: Column(
                                children: [
                                  buildListTitles(
                                      context: context,
                                      title: AppLocalizations.of(context)!
                                          .recommended_for_you,
                                      subTitle: state
                                          .recommendedProductsList
                                          .length <
                                          6
                                          ? ''
                                          : AppLocalizations.of(context)!
                                          .more,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .recommendationProductsScreen
                                                .name);
                                      }),
                                  SizedBox(
                                    width: getScreenWidth(context),
                                    height: 170,
                                    child: ListView.builder(
                                        itemCount: state
                                            .recommendedProductsList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                            AppConstants.padding_5),
                                        itemBuilder: (context, index) =>
                                            CommonProductItemWidget(
                                              height: 150,
                                              width: 140,
                                              productImage:
                                              state
                                                  .recommendedProductsList[
                                              index]
                                                  .mainImage ??
                                                  '',
                                              productName:
                                              state
                                                  .recommendedProductsList[
                                              index]
                                                  .productName ??
                                                  '',
                                              totalSaleCount:
                                              state
                                                  .recommendedProductsList[
                                              index]
                                                  .totalSale ??
                                                  0,
                                              price:
                                              state
                                                  .recommendedProductsList[
                                              index]
                                                  .productPrice
                                                  ?.toDouble() ??
                                                  0.0,
                                              onButtonTap:
                                                  () {
                                                showProductDetails(
                                                    context: context,
                                                    productId: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .id ??
                                                        '');
                                              },)
                                      // buildRecommendationAndPreviousOrderProductsListItem(
                                      //   context: context,
                                      //   productImage: state
                                      //       .recommendedProductsList[
                                      //   index]
                                      //       .mainImage ??
                                      //       '',
                                      //   productName: state
                                      //       .recommendedProductsList[
                                      //   index]
                                      //       .productName ??
                                      //       '',
                                      //   totalSale: state
                                      //       .recommendedProductsList[
                                      //   index]
                                      //       .totalSale ??
                                      //       0,
                                      //   price: state
                                      //       .recommendedProductsList[
                                      //   index]
                                      //       .productPrice
                                      //       ?.toDouble() ??
                                      //       0.0,
                                      //   onButtonTap: () {
                                      //     showProductDetails(
                                      //         context: context,
                                      //         productId: state
                                      //             .recommendedProductsList[
                                      //         index]
                                      //             .id ??
                                      //             '');
                                      //   },
                                      // )
                                    ),
                                  ),
                                ],
                              ),
                              crossFadeState:
                              state.recommendedProductsList.isEmpty
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: Duration(milliseconds: 300)),
                          AnimatedCrossFade(
                              firstChild: getScreenWidth(context).width,
                              secondChild: Column(
                                children: [
                                  buildListTitles(
                                      context: context,
                                      title: AppLocalizations.of(context)!
                                          .previous_order_products,
                                      subTitle:
                                      state.previousOrderProductsList
                                          .length <
                                          6
                                          ? ''
                                          : AppLocalizations.of(
                                          context)!
                                          .more,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .reorderScreen.name);
                                      }),
                                  SizedBox(
                                    width: getScreenWidth(context),
                                    height: 170,
                                    child: ListView.builder(
                                        itemCount: state
                                            .previousOrderProductsList
                                            .length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                            AppConstants.padding_5),
                                        itemBuilder: (context, index) =>
                                            CommonProductItemWidget(
                                              height: 150,
                                              width: 140,
                                              productImage:
                                              state
                                                  .previousOrderProductsList[
                                              index]
                                                  .mainImage ??
                                                  '',
                                              productName:
                                              state
                                                  .previousOrderProductsList[
                                              index]
                                                  .productName ??
                                                  '',
                                              totalSaleCount:
                                              state
                                                  .previousOrderProductsList[
                                              index]
                                                  .totalSale ??
                                                  0,
                                              price:
                                              state
                                                  .previousOrderProductsList[
                                              index]
                                                  .productPrice
                                                  ?.toDouble() ??
                                                  0.0,
                                              onButtonTap:
                                                  () {
                                                showProductDetails(
                                                    context: context,
                                                    productId: state
                                                        .previousOrderProductsList[
                                                    index]
                                                        .id ??
                                                        '');
                                              },)
                                      // buildRecommendationAndPreviousOrderProductsListItem(
                                      //                                 context: context,
                                      //                                 productImage: state
                                      //                                     .previousOrderProductsList[
                                      //                                 index]
                                      //                                     .mainImage ??
                                      //                                     '',
                                      //                                 productName: state
                                      //                                     .previousOrderProductsList[
                                      //                                 index]
                                      //                                     .productName ??
                                      //                                     '',
                                      //                                 totalSale: state
                                      //                                     .previousOrderProductsList[
                                      //                                 index]
                                      //                                     .totalSale ??
                                      //                                     0,
                                      //                                 price: state
                                      //                                     .previousOrderProductsList[
                                      //                                 index]
                                      //                                     .productPrice
                                      //                                     ?.toDouble() ??
                                      //                                     0.0,
                                      //                                 onButtonTap: () {
                                      //                                   showProductDetails(
                                      //                                       context: context,
                                      //                                       productId: state
                                      //                                           .previousOrderProductsList[
                                      //                                       index]
                                      //                                           .id ??
                                      //                                           '');
                                      //                                 },
                                      //                               )
                                    ),
                                  ),
                                ],
                              ),
                              crossFadeState:
                              state.previousOrderProductsList.isEmpty
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: Duration(milliseconds: 300)),
                          AppConstants.bottomNavSpace.height,
                        ],
                      ),
                    ),
                    CommonSearchWidget(
                      isCategoryExpand: state.isCategoryExpand,
                      isSearching: state.isSearching,
                      onFilterTap: () {
                        bloc.add(StoreEvent.changeCategoryExpansion());
                      },
                      onSearchTap: () {
                        bloc.add(
                            StoreEvent.changeCategoryExpansion(isOpened: true));
                      },
                      onSearch: (String search) {
                        if (search.length > 2) {
                          bloc.add(
                              StoreEvent.globalSearchEvent(context: context));
                        }
                      },
                      onSearchSubmit: (String search) {
                        bloc.add(
                            StoreEvent.globalSearchEvent(context: context));
                      },
                      onOutSideTap: () {
                        bloc.add(StoreEvent.changeCategoryExpansion(
                            isOpened: false));
                      },
                      onSearchItemTap: () {
                        bloc.add(StoreEvent.changeCategoryExpansion());
                      },
                      controller: state.searchController,
                      searchList: state.searchList,
                      searchResultWidget: state.searchList.isEmpty
                          ? Center(
                        child: Text(
                          '${AppLocalizations.of(context)!
                              .search_result_not_found}',
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.textColor),
                        ),
                      )
                          : ListView.builder(
                        itemCount: state.searchList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _buildSearchItem(
                              context: context,
                              searchName: state.searchList[index].name,
                              searchImage: state.searchList[index].image,
                              searchType:
                              state.searchList[index].searchType,
                              isMoreResults: state.searchList
                                  .where((search) =>
                              search.searchType ==
                                  state.searchList[index]
                                      .searchType)
                                  .toList()
                                  .length ==
                                  10,
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
                                    bloc.add(StoreEvent
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
                                      arguments: {
                                        AppStrings.searchString: state.search
                                      })
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
                                      ? Navigator.pushNamed(
                                      context,
                                      RouteDefine.productSaleScreen.name,
                                      arguments: {
                                        AppStrings.searchString: state.search
                                      })
                                      : Navigator.pushNamed(
                                      context,
                                      RouteDefine.supplierProductsScreen.name,
                                      arguments: {
                                        AppStrings.searchString: state.search
                                      });
                                }
                              },
                              onTap: () async {
                                if (state.searchList[index].searchType ==
                                    SearchTypes.sale ||
                                    state.searchList[index].searchType ==
                                        SearchTypes.product) {
                                  showProductDetails(
                                      context: context,
                                      productId: state
                                          .searchList[index].searchId,
                                      isBarcode: true);
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
                                    bloc.add(StoreEvent
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
                                          .supplierProductsScreen
                                          .name,
                                      arguments: {
                                        AppStrings.supplierIdString:
                                        state.searchList[index]
                                            .searchId
                                      });
                                }
                                bloc.add(
                                    StoreEvent.changeCategoryExpansion());
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
                          showProductDetails(
                              context: context,
                              productId: scanResult,
                              isBarcode: true);
                        } /*else {
                          showProductDetails(
                              context: context,
                              productId: "653a337366a6f5add6e02727",
                              isBarcode: true);
                        }*/
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

  Widget _buildSearchItem({
    required BuildContext context,
    required String searchName,
    required String searchImage,
    required SearchTypes searchType,
    required bool isShowSearchLabel,
    required bool isMoreResults,
    required void Function() onTap,
    required void Function() onSeeAllTap,
    bool? isLastItem,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                    : searchType == SearchTypes.company
                    ? AppLocalizations.of(context)!.companies
                    : searchType == SearchTypes.sale
                    ? AppLocalizations.of(context)!.sales
                    : searchType == SearchTypes.supplier
                    ? AppLocalizations.of(context)!.suppliers
                    : AppLocalizations.of(context)!.products,
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
            height: 35,
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border(
                    bottom: (isLastItem ?? false)
                        ? BorderSide.none
                        : BorderSide(
                        color: AppColors.borderColor.withOpacity(0.5),
                        width: 1))),
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.padding_20,
                vertical: AppConstants.padding_5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 35,
                  width: 40,
                  child: Image.network(
                    '${AppUrls.baseFileUrl}$searchImage',
                    fit: BoxFit.scaleDown,
                    height: 35,
                    width: 40,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CommonShimmerWidget(
                            child: Container(
                              width: 40,
                              height: 35,
                              color: AppColors.whiteColor,
                            ));
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        AppImagePath.splashLogo,
                        fit: BoxFit.scaleDown,
                        width: 40,
                        height: 35,
                      );
                    },
                  ),
                ),
                10.width,
                Text(
                  searchName,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_12,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding buildListTitles({required BuildContext context,
    required String title,
    required void Function() onTap,
    required subTitle}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.padding_10,
        right: AppConstants.padding_10,
        top: AppConstants.padding_10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.blackColor),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              subTitle,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: AppColors.mainColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryListItem({required String categoryName,
    required void Function() onTap,
    required String categoryImage,
    required bool isHomePreference}) {
    return !isHomePreference
        ? 0.width
        : Container(
      height: 90,
      width: 90,
      margin: EdgeInsets.symmetric(
          horizontal: AppConstants.padding_5,
          vertical: AppConstants.padding_10),
      clipBehavior: Clip.hardEdge,
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: AppConstants.padding_5,
                left: AppConstants.padding_5,
                right: AppConstants.padding_5,
                bottom: AppConstants.padding_20,
              ),
              child: CachedNetworkImage(
                imageUrl: "${AppUrls.baseFileUrl}$categoryImage",
                fit: BoxFit.contain,
                height: 65,
                width: 80,
                alignment: Alignment.center,
                placeholder: (context, url) {
                  return CommonShimmerWidget(
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                      ),
                      // alignment: Alignment.center,
                      // child: CupertinoActivityIndicator(
                      //   color: AppColors.blackColor,
                      // ),
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  // debugPrint('product category list image error : $error');
                  return Container(
                    // padding: EdgeInsets.only(
                    //     bottom: AppConstants.padding_10, top: 0),
                    child: Image.asset(
                      AppImagePath.imageNotAvailable5,
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // height: 20,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_5,
                    vertical: AppConstants.padding_2),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.radius_10),
                      bottomRight:
                      Radius.circular(AppConstants.radius_10)),
                  // border: Border.all(color: AppColors.whiteColor, width: 1),
                ),
                clipBehavior: Clip.hardEdge,
                child: CommonMarqueeWidget(
                  direction: Axis.horizontal,
                  child: Text(
                    categoryName,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.whiteColor),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProductSaleListItem({
    required BuildContext context,
    required String saleImage,
    required String title,
    required String description,
    required double price,
    required void Function() onButtonTap,
  }) {
    return Container(
      height: 170,
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
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
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onButtonTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: "${AppUrls.baseFileUrl}$saleImage",
                height: 70,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) {
                  return CommonShimmerWidget(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_10)),
                      ),
                      // alignment: Alignment.center,
                      // child: CupertinoActivityIndicator(
                      //   color: AppColors.blackColor,
                      // ),
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  // debugPrint('sale list image error : $error');
                  return Container(
                    child: Image.asset(AppImagePath.imageNotAvailable5,
                        height: 70, width: double.maxFinite, fit: BoxFit.cover),
                  );
                },
              ),
            ),
            5.height,
            Text(
              title,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12,
                  color: AppColors.saleRedColor,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            5.height,
            Expanded(
              child: Text(
                description,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_10, color: AppColors.blackColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            5.height,
            Center(
              child: CommonProductButtonWidget(
                title:
                "${price.toStringAsFixed(
                    0)}%" /*${AppLocalizations.of(context)!.currency}*/,
                onPressed: onButtonTap,
                // height: 35,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRecommendationAndPreviousOrderProductsListItem({
    required BuildContext context,
    required String productImage,
    required String productName,
    required int totalSale,
    required double price,
    required void Function() onButtonTap,
  }) {
    return Container(
      height: 150,
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
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
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onButtonTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: "${AppUrls.baseFileUrl}$productImage",
                height: 70,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) {
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
                },
                errorWidget: (context, error, stackTrace) {
                  // debugPrint('sale list image error : $error');
                  return Container(
                    child: Image.asset(AppImagePath.imageNotAvailable5,
                        height: 70, width: double.maxFinite, fit: BoxFit.cover),
                  );
                },
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
              child: totalSale == 0
                  ? 0.width
                  : Text(
                "${totalSale} ${AppLocalizations.of(context)!.discount}",
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_10,
                    color: AppColors.saleRedColor,
                    fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            5.height,
            Center(
              child: CommonProductButtonWidget(
                title:
                "${price.toStringAsFixed(AppConstants.amountFrLength) == "0.00"
                    ? '0'
                    : price.toStringAsFixed(
                    AppConstants.amountFrLength)}${AppLocalizations.of(context)!
                    .currency}",
                onPressed: onButtonTap,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCompanyListItem({required String companyLogo,
    required String companyName,
    required void Function() onTap,
    bool? isHomePreference}) {
    return !(isHomePreference ?? true)
        ? 0.width
        : Container(
      height: 90,
      width: 90,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: InkWell(
        borderRadius:
        BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding:
              const EdgeInsets.only(bottom: AppConstants.padding_20),
              child: CachedNetworkImage(
                imageUrl: "${AppUrls.baseFileUrl}$companyLogo",
                fit: BoxFit.scaleDown,
                height: 70,
                width: 90,
                placeholder: (context, url) {
                  return CommonShimmerWidget(
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  // debugPrint('product category list image error : $error');
                  return Container(
                    child: Image.asset(
                      AppImagePath.imageNotAvailable5,
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 20,
                // width: 90,
                alignment: Alignment.center,
                // margin:
                //     EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_5,
                    vertical: AppConstants.padding_2),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.only(
                      bottomRight:
                      Radius.circular(AppConstants.radius_10),
                      bottomLeft:
                      Radius.circular(AppConstants.radius_10)),
                  // border: Border.all(color: AppColors.whiteColor, width: 1),
                ),
                child: CommonMarqueeWidget(
                  direction: Axis.horizontal,
                  child: Text(
                    companyName,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.whiteColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCategoryFilterItem(
      {required String category, required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border(
                bottom: BorderSide(
                    color: AppColors.borderColor.withOpacity(0.5), width: 1))),
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.padding_20,
            vertical: AppConstants.padding_15),
        child: Text(
          category,
          style: AppStyles.rkRegularTextStyle(
            size: AppConstants.font_12,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }

  void showProductDetails({required BuildContext context,
    required String productId,
    bool? isBarcode}) async {
    context.read<StoreBloc>().add(StoreEvent.getProductDetailsEvent(
        context: context, productId: productId, isBarcode: isBarcode));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<StoreBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery
                    .of(context)
                    .viewPadding
                    .top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: AppConstants.bottomSheetInitHeight,
            //shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<StoreBloc>(),
                  child: BlocBuilder<StoreBloc, StoreState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppConstants.radius_30),
                            topRight: Radius.circular(AppConstants.radius_30),
                          ),
                          color: AppColors.whiteColor,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Scaffold(
                          body: state.isProductLoading
                              ? ProductDetailsShimmerWidget()
                              : CommonProductDetailsWidget(
                              context: context,

                              productImageIndex: state.imageIndex,
                              onPageChanged: (index, p1) {
                                context.read<StoreBloc>().add(
                                    StoreEvent.updateImageIndexEvent(
                                        index: index));
                              },
                              productImages: [
                                state.productDetails.first.mainImage ?? '',
                                ...state.productDetails.first.images?.map(
                                        (image) => image.imageUrl ?? '') ??
                                    []
                              ],
                              productName: state.productDetails.first
                                  .productName ??
                                  '',
                              productCompanyName:
                              state.productDetails.first.brandName ??
                                  '',
                              productDescription:
                              parse(state.productDetails.first
                                  .productDescription ?? '')
                                  .body
                                  ?.text ??
                                  '',
                              productSaleDescription:
                              parse(state.productDetails.first
                                  .productDescription ?? '')
                                  .body
                                  ?.text ??
                                  '',
                              productPrice: state
                                  .productStockList[
                              state.productStockUpdateIndex]
                                  .totalPrice *
                                  state
                                      .productStockList[state
                                      .productStockUpdateIndex]
                                      .quantity,
                              productScaleType: state.productDetails.first
                                  .scales?.scaleType ?? '',
                              productWeight: state.productDetails.first
                                  .itemsWeight?.toDouble() ?? 0.0,
                              isNoteOpen: state.productStockList[state
                                  .productStockUpdateIndex].isNoteOpen,
                              onNoteToggleChanged: () {
                                context.read<StoreBloc>().add(
                                    StoreEvent.toggleNoteEvent(
                                        isBarcode: isBarcode ?? false));
                              },
                              supplierWidget: state.productSupplierList.isEmpty
                                  ? Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: AppColors
                                                .borderColor
                                                .withOpacity(0.5),
                                            width: 1))),
                                padding: const EdgeInsets.symmetric(
                                    vertical:
                                    AppConstants.padding_30),
                                alignment: Alignment.center,
                                child: Text(
                                  '${AppLocalizations.of(context)!
                                      .suppliers_not_available}',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor),
                                ),
                              )
                                  : buildSupplierSelection(context: context),
                              productStock: state.productStockList[state
                                  .productStockUpdateIndex].stock,
                              isRTL: context.rtl,
                              isSupplierAvailable: state.productSupplierList
                                  .isEmpty ? false : true,
                              scrollController: scrollController,
                              productQuantity: state.productStockList[state
                                  .productStockUpdateIndex].quantity,
                              onQuantityChanged: (quantity) {
                                context.read<StoreBloc>().add(
                                    StoreEvent.updateQuantityOfProduct(
                                        context: context1,
                                        quantity: quantity));
                              },
                              onQuantityIncreaseTap: () {
                                context.read<StoreBloc>().add(
                                    StoreEvent.increaseQuantityOfProduct(
                                        context: context1));
                              },
                              onQuantityDecreaseTap: () {
                                context.read<StoreBloc>().add(
                                    StoreEvent.decreaseQuantityOfProduct(
                                        context: context1));
                              },
                              noteController: state.noteController,
                              // TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note)..selection = TextSelection.fromPosition(TextPosition(offset: state.productStockList[state.productStockUpdateIndex].note.length)),
                              onNoteChanged: (newNote) {
                                context.read<StoreBloc>().add(
                                    StoreEvent.changeNoteOfProduct(
                                        newNote: newNote));
                              },
                              isLoading: state.isLoading,
                              onAddToOrderPressed: state.isLoading
                                  ? null
                                  : () {
                                context.read<StoreBloc>().add(
                                    StoreEvent.addToCartProductEvent(
                                        context: context1));
                              }),
                        ),
                      );
                    },
                  ));
            },
          ),
        );
      },
    );
  }

  Widget buildSupplierSelection({required BuildContext context}) {
    return BlocProvider.value(
      value: context.read<StoreBloc>(),
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return AnimatedCrossFade(
              firstChild: Container(
                width: getScreenWidth(context),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: AppColors.borderColor.withOpacity(0.5),
                            width: 1))),
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding_10,
                    horizontal: AppConstants.padding_30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: AppConstants.padding_5),
                      child: InkWell(
                        onTap: () {
                          context.read<StoreBloc>().add(StoreEvent
                              .changeSupplierSelectionExpansionEvent());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.suppliers,
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.smallFont,
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 26,
                              color: AppColors.blackColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    state.productSupplierList
                        .where((supplier) => supplier.selectedIndex != -1)
                        .isEmpty
                        ? InkWell(
                        onTap: () {
                          context.read<StoreBloc>().add(StoreEvent
                              .changeSupplierSelectionExpansionEvent());
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 60,
                          width: getScreenWidth(context),
                          alignment: Alignment.center,
                          child: Text(
                            '${AppLocalizations.of(context)!.select_supplier}',
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.blackColor),
                          ),
                        ))
                        : ListView.builder(
                      itemCount: state.productSupplierList
                          .where((supplier) =>
                      supplier.selectedIndex != -1)
                          .isNotEmpty
                          ? 1
                          : 0,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 85,
                          padding: EdgeInsets.symmetric(
                              vertical: AppConstants.padding_5,
                              horizontal: AppConstants.padding_10),
                          margin: EdgeInsets.symmetric(
                              vertical: AppConstants.padding_5),
                          decoration: BoxDecoration(
                            color: AppColors.iconBGColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppConstants.radius_5)),
                            border: Border.all(
                                color: AppColors.borderColor
                                    .withOpacity(0.8),
                                width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${state.productSupplierList
                                    .firstWhere((supplier) =>
                                supplier.selectedIndex != -1)
                                    .companyName}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Expanded(
                                child: Container(
                                  width: getScreenWidth(context),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.borderColor
                                              .withOpacity(0.5),
                                          width: 1),
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppConstants.radius_5))),
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppConstants.padding_3,
                                      horizontal: AppConstants.padding_5),
                                  margin: EdgeInsets.only(
                                    top: AppConstants.padding_5,
                                  ),
                                  child: state.productSupplierList
                                      .firstWhere(
                                        (supplier) =>
                                    supplier
                                        .selectedIndex ==
                                        -2,
                                    orElse: () =>
                                        ProductSupplierModel(
                                            supplierId: '',
                                            companyName: ''),
                                  )
                                      .selectedIndex ==
                                      -2
                                      ? Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'Price : ${state.productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex == -2)
                                            .basePrice
                                            .toStringAsFixed(AppConstants
                                            .amountFrLength)}${AppLocalizations
                                            .of(context)!.currency}',
                                        style: AppStyles
                                            .rkRegularTextStyle(
                                            size: AppConstants
                                                .font_14,
                                            color: AppColors
                                                .blackColor),
                                      ),
                                    ],
                                  )
                                      : Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '${state.productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index].saleName}',
                                        style: AppStyles
                                            .rkRegularTextStyle(
                                            size: AppConstants
                                                .font_12,
                                            color: AppColors
                                                .saleRedColor),
                                      ),
                                      2.height,
                                      Text(
                                        'Price : ${state.productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index].salePrice
                                            .toStringAsFixed(AppConstants
                                            .amountFrLength)}${AppLocalizations
                                            .of(context)!.currency}(${state
                                            .productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index].saleDiscount
                                            .toStringAsFixed(0)}%)',
                                        style: AppStyles
                                            .rkRegularTextStyle(
                                            size: AppConstants
                                                .font_14,
                                            color: AppColors
                                                .blackColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              secondChild: state.productSupplierList.isEmpty
                  ? Center(
                child: Text(
                  '${AppLocalizations.of(context)!.suppliers_not_available}',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: AppColors.textColor),
                ),
              )
                  : ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: getScreenHeight(context) * 0.5,
                    maxWidth: getScreenWidth(context)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color:
                              AppColors.borderColor.withOpacity(0.5),
                              width: 1))),
                  padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.padding_10,
                      horizontal: AppConstants.padding_30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppConstants.padding_5),
                        child: InkWell(
                          onTap: () {
                            context.read<StoreBloc>().add(StoreEvent
                                .changeSupplierSelectionExpansionEvent());
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.suppliers,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Icon(
                                Icons.remove,
                                size: 26,
                                color: AppColors.blackColor,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.productSupplierList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 105,
                              padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.padding_5,
                                  horizontal: AppConstants.padding_10),
                              margin: EdgeInsets.symmetric(
                                  vertical: AppConstants.padding_10),
                              decoration: BoxDecoration(
                                  color: AppColors.iconBGColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          AppConstants.radius_10)),
                                  boxShadow: [
                                    state.productSupplierList[index]
                                        .selectedIndex !=
                                        -1
                                        ? BoxShadow(
                                        color: AppColors.shadowColor
                                            .withOpacity(0.15),
                                        blurRadius:
                                        AppConstants.blur_10)
                                        : BoxShadow()
                                  ],
                                  border: Border.all(
                                      color: AppColors.lightBorderColor,
                                      width: 1)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${state.productSupplierList[index]
                                        .companyName}',
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_14,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state
                                          .productSupplierList[index]
                                          .supplierSales
                                          .length +
                                          1,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, subIndex) {
                                        return subIndex ==
                                            state
                                                .productSupplierList[
                                            index]
                                                .supplierSales
                                                .length
                                            ? InkWell(
                                          onTap: () {
                                            //for base price selection /without sale pass -2
                                            context
                                                .read<StoreBloc>()
                                                .add(StoreEvent
                                                .supplierSelectionEvent(
                                                supplierIndex:
                                                index,
                                                context:
                                                context,
                                                supplierSaleIndex:
                                                -2));
                                            context
                                                .read<StoreBloc>()
                                                .add(StoreEvent
                                                .changeSupplierSelectionExpansionEvent());
                                          },
                                          splashColor:
                                          Colors.transparent,
                                          highlightColor:
                                          Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .whiteColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppConstants
                                                            .radius_10)),
                                                border: Border.all(
                                                    color: state
                                                        .productSupplierList[
                                                    index]
                                                        .selectedIndex ==
                                                        -2
                                                        ? AppColors
                                                        .mainColor
                                                        .withOpacity(
                                                        0.8)
                                                        : Colors
                                                        .transparent,
                                                    width: 1.5)),
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                AppConstants
                                                    .padding_3,
                                                horizontal:
                                                AppConstants
                                                    .padding_5),
                                            margin: EdgeInsets.only(
                                                top: AppConstants
                                                    .padding_5,
                                                left: AppConstants
                                                    .padding_5,
                                                right: AppConstants
                                                    .padding_5),
                                            alignment:
                                            Alignment.center,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Price : ${state
                                                      .productSupplierList[index]
                                                      .basePrice
                                                      .toStringAsFixed(
                                                      AppConstants
                                                          .amountFrLength)}${AppLocalizations
                                                      .of(context)!.currency}',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                      size: AppConstants
                                                          .font_14,
                                                      color: AppColors
                                                          .blackColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                            : InkWell(
                                          onTap: () {
                                            context
                                                .read<StoreBloc>()
                                                .add(StoreEvent
                                                .supplierSelectionEvent(
                                                supplierIndex:
                                                index,
                                                context:
                                                context,
                                                supplierSaleIndex:
                                                subIndex));
                                            context
                                                .read<StoreBloc>()
                                                .add(StoreEvent
                                                .changeSupplierSelectionExpansionEvent());
                                          },
                                          splashColor:
                                          Colors.transparent,
                                          highlightColor:
                                          Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .whiteColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppConstants
                                                            .radius_10)),
                                                border: Border.all(
                                                    color: state
                                                        .productSupplierList[index]
                                                        .selectedIndex ==
                                                        subIndex
                                                        ? AppColors
                                                        .mainColor
                                                        .withOpacity(
                                                        0.8)
                                                        : Colors
                                                        .transparent,
                                                    width: 1.5)),
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                AppConstants
                                                    .padding_3,
                                                horizontal:
                                                AppConstants
                                                    .padding_5),
                                            margin: EdgeInsets.only(
                                                top: AppConstants
                                                    .padding_5,
                                                left: AppConstants
                                                    .padding_5,
                                                right: AppConstants
                                                    .padding_5),
                                            alignment:
                                            Alignment.center,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${state
                                                      .productSupplierList[index]
                                                      .supplierSales[subIndex]
                                                      .saleName}',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                      size: AppConstants
                                                          .font_12,
                                                      color: AppColors
                                                          .saleRedColor),
                                                ),
                                                2.height,
                                                Text(
                                                  'Price : ${state
                                                      .productSupplierList[index]
                                                      .supplierSales[subIndex]
                                                      .salePrice
                                                      .toStringAsFixed(
                                                      AppConstants
                                                          .amountFrLength)}${AppLocalizations
                                                      .of(context)!
                                                      .currency}(${state
                                                      .productSupplierList[index]
                                                      .supplierSales[subIndex]
                                                      .saleDiscount
                                                      .toStringAsFixed(0)}%)',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                      size: AppConstants
                                                          .font_14,
                                                      color: AppColors
                                                          .blackColor),
                                                ),
                                                2.height,
                                                GestureDetector(
                                                    onTap: () {
                                                      showConditionDialog(
                                                          context:
                                                          context,
                                                          saleCondition:
                                                          '${state
                                                              .productSupplierList[index]
                                                              .supplierSales[subIndex]
                                                              .saleDescription}');
                                                    },
                                                    child: Text(
                                                      'Read condition',
                                                      style: AppStyles
                                                          .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .font_10,
                                                          color: AppColors
                                                              .blueColor),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              crossFadeState: state.isSelectSupplier
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300));
        },
      ),
    );
  }

  void showConditionDialog(
      {required BuildContext context, required String saleCondition}) {
    showDialog(
        context: context,
        builder: (context) =>
            CommonSaleDescriptionDialog(
                title: saleCondition,
                onTap: () {
                  Navigator.pop(context);
                },
                buttonTitle: "OK"));
  }
}
