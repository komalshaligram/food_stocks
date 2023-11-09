import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/supplier_products/supplier_products_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/supplier_products_screen_shimmer_widget.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';

class SupplierProductsRoute {
  static Widget get route => SupplierProductsScreen();
}

class SupplierProductsScreen extends StatelessWidget {
  const SupplierProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => SupplierProductsBloc()
        ..add(SupplierProductsEvent.getSupplierProductsIdEvent(
            supplierId: args?[AppStrings.supplierIdString]))
        ..add(SupplierProductsEvent.getSupplierProductsListEvent(
            context: context)),
      child: SupplierProductsScreenWidget(),
    );
  }
}

class SupplierProductsScreenWidget extends StatelessWidget {
  const SupplierProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: AppLocalizations.of(context)!.products,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: NotificationListener<ScrollNotification>(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Stack(
                    //   children: [
                    //     Container(
                    //       height: getScreenWidth(context) / 3,
                    //       width: getScreenWidth(context) / 3,
                    //       clipBehavior: Clip.hardEdge,
                    //       margin: EdgeInsets.symmetric(
                    //           vertical: AppConstants.padding_10,
                    //           horizontal: AppConstants.padding_5),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.all(
                    //             Radius.circular(AppConstants.radius_10)),
                    //         color: AppColors.whiteColor,
                    //         boxShadow: [
                    //           BoxShadow(
                    //               color: AppColors.shadowColor.withOpacity(0.15),
                    //               blurRadius: AppConstants.blur_10)
                    //         ],
                    //       ),
                    //       child: Image.network(
                    //         "${AppUrls.baseFileUrl}",
                    //         fit: BoxFit.cover,
                    //         loadingBuilder: (context, child, loadingProgress) {
                    //           if (loadingProgress?.cumulativeBytesLoaded !=
                    //               loadingProgress?.expectedTotalBytes) {
                    //             return Container(
                    //               height: getScreenWidth(context) / 3,
                    //               width: getScreenWidth(context) / 3,
                    //               alignment: Alignment.center,
                    //               color: AppColors.whiteColor,
                    //               child: CupertinoActivityIndicator(
                    //                 color: AppColors.blackColor,
                    //               ),
                    //             );
                    //           }
                    //           return child;
                    //         },
                    //         errorBuilder: (context, error, stackTrace) {
                    //           // debugPrint('product category list image error : $error');
                    //           return Container(
                    //             color: AppColors.whiteColor,
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //     Positioned(
                    //       bottom: 0,
                    //       left: AppConstants.padding_5,
                    //       right: AppConstants.padding_5,
                    //       child: Container(
                    //         // height: 20,
                    //         // width: 80,
                    //         alignment: Alignment.center,
                    //         padding: EdgeInsets.symmetric(
                    //             vertical: AppConstants.padding_5,
                    //             horizontal: AppConstants.padding_5),
                    //         decoration: BoxDecoration(
                    //           color: AppColors.mainColor,
                    //           borderRadius: BorderRadius.only(
                    //               bottomLeft:
                    //                   Radius.circular(AppConstants.radius_10),
                    //               bottomRight:
                    //                   Radius.circular(AppConstants.radius_10)),
                    //           // border: Border.all(color: AppColors.whiteColor, width: 1),
                    //         ),
                    //         child: Text(
                    //           'supplierName',
                    //           style: AppStyles.rkRegularTextStyle(
                    //               size: AppConstants.font_12,
                    //               color: AppColors.whiteColor),
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // 10.height,
                    state.isShimmering
                        ? SupplierProductsScreenShimmerWidget()
                        : state.productList.isEmpty
                            ? Container(
                                height: getScreenHeight(context) - 56,
                                width: getScreenWidth(context),
                                alignment: Alignment.center,
                                child: Text(
                                  'Currently this Supplier has no products',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor),
                                ),
                              )
                            : GridView.builder(
                                itemCount: state.productList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppConstants.padding_5),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio:
                                            (getScreenWidth(context) + 50) /
                                                getScreenHeight(context)),
                                itemBuilder: (context, index) =>
                                    buildSupplierProducts(
                                        context: context,
                                        productName: state.productList[index]
                                                .productName ??
                                            '',
                                        productPrice: state
                                                .productList[index].numberOfUnit
                                                ?.toDouble() ??
                                            0.0,
                                        productImage: state
                                                .productList[index].mainImage ??
                                            '',
                                        isRTL: isRTLContent(context: context)),
                              ),
                    state.isLoadMore
                        ? Container(
                            height: 50,
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            child: CupertinoActivityIndicator(
                              color: AppColors.blackColor,
                            ),
                          )
                        : 0.width,
                  ],
                ),
              ),
              onNotification: (notification) {
                if (notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
                  if (!state.isLoadMore) {
                    context.read<SupplierProductsBloc>().add(
                        SupplierProductsEvent.getSupplierProductsListEvent(
                            context: context));
                  }
                }
                return true;
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildSupplierProducts(
      {required BuildContext context,
      required String productImage,
      required String productName,
      required double productPrice,
      required bool isRTL}) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        showProductDetails(
            context: context,
            productImage: '',
            isRTL: isRTLContent(context: context));
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_10,
        ),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.all(
              Radius.circular(AppConstants.radius_10),
            ),
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: AppConstants.padding_5,
                  left: AppConstants.padding_5,
                  top: AppConstants.padding_5),
              child: Image.network(
                "${AppUrls.baseFileUrl}$productImage",
                height: 80,
                fit: BoxFit.fitHeight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress?.cumulativeBytesLoaded !=
                      loadingProgress?.expectedTotalBytes) {
                    return CommonShimmerWidget(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_10)),
                        ),
                        // alignment: Alignment.center,
                        // color: AppColors.whiteColor,
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
                    height: 80,
                    color: AppColors.whiteColor,
                  );
                },
              ),
            ),
            4.height,
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.padding_5),
              child: Text(
                productName,
                style: AppStyles.rkBoldTextStyle(
                    size: AppConstants.font_14, color: AppColors.blackColor),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            4.height,
            Text(
              "23.00${AppLocalizations.of(context)!.currency}",
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12, color: AppColors.blackColor),
              textAlign: TextAlign.center,
            ),
            4.height,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_5),
                child: Text(
                  "Sale 2 at a discount",
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_12,
                      color: AppColors.saleRedColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: 35,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: AppColors.borderColor.withOpacity(0.7),
                        width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('+');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.iconBGColor,
                          border: Border(
                            left: isRTL
                                ? BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.7),
                                    width: 1)
                                : BorderSide.none,
                            right: isRTL
                                ? BorderSide.none
                                : BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.7),
                                    width: 1),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.add, color: AppColors.mainColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: AppColors.whiteColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_5),
                      alignment: Alignment.center,
                      child: Text(
                        '0',
                        style: AppStyles.rkBoldTextStyle(
                            size: 24,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('-');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.iconBGColor,
                          border: Border(
                            left: isRTL
                                ? BorderSide.none
                                : BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.7),
                                    width: 1),
                            right: isRTL
                                ? BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.7),
                                    width: 1)
                                : BorderSide.none,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.remove, color: AppColors.mainColor),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showProductDetails(
      {required BuildContext context,
      required String productImage,
      required bool isRTL}) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      // showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: true,
          maxChildSize: 1 -
              (MediaQuery.of(context).viewPadding.top /
                  getScreenHeight(context)),
          minChildSize: 0.4,
          initialChildSize: 0.7,
          shouldCloseOnMinExtent: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radius_30),
                  topRight: Radius.circular(AppConstants.radius_30),
                ),
                color: AppColors.whiteColor,
              ),
              padding: EdgeInsets.only(
                top: AppConstants.padding_10,
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  // 10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: 0.width),
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Product name',
                          style: AppStyles.rkBoldTextStyle(
                            size: AppConstants.normalFont,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 40,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  5.height,
                  Center(
                    child: Text(
                      '100gr | Company name',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: AppColors.blackColor),
                    ),
                  ),
                  10.height,
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.network(
                              '${AppUrls.baseFileUrl}$productImage',
                              height: 150,
                              fit: BoxFit.fitHeight,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress?.cumulativeBytesLoaded !=
                                    loadingProgress?.expectedTotalBytes) {
                                  return Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppConstants.radius_10)),
                                    ),
                                    // alignment: Alignment.center,
                                    // color: AppColors.whiteColor,
                                    // child: CupertinoActivityIndicator(
                                    //   color: AppColors.blackColor,
                                    // ),
                                  );
                                }
                                return child;
                              },
                              errorBuilder: (context, error, stackTrace) {
                                // debugPrint('product category list image error : $error');
                                return Container(
                                  height: 150,
                                  color: AppColors.whiteColor,
                                  child: Image.asset(
                                    AppImagePath.imageNotAvailable5,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.5),
                                    width: 1),
                                bottom: BorderSide(
                                    width: 1,
                                    color:
                                        AppColors.borderColor.withOpacity(0.5)),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_15,
                                vertical: AppConstants.padding_20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '11.90₪',
                                      style: AppStyles.rkBoldTextStyle(
                                          size: AppConstants.font_30,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '4.76 ש"ח ל- 100 גרם',
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.iconBGColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(isRTL
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_50),
                                            bottomLeft: Radius.circular(isRTL
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_50),
                                            bottomRight: Radius.circular(isRTL
                                                ? AppConstants.radius_50
                                                : AppConstants.radius_5),
                                            topRight: Radius.circular(isRTL
                                                ? AppConstants.radius_50
                                                : AppConstants.radius_5),
                                          ),
                                          border: Border.all(
                                              color: AppColors.navSelectedColor,
                                              width: 1),
                                        ),
                                        // padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_8),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.add,
                                          size: 26,
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                    ),
                                    5.width,
                                    Container(
                                      width: 80,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.iconBGColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              AppConstants.radius_5),
                                          bottomLeft: Radius.circular(
                                              AppConstants.radius_5),
                                          bottomRight: Radius.circular(
                                              AppConstants.radius_5),
                                          topRight: Radius.circular(
                                              AppConstants.radius_5),
                                        ),
                                        border: Border.all(
                                            color: AppColors.navSelectedColor,
                                            width: 1),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '1',
                                        style: AppStyles.rkBoldTextStyle(
                                            size: AppConstants.font_30,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    5.width,
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.iconBGColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(isRTL
                                                ? AppConstants.radius_50
                                                : AppConstants.radius_5),
                                            bottomLeft: Radius.circular(isRTL
                                                ? AppConstants.radius_50
                                                : AppConstants.radius_5),
                                            bottomRight: Radius.circular(isRTL
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_50),
                                            topRight: Radius.circular(isRTL
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_50),
                                          ),
                                          border: Border.all(
                                              color: AppColors.navSelectedColor,
                                              width: 1),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.remove,
                                            size: 26,
                                            color: AppColors.mainColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.borderColor
                                            .withOpacity(0.5),
                                        width: 1))),
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding_10,
                                horizontal: AppConstants.padding_20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sale',
                                        style: AppStyles.rkBoldTextStyle(
                                            size: AppConstants.font_30,
                                            color: AppColors.saleRedColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      5.height,
                                      Text(
                                        '2 at discount Buy 2 units at a price there of ₪20',
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.font_14,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: 0.height),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding_20,
                                horizontal: AppConstants.padding_20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.note,
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_14,
                                      color: AppColors.blackColor),
                                ),
                                10.height,
                                Container(
                                  height: 120,
                                  width: getScreenWidth(context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppConstants.padding_10),
                                  decoration: BoxDecoration(
                                      color: AppColors.notesBGColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppConstants.radius_5))),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    maxLines: 4,
                                  ) /*Text(
                                    '',
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_12,
                                        color: AppColors.blackColor),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  )*/
                                  ,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(AppConstants.padding_20),
                            child: CommonProductButtonWidget(
                              title: AppLocalizations.of(context)!.add_to_order,
                              onPressed: () {},
                              width: double.maxFinite,
                              height: AppConstants.buttonHeight,
                              borderRadius: AppConstants.radius_5,
                              textSize: AppConstants.normalFont,
                              textColor: AppColors.whiteColor,
                              bgColor: AppColors.mainColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
