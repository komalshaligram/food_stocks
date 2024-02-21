import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/company_products/company_products_bloc.dart';
import 'package:food_stock/ui/widget/common_product_item_widget.dart';
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_button.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_list_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_search_widget.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/confetti.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';
import '../widget/supplier_products_screen_shimmer_widget.dart';

class CompanyProductsRoute {
  static Widget get route => CompanyProductsScreen();
}

class CompanyProductsScreen extends StatelessWidget {
   CompanyProductsScreen({super.key});
  String? companyName;
  String? companyLogo;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    companyName = args?[AppStrings.companyName];
    companyLogo = args?[AppStrings.companyLogo];
    return BlocProvider(
      create: (context) => CompanyProductsBloc()
        ..add(CompanyProductsEvent.getCompanyProductsIdEvent(
            companyId: args?[AppStrings.companyIdString]))
        ..add(CompanyProductsEvent.getCompanyProductsListEvent(context: context)),
      child: CompanyProductsScreenWidget(companyName:companyName,companyLogo:companyLogo),
    );
  }
}

class CompanyProductsScreenWidget extends StatelessWidget {
   const CompanyProductsScreenWidget({super.key,required this.companyName,required this.companyLogo});
  final String? companyName;
  final String? companyLogo;

  @override
  Widget build(BuildContext context) {
    CompanyProductsBloc bloc = context.read<CompanyProductsBloc>();
    return BlocBuilder<CompanyProductsBloc, CompanyProductsState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endContained ,
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            child:  Stack(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  // margin: EdgeInsets.only(bottom: 10),
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
                      color: AppColors.whiteColor,
                    ),),
                ),
                Positioned(
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
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppConstants.radius_100)),
                          border: Border.all(
                              color:  AppColors.whiteColor,
                              width: 1),
                        ),
                        child: Text(
                          '${state.cartCount}',
                          style: AppStyles.rkRegularTextStyle(
                              size: 10,
                              color:  AppColors.whiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
                  SizedBox(
                    height: 50,
                    width: 25,
                    child: Visibility(
                      visible:state.duringCelebration,
                      child: IgnorePointer(
                        child: Confetti(
                          isStopped:!state.duringCelebration,
                          snippingsCount: 10,
                          snipSize: 3.0,
                          colors:[AppColors.mainColor],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            backgroundColor:Colors.transparent,
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
             title: state.productList.isNotEmpty ? state.productList.elementAt(0).brandId ??'':companyName??'',
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: GestureDetector(
                  onTap: (){
                    context.read<CompanyProductsBloc>().add(CompanyProductsEvent.getGridListView());
                  },
                  child: Icon(state.isCompanyProductGrid ? Icons.list : Icons.grid_view)),
            ),
          ),
          body: FocusDetector(
             onFocusGained: (){
               bloc.add(CompanyProductsEvent.getCartCountEvent());
             },
            child: SafeArea(
              child: Stack(
                    children: [
                      Column(
                        children: [
                          100.height,
                       /*   Center(
                            child: CachedNetworkImage(
                              imageUrl: state.productList.isNotEmpty?"${AppUrls.baseFileUrl}${state.productList.elementAt(0).brandLogo}":companyLogo??'',
                              fit: BoxFit.scaleDown,
                              height: 100,
                              alignment: Alignment.center,
                              placeholder: (context, url) => CommonShimmerWidget(
                                child: Container(
                                  height: getScreenHeight(context),
                                  width: getScreenWidth(context),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft:
                                        Radius.circular(AppConstants.radius_10),
                                        topRight:
                                        Radius.circular(AppConstants.radius_10)),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 100,
                                //width: getScreenWidth(context),
                                color: AppColors.whiteColor,
                                child: Image.asset(
                                  AppImagePath.imageNotAvailable5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),*/
                          Expanded(
                            child: state.isShimmering
                                ? state.isCompanyProductGrid ? SupplierProductsScreenShimmerWidget() :
                            StoreCategoryScreenSubcategoryShimmerWidget()
                                : state.productList.isEmpty
                                ? Container (
                                    height: getScreenHeight(context) - 80,
                                    width: getScreenWidth(context),
                                    margin: EdgeInsets.only(top: 30),
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppLocalizations.of(context)!.this_company_has_no_product,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.smallFont,
                                          color: AppColors.textColor),
                                    ),
                                  )
                                : SmartRefresher(
                          enablePullDown: true,
                          controller: state.refreshController,
                          header:
                          RefreshWidget(),
                          footer: CustomFooter(
                            builder: (context, mode) =>
                               state.isCompanyProductGrid ? SupplierProductsScreenShimmerWidget() :StoreCategoryScreenSubcategoryShimmerWidget(),
                          ),
                          enablePullUp: !state.isBottomOfProducts,
                          onRefresh: () {
                            context.read<CompanyProductsBloc>().add(
                                CompanyProductsEvent.refreshListEvent(context: context));
                          },
                          onLoading: () {
                            context.read<CompanyProductsBloc>().add(
                                CompanyProductsEvent.getCompanyProductsListEvent(
                                    context: context));
                          },

                                  child: state.isCompanyProductGrid ? GridView.builder(
                                      itemCount: state.productList.length,
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppConstants.padding_5),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              childAspectRatio:  MediaQuery.of(context).size.width > 370 ?AppConstants
                                                  .productGridAspectRatio: AppConstants
                                                  .productGridAspectRatio1
                                          ),
                                      itemBuilder: (context, index) => DelayedWidget(
                                            child: CommonProductItemWidget(
                                              productStock: state.productList[index].productStock.toString() ?? '0',
                                                productImage: state.productList[index]
                                                        .mainImage ??
                                                    '',
                                                productName: state.productList[index]
                                                        .productName ??
                                                    '',
                                                totalSaleCount: state
                                                        .productList[index]
                                                        .totalSale ??
                                                    0,
                                                price: state.productList[index]
                                                        .productPrice ??
                                                    0.0,
                                                onButtonTap: () {
                                                  showProductDetails(
                                                      context: context,
                                                      productId: state
                                                              .productList[index]
                                                              .id ?? '',
                                                    productStock: state.productList[index].productStock.toString() ?? '0',

                                                  );
                                                }),
                                          )
                                      )
                              :ListView.builder(
                                      itemCount: state.productList.length,
                                      shrinkWrap: true,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppConstants.padding_5),
                                      itemBuilder: (context, index) => DelayedWidget(
                                          child: CommonProductListWidget(
                                              productStock: state.productList[index].productStock ?? 0,
                                              productImage: state.productList[index]
                                                  .mainImage ??
                                                  '',
                                              productName: state.productList[index]
                                                  .productName ??
                                                  '',
                                              totalSaleCount: state
                                                  .productList[index]
                                                  .totalSale ??
                                                  0,
                                              price: state.productList[index]
                                                  .productPrice ??
                                                  0.0,
                                              onButtonTap: () {
                                                showProductDetails(
                                                  context: context,
                                                  productId: state
                                                      .productList[index]
                                                      .id ??
                                                      '',
                                                  productStock: state.productList[index].productStock.toString() ?? '0',

                                                );
                                              }),
                                  ),
                                ),
                      ),),
                    ],
                  ),
                      CommonSearchWidget(
                        isFilterTap: true,
                        isCategoryExpand: state.isCategoryExpand,
                        isSearching: state.isSearching,
                        onFilterTap: () {
                          bloc.add(CompanyProductsEvent.changeCategoryExpansion());
                        },
                        onSearchTap: () {
                          if(state.searchController.text != ''){
                            bloc.add(CompanyProductsEvent.changeCategoryExpansion(isOpened: true));
                          }
                        },
                        onSearch: (String search) {
                          if (search.length > 1) {
                            bloc.add(CompanyProductsEvent.changeCategoryExpansion(isOpened: true));
                            bloc.add(
                                CompanyProductsEvent.globalSearchEvent(context: context));
                          }
                        },
                        onSearchSubmit: (String search) {
                          bloc.add(
                              CompanyProductsEvent.globalSearchEvent(context: context));
                        },
                        onOutSideTap: () {
                          bloc.add(CompanyProductsEvent.changeCategoryExpansion(
                              isOpened: false));
                        },
                        onSearchItemTap: () {
                          bloc.add(CompanyProductsEvent.changeCategoryExpansion());
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
                                      bloc.add(CompanyProductsEvent
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
                                      bloc.add(CompanyProductsEvent
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
                                          SearchTypes.product) {
                                    print("tap 4");
                                    showProductDetails(
                                        context: context,
                                        productStock: state.searchList[index].productStock.toString(),
                                        productId: state
                                            .searchList[index].searchId,
                                        isBarcode: true
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
                                      bloc.add(CompanyProductsEvent
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
                                      CompanyProductsEvent.changeCategoryExpansion());
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
                            showProductDetails(
                                context: context,
                               // productStock: '1',
                                productId: scanResult,
                                isBarcode: true);
                          }
                        },
                      ),
              ]
            ),
          ),),
        );
      },
    );
  }

  Widget buildCompanyProducts(
      {required BuildContext context,
      required int index,
      required String productImage,
      required String productName,
      required double productPrice,
      required int totalSale,
      required void Function() onPressed,
      required bool isRTL}) {
    return DelayedWidget(
      child: Container(
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
                "$totalSale ${AppLocalizations.of(context)!.discount}",
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
                    "${AppLocalizations
                        .of(context)!.currency}${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(AppConstants.amountFrLength)}",
                onPressed: onPressed,
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

  void showProductDetails(
      {required BuildContext context, required String productId,  bool? isBarcode,   String productStock = '0',
      }) async {
    context.read<CompanyProductsBloc>().add(
        CompanyProductsEvent.getProductDetailsEvent(
            context: context, productId: productId,
        isBarcode: isBarcode ?? false
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
        return BlocProvider.value(
          value: context.read<CompanyProductsBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: AppConstants.bottomSheetInitHeight,
            //    shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<CompanyProductsBloc>(),
                  child: BlocBuilder<CompanyProductsBloc, CompanyProductsState>(
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
                                context.read<CompanyProductsBloc>().add(
                                        CompanyProductsEvent
                                            .updateImageIndexEvent(
                                                index: index));
                                  },
                                  productImages: [
                                    state.productDetails.first.mainImage ?? '',
                                    ...state.productDetails.first.images?.map(
                                            (image) => image.imageUrl ?? '') ??
                                        []
                                  ],
                                  productPerUnit:
                                      state.productDetails.first.numberOfUnit ??
                                          0,

                                  productName:
                                      state.productDetails.first.productName ??
                                          '',
                                  productCompanyName:
                                      state.productDetails.first.brandName ??
                                          '',
                                  productDescription: state.productDetails.first
                                          .productDescription ??
                                      '',
                                  productSaleDescription: state.productDetails
                                          .first.productDescription ??
                                      '',
                                  productPrice: state
                                          .productStockList[state.productStockUpdateIndex]
                                          .totalPrice *
                                      state.productStockList[state.productStockUpdateIndex].quantity *
                                      (state.productDetails.first.numberOfUnit ?? 0),
                                  productScaleType: state.productDetails.first.scales?.scaleType ?? '',
                                  productWeight: state.productDetails.first.itemsWeight?.toDouble() ?? 0.0,
                               /*   isNoteOpen: state.productStockList[state.productStockUpdateIndex].isNoteOpen,
                                  onNoteToggleChanged: () {
                                    context.read<CompanyProductsBloc>().add(
                                        CompanyProductsEvent.toggleNoteEvent());
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
                                '${AppLocalizations.of(context)!.out_of_stock}',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.redColor),
                                ),
                              )*/
                                  //: buildSupplierSelection(context: context),
                            productUnitPrice: state
                                .productStockList[state.productStockUpdateIndex]
                                .totalPrice!=0?  state
                                .productStockList[state.productStockUpdateIndex]
                                .totalPrice:  double.parse(state.productDetails.first.supplierSales?.first?.productPrice.toString()??'0'),
                            productStock:state.productStockList[state.productStockUpdateIndex].stock != 0 ?
                            int.parse(state.productStockList[state.productStockUpdateIndex].stock.toString()):
                            int.parse(productStock.toString() ?? '0'),
                              isRTL: context.rtl,
                              isSupplierAvailable: state.productSupplierList.isEmpty ? false : true,
                              scrollController: scrollController,
                              productQuantity: state.productStockList[state.productStockUpdateIndex].quantity,
                              onQuantityChanged: (quantity) {
                                context.read<CompanyProductsBloc>().add(
                                    CompanyProductsEvent
                                        .updateQuantityOfProduct(
                                        context: context1,
                                        quantity: quantity));
                              },
                              onQuantityIncreaseTap: () {
                                context.read<CompanyProductsBloc>().add(
                                    CompanyProductsEvent
                                        .increaseQuantityOfProduct(
                                        context: context1));
                              },
                              onQuantityDecreaseTap: () {
                                context.read<CompanyProductsBloc>().add(
                                    CompanyProductsEvent
                                        .decreaseQuantityOfProduct(
                                                context: context1));
                                  },

                                  // TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note)..selection = TextSelection.fromPosition(TextPosition(offset: state.productStockList[state.productStockUpdateIndex].note.length)),
                                  // isLoading: state.isLoading,
                                  /*onAddToOrderPressed: state.isLoading
                                  ? null
                                  : () {
                                context
                                    .read<CompanyProductsBloc>()
                                    .add(CompanyProductsEvent
                                    .addToCartProductEvent(
                                    context: context1));
                              }*/
                                ),
                          bottomNavigationBar: state.isProductLoading
                              ? 0.height
                              : CommonProductDetailsButton(
                                  isLoading: state.isLoading,
                                  isSupplierAvailable:
                                      state.productSupplierList.isEmpty
                                          ? false
                                          : true,
                                  productStock: state
                                      .productStockList[
                                          state.productStockUpdateIndex]
                                      .stock,
                                  onAddToOrderPressed: state.isLoading
                                      ? null
                                      : () {
                                          context
                                              .read<CompanyProductsBloc>()
                                              .add(CompanyProductsEvent
                                                  .addToCartProductEvent(
                                                      context: context1,
                                            productId: productId

                                          ));
                                        }),
                        ),
                      );
                    },
                  ));
            },
          ),
        );
      },
    ).then((value){
      context.read<CompanyProductsBloc>().add(CompanyProductsEvent.getCartCountEvent());
    });
  }

  Widget buildSupplierSelection({required BuildContext context}) {
    return BlocProvider.value(
      value: context.read<CompanyProductsBloc>(),
      child: BlocBuilder<CompanyProductsBloc, CompanyProductsState>(
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
                          context.read<CompanyProductsBloc>().add(
                              CompanyProductsEvent
                                  .changeSupplierSelectionExpansionEvent());
                        },
                        child: state.productSupplierList.length > 1 ? Row(
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
                              context.read<CompanyProductsBloc>().add(
                                  CompanyProductsEvent
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
                                      '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex != -1).companyName}',
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
                                                        .of(context)!.currency}${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex == -2).basePrice.toStringAsFixed(AppConstants.amountFrLength)}',
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
                                                    '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].saleName}',
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
                                                        .of(context)!.currency}${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].salePrice.toStringAsFixed(AppConstants.amountFrLength)}(${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].saleDiscount.toStringAsFixed(0)}%)',
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
               '${AppLocalizations.of(context)!.out_of_stock}',
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont,
                            color: AppColors.redColor),
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
                                  context.read<CompanyProductsBloc>().add(
                                      CompanyProductsEvent
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
                                          '${state.productSupplierList[index].companyName}',
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
                                                                CompanyProductsBloc>()
                                                            .add(CompanyProductsEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    context:
                                                                        context,
                                                                    supplierSaleIndex:
                                                                        -2));
                                                        context
                                                            .read<
                                                                CompanyProductsBloc>()
                                                            .add(CompanyProductsEvent
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
                                                              '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}:${AppLocalizations
                                                                  .of(context)!.currency}${state.productSupplierList[index].basePrice.toStringAsFixed(AppConstants.amountFrLength)}',
                                                              style: AppStyles.rkRegularTextStyle(
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
                                                                CompanyProductsBloc>()
                                                            .add(CompanyProductsEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    context:
                                                                        context,
                                                                    supplierSaleIndex:
                                                                        subIndex));
                                                        context
                                                            .read<
                                                                CompanyProductsBloc>()
                                                            .add(CompanyProductsEvent
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
                                                                color: state.productSupplierList[index].selectedIndex ==
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
                                                              '${state.productSupplierList[index].supplierSales[subIndex].saleName}',
                                                              style: AppStyles.rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .font_12,
                                                                  color: AppColors
                                                                      .saleRedColor),
                                                            ),
                                                            2.height,
                                                            Text(
                                                              '${AppLocalizations.of(context)!.price} : ${AppLocalizations
                                                                  .of(context)!.currency}${state.productSupplierList[index].supplierSales[subIndex].salePrice.toStringAsFixed(AppConstants.amountFrLength)}(${state.productSupplierList[index].supplierSales[subIndex].saleDiscount.toStringAsFixed(0)}%)',
                                                              style: AppStyles.rkRegularTextStyle(
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
                                                                          '${state.productSupplierList[index].supplierSales[subIndex].saleDescription}');
                                                                },
                                                                child: Text(
                                                                  '${AppLocalizations.of(context)!.read_condition}',
                                                                  style: AppStyles.rkRegularTextStyle(
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
        builder: (context) => CommonSaleDescriptionDialog(
            title: saleCondition,
            onTap: () {
              Navigator.pop(context);
            },
            buttonTitle: '${AppLocalizations.of(context)!.ok}'));
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
             height: (productStock) != 0 ? 35 : 50,
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
                         return Container(
                             width: 40,
                             height: 35,
                             child: CupertinoActivityIndicator());
                       }
                     },
                     errorBuilder: (context, error, stackTrace) {
                       return searchType == SearchTypes.subCategory
                           ? Image.asset(AppImagePath.imageNotAvailable5,
                           height: 35, width: 40, fit: BoxFit.cover)
                           : SvgPicture.asset(
                         AppImagePath.splashLogo,
                         fit: BoxFit.scaleDown,
                         width: 40,
                         height: 35,
                       );
                     },
                   ),
                 ),
                 10.width,
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(
                       child: Text(
                         searchName,
                         style: AppStyles.rkRegularTextStyle(
                           size: AppConstants.font_12,
                           color: AppColors.blackColor,
                         ),
                         maxLines: 1,
                         overflow: TextOverflow.ellipsis,
                       ),
                     ),
                     (productStock) != 0 ? 0.width : Text(
                       AppLocalizations.of(context)!
                           .out_of_stock1,
                       style: AppStyles.rkBoldTextStyle(
                           size: AppConstants.font_12,
                           color: AppColors.redColor,
                           fontWeight: FontWeight.w400),
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
}
