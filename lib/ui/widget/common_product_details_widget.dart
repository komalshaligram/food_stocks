import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final double productUnitPrice;
  final int productPerUnit;
  final int productQuantity;
  final String productScaleType;
  final ScrollController scrollController;
  final TextEditingController noteController;
  // final void Function()? onAddToOrderPressed;
  final void Function() onQuantityIncreaseTap;
  final void Function() onQuantityDecreaseTap;
  final void Function(String)? onNoteChanged;
  final void Function(String) onQuantityChanged;
  final void Function() onNoteToggleChanged;
  final bool isRTL;

  // final bool isLoading;
  final bool isNoteOpen;
  final int productStock;
  final Widget supplierWidget;
  final bool isSupplierAvailable;
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
    required this.productUnitPrice,
    required this.productPerUnit,
    required this.isRTL,
    required this.isNoteOpen,
    required this.scrollController,
    // this.onAddToOrderPressed,
    required this.noteController,
    required this.productQuantity,
    required this.onQuantityIncreaseTap,
    required this.onQuantityDecreaseTap,
    required this.onNoteToggleChanged,
    this.onNoteChanged,
    required this.onQuantityChanged,
    // required this.isLoading,
    required this.productStock,
    required this.productScaleType,
    required this.supplierWidget,
    required this.isSupplierAvailable,
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
      child:
          // Stack(
          //   fit: StackFit.passthrough,
          //   children: [
          Column(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$productPerUnit${AppLocalizations.of(context)!
                        .unit_in_box}',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.blackColor),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.price} : ${productUnitPrice
                        .toStringAsFixed(2)}${AppLocalizations.of(context)!
                        .per_unit}',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        color: AppColors.blackColor),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       '${productWeight.toStringAsFixed(1)}$productScaleType',
              //       style: AppStyles.rkRegularTextStyle(
              //           size: AppConstants.smallFont,
              //           color: AppColors.blackColor),
              //     ),
              //     productCompanyName == ''
              //         ? 0.height
              //         : Text(
              //             ' | ',
              //             style: AppStyles.rkRegularTextStyle(
              //                 size: AppConstants.smallFont,
              //                 color: AppColors.blackColor),
              //           ),
              //     Text(
              //       '$productCompanyName',
              //       style: AppStyles.rkRegularTextStyle(
              //           size: AppConstants.smallFont,
              //           color: AppColors.blackColor),
              //     ),
              //   ],
              // ),
              10.height,
              Expanded(
                // fit: FlexFit.tight,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                      .map((productImage) => Image.network(
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
                                                      horizontal: AppConstants
                                                          .padding_2),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          productImageIndex ==
                                                                  productImage
                                                                      .key
                                                              ? AppColors
                                                                  .mainColor
                                                              : AppColors
                                                                  .borderColor,
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
                      isSupplierAvailable
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: AppColors.borderColor
                                              .withOpacity(0.5),
                                          width: 1),
                                      bottom: BorderSide(
                                          width: 1,
                                          color: AppColors.borderColor
                                              .withOpacity(0.5)),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppConstants.padding_15,
                                      vertical: AppConstants.padding_20),
                                  child: productStock == 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${AppLocalizations.of(context)!.out_of_stock}',
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                      size: AppConstants
                                                          .smallFont,
                                                      color:
                                                          AppColors.textColor),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: (getScreenWidth(context) -
                                                      30) /
                                                  2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(AppConstants.amountFrLength)}${AppLocalizations.of(context)!.currency}',
                                                    style: AppStyles
                                                        .rkBoldTextStyle(
                                                            size: AppConstants
                                                                .font_30,
                                                            color: AppColors
                                                                .blackColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                  Text(
                                                    "${parse(productSaleDescription).body?.text}",
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                            size: AppConstants
                                                                .font_14,
                                                            color: AppColors
                                                                .blackColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: (getScreenWidth(context) -
                                                      30) /
                                                  2,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  GestureDetector(
                                                    onTap:
                                                        onQuantityIncreaseTap,
                                                    child: Container(
                                                      height: 50,
                                                      width: 40,
                                                      // padding: EdgeInsets.symmetric(
                                                      //     horizontal: AppConstants.padding_10),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .iconBGColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(isRTL
                                                                  ? AppConstants
                                                                      .radius_5
                                                                  : AppConstants
                                                                      .radius_50),
                                                          bottomLeft: Radius
                                                              .circular(isRTL
                                                                  ? AppConstants
                                                                      .radius_5
                                                                  : AppConstants
                                                                      .radius_50),
                                                          bottomRight: Radius
                                                              .circular(isRTL
                                                                  ? AppConstants
                                                                      .radius_50
                                                                  : AppConstants
                                                                      .radius_5),
                                                          topRight: Radius
                                                              .circular(isRTL
                                                                  ? AppConstants
                                                                      .radius_50
                                                                  : AppConstants
                                                                      .radius_5),
                                                        ),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .navSelectedColor,
                                                            width: 1),
                                                      ),
                                                      // padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_8),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 26,
                                                        color:
                                                            AppColors.mainColor,
                                                      ),
                                                    ),
                                                  ),
                                                  5.width,
                                                  Expanded(
                                                    child: Container(
                                                      // width: max,
                                                      height: 50,
                                                      // padding: EdgeInsets.symmetric(
                                                      //     horizontal:
                                                      //         AppConstants.padding_10),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .iconBGColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  AppConstants
                                                                      .radius_5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  AppConstants
                                                                      .radius_5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  AppConstants
                                                                      .radius_5),
                                                          topRight:
                                                              Radius.circular(
                                                                  AppConstants
                                                                      .radius_5),
                                                        ),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .navSelectedColor,
                                                            width: 1),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: TextField(
                                                        // readOnly: true,
                                                        controller: TextEditingController(
                                                            text:
                                                                "${productQuantity}")
                                                          ..selection = TextSelection
                                                              .fromPosition(
                                                                  TextPosition(
                                                                      offset: "$productQuantity"
                                                                          .length)),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyles
                                                            .rkBoldTextStyle(
                                                                size:
                                                                    AppConstants
                                                                        .font_26,
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                        maxLength: 5,
                                                        maxLines: 1,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        // onTapOutside: (event) =>
                                                        //     FocusScope.of(
                                                        //             context)
                                                        //         .unfocus(),
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        onChanged:
                                                            onQuantityChanged,
                                                        cursorColor:
                                                            AppColors.mainColor,
                                                        decoration: InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            errorBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedErrorBorder:
                                                                InputBorder
                                                                    .none,
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            filled: true,
                                                            counterText: '',
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxHeight:
                                                                        50,
                                                                    minWidth:
                                                                        50),
                                                            fillColor: Colors
                                                                .transparent,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical:
                                                                        0)),
                                                      )
                                                      /*Text(
                                                        '$productQuantity',
                                                        style: AppStyles
                                                            .rkBoldTextStyle(
                                                                size: AppConstants
                                                                    .font_26,
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                        // maxLines: 1,
                                                      )*/
                                                      ,
                                                    ),
                                                  ),
                                                  5.width,
                                                  GestureDetector(
                                                    onTap:
                                                        onQuantityDecreaseTap,
                                                    child: Container(
                                                      height: 50,
                                                      width: 40,
                                                      // padding: EdgeInsets.symmetric(
                                                      //     horizontal: AppConstants.padding_10),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .iconBGColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(isRTL
                                                                  ? AppConstants
                                                                      .radius_50
                                                                  : AppConstants
                                                                      .radius_5),
                                                          bottomLeft: Radius
                                                              .circular(isRTL
                                                                  ? AppConstants
                                                                      .radius_50
                                                                  : AppConstants
                                                                      .radius_5),
                                                          bottomRight: Radius
                                                              .circular(isRTL
                                                                  ? AppConstants
                                                                      .radius_5
                                                                  : AppConstants
                                                                      .radius_50),
                                                          topRight: Radius
                                                              .circular(isRTL
                                                                  ? AppConstants
                                                                      .radius_5
                                                                  : AppConstants
                                                                      .radius_50),
                                                        ),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .navSelectedColor,
                                                            width: 1),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(Icons.remove,
                                                          size: 26,
                                                          color: AppColors
                                                              .mainColor),
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
                                                vertical:
                                                    AppConstants.padding_20,
                                                horizontal:
                                                    AppConstants.padding_20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .note,
                                                      style: AppStyles
                                                          .rkRegularTextStyle(
                                                              size: AppConstants
                                                                  .font_14,
                                                              color: AppColors
                                                                  .blackColor),
                                                    ),
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap:
                                                          onNoteToggleChanged,
                                                      child: Icon(
                                                        isNoteOpen
                                                            ? Icons.remove
                                                            : Icons.add,
                                                        size: 26,
                                                        color: AppColors
                                                            .blackColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                10.height,
                                                AnimatedCrossFade(
                                                    firstChild:
                                                        getScreenWidth(context)
                                                            .width,
                                                    secondChild: Container(
                                                      // height: 120,
                                                      width: getScreenWidth(
                                                          context),
                                                      padding: EdgeInsets.only(
                                                          left: AppConstants
                                                              .padding_10,
                                                          right: AppConstants
                                                              .padding_10,
                                                          bottom: AppConstants
                                                              .padding_5),
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .notesBGColor,
                                                          borderRadius: BorderRadius
                                                              .all(Radius.circular(
                                                                  AppConstants
                                                                      .radius_5))),
                                                      margin: EdgeInsets.only(
                                                          bottom: AppConstants
                                                              .padding_15),
                                                      child: TextFormField(
                                                        controller:
                                                            noteController,
                                                        onChanged:
                                                            onNoteChanged,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                        maxLines: 3,
                                                        maxLength: 50,
                                                      ),
                                                    ),
                                                    crossFadeState: isNoteOpen
                                                        ? CrossFadeState
                                                            .showSecond
                                                        : CrossFadeState
                                                            .showFirst,
                                                    duration: Duration(
                                                        milliseconds: 300))
                                              ],
                                            ),
                                          ),
                                          // 90.height,
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                          //       top: 0,
                                          //       left: AppConstants.padding_20,
                                          //       right: AppConstants.padding_20,
                                          //       bottom: AppConstants.padding_20),
                                          //   child: CommonProductButtonWidget(
                                          //     title: AppLocalizations.of(context)!
                                          //         .add_to_order,
                                          //     isLoading: isLoading,
                                          //     onPressed: onAddToOrderPressed,
                                          //     width: double.maxFinite,
                                          //     height: AppConstants.buttonHeight,
                                          //     borderRadius: AppConstants.radius_5,
                                          //     textSize: AppConstants.normalFont,
                                          //     textColor: AppColors.whiteColor,
                                          //     bgColor: AppColors.mainColor,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                          ],
                        )
                      : 0.width,
                  // 160.height,
                ],
              ),
            ),
          ),
        ],
      ),
      // !isSupplierAvailable || productStock == 0
      //     ? 0.width
      //     : Positioned(
      //         bottom: 0,
      //         right: 0,
      //         left: 0,
      //         child: Container(
      //           height: 90,
      //           width: getScreenWidth(context),
      //           padding: EdgeInsets.symmetric(
      //               horizontal: AppConstants.padding_20,
      //               vertical: AppConstants.padding_20),
      //           decoration: BoxDecoration(
      //               color: AppColors.whiteColor,
      //               border: Border(
      //                   top: BorderSide(
      //                       color: AppColors.lightBorderColor, width: 1))),
      //           child: CommonProductButtonWidget(
      //             title: AppLocalizations.of(context)!.add_to_order,
      //             isLoading: isLoading,
      //             onPressed: onAddToOrderPressed,
      //             width: double.maxFinite,
      //             height: AppConstants.buttonHeight,
      //             borderRadius: AppConstants.radius_5,
      //             textSize: AppConstants.normalFont,
      //             textColor: AppColors.whiteColor,
      //             bgColor: AppColors.mainColor,
      //           ),
      //         ),
      //       ),
      // ],
      // ),
    );
  }
}
