import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import 'common_product_button_widget.dart';
import 'common_shimmer_widget.dart';

class CommonProductSaleItemWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String saleImage;
  final String title;
  final String description;
  final String productName;
  final double discountedPrice;
  final void Function() onButtonTap;
  final bool isGuestUser;
  final double? imageHeight;
  final double? imageWidth;
  final dynamic originalPrice;
  final String lowStock;
  final bool? isPesach;
  final String productStock;
  final bool? isSale;
  final int? quantity;
  final void Function()? onQuantityChanged;
  final void Function()? onQuantityIncreaseTap;
  final void Function()? onQuantityDecreaseTap;
  final VoidCallback? onGuestLoginRequired;
  final String? minQuantity;
  final String? maxQuantity;
  final bool? isMixedSale;
  final String? numberOfUnits;
  final String? scaleType;

  const CommonProductSaleItemWidget(
      {super.key,
      this.height,
      this.width,
      required this.saleImage,
      required this.title,
      required this.description,
      required this.productName,
      required this.onButtonTap,
      required this.discountedPrice,
      this.isGuestUser = false,
      this.imageHeight = 80,
      this.imageWidth = 80,
      this.originalPrice = 0.0,
      this.lowStock = '',
      this.isPesach = false,
      required this.isSale,
      this.productStock = '0',
      this.quantity = 0,
      this.onQuantityChanged,
      this.onQuantityIncreaseTap,
      this.onQuantityDecreaseTap,
      this.onGuestLoginRequired,
      this.minQuantity,
      this.maxQuantity,
      required this.isMixedSale,
      required this.numberOfUnits,
      required this.scaleType});

  void _onQuantityIncrease() {
    if (isGuestUser) {
      onGuestLoginRequired?.call();
      return;
    }
    onQuantityIncreaseTap?.call();
  }

  void _onQuantityDecrease() {
    if (isGuestUser) {
      onGuestLoginRequired?.call();
      return;
    }
    onQuantityDecreaseTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final double productImageHeight = getItemHeight(context, false) == 350.0
        ? 190
        : getItemHeight(context, false) == 260.0
            ? 125
            : imageHeight ?? 80;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)]),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_5),
      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_5),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onButtonTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Stack(clipBehavior: Clip.none, children: [
              Center(
                  child:
                      // !isGuestUser
                      //     ?
                      saleImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: "${AppUrlEndPoints.baseFileUrl}$saleImage",
                              height: productImageHeight,
                              fit: BoxFit.fitHeight,
                              placeholder: (context, url) {
                                return CommonShimmerWidget(
                                  child: Container(
                                    height: productImageHeight,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10))),
                                  ),
                                );
                              },
                              errorWidget: (context, error, stackTrace) {
                                return Image.asset(AppImagePath.imageNotAvailable5, height: productImageHeight, width: 70, fit: BoxFit.cover);
                              })
                          : Image.asset(AppImagePath.imageNotAvailable5, height: productImageHeight, width: 70)
                  // : Image.asset(AppImagePath.imageNotAvailable5,
                  //     height: productImageHeight, width: 70),
                  ),
              if (isSale == true)
                Positioned(
                  top: 12,
                  left: -48,
                  child: Transform.rotate(
                    angle: -0.75,
                    child: Container(
                      width: 125,
                      height: 18,
                      alignment: Alignment.center,
                      color: AppColors.orangeColor,
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(4, -1.5),
                          child: Text("מבצע",
                              textAlign: TextAlign.center,
                              style: AppStyles.rkBoldTextStyle(size: 9, color: AppColors.whiteColor, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ),
                ),
              if (isPesach == true)
                Positioned(
                  top: 12,
                  right: -48,
                  child: Transform.rotate(
                    angle: 0.75,
                    child: Container(
                      width: 125,
                      height: 18,
                      alignment: Alignment.center,
                      color: AppColors.pesachBGColor,
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(-4, -1.5),
                          child: Text('כשל"פ',
                              textAlign: TextAlign.center,
                              style: AppStyles.rkBoldTextStyle(size: 9, color: AppColors.blackColor, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ),
                ),
            ]),
            Text(productName,
                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if (!isGuestUser)
              Visibility(
                visible: numberOfUnits != '0',
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Center(
                  child: Text(
                      scaleType == 'מארזים'
                          ? '${numberOfUnits.toString()} ${AppLocalizations.of(context)!.unit_in_box}'
                          : scaleType == 'Units'
                              ? AppLocalizations.of(context)!.sold_units
                              : '${AppLocalizations.of(context)!.approx}${' '}${numberOfUnits.toString()}${' '}${AppLocalizations.of(context)!.kgBox}',
                      style: AppStyles.rkBoldTextStyle(size: AppConstants.font_10, color: AppColors.blackColor, fontWeight: FontWeight.w400)),
                ),
              ),
            1.height,
            if (!isGuestUser)
              Visibility(
                visible: isSale == true,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Center(
                  child: Text("${AppLocalizations.of(context)!.currency}${originalPrice?.toStringAsFixed(2)}",
                      style: AppStyles.rkBoldTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ).copyWith(decoration: TextDecoration.lineThrough)),
                ),
              ),
          ]),
          !isGuestUser
              ? Center(
                  child: CommonProductButtonWidget(
                      title: isSale == true
                          ? "${AppLocalizations.of(context)!.currency}${discountedPrice.toStringAsFixed(2)}"
                          : "${AppLocalizations.of(context)!.currency}"
                              "${originalPrice?.toStringAsFixed(2)}",
                      onPressed: onButtonTap,
                      width: 110,
                      textColor: AppColors.whiteColor,
                      bgColor: AppColors.mainColor,
                      borderRadius: AppConstants.radius_3,
                      textSize: AppConstants.font_12),
                )
              : 0.width,
          isGuestUser
              ? 0.height
              : (productStock == '0' || productStock == '0.0')
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: AppConstants.padding_5),
                      child: Text(AppLocalizations.of(context)!.out_of_stock1,
                          textAlign: TextAlign.center,
                          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.redColor, fontWeight: FontWeight.w400)),
                    )
                  : lowStock.isNotEmpty
                      ? Center(
                          child: Text(lowStock,
                              style:
                                  AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.orangeColor, fontWeight: FontWeight.w400)),
                        )
                      : 0.width,
          if (isSale! && minQuantity.toString() != '0' && maxQuantity.toString() != '100')
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                  '${AppLocalizations.of(context)!.minGrid}: ${minQuantity.toString()} / ${AppLocalizations.of(context)!.maxGrid}: ${maxQuantity.toString()}',
                  style: AppStyles.rkRegularTextStyle(color: AppColors.redColor, size: AppConstants.font_10)),
            ])
          else if (isSale! && maxQuantity.toString() == '100' && minQuantity.toString() != '0')
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${AppLocalizations.of(context)!.minimumGrid}: ${minQuantity.toString()}',
                  style: AppStyles.rkRegularTextStyle(color: AppColors.redColor, size: AppConstants.font_10)),
            ])
          else if (isSale! && minQuantity.toString() == '0' && maxQuantity.toString() != '0' && maxQuantity.toString() != '100')
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${AppLocalizations.of(context)!.maximumGrid}: ${maxQuantity.toString()}',
                  style: AppStyles.rkRegularTextStyle(color: AppColors.redColor, size: AppConstants.font_10)),
            ]),
          isMixedSale == true
              ? Center(
                  child: Text(AppLocalizations.of(context)!.mixedSale,
                      style: AppStyles.rkRegularTextStyle(color: AppColors.redColor, size: AppConstants.font_10)),
                )
              : const IgnorePointer(),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(
                  onTap: _onQuantityIncrease,
                  child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppConstants.radius_2),
                          border: Border.all(color: AppColors.greyColor),
                          color: AppColors.pageColor),
                      child: const Icon(Icons.add, size: 20)),
                ),
                Text(quantity.toString(), style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.font_17)),
                GestureDetector(
                  onTap: _onQuantityDecrease,
                  child: Container(
                      alignment: Alignment.center,
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppConstants.radius_3),
                          border: Border.all(color: AppColors.greyColor),
                          color: AppColors.pageColor),
                      child: const Icon(Icons.remove, size: 20)),
                ),
              ])),
          5.height,
        ]),
      ),
    );
  }
}
