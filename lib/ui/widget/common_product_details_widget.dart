import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import 'common_product_button_widget.dart';

class CommonProductDetailsWidget extends StatelessWidget {
  final BuildContext context;
  final List<String> productImages;
  final String productName;
  final String productCompanyName;
  final String productDescription;
  final String productSaleDescription;
  final double productPrice;
  final double productWeight;
  final int productQuantity;
  final String productScaleType;
  final ScrollController scrollController;
  final TextEditingController noteController;
  final void Function()? onAddToOrderPressed;
  final void Function() onQuantityIncreaseTap;
  final void Function() onQuantityDecreaseTap;
  final void Function(String)? onNoteChanged;
  final bool isRTL;
  final bool isLoading;
  final int productStock;
  final Widget supplierWidget;
  final int productImageIndex;
  final dynamic Function(int, CarouselPageChangedReason)? onPageChanged;

  // final CarouselController carouselController = CarouselController();

  const CommonProductDetailsWidget({
    super.key,
    required this.context,
    required this.productImages,
    required this.productName,
    required this.productCompanyName,
    required this.productDescription,
    required this.productSaleDescription,
    required this.productPrice,
    required this.productWeight,
    required this.isRTL,
    required this.scrollController,
    required this.onAddToOrderPressed,
    required this.noteController,
    required this.productQuantity,
    required this.onQuantityIncreaseTap,
    required this.onQuantityDecreaseTap,
    this.onNoteChanged,
    required this.isLoading,
    required this.productStock,
    required this.productScaleType,
    required this.supplierWidget,
    required this.productImageIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // bool isSelectSupplier = true;
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
          bottom: MediaQuery.of(context).viewInsets.bottom),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 36,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          5.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${productWeight.toStringAsFixed(1)}$productScaleType',
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
              ),
              Text(
                ' | ',
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
              ),
              Text(
                '$productCompanyName',
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
              ),
            ],
          ),
          10.height,
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20,
                              right: AppConstants.padding_10,
                              left: AppConstants.padding_10,
                              top: AppConstants.padding_10),
                          child: CarouselSlider(
                              // carouselController: carouselController,
                              items: productImages
                                  .map(
                                      (productImage) => /*Container(
                                            height: 150,
                                            color: AppColors.lightBorderColor,
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppConstants.padding_5),
                                          )*/
                                          Image.network(
                                            "${AppUrls.baseFileUrl}$productImage",
                                            height: 150,
                                            fit: BoxFit.fitHeight,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress
                                                      ?.cumulativeBytesLoaded !=
                                                  loadingProgress
                                                      ?.expectedTotalBytes) {
                                                return CommonShimmerWidget(
                                                  child: Container(
                                                    height: 150,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.whiteColor,
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              AppConstants
                                                                  .radius_10)),
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
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              // debugPrint('product category list image error : $error');
                                              return Image.asset(
                                                AppImagePath.imageNotAvailable5,
                                                fit: BoxFit.cover,
                                                // width: 90,
                                                height: 150,
                                              );
                                            },
                                          ))
                                  .toList(),
                              options: CarouselOptions(
                                  height: 150,
                                  onPageChanged: onPageChanged,
                                  initialPage: productImageIndex,
                                  aspectRatio: 16 / 9,
                                  scrollDirection: Axis.horizontal,
                                  enableInfiniteScroll: false,
                                  autoPlayCurve: Curves.decelerate,
                                  pageSnapping: true)),
                        ),
                        productImages.length < 2
                            ? 0.width
                            : Positioned(
                                bottom: 5,
                                child: Container(
                                  width: getScreenWidth(context),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: productImages
                                        .asMap()
                                        .entries
                                    .map((productImage) => Container(
                                  height: 7,
                                  width: 7,
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                      AppConstants.padding_2),
                                  decoration: BoxDecoration(
                                      color: productImageIndex ==
                                          productImage.key
                                                      ? AppColors.mainColor
                                                      : AppColors.borderColor,
                                                  shape: BoxShape.circle),
                                            ))
                                        .toList(),
                                  ),
                                ))
                      ],
                    ),
                  ),
                  /*false */ /*productStock == 0*/ /* ? 0.width : */
                  supplierWidget,
                  // : AnimatedCrossFade(
                  //     firstChild: Container(
                  //       width: getScreenWidth(context),
                  //       decoration: BoxDecoration(
                  //           border: Border(
                  //               top: BorderSide(
                  //                   color: AppColors.borderColor
                  //                       .withOpacity(0.5),
                  //                   width: 1))),
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: AppConstants.padding_10,
                  //           horizontal: AppConstants.padding_30),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(
                  //                 bottom: AppConstants.padding_5),
                  //             child: InkWell(
                  //               onTap: onSupplierSelectionTap,
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                 MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(
                  //                     AppLocalizations.of(context)!.suppliers,
                  //                     style: AppStyles.rkRegularTextStyle(
                  //                         size: AppConstants.smallFont,
                  //                         color: AppColors.mainColor,
                  //                         fontWeight: FontWeight.w500),
                  //                   ),
                  //                   Icon(
                  //                     Icons.arrow_drop_down,
                  //                     size: 26,
                  //                     color: AppColors.blackColor,
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           ListView.builder(
                  //             itemCount: 3,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             shrinkWrap: true,
                  //             itemBuilder: (context, index) {
                  //               return Container(
                  //                 padding: EdgeInsets.symmetric(
                  //                     vertical: AppConstants.padding_5,
                  //                     horizontal:
                  //                     AppConstants.padding_10),
                  //                 margin: EdgeInsets.symmetric(
                  //                     vertical: AppConstants.padding_5),
                  //                 decoration: BoxDecoration(
                  //                   color: AppColors.iconBGColor,
                  //                   borderRadius: BorderRadius.all(
                  //                       Radius.circular(
                  //                           AppConstants.radius_5)),
                  //                 ),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                   CrossAxisAlignment.start,
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     Text(
                  //                       'Supplier Name',
                  //                       style:
                  //                       AppStyles.rkRegularTextStyle(
                  //                           size:
                  //                           AppConstants.font_12,
                  //                           color:
                  //                           AppColors.blackColor),
                  //                     ),
                  //                     Container(
                  //                       decoration: BoxDecoration(
                  //                           color: AppColors
                  //                               .whiteColor,
                  //                           borderRadius: BorderRadius
                  //                               .all(Radius.circular(
                  //                               AppConstants
                  //                                   .radius_3))),
                  //                       padding:
                  //                       EdgeInsets.symmetric(
                  //                           vertical:
                  //                           AppConstants
                  //                               .padding_3,
                  //                           horizontal:
                  //                           AppConstants
                  //                               .padding_5),
                  //                       margin: EdgeInsets.only(
                  //                           top: AppConstants
                  //                               .padding_5,),
                  //                       alignment:
                  //                       Alignment.topLeft,
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                         CrossAxisAlignment
                  //                             .start,
                  //                         mainAxisSize:
                  //                         MainAxisSize.min,
                  //                         children: [
                  //                           Text('Sale Name'),
                  //                           2.height,
                  //                           Text('price : 150\$'),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               );
                  //             },
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     secondChild: Container(
                  //       height: getScreenHeight(context) * 0.5,
                  //       width: getScreenWidth(context),
                  //       decoration: BoxDecoration(
                  //           border: Border(
                  //               top: BorderSide(
                  //                   color: AppColors.borderColor
                  //                       .withOpacity(0.5),
                  //                   width: 1))),
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: AppConstants.padding_10,
                  //           horizontal: AppConstants.padding_30),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(
                  //                 bottom: AppConstants.padding_5),
                  //             child: InkWell(
                  //               onTap: onSupplierSelectionTap,
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(
                  //                     AppLocalizations.of(context)!.suppliers,
                  //                     style: AppStyles.rkRegularTextStyle(
                  //                         size: AppConstants.smallFont,
                  //                         color: AppColors.mainColor,
                  //                         fontWeight: FontWeight.w500),
                  //                   ),
                  //                   Icon(
                  //                     Icons.remove,
                  //                     size: 26,
                  //                     color: AppColors.blackColor,
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: ListView.builder(
                  //               itemBuilder: (context, index) {
                  //                 return Container(
                  //                   height: 95,
                  //                   padding: EdgeInsets.symmetric(
                  //                       vertical: AppConstants.padding_5,
                  //                       horizontal:
                  //                           AppConstants.padding_10),
                  //                   margin: EdgeInsets.symmetric(
                  //                       vertical: AppConstants.padding_10),
                  //                   decoration: BoxDecoration(
                  //                     color: AppColors.iconBGColor,
                  //                     borderRadius: BorderRadius.all(
                  //                         Radius.circular(
                  //                             AppConstants.radius_5)),
                  //                   ),
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     children: [
                  //                       Text(
                  //                         'Supplier Name',
                  //                         style:
                  //                             AppStyles.rkRegularTextStyle(
                  //                                 size:
                  //                                     AppConstants.font_12,
                  //                                 color:
                  //                                     AppColors.blackColor),
                  //                       ),
                  //                       Expanded(
                  //                         child: ListView.builder(
                  //                           scrollDirection:
                  //                               Axis.horizontal,
                  //                           itemBuilder: (context, index) {
                  //                             return Container(
                  //                               decoration: BoxDecoration(
                  //                                   color: AppColors
                  //                                       .whiteColor,
                  //                                   borderRadius: BorderRadius
                  //                                       .all(Radius.circular(
                  //                                           AppConstants
                  //                                               .radius_3))),
                  //                               padding:
                  //                                   EdgeInsets.symmetric(
                  //                                       vertical:
                  //                                           AppConstants
                  //                                               .padding_3,
                  //                                       horizontal:
                  //                                           AppConstants
                  //                                               .padding_5),
                  //                               margin: EdgeInsets.only(
                  //                                   top: AppConstants
                  //                                       .padding_10,
                  //                                   left: AppConstants
                  //                                       .padding_5,
                  //                                   right: AppConstants
                  //                                       .padding_5),
                  //                               alignment:
                  //                                   Alignment.topLeft,
                  //                               child: Column(
                  //                                 crossAxisAlignment:
                  //                                     CrossAxisAlignment
                  //                                         .start,
                  //                                 mainAxisSize:
                  //                                     MainAxisSize.min,
                  //                                 children: [
                  //                                   Text('Sale Name'),
                  //                                   2.height,
                  //                                   Text('price : 150\$'),
                  //                                   2.height,
                  //                                   Text(
                  //                                       'Sale Description'),
                  //                                 ],
                  //                               ),
                  //                             );
                  //                           },
                  //                         ),
                  //                       )
                  //                     ],
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     crossFadeState: isSelectSupplier
                  //         ? CrossFadeState.showSecond
                  //         : CrossFadeState.showFirst,
                  //     duration: Duration(milliseconds: 300)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: AppColors.borderColor.withOpacity(0.5),
                            width: 1),
                        bottom: BorderSide(
                            width: 1,
                            color: AppColors.borderColor.withOpacity(0.5)),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_15,
                        vertical: AppConstants.padding_20),
                    child: productStock == 0
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.outOfStockString,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.textColor),
                        ),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: (getScreenWidth(context) - 30) / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(AppConstants.amountFrLength)}${AppLocalizations.of(context)!.currency}',
                                      style: AppStyles.rkBoldTextStyle(
                                          size: AppConstants.font_30,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                "${parse(productSaleDescription).body?.text}",
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: (getScreenWidth(context) - 30) / 2,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    GestureDetector(
                                      onTap: onQuantityIncreaseTap,
                                      child: Container(
                                        height: 50,
                                        width: 40,
                                        // padding: EdgeInsets.symmetric(
                                        //     horizontal: AppConstants.padding_10),
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
                              Expanded(
                                      child: Container(
                                        // width: max,
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                AppConstants.padding_10),
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
                                          '$productQuantity',
                                          style: AppStyles.rkBoldTextStyle(
                                              size: AppConstants.font_26,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.w700),
                                          // maxLines: 1,
                                        ),
                                      ),
                                    ),
                              5.width,
                              GestureDetector(
                                onTap: onQuantityDecreaseTap,
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: AppConstants.padding_10),
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
                        ),
                      ],
                    ),
                  ),
                  productStock == 0
                      ? 0.width
                      : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                              // height: 120,
                              width: getScreenWidth(context),
                              padding: EdgeInsets.only(
                                  left: AppConstants.padding_10,
                                  right: AppConstants.padding_10,
                                  bottom: AppConstants.padding_5),
                              decoration: BoxDecoration(
                                  color: AppColors.notesBGColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          AppConstants.radius_5))),
                              child: TextFormField(
                                controller: noteController,
                                onChanged: onNoteChanged,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    border: InputBorder.none),
                                maxLines: 3,
                                maxLength: 50,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.all(AppConstants.padding_20),
                        child: CommonProductButtonWidget(
                          title:
                          AppLocalizations.of(context)!.add_to_order,
                          isLoading: isLoading,
                          onPressed: onAddToOrderPressed,
                          width: double.maxFinite,
                          height: AppConstants.buttonHeight,
                          borderRadius: AppConstants.radius_5,
                          textSize: AppConstants.normalFont,
                          textColor: AppColors.whiteColor,
                          bgColor: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                  // 160.height,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Row(
//   children: [
//     Expanded(
//       flex: 5,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Sale',
//             style: AppStyles.rkBoldTextStyle(
//                 size: AppConstants.font_30,
//                 color: AppColors.saleRedColor,
//                 fontWeight: FontWeight.w700),
//           ),
//           5.height,
//           Text(
//             productDescription,
//             style: AppStyles.rkRegularTextStyle(
//                 size: AppConstants.font_14,
//                 color: AppColors.blackColor,
//                 fontWeight: FontWeight.w400),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     ),
//     Expanded(flex: 2, child: 0.height),
//   ],
// ),
