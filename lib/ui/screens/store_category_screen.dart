import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/bloc/store_category/store_category_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_search_widget.dart';
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/store_category_screen_planogram_shimmer_widget.dart';
import 'package:food_stock/ui/widget/store_category_screen_subcategory_shimmer_widget.dart';

import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/product_details_shimmer_widget.dart';

class StoreCategoryRoute {
  static Widget get route => const StoreCategoryScreen();
}

class StoreCategoryScreen extends StatelessWidget {
  const StoreCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map?;
    debugPrint('store category args = $args');
    return BlocProvider(
      create: (context) =>
      StoreCategoryBloc()
        ..add(
            StoreCategoryEvent.updateGlobalSearchEvent(
                search: args?[AppStrings.searchString] ?? '',
                context: context,
                searchList: args?[AppStrings.searchResultString] ?? []))..add(
          StoreCategoryEvent.changeCategoryDetailsEvent(
              categoryId: args?[AppStrings.categoryIdString] ?? '',
              categoryName: args?[AppStrings.categoryNameString] ?? '',
              context: context)),
      child: StoreCategoryScreenWidget(),
    );
  }
}

class StoreCategoryScreenWidget extends StatelessWidget {
  const StoreCategoryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    StoreCategoryBloc bloc = context.read<StoreCategoryBloc>();
    return BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
      builder: (context, state) =>
          WillPopScope(
            onWillPop: () {
              if (state.isSubCategory) {
                Navigator.pop(context, {
                  AppStrings
                      .searchString: state
                      .searchController.text,
                  AppStrings
                      .searchResultString: state
                      .searchList
                });
                return Future.value(false);
              } else {
                bloc.add(StoreCategoryEvent.changeSubCategoryOrPlanogramEvent(
                    isSubCategory: true, context: context));
                return Future.value(false);
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              body: SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                        height: getScreenHeight(context),
                        width: getScreenWidth(context),
                        child: Stack(
                          children: [
                            state.isSubCategory
                                ? NotificationListener<ScrollNotification>(
                              child: SingleChildScrollView(
                                physics: state.subCategoryList.isEmpty
                                    ? const NeverScrollableScrollPhysics()
                                    : const AlwaysScrollableScrollPhysics(),
                                child: GestureDetector(
                                  onTap: () {
                                    bloc.add(StoreCategoryEvent
                                        .changeSubCategoryOrPlanogramEvent(
                                        isSubCategory: false,
                                        context: context));
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      80.height,
                                      buildTopNavigation(
                                          context: context,
                                          categoryName: state.categoryName,
                                          search: state.searchController.text,
                                          searchList: state.searchList),
                                      state.isSubCategoryShimmering
                                          ? StoreCategoryScreenSubcategoryShimmerWidget()
                                          : state.subCategoryList.isEmpty
                                          ? Container(
                                        height: getScreenHeight(
                                            context) -
                                            160,
                                        width:
                                        getScreenWidth(context),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${AppLocalizations.of(context)!
                                              .sub_categories_not_available}',
                                          textAlign:
                                          TextAlign.center,
                                          style: AppStyles
                                              .rkRegularTextStyle(
                                              size: AppConstants
                                                  .smallFont,
                                              color: AppColors
                                                  .textColor),
                                        ),
                                      )
                                          : ListView.builder(
                                        itemCount: state
                                            .subCategoryList.length,
                                        shrinkWrap: true,
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,
                                            index) =>
                                            buildSubCategoryListItem(
                                                index: index,
                                                context: context,
                                                subCategoryName: state
                                                    .subCategoryList[
                                                index]
                                                    .subCategoryName ??
                                                    '',
                                                onTap: () {
                                                  //get subcategory wise plano grams
                                                  context.read<
                                                      StoreCategoryBloc>()
                                                      .add(
                                                      StoreCategoryEvent
                                                          .changeSubCategoryDetailsEvent(
                                                          subCategoryId: state
                                                              .subCategoryList[
                                                          index]
                                                              .id ??
                                                              '',
                                                          subCategoryName: state
                                                              .subCategoryList[
                                                          index]
                                                              .subCategoryName ??
                                                              '',
                                                          context:
                                                          context));
                                                }),
                                      ),
                                      state.isLoadMore
                                          ? StoreCategoryScreenSubcategoryShimmerWidget()
                                          : 0.width,
                                      // state.subCategoryList.isEmpty
                                      //     ? 0.width
                                      //     : state.isBottomOfPlanoGrams
                                      //         ? CommonPaginationEndWidget(
                                      //             pageEndText:
                                      //                 'No more Sub Categories')
                                      //         : 0.width,
                                    ],
                                  ),
                                ),
                              ),
                              onNotification: (notification) {
                                if (notification.metrics.pixels ==
                                    notification.metrics.maxScrollExtent) {
                                  context.read<StoreCategoryBloc>().add(
                                      StoreCategoryEvent
                                          .getSubCategoryListEvent(
                                          context: context));
                                }
                                return true;
                              },
                            )
                                : NotificationListener<ScrollNotification>(
                              child: SingleChildScrollView(
                                physics: state.planoGramsList.isEmpty
                                    ? const NeverScrollableScrollPhysics()
                                    : const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    80.height,
                                    buildTopNavigation(
                                        context: context,
                                        categoryName: state.categoryName,
                                        subCategoryName:
                                        state.subCategoryName,
                                        search: state.searchController.text,
                                        searchList: state.searchList),
                                    16.height,
                                    state.isPlanogramShimmering
                                        ? StoreCategoryScreenPlanoGramShimmerWidget()
                                        : state.planoGramsList.isEmpty
                                        ? Container(
                                      height:
                                      getScreenHeight(context) -
                                          160,
                                      width:
                                      getScreenWidth(context),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${AppLocalizations.of(context)!
                                            .products_not_available}',
                                        textAlign: TextAlign.center,
                                        style: AppStyles
                                            .rkRegularTextStyle(
                                            size: AppConstants
                                                .smallFont,
                                            color: AppColors
                                                .textColor),
                                      ),
                                    )
                                        : ListView.builder(
                                      itemCount: state
                                          .planoGramsList.length,
                                      shrinkWrap: true,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (context, index) {
                                        return (state
                                            .planoGramsList[
                                        index]
                                            .planogramproducts
                                            ?.isEmpty ??
                                            true)
                                            ? 0.width
                                            : buildPlanoGramItem(
                                            context: context,
                                            index: index);
                                      },
                                    ),
                                    state.isLoadMore
                                        ? StoreCategoryScreenPlanoGramShimmerWidget()
                                        : 0.width,
                                    // state.isBottomOfPlanoGrams
                                    //     ? CommonPaginationEndWidget(
                                    //         pageEndText: 'No more Products')
                                    //     : 0.width,
                                    // 85.height,
                                    // Container(
                                    //   color: AppColors.whiteColor,
                                    //   child: Column(
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       // Row(
                                    //       //   mainAxisAlignment:
                                    //       //   MainAxisAlignment.start,
                                    //       //   children: [
                                    //       //     Padding(
                                    //       //       padding: const EdgeInsets.symmetric(
                                    //       //           horizontal:
                                    //       //           AppConstants.padding_10,
                                    //       //           vertical: AppConstants.padding_3),
                                    //       //       child: Text(
                                    //       //         AppLocalizations.of(context)!
                                    //       //             .planogram,
                                    //       //         style: AppStyles.rkBoldTextStyle(
                                    //       //             size: AppConstants.mediumFont,
                                    //       //             color: AppColors.blackColor,
                                    //       //             fontWeight: FontWeight.w600),
                                    //       //       ),
                                    //       //     ),
                                    //       //   ],
                                    //       // ),
                                    //       buildPlanogramTitles(
                                    //           context: context,
                                    //           title: 'planogram',
                                    //           onTap: () {},
                                    //           subTitle: 'all planogram'),
                                    //       5.height,
                                    //       SizedBox(
                                    //         height: 200,
                                    //         child: ListView.builder(
                                    //           itemCount: 10,
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal:
                                    //               AppConstants.padding_5),
                                    //           scrollDirection: Axis.horizontal,
                                    //           shrinkWrap: true,
                                    //           itemBuilder: (context, index) {
                                    //             return buildPlanoGramListItem(
                                    //                 context: context,
                                    //                 isRTL: isRTLContent(
                                    //                     context: context),
                                    //                 width: getScreenWidth(
                                    //                     context) /
                                    //                     3.2);
                                    //           },
                                    //         ),
                                    //       ),
                                    //       10.height,
                                    //     ],
                                    //   ),
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Text(
                                    //         AppLocalizations.of(context)!.planogram,
                                    //         style: AppStyles.rkBoldTextStyle(
                                    //             size: AppConstants.mediumFont,
                                    //             color: AppColors.blackColor,
                                    //             fontWeight: FontWeight.w600),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // GridView.builder(
                                    //   physics: const NeverScrollableScrollPhysics(),
                                    //   padding: EdgeInsets.symmetric(
                                    //       vertical: AppConstants.padding_5),
                                    //   gridDelegate:
                                    //   SliverGridDelegateWithFixedCrossAxisCount(
                                    //       crossAxisCount: 3,
                                    //       childAspectRatio:
                                    //       (getScreenWidth(context) + 70) /
                                    //           getScreenHeight(context)),
                                    //   shrinkWrap: true,
                                    //   itemCount: 20,
                                    //   itemBuilder: (context, index) {
                                    //     return buildPlanoGramListItem(
                                    //         context: context,
                                    //         isRTL: context.rtl,
                                    //         width: getScreenWidth(context) / 3.2);
                                    //   },
                                    // )
                                  ],
                                ),
                              ),
                              onNotification: (notification) {
                                if (notification.metrics.pixels ==
                                    notification.metrics.maxScrollExtent) {
                                  if (notification.metrics.axis ==
                                      Axis.vertical) {}
                                  context.read<StoreCategoryBloc>().add(
                                      StoreCategoryEvent
                                          .getPlanoGramProductsEvent(
                                          context: context));
                                }
                                return true;
                              },
                            ),
                          ],
                        )),
                    CommonSearchWidget(
                      isCategoryExpand: state.isCategoryExpand,
                      isSearching: state.isSearching,
                      isBackButton: true,
                      onFilterTap: () {
                        Navigator.pop(context, {
                          AppStrings
                              .searchString: state
                              .searchController.text,
                          AppStrings
                              .searchResultString: state
                              .searchList
                        });
                        // bloc.add(
                        //     StoreCategoryEvent.changeCategoryExpansionEvent());
                      },
                      onSearch: (String search) {
                        if (search.length > 2) {
                          bloc.add(StoreCategoryEvent.globalSearchEvent(
                              context: context));
                        }
                      },
                      onSearchSubmit: (String search) {
                        bloc.add(StoreCategoryEvent.globalSearchEvent(
                            context: context));
                      },
                      onSearchTap: () {
                        bloc.add(
                            StoreCategoryEvent.changeCategoryExpansionEvent(
                                isOpened: true));
                      },
                      onOutSideTap: () {
                        bloc.add(
                            StoreCategoryEvent.changeCategoryExpansionEvent(
                                isOpened: false));
                      },
                      onSearchItemTap: () {
                        bloc.add(
                            StoreCategoryEvent.changeCategoryExpansionEvent());
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
                              searchType: state.searchList[index].searchType,
                              isMoreResults: state.searchList
                                  .where((search) =>
                              search.searchType ==
                                  state.searchList[index]
                                      .searchType)
                                  .toList()
                                  .length ==
                                  10,
                              isLastItem: state.searchList.length - 1 == index,
                              isShowSearchLabel: index == 0
                                  ? true
                                  : state.searchList[index].searchType !=
                                  state.searchList[index - 1]
                                      .searchType
                                  ? true
                                  : false,
                              onSeeAllTap: () async {
                                if (state.searchList[index].searchType ==
                                    SearchTypes.category
                                ) {
                                  dynamic result = await Navigator.pushNamed(
                                      context,
                                      RouteDefine.productCategoryScreen.name,
                                      arguments: {
                                        AppStrings.searchString: state
                                            .searchController.text,
                                        AppStrings.reqSearchString: state
                                            .searchController.text,
                                        AppStrings.fromStoreCategoryString: true
                                      });
                                  if (result != null) {
                                    bloc.add(StoreCategoryEvent
                                        .changeCategoryDetailsEvent(
                                        categoryId:
                                        result[AppStrings.categoryIdString],
                                        categoryName:
                                        result[AppStrings.categoryNameString],
                                        context: context));
                                  }
                                } else {
                                  state.searchList[index].searchType ==
                                      SearchTypes.company ?
                                  Navigator.pushNamed(
                                      context,
                                      RouteDefine.companyScreen.name,
                                      arguments: {
                                        AppStrings.searchString: state
                                            .searchController.text
                                      }) :
                                  state.searchList[index].searchType ==
                                      SearchTypes.supplier ?
                                  Navigator.pushNamed(
                                      context,
                                      RouteDefine.supplierScreen.name,
                                      arguments: {
                                        AppStrings.searchString: state
                                            .searchController.text
                                      }) :
                                  state.searchList[index].searchType ==
                                      SearchTypes.sale
                                      ? Navigator.pushNamed(
                                      context,
                                      RouteDefine.productSaleScreen.name,
                                      arguments: {
                                        AppStrings.searchString: state
                                            .searchController.text
                                      })
                                      : Navigator
                                      .pushNamed(context,
                                      RouteDefine.supplierProductsScreen.name,
                                      arguments: {
                                        AppStrings.searchString: state
                                            .searchController.text
                                      });
                                }
                                bloc.add(StoreCategoryEvent
                                    .changeCategoryExpansionEvent());
                              },
                              onTap: () {
                                state.searchList[index].searchType ==
                                    SearchTypes.sale ||
                                    state.searchList[index].searchType ==
                                        SearchTypes.product
                                    ? showProductDetails(
                                    context: context,
                                    productId: state
                                        .searchList[index].searchId,
                                    planoGramIndex: 0,
                                    isBarcode: true)
                                    : state.searchList[index].searchType ==
                                    SearchTypes.category
                                    ? bloc.add(StoreCategoryEvent
                                    .changeCategoryDetailsEvent(
                                    categoryId:
                                    state.searchList[index].searchId,
                                    categoryName:
                                    state.searchList[index].name,
                                    context: context))
                                    : state.searchList[index].searchType ==
                                    SearchTypes.company
                                    ? Navigator.pushNamed(context, RouteDefine
                                    .companyProductsScreen
                                    .name, arguments: {
                                  AppStrings.companyIdString: state
                                      .searchList[index].searchId
                                }) : Navigator.pushNamed(
                                    context,
                                    RouteDefine
                                        .supplierProductsScreen
                                        .name,
                                    arguments:
                                    {
                                      AppStrings.supplierIdString: state
                                          .searchList[index].searchId
                                    });
                                bloc.add(StoreCategoryEvent
                                    .changeCategoryExpansionEvent());
                              });
                        },
                      ),
                      onScanTap: () async {
                        // Navigator.pushNamed(context, RouteDefine.qrScanScreen.name);
                        String result = await scanBarcodeOrQRCode(
                            context: context,
                            cancelText: AppLocalizations.of(context)!.cancel,
                            scanMode: ScanMode.BARCODE);
                        if (result != '-1') {
                          // -1 result for cancel scanning
                          debugPrint('result = $result');
                          showProductDetails(
                              context: context,
                              productId: result,
                              planoGramIndex: 0,
                              isBarcode: true);
                        } else {
                          showProductDetails(
                              context: context,
                              productId: '156470',
                              planoGramIndex: state.productStockList
                                  .indexOf(state.productStockList.last),
                              isBarcode: true);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildSearchItem({
    required BuildContext context,
    required String searchName,
    required String searchImage,
    required bool isMoreResults,
    required SearchTypes searchType,
    required bool isShowSearchLabel,
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
                        return CommonShimmerWidget(child: Container(width: 40,
                          height: 35,
                          color: AppColors.whiteColor,));
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        AppImagePath.splashLogo, fit: BoxFit.scaleDown,
                        width: 40,
                        height: 35,);
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

  Widget buildPlanoGramTitles({required BuildContext context,
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
            style: AppStyles.rkBoldTextStyle(
                size: AppConstants.mediumFont,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              subTitle,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.mediumFont,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlanoGramProductListItem({required BuildContext context,
    required int index,
    required int subIndex,
    required double height,
    required double width}) {
    return BlocProvider.value(
      value: context.read<StoreCategoryBloc>(),
      child: BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
        builder: (context1, state) {
          return Container(
            height: height,
            width: width,
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
                  child: Image.network(
                    "${AppUrls.baseFileUrl}${state.planoGramsList[index]
                        .planogramproducts?[subIndex].mainImage}",
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
                  ),
                ),
                5.height,
                Text(
                  "${state.planoGramsList[index].planogramproducts?[subIndex]
                      .productName}",
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_12,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                5.height,
                Expanded(
                  child: state.planoGramsList[index]
                      .planogramproducts?[subIndex].totalSale ==
                      0
                      ? 0.width
                      : Text(
                    "${state.planoGramsList[index].planogramproducts?[subIndex]
                        .totalSale} ${AppLocalizations.of(context)!.discount}",
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
                    "${state.planoGramsList[index].planogramproducts?[subIndex]
                        .productPrice?.toStringAsFixed(
                        AppConstants.amountFrLength) == "0.00" ? '0' : state
                        .planoGramsList[index].planogramproducts?[subIndex]
                        .productPrice?.toStringAsFixed(
                        AppConstants.amountFrLength)}${AppLocalizations.of(
                        context)!.currency}",
                    onPressed: () {
                      showProductDetails(
                          context: context,
                          productId: state.planoGramsList[index]
                              .planogramproducts?[subIndex].id ??
                              '',
                          planoGramIndex: index);
                    },
                    textColor: AppColors.whiteColor,
                    bgColor: AppColors.mainColor,
                    borderRadius: AppConstants.radius_3,
                    textSize: AppConstants.font_12,
                  ),
                )
              ],
            ),
          );
          // return Container(
          //   height: height,
          //   width: width,
          //   clipBehavior: Clip.hardEdge,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: AppConstants.padding_10,
          //     vertical: AppConstants.padding_10,
          //   ),
          //   padding: EdgeInsets.symmetric(vertical: AppConstants.padding_10),
          //   decoration: BoxDecoration(
          //       color: AppColors.whiteColor,
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(AppConstants.radius_10),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //             color: AppColors.shadowColor.withOpacity(0.15),
          //             blurRadius: AppConstants.blur_10),
          //       ]),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //               top: AppConstants.padding_5,
          //               left: AppConstants.padding_10,
          //               right: AppConstants.padding_10),
          //           child: Image.network(
          //             '${AppUrls.baseFileUrl}${state.planoGramsList[index].planogramproducts?[subIndex].mainImage}',
          //             // height: 120,
          //             fit: BoxFit.contain,
          //             loadingBuilder: (context, child, loadingProgress) {
          //               if (loadingProgress?.cumulativeBytesLoaded !=
          //                   loadingProgress?.expectedTotalBytes) {
          //                 return CommonShimmerWidget(
          //                   child: Container(
          //                     // height: 120,
          //                     margin: EdgeInsets.only(
          //                         bottom: AppConstants.padding_5),
          //                     decoration: BoxDecoration(
          //                         color: AppColors.whiteColor,
          //                         borderRadius: BorderRadius.all(
          //                             Radius.circular(AppConstants.radius_10))),
          //                   ),
          //                 );
          //               }
          //               return child;
          //             },
          //             errorBuilder: (context, error, stackTrace) {
          //               // debugPrint('product category list image error : $error');
          //               return Container(
          //                 child: Image.asset(
          //                   AppImagePath.imageNotAvailable5,
          //                   fit: BoxFit.cover,
          //                   // width: 80,
          //                   // height: 120,
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //       ),
          //       4.height,
          //       Container(
          //         width: double.maxFinite,
          //         decoration: BoxDecoration(
          //           color: AppColors.mainColor,
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(AppConstants.radius_10),
          //           ),
          //         ),
          //         alignment: Alignment.center,
          //         padding: EdgeInsets.symmetric(
          //             horizontal: AppConstants.padding_5,
          //             vertical: AppConstants.padding_10),
          //         margin:
          //             EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
          //         child: CommonMarqueeWidget(
          //           child: Text(
          //             '${state.planoGramsList[index].planogramproducts?[subIndex].productName}',
          //             style: AppStyles.rkBoldTextStyle(
          //                 size: AppConstants.smallFont,
          //                 color: AppColors.whiteColor,
          //                 fontWeight: FontWeight.w500),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       ),
          //       // 4.height,
          //       // Text(
          //       //   "23.00${AppLocalizations.of(context)!.currency}",
          //       //   style: AppStyles.rkBoldTextStyle(
          //       //       size: AppConstants.font_12, color: AppColors.blackColor),
          //       //   textAlign: TextAlign.center,
          //       // ),
          //       // 4.height,
          //       // Expanded(
          //       //   child: Text(
          //       //     "Sale 2 at a discount",
          //       //     style: AppStyles.rkBoldTextStyle(
          //       //         size: AppConstants.font_12,
          //       //         color: AppColors.saleRedColor),
          //       //     maxLines: 1,
          //       //     overflow: TextOverflow.ellipsis,
          //       //     textAlign: TextAlign.center,
          //       //   ),
          //       // ),
          //       // Container(
          //       //   height: 35,
          //       //   decoration: BoxDecoration(
          //       //     border: Border(
          //       //         top: BorderSide(
          //       //             color: AppColors.borderColor.withOpacity(0.7),
          //       //             width: 1)),
          //       //   ),
          //       //   child: Row(
          //       //     children: [
          //       //       Expanded(
          //       //         flex: 2,
          //       //         child: GestureDetector(
          //       //           onTap: () {
          //       //             debugPrint('+');
          //       //           },
          //       //           child: Container(
          //       //             decoration: BoxDecoration(
          //       //               color: AppColors.iconBGColor,
          //       //               border: Border(
          //       //                 left: isRTL
          //       //                     ? BorderSide(
          //       //                         color: AppColors.borderColor
          //       //                             .withOpacity(0.7),
          //       //                         width: 1)
          //       //                     : BorderSide.none,
          //       //                 right: isRTL
          //       //                     ? BorderSide.none
          //       //                     : BorderSide(
          //       //                         color: AppColors.borderColor
          //       //                             .withOpacity(0.7),
          //       //                         width: 1),
          //       //               ),
          //       //             ),
          //       //             padding: EdgeInsets.symmetric(
          //       //                 horizontal: AppConstants.padding_3),
          //       //             alignment: Alignment.center,
          //       //             child: Icon(Icons.add, color: AppColors.mainColor),
          //       //           ),
          //       //         ),
          //       //       ),
          //       //       Expanded(
          //       //         flex: 3,
          //       //         child: Container(
          //       //           color: AppColors.whiteColor,
          //       //           padding: EdgeInsets.symmetric(
          //       //               horizontal: AppConstants.padding_5),
          //       //           alignment: Alignment.center,
          //       //           child: Text(
          //       //             '0',
          //       //             style: AppStyles.rkBoldTextStyle(
          //       //                 size: 24,
          //       //                 color: AppColors.blackColor,
          //       //                 fontWeight: FontWeight.w600),
          //       //           ),
          //       //         ),
          //       //       ),
          //       //       Expanded(
          //       //         flex: 2,
          //       //         child: GestureDetector(
          //       //           onTap: () {
          //       //             debugPrint('-');
          //       //           },
          //       //           child: Container(
          //       //             decoration: BoxDecoration(
          //       //               color: AppColors.iconBGColor,
          //       //               border: Border(
          //       //                 left: isRTL
          //       //                     ? BorderSide.none
          //       //                     : BorderSide(
          //       //                         color: AppColors.borderColor
          //       //                             .withOpacity(0.7),
          //       //                         width: 1),
          //       //                 right: isRTL
          //       //                     ? BorderSide(
          //       //                         color: AppColors.borderColor
          //       //                             .withOpacity(0.7),
          //       //                         width: 1)
          //       //                     : BorderSide.none,
          //       //               ),
          //       //             ),
          //       //             padding: EdgeInsets.symmetric(
          //       //                 horizontal: AppConstants.padding_3),
          //       //             alignment: Alignment.center,
          //       //             child:
          //       //                 Icon(Icons.remove, color: AppColors.mainColor),
          //       //           ),
          //       //         ),
          //       //       ),
          //       //     ],
          //       //   ),
          //       // )
          //     ],
          //   ),
          // );
        },
      ),
    );
  }

  void showProductDetails({required BuildContext context,
    required String productId,
    required int planoGramIndex,
    bool? isBarcode}) async {
    context.read<StoreCategoryBloc>().add(
        StoreCategoryEvent.getProductDetailsEvent(
            context: context,
            productId: productId,
            planoGramIndex: planoGramIndex,
            isBarcode: isBarcode));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      // showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<StoreCategoryBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery
                    .of(context)
                    .viewPadding
                    .top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: 0.7,
            shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<StoreCategoryBloc>(),
                  child: BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
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
                                context.read<StoreCategoryBloc>().add(
                                    StoreCategoryEvent.updateImageIndexEvent(
                                        index: index));
                              },
                              productImages:
                              [
                                state.productDetails.first.mainImage ??
                                    '',
                                ...state.productDetails.first.images?.map((
                                    image) => image.imageUrl ?? '') ?? []
                              ],
                              productName:
                              state.productDetails.first.productName ??
                                  '',
                              productCompanyName:
                              state.productDetails.first.brandName ??
                                  '',
                              productDescription:
                              state.productDetails.first.productDescription ??
                                  '',
                              productSaleDescription:
                              state.productDetails.first.productDescription ??
                                  '',
                              productPrice: state
                                  .productStockList[state.planoGramUpdateIndex]
                              [state.productStockUpdateIndex]
                                  .totalPrice *
                                  state
                                      .productStockList[state
                                      .planoGramUpdateIndex]
                                  [state.productStockUpdateIndex]
                                      .quantity,
                              productScaleType: state.productDetails.first
                                  .scales?.scaleType ?? '',
                              productWeight: state.productDetails.first
                                  .itemsWeight?.toDouble() ?? 0.0,
                              isNoteOpen: state.productStockList[state
                                  .planoGramUpdateIndex][state
                                  .productStockUpdateIndex].isNoteOpen,
                              onNoteToggleChanged: () {
                                context.read<StoreCategoryBloc>().add(
                                    StoreCategoryEvent.toggleNoteEvent(
                                        isBarcode: isBarcode ?? false));
                              },
                              supplierWidget: state.productSupplierList.isEmpty
                                  ? Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: AppColors.borderColor
                                                .withOpacity(0.5),
                                            width: 1))),
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_30),
                                alignment: Alignment.center,
                                child: Text(
                                  '${AppLocalizations.of(context)!
                                      .suppliers_not_available}',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor),
                                ),
                              )
                                  : buildSupplierSelection(
                                  context: context),
                              productStock: state.productStockList[state
                                  .planoGramUpdateIndex][state
                                  .productStockUpdateIndex].stock,
                              isRTL: context.rtl,
                              isSupplierAvailable: state.productSupplierList
                                  .isEmpty ? false : true,
                              scrollController: scrollController,
                              productQuantity: state.productStockList[state
                                  .planoGramUpdateIndex][state
                                  .productStockUpdateIndex].quantity,
                              onQuantityChanged: (quantity) {

                              },
                              onQuantityIncreaseTap: () {
                                context.read<StoreCategoryBloc>().add(
                                    StoreCategoryEvent
                                        .increaseQuantityOfProduct(
                                        context: context1));
                              },
                              onQuantityDecreaseTap: () {
                                context.read<StoreCategoryBloc>().add(
                                    StoreCategoryEvent
                                        .decreaseQuantityOfProduct(
                                        context: context1));
                              },
                              noteController: TextEditingController(text: state
                                  .productStockList[planoGramIndex][state
                                  .productStockUpdateIndex].note)
                                ..selection = TextSelection.fromPosition(
                                    TextPosition(
                                        offset: state.productStockList[state
                                            .planoGramUpdateIndex][state
                                            .productStockUpdateIndex].note
                                            .length)),
                              onNoteChanged: (newNote) {
                                context.read<StoreCategoryBloc>().add(
                                    StoreCategoryEvent.changeNoteOfProduct(
                                        newNote: newNote));
                              },
                              isLoading: state.isLoading,
                              onAddToOrderPressed: state.isLoading
                                  ? null
                                  : () {
                                context.read<StoreCategoryBloc>().add(
                                    StoreCategoryEvent
                                        .addToCartProductEvent(
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

  // Container buildPlanoGramListItem(
  //     {required BuildContext context, double? width, required bool isRTL}) {
  //   return Container(
  //     // height: 190,
  //     width: width,
  //     clipBehavior: Clip.hardEdge,
  //     margin: EdgeInsets.symmetric(
  //       horizontal: AppConstants.padding_10,
  //       vertical: AppConstants.padding_10,
  //     ),
  //     decoration: BoxDecoration(
  //         color: AppColors.whiteColor,
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(AppConstants.radius_10),
  //         ),
  //         boxShadow: [
  //           BoxShadow(
  //               color: AppColors.shadowColor.withOpacity(0.15),
  //               blurRadius: AppConstants.blur_10),
  //         ]),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Image.asset(
  //           AppImagePath.product3,
  //           height: 80,
  //           fit: BoxFit.fitHeight,
  //         ),
  //         4.height,
  //         Text(
  //           'ProductName',
  //           style: AppStyles.rkBoldTextStyle(
  //               size: AppConstants.font_14, color: AppColors.blackColor),
  //           textAlign: TextAlign.center,
  //         ),
  //         4.height,
  //         Text(
  //           "23.00${AppLocalizations.of(context)!.currency}",
  //           style: AppStyles.rkBoldTextStyle(
  //               size: AppConstants.font_12, color: AppColors.blackColor),
  //           textAlign: TextAlign.center,
  //         ),
  //         4.height,
  //         Expanded(
  //           child: Text(
  //             "Sale 2 at a discount",
  //             style: AppStyles.rkBoldTextStyle(
  //                 size: AppConstants.font_12, color: AppColors.saleRedColor),
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         Container(
  //           height: 35,
  //           decoration: BoxDecoration(
  //             border: Border(
  //                 top: BorderSide(
  //                     color: AppColors.borderColor.withOpacity(0.7), width: 1)),
  //           ),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 flex: 2,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     debugPrint('+');
  //                   },
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       color: AppColors.iconBGColor,
  //                       border: Border(
  //                         left: isRTL
  //                             ? BorderSide(
  //                                 color: AppColors.borderColor.withOpacity(0.7),
  //                                 width: 1)
  //                             : BorderSide.none,
  //                         right: isRTL
  //                             ? BorderSide.none
  //                             : BorderSide(
  //                                 color: AppColors.borderColor.withOpacity(0.7),
  //                                 width: 1),
  //                       ),
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                         horizontal: AppConstants.padding_3),
  //                     alignment: Alignment.center,
  //                     child: Icon(Icons.add, color: AppColors.mainColor),
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 3,
  //                 child: Container(
  //                   color: AppColors.whiteColor,
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: AppConstants.padding_5),
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     '0',
  //                     style: AppStyles.rkBoldTextStyle(
  //                         size: 24,
  //                         color: AppColors.blackColor,
  //                         fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 2,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     debugPrint('-');
  //                   },
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       color: AppColors.iconBGColor,
  //                       border: Border(
  //                         left: isRTL
  //                             ? BorderSide.none
  //                             : BorderSide(
  //                                 color: AppColors.borderColor.withOpacity(0.7),
  //                                 width: 1),
  //                         right: isRTL
  //                             ? BorderSide(
  //                                 color: AppColors.borderColor.withOpacity(0.7),
  //                                 width: 1)
  //                             : BorderSide.none,
  //                       ),
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                         horizontal: AppConstants.padding_3),
  //                     alignment: Alignment.center,
  //                     child: Icon(Icons.remove, color: AppColors.mainColor),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget buildTopNavigation({required BuildContext context,
    required String categoryName,
    String? subCategoryName, required String search, required List<
        SearchModel> searchList}) {
    return Container(
      width: getScreenWidth(context),
      margin: EdgeInsets.only(top: AppConstants.padding_10,
          left: context.rtl ? 0 : AppConstants.padding_10,
          right: context.rtl ? AppConstants.padding_10 : 0,
          bottom: AppConstants.padding_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context, {
                AppStrings
                    .searchString: search,
                AppStrings
                    .searchResultString: searchList
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.home,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: AppColors.mainColor),
                  textAlign: TextAlign.center,
                ),
                1.width,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.mainColor,
                  size: 16,
                ),
                1.width,
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!(subCategoryName?.isEmpty ?? true)) {
                debugPrint('cate');
                BlocProvider.of<StoreCategoryBloc>(context).add(
                    StoreCategoryEvent.changeSubCategoryOrPlanogramEvent(
                        isSubCategory: true, context: context));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  categoryName,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: subCategoryName?.isEmpty ?? true
                          ? AppColors.blackColor
                          : AppColors.mainColor),
                  textAlign: TextAlign.center,
                ),
                1.width,
                subCategoryName?.isEmpty ?? true
                    ? 0.height
                    : Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: subCategoryName?.isEmpty ?? true
                      ? AppColors.blackColor
                      : AppColors.mainColor,
                  size: 16,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              subCategoryName ?? '',
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.blackColor),
              // textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlanoGramItem(
      {required BuildContext context, required int index}) {
    return BlocProvider.value(
      value: context.read<StoreCategoryBloc>(),
      child: BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
        builder: (context, state) {
          return Container(
            color: AppColors.whiteColor,
            margin: EdgeInsets.symmetric(vertical: AppConstants.padding_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildPlanoGramTitles(
                    context: context,
                    title: state.planoGramsList[index].planogramName ?? '',
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteDefine.planogramProductScreen.name,
                          arguments: {
                            AppStrings.planogramProductsParamString:
                            state.planoGramsList[index]
                          });
                    },
                    subTitle: (state.planoGramsList[index].planogramproducts
                        ?.length ??
                        0) <
                        6
                        ? ''
                        : AppLocalizations.of(context)!.see_all),
                5.height,
                SizedBox(
                  height: 170,
                  child:
                  state.planoGramsList[index].planogramproducts?.isEmpty ??
                      false
                      ? Center(
                    child: Text(
                      '${AppLocalizations.of(context)!.out_of_stock}',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: AppColors.textColor),
                    ),
                  )
                      : ListView.builder(
                    itemCount: (state.planoGramsList[index]
                        .planogramproducts?.length ??
                        0) <
                        6
                        ? state.planoGramsList[index]
                        .planogramproducts?.length
                        : 6,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_5),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, subIndex) {
                      return buildPlanoGramProductListItem(
                          context: context,
                          index: index,
                          subIndex: subIndex,
                          height: 150,
                          width: getScreenWidth(context) / 3.2);
                    },
                  ),
                ),
                10.height,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSubCategoryListItem({required int index,
    required BuildContext context,
    required String subCategoryName,
    required void Function()? onTap}) {
    return DelayedWidget(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_5)),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.1),
                    blurRadius: AppConstants.blur_10),
              ]),
          margin: EdgeInsets.symmetric(
              vertical: AppConstants.padding_5,
              horizontal: AppConstants.padding_10),
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.padding_15,
              vertical: AppConstants.padding_15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                subCategoryName,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSupplierSelection({required BuildContext context}) {
    return BlocProvider.value(
      value: context.read<StoreCategoryBloc>(),
      child: BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
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
                          context.read<StoreCategoryBloc>().add(
                              StoreCategoryEvent
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
                          context.read<StoreCategoryBloc>().add(
                              StoreCategoryEvent
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
                                        'Price : ${state
                                            .productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex ==
                                            -2)
                                            .basePrice
                                            .toStringAsFixed(
                                            2)}${AppLocalizations
                                            .of(context)!
                                            .currency}',
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
                                            .supplierSales[index]
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
                                            .productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index]
                                            .salePrice
                                            .toStringAsFixed(
                                            2)}${AppLocalizations
                                            .of(context)!
                                            .currency}(${state
                                            .productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index]
                                            .saleDiscount.toStringAsFixed(
                                            0)}%)',
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
                  ? Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: AppColors.borderColor.withOpacity(0.5),
                            width: 1))),
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding_30),
                alignment: Alignment.center,
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
                            context.read<StoreCategoryBloc>().add(
                                StoreCategoryEvent
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
                              height: 95,
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
                                                .read<
                                                StoreCategoryBloc>()
                                                .add(StoreCategoryEvent
                                                .supplierSelectionEvent(
                                                supplierIndex:
                                                index,
                                                context: context,
                                                supplierSaleIndex:
                                                -2));
                                            context
                                                .read<
                                                StoreCategoryBloc>()
                                                .add(StoreCategoryEvent
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
                                                .read<
                                                StoreCategoryBloc>()
                                                .add(StoreCategoryEvent
                                                .supplierSelectionEvent(
                                                supplierIndex:
                                                index,
                                                context:
                                                context,
                                                supplierSaleIndex:
                                                subIndex));
                                            context
                                                .read<
                                                StoreCategoryBloc>()
                                                .add(StoreCategoryEvent
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
