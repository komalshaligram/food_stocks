import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/reorder/reorder_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/widget/common_check_box_widget.dart';
import 'package:food_stock/ui/widget/refresh_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_sale_item_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/confetti.dart';
import '../widget/custom_button_widget.dart';
import '../widget/filter_bottom_sheet_shimmer_widget.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';
import '../widget/supplier_products_screen_shimmer_widget.dart';


class ReorderRoute {
  static Widget get route => ReorderScreen();
}

class ReorderScreen extends StatelessWidget {
  const ReorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ReorderBloc()
        ..add(ReorderEvent.getPreviousOrderProductsEvent(context: context))
        ..add(ReorderEvent.userApproveEvent(context: context))
    ,
      child: ReorderScreenWidget(),
    );
  }
}

class ReorderScreenWidget extends StatelessWidget {
  const ReorderScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ReorderBloc bloc = context.read<ReorderBloc>();
    return BlocListener<ReorderBloc, ReorderState>(
  listener: (context, state) {

  },
  child: BlocBuilder<ReorderBloc, ReorderState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation
              .endContained,
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            child: Stack(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.transparent,
                          width: 1
                      ),
                      gradient: AppColors.appMainGradientColor,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppConstants.radius_100))),
                  child: Center(
                    child: SvgPicture.asset(
                      AppImagePath.cart,
                      height: 26,
                      width: 26,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          AppColors.whiteColor, BlendMode.srcIn),
                    ),),
                ),
                state.cartCount != 0 ? Positioned(
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
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppConstants.radius_100)),
                          border: Border.all(
                              color: AppColors.whiteColor,
                              width: 1),
                        ),
                        child: Text(
                          '${state.cartCount}',
                          style: AppStyles.rkRegularTextStyle(
                              size: 10,
                              color: AppColors.whiteColor),
                        ),
                      ),
                    ],
                  ),
                ) : 0.width,
                SizedBox(
                  height: 50,
                  width: 25,
                  child: Visibility(
                    visible: state.duringCelebration,
                    child: IgnorePointer(
                      child: Confetti(
                        isStopped: !state.duringCelebration,
                        snippingsCount: 10,
                        snipSize: 3.0,
                        colors: [AppColors.mainColor],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name,
                  arguments: {AppStrings.isBasketScreenString: 'true'}
              );
            },
          ),
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.previous_order_products,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: Row(
                children: [
                 /* GestureDetector(
                      onTap: () {
                        bloc.add(ReorderEvent.filterEvent(context: context));
                        filterBottomSheet(context: context);
                      },
                      child: Icon(Icons.filter_alt)),*/
                  5.width,
                  GestureDetector(
                      onTap: () {
                        context.read<ReorderBloc>().add(
                            ReorderEvent.getGridListView());
                      },
                      child: Icon(
                          state.isGridView ? Icons.list : Icons.grid_view)),
                ],
              ),
            ),
          ),
          body: FocusDetector(
            onFocusGained: () {
              bloc.add(ReorderEvent.getCartCountEvent());
              bloc.add(ReorderEvent.getPermissionList(context: context));
            },
            child: SafeArea(
              child: Stack(
                children: [
                  SmartRefresher(
                    enablePullDown:
                    true,
                    controller: state.refreshController,
                    header: RefreshWidget(),
                    footer: CustomFooter(
                      builder: (context, mode) =>
                      state.isGridView
                          ? SupplierProductsScreenShimmerWidget()
                          : StoreCategoryScreenSubcategoryShimmerWidget(),
                    ),
                    enablePullUp: !state.isBottomOfProducts,
                    onRefresh: () {
                      context
                          .read<ReorderBloc>()
                          .add(ReorderEvent.refreshListEvent(context: context));
                    },
                    onLoading: () {
                      context.read<ReorderBloc>().add(
                          ReorderEvent.getPreviousOrderProductsEvent(
                              context: context));
                    },
                    child:
                    SingleChildScrollView(
                      physics: state.previousOrderProductsList.isEmpty
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          100.height,
                          state.isShimmering
                              ? state.isGridView
                              ? SupplierProductsScreenShimmerWidget()
                              : StoreCategoryScreenSubcategoryShimmerWidget()
                              : state.previousOrderProductsList.isEmpty
                              ? Container(
                            height: getScreenHeight(context) - 80,
                            width: getScreenWidth(context),
                            alignment: Alignment.center,
                            child: Text(
                              '${AppLocalizations.of(context)!.no_data}',
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.smallFont,
                                  color: AppColors.textColor),
                            ),
                          )
                              : state.isGridView ? GridView.builder(
                              itemCount: state
                                  .previousOrderProductsList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConstants.padding_5),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio:
                                  getChildAspectRatio(context,state.isSaleOn)),
                              itemBuilder: (context, index) =>
                                  CommonProductSaleItemWidget(
                                      isSale: state
                                          .previousOrderProductsList[
                                      index]
                                          .sale?.isSale ?? false,
                                      isGuestUser: false,
                                      height: AppConstants
                                          .salesProductItemHeight,
                                      width: 140,
                                      productName: state
                                          .previousOrderProductsList[
                                      index]
                                          .productName ?? '',
                                      saleImage: state
                                          .previousOrderProductsList[
                                      index]
                                          .mainImage ?? '',
                                      title: state
                                          .previousOrderProductsList[
                                      index]
                                          .name,
                                      description: parse(state.previousOrderProductsList[index].sale?.saleDescription).body?.text ?? '',
                                      discountedPrice: double.parse(state.previousOrderProductsList[index].sale?.salePrice ?? ''),
                                      originalPrice: state.previousOrderProductsList[index].productPrice,
                                      productStock: state.previousOrderProductsList[index].productStock.toString(),
                                      lowStock: state.previousOrderProductsList[index].lowStock ?? '',
                                      isPesach: state.previousOrderProductsList[index].isPesach,
                                      onButtonTap: () {
                                        showProductDetails(
                                            context: context,
                                            productId: state.previousOrderProductsList[index].id ?? '',
                                            productListIndex: 1,
                                            isBarcode: false,
                                            productStock: state
                                                .previousOrderProductsList[
                                            index]
                                                .productStock
                                                .toString());
                                      })
                          ) :
                          ListView.builder(
                              itemCount: state.previousOrderProductsList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConstants.padding_5),
                              itemBuilder: (context, index) =>
                                  CommonSaleListView(
                                      context: context,
                                      discountedPrice: double.parse(state.previousOrderProductsList[index].sale?.salePrice ?? ''),
                                      isFromSale: state.previousOrderProductsList[index].sale?.isSale,
                                      salesDesc: state.previousOrderProductsList[index].sale?.saleDescription,
                                      isGuestUser: false,
                                      isPesach: state.previousOrderProductsList[index].isPesach,
                                      numberOfUnits: state.previousOrderProductsList[index].numberOfUnit.toString(),
                                      lowStock: state.previousOrderProductsList[index].lowStock.toString(),
                                      productStock: state.previousOrderProductsList[index].productStock.toString(),
                                      productImage: state.previousOrderProductsList[index].mainImage ?? '',
                                      productName: state.previousOrderProductsList[index].productName ?? '',
                                      price: double.parse(state.previousOrderProductsList[index].productPrice.toString()),
                                      onButtonTap: () {
                                        showProductDetails(
                                          productListIndex: 1,
                                          context: context,
                                          productId: state.previousOrderProductsList[index].id ?? '',
                                          productStock: state
                                              .previousOrderProductsList[
                                          index]
                                              .productStock
                                              .toString(),
                                        );
                                      })

                          ),
                        ],
                      ),
                    ),
                    // ),
                  ),
                  CommonSearchWidget(
                    onCloseTap: () {
                      bloc.add(ReorderEvent.changeCategoryExpansion(
                          isOpened: false));
                    },
                    isFilterTap: true,
                    isCategoryExpand: state.isCategoryExpand,
                    isSearching: state.isSearching,
                    onFilterTap: () {
                      bloc.add(ReorderEvent.changeCategoryExpansion());
                    },
                    onSearchTap: () {
                      if (state.searchController.text != '') {
                        bloc.add(ReorderEvent.changeCategoryExpansion(
                            isOpened: true));
                      }
                    },
                    onSearch: (String search) {
                      if (search.length > 1) {
                        bloc.add(ReorderEvent.changeCategoryExpansion(
                            isOpened: true));
                        bloc.add(
                            ReorderEvent.globalSearchEvent(context: context));
                      }
                    },
                    onSearchSubmit: (String search) {
                      // bloc.add(ReorderEvent.globalSearchEvent(context: context));
                      Navigator.pushNamed(
                          context,
                          RouteDefine.supplierProductsScreen.name,
                          arguments: {
                            AppStrings.searchString: state.search,
                            AppStrings.searchType: SearchTypes.product
                                .toString()
                          });
                    },
                    onOutSideTap: () {
                      bloc.add(ReorderEvent.changeCategoryExpansion(
                          isOpened: false));
                    },
                    onSearchItemTap: () {
                      bloc.add(ReorderEvent.changeCategoryExpansion());
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
                        return SearchItemWidget(
                            salePrice: state.searchList[index].salePrice,
                            saleDesc: state.searchList[index].salesDesc,
                            isPesach: state.searchList[index].isPesach,
                            lowStock: state.searchList[index].lowStock
                                .toString(),
                            numberOfUnits: state.searchList[index]
                                .numberOfUnits,
                            priceOfBox: state.searchList[index].priceOfBox,
                            productStock: state.searchList[index].productStock,
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
                              debugPrint("searchType: ${state.searchList[index]
                                  .searchType}");
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
                                  bloc.add(ReorderEvent
                                      .updateGlobalSearchEvent(
                                      search: searchResult[
                                      AppStrings.searchString],
                                      searchList: searchResult[
                                      AppStrings
                                          .searchResultString]));
                                }
                              } else if (state.searchList[index].searchType ==
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
                                  bloc.add(ReorderEvent.updateGlobalSearchEvent(
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
                                      AppStrings.searchString: state.search,
                                      AppStrings.searchType: SearchTypes.product
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
                                showProductDetails(
                                    context: context,
                                    productStock: state.searchList[index]
                                        .productStock.toString(),
                                    productId: state
                                        .searchList[index].searchId,
                                    isBarcode: true,
                                    productListIndex: 0
                                );
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
                                  bloc.add(ReorderEvent
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
                                  ReorderEvent.changeCategoryExpansion());
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
                        showProductDetails(
                            context: context,
                            productId: scanResult,
                            isBarcode: true,
                            productStock: '1',
                            productListIndex: 0
                        );
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

  Widget buildPreviousOrderProductItem({
    required BuildContext context,
    required int index,
    required int totalSale,
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
              "${AppLocalizations.of(context)!.currency}${productPrice
                  .toStringAsFixed(AppConstants.amountFrLength) == "0.00"
                  ? '0'
                  : productPrice.toStringAsFixed(AppConstants.amountFrLength)}",
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
    required BuildContext context, required String productId,
    bool? isBarcode, String productStock = '0',
    required int productListIndex

  }) async {
    context.read<ReorderBloc>().add(ReorderEvent.getProductDetailsEvent(
        context: context, productId: productId,
        isBarcode: isBarcode ?? false,
        productListIndex: productListIndex
    ));
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
            maxChildSize: 1 -
                (MediaQuery
                    .of(context)
                    .viewPadding
                    .top /
                    getScreenHeight(context) * 0.2),
            minChildSize: productStock == '0' ? 0.9 : 1 -
                (MediaQuery
                    .of(context)
                    .viewPadding
                    .top /
                    getScreenHeight(context) * 0.2),
            initialChildSize: productStock == '0' ? 0.9 : 1 -
                (MediaQuery
                    .of(context)
                    .viewPadding
                    .top /
                    getScreenHeight(context) * 0.2),
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                value: context.read<ReorderBloc>(),
                child: BlocBuilder<ReorderBloc, ReorderState>(
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
                          ? NoDataBottomSheet(dialogContext: context)
                          : SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: Column(
                          children: [
                            CommonProductDetailsWidget(
                              isIncludedVat: state.isIncludedVat,
                              productDetails: state.productDetails,
                            /*  salePrice: double.parse(
                                  state.productDetails.first.sale.salePrice),
                              maxQty: state.productDetails.first.sale
                                  .saleMaxQuantity,
                              endDate: state.productDetails.first.sale
                                  .saleUntilDate,
                              startDate: state.productDetails.first.sale
                                  .saleFromDate,
                              isSaleOn: state.productDetails.first.sale.isSale,*/
                              isSubUserAddToBasket: state.isSubUserAddToBasket,
                              bottleTax: state.bottleDeposit,
                              totalBottleDeposit: (state.bottleDeposit *
                                  (state.productDetails.first.numberOfUnit ?? 1).toDouble() * state
                                  .productStockList[state.productListIndex][
                              state.productStockUpdateIndex]
                                  .quantity),
                              isBottle:(state.productDetails.first.isBottle ?? false),
                            /*  nmMashlim: state.productDetails.first.nmMashlim,
                              isPesach: state.productDetails.first.isPesach,
                              lowStock: state.productDetails.first.supplierSales
                                  .first.lowStock.toString() ?? '',
                              qrCode: state.productDetails.first.qrcode ?? '',*/
                              addToOrderTap: () {
                                context.read<ReorderBloc>().add(
                                    ReorderEvent.addToCartProductEvent(
                                        context: context1,
                                        productId: productId
                                    ));
                              },
                              isLoading: state.isLoading,
                              imageOnTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: getScreenHeight(context) -
                                              MediaQuery
                                                  .of(context)
                                                  .padding
                                                  .top,
                                          width: getScreenWidth(context),
                                          child: GestureDetector(
                                            onVerticalDragStart: (dragDetails) {
                                              debugPrint('onVerticalDragStart');
                                            },
                                            onVerticalDragUpdate: (
                                                dragDetails) {
                                              debugPrint(
                                                  'onVerticalDragUpdate');
                                            },
                                            onVerticalDragEnd: (endDetails) {
                                              debugPrint('onVerticalDragEnd');
                                              Navigator.pop(dialogContext);
                                            },
                                            child: PhotoView(
                                              imageProvider: NetworkImage(
                                                '${AppUrls.baseFileUrl}${state
                                                    .productDetails[state
                                                    .imageIndex].mainImage}',
                                              ),
                                            ),
                                          ),
                                        ),

                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Icon(Icons.close,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ],
                                    );
                                  },);
                              },
                              context: context,
                              productImageIndex: state.imageIndex,
                              onPageChanged: (index, p1) {
                                context.read<ReorderBloc>().add(
                                    ReorderEvent.updateImageIndexEvent(
                                        index: index));
                              },
                              productImages: [
                                state.productDetails.first.mainImage ??
                                    '',
                                ...?state.productDetails.first.images?.map((
                                    image) =>
                                image.imageUrl ?? '')
                              ],
                            productUnitPrice: double.parse(
                                state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'),
                          /*    productPerUnit: state.productDetails.first
                                  .numberOfUnit,
                             ,
                              productName: state.productDetails.first
                                  .productName,

                              productSaleDescription: parse(state
                                  .productDetails
                                  .first
                                  .sale.saleDescription ??
                                  '')
                                  .body
                                  ?.text ??
                                  '',*/
                              productPrice: state
                                  .productStockList[state
                                  .productListIndex][state
                                  .productStockUpdateIndex]
                                  .totalPrice *
                                  state
                                      .productStockList[state.productListIndex][
                                  state.productStockUpdateIndex]
                                      .quantity *
                                  (state.productDetails.first
                                      .numberOfUnit ?? 1),

                              /*productWeight: state
                                  .productDetails.first.itemsWeight.toDouble(),*/
                              productStock: (state.productStockList[state
                                  .productListIndex][state
                                  .productStockUpdateIndex].stock.toString()),
                              isRTL: context.rtl,
                             /* isSupplierAvailable:
                              state.productSupplierList.isEmpty
                                  ? false
                                  : true,*/
                              scrollController: scrollController,
                              productQuantity: state
                                  .productStockList[state.productListIndex][
                              state.productStockUpdateIndex]
                                  .quantity,
                              onQuantityChanged: (quantity) {
                                context.read<ReorderBloc>().add(
                                    ReorderEvent.updateQuantityOfProduct(
                                        context: context1,
                                        quantity: quantity));
                              },
                              onQuantityIncreaseTap: () {
                                context.read<ReorderBloc>().add(
                                    ReorderEvent.increaseQuantityOfProduct(
                                        context: context1));
                              },
                              onQuantityDecreaseTap: () {
                                if (state
                                    .productStockList[state.productListIndex][
                                state.productStockUpdateIndex]
                                    .quantity > 1) {
                                  context.read<ReorderBloc>().add(
                                      ReorderEvent.decreaseQuantityOfProduct(
                                          context: context1));
                                }
                              },
                            ),
                            state.relatedProductList.isEmpty
                                ? 0.width
                                : relatedProductWidget(
                                context1, state.relatedProductList, context)
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
          alignment:
          context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
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
          height: AppConstants.salesProductItemHeight,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2, i) {
              return CommonProductSaleItemWidget(
                isSale: relatedProductList.elementAt(i).sale?.isSale,
                isGuestUser: false,
                height: AppConstants.salesProductItemHeight,
                width: 140,
                productName: relatedProductList.elementAt(i).productName ?? '' ,
                saleImage: relatedProductList.elementAt(i).mainImage ?? '' ,
                title: relatedProductList.elementAt(i).name ,
                description: parse(relatedProductList
                    .elementAt(i)
                    .sale?.saleDescription )
                    .body
                    ?.text ??
                    '',
                discountedPrice: double.parse(
                    relatedProductList.elementAt(i).sale?.salePrice ?? '0'),
                originalPrice:
                relatedProductList.elementAt(i).productPrice ,
                productStock:
                relatedProductList.elementAt(i).productStock.toString(),
                lowStock: relatedProductList.elementAt(i).lowStock ?? '',
                isPesach: relatedProductList.elementAt(i).isPesach,

                onButtonTap: () {
                  Navigator.pop(prevContext);
                  showProductDetails(
                      productListIndex: 2,
                      context: context,
                      productId:
                      relatedProductList[i].id ?? '',
                      isBarcode: false,
                      productStock: (relatedProductList[i].productStock
                          .toString())
                  );
                },);
            }

            , itemCount: relatedProductList.length,),
        )
      ],
    );
  }

  Widget buildSupplierSelection({required BuildContext context}) {
    return BlocProvider.value(
      value: context.read<ReorderBloc>(),
      child: BlocBuilder<ReorderBloc, ReorderState>(
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
                          context.read<ReorderBloc>().add(ReorderEvent
                              .changeSupplierSelectionExpansionEvent());
                        },
                        child: state.productSupplierList.length > 1
                            ? Row(
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
                              Icons.arrow_drop_down,
                              size: 26,
                              color: AppColors.blackColor,
                            )
                          ],
                        )
                            : 0.width,
                      ),
                    ),
                    state.productSupplierList
                        .where((supplier) => supplier.selectedIndex != -1)
                        .isEmpty
                        ? InkWell(
                        onTap: () {
                          context.read<ReorderBloc>().add(ReorderEvent
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
                                        '${AppLocalizations.of(context)!
                                            .price}:${AppLocalizations.of(
                                            context)!.currency}${state
                                            .productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex == -2)
                                            .basePrice
                                            .toStringAsFixed(
                                            AppConstants.amountFrLength)}',
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
                                        '${AppLocalizations.of(context)!
                                            .price}:${AppLocalizations.of(
                                            context)!.currency}${state
                                            .productSupplierList
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
                            context.read<ReorderBloc>().add(ReorderEvent
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
                                                .read<ReorderBloc>()
                                                .add(ReorderEvent
                                                .supplierSelectionEvent(
                                                supplierIndex:
                                                index,
                                                context:
                                                context,
                                                supplierSaleIndex:
                                                -2));
                                            context
                                                .read<ReorderBloc>()
                                                .add(ReorderEvent
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
                                                  '${AppLocalizations.of(
                                                      context)!
                                                      .price} : ${AppLocalizations
                                                      .of(context)!
                                                      .currency}${state
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
                                                .read<ReorderBloc>()
                                                .add(ReorderEvent
                                                .supplierSelectionEvent(
                                                supplierIndex:
                                                index,
                                                context:
                                                context,
                                                supplierSaleIndex:
                                                subIndex));
                                            context
                                                .read<ReorderBloc>()
                                                .add(ReorderEvent
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
                                                  '${AppLocalizations.of(
                                                      context)!
                                                      .price} : ${AppLocalizations
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
                                                      '${AppLocalizations.of(
                                                          context)!
                                                          .read_condition}',
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

  void filterBottomSheet({required BuildContext context}) {
    showMaterialModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      enableDrag: true,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                  AppConstants.radius_20),
              topLeft: Radius.circular(
                  AppConstants.radius_20)),
          borderSide: BorderSide.none),
      builder: (context1) {
        ReorderBloc bloc = context.read<ReorderBloc>();
        return BlocProvider.value(
          value: context.read<ReorderBloc>(),
          child: DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.8,
            minChildSize: 0.4,
            initialChildSize: 0.8,
            builder: (context, scrollController) {
              return BlocBuilder<ReorderBloc, ReorderState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: state.isFilterShimmering
                        ? FilterBottomSheetShimmerWidget()
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context1);
                              },
                              child: Icon(Icons.close)),
                        ),
                        15.height,
                        Text(
                          AppLocalizations.of(context)!.sorting,
                          style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.mediumFont,
                            color: AppColors.blackColor,),
                          textAlign: TextAlign.center,
                        ),
                        10.height,
                        Container(
                          color: AppColors.pageColor,
                          child: CommonDropDownButton(
                            color: AppColors.borderColor,
                            value: state.sortingField,
                            items: state.sortingList.map((element) {
                              return DropdownMenuItem<String>(
                                value: element,
                                child: Text(element),
                              );
                            }).toList(),
                            onChanged: (value) {
                              bloc.add(
                                  ReorderEvent.sortingEvent(
                                      context: context,
                                      sortField: value ?? ''));
                            },),
                        ),
                        15.height,
                        Text(
                          AppLocalizations.of(context)!.filtering,
                          style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.mediumFont,
                            color: AppColors.blackColor,),
                          textAlign: TextAlign.center,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.filterList.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor.withOpacity(
                                          0.3),
                                      border: Border.all(
                                        color: AppColors.borderColor,
                                      )),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                    ),
                                    child: ListTileTheme(
                                      dense: true,
                                      child: Container(
                                        color: AppColors.pageColor,
                                        child: ExpansionTile(
                                          title: Text(
                                              state.filterList[index].brandModel
                                                  ?.filterFieldName ?? '',
                                              style: AppStyles
                                                  .rkRegularTextStyle(
                                                size: AppConstants.mediumFont,
                                                color: AppColors.blackColor,)),
                                          children: <Widget>[
                                            ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: state.filterList[index]
                                                  .brandModel
                                                  ?.FilterFieldProductList
                                                  .length,
                                              physics: ClampingScrollPhysics(),
                                              itemBuilder: (context, subIndex) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .pageColor,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: AppColors
                                                                .borderColor
                                                                .withOpacity(
                                                                0.4)),
                                                      )),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      (state.filterList[index]
                                                          .brandModel
                                                          ?.FilterFieldProductList[subIndex]
                                                          .subCategoriesList
                                                          .isEmpty ?? false)
                                                          ?
                                                      Text(state
                                                          .filterList[index]
                                                          .brandModel!
                                                          .FilterFieldProductList[subIndex]
                                                          .name,
                                                          style: AppStyles
                                                              .rkRegularTextStyle(
                                                              size: AppConstants
                                                                  .mediumFont,
                                                              color: AppColors
                                                                  .blackColor))
                                                          : Expanded(
                                                        child: ExpansionTile(
                                                          tilePadding: EdgeInsets.zero,
                                                            leading: (state.filterList[index].brandModel?.FilterFieldProductList[subIndex].subCategoriesList.isNotEmpty ?? false) ? (state
                                                                .filterList[index]
                                                                .brandModel?.FilterFieldProductList[subIndex].isExpansion ?? false) ?
                                                            Icon(Icons.keyboard_arrow_up_outlined) :
                                                            Icon(Icons.keyboard_arrow_down_rounded): 0.width,
                                                            trailing : SizedBox(
                                                              width: 75,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  (state.filterList[index].brandModel?.FilterFieldProductList[subIndex].subCategoriesList.isNotEmpty ?? false) ?  CommonCheckBox(
                                                                    value: state
                                                                        .filterList[index]
                                                                        .brandModel
                                                                        ?.FilterFieldProductList[subIndex]
                                                                        .isSelected ??
                                                                        false,
                                                                    onChanged: (value) {
                                                                     bloc.add(
                                                                          ReorderEvent
                                                                              .selectFilterFieldEvent(
                                                                              context: context,
                                                                              mainIndex: index,
                                                                              subIndex: subIndex,
                                                                              subCatIndex: -1
                                                                          ));
                                                                    },
                                                                  ) : 0.width,
                                                                ],
                                                              ),
                                                            ),
                                                          onExpansionChanged: (value){
                                                           bloc.add(ReorderEvent.expansionChangeEvent(isExpansionChanged: value,
                                                           subIndex: subIndex,mainIndex: index,
                                                           ));
                                                          },
                                                          title: Text(state
                                                              .filterList[index]
                                                              .brandModel!
                                                              .FilterFieldProductList[subIndex]
                                                              .name,
                                                              style: AppStyles
                                                                  .rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .mediumFont,
                                                                  color: AppColors
                                                                      .blackColor)),
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: ListView.builder(
                                                                scrollDirection: Axis
                                                                    .vertical,
                                                                shrinkWrap: true,
                                                                itemCount: state
                                                                    .filterList[index]
                                                                    .brandModel?.FilterFieldProductList[subIndex]
                                                                    .subCategoriesList
                                                                    .length,
                                                                physics: ClampingScrollPhysics(),
                                                                itemBuilder: (
                                                                    BuildContext context,
                                                                    int subCatIndex) {
                                                                  return Container(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 10,
                                                                        vertical: 5),
                                                                    decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .pageColor,
                                                                        border: Border(
                                                                          bottom: BorderSide(
                                                                              color: AppColors
                                                                                  .borderColor
                                                                                  .withOpacity(
                                                                                  0.4)),
                                                                        )),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text((state.filterList[index]
                                                                            .brandModel?.FilterFieldProductList[subIndex]
                                                                            .subCategoriesList[subCatIndex]
                                                                            .name ?? ''),
                                                                            style: AppStyles
                                                                                .rkRegularTextStyle(
                                                                                size: AppConstants
                                                                                    .mediumFont,
                                                                                color: AppColors
                                                                                    .blackColor)),
                                                                       CommonCheckBox(
                                                                          value: state
                                                                              .filterList[index]
                                                                              .brandModel
                                                                              ?.FilterFieldProductList[subIndex].subCategoriesList[subCatIndex]
                                                                              .isSelected ??
                                                                              false,
                                                                          onChanged: (
                                                                              value) {
                                                                            bloc.add(
                                                                                ReorderEvent
                                                                                    .selectFilterFieldEvent(
                                                                                    context: context,
                                                                                    mainIndex: index,
                                                                                    subIndex: subIndex,
                                                                                  subCatIndex: subCatIndex
                                                                                ));
                                                                          },
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
                                                      (state.filterList[index].brandModel?.FilterFieldProductList[subIndex].subCategoriesList.isEmpty ?? false) ?  CommonCheckBox(
                                                        value: state
                                                            .filterList[index]
                                                            .brandModel
                                                            ?.FilterFieldProductList[subIndex]
                                                            .isSelected ??
                                                            false,
                                                        onChanged: (value) {
                                                         bloc.add(
                                                              ReorderEvent
                                                                  .selectFilterFieldEvent(
                                                                  context: context,
                                                                  mainIndex: index,
                                                                  subIndex: subIndex,
                                                                subCatIndex: -1
                                                              ));
                                                        },
                                                      ) : SizedBox()
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        10.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButtonWidget(
                              width: 120,
                              height: 40,
                              buttonText: AppLocalizations.of(context)!.apply,
                              fontColors: AppColors.whiteColor,
                              //isLoading: state.isLoading,
                              onPressed: () {
                                context.read<ReorderBloc>().add(
                                    ReorderEvent.applyFilterEvent(
                                        context: context));
                              },
                              bGColor: AppColors.mainColor,
                            ),
                            CustomButtonWidget(
                              width: 120,
                              height: 40,
                              buttonText: AppLocalizations.of(context)!.clear,
                              fontColors: AppColors.whiteColor,
                              //  isLoading: state.isLoading,
                              onPressed: () {
                                context.read<ReorderBloc>().add(
                                    ReorderEvent.clearFilterEvent(
                                        context: context));
                              },
                              bGColor: AppColors.mainColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },);
  }
}
