
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/planogram_product/planogram_product_bloc.dart';
import 'package:food_stock/data/model/res_model/planogram_res_model/planogram_res_model.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/common_product_item_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:photo_view/photo_view.dart';
import '../../data/model/search_model/search_model.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_list_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_search_widget.dart';
import '../widget/confetti.dart';
import '../widget/product_details_shimmer_widget.dart';

class PlanogramProductRoute {
  static Widget get route => const PlanogramProductScreen();
}

class PlanogramProductScreen extends StatelessWidget {
  const PlanogramProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => PlanogramProductBloc()
        ..add(PlanogramProductEvent.getPlanogramProductsEvent(
            planogram: args?[AppStrings.planogramProductsParamString] ??
                PlanogramDatum(),context: context)),
      child: PlanogramProductScreenWidget(),
    );
  }
}

class PlanogramProductScreenWidget extends StatelessWidget {
  const PlanogramProductScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PlanogramProductBloc bloc = context.read<PlanogramProductBloc>();
    return BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
          FloatingActionButtonLocation.endContained,
          floatingActionButton:  !state.isGuestUser?FloatingActionButton(
            elevation: 0,
            child: Stack(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 1),
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
                    ),
                  ),
                ),
                state.cartCount!=0?Positioned(
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
                              color: AppColors.whiteColor, width: 1),
                        ),
                        child: Text(
                        '${state.cartCount}',
                          style: AppStyles.rkRegularTextStyle(
                              size: 10, color: AppColors.whiteColor),
                        ),
                      ),
                    ],
                  ),
                ):0.width,
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
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name,
                  arguments: {AppStrings.isBasketScreenString: 'true'});
            },
          ):0.width,
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title:state.planogramName.toCapitalized(),
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: GestureDetector(
                  onTap: (){
                    context.read<PlanogramProductBloc>().add(PlanogramProductEvent.getGridListView());
                  },
                  child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
            ),
          ),
          body: FocusDetector(
            onFocusGained: (){
              bloc.add(PlanogramProductEvent.getCartCountEvent());
            },
            child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                    children: [
                      100.height,
                      Expanded(
                          child: state.isGridView ? GridView.builder(
                            itemCount: state.planogramProductList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: MediaQuery.of(context).size.width > 370 ?AppConstants
                                    .productGridAspectRatio: AppConstants
                                    .productGridAspectRatio1
                            ),
                            itemBuilder: (context, index) => buildPlanoGramProductItem(
                              isPesach: state.planogramProductList[index].isPesach,
                              lowStock: state.planogramProductList[index].lowStock.toString(),
                              isGuestUser: state.isGuestUser,
                                productImage: state.planogramProductList[index].mainImage ?? '',
                                productName:
                                state.planogramProductList[index].productName ?? '',
                                productPrice:
                                state.planogramProductList[index].productPrice ?? 0.0,
                                totalSale: state.planogramProductList[index].totalSale ?? 0,
                                onPressed: () {
                                if(!state.isGuestUser){
                                  showProductDetails(
                                      context: context,
                                      productId: state.planogramProductList[index].id ?? '',
                                      productStock: state.planogramProductList[index].productStock.toString() ?? '0',
                                    productListIndex: 1
                                  );
                                }
                                else{
                                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                }
                                },
                                productStock :state.planogramProductList[index].productStock ?? 0,
                                context: context,
                                index: index,
                                isRTL: context.rtl),
                          ) : ListView.builder(
                            itemCount: state.planogramProductList.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_5),
                            itemBuilder: (context, index) => CommonProductListWidget(
                                isPesach: state.planogramProductList[index].isPesach,
                              lowStock: state.planogramProductList[index].lowStock.toString(),
                              isGuestUser: state.isGuestUser,
                                numberOfUnits: state.planogramProductList[index].numberOfUnit.toString(),
                                productStock: state.planogramProductList[index].productStock.toString(),
                                productImage: state.planogramProductList[index]
                                    .mainImage ??
                                    '',
                                productName: state.planogramProductList[index]
                                    .productName ??
                                    '',
                                totalSaleCount: state
                                    .planogramProductList[index]
                                    .totalSale ??
                                    0,
                                price: state.planogramProductList[index]
                                    .productPrice ??
                                    0.0,
                                onButtonTap: () {
                                if(!state.isGuestUser){
                                  showProductDetails(
                                    context: context,
                                    productId: state
                                        .planogramProductList[index]
                                        .id ??
                                        '',
                                    productStock: state.planogramProductList[index].productStock.toString(),
                                    productListIndex: 1

                                  );
                                }
                                else{
                                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                }

                                }),
                          ),
                      )
                    ],
                    ),
                    CommonSearchWidget(
                      onCloseTap: () {
                        bloc.add(PlanogramProductEvent.changeCategoryExpansion(isOpened: false));
                      },
                      isFilterTap: true,
                      isCategoryExpand: state.isCategoryExpand,
                      isSearching: state.isSearching,
                      onFilterTap: () {
                        bloc.add(PlanogramProductEvent.changeCategoryExpansion());
                      },
                      onSearchTap: () {
                        if(state.searchController.text != ''){
                          bloc.add(PlanogramProductEvent.changeCategoryExpansion(isOpened: true));
                        }
                      },
                      onSearch: (String search) {
                        if (search.length > 1) {
                          bloc.add(PlanogramProductEvent.changeCategoryExpansion(isOpened: true));
                          bloc.add(
                              PlanogramProductEvent.globalSearchEvent(context: context));
                        }
                      },
                      onSearchSubmit: (String search) {
                     //   bloc.add(PlanogramProductEvent.globalSearchEvent(context: context));
                        Navigator.pushNamed(
                            context,
                            RouteDefine.supplierProductsScreen.name,
                            arguments: {
                              AppStrings.searchString: state.search,
                              AppStrings.searchType : SearchTypes.product.toString()
                            });
                      },
                      onOutSideTap: () {
                        bloc.add(PlanogramProductEvent.changeCategoryExpansion(
                            isOpened: false));
                      },
                      onSearchItemTap: () {
                        bloc.add(PlanogramProductEvent.changeCategoryExpansion());
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
                              lowStock: state.searchList[index].lowStock.toString(),
                            isGuestUser: state.isGuestUser,
                              numberOfUnits:state.searchList[index].numberOfUnits,
                              priceOfBox: state.searchList[index].priceOfBox,
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
                                    bloc.add(PlanogramProductEvent
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
                                    bloc.add(PlanogramProductEvent
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
                                        SearchTypes.product && !state.isGuestUser) {
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
                                    bloc.add(PlanogramProductEvent
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
                                    PlanogramProductEvent
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
                          print("tap 5");
                          if(!state.isGuestUser){
                            showProductDetails(
                                context: context,
                                // productStock: '1',
                                productId: scanResult,
                                isBarcode: true,
                                productStock: '1',
                              productListIndex: 0
                            );
                          }
                          else{
                            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                          }

                        }
                      },
                    ),
                  ],
                )
              
            ),
          ),
        );
      },
    );
  }

  Widget buildPlanoGramProductItem(
      {required BuildContext context,
      required int index,
      required String productImage,
      required String productName,
      required double productPrice,
      required int totalSale,
      required void Function() onPressed,
      required bool isRTL, required int productStock,
      required bool isGuestUser,
        required String lowStock,
        required bool? isPesach
      }) {
    return CommonProductItemWidget(
      isPesach: isPesach,
      lowStock: lowStock,
      isGuestUser: isGuestUser,
        imageHeight: getScreenHeight(context) >= 1000 ? getScreenHeight(context) * 0.17 : 70,
        imageWidth: getScreenWidth(context) >= 700 ? 100 : 70,
        productImage: productImage,
        productName: productName,
        totalSaleCount: totalSale,
        price: productPrice,
        productStock : productStock.toString(),
        onButtonTap: onPressed);
  }

  void showProductDetails({
    required BuildContext context,
    required String productId,
    bool? isBarcode,
    String productStock  = '0',
    bool isRelated = false,
    int productListIndex = -1,

  }) async {
    context.read<PlanogramProductBloc>().add(PlanogramProductEvent.getProductDetailsEvent(
      context: context,
      productId: productId,
      isBarcode: isBarcode ?? false,
      productListIndex: productListIndex
      //planoGramIndex: planoGramIndex
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
              value: context.read<PlanogramProductBloc>(),
              child: BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
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
                              nmMashlim: state.productDetails.first.nmMashlim??'',
                              isPesach: state.productDetails.first.isPesach??false,
                              lowStock: state.productDetails.first.supplierSales?.first.lowStock.toString() ?? '',
                              qrCode:state.productDetails.first.qrcode ?? '' ,
                              addToOrderTap: () {
                                context.read<PlanogramProductBloc>().add(
                                    PlanogramProductEvent.addToCartProductEvent(
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
                                                debugPrint('onVerticalDragStart');
                                            },
                                            onVerticalDragUpdate: (dragDetails) {
                                                debugPrint('onVerticalDragUpdate');
                                            },
                                            onVerticalDragEnd: (endDetails) {
                                               debugPrint('onVerticalDragEnd');
                                              Navigator.pop(dialogContext);
                                            },
                                            child: PhotoView(
                                              imageProvider: NetworkImage(
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
                                context.read<PlanogramProductBloc>().add(
                                    PlanogramProductEvent.updateImageIndexEvent(
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
                              productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString()??'0'),
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
                                  .productStockList[state.productListIndex][
                              state.productStockUpdateIndex]
                                  .totalPrice *
                                  state
                                      .productStockList[state.productListIndex][
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
                              productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                              isRTL: context.rtl,
                              isSupplierAvailable:
                              state.productSupplierList.isEmpty
                                  ? false
                                  : true,
                              scrollController: scrollController,
                              productQuantity:  state
                                  .productStockList[state.productListIndex][
                              state.productStockUpdateIndex]
                                  .quantity,
                              onQuantityChanged: (quantity) {
                                context.read<PlanogramProductBloc>().add(
                                    PlanogramProductEvent.updateQuantityOfProduct(
                                        context: context1,
                                        quantity: quantity));
                              },
                              onQuantityIncreaseTap: () {
                                context.read<PlanogramProductBloc>().add(
                                    PlanogramProductEvent.increaseQuantityOfProduct(
                                        context: context1));
                              },
                              onQuantityDecreaseTap: () {
                                if(state
                                    .productStockList[state.productListIndex][
                                state.productStockUpdateIndex]
                                    .quantity > 1){
                                  context.read<PlanogramProductBloc>().add(
                                      PlanogramProductEvent.decreaseQuantityOfProduct(
                                          context: context1));
                                }
                              },
                            ),
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
            padding: const EdgeInsets.only(left: 8.0, right: 8.0,top: 10),
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
          padding: EdgeInsets.only(left: 10,right: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2,i){
              return CommonProductItemWidget(
                isPesach: relatedProductList.elementAt(i).isPesach,
                lowStock: relatedProductList.elementAt(i).lowStock.toString(),
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
                      productListIndex: 2,
                      productStock: (relatedProductList[i].productStock.toString())
                  );
                },
              );},itemCount: relatedProductList.length,),
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
    bool? isLastItem, required String productStock,
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
            height: !isGuestUser ?  lowStock.isNotEmpty || (productStock) != '0' ? 120 :  searchType == SearchTypes.category || searchType == SearchTypes.subCategory || searchType == SearchTypes.company || searchType == SearchTypes.supplier ?  80 :110 : 80,
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
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: !isGuestUser ? searchImage.isNotEmpty ?  ClipRRect(
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
                    fit: BoxFit.cover, height: 80,
                    width: 70,) : Image.asset(AppImagePath.imageNotAvailable5,
                    fit: BoxFit.cover, height: 80,
                    width: 70,),
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
}
