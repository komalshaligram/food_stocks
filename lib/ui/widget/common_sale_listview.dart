import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';

class CommonSaleListView extends StatelessWidget {
  final double? height;
  final double discountedPrice;
  final String productImage;
  final String productName;
  final dynamic price;
  final String productStock;
  final void Function() onButtonTap;
  final bool isGuestUser;
  final String numberOfUnits;
  final String? scaleType;
  final String lowStock;
  final bool? isPesach;
  final bool? isFromSale;
  final BuildContext context;
  final String? salesDesc;
  final int? quantity;
  final void Function()? onQuantityChanged;
  final void Function()? onQuantityIncreaseTap;
  final void Function()? onQuantityDecreaseTap;
  final String? minQuantity;
  final String? maxQuantity;
  final bool? isMixedSale;

  const CommonSaleListView({
    super.key,
    this.height,
    required this.discountedPrice,
    required this.productImage,
    required this.productName,
    required this.price,
    required this.productStock,
    required this.onButtonTap,
    required this.isGuestUser,
    required this.numberOfUnits,
    required this.scaleType,
    required this.lowStock,
    this.isPesach,
    this.isFromSale,
    required this.context,
    this.salesDesc,
    this.quantity,
    this.onQuantityChanged,
    this.onQuantityIncreaseTap,
    this.onQuantityDecreaseTap,
    this.minQuantity,
    this.maxQuantity,
    required this.isMixedSale,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.15),
                blurRadius: AppConstants.blur_10)
          ],
        ),
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(
            vertical: AppConstants.padding_10,
            horizontal: AppConstants.padding_5),
        padding: const EdgeInsets.symmetric(
            vertical: AppConstants.padding_5,
            horizontal: AppConstants.padding_10),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          // !isGuestUser
          //     ?
          productImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: "${AppUrlEndPoints.baseFileUrl}$productImage",
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,
                      placeholder: (context, url) {
                        return CommonShimmerWidget(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppConstants.radius_10))),
                          ),
                        );
                      },
                      errorWidget: (context, error, stackTrace) {
                        return Image.asset(AppImagePath.imageNotAvailable5,
                            height: 70, width: 70, fit: BoxFit.cover);
                      })
                  : Image.asset(AppImagePath.imageNotAvailable5,
                      height: 70, width: 70),
              // : Image.asset(AppImagePath.imageNotAvailable5,
              //     height: 70, width: 70),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: getScreenWidth(context) / 1.5,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName,
                                      style: AppStyles.rkBoldTextStyle(
                                          size: AppConstants.font_14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    isGuestUser
                                        ? 0.height
                                        : (productStock) == '0' ||
                                                productStock == '0.0'
                                            ? Text(
                                                AppLocalizations.of(context)!
                                                    .out_of_stock1,
                                                textAlign: TextAlign.center,
                                                style:
                                                    AppStyles.rkBoldTextStyle(
                                                        size: AppConstants
                                                            .font_12,
                                                        color:
                                                            AppColors.redColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              )
                                            : lowStock.isNotEmpty
                                                ? Text(lowStock,
                                                    style: AppStyles
                                                        .rkBoldTextStyle(
                                                            size: AppConstants
                                                                .font_12,
                                                            color: AppColors
                                                                .orangeColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400))
                                                : 0.width,
                                    isPesach! ? 3.height : 0.height,
                                    isPesachLabelShow(isPesach!, context),
                                    isPesach! ? 3.height : 0.height,
                                    1.height,
                                    !isGuestUser
                                        ? numberOfUnits != '0'
                                            ? Text(
                                                scaleType == 'מארזים'
                                                    ? '${numberOfUnits.toString()} ${AppLocalizations.of(context)!.unit_in_box}'
                                                    : scaleType == 'Units'
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .sold_units
                                                        : '${AppLocalizations.of(context)!.approx}${' '}${numberOfUnits.toString()}${' '}${AppLocalizations.of(context)!.kgBox}',
                                                style:
                                                    AppStyles.rkBoldTextStyle(
                                                  size: AppConstants.font_12,
                                                  color: AppColors.blackColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            : 0.width
                                        : 0.width,
                                    1.height,
                                  ]),
                            ),
                          ]),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (salesDesc!.isNotEmpty)
                              Container(
                                width: MediaQuery.of(context).size.width / 1.6,
                                padding: const EdgeInsets.all(
                                    AppConstants.padding_3),
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    color: AppColors.saleBGColor,
                                    border: Border.all(
                                        color: AppColors.saleBGColor),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radius_3)),
                                child: Text(
                                  "${parse(salesDesc).body?.text}",
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_12,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              )
                            else
                              0.width,
                            if (!isGuestUser && price != 0.0)
                              scaleType == 'Units'
                                  ? (isFromSale == true
                                      ? Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${AppLocalizations.of(context)?.currency}${(price as num).toStringAsFixed(2)} ',
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                  size: AppConstants.font_12,
                                                  color: AppColors.blackColor,
                                                ).copyWith(
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${AppLocalizations.of(context)?.currency}${discountedPrice.toStringAsFixed(2)}',
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                  size: AppConstants.font_12,
                                                  color: AppColors.redColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          '${AppLocalizations.of(context)?.currency}${(price as num).toStringAsFixed(2)}',
                                          style: AppStyles.rkBoldTextStyle(
                                            size: AppConstants.font_12,
                                            color: AppColors.blueColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ))
                                  : (numberOfUnits != '0'
                                      ? (isFromSale == true
                                          ? Text.rich(
                                              TextSpan(
                                                text:
                                                    '${AppLocalizations.of(context)?.price_par_box} ',
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                  size: AppConstants.font_12,
                                                  color: AppColors.blackColor,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${AppLocalizations.of(context)?.currency}${(price * int.parse(numberOfUnits)).toStringAsFixed(2)} ',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                      size:
                                                          AppConstants.font_12,
                                                      color:
                                                          AppColors.blackColor,
                                                    ).copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        ' ${AppLocalizations.of(context)?.currency}${(discountedPrice * int.parse(numberOfUnits)).toStringAsFixed(2)}',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                      size:
                                                          AppConstants.font_12,
                                                      color: AppColors.redColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Text(
                                              '${AppLocalizations.of(context)?.price_par_box} ${AppLocalizations.of(context)?.currency}${(price * int.parse(numberOfUnits)).toStringAsFixed(2)}',
                                              style: AppStyles.rkBoldTextStyle(
                                                size: AppConstants.font_12,
                                                color: AppColors.blueColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ))
                                      : const SizedBox.shrink()),
                          ]),
                      5.height,
                      if (isFromSale! &&
                          minQuantity != '0' &&
                          maxQuantity != '100')
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.minimumList}: ${minQuantity.toString()}',
                                style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.redColor,
                                    size: AppConstants.font_14),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.maximumList}: ${maxQuantity.toString()}',
                                style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.redColor,
                                    size: AppConstants.font_14),
                              )
                            ])
                      else if (isFromSale! &&
                          maxQuantity == '100' &&
                          minQuantity.toString() != '0')
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.minimumList}: ${minQuantity.toString()}',
                                style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.redColor,
                                    size: AppConstants.font_14),
                              ),
                            ])
                      else if (isFromSale! &&
                          minQuantity.toString() == '0' &&
                          maxQuantity.toString() != '0' &&
                          maxQuantity.toString() != '100')
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.maximumList}: ${maxQuantity.toString()}',
                                style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.redColor,
                                    size: AppConstants.font_14),
                              ),
                            ])
                      else if (isFromSale! &&
                          minQuantity.toString() == '0' &&
                          maxQuantity.toString() == '0')
                        const IgnorePointer()
                      else
                        const IgnorePointer(),
                      isMixedSale!
                          ? Center(
                              child: Text(
                                  AppLocalizations.of(context)!.mixedSale,
                                  style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.redColor,
                                      size: AppConstants.font_14)),
                            )
                          : const IgnorePointer(),
                      5.height,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: onQuantityIncreaseTap,
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radius_2),
                                  border:
                                      Border.all(color: AppColors.greyColor),
                                  color: AppColors.pageColor,
                                ),
                                child: const Icon(Icons.add, size: 15),
                              ),
                            ),
                            15.width,
                            Text(quantity.toString(),
                                style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.blackColor,
                                    size: AppConstants.font_17)),
                            15.width,
                            GestureDetector(
                              onTap: onQuantityDecreaseTap,
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radius_3),
                                  border:
                                      Border.all(color: AppColors.greyColor),
                                  color: AppColors.pageColor,
                                ),
                                child: const Icon(Icons.remove, size: 15),
                              ),
                            )
                          ]),
                      5.height,
                    ]),
              ]),
        ]),
      ),
    );
  }
}
