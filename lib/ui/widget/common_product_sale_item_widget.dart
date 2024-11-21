import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
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
  final double? originalPrice;
  final String lowStock;
  final bool? isPesach;
  final String productStock;
  final bool? isSale;

  const CommonProductSaleItemWidget({
    super.key,
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_5),
      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_5),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onButtonTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: !isGuestUser
                        ? saleImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: "${AppUrlEndPoints.baseFileUrl}$saleImage",
                                height: getItemHeight( context, false) == 260 ? 125 :
                                getItemHeight(context, false) == 350 ? 190 : imageHeight,
                                fit: BoxFit.fitHeight,
                                placeholder: (context, url) {
                                  return CommonShimmerWidget(
                                    child: Container(
                                      height: imageHeight,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
                                      ),
                                    ),
                                  );
                                },
                                errorWidget: (context, error, stackTrace) {
                                  return Image.asset(AppImagePath.imageNotAvailable5,
                                      height: isTablet(context) ? 110 : imageHeight, width: double.maxFinite, fit: BoxFit.cover);
                                },
                              )
                            : Image.asset(
                                AppImagePath.imageNotAvailable5,
                                height: isTablet(context) ? 110 : imageHeight,
                                width: 70,
                              )
                        : Image.asset(
                            AppImagePath.imageNotAvailable5,
                            height: isTablet(context) ? 110 : imageHeight,
                            width: 70,
                          ),
                  ),
                  2.height,
                  Text(
                    productName,
                    style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.height,
                  description.isNotEmpty
                      ? Center(
                          child: Container(
                            width: width! - 10,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(color: AppColors.saleBGColor, border: Border.all(color: AppColors.saleBGColor), borderRadius: BorderRadius.circular(AppConstants.radius_3)),
                            child: Text(
                              "${parse(description).body?.text}",
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_10,
                                color: AppColors.whiteColor,
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      : 0.height,
                  isGuestUser
                      ? 0.height
                      : (productStock) == '0' || productStock == '0.0'
                          ? Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                AppLocalizations.of(context)!.out_of_stock1,
                                textAlign: TextAlign.center,
                                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.redColor, fontWeight: FontWeight.w400),
                              ),
                            )
                          : lowStock.isNotEmpty
                              ? Text(lowStock, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.orangeColor, fontWeight: FontWeight.w400))
                              : 0.width,
                  1.height,
                  Center(child: isPesachLabelShow(isPesach!, context)),
                  isPesach! ? 2.height : 0.height,
                  !isGuestUser
                      ? isSale!
                          ? Center(
                            child: Text(
                              "${AppLocalizations.of(context)!.currency}${originalPrice?.toStringAsFixed(2)}",
                              style: AppStyles.rkBoldTextStyle(
                                size: AppConstants.font_12,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w600,
                              ).copyWith(decoration: TextDecoration.lineThrough),
                            ),
                          )
                          : 0.width
                      : 0.width,
                ],
              ),
            ),
            !isGuestUser
                ? Center(
                    child: CommonProductButtonWidget(
                      title: isSale! ? "${AppLocalizations.of(context)!.currency}${discountedPrice.toStringAsFixed(2)}" : "${AppLocalizations.of(context)!.currency}${originalPrice?.toStringAsFixed(2)}",
                      onPressed: onButtonTap,
                      // height: 35,
                      width: 110,
                      textColor: AppColors.whiteColor,
                      bgColor: AppColors.mainColor,
                      borderRadius: AppConstants.radius_3,
                      textSize: AppConstants.font_12,
                    ),
                  )
                : 0.width
          ],
        ),
      ),
    );
  }
}
