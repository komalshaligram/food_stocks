import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
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
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../bloc/store/store_bloc.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_strings.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
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
      create: (context) {
        return StoreBloc()
          ..add(StoreEvent.getProductCategoriesListEvent(context: context))..add(
              StoreEvent.getCompaniesListEvent(context: context))..add(
              StoreEvent.getSuppliersListEvent(context: context))..add(
              StoreEvent.getProductSalesListEvent(context: context))..add(
              StoreEvent.getRecommendationProductsListEvent(context: context))..add(
              StoreEvent.getPreviousOrderProductsListEvent(context: context));
      },
      child: StoreScreenWidget(),
    );
  }
}

class StoreScreenWidget extends StatelessWidget {
  StoreScreenWidget({Key? key}) : super(key: key);

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
                //  if(state.productCategoryList.isEmpty) {
                //     bloc.add(StoreEvent.getProductCategoriesListEvent(context: context));
                //      bloc.add(StoreEvent.getCompaniesListEvent(context: context));
                //      bloc.add(StoreEvent.getSuppliersListEvent(context: context));
                //      bloc.add(StoreEvent.getProductSalesListEvent(context: context));
                //      bloc.add(StoreEvent.getRecommendationProductsListEvent(context: context));
                //      bloc.add(StoreEvent.getPreviousOrderProductsListEvent(context: context));
                //   }
              },
              child: SafeArea(
                child: Stack(
                  children: [
                    SmartRefresher(
                      enablePullDown: true,
                      controller: state.refreshController,
                      header: CustomHeader(
                        refreshStyle: RefreshStyle.Behind,
                        builder: (c, m) {
                          return Container(
                            height: 30,
                            width: 30,
                            margin: EdgeInsets.only(top: 90),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: AppColors.shadowColor.withOpacity(0.1),
                                  blurRadius: AppConstants.blur_10)
                            ], color: AppColors.whiteColor, shape: BoxShape.circle),
                            child: CupertinoActivityIndicator(
                              color: AppColors.mainColor,
                              radius: 10,
                            ),
                          );
                        },
                      ),
                      footer: CustomFooter(
                        builder: (context, mode) => StoreScreenShimmerWidget(),
                      ),
                      onRefresh: () {
                        bloc.add(StoreEvent.getProductCategoriesListEvent(
                            context: context));
                        bloc.add(
                            StoreEvent.getCompaniesListEvent(context: context));
                        bloc.add(
                            StoreEvent.getSuppliersListEvent(context: context));
                        bloc.add(StoreEvent.getProductSalesListEvent(
                            context: context));
                        bloc.add(StoreEvent.getRecommendationProductsListEvent(
                            context: context));
                        bloc.add(StoreEvent.getPreviousOrderProductsListEvent(
                            context: context));
                        state.refreshController.refreshCompleted();
                        state.refreshController.loadComplete();
                      },
                      child: SingleChildScrollView(
                        child: state.isShimmering && state.productCategoryList.isEmpty
                            ? StoreScreenShimmerWidget()
                            : AnimationLimiter(
                          child: Column(
                            children:
                            AnimationConfiguration.toStaggeredList(
                              duration: const Duration(seconds: 1),
                              childAnimationBuilder: (widget) =>
                                  SlideAnimation(
                                      verticalOffset:
                                      MediaQuery.of(context)
                                          .size
                                          .height /
                                          5,
                                      child:
                                      FadeInAnimation(child: widget)),
                              children: [
                                80.height,
                                AnimatedCrossFade(
                                    firstChild:
                                    getScreenWidth(context).width,
                                    secondChild: Column(
                                      children: [
                                        state.isCatVisible ?   buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(
                                                context)!
                                                .categories,
                                            subTitle: /*state.productCategoryList
                                              .length <
                                              6
                                              ? ''
                                              : */
                                            AppLocalizations.of(
                                                context)!
                                                .all_categories,
                                            onTap: () async {
                                              dynamic searchResult =
                                              await Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .productCategoryScreen
                                                      .name,
                                                  arguments: {
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
                                            }):Container(),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height: state.isCatVisible? 125:0,
                                          child: ListView.builder(
                                            itemCount: state
                                                .productCategoryList
                                                .length,
                                            shrinkWrap: true,
                                            scrollDirection:
                                            Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: AppConstants
                                                    .padding_5),
                                            itemBuilder:
                                                (context, index) {
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
                                                    await Navigator
                                                        .pushNamed(
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
                                                          AppStrings.categoryNameString: state
                                                              .productCategoryList[
                                                          index]
                                                              .categoryName,
                                                          /* AppStrings
                                                                        .searchString:
                                                                    state
                                                                        .search,
                                                                AppStrings
                                                                        .searchResultString:
                                                                    state
                                                                        .searchList*/
                                                        });
                                                    if (searchResult !=
                                                        null) {
                                                      bloc.add(StoreEvent.updateGlobalSearchEvent(
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
                                    duration:
                                    Duration(milliseconds: 300)),
                                AnimatedCrossFade(
                                    firstChild:
                                    getScreenWidth(context).width,
                                    secondChild: Column(
                                      children: [
                                        state.isCompanyVisible?buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(
                                                context)!
                                                .companies,
                                            subTitle: /*state
                                              .companiesList.length <
                                              6
                                              ? ''
                                              : */
                                            AppLocalizations.of(
                                                context)!
                                                .all_companies,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .companyScreen
                                                      .name);
                                            }):Container(),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height:   state.isCompanyVisible ? 130:0,
                                          child: ListView.builder(
                                            itemCount: state
                                                .companiesList.length,
                                            shrinkWrap: true,
                                            scrollDirection:
                                            Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: AppConstants
                                                    .padding_5),
                                            itemBuilder:
                                                (context, index) {
                                              return buildCompanyListItem(
                                                  companyLogo: state
                                                      .companiesList[
                                                  index]
                                                      .brandLogo ??
                                                      '',
                                                  companyName: state
                                                      .companiesList[
                                                  index]
                                                      .brandName ??
                                                      '',
                                                  isHomePreference: state
                                                      .companiesList[
                                                  index]
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
                                                              '',
                                                          AppStrings
                                                              .companyLogo: state
                                                              .companiesList[
                                                          index]
                                                              .brandLogo ??
                                                              '',
                                                          AppStrings
                                                              .companyName: state
                                                              .companiesList[
                                                          index]
                                                              .brandName ??
                                                              '',
                                                        });
                                                  });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    crossFadeState:
                                    state.companiesList.isEmpty
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    duration:
                                    Duration(milliseconds: 300)),
                                AnimatedCrossFade(
                                    firstChild:
                                    getScreenWidth(context).width,
                                    secondChild: Column(
                                      children: [
                                        state.isSupplierVisible ? buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(
                                                context)!
                                                .suppliers,
                                            subTitle: /*(state.suppliersList.data
                                              ?.length ??
                                              0) <
                                              6
                                              ? ''
                                              : */
                                            AppLocalizations.of(
                                                context)!
                                                .all_suppliers,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .supplierScreen
                                                      .name);
                                            }):Container(),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height:state.isSupplierVisible?  130:0,
                                          child: ListView.builder(
                                            itemCount: state.suppliersList
                                                .data?.length,
                                            shrinkWrap: true,
                                            scrollDirection:
                                            Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: AppConstants
                                                    .padding_5),
                                            itemBuilder:
                                                (context, index) {
                                              return buildCompanyListItem(
                                                  companyLogo: state
                                                      .suppliersList
                                                      .data?[index]
                                                      .logo ??
                                                      '',
                                                  /*    isHomePreference:  (state.suppliersList.data != null )  ?  (state
                                                            .suppliersList.data?[index]
                                                            .supplierDetail?.isHomePreference ??
                                                            false) : false,*/
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
                                                              .data?[
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
                                    crossFadeState: state.suppliersList
                                        .data?.isEmpty ??
                                        true
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    duration:
                                    Duration(milliseconds: 300)),
                                AnimatedCrossFade(
                                    firstChild:
                                    getScreenWidth(context).width,
                                    secondChild: Column(
                                      children: [
                                        buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(
                                                context)!
                                                .sales,
                                            subTitle: /*state.productSalesList
                                              .length <
                                              6
                                              ? ''
                                              : */
                                            AppLocalizations.of(
                                                context)!
                                                .all_sales,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .productSaleScreen
                                                      .name);
                                            }),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height: state.isGuestUser ? 180 :190 ,
                                          child: ListView.builder(
                                            itemCount: state
                                                .productSalesList.length,
                                            shrinkWrap: true,
                                            scrollDirection:
                                            Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: AppConstants
                                                    .padding_5),
                                            itemBuilder:
                                                (context, index) {
                                              return CommonProductSaleItemWidget(
                                                  isGuestUser: state.isGuestUser,
                                                  height: 180,
                                                  width: 140,
                                                  productName: state.productSalesList[index].productName??'',
                                                  saleImage: state
                                                      .productSalesList[
                                                  index]
                                                      .mainImage ??
                                                      '',
                                                  title: state
                                                      .productSalesList[
                                                  index]
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
                                                  salePercentage:
                                                  double.parse(state
                                                      .productSalesList[
                                                  index]
                                                      .discountPercentage ??
                                                      '0.0'),
                                                  discountedPrice: state
                                                      .productSalesList[
                                                  index]
                                                      .discountedPrice ??
                                                      0,
                                                  onButtonTap: () {
                                                    print("tap 1");
                                                    if(!state.isGuestUser){
                                                      showProductDetails(
                                                        context: context,
                                                        productId: state
                                                            .productSalesList[
                                                        index]
                                                            .id ??
                                                            '',
                                                      );
                                                    }
                                                    else{
                                                      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                    }

                                                  });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    crossFadeState:
                                    state.productSalesList.isEmpty
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    duration:
                                    Duration(milliseconds: 300)),
                                !state.isGuestUser ?  AnimatedCrossFade(
                                    firstChild:
                                    getScreenWidth(context).width,
                                    secondChild: Column(
                                      children: [
                                        buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(context)!.recommended_for_you,
                                            subTitle: AppLocalizations.of(context)!.more,
                                            onTap: () {
                                              Navigator.pushNamed(context, RouteDefine.recommendationProductsScreen.name);
                                            }),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height: 175,
                                          child: ListView.builder(
                                              itemCount: state
                                                  .recommendedProductsList
                                                  .length,
                                              shrinkWrap: true,
                                              scrollDirection:
                                              Axis.horizontal,
                                              padding:
                                              EdgeInsets.symmetric(
                                                  horizontal:
                                                  AppConstants
                                                      .padding_5),
                                              itemBuilder: (context,
                                                  index) =>
                                                  CommonProductItemWidget(
                                                    productStock: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .productStock.toString() ,
                                                    height: 160,
                                                    width: 140,
                                                    productImage: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .mainImage ??
                                                        '',
                                                    productName: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .productName ??
                                                        '',
                                                    totalSaleCount: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .totalSale ??
                                                        0,
                                                    price: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .productPrice
                                                        ?.toDouble() ??
                                                        0.0,
                                                    onButtonTap: () {
                                                      print("tap 2");
                                                      if(!state.isGuestUser){
                                                        showProductDetails(
                                                            context:
                                                            context,
                                                            productId: state
                                                                .recommendedProductsList[
                                                            index]
                                                                .id ??
                                                                '',
                                                            productStock:  state
                                                                .recommendedProductsList[
                                                            index]
                                                                .productStock.toString() ??
                                                                ''
                                                        );
                                                      }
                                                      else{
                                                        Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                      }


                                                    },
                                                  )
                                          ),
                                        ),
                                      ],
                                    ),
                                    crossFadeState: state
                                        .recommendedProductsList
                                        .isEmpty
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    duration:
                                    Duration(milliseconds: 300)) : 0.width,
                                !state.isGuestUser ? AnimatedCrossFade(
                                    firstChild:
                                    getScreenWidth(context).width,
                                    secondChild: Column(
                                      children: [
                                        buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(
                                                context)!
                                                .previous_order_products,
                                            subTitle: AppLocalizations.of(context)!.more,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, RouteDefine.reorderScreen.name);
                                            }),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height: 175,
                                          child: ListView.builder(
                                              itemCount: state
                                                  .previousOrderProductsList
                                                  .length,
                                              shrinkWrap: true,
                                              scrollDirection:
                                              Axis.horizontal,
                                              padding:
                                              EdgeInsets.symmetric(
                                                  horizontal:
                                                  AppConstants
                                                      .padding_5),
                                              itemBuilder: (context,
                                                  index) =>
                                                  CommonProductItemWidget(
                                                    height: 160,
                                                    width: 140,
                                                    productStock: state
                                                        .previousOrderProductsList[
                                                    index]
                                                        .productStock.toString(),
                                                    productImage: state
                                                        .previousOrderProductsList[
                                                    index]
                                                        .mainImage ??
                                                        '',
                                                    productName: state
                                                        .previousOrderProductsList[
                                                    index]
                                                        .productName ??
                                                        '',
                                                    totalSaleCount: state
                                                        .previousOrderProductsList[
                                                    index]
                                                        .totalSale ??
                                                        0,
                                                    price: state
                                                        .previousOrderProductsList[
                                                    index]
                                                        .productPrice
                                                        ?.toDouble() ??
                                                        0.0,
                                                    onButtonTap: () {
                                                      print("tap 3");
                                                      if(!state.isGuestUser){
                                                        showProductDetails(
                                                            context:
                                                            context,
                                                            productId: state
                                                                .previousOrderProductsList[
                                                            index]
                                                                .id ?? '',
                                                            productStock: state
                                                                .previousOrderProductsList[
                                                            index]
                                                                .productStock.toString() ?? '0'
                                                        );
                                                      }
                                                      else{
                                                        Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                      }


                                                    },
                                                  )
                                          ),
                                        ),
                                      ],
                                    ),
                                    crossFadeState: state
                                        .previousOrderProductsList
                                        .isEmpty
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    duration:
                                    Duration(milliseconds: 300)) : 0.width,
                                AppConstants.bottomNavSpace.height,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CommonSearchWidget(
                      onCloseTap: () {
                        bloc.add(StoreEvent.changeCategoryExpansion(isOpened: false));
                      },
                      isCategoryExpand: state.isCategoryExpand,
                      isSearching: state.isSearching,
                      onFilterTap: () {
                        bloc.add(StoreEvent.changeCategoryExpansion(isOpened: true));
                        bloc.add(StoreEvent.getProductCategoriesListEvent(
                            context: context));
                      },
                      onSearchTap: () {
                        if(state.searchController.text != ''){
                          bloc.add(StoreEvent.changeCategoryExpansion(isOpened: true));
                        }
                        bloc.add(
                            StoreEvent.globalSearchEvent(context: context));
                      },
                      onSearch: (String search) {
                        if (search.length > 1) {
                          bloc.add(StoreEvent.changeCategoryExpansion(isOpened: true));
                          bloc.add(
                              StoreEvent.globalSearchEvent(context: context));
                        }
                      },
                      onSearchSubmit: (String search) {
                        // bloc.add(StoreEvent.globalSearchEvent(context: context));
                          Navigator.pushNamed(
                              context,
                              RouteDefine.supplierProductsScreen.name,
                              arguments: {
                                AppStrings.searchString: state.search,
                                AppStrings.searchType : SearchTypes.product.toString()
                              });
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
                        itemBuilder: (listViewContext, index) {
                          return _buildSearchItem(
                              numberOfUnits:state.searchList[index].numberOfUnits,
                              priceOfBox: state.searchList[index].priceOfBox,
                              isGuestUser: state.isGuestUser,
                              productStock : state.searchList[index].productStock,
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
                                debugPrint("searchType: ${state.searchList[index].searchType}");

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
                                        AppStrings.categoryNameString:
                                        state.searchList[index]
                                            .categoryName,
                                        AppStrings.searchString:
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
                                        AppStrings.searchString: state.search,
                                        AppStrings.searchType : SearchTypes.product.toString()
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
                                          SearchTypes.product ) {
                                    print("tap 4");
                                    if(!state.isGuestUser){
                                      showProductDetails(
                                          context: context,
                                          productId: state
                                              .searchList[index].searchId,
                                          isBarcode: true,
                                          productStock: state.searchList[index].productStock.toString()
                                      );
                                    }
                                   else{
                                     Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                    }

                                  }


                                  else if (state
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
                          print("tap 5");
                          if(!state.isGuestUser){
                            showProductDetails(
                                context: context,
                                productId: scanResult,
                                isBarcode: true,
                                productStock: '1'
                            );
                          }
                          else{
                            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
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

  Widget _buildSearchItem({

    required BuildContext context,
    required String searchName,
    required String searchImage,
    required SearchTypes searchType,
    required bool isShowSearchLabel,
    required bool isMoreResults,
    required void Function() onTap,
    required void Function() onSeeAllTap,
    bool? isLastItem, required int productStock,
    bool isGuestUser = false,
    required int numberOfUnits,
    required double priceOfBox,
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
            height: !isGuestUser ? (productStock) != 0 ? 100 :  searchType == SearchTypes.category || searchType == SearchTypes.subCategory || searchType == SearchTypes.company || searchType == SearchTypes.supplier ?  80 :110 : 70,
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
                left: AppConstants.padding_20,
                right: AppConstants.padding_20,
                bottom: AppConstants.padding_5),
            // padding: EdgeInsets.symmetric(
            //     horizontal: AppConstants.padding_20,
            //     vertical: AppConstants.padding_5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: !isGuestUser ? searchType == SearchTypes.category || searchType == SearchTypes.subCategory || searchType == SearchTypes.company || searchType == SearchTypes.supplier ? MainAxisAlignment.start: MainAxisAlignment.spaceBetween :MainAxisAlignment.start ,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                  ),
                  child: !isGuestUser ?  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${AppUrls.baseFileUrl}$searchImage',
                      fit: BoxFit.fitHeight,
                      height: 80,
                      width: 80,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Container(
                              height: 80,
                              width: 70,
                              child: CupertinoActivityIndicator());
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return searchType == SearchTypes.subCategory
                            ? Image.asset(AppImagePath.imageNotAvailable5,
                            height: 80,
                            width: 70, fit: BoxFit.cover)
                            : SvgPicture.asset(
                          AppImagePath.splashLogo,
                          fit: BoxFit.scaleDown,
                          height: 80,
                          width: 70,
                        );
                      },
                    ),
                  ) : Image.asset(AppImagePath.imageNotAvailable5,
                    fit: BoxFit.fitWidth, height: 80,
                    width: 80,),
                ),
                10.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: getScreenWidth(context) * 0.45,
                      child: Text(
                        searchName,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_14,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold
                        ),
                        // overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    searchType == SearchTypes.category || searchType == SearchTypes.subCategory || searchType == SearchTypes.company || searchType == SearchTypes.supplier ? 0.width :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: getScreenWidth(context) * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (productStock) != 0 ? 0.width : Text(
                                AppLocalizations.of(context)!
                                    .out_of_stock1,
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.redColor,
                                    fontWeight: FontWeight.w400),
                              ),
                             !isGuestUser? numberOfUnits != 0 ? Text(
                                '${numberOfUnits.toString()}${' '}${AppLocalizations.of(context)!.unit_in_box}',
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w400),
                              ) : 0.width : 0.width,
                              !isGuestUser?numberOfUnits != 0 && priceOfBox != 0.0 ? Text(
                                '${AppLocalizations.of(context)?.price_par_box}${' '}${AppLocalizations.of(context)?.currency}${(priceOfBox * numberOfUnits).toStringAsFixed(2)}',
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.blueColor,
                                    fontWeight: FontWeight.w400),
                              ) : 0.width: 0.width,
                            ],
                          ),
                        ),
                        !isGuestUser ? priceOfBox != 0.0 ? Container(
                          width: 60,
                          child: Text(
                            '${AppLocalizations.of(context)!.currency}${priceOfBox.toStringAsFixed(2)}',
                            style: AppStyles.rkBoldTextStyle(
                                size: AppConstants.font_12,
                                color: AppColors.blueColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ) : 0.width:0.width,

                      ],
                    ),
                  ],
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
          GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: AppColors.blackColor),
            ),
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
      height: 150,
      width: 105,
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
                // top: AppConstants.padding_5,
                // left: AppConstants.padding_5,
                //  right: AppConstants.padding_5,
                // bottom: AppConstants.padding_20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(AppConstants.padding_10)),
                child: CachedNetworkImage(
                  imageUrl: "${AppUrls.baseFileUrl}$categoryImage",
                  fit: BoxFit.cover,
                  height: 140,
                  width: 105,
                  alignment: Alignment.center,
                  placeholder: (context, url) {
                    return CommonShimmerWidget(
                      child: Container(
                        height: 140,
                        width: 105,
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
                     debugPrint('product category list image error : $error');
                    return Container(
                      // padding: EdgeInsets.only(
                      //     bottom: AppConstants.padding_10, top: 0),
                      child: Image.asset(
                        AppImagePath.imageNotAvailable5,
                        fit: BoxFit.cover,
                        width: 140,
                        height: 110,
                      ),
                    );
                  },
                ),
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
                  gradient: AppColors.appMainGradientColor,
                  //    color: AppColors.mainColor,
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
                        size: AppConstants.font_14,
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
                   debugPrint('sale list image error : $error');
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
                   debugPrint('sale list image error : $error');
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
                "${AppLocalizations.of(context)!
                    .currency}${price.toStringAsFixed(AppConstants.amountFrLength) == "0.00"
                    ? '0'
                    : price.toStringAsFixed(
                    AppConstants.amountFrLength)}",
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
      height: 150,
      width: 105,
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
                height: 110,
                width: 105,
                placeholder: (context, url) {
                  return CommonShimmerWidget(
                    child: Container(
                      height: 110,
                      width: 105,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                   debugPrint('product category list image error : $error');
                  return Container(
                    child: Image.asset(
                      AppImagePath.imageNotAvailable5,
                      fit: BoxFit.cover,
                      width: 110,
                      height: 105,
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
                height: 25,
                // width: 90,
                alignment: Alignment.center,
                // margin:
                //     EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_5,
                    vertical: AppConstants.padding_2),
                decoration: BoxDecoration(
                  gradient: AppColors.appMainGradientColor,
                  //  color: AppColors.mainColor,
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
                        size: AppConstants.font_14,
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

  void showProductDetails({
    required BuildContext context,
    required String productId,
    bool? isBarcode,
    String productStock  = '0',
    bool isRelated = false,
    int planoGramIndex = 0,
  }) async {
    context.read<StoreBloc>().add(StoreEvent.getProductDetailsEvent(
      context: context,
      productId: productId,
      isBarcode: isBarcode ?? false,
      // planoGramIndex: planoGramIndex
    ));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return DraggableScrollableSheet(
          expand: true,
          maxChildSize: 1 -
              (MediaQuery.of(context).viewPadding.top /
                  getScreenHeight(context)),

          minChildSize:  productStock == '0' ? 0.8 :  1 -
              (MediaQuery.of(context).viewPadding.top /
                  getScreenHeight(context)),
          initialChildSize:  productStock == '0' ? 0.8 :  1 -
              (MediaQuery.of(context).viewPadding.top /
                  getScreenHeight(context)),
          builder:
              (BuildContext context1, ScrollController scrollController) {
            return BlocProvider.value(
              value: context.read<StoreBloc>(),
              child: BlocBuilder<StoreBloc, StoreState>(
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

                      child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                  if(getScreenHeight(context)<700 ){
                  final metrices = notification.metrics;
                  if (metrices.atEdge && metrices.pixels == 0) {
                  Navigator.pop(context);

                  }

                  if (metrices.pixels == metrices.minScrollExtent) {

                  }

                  if (metrices.atEdge && metrices.pixels > 0) {

                  }

                  if (metrices.pixels >= metrices.maxScrollExtent) {

                  }

                  }
                  return false;
                  },
                        child: Column(
                          children: [
                            CommonProductDetailsWidget(
                              qrCode:state.productDetails.first.qrcode ?? '' ,
                              addToOrderTap: () {
                                context.read<StoreBloc>().add(
                                    StoreEvent.addToCartProductEvent(
                                        context: context1,
                                        productId: productId
                                    ));
                              },
                              isLoading: state.isLoading,
                              imageOnTap: (){
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: getScreenHeight(context) - MediaQuery.of(context).padding.top ,
                                          width: getScreenWidth(context),
                                          child: GestureDetector(
                                            onVerticalDragStart: (dragDetails) {
                                              print('onVerticalDragStart');
                                            },
                                            onVerticalDragUpdate: (dragDetails) {
                                              print('onVerticalDragUpdate');
                                            },
                                            onVerticalDragEnd: (endDetails) {
                                              print('onVerticalDragEnd');
                                              Navigator.pop(dialogContext);
                                            },
                                            child: PhotoView(
                                              imageProvider: CachedNetworkImageProvider(
                                                '${AppUrls.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                              ),
                                            ),
                                          ),
                                        ),

                                        GestureDetector(
                                            onTap: (){
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Icon(Icons.close,
                                              color: Colors.white,
                                            )),
                                      ],
                                    );
                                  },);
                              },
                              context: context,
                              productImageIndex: state.imageIndex,
                              onPageChanged: (index, p1) {
                                context.read<StoreBloc>().add(
                                    StoreEvent.updateImageIndexEvent(
                                        index: index));
                              },
                              productImages: [
                                state.productDetails.first.mainImage ??
                                    '',
                                ...state.productDetails.first.images
                                    ?.map((image) =>
                                image.imageUrl ?? '') ??
                                    []
                              ],
                              productPerUnit: state.productDetails.first
                                  .numberOfUnit ?? 0,
                              productUnitPrice:  state.productStockList[state.productStockUpdateIndex].totalPrice,
                              productName: state.productDetails.first
                                  .productName ??
                                  '',
                              productCompanyName: state
                                  .productDetails.first.brandName ??
                                  '',
                              productDescription: parse(state
                                  .productDetails
                                  .first
                                  .productDescription ??
                                  '')
                                  .body
                                  ?.text ??
                                  '',
                              productSaleDescription: parse(state
                                  .productDetails
                                  .first
                                  .productDescription ??
                                  '')
                                  .body
                                  ?.text ??
                                  '',
                              productPrice: state
                                  .productStockList[
                              state.productStockUpdateIndex]
                                  .totalPrice *
                                  state
                                      .productStockList[
                                  state.productStockUpdateIndex]
                                      .quantity *
                                  (state.productDetails.first
                                      .numberOfUnit ??
                                      0) ,
                              productScaleType: state.productDetails
                                  .first.scales?.scaleType ??
                                  '',
                              productWeight: state
                                  .productDetails.first.itemsWeight
                                  ?.toDouble() ??
                                  0.0,
                              productStock: int.parse(state.productStockList[state.productStockUpdateIndex].stock.toString()),
                              isRTL: context.rtl,
                              isSupplierAvailable:
                              state.productSupplierList.isEmpty
                                  ? false
                                  : true,
                              scrollController: scrollController,
                              productQuantity:  state
                                  .productStockList[
                              state.productStockUpdateIndex]
                                  .quantity,
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
                                if(state
                                    .productStockList[
                                state.productStockUpdateIndex]
                                    .quantity > 1){
                                  context.read<StoreBloc>().add(
                                      StoreEvent.decreaseQuantityOfProduct(
                                          context: context1));
                                }
                              },
                            ),
                            10.height,
                            state.relatedProductList.isEmpty ? 0.width : relatedProductWidget(context1, state.relatedProductList,context)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },

        );
      },
    );
  }

  Widget relatedProductWidget(BuildContext prevContext, List<RelatedProductDatum> relatedProductList,BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment:
          context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              AppLocalizations.of(context)!.related_products,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.mediumFont,
                  color: AppColors.blackColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          height: AppConstants.relatedProductItemHeight,
          padding: EdgeInsets.only(left: 10,right: 10,top: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2,i){
              return CommonProductItemWidget(
                productStock:relatedProductList.elementAt(i).productStock.toString(),
                width: AppConstants.relatedProductItemWidth,
                productImage:relatedProductList[i].mainImage,
                productName: relatedProductList.elementAt(i).productName,
                totalSaleCount: relatedProductList.elementAt(i).totalSale,
                price:relatedProductList.elementAt(i).productPrice,
                onButtonTap: (){
                  Navigator.pop(prevContext);
                  showProductDetails(
                      context: context,
                      productId: relatedProductList[i].id,
                      isBarcode: false,
                      productStock: (relatedProductList[i].productStock.toString())
                  );
                },
              );},itemCount: relatedProductList.length,),
        )
      ],
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
                        child:  state.productSupplierList.length > 1 ? Row(
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
                        ) : 0.width,
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
                                        '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}:${AppLocalizations
                                            .of(context)!.currency}${state.productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex == -2)
                                            .basePrice
                                            .toStringAsFixed(AppConstants
                                            .amountFrLength)}',
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
                                        '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}:${AppLocalizations
                                            .of(context)!.currency}${state.productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index].salePrice
                                            .toStringAsFixed(AppConstants
                                            .amountFrLength)}(${state
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
                                                  '${AppLocalizations.of(context)!.price}  : ${AppLocalizations
                                                      .of(context)!.currency}${state
                                                      .productSupplierList[index]
                                                      .basePrice
                                                      .toStringAsFixed(
                                                      AppConstants
                                                          .amountFrLength)}',
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
                                                  '${AppLocalizations.of(context)!.price}  : ${AppLocalizations
                                                      .of(context)!
                                                      .currency}${state
                                                      .productSupplierList[index]
                                                      .supplierSales[subIndex]
                                                      .salePrice
                                                      .toStringAsFixed(
                                                      AppConstants
                                                          .amountFrLength)}(${state
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
                                                      '${AppLocalizations.of(context)!.read_condition}',
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
                buttonTitle: "${AppLocalizations.of(context)!.ok}"));
  }
}
