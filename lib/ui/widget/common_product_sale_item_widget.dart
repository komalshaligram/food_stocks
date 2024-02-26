import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
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
  final double salePercentage;
  final double discountedPrice;
  final void Function() onButtonTap;
  final bool isGuestUser;
  final double? imageHeight;
  final double? imageWidth;

  const CommonProductSaleItemWidget(
      {super.key,
      this.height,
      this.width,
      required this.saleImage,
      required this.title,
      required this.description,
      required this.salePercentage,
        required this.productName,
      required this.onButtonTap,
      required this.discountedPrice,
        this.isGuestUser = false,
        this.imageHeight = 70,
        this.imageWidth = 70,
      });

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: !isGuestUser ? CachedNetworkImage(
                imageUrl: "${AppUrls.baseFileUrl}$saleImage",
                height: imageHeight,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) {
                  return CommonShimmerWidget(
                    child: Container(
                      height: imageHeight,
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_10)),
                      ),
                      // alignment: Alignment.center,
                      // child: CupertinoActivityIndicator(
                      //   color: AppColors.blackColor,
                      // ),
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  // debugPrint('sale list image error : $error');
                  return Container(
                    child: Image.asset(AppImagePath.imageNotAvailable5,
                        height: imageHeight, width: double.maxFinite, fit: BoxFit.cover),
                  );
                },
              ) :
              Image.asset(AppImagePath.imageNotAvailable5,
                height: imageHeight,
                width: 70,
              ),
            ),
            5.height,
            Text(
              productName,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
                "${parse(description).body?.text}",
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_10, color: AppColors.blackColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            5.height,


            !isGuestUser ?  Center(
              child: CommonProductButtonWidget(
                title:
                    "${AppLocalizations.of(context)!.currency}${discountedPrice.toStringAsFixed(2)}" ,
                onPressed: onButtonTap,
                // height: 35,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_12,
              ),
            ): 0.width
          ],
        ),
      ),
    );
  }
}
