import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/widget/common_product_details_button.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';

class CommonProductDetailsWidget extends StatelessWidget {
  final BuildContext context;
  final ScrollController scrollController;
  final void Function() onQuantityIncreaseTap;
  final void Function() onQuantityDecreaseTap;
  final void Function() imageOnTap;
  final void Function(String) onQuantityChanged;
  final List<String> productImages;
  final String productStock;
  final double productPrice;
  final int productQuantity;
  final double productUnitPrice;
  final List<Product> productDetails;
  final Function() addToOrderTap;
  final bool isSubUserAddToBasket;
  final double totalBottleDeposit;
  final bool isLoading;
  final double bottleTax;
  final bool isBottle;
  final bool isIncludedVat;
  final Function() onCloseTap;
  final bool isFromBasketScreen;

  const CommonProductDetailsWidget({super.key, required this.context, required this.productImages, required this.productStock, required this.productUnitPrice, required this.bottleTax, required this.isBottle, this.isLoading = false, required this.productDetails, required this.imageOnTap, required this.scrollController, required this.onQuantityIncreaseTap, required this.onQuantityDecreaseTap, required this.onQuantityChanged, required this.addToOrderTap, required this.productPrice, required this.productQuantity, required this.isSubUserAddToBasket, required this.totalBottleDeposit, required this.isIncludedVat, required this.onCloseTap,this.isFromBasketScreen = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radius_30),
          topRight: Radius.circular(AppConstants.radius_30),
        ),
        color: AppColors.whiteColor,
      ),
      padding: const EdgeInsets.only(
        top: AppConstants.padding_10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: 0.width),
                  Expanded(
                    flex: 4,
                    child: Text(
                      productDetails.first.productName ?? '',
                      style: AppStyles.rkBoldTextStyle(
                        size: AppConstants.normalFont,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: isFromBasketScreen?onCloseTap:(){
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 36,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
              5.height,
              Text(
                '${productDetails.first.numberOfUnit.toString()} ${AppLocalizations.of(context)!.unit_in_box} ',
                style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (productDetails.first.sale?.isSale ?? false)
                      ? Text.rich(
                          TextSpan(
                            text: isIncludedVat ? '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit} (${AppLocalizations.of(context)?.price_includes_vat}):' : '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}: ',
                            children: <TextSpan>[
                              TextSpan(
                                text: '${AppLocalizations.of(context)?.currency}${productUnitPrice.toStringAsFixed(2)} ',
                                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor).copyWith(decoration: TextDecoration.lineThrough),
                              ),
                              TextSpan(
                                text: ' ${AppLocalizations.of(context)?.currency}${double.parse(productDetails.first.sale?.salePrice ?? '').toStringAsFixed(2)}',
                                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.redColor),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          isIncludedVat ? '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}:${AppLocalizations.of(context)?.currency}${productUnitPrice.toStringAsFixed(2)} (${AppLocalizations.of(context)?.price_includes_vat})' : '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}:${AppLocalizations.of(context)?.currency}${productUnitPrice.toStringAsFixed(2)}',
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor),
                        ),
                ],
              ),
              productDetails.first.sale?.saleDescription != '' ? 8.height : 0.height,
              productDetails.first.sale?.saleDescription != ''
                  ? Container(
                      width: getScreenWidth(context) - 50,
                      padding: const EdgeInsets.all(3),
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(color: AppColors.saleBGColor, border: Border.all(color: AppColors.saleBGColor), borderRadius: BorderRadius.circular(AppConstants.radius_3)),
                      child: Text(
                        "${parse(productDetails.first.sale?.saleDescription).body?.text}",
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor, fontWeight: FontWeight.w500),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : 0.width,
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (productDetails.first.isPesach ?? false) ? 5.height : 0.height,
              (productDetails.first.isPesach ?? false)
                  ? Container(
                      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                      decoration: BoxDecoration(color: AppColors.pesachBGColor, border: Border.all(color: AppColors.pesachBGColor), borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: productDetails.first.nmMashlim != ''
                          ? Text('${AppLocalizations.of(context)!.pesach}, ${productDetails.first.nmMashlim}')
                          : Text(
                              AppLocalizations.of(context)!.pesach,
                              style: const TextStyle(fontSize: 12),
                            ))
                  : 0.height,
              (productDetails.first.isPesach ?? false) ? 5.height : 0.height,
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onPanUpdate: (detail) {
                      Navigator.pop(context);
                    },
                    onVerticalDragStart: (dragDetails) {
                    },
                    onVerticalDragUpdate: (dragDetails) {
                    },
                    onVerticalDragEnd: (endDetails) {
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppConstants.padding_10, right: AppConstants.padding_10, left: AppConstants.padding_10, top: AppConstants.padding_10),
                            child: productImages.first.isNotEmpty
                                ? GestureDetector(
                                    onTap: imageOnTap,
                                    child: Image.network(
                                      "${AppUrlEndPoints.baseFileUrl}${productImages.first}",
                                      height: getItemHeight( context, false) == 350.0 ? 200 :
                                      getItemHeight(context, false) == 260.0 ? 180 : 150,
                                      fit: BoxFit.contain,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress?.cumulativeBytesLoaded != loadingProgress?.expectedTotalBytes) {
                                          return CommonShimmerWidget(
                                            child: Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
                                              ),
                                            ),
                                          );
                                        }
                                        return child;
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          AppImagePath.imageNotAvailable5,
                                          fit: BoxFit.cover,
                                          // width: 90,
                                          height: getItemHeight( context, false) == 350.0 ? 200 :
                                          getItemHeight(context, false) == 260.0 ? 180 : 150,
                                        );
                                      },
                                    ),
                                  )
                                : Image.asset(
                                    AppImagePath.imageNotAvailable5,
                                    fit: BoxFit.cover,
                                    // width: 90,
                                    height: 150,
                                  ),
                            /* child: CarouselSlider(
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
                                              borderRadius: const BorderRadius.all(
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
                                    initialPage: productImageIndex,
                                    aspectRatio: 16 / 9,
                                    scrollDirection: Axis.horizontal,
                                    enableInfiniteScroll: false,
                                    autoPlayCurve: Curves.decelerate,
                                    pageSnapping: true)),*/
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    productDetails.first.qrcode ?? '',
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor),
                  ),
                  5.height,
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.borderColor.withOpacity(0.5), width: 1),
                        bottom: BorderSide(color: AppColors.borderColor.withOpacity(0.5), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                    child: productStock == '0' || productStock == "-1" || productStock == "0.0"
                        ? Column(
                            children: [
                              5.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.out_of_stock1,
                                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.redColor),
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
                                  SizedBox(
                                    width: getScreenWidth(context) >= 700 ? (getScreenWidth(context) - 30) / 3 : (getScreenWidth(context) - 30) / 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context)!.currency}${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(AppConstants.amountFrLength)}',
                                          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_30, color: AppColors.blackColor, fontWeight: FontWeight.w700),
                                        ),
                                        !isIncludedVat
                                            ? (productDetails.first.isBottle ?? false)
                                                ? Container(padding: const EdgeInsets.only(top: 3), child: Text('${AppLocalizations.of(context)?.bottle_deposit}:${AppLocalizations.of(context)!.currency}${totalBottleDeposit.toStringAsFixed(AppConstants.amountFrLength)}'))
                                                : 0.height
                                            : 0.width,
                                        isIncludedVat
                                            ? Text(
                                                '(${AppLocalizations.of(context)!.price_includes_vat})',
                                                style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.w400),
                                              )
                                            : 0.width,
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: getScreenWidth(context) >= 700 ? (getScreenWidth(context) - 30) / 3 : (getScreenWidth(context) - 30) / 2,
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
                                                topLeft: Radius.circular(context.rtl ? AppConstants.radius_5 : AppConstants.radius_50),
                                                bottomLeft: Radius.circular(context.rtl ? AppConstants.radius_5 : AppConstants.radius_50),
                                                bottomRight: Radius.circular(context.rtl ? AppConstants.radius_50 : AppConstants.radius_5),
                                                topRight: Radius.circular(context.rtl ? AppConstants.radius_50 : AppConstants.radius_5),
                                              ),
                                              border: Border.all(color: AppColors.navSelectedColor, width: 1),
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
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(AppConstants.radius_5),
                                                  bottomLeft: Radius.circular(AppConstants.radius_5),
                                                  bottomRight: Radius.circular(AppConstants.radius_5),
                                                  topRight: Radius.circular(AppConstants.radius_5),
                                                ),
                                                border: Border.all(color: AppColors.navSelectedColor, width: 1),
                                              ),
                                              alignment: Alignment.center,
                                              child: TextField(
                                                controller: TextEditingController(text: "$productQuantity")..selection = TextSelection.fromPosition(TextPosition(offset: "$productQuantity".length)),
                                                textAlign: TextAlign.center,
                                                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_26, color: AppColors.blackColor, fontWeight: FontWeight.w700),
                                                maxLength: 5,
                                                maxLines: 1,
                                                textInputAction: TextInputAction.done,
                                                keyboardType: Platform.isIOS ? const TextInputType.numberWithOptions(signed: true) : TextInputType.number,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                textDirection: TextDirection.ltr,
                                                onChanged: onQuantityChanged,
                                                cursorColor: AppColors.mainColor,
                                                decoration: const InputDecoration(border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, errorBorder: InputBorder.none, focusedErrorBorder: InputBorder.none, disabledBorder: InputBorder.none, filled: true, counterText: '', constraints: BoxConstraints(maxHeight: 50, minWidth: 50), fillColor: Colors.transparent, contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
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
                                                topLeft: Radius.circular(context.rtl ? AppConstants.radius_50 : AppConstants.radius_5),
                                                bottomLeft: Radius.circular(context.rtl ? AppConstants.radius_50 : AppConstants.radius_5),
                                                bottomRight: Radius.circular(context.rtl ? AppConstants.radius_5 : AppConstants.radius_50),
                                                topRight: Radius.circular(context.rtl ? AppConstants.radius_5 : AppConstants.radius_50),
                                              ),
                                              border: Border.all(color: AppColors.navSelectedColor, width: 1),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.remove, size: 26, color: AppColors.mainColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              (productDetails.first.sale?.saleMinQuantity != '0')
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      margin: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        '${AppLocalizations.of(context)!.minimum_box_title} : ${productDetails.first.sale?.saleMinQuantity}',
                                        style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.blackColor, fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  : 0.height,
                              (productDetails.first.sale?.isSale ?? false) && productDetails.first.sale?.saleMaxQuantity!='0'
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      margin: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        '${AppLocalizations.of(context)!.maximum_qty} : ${productDetails.first.sale?.saleMaxQuantity}',
                                        style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.blackColor, fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  : 0.height,
                              (productDetails.first.supplierSales?.first.lowStock != '') && (productStock != '0' || productStock != '0.0')
                                  ? Text(
                                      (productDetails.first.supplierSales?.first.lowStock.toString() ?? ''),
                                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.orangeColor),
                                    )
                                  : 0.height,
                              !isSubUserAddToBasket ? 13.height : 0.width,
                              isSubUserAddToBasket ? CommonProductDetailsButton(isLoading: isLoading, isSupplierAvailable: true, productStock: (productStock.toString()), onAddToOrderPressed: isLoading ? null : addToOrderTap) : 0.width,
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