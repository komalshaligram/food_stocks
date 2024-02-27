import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/bloc/supplier_products/supplier_products_bloc.dart';
import 'package:food_stock/data/model/search_model/search_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_product_item_widget.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/supplier_products_screen_shimmer_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_button.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_list_widget.dart';
import '../widget/common_sale_description_dialog.dart';
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
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map?;
    debugPrint('supplier products args = $args');
    return BlocProvider(
      create: (context) =>
      SupplierProductsBloc()
        ..add(SupplierProductsEvent.getSupplierProductsIdEvent(
            supplierId: args?[AppStrings.supplierIdString] ?? '',
            search: args?[AppStrings.searchString] ?? ''))..add(
          SupplierProductsEvent.getSupplierProductsListEvent(
              context: context,searchType: args?[AppStrings.searchType]??'')),
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
                title: AppLocalizations.of(context)!.products,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                trailingWidget: GestureDetector(
                    onTap: (){
                      context.read<SupplierProductsBloc>().add(SupplierProductsEvent.getGridListView());
                    },
                    child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
              ),
            ),
            body: SafeArea(
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
                            builder: (context, mode) =>
                               state.isGridView ?  SupplierProductsScreenShimmerWidget() : StoreCategoryScreenSubcategoryShimmerWidget(),
                          ),
                          enablePullUp: !state.isBottomOfProducts,
                          onRefresh: () {
                            context.read<SupplierProductsBloc>().add(
                                SupplierProductsEvent.refreshListEvent(
                                    context: context));
                          },
                          onLoading: () {
                            context.read<SupplierProductsBloc>().add(
                                SupplierProductsEvent.getSupplierProductsListEvent(
                                    context: context,searchType: state.searchType));
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
                                    ?  state.isGridView ?  SupplierProductsScreenShimmerWidget() : StoreCategoryScreenSubcategoryShimmerWidget()
                                    : state.productList.isEmpty
                                    ? Container(
                                  height: getScreenHeight(context) - 80,
                                  width: getScreenWidth(context),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${AppLocalizations.of(context)!.currently_this_Supplier_has_no_products}',
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.smallFont,
                                        color: AppColors.textColor),
                                  ),
                                )
                                    : state.isGridView ? GridView.builder(
                                    itemCount: state.productList.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppConstants.padding_5),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: MediaQuery.of(context).size.width > 370 ?AppConstants
                                            .productGridAspectRatio: AppConstants
                                            .productGridAspectRatio1
                                    ),
                                    itemBuilder: (context, index) {
                                      return DelayedWidget(
                                          child: CommonProductItemWidget(
                                              imageHeight: getScreenHeight(context) >= 1000 ? getScreenHeight(context) * 0.17 : 70,
                                              imageWidth: getScreenWidth(context) >= 700 ? getScreenWidth(context) * 100 : 70,
                                            isGuestUser: state.isGuestUser,
                                              productStock: state.productList[index].productStock.toString() ?? '0',
                                                      productImage: state
                                                              .productList[index]
                                                              .mainImage ??
                                                          '',
                                                      productName: state
                                                              .productList[index]
                                                              .productName ??
                                                          '',
                                                      totalSaleCount: 0,
                                                      price: double.parse(state
                                                              .productList[index]
                                                              .productPrice.toString() ??
                                                          "0.0"),
                                                      onButtonTap: () {
                                               if(!state.isGuestUser){
                                                 showProductDetails(
                                                     context: context,
                                                     productId: /*state.searchType==SearchTypes.product.toString()?state.productList[index].id??'':state
                                                         .productList[index]
                                                         .productId ??
                                                         '',*/state
                                                         .productList[index]
                                                         .productId ??
                                                         '',
                                                     productStock : '0',
                                                 );
                                               }
                                               else{
                                                 Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                               }
                        
                                                      }),
                                        );
                                    }
                                ) :
                                ListView.builder(
                                  itemCount: state.productList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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
                                        /*totalSaleCount: state
                                            .productList[index]
                                            .totalSale ??
                                            0,*/
                                        price: state.productList[index]
                                            .productPrice ??
                                            0.0,
                                        onButtonTap: () {
          if(!state.isGuestUser) {
            showProductDetails(
              context: context,
              productId: state
                  .productList[index]
                  .id ??
                  '',
              productStock: state.productList[index].productStock.toString() ??
                  '0',

            );
          }
                                        }, totalSaleCount: 0,),
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
                      bloc.add(SupplierProductsEvent.changeCategoryExpansion(isOpened: false));
                    },
                    isFilterTap: true,
                    isCategoryExpand: state.isCategoryExpand,
                    isSearching: state.isSearching,
                    onFilterTap: () {
                      bloc.add(SupplierProductsEvent.changeCategoryExpansion());
                    },
                    onSearchTap: () {
                      if(state.searchController.text != ''){
                        bloc.add(SupplierProductsEvent.changeCategoryExpansion(isOpened: true));
                      }
                    },
                    onSearch: (String search) {
                      if (search.length > 1) {
                        bloc.add(SupplierProductsEvent.changeCategoryExpansion(isOpened: true));
                        bloc.add(
                            SupplierProductsEvent.globalSearchEvent(context: context));
                      }
                    },
                    onSearchSubmit: (String search) {
                      bloc.add(
                          SupplierProductsEvent.globalSearchEvent(context: context));
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
                                      AppStrings.categoryNameString:
                                      state.searchList[index]
                                          .categoryName,
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
                                        .supplierProductsScreen
                                        .name,
                                    arguments: {
                                      AppStrings.supplierIdString:
                                      state.searchList[index]
                                          .searchId
                                    });
                              }
                              bloc.add(
                                  SupplierProductsEvent.changeCategoryExpansion());
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
                ],
              ),
        
            ),
          );
        },
      ),
    );
  }

  Widget buildSupplierProducts({required BuildContext context,
    required int index,
    required String productImage,
    required String productName,
    required double productPrice,
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
              child: 0.width,
              // child: state.planoGramsList[index].planogramproducts?[subIndex].totalSale == 0
              //     ? 0.width
              //     : Text(
              //   "${state.planoGramsList[index].planogramproducts?[subIndex].totalSale} ${AppLocalizations.of(context)!.discount}",
              //   style: AppStyles.rkRegularTextStyle(
              //       size: AppConstants.font_10,
              //       color: AppColors.saleRedColor,
              //       fontWeight: FontWeight.w600),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
            ),
            5.height,
            Center(
              child: CommonProductButtonWidget(
                title:
                "${AppLocalizations
                    .of(context)!.currency}${productPrice.toStringAsFixed(
                    AppConstants.amountFrLength) == "0.00" ? '0' : productPrice
                    .toStringAsFixed(
                    AppConstants.amountFrLength)}",
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
      {required BuildContext context, required String productId , String productStock ='0',
      bool? isBarcode,
      }) async {
    context.read<SupplierProductsBloc>().add(
        SupplierProductsEvent.getProductDetailsEvent(
          isBarcode: isBarcode ?? false,
            context: context, productId: productId));
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
        print('productStock____${productStock}');
        return BlocProvider.value(
          value: context.read<SupplierProductsBloc>(),
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
            //  shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<SupplierProductsBloc>(),
                  child:
                  BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
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
                              :state.productDetails.isEmpty
                              ? Center(
                            child: Text(
                                AppLocalizations.of(context)!.no_product,
                                style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.normalFont,
                                  color: AppColors.redColor,
                                  fontWeight: FontWeight.w500,
                                )),
                          )
                              : CommonProductDetailsWidget(
                            isLoading: state.isLoading,
                            addToOrderTap: state.isLoading
                                ? (){}
                                : () {
                              context
                                  .read<SupplierProductsBloc>()
                                  .add(SupplierProductsEvent
                                  .addToCartProductEvent(
                                  context: context1,
                                  productId: productId
                              ));
                            },
                            imageOnTap: (){
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: getScreenHeight(context) - MediaQuery.of(context).padding.top ,
                                        width: getScreenWidth(context),
                                        child: PhotoView(
                                          imageProvider: CachedNetworkImageProvider(
                                            '${AppUrls.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.close,
                                            color: Colors.white,
                                          )),
                                    ],
                                  );
                                },);
                            },
                              context: context,
                              // contentKey: _contentKey,
                                  productImageIndex: state.imageIndex,
                              onPageChanged: (index, p1) {
                                context.read<SupplierProductsBloc>().add(
                                    SupplierProductsEvent
                                        .updateImageIndexEvent(
                                        index: index));
                              },
                              productImages: [
                                state.productDetails.first.mainImage ?? '',
                                ...state.productDetails.first.images?.map(
                                        (image) => image.imageUrl ?? '') ??
                                    []
                              ],
                              productPerUnit: state.productDetails.first
                                  .numberOfUnit ?? 0,
                              productUnitPrice: state.productStockList[state
                                  .productStockUpdateIndex].totalPrice,
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
                              productPrice:
                              state.productStockList[state
                                  .productStockUpdateIndex].totalPrice *
                                  state
                                      .productStockList[
                                  state.productStockUpdateIndex]
                                      .quantity *
                                  (state.productDetails.first.numberOfUnit ??
                                      0),
                              productScaleType:
                              state.productDetails.first.scales?.scaleType ??
                                  '',
                              productWeight: state.productDetails.first
                                  .itemsWeight?.toDouble() ?? 0.0,
                              productStock: state.productStockList[state.productStockUpdateIndex].stock != 0 ?
                              int.parse(state.productStockList[state.productStockUpdateIndex].stock.toString()):
                              int.parse(productStock.toString() ?? '0'),
                              isRTL: context.rtl,
                              isSupplierAvailable: state.productSupplierList
                                  .isEmpty ? false : true,
                              scrollController: scrollController,
                              productQuantity: state.productStockList[state
                                  .productStockUpdateIndex].quantity,
                              onQuantityChanged: (quantity) {
                                context.read<SupplierProductsBloc>().add(
                                    SupplierProductsEvent
                                        .updateQuantityOfProduct(
                                        context: context1,
                                        quantity: quantity));
                              },
                              onQuantityIncreaseTap: () {
                                context.read<SupplierProductsBloc>().add(
                                    SupplierProductsEvent
                                        .increaseQuantityOfProduct(
                                        context: context1));
                              },
                              onQuantityDecreaseTap: () {
                                context.read<SupplierProductsBloc>().add(
                                    SupplierProductsEvent
                                        .decreaseQuantityOfProduct(
                                                context: context1));
                                  },
                                ),
                          bottomNavigationBar: state.isProductLoading
                              ? 0.height
                              :  Container(
                            height: 200,
                            padding: EdgeInsets.only(bottom:10,left: 10,right: 10),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context,i){return   CommonProductItemWidget(
                                productStock: '1',
                                height: 10,
                                width: 140,
                                productImage:
                                '',
                                productName:
                                '',
                                totalSaleCount:
                                0,
                                price:
                                0.0,
                                onButtonTap: () {
                                  print("tap 2: supplier product scren");
                                },
                              );},itemCount: 3,),
                          ),
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
      value: context.read<SupplierProductsBloc>(),
      child: BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
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
                          context.read<SupplierProductsBloc>().add(
                              SupplierProductsEvent
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
                              context.read<SupplierProductsBloc>().add(
                                  SupplierProductsEvent
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
                                                    '${AppLocalizations.of(context)!.price}:${AppLocalizations
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
                                                    '${AppLocalizations.of(context)!.price}:${AppLocalizations
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
                      '${AppLocalizations.of(context)!.out_of_stock1}',
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
                                  context.read<SupplierProductsBloc>().add(
                                      SupplierProductsEvent
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
                                                                SupplierProductsBloc>()
                                                            .add(SupplierProductsEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    context:
                                                                        context,
                                                                    supplierSaleIndex:
                                                                        -2));
                                                        context
                                                            .read<
                                                                SupplierProductsBloc>()
                                                            .add(SupplierProductsEvent
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
                                                              '${AppLocalizations.of(context)!.price} : ${AppLocalizations
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
                                                                SupplierProductsBloc>()
                                                            .add(SupplierProductsEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    context:
                                                                        context,
                                                                    supplierSaleIndex:
                                                                        subIndex));
                                                        context
                                                            .read<
                                                                SupplierProductsBloc>()
                                                            .add(SupplierProductsEvent
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
                                                              '${AppLocalizations.of(context)!.price}  :${AppLocalizations
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
            buttonTitle: "${AppLocalizations.of(context)!.ok}"));
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
