import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_marquee_widget.dart';
import 'package:food_stock/ui/widget/common_product_button_widget.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../bloc/store/store_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_strings.dart';
import '../widget/common_product_category_widget.dart';
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
      create: (context) => StoreBloc()
        ..add(StoreEvent.getProductCategoriesListEvent(context: context))
        ..add(StoreEvent.getProductSalesListEvent(context: context))
        ..add(StoreEvent.getSuppliersListEvent(context: context)),
      child: StoreScreenWidget(),
    );
  }
}

class StoreScreenWidget extends StatelessWidget {
  const StoreScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreBloc bloc = context.read<StoreBloc>();
    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {},
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Stack(
                children: [
                  state.isShimmering
                      ? StoreScreenShimmerWidget()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              80.height,
                              state.productCategoryList.isEmpty
                                  ? 0.width
                                  : Column(
                                      children: [
                                        buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(context)!
                                                .categories,
                                            subTitle:
                                                AppLocalizations.of(context)!
                                                    .all_categories,
                                            onTap: () {}),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height: 110,
                                          child: ListView.builder(
                                            itemCount: state.productCategoryList
                                                        .length <
                                                    6
                                                ? state
                                                    .productCategoryList.length
                                                : 6 /*state.productCategoryList.length.clamp(6, 6).toInt()*/,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppConstants.padding_5),
                                            itemBuilder: (context, index) {
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
                                                  onTap: () {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                              // Column(
                              //   children: [
                              //     buildListTitles(
                              //         context: context,
                              //         title: AppLocalizations.of(context)!
                              //             .companies,
                              //         subTitle: AppLocalizations.of(context)!
                              //             .all_companies,
                              //         onTap: () {}),
                              //     SizedBox(
                              //       width: getScreenWidth(context),
                              //       height: 110,
                              //       child: ListView.builder(
                              //         itemCount: 10,
                              //         shrinkWrap: true,
                              //         scrollDirection: Axis.horizontal,
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: AppConstants.padding_5),
                              //         itemBuilder: (context, index) {
                              //           return buildCompanyListItem(
                              //               companyLogo:
                              //                   AppImagePath.profileImage,
                              //               companyName: "Company Name",
                              //               onTap: () {});
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              (state.suppliersList.data?.length ?? 0) == 0
                                  ? 0.width
                                  : Column(
                                      children: [
                                        buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(context)!
                                                .suppliers,
                                            subTitle:
                                                AppLocalizations.of(context)!
                                                    .all_suppliers,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .supplierScreen.name);
                                            }),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height: 110,
                                          child: ListView.builder(
                                            itemCount: (state.suppliersList.data
                                                            ?.length ??
                                                        0) <
                                                    5
                                                ? state
                                                    .suppliersList.data?.length
                                                : 6,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppConstants.padding_5),
                                            itemBuilder: (context, index) {
                                              return buildCompanyListItem(
                                                  companyLogo: state
                                                          .suppliersList
                                                          .data?[index]
                                                          .logo ??
                                                      '',
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
                                                                  .data?[index]
                                                                  .id ??
                                                              ''
                                                        });
                                                  });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                              (state.productSalesList.data?.length ?? 0) == 0
                                  ? 0.width
                                  : Column(
                                      children: [
                                        buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(context)!
                                                .sales,
                                            subTitle:
                                                AppLocalizations.of(context)!
                                                    .all_sales,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .productSaleScreen.name);
                                            }),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height: 190,
                                          child: ListView.builder(
                                            itemCount: (state.productSalesList
                                                            .data?.length ??
                                                        0) <
                                                    6
                                                ? state.productSalesList.data
                                                    ?.length
                                                : 6,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppConstants.padding_5),
                                            itemBuilder: (context, index) {
                                              return buildProductSaleListItem(
                                                context: context,
                                                saleImage: state
                                                        .productSalesList
                                                        .data?[index]
                                                        .mainImage ??
                                                    '',
                                                title: state
                                                        .productSalesList
                                                        .data?[index]
                                                        .salesName ??
                                                    '',
                                                description: state
                                                        .productSalesList
                                                        .data?[index]
                                                        .salesDescription ??
                                                    '',
                                                price: state
                                                        .productSalesList
                                                        .data?[index]
                                                        .discountPercentage
                                                        ?.toDouble() ??
                                                    0.0,
                                                onButtonTap: () {
                                                  showProductDetails(
                                                      context: context,
                                                      productId: state
                                                              .productSalesList
                                                              .data?[index]
                                                              .id ??
                                                          '');
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                              // Column(
                              //   children: [
                              //     buildListTitles(
                              //         context: context,
                              //         title: AppLocalizations.of(context)!
                              //             .recommended_for_you,
                              //         subTitle:
                              //             AppLocalizations.of(context)!.more,
                              //         onTap: () {}),
                              //     SizedBox(
                              //       width: getScreenWidth(context),
                              //       height: 190,
                              //       child: ListView.builder(
                              //         itemCount: 10,
                              //         shrinkWrap: true,
                              //         scrollDirection: Axis.horizontal,
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: AppConstants.padding_5),
                              //         itemBuilder: (context, index) {
                              //           return buildProductSaleListItem(
                              //             context: context,
                              //             saleImage: AppImagePath.product2,
                              //             title: '2 Products discount',
                              //             description:
                              //                 'Buy 2 units of a of flat salted pretzels for a price of 250 grams',
                              //             price: 20,
                              //             onTap: () {},
                              //             onButtonTap: () {},
                              //           );
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              85.height,
                            ],
                          ),
                        ),
                  CommonProductCategoryWidget(
                    isCategoryExpand: state.isCategoryExpand,
                    isRTL: isRTLContent(context: context),
                    onFilterTap: () {
                      bloc.add(StoreEvent.changeCategoryExpansion());
                    },
                    onScanTap: () async {
                      // Navigator.pushNamed(
                      //     context, RouteDefine.qrScanScreen.name);
                      String result = await scanBarcodeOrQRCode(
                          context: context,
                          cancelText: AppLocalizations.of(context)!.cancel,
                          scanMode: ScanMode.QR);
                      if (result != '-1') {
                        // -1 result for cancel scanning
                        debugPrint('result = $result');
                        showSnackBar(
                            context: context,
                            title: result,
                            bgColor: AppColors.mainColor);
                      }
                    },
                    controller: TextEditingController(),
                    onOutSideTap: () {
                      bloc.add(
                          StoreEvent.changeCategoryExpansion(isOpened: true));
                    },
                    categoryList: [
                      'Category name',
                      'Category name',
                      'Category name',
                      'Category name',
                      'Category name',
                    ],
                    onCatListItemTap: () {
                      Navigator.pushNamed(
                          context, RouteDefine.storeCategoryScreen.name);
                      bloc.add(
                          StoreEvent.changeCategoryExpansion(isOpened: true));
                    },
                    // child: !state.isCategoryExpand
                    //     ? 0.height
                    //     : Container(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.only(
                    //                   left: AppConstants.padding_20,
                    //                   right: AppConstants.padding_20,
                    //                   top: AppConstants.padding_15,
                    //                   bottom: AppConstants.padding_5),
                    //               child: Text(
                    //                 AppLocalizations.of(context)!.categories,
                    //                 style: AppStyles.rkBoldTextStyle(
                    //                     size: AppConstants.smallFont,
                    //                     color: AppColors.blackColor,
                    //                     fontWeight: FontWeight.w500),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               child: ListView.builder(
                    //                 itemCount: 18,
                    //                 shrinkWrap: true,
                    //                 clipBehavior: Clip.hardEdge,
                    //                 itemBuilder: (context, index) {
                    //                   return buildCategoryFilterItem(
                    //                       category: 'category',
                    //                       onTap: () {
                    //                         Navigator.pushNamed(
                    //                             context,
                    //                             RouteDefine
                    //                                 .storeCategoryScreen.name);
                    //                       });
                    //                 },
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding buildListTitles(
      {required BuildContext context,
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
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.blackColor),
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

  Widget buildCategoryListItem(
      {required String categoryName,
      required void Function() onTap,
      required String categoryImage}) {
    return Container(
      height: 90,
      width: 90,
      margin: EdgeInsets.symmetric(
          horizontal: AppConstants.padding_5,
          vertical: AppConstants.padding_10),
      clipBehavior: Clip.hardEdge,
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
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
                  top: AppConstants.padding_5,
                  left: AppConstants.padding_5,
                  right: AppConstants.padding_5,
                  bottom: AppConstants.padding_20),
              child: Image.network(
                "${AppUrls.baseFileUrl}$categoryImage",
                fit: BoxFit.contain,
                height: 65,
                width: 80,
                alignment: Alignment.center,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress?.cumulativeBytesLoaded !=
                      loadingProgress?.expectedTotalBytes) {
                    return CommonShimmerWidget(
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                        ),
                        // alignment: Alignment.center,
                        // child: CupertinoActivityIndicator(
                        //   color: AppColors.blackColor,
                        // ),
                      ),
                    );
                  }
                  return child;
                },
                errorBuilder: (context, error, stackTrace) {
                  // debugPrint('product category list image error : $error');
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: AppConstants.padding_10, top: 0),
                    child: Image.asset(
                      AppImagePath.imageNotAvailable5,
                      fit: BoxFit.cover,
                      width: 90,
                      height: 70,
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
                // height: 20,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_5,
                    vertical: AppConstants.padding_2),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.radius_10),
                      bottomRight: Radius.circular(AppConstants.radius_10)),
                  // border: Border.all(color: AppColors.whiteColor, width: 1),
                ),
                clipBehavior: Clip.hardEdge,
                child: CommonMarqueeWidget(
                  direction: Axis.horizontal,
                  child: Text(
                    categoryName,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              "${AppUrls.baseFileUrl}$saleImage",
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
                      // alignment: Alignment.center,
                      // child: CupertinoActivityIndicator(
                      //   color: AppColors.blackColor,
                      // ),
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
                  "${price.toStringAsFixed(0)}${AppLocalizations.of(context)!.currency}",
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
    );
  }

  Widget buildCompanyListItem(
      {required String companyLogo,
      required String companyName,
      required void Function() onTap}) {
    return Container(
      height: 90,
      width: 90,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.padding_20),
              child: Image.network(
                "${AppUrls.baseFileUrl}$companyLogo",
                fit: BoxFit.fill,
                height: 70,
                width: 90,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress?.cumulativeBytesLoaded !=
                      loadingProgress?.expectedTotalBytes) {
                    return CommonShimmerWidget(
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                        ),
                        // alignment: Alignment.center,
                        // child: CupertinoActivityIndicator(
                        //   color: AppColors.blackColor,
                        // ),
                      ),
                    );
                  }
                  return child;
                },
                errorBuilder: (context, error, stackTrace) {
                  // debugPrint('product category list image error : $error');
                  return Container(
                    child: Image.asset(
                      AppImagePath.imageNotAvailable5,
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
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
                height: 20,
                // width: 90,
                alignment: Alignment.center,
                // margin:
                //     EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_5,
                    vertical: AppConstants.padding_2),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(AppConstants.radius_10),
                      bottomLeft: Radius.circular(AppConstants.radius_10)),
                  // border: Border.all(color: AppColors.whiteColor, width: 1),
                ),
                child: CommonMarqueeWidget(
                  direction: Axis.horizontal,
                  child: Text(
                    companyName,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
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

  void showProductDetails(
      {required BuildContext context, required String productId}) async {
    context.read<StoreBloc>().add(StoreEvent.getProductDetailsEvent(
        context: context, productId: productId));
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
          value: context.read<StoreBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: 0.7,
            shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<StoreBloc>(),
                  child: BlocBuilder<StoreBloc, StoreState>(
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
                                  productImage:
                                      state.productDetails.product?.first.mainImage ??
                                          '',
                                  productName:
                                      state.productDetails.product?.first.productName ??
                                          '',
                                  productCompanyName:
                                      state.productDetails.product?.first.brandName ??
                                          '',
                                  productDescription: state.productDetails
                                          .product?.first.productDescription ??
                                      '',
                                  productSaleDescription: state.productDetails
                                          .product?.first.productDescription ??
                                      '',
                                  productPrice: state.productDetails.product
                                          ?.first.numberOfUnit
                                          ?.toDouble() ??
                                      0.0,
                                  productWeight: state.productDetails.product
                                          ?.first.itemsWeight
                                          ?.toDouble() ??
                                      0.0,
                                  isRTL: isRTLContent(context: context),
                                  scrollController: scrollController,
                                  productQuantity: state.productStockList[state.productStockUpdateIndex].quantity,
                                  onQuantityIncreaseTap: () {
                                    context.read<StoreBloc>().add(
                                        StoreEvent.increaseQuantityOfProduct(
                                            context: context1));
                                  },
                                  onQuantityDecreaseTap: () {
                                    context.read<StoreBloc>().add(
                                        StoreEvent.decreaseQuantityOfProduct(
                                            context: context1));
                                  },
                                  noteController: TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note),
                                  onNoteChanged: (newNote) {
                                    context.read<StoreBloc>().add(
                                        StoreEvent.changeNoteOfProduct(
                                            newNote: newNote));
                                  },
                                  isLoading: state.isLoading,
                                  onAddToOrderPressed: state.isLoading
                                      ? null
                                      : () {
                                          context.read<StoreBloc>().add(
                                              StoreEvent
                                                  .verifyProductStockEvent(
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
}
