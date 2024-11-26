import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/pesach_products/pesach_products_bloc.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../ui/widget/supplier_products_screen_shimmer_widget.dart';
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
import '../widget/common_product_sale_item_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/confetti.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';

class PesachProductsRoute {
  static Widget get route => const PesachProductsScreen();
}

class PesachProductsScreen extends StatelessWidget {
  const PesachProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => PesachProductsBloc()
        ..add(PesachProductsEvent.getSupplierProductsListEvent(context: context, searchType: args?[AppStrings.searchType] ?? ''))
        ..add(PesachProductsEvent.userApproveEvent(context: context)),
      child: const PesachProductsScreenWidget(),
    );
  }
}

class PesachProductsScreenWidget extends StatelessWidget {
  const PesachProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PesachProductsBloc bloc = context.read<PesachProductsBloc>();
    return BlocListener<PesachProductsBloc, PesachProductsState>(
      listener: (context, state) {},
      child: BlocBuilder<PesachProductsBloc, PesachProductsState>(
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
                  )
                : 0.width,
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.pesach_products,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                trailingWidget: GestureDetector(
                    onTap: () {
                      context.read<PesachProductsBloc>().add(const PesachProductsEvent.getGridListView());
                    },
                    child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
              ),
            ),
            body: FocusDetector(
              onFocusGained: () {
                bloc.add(const PesachProductsEvent.getCartCountEvent());
                bloc.add(PesachProductsEvent.getPermissionList(context: context));
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
                            header: const RefreshWidget(),
                            footer: CustomFooter(
                              builder: (context, mode) => state.isGridView ? SupplierProductsScreenShimmerWidget() : StoreCategoryScreenSubcategoryShimmerWidget(),
                            ),
                            enablePullUp: !state.isBottomOfProducts,
                            onRefresh: () {
                              context.read<PesachProductsBloc>().add(PesachProductsEvent.refreshListEvent(context: context));
                            },
                            onLoading: () {
                              context.read<PesachProductsBloc>().add(PesachProductsEvent.getSupplierProductsListEvent(context: context, searchType: state.searchType));
                            },
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
                                                AppLocalizations.of(context)!.no_product,
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
                                                        isSale: state.productList[index].sale?.isSale,
                                                        isGuestUser: state.isGuestUser,
                                                        height: AppConstants.salesProductItemHeight,
                                                        width: 140,
                                                        productName: state.productList[index].productName ?? '',
                                                        saleImage: state.productList[index].mainImage ?? '',
                                                        title: state.productList[index].name,
                                                        description: parse(state.productList[index].sale?.saleDescription ?? '').body?.text ?? '',
                                                        discountedPrice: double.parse(state.productList[index].sale!.salePrice.toString()),
                                                        originalPrice: state.productList[index].productPrice ?? 0,
                                                        productStock: state.productList[index].productStock.toString(),
                                                        lowStock: state.productList[index].lowStock ?? '',
                                                        isPesach: state.productList[index].isPesach,
                                                        onButtonTap: () {
                                                          if (!state.isGuestUser) {
                                                            showProductDetails(maxQty: int.parse(state.productList[index].sale?.saleMaxQuantity.toString() ?? '0 '), productListIndex: 1, context: context, productId: state.productList[index].id ?? '', productStock: state.productList[index].productStock.toString(), isSaleOn: state.isSaleOn);
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
                                                    isFromSale: state.productList[index].sale?.isSale,
                                                    salesDesc: state.productList[index].sale?.saleDescription,
                                                    isPesach: state.productList[index].isPesach,
                                                    lowStock: state.productList[index].lowStock.toString(),
                                                    isGuestUser: state.isGuestUser,
                                                    numberOfUnits: state.productList[index].numberOfUnit ?? '0',
                                                    productStock: state.productList[index].productStock.toString(),
                                                    productImage: state.productList[index].mainImage ?? '',
                                                    productName: state.productList[index].productName ?? '',
                                                    price: double.parse(state.productList[index].productPrice.toString()),
                                                    onButtonTap: () {
                                                      if (!state.isGuestUser) {
                                                        showProductDetails(productListIndex: 1, context: context, productId: state.productList[index].id ?? '', productStock: state.productList[index].productStock.toString(), isSaleOn: state.isSaleOn);
                                                      } else {
                                                        Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                      }
                                                    },
                                                    discountedPrice: double.parse(state.productList[index].sale?.salePrice ?? '0'),
                                                    context: context,
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
                        bloc.add(const PesachProductsEvent.changeCategoryExpansion(isOpened: false));
                      },
                      isFilterTap: true,
                      isCategoryExpand: state.isCategoryExpand,
                      isSearching: state.isSearching,
                      onFilterTap: () {
                        bloc.add(const PesachProductsEvent.changeCategoryExpansion());
                      },
                      onSearchTap: () {
                        if (state.searchController.text != '') {
                          bloc.add(const PesachProductsEvent.changeCategoryExpansion(isOpened: true));
                        }
                      },
                      onSearch: (String search) {
                        if (search.length > 1) {
                          bloc.add(const PesachProductsEvent.changeCategoryExpansion(isOpened: true));
                          bloc.add(PesachProductsEvent.globalSearchEvent(context: context));
                        }
                      },
                      onSearchSubmit: (String search) {
                        Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()});
                      },
                      onOutSideTap: () {
                        state.searchController.clear();
                        bloc.add(const PesachProductsEvent.changeCategoryExpansion(isOpened: false));
                      },
                      onSearchItemTap: () {
                        bloc.add(const PesachProductsEvent.changeCategoryExpansion());
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
                                    isShowSearchLabel: index == 0
                                        ? true
                                        : state.searchList[index].searchType != state.searchList[index - 1].searchType
                                            ? true
                                            : false,
                                    onSeeAllTap: () async {
                                      debugPrint("searchType: ${state.searchList[index].searchType}");
                                      if (state.searchList[index].searchType == SearchTypes.category) {
                                        dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.productCategoryScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.reqSearchString: state.search, AppStrings.searchResultString: state.searchList});
                                        if (searchResult != null) {
                                          bloc.add(PesachProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                        }
                                      } else if (state.searchList[index].searchType == SearchTypes.subCategory) {
                                        dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.categoryIdString: state.searchList[index].categoryId, AppStrings.categoryNameString: state.searchList[index].categoryName, AppStrings.searchString: state.search, AppStrings.searchResultString: state.searchList});
                                        if (searchResult != null) {
                                          bloc.add(PesachProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
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
                                        debugPrint("tap 4");
                                        if (!state.isGuestUser) {
                                          showProductDetails(productListIndex: 0, context: context, productStock: state.searchList[index].productStock.toString(), productId: state.searchList[index].searchId, isBarcode: true, isSaleOn: state.isSaleOn);
                                        } else {
                                          Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                        }
                                      } else if (state.searchList[index].searchType == SearchTypes.category) {
                                        dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.categoryIdString: state.searchList[index].searchId, AppStrings.categoryNameString: state.searchList[index].name, AppStrings.searchString: state.searchController.text, AppStrings.searchResultString: state.searchList});
                                        if (searchResult != null) {
                                          bloc.add(PesachProductsEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                        }
                                      } else {
                                        state.searchList[index].searchType == SearchTypes.company ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {AppStrings.companyIdString: state.searchList[index].searchId}) : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.supplierIdString: state.searchList[index].searchId});
                                      }
                                      bloc.add(const PesachProductsEvent.changeCategoryExpansion());
                                    });
                              },
                            ),
                      onScanTap: () async {
                        String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
                        if (scanResult != '-1') {
                          // -1 result for cancel scanning

                          if (!state.isGuestUser) {
                            showProductDetails(context: context, productListIndex: 0, productId: scanResult, isBarcode: true, productStock: '1', isSaleOn: state.isSaleOn);
                          } else {
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
                      // debugPrint('sale list image error : $error');
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

  void showProductDetails({required BuildContext context, required String productId, required int productListIndex, int maxQty = 0, bool? isBarcode, String productStock = '0', required bool isSaleOn}) async {
    context.read<PesachProductsBloc>().add(PesachProductsEvent.getProductDetailsEvent(context: context, productId: productId, productListIndex: productListIndex, isBarcode: isBarcode ?? false));
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
            minChildSize: productStock == '0' || productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
            initialChildSize: productStock == '0' || productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
            builder: (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                value: context.read<PesachProductsBloc>(),
                child: BlocBuilder<PesachProductsBloc, PesachProductsState>(
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
                                          context.read<PesachProductsBloc>().add(PesachProductsEvent.addToCartProductEvent(context: context1, productId: productId));
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
                                                          debugPrint('onVerticalDragStart');
                                                        },
                                                        onVerticalDragUpdate: (dragDetails) {
                                                          debugPrint('onVerticalDragUpdate');
                                                        },
                                                        onVerticalDragEnd: (endDetails) {
                                                          debugPrint('onVerticalDragEnd');
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
                                        productImages: [state.productDetails.first.mainImage ?? ''],
                                        productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'),
                                        productPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                        productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                        scrollController: scrollController,
                                        productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                        onQuantityChanged: (quantity) {
                                          context.read<PesachProductsBloc>().add(PesachProductsEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                        },
                                        onQuantityIncreaseTap: () {
                                          context.read<PesachProductsBloc>().add(PesachProductsEvent.increaseQuantityOfProduct(context: context1));
                                        },
                                        onQuantityDecreaseTap: () {
                                          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                            context.read<PesachProductsBloc>().add(PesachProductsEvent.decreaseQuantityOfProduct(context: context1));
                                          }
                                        },
                                        onCloseTap: (){Navigator.pop(context);},
                                      ),
                                      state.relatedProductList.isEmpty ? 0.width : relatedProductWidget(context1, state.relatedProductList, context, isSaleOn),
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
          height:  getItemHeight(context, isSaleOn),
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
