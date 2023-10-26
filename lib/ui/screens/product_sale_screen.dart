import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/product_sale/product_sale_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/widget/product_sale_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';

class ProductSaleRoute {
  static Widget get route => ProductSaleScreen();
}

class ProductSaleScreen extends StatelessWidget {
  const ProductSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductSaleBloc()
        ..add(ProductSaleEvent.getProductSalesListEvent(context: context)),
      child: ProductSaleScreenWidget(),
    );
  }
}

class ProductSaleScreenWidget extends StatelessWidget {
  const ProductSaleScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSaleBloc, ProductSaleState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: AppLocalizations.of(context)!.sales,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: state.isShimmering
                ? ProductSaleScreenShimmerWidget()
                : (state.productSalesList.data?.length ?? 0) == 0
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Currently products are not on sale',
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.textColor),
                          ),
                        ],
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: state.productSalesList.data?.length ?? 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 9 / 13),
                        itemBuilder: (context, index) {
                          return buildProductSaleListItem(
                            context: context,
                            saleImage:
                                state.productSalesList.data?[index].mainImage ??
                                    '',
                            title:
                                state.productSalesList.data?[index].salesName ??
                                    '',
                            description: state.productSalesList.data?[index]
                                    .salesDescription ??
                                '',
                            price: state.productSalesList.data?[index]
                                    .discountPercentage
                                    ?.toDouble() ??
                                0.0,
                            onButtonTap: () {
                              showProductDetails(
                                  context: context,
                                  isRTL: isRTLContent(context: context),
                                  productImage: state.productSalesList
                                          .data?[index].mainImage ??
                                      '',
                                  productName: state.productSalesList
                                          .data?[index].productName ??
                                      '',
                                  productCompanyName: state.productSalesList
                                          .data?[index].brandName ??
                                      '',
                                  productSaleDescription:
                                      state.productSalesList.data?[index].salesName ??
                                          '',
                                  productDescription: state.productSalesList
                                          .data?[index].salesDescription ??
                                      '',
                                  productPrice: state.productSalesList
                                          .data?[index].discountPercentage
                                          ?.toDouble() ??
                                      0.0,
                                  productWeight: state.productSalesList.data?[index].itemsWeight?.toDouble() ?? 0.0);
                            },
                          );
                        },
                      ),
          ),
        );
      },
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
      // height: 170,
      // width: 140,
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
                  return Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(
                      color: AppColors.blackColor,
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

  void showProductDetails(
      {required BuildContext context,
      required String productImage,
      required String productName,
      required String productCompanyName,
      required String productDescription,
      required String productSaleDescription,
      required double productPrice,
      required double productWeight,
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
                          productName,
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
                      '$productWeight | $productCompanyName',
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(AppConstants.padding_10),
                              child: Image.network(
                                "${AppUrls.baseFileUrl}$productImage",
                                height: 150,
                                fit: BoxFit.fitHeight,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress?.cumulativeBytesLoaded !=
                                      loadingProgress?.expectedTotalBytes) {
                                    return Container(
                                      height: 170,
                                      alignment: Alignment.center,
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.blackColor,
                                      ),
                                    );
                                  }
                                  return child;
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  // debugPrint('product category list image error : $error');
                                  return Container(
                                    padding: EdgeInsets.only(
                                        bottom: AppConstants.padding_10,
                                        top: 0),
                                    child: Image.asset(
                                      AppImagePath.imageNotAvailable5,
                                      fit: BoxFit.cover,
                                      // width: 90,
                                      height: 170,
                                    ),
                                  );
                                },
                              ),
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
                                      '$productPrice${AppLocalizations.of(context)!.currency}',
                                      style: AppStyles.rkBoldTextStyle(
                                          size: AppConstants.font_30,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      productSaleDescription,
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
                                        productDescription,
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
