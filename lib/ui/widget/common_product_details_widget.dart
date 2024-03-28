import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_stock/ui/widget/common_product_details_button.dart';
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
  final void Function() onQuantityIncreaseTap;
  final void Function() onQuantityDecreaseTap;
  final void Function() imageOnTap;
  final void Function(String) onQuantityChanged;
  final bool isRTL;
  final String productStock;
  final bool isSupplierAvailable;
  final int productImageIndex;
  final dynamic Function(int, CarouselPageChangedReason)? onPageChanged;
  final String saleDate;
  final String startDate;
  final String endDate;
  final Function() addToOrderTap;
  final bool isLoading;
  final String qrCode;
  final String lowStock;
  final bool isPesach;
  final String nmMashlim;

  const CommonProductDetailsWidget(
      {super.key,
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
       this.isRTL = false,
      required this.scrollController,
       this.isPesach = false,
      required this.productQuantity,
      required this.onQuantityIncreaseTap,
      required this.onQuantityDecreaseTap,
      required this.onQuantityChanged,
      required this.productStock,
      required this.productScaleType,
      required this.isSupplierAvailable,
      required this.productImageIndex,
      required this.onPageChanged,
      this.saleDate = '',
      this.startDate = '',
      this.endDate = '',
      this.isLoading = false,
      required this.imageOnTap,
      required this.addToOrderTap,
      required this.qrCode,
        required this.lowStock,
      required this.nmMashlim
      });

  @override
  Widget build(BuildContext context) {
    debugPrint('qrCode_____${qrCode}');
    debugPrint('stock_____${productStock}');
    debugPrint('lowStock${lowStock}');
    return Container(
     // height: getScreenHeight(context) / 1.5,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onPanUpdate: (detail){
              Navigator.pop(context);
            },
            child: Column(
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
                Text(
                  '$productPerUnit ${AppLocalizations.of(context)!.unit_in_box} ',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: AppColors.blackColor),
                ),
                Text(
                  '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}:${AppLocalizations.of(context)?.currency}${productUnitPrice.toStringAsFixed(2)}',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_14, color: AppColors.blackColor),
                ),
              ],
            ),
          ),
          5.height,
          nmMashlim.isNotEmpty?Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                color: AppColors.pesachBGColor,
                border: Border.all(color: AppColors.pesachBGColor),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child:Text(nmMashlim),
          ):0.height,
          nmMashlim.isNotEmpty?5.height:0.height,
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onPanUpdate: (detail){
                  Navigator.pop(context);
                },
                child: Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppConstants.padding_10,
                            right: AppConstants.padding_10,
                            left: AppConstants.padding_10,
                            top: AppConstants.padding_10),
                        child: CarouselSlider(
                            // carouselController: carouselController,
                            items: productImages
                                .map((productImage) => GestureDetector(
                                      onTap: imageOnTap,
                                      child: productImage.isNotEmpty ? Image.network(
                                        "${AppUrls.baseFileUrl}$productImage",
                                        height: 150,
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress
                                                  ?.cumulativeBytesLoaded !=
                                              loadingProgress
                                                  ?.expectedTotalBytes) {
                                            return CommonShimmerWidget(
                                              child: Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(AppConstants
                                                          .radius_10)),
                                                ),
                                              ),
                                            );
                                          }
                                          return child;
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            AppImagePath.imageNotAvailable5,
                                            fit: BoxFit.cover,
                                            // width: 90,
                                            height: 150,
                                          );
                                        },
                                      ) : Image.asset(
                                        AppImagePath.imageNotAvailable5,
                                        fit: BoxFit.cover,
                                        // width: 90,
                                        height: 150,
                                      ),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
              ),
              Text(
                qrCode,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
              ),
              5.height,
              /*   startDate != '' ?  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.from_time,
                              style:
                              AppStyles.rkRegularTextStyle(
                                  size: AppConstants
                                      .smallFont,
                                  color:
                                  AppColors.blackColor,
                              fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(startDate,
                              style:
                              AppStyles.rkRegularTextStyle(
                                  size: AppConstants
                                      .font_14,
                                  color:
                                  AppColors.blackColor),)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.until_time,
                              style:
                              AppStyles.rkRegularTextStyle(
                                  size: AppConstants
                                      .smallFont,
                                  color:
                                  AppColors.blackColor,
                                  fontWeight: FontWeight.w600
                              ),),
                            Text(endDate,
                              style:
                              AppStyles.rkRegularTextStyle(
                                  size: AppConstants
                                      .font_14,
                                  color:
                                  AppColors.blackColor),)
                          ],
                        )
                      ],
                    ),
                  ): 0.width,
                  10.height,*/
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: AppColors.borderColor.withOpacity(0.5),
                        width: 1),
                    bottom: BorderSide(
                        color: AppColors.borderColor.withOpacity(0.5),
                        width: 1),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                child: double.parse(productStock) <= 0
                    ? Column(
                        children: [
                          5.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.out_of_stock1}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.redColor),
                              ),
                            ],
                          ),
                          10.height
                        ],
                      )
                    : Column(
                        children: [
                          5.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: getScreenWidth(context) >= 700
                                    ? (getScreenWidth(context) - 30) / 3
                                    : (getScreenWidth(context) - 30) / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.currency}${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(AppConstants.amountFrLength)}',
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
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: getScreenWidth(context) >= 700
                                    ? (getScreenWidth(context) - 30) / 3
                                    : (getScreenWidth(context) - 30) / 2,
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
                                                color:
                                                    AppColors.navSelectedColor,
                                                width: 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: TextField(
                                            // readOnly: true,
                                            controller: TextEditingController(
                                                text: "${productQuantity}")
                                              ..selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              "$productQuantity"
                                                                  .length)),
                                            textAlign: TextAlign.center,
                                            style: AppStyles.rkBoldTextStyle(
                                                size: AppConstants.font_26,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w700),
                                            maxLength: 5,
                                            maxLines: 1,
                                            textInputAction:
                                                TextInputAction.done,
                                            keyboardType: Platform.isIOS
                                                ? TextInputType
                                                    .numberWithOptions(
                                                        signed: true)
                                                : TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            textDirection: TextDirection.ltr,
                                            onChanged: onQuantityChanged,
                                            cursorColor: AppColors.mainColor,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                filled: true,
                                                counterText: '',
                                                constraints: BoxConstraints(
                                                    maxHeight: 50,
                                                    minWidth: 50),
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: 0)),
                                          )),
                                    ),
                                    5.width,
                                    GestureDetector(
                                      onTap: onQuantityDecreaseTap,
                                      child: Container(
                                        height: 50,
                                        width: 40,
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
                          lowStock.isNotEmpty && productStock != '0' ? Text(
                            lowStock,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont, color: AppColors.orangeColor),
                          ) : 0.width,
                          CommonProductDetailsButton(
                              isLoading: isLoading,
                              isSupplierAvailable: true,
                              productStock: (productStock.toString()),
                              onAddToOrderPressed:
                                  isLoading ? null : addToOrderTap),
                        ],
                      ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}