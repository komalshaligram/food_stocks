import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import 'common_product_button_widget.dart';
import 'common_shimmer_widget.dart';

class CommonProductItemWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String productImage;
  final String productName;
  final int totalSaleCount;
  final dynamic price;
  final dynamic productStock;
  final void Function() onButtonTap;

  const CommonProductItemWidget(
      {super.key,
      this.height,
      this.width,
      required this.productImage,
      required this.productName,
      required this.totalSaleCount,
      required this.price,
      required this.onButtonTap, this.productStock = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
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
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onButtonTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: "${AppUrls.baseFileUrl}$productImage",
                height: 69,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) {
                  return CommonShimmerWidget(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_10)),
                      ),
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
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
              productName,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            2.height,
            Expanded(
              child: totalSaleCount == 0
                  ? 0.width
                  : Text(
                      "${totalSaleCount} ${AppLocalizations.of(context)!.discount}",
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_10,
                          color: AppColors.saleRedColor,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
            ),
            (productStock) != 0 ? 0.width :Text(
              AppLocalizations.of(context)!
                  .out_of_stock1,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12,
                  color: AppColors.redColor,
                  fontWeight: FontWeight.w400),
            ),
            3.height,
            Center(
              child: CommonProductButtonWidget(
                width: 110,
                title:
                    "${AppLocalizations.of(context)!.currency}${price.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : price.toStringAsFixed(AppConstants.amountFrLength)}",
                onPressed: onButtonTap,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
