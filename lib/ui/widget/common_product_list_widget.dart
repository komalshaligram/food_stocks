import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import 'common_product_button_widget.dart';
import 'common_shimmer_widget.dart';

class CommonProductListWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String productImage;
  final String productName;
  final int totalSaleCount;
  final dynamic price;
  final dynamic productStock;
  final void Function() onButtonTap;
   CommonProductListWidget({super.key,
     this.height,
     this.width,
     required this.productImage,
     required this.productName,
     required this.totalSaleCount,
     required this.price,
     required this.onButtonTap, this.productStock = 0
   });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:double.maxFinite,
    //  height: 150,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedNetworkImage(
            imageUrl: "${AppUrls.baseFileUrl}$productImage",
            height: 70,
            width: 70,
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
                    height: 70, width: 70, fit: BoxFit.cover),
              );
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: AppConstants.padding_15,
                horizontal: AppConstants.padding_10),
            width: 150,
         //   height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.smallFont,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                totalSaleCount == 0
                    ? 0.width
                    : Text(
                  "${totalSaleCount} ${AppLocalizations.of(context)!.discount}",
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_12,
                      color: AppColors.saleRedColor,
                      fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                (productStock) != 0 ? 0.width :Text(
                  AppLocalizations.of(context)!
                      .out_of_stock1,
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_14,
                      color: AppColors.redColor,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),

          CommonProductButtonWidget(
            title:
            "${AppLocalizations.of(context)!.currency}${price.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : price.toStringAsFixed(AppConstants.amountFrLength)}",
            onPressed: onButtonTap,
            textColor: AppColors.whiteColor,
            bgColor: AppColors.mainColor,
            borderRadius: AppConstants.radius_3,
            textSize: AppConstants.font_14,
            height: 32,
            width: 100,
          ),
        ],
      ),
    );
  }
}