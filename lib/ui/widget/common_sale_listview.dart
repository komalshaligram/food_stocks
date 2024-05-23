import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'common_product_button_widget.dart';

class CommonSaleListView extends StatelessWidget {
  final double? height;
      double discountedPrice;
  final String productImage;
  final String productName;

  final double price;
  final String productStock;
  final void Function() onButtonTap;
  final bool isGuestUser;
  final String numberOfUnits;
  final String lowStock;
  final bool? isPesach;
  final bool? isFromSale;
  final BuildContext context;
  final String? salesDesc;

   CommonSaleListView({
    this.height,
    required this.discountedPrice,
    required this.productImage,
    required this.productName,
    required this.price,
    required this.productStock,
    required this.onButtonTap,
    required this.isGuestUser,
    required this.numberOfUnits,
    required this.lowStock,
    this.isPesach,
    this.isFromSale,
    required this.context,
    this.salesDesc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            !isGuestUser ? productImage.isNotEmpty?  CachedNetworkImage(
              imageUrl: "${AppUrls.baseFileUrl}$productImage",
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
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppConstants.radius_10)),
                    ),
                  ),
                );
              },
              errorWidget: (context, error, stackTrace) {
                debugPrint('sale list image error : $error');
                return Container(
                  child: Image.asset(AppImagePath.imageNotAvailable5,
                      height: 70, width: 70, fit: BoxFit.cover),
                );
              },
            ) :
            Image.asset(AppImagePath.imageNotAvailable5 , height: 70,
              width: 70, ) :  Image.asset(AppImagePath.imageNotAvailable5 , height: 70,
              width: 70, ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width:getScreenWidth(context)/2.5,
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
                              (productStock) != '0' && lowStock.isEmpty ||   isGuestUser ? 0.width :
                              (productStock) == '0' && lowStock.isNotEmpty ?Text(
                                AppLocalizations.of(context)!
                                    .out_of_stock1,
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.redColor,
                                    fontWeight: FontWeight.w400),
                              ) : Text(
                                lowStock,
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.orangeColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              isPesach! ? 3.height :0.height,
                              isPesachLabelShow(isPesach!, context),
                              isPesach! ? 3.height :0.height,
                              !isGuestUser ? numberOfUnits != '0' ? Text(
                                '${numberOfUnits.toString()}${' '}${AppLocalizations.of(context)!.unit_in_box}',
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w400),
                              ) : 0.width : 0.width,
                            ],
                          ),
                        ),
                        !isGuestUser ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${AppLocalizations.of(context)?.currency}${price.toStringAsFixed(2)}',  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.redColor,fontWeight: FontWeight.w500).copyWith(decoration: TextDecoration.lineThrough,decorationColor: AppColors.redColor),),
                            2.height,
                            CommonProductButtonWidget(
                              title:
                              "${AppLocalizations.of(context)!.currency}${discountedPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : discountedPrice.toStringAsFixed(AppConstants.amountFrLength)}",
                              onPressed: onButtonTap,
                              textColor: AppColors.whiteColor,
                              bgColor: AppColors.mainColor,
                              borderRadius: AppConstants.radius_3,
                              textSize: AppConstants.font_14,
                              height: 32,
                              width: 80,
                            ),
                          ],
                        ) : 0.width,
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        salesDesc!.isNotEmpty?Container(
                          padding: EdgeInsets.all(3),
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(color: AppColors.saleBGColor, border: Border.all(color: AppColors.saleBGColor), borderRadius: BorderRadius.circular(AppConstants.radius_3)),
                          child: Text(
                            "${parse(salesDesc).body?.text}",
                            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.whiteColor,fontWeight: FontWeight.w500),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ):0.width,
                        !isGuestUser? numberOfUnits !='0' && price != 0.0 ? isFromSale!?Text.rich(TextSpan(
                          text: '${AppLocalizations.of(context)?.price_par_box} ',
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_12, color: AppColors.blackColor),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${AppLocalizations.of(context)?.currency}${(price * int.parse(numberOfUnits)).toStringAsFixed(2)} ',
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.font_12, color: AppColors.blackColor).copyWith(decoration: TextDecoration.lineThrough),
                            ),
                            TextSpan(
                              text: ' ${AppLocalizations.of(context)?.currency}${(price * int.parse(numberOfUnits)).toStringAsFixed(2)}',
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.font_12, color: AppColors.redColor),
                            ),
                          ],
                        ),
                        ) :Text(
                          '${AppLocalizations.of(context)?.price_par_box}${' '}${AppLocalizations.of(context)?.currency}${(price * int.parse(numberOfUnits)).toStringAsFixed(2)}',
                          style: AppStyles.rkBoldTextStyle(
                              size: AppConstants.font_12,
                              color: AppColors.blueColor,
                              fontWeight: FontWeight.w400),
                        ): 0.width : 0.width,
                      ],
                    )
                  ],
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }
}

