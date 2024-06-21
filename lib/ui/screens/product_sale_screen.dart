
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/product_sale/product_sale_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/widget/common_product_sale_item_widget.dart';
import 'package:food_stock/ui/widget/common_sale_description_dialog.dart';
import 'package:food_stock/ui/widget/common_sale_listview.dart';
import 'package:food_stock/ui/widget/product_sale_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/store_category_screen_subcategory_shimmer_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class   ProductSaleRoute {
  static Widget get route => ProductSaleScreen();
}

class ProductSaleScreen extends StatelessWidget {
  const ProductSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint('product sale args = $args');
    debugPrint('saleProductId = ${args?[AppStrings.companyIdString] ?? ''}');
    return BlocProvider(
      create: (context) => ProductSaleBloc()
        ..add(ProductSaleEvent.setSearchEvent(search: args?[AppStrings.searchString] ?? ''))
        ..add(ProductSaleEvent.getProductSalesListEvent(context: context))
      ..add(ProductSaleEvent.userApproveEvent(context: context)),
      child: ProductSaleScreenWidget(saleProductId: args?[AppStrings.companyIdString] ?? ''),
    );
  }
}

class ProductSaleScreenWidget extends StatelessWidget {
  late final String saleProductId;
   ProductSaleScreenWidget({super.key,this.saleProductId = ''});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductSaleBloc, ProductSaleState>(
      listener: (context, state) {},
      child: BlocBuilder<ProductSaleBloc, ProductSaleState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.sales,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
                trailingWidget: GestureDetector(
                    onTap: () {
                      context.read<ProductSaleBloc>().add(ProductSaleEvent.getGridListView());
                    },
                    child: Icon(state.isGridView ? Icons.list : Icons.grid_view)),
              ),
            ),
            body: FocusDetector(
              onFocusGained: (){
                if(saleProductId != ''){
                  showProductDetails(
                      context: context,
                      productId: saleProductId,
                    productStock: '1',
                    isBarcode: true,
                    productListIndex: 0
                  );
                }
              },
              child: SafeArea(
                child:
                    SmartRefresher(
                  enablePullDown: true,
                  controller: state.refreshController,
                  header: RefreshWidget(),
                  footer: CustomFooter(
                    builder: (context, mode) => ProductSaleScreenShimmerWidget(),
                  ),
                  enablePullUp: !state.isBottomOfProducts,
                  onRefresh: () {
                    context.read<ProductSaleBloc>().add(ProductSaleEvent.refreshListEvent(context: context));
                  },
                  onLoading: () {
                    context.read<ProductSaleBloc>().add(ProductSaleEvent.getProductSalesListEvent(context: context));
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        state.isShimmering
                            ? state.isGridView
                                ? ProductSaleScreenShimmerWidget()
                                : StoreCategoryScreenSubcategoryShimmerWidget()
                            : state.productSalesList.length == 0
                                ? Container(
                                    height: getScreenHeight(context) - 80,
                                    width: getScreenWidth(context),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${AppLocalizations.of(context)!.currently_products_are_not_on_sale}',
                                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor),
                                    ),
                                  )
                                : state.isGridView
                                    ? GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: state.productSalesList.length,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.48),
                                        //getChildAspectRatio(context)),
                                        itemBuilder: (context, index) {
                                          return buildProductSaleListItem(
                                            productStock: state.productSalesList[index].productStock.toString(),
                                            isPesach: state.productSalesList[index].isPesach ?? false,
                                            lowStock: state.productSalesList[index].lowStock ?? '',
                                            originalPrice:state.productSalesList[index].productPrice ?? 0.0,
                                            isGuestUser: state.isGuestUser,
                                            index: index,
                                            context: context,
                                            saleImage: state.productSalesList[index].mainImage ?? '',
                                            title: state.productSalesList[index].name,
                                            productName: state.productSalesList[index].productName ?? '',
                                            description: parse(state.productSalesList[index].sale?.saleDescription ?? '').body?.text ?? '',

                                            discountedPrice: double.parse(state.productSalesList[index].sale?.salePrice ?? ''),
                                            onButtonTap: () {
                                              if (!state.isGuestUser) {
                                                showProductDetails(
                                                  context: context,
                                                  productId: state.productSalesList[index].id ?? '',
                                                   productStock: state.productSalesList[index].toString(),
                                                  productListIndex: 1
                                                );
                                              } else {
                                                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                              }
                                            },
                                          );
                                        },
                                      )
                                    : ListView.builder(
                                        itemCount: state.productSalesList.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                                        itemBuilder: (context, index) => CommonSaleListView(
                                            context: context,
                                            discountedPrice: double.parse(state.productSalesList[index].sale?.salePrice ?? ''),
                                            isFromSale: state.productSalesList[index].sale?.isSale?? false,
                                            salesDesc: state.productSalesList[index].sale?.saleDescription ?? '',
                                            isGuestUser: state.isGuestUser,
                                            isPesach: state.productSalesList[index].isPesach,
                                            numberOfUnits: state.productSalesList[index].numberOfUnit.toString(),
                                            lowStock: state.productSalesList[index].lowStock.toString(),
                                            productStock: state.productSalesList[index].productStock.toString(),
                                            productImage: state.productSalesList[index].mainImage ?? '' ,
                                            productName: state.productSalesList[index].productName ?? '' ,
                                            price: double.parse(state.productSalesList[index].productPrice.toString()),
                                            onButtonTap: () {
                                              showProductDetails(
                                                context: context,
                                                productId: state.productSalesList[index].id ??'',
                                                productStock: state.productSalesList[index].toString(),
                                                productListIndex: 1
                                              );
                                            }),
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
    );
  }

  Widget buildProductSaleListItem({
    required int index,
    required BuildContext context,
    required String saleImage,
    required String title,
    required String description,

    required String productName,
    required double discountedPrice,
    required void Function() onButtonTap,
    required bool isGuestUser,
    required double originalPrice,
    required bool isPesach,
    required String lowStock,
    required String productStock
  }) {
    return CommonProductSaleItemWidget(
        isSale: true,
      height: AppConstants.salesProductItemHeight,
      width: 140,
      isGuestUser: isGuestUser,
      saleImage: saleImage,
      title: title,
      description: description,
      onButtonTap: onButtonTap,
      productName: productName,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      isPesach: isPesach,
      lowStock: lowStock,
      productStock : productStock
    );
  }


  void showProductDetails({
    required BuildContext context,
    required String productId,
    String productStock = '0',
    bool isBarcode = false,
    required int productListIndex
  }) async {
    context.read<ProductSaleBloc>().add(ProductSaleEvent.getProductDetailsEvent(context: context, productId: productId,isBarcode: isBarcode,productListIndex: productListIndex));
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      //  showDragHandle: true,
      //  useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<ProductSaleBloc>(),
          child: BlocBuilder<ProductSaleBloc, ProductSaleState>(
            builder: (blocContext, state) {
              return SafeArea(
                bottom: false,
                child: DraggableScrollableSheet(
                  expand: true,
                  maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                  minChildSize: productStock == '0' ||productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                  initialChildSize: productStock == '0'||productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                  builder: (BuildContext context1, ScrollController scrollController) {
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
                          : SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: Column(
                                children: [
                                  CommonProductDetailsWidget(
                                    productDetails: state.productDetails,
                              /*      salePrice: double.parse(state.productDetails.first.sale.salePrice),
                                    maxQty: state.productDetails.first.sale.saleMaxQuantity,
                                    endDate: state.productDetails.first.sale.saleUntilDate,
                                    startDate: state.productDetails.first.sale.saleFromDate,
                                    isSaleOn: state.productDetails.first.sale.isSale,*/
                                    isSubUserAddToBasket: state.isSubUserAddToBasket,
                                    bottleTax: state.bottleDeposit,
                                    totalBottleDeposit: (state.bottleDeposit * state.productDetails.first.numberOfUnit!.toDouble() * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                    isBottle: state.productDetails.first.isBottle ,
                                    /*nmMashlim: state.productDetails.first.nmMashlim ,
                                    isPesach: state.productDetails.first.isPesach ,
                                    lowStock: state.productDetails.first.supplierSales.first.lowStock.toString() ?? '',
                                    qrCode: state.productDetails.first.qrcode ,*/
                                    isLoading: state.isLoading,

                                    addToOrderTap: () {
                                      context.read<ProductSaleBloc>().add(ProductSaleEvent.addToCartProductEvent(context: context1,productId: productId));
                                    },
                                    imageOnTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SafeArea(
                                            bottom: false,
                                            child: Stack(
                                              children: [
                                                Container(
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
                                                      Navigator.pop(context);
                                                    },
                                                    child: PhotoView(
                                                      imageProvider: NetworkImage(
                                                        '${AppUrls.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
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
                                      context.read<ProductSaleBloc>().add(ProductSaleEvent.updateImageIndexEvent(index: index));
                                    },
                                    productUnitPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,

                                    productImages: [state.productDetails.first.mainImage , ...state.productDetails.first.images.map((image) => image.imageUrl ?? '') ?? []],
                                   /* productPerUnit: state.productDetails.first.numberOfUnit ,
                                    productName: state.productDetails.first.productName,
                                    productSaleDescription: parse(state
                                        .productDetails
                                        .first
                                        .sale.saleDescription ??
                                        '')
                                        .body
                                        ?.text ??
                                        '',*/
                                    productPrice:state.productDetails.first.sale.isSale?
                                    double.parse(state.productDetails.first.sale.salePrice) * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit)
                                        :
                                    state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 0),
                                  //  productWeight: state.productDetails.first.itemsWeight.toDouble() ?? 0.0,
                                    productStock: state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString(),
                                    isRTL: context.rtl,
                                  //  isSupplierAvailable: state.productSupplierList.isEmpty ? false : true,
                                    scrollController: scrollController,
                                    productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                    onQuantityChanged: (quantity) {
                                      context.read<ProductSaleBloc>().add(ProductSaleEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                    },
                                    onQuantityIncreaseTap: () {
                                      context.read<ProductSaleBloc>().add(ProductSaleEvent.increaseQuantityOfProduct(context: context1));
                                    },
                                    onQuantityDecreaseTap: () {
                                      if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                        context.read<ProductSaleBloc>().add(ProductSaleEvent.decreaseQuantityOfProduct(context: context1));
                                      }
                                    },
                                  ),
                                  state.relatedProductList.isEmpty ? 0.width : relatedProductWidget(context1, state.relatedProductList, context)
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

  Widget relatedProductWidget(BuildContext prevContext, List<RelatedProductDatum> relatedProductList, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                  Navigator.of(prevContext).pop();
                  showProductDetails(context: context, productId: relatedProductList[i].id,
                  productStock:  relatedProductList.elementAt(i)
                      .productStock.toString(),
                    productListIndex: 2
                  );
                },);
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
            buttonTitle: "${AppLocalizations.of(context)!.ok}"));
  }
}
