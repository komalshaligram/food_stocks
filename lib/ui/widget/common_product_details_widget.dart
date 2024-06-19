import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/widget/common_product_details_button.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';

class CommonProductDetailsWidget extends StatelessWidget {
  final BuildContext context;
  final int productImageIndex;
  final dynamic Function(int, CarouselPageChangedReason)? onPageChanged;
  final ScrollController scrollController;
  final void Function() onQuantityIncreaseTap;
  final void Function() onQuantityDecreaseTap;
  final void Function() imageOnTap;
  final void Function(String) onQuantityChanged;
  final bool isRTL;
  final List<String> productImages;
  final String productStock;
  final double productPrice;
  final int productQuantity;
/*
  final String productName;
  final String productSaleDescription;
  final double productWeight;

  final double salePrice;
  final int productPerUnit;
  final bool isSupplierAvailable;
  final String qrCode;
  final String lowStock;
  final bool isPesach;
  final String nmMashlim;

  final bool isSaleOn;
  final String maxQty;*/
  final double productUnitPrice;
 final List<Product> productDetails;
  final Function() addToOrderTap;
  final bool isSubUserAddToBasket;
  final double totalBottleDeposit;
  final bool isLoading;
  final double bottleTax;
  final bool isBottle;
  const CommonProductDetailsWidget(
      {super.key,
      required this.context,
        required this.productImageIndex,
        required this.onPageChanged,
        required this.productImages,
        required this.productStock,

     /*
      required this.productName,
      required this.productSaleDescription,
      required this.productWeight,

      required this.productPerUnit,
        required this.salePrice,
       this.isPesach = false,
      required this.maxQty,
      required this.isSupplierAvailable,
      required this.qrCode,
        required this.lowStock,
      required this.nmMashlim,

        this.isSaleOn = false,*/
        required this.productUnitPrice,
        required this.bottleTax,
        required this.isBottle,
        this.isLoading = false,
        required this.productDetails,
        required this.imageOnTap,
        this.isRTL = false,
        required this.scrollController,
        required this.onQuantityIncreaseTap,
        required this.onQuantityDecreaseTap,
        required this.onQuantityChanged,
        required this.addToOrderTap,
        required this.productPrice,
        required this.productQuantity,
        required this.isSubUserAddToBasket,
        required this.totalBottleDeposit,

      });

  @override
  Widget build(BuildContext context) {

    debugPrint('productDetails123: $productDetails');

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
                        productDetails.first.productName,
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
                  '${productDetails.first.supplierSales.first.productPrice.toString()} ${AppLocalizations.of(context)!.unit_in_box} ',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: AppColors.blackColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    productDetails.first.sale.isSale?
                    Text.rich(TextSpan(
                      text: '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}: ',
                      children: <TextSpan>[
                         TextSpan(
                          text: '${AppLocalizations.of(context)?.currency}${productUnitPrice.toStringAsFixed(2)} ',
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14, color: AppColors.blackColor).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                         TextSpan(
                          text: ' ${AppLocalizations.of(context)?.currency}${double.parse(productDetails.first.sale.salePrice).toStringAsFixed(2)}',
                           style: AppStyles.rkRegularTextStyle(
                               size: AppConstants.font_14, color: AppColors.redColor),
                        ),
                      ],
                    ),
                    )
                   :Text(
                      '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}:${AppLocalizations.of(context)?.currency}${productUnitPrice.toStringAsFixed(2)}',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_14, color: AppColors.blackColor),
                    ),
                  ],
                ),
                productDetails.first.sale.saleDescription.isNotEmpty ? 8.height:0.height ,
                productDetails.first.sale.saleDescription.isNotEmpty ? Container(
                  width: getScreenWidth(context) - 50,
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(color: AppColors.saleBGColor, border: Border.all(color: AppColors.saleBGColor), borderRadius: BorderRadius.circular(AppConstants.radius_3)),
                  child: Text(
                    "${parse(productDetails.first.sale.saleDescription).body?.text}",
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor,fontWeight: FontWeight.w500),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ):0.width,
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              productDetails.first.isPesach? 5.height:0.height,
              productDetails.first.isPesach ? Container(
                  padding: EdgeInsets.only(left:3.0,right: 3.0),
                  decoration: BoxDecoration(
                      color: AppColors.pesachBGColor,
                      border: Border.all(color: AppColors.pesachBGColor),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child:productDetails.first.nmMashlim.isNotEmpty?Text('${AppLocalizations.of(context)!.pesach}, ${productDetails.first.nmMashlim}'):Text(AppLocalizations.of(context)!.pesach,style: TextStyle(fontSize: 12),)
              ):0.height,
              productDetails.first.isPesach?5.height:0.height,
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
                        ],
                      ),
                    ),
                  ),
                  Text(
                    productDetails.first.qrcode,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont, color: AppColors.blackColor),
                  ),
                  5.height,
                  Container (
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
                    child: productStock == '0' || productStock == "-1" || productStock == "0.0"
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
                        3.height,
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
                                  productDetails.first.isBottle?Container(
                                      padding: EdgeInsets.only(top:3),
                                      child: Text('${AppLocalizations.of(context)?.bottle_deposit}:${AppLocalizations.of(context)!.currency}${totalBottleDeposit.toStringAsFixed(AppConstants.amountFrLength)}')):0.height,

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
                                          controller: TextEditingController(
                                              text: "${productQuantity}")
                                            ..selection =
                                            TextSelection.fromPosition(TextPosition(offset: "$productQuantity".length)),
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
                        productDetails.first.sale.isSale? Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            '${AppLocalizations.of(context)!.maximum_qty} : ${productDetails.first.sale.saleMaxQuantity}',
                            style: AppStyles.rkBoldTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ):0.height,
                        productDetails.first.supplierSales.first.lowStock.isNotEmpty && (productStock != '0' || productStock != '0.0' )? Text(
                          productDetails.first.supplierSales.first.lowStock.toString(),
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont, color: AppColors.orangeColor),
                        ) : 0.height,
                        !isSubUserAddToBasket ? 13.height : 0.width,
                        isSubUserAddToBasket ? CommonProductDetailsButton(
                            isLoading: isLoading,
                            isSupplierAvailable: true,
                            productStock: (productStock.toString()),
                            onAddToOrderPressed:
                            isLoading ? null : addToOrderTap) : 0.width,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )

        ],
      ),
    );
  }
}