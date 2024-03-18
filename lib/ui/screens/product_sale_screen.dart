
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/product_sale/product_sale_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/widget/common_product_sale_item_widget.dart';
import 'package:food_stock/ui/widget/common_sale_description_dialog.dart';
import 'package:food_stock/ui/widget/product_sale_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_product_item_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class ProductSaleRoute {
  static Widget get route => ProductSaleScreen();
}

class ProductSaleScreen extends StatelessWidget {
  const ProductSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint('product sale args = $args');
    return BlocProvider(
      create: (context) => ProductSaleBloc()
        ..add(ProductSaleEvent.setSearchEvent(
            search: args?[AppStrings.searchString] ?? ''))
        ..add(ProductSaleEvent.getProductSalesListEvent(context: context)),
      child: ProductSaleScreenWidget(),
    );
  }
}

class ProductSaleScreenWidget extends StatelessWidget {
  const ProductSaleScreenWidget({super.key});

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
              ),
            ),
            body: SafeArea(
              child:
                  //   NotificationListener<ScrollNotification>(
                  // child:
                  SmartRefresher(
                enablePullDown: true,
                controller: state.refreshController,
                header: RefreshWidget(),
                footer: CustomFooter(
                  builder: (context, mode) => ProductSaleScreenShimmerWidget(),
                ),
                enablePullUp: !state.isBottomOfProducts,
                onRefresh: () {
                  context
                      .read<ProductSaleBloc>()
                      .add(ProductSaleEvent.refreshListEvent(context: context));
                },
                onLoading: () {
                  context.read<ProductSaleBloc>().add(
                      ProductSaleEvent.getProductSalesListEvent(
                          context: context));
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      state.isShimmering
                          ? ProductSaleScreenShimmerWidget()
                          : state.productSalesList.length == 0
                              ? Container(
                                  height: getScreenHeight(context) - 80,
                                  width: getScreenWidth(context),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${AppLocalizations.of(context)!.currently_products_are_not_on_sale}',
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.smallFont,
                                        color: AppColors.textColor),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.productSalesList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppConstants.padding_10),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio:
                                              MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      370
                                                  ? AppConstants
                                                      .productGridAspectRatio1
                                                  : AppConstants
                                                      .productGridAspectRatio2),
                                  itemBuilder: (context, index) {
                                    return buildProductSaleListItem(
                                      isGuestUser: state.isGuestUser,
                                      index: index,
                                      context: context,
                                      saleImage: state.productSalesList[index]
                                              .mainImage ??
                                          '',
                                      title: state.productSalesList[index]
                                              .salesName ??
                                          '',
                                      productName: state.productSalesList[index]
                                              .productName ??
                                          '',
                                      description: parse(state
                                                      .productSalesList[index]
                                                      .salesDescription ??
                                                  '')
                                              .body
                                              ?.text ??
                                          '',
                                      salePercentage: double.parse(state
                                              .productSalesList[index]
                                              .discountPercentage ??
                                          '0.0'),
                                      discountedPrice: state
                                              .productSalesList[index]
                                              .discountedPrice ??
                                          0,
                                      onButtonTap: () {
                                        if (!state.isGuestUser) {
                                          showProductDetails(
                                            context: context,
                                            productId: state
                                                    .productSalesList[index]
                                                    .id ??
                                                '',
                                            startDate: state
                                                .productSalesList[index]
                                                .fromDate
                                                .toString(),
                                            endDate: state
                                                .productSalesList[index].endDate
                                                .toString(),
                                          );
                                        } else {
                                          Navigator.pushNamed(context,
                                              RouteDefine.connectScreen.name);
                                        }
                                      },
                                    );
                                  },
                                ),
                    ],
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
    required double salePercentage,
    required String productName,
    required double discountedPrice,
    required void Function() onButtonTap,
    required bool isGuestUser,
  }) {
    return CommonProductSaleItemWidget(
          imageHeight: getScreenHeight(context) >= 1000
      ? getScreenHeight(context) * 0.17
      : 70,
          isGuestUser: isGuestUser,
          saleImage: saleImage,
          title: title,
          description: description,
          salePercentage: salePercentage,
          onButtonTap: onButtonTap,
          productName: productName,
          discountedPrice: discountedPrice,
        );
  }

  void showProductDetails({
    required BuildContext context,
    required String productId,
    required String startDate,
    required String endDate,
    String productStock = '0',
  }) async {
    context.read<ProductSaleBloc>().add(ProductSaleEvent.getProductDetailsEvent(
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
        return BlocProvider.value(
          value: context.read<ProductSaleBloc>(),
          child: BlocBuilder<ProductSaleBloc, ProductSaleState>(
            builder: (blocContext, state) {
              return DraggableScrollableSheet(
                expand: true,
                maxChildSize: 1 -
                    (MediaQuery.of(context).viewPadding.top /
                        getScreenHeight(context)),
                minChildSize: productStock == '0'
                    ? 0.8
                    : 1 -
                        (MediaQuery.of(context).viewPadding.top /
                            getScreenHeight(context)),
                initialChildSize: productStock == '0'
                    ? 0.8
                    : 1 -
                        (MediaQuery.of(context).viewPadding.top /
                            getScreenHeight(context)),
                builder:
                    (BuildContext context1, ScrollController scrollController) {
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
                              lowStock: state.productDetails.first.supplierSales?.first.lowStock.toString() ?? '',
                              qrCode:
                              state.productDetails.first.qrcode ?? '',
                              isLoading: state.isLoading,
                              addToOrderTap: () {
                                context.read<ProductSaleBloc>().add(
                                    ProductSaleEvent.addToCartProductEvent(
                                        context: context1));
                              },
                              imageOnTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: getScreenHeight(context) -
                                              MediaQuery.of(context)
                                                  .padding
                                                  .top,
                                          width: getScreenWidth(context),
                                          child: GestureDetector(
                                            onVerticalDragStart:
                                                (dragDetails) {
                                                debugPrint('onVerticalDragStart');
                                            },
                                            onVerticalDragUpdate:
                                                (dragDetails) {
                                                debugPrint('onVerticalDragUpdate');
                                            },
                                            onVerticalDragEnd:
                                                (endDetails) {
                                               debugPrint('onVerticalDragEnd');
                                              Navigator.pop(context);
                                            },
                                            child: PhotoView(
                                              imageProvider:
                                              NetworkImage(
                                                '${AppUrls.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            )),
                                      ],
                                    );
                                  },
                                );
                              },
                              startDate: startDate,
                              endDate: endDate,
                              context: context,
                              productImageIndex: state.imageIndex,
                              onPageChanged: (index, p1) {
                                context.read<ProductSaleBloc>().add(
                                    ProductSaleEvent.updateImageIndexEvent(
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
                              productUnitPrice: state
                                  .productStockList[
                              state.productStockUpdateIndex]
                                  .totalPrice,
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
                                  .productStockList[
                              state.productStockUpdateIndex]
                                  .totalPrice *
                                  state
                                      .productStockList[
                                  state.productStockUpdateIndex]
                                      .quantity *
                                  (state.productDetails.first
                                      .numberOfUnit ??
                                      0),
                              productScaleType: state.productDetails.first
                                  .scales?.scaleType ??
                                  '',
                              productWeight: state
                                  .productDetails.first.itemsWeight
                                  ?.toDouble() ??
                                  0.0,
                              productStock: state
                                  .productStockList[
                              state.productStockUpdateIndex]
                                  .stock.toString(),
                              isRTL: context.rtl,
                              isSupplierAvailable:
                              state.productSupplierList.isEmpty
                                  ? false
                                  : true,
                              scrollController: scrollController,
                              productQuantity: state
                                  .productStockList[
                              state.productStockUpdateIndex]
                                  .quantity,
                              onQuantityChanged: (quantity) {
                                context.read<ProductSaleBloc>().add(
                                    ProductSaleEvent
                                        .updateQuantityOfProduct(
                                        context: context1,
                                        quantity: quantity));
                              },
                              onQuantityIncreaseTap: () {
                                context.read<ProductSaleBloc>().add(
                                    ProductSaleEvent
                                        .increaseQuantityOfProduct(
                                        context: context1));
                              },
                              onQuantityDecreaseTap: () {
                                if (state
                                    .productStockList[
                                state.productStockUpdateIndex]
                                    .quantity >
                                    1) {
                                  context.read<ProductSaleBloc>().add(
                                      ProductSaleEvent
                                          .decreaseQuantityOfProduct(
                                          context: context1));
                                }
                              },
                            ),
                            state.relatedProductList.isEmpty
                                ? 0.width : relatedProductWidget(context1, state.relatedProductList,context)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
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
          padding: EdgeInsets.only(left: 10,right: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2,i){
              return CommonProductItemWidget(
                lowStock: relatedProductList.elementAt(i).lowStock.toString(),
                productStock:relatedProductList.elementAt(i).productStock.toString(),
                width: AppConstants.relatedProductItemWidth,
                productImage:relatedProductList[i].mainImage,
                productName: relatedProductList.elementAt(i).productName,
                totalSaleCount: relatedProductList.elementAt(i).totalSale,
                price:relatedProductList.elementAt(i).productPrice,
                onButtonTap: (){
                  Navigator.of(prevContext).pop();
                  showProductDetails(
                      context: context,
                      productId: relatedProductList[i].id,
                      endDate: '',
                      startDate: '');
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
}
