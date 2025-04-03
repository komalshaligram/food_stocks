import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/recommendation_products/recommendation_products_bloc.dart';
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
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_sale_item_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/confetti.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';
import '../widget/supplier_products_screen_shimmer_widget.dart';

class RecommendationProductsRoute {
  static Widget get route => const RecommendationProductsScreen();
}

class RecommendationProductsScreen extends StatelessWidget {
  const RecommendationProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendationProductsBloc()
        ..add(RecommendationProductsEvent.getRecommendationProductsEvent(context: context))
        ..add(RecommendationProductsEvent.userApproveEvent(context: context)),
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
      child: BlocBuilder<RecommendationProductsBloc, RecommendationProductsState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
            floatingActionButton: FloatingActionButton(
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
                    // margin: EdgeInsets.only(bottom: 10),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(border: Border.all(color: Colors.transparent, width: 1), gradient: AppColors.appMainGradientColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100))),
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
                                  //gradient:AppColors.appMainGradientColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                                  border: Border.all(color: AppColors.whiteColor, width: 1),
                                ),
                                child: Text(
                                  '${state.cartCount}',
                                  style: AppStyles.rkRegularTextStyle(size: 10, color: AppColors.whiteColor),
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
            ),
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
            body: FocusDetector(
              onFocusGained: () {
                bloc.add(const RecommendationProductsEvent.getCartCountEvent());
                bloc.add(RecommendationProductsEvent.getPermissionList(context: context));
              },
              child: SafeArea(
                child: NotificationListener<ScrollNotification>(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          100.height,
                          Expanded(
                            child: state.isShimmering
                                ? state.isGridView
                                    ? SupplierProductsScreenShimmerWidget()
                                    : StoreCategoryScreenSubcategoryShimmerWidget()
                                : state.recommendationProductsList.isEmpty
                                    ? Container(
                                        height: getScreenHeight(context) - 80,
                                        width: getScreenWidth(context),
                                        margin: const EdgeInsets.only(top: 30),
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context)!.recommendation_products_are_not_available,
                                          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor),
                                        ),
                                      )
                                    : SmartRefresher(
                                        enablePullDown: /*state.isShimmering || state.isLoading ? false : */
                                            true,
                                        controller: state.refreshController,
                                        header: const RefreshWidget(),
                                        footer: CustomFooter(builder: (context, mode) => state.isGridView ? SupplierProductsScreenShimmerWidget() : StoreCategoryScreenSubcategoryShimmerWidget()),
                                        enablePullUp: !state.isBottomOfProducts,
                                        onRefresh: () {
                                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.refreshListEvent(context: context));
                                        },
                                      /*  onLoading: () {
                                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.getRecommendationProductsEvent(context: context));
                                        },*/
                                        child: SingleChildScrollView(
                                          physics: state.recommendationProductsList.isEmpty ? const NeverScrollableScrollPhysics() : null,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              state.isGridView
                                                  ? GridView.builder(
                                                      itemCount: state.recommendationProductsList.length,
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: getChildAspectRatio(context, state.isSaleOn)),
                                                      itemBuilder: (context, index) {
                                                        return CommonProductSaleItemWidget(
                                                            isSale: state.recommendationProductsList[index].sale?.isSale,
                                                            height: AppConstants.salesProductItemHeight,
                                                            width: 140,
                                                            productName: state.recommendationProductsList[index].productName ?? '',
                                                            saleImage: state.recommendationProductsList[index].mainImage ?? '',
                                                            title: state.recommendationProductsList[index].name,
                                                            description: parse(state.recommendationProductsList[index].sale?.saleDescription ?? '').body?.text ?? '',
                                                            discountedPrice: double.parse(state.recommendationProductsList[index].sale?.salePrice ?? ''),
                                                            originalPrice: state.recommendationProductsList[index].productPrice,
                                                            productStock: state.recommendationProductsList[index].productStock.toString(),
                                                            lowStock: state.recommendationProductsList[index].lowStock ?? '',
                                                            isPesach: state.recommendationProductsList[index].isPesach,
                                                            onButtonTap: () {
                                                              showProductDetails(context: context, productId: state.recommendationProductsList[index].id ?? '', productStock: state.recommendationProductsList[index].productStock.toString(), productListIndex: 1, isSaleOn: state.isSaleOn);
                                                            });
                                                      })
                                                  : ListView.builder(
                                                      itemCount: state.recommendationProductsList.length,
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                                                      itemBuilder: (context, index) => CommonSaleListView(
                                                        context: context,
                                                        discountedPrice: double.parse(state.recommendationProductsList[index].sale?.salePrice ?? ''),
                                                        isFromSale: state.recommendationProductsList[index].sale?.isSale ?? false,
                                                        salesDesc: state.recommendationProductsList[index].sale?.saleDescription ?? '',
                                                        isPesach: state.recommendationProductsList[index].isPesach,
                                                        numberOfUnits: state.recommendationProductsList[index].numberOfUnit.toString(),
                                                        lowStock: state.recommendationProductsList[index].lowStock.toString(),
                                                        productStock: state.recommendationProductsList[index].productStock.toString(),
                                                        productImage: state.recommendationProductsList[index].mainImage ?? '',
                                                        productName: state.recommendationProductsList[index].productName ?? '',
                                                        price: double.parse(state.recommendationProductsList[index].productPrice.toString()),
                                                        onButtonTap: () {
                                                          showProductDetails(context: context, productId: state.recommendationProductsList[index].id ?? '', productStock: state.recommendationProductsList[index].productStock.toString(), productListIndex: 1, isSaleOn: state.isSaleOn);
                                                        },
                                                        isGuestUser: false,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        // ),
                                      ),
                          )
                        ],
                      ),
                      CommonSearchWidget(
                        onCloseTap: () {
                          bloc.add(const RecommendationProductsEvent.changeCategoryExpansion(isOpened: false));
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
                          // bloc.add(RecommendationProductsEvent.globalSearchEvent(context: context));
                          Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()});
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
                        searchResultWidget:state.isSearching ? const SizedBox() : state.searchList.isEmpty
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
                                    isShowSeeAll: index==state.searchList.length-1?true:false,
                                    salePrice: state.searchList[index].salePrice,
                                    saleDesc: state.searchList[index].salesDesc,
                                    isPesach: state.searchList[index].isPesach,
                                    lowStock: state.searchList[index].lowStock,
                                    numberOfUnits: state.searchList[index].numberOfUnits,
                                    priceOfBox: state.searchList[index].priceOfBox,
                                    productStock: state.searchList[index].productStock,
                                    context: context,
                                    searchName: state.searchList[index].name,
                                    searchImage: state.searchList[index].image,
                                    searchType: state.searchList[index].searchType,
                                    isMoreResults: state.searchList.where((search) => search.searchType == state.searchList[index].searchType).toList().isNotEmpty,
                                    isLastItem: state.searchList.length - 1 == index,
                                    isShowSearchLabel: index == 0
                                        ? true
                                        : state.searchList[index].searchType != state.searchList[index - 1].searchType
                                            ? true
                                            : false,
                                    onSeeAllTap: () async {
                                      if (state.searchList[index].searchType == SearchTypes.category) {
                                        dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.productCategoryScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.reqSearchString: state.search, AppStrings.searchResultString: state.searchList});
                                        if (searchResult != null) {
                                          bloc.add(RecommendationProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                        }
                                      } else if (state.searchList[index].searchType == SearchTypes.subCategory) {
                                        dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.categoryIdString: state.searchList[index].categoryId, AppStrings.categoryNameString: state.searchList[index].categoryName, AppStrings.searchString: state.search, AppStrings.searchResultString: state.searchList});
                                        if (searchResult != null) {
                                          bloc.add(RecommendationProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
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
                                        showProductDetails(context: context, productStock: state.searchList[index].productStock.toString(), productId: state.searchList[index].searchId, isBarcode: true, productListIndex: 0, isSaleOn: state.isSaleOn);
                                      } else if (state.searchList[index].searchType == SearchTypes.category) {
                                        dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.categoryIdString: state.searchList[index].searchId, AppStrings.categoryNameString: state.searchList[index].name, AppStrings.searchString: state.searchController.text, AppStrings.searchResultString: state.searchList});
                                        if (searchResult != null) {
                                          bloc.add(RecommendationProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                        }
                                      } else {
                                        state.searchList[index].searchType == SearchTypes.company ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {AppStrings.companyIdString: state.searchList[index].searchId}) : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.supplierIdString: state.searchList[index].searchId});
                                      }
                                      bloc.add(const RecommendationProductsEvent.changeCategoryExpansion());
                                    }, isGuestUser: false,
                                  );
                                },
                              ),
                        onScanTap: () async {
                          String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
                          if (scanResult != '-1') {
                            // -1 result for cancel scanning
                            showProductDetails(
                                context: context,
                                productId: scanResult,
                                isBarcode: true,
                                productStock: '1',
                                productListIndex: 0,
                                isSaleOn: state.isSaleOn);
                          }
                        },
                      ),
                    ],
                  ),
                  onNotification: (notification) {
          if (notification.metrics.pixels > (notification.metrics.maxScrollExtent - 400)) {
            if (!state.isBottomOfProducts) {
              context.read<RecommendationProductsBloc>().add(
                  RecommendationProductsEvent.getRecommendationProductsEvent(
                      context: context));
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

  void showProductDetails({required BuildContext context, required String productId, bool? isBarcode, String productStock = '0', int productListIndex = -1, required bool isSaleOn}) async {
    context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.getProductDetailsEvent(context: context, productId: productId, isBarcode: isBarcode ?? false, productListIndex: productListIndex));
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      enableDrag: true,
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
                child: BlocBuilder<RecommendationProductsBloc, RecommendationProductsState>(
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
                                        totalBottleDeposit: (state.bottleDeposit * (state.productDetails.first.numberOfUnit ?? 1) * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                        isBottle: (state.productDetails.first.isBottle ?? false),
                                        addToOrderTap: () {
                                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.addToCartProductEvent(context: context1, productId: productId));
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
                                                        onVerticalDragStart: (dragDetails) {
                                                        },
                                                        onVerticalDragUpdate: (dragDetails) {
                                                        },
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
                                        productImages: [state.productDetails.first.mainImage ?? ''],
                                        productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? ''),
                                        productPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                        productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                        scrollController: scrollController,
                                        productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                        onQuantityChanged: (quantity) {
                                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                        },
                                        onQuantityIncreaseTap: () {
                                          context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.increaseQuantityOfProduct(context: context1));
                                        },

                                        onQuantityDecreaseTap: () {
                                          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                            context.read<RecommendationProductsBloc>().add(RecommendationProductsEvent.decreaseQuantityOfProduct(context: context1));
                                          }
                                        },
                                        onCloseTap: (){Navigator.pop(context);},
                                      ),
                                      state.isRelatedShimmering?
                                      const RelatedProductShimmerWidget():
                                      state.relatedProductList.isEmpty ? 0.width : relatedProductWidget(context1, state.relatedProductList, context, isSaleOn)
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

  Widget relatedProductWidget(BuildContext prevContext, List<RelatedProductDatum> relatedProductList, BuildContext context, bool isSaleOn) {
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
                onButtonTap: () {
                  Navigator.pop(prevContext);
                  showProductDetails(isSaleOn: isSaleOn, context: context, productId: relatedProductList[i].id ?? '', isBarcode: false, productListIndex: 2, productStock: (relatedProductList[i].productStock.toString()));
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
}
