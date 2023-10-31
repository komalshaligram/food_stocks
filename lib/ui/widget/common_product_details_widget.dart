import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import 'common_product_button_widget.dart';

class CommonProductDetailsWidget extends StatelessWidget {
  final BuildContext context;
  final String productImage;
  final String productName;
  final String productCompanyName;
  final String productDescription;
  final String productSaleDescription;
  final double productPrice;
  final double productWeight;
  final int productQuantity;
  final ScrollController scrollController;
  final TextEditingController noteController;
  final void Function()? onAddToOrderPressed;
  final void Function() onQuantityIncreaseTap;
  final void Function() onQuantityDecreaseTap;
  final void Function(String)? onNoteChanged;
  final bool isRTL;
  final bool isLoading;

  const CommonProductDetailsWidget(
      {super.key,
      required this.context,
      required this.productImage,
      required this.productName,
      required this.productCompanyName,
      required this.productDescription,
      required this.productSaleDescription,
      required this.productPrice,
      required this.productWeight,
      required this.isRTL,
      required this.scrollController,
      required this.onAddToOrderPressed,
      required this.noteController,
      required this.productQuantity,
      required this.onQuantityIncreaseTap,
      required this.onQuantityDecreaseTap,
      this.onNoteChanged,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
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
          bottom: MediaQuery.of(context).viewInsets.bottom),
      clipBehavior: Clip.hardEdge,
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
          Center(
            child: Text(
              '${productWeight.toStringAsFixed(1)} | $productCompanyName',
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: AppColors.blackColor),
            ),
          ),
          10.height,
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.padding_10),
                      child: Image.network(
                        "${AppUrls.baseFileUrl}$productImage",
                        height: 150,
                        fit: BoxFit.fitHeight,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress?.cumulativeBytesLoaded !=
                              loadingProgress?.expectedTotalBytes) {
                            return CommonShimmerWidget(
                              child: Container(
                                height: 150,
                                width: 150,
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
                          }
                          return child;
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // debugPrint('product category list image error : $error');
                          return Image.asset(
                            AppImagePath.imageNotAvailable5,
                            fit: BoxFit.cover,
                            // width: 90,
                            height: 150,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: AppColors.borderColor.withOpacity(0.5),
                            width: 1),
                        bottom: BorderSide(
                            width: 1,
                            color: AppColors.borderColor.withOpacity(0.5)),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_15,
                        vertical: AppConstants.padding_20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$productPrice${AppLocalizations.of(context)!.currency}',
                              style: AppStyles.rkBoldTextStyle(
                                  size: AppConstants.font_30,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              productSaleDescription,
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.font_14,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: onQuantityIncreaseTap,
                              child: Container(
                                height: 50,
                                width: 50,
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
                                // padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_8),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add,
                                  size: 26,
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ),
                            5.width,
                            Container(
                              width: 80,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.iconBGColor,
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(AppConstants.radius_5),
                                  bottomLeft:
                                      Radius.circular(AppConstants.radius_5),
                                  bottomRight:
                                      Radius.circular(AppConstants.radius_5),
                                  topRight:
                                      Radius.circular(AppConstants.radius_5),
                                ),
                                border: Border.all(
                                    color: AppColors.navSelectedColor,
                                    width: 1),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$productQuantity',
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.font_30,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            5.width,
                            GestureDetector(
                              onTap: onQuantityDecreaseTap,
                              child: Container(
                                height: 50,
                                width: 50,
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
                                    size: 26, color: AppColors.mainColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppColors.borderColor.withOpacity(0.5),
                                width: 1))),
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.padding_10,
                        horizontal: AppConstants.padding_20),
                    child: Row(
                      children: [],
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 5,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'Sale',
                    //             style: AppStyles.rkBoldTextStyle(
                    //                 size: AppConstants.font_30,
                    //                 color: AppColors.saleRedColor,
                    //                 fontWeight: FontWeight.w700),
                    //           ),
                    //           5.height,
                    //           Text(
                    //             productDescription,
                    //             style: AppStyles.rkRegularTextStyle(
                    //                 size: AppConstants.font_14,
                    //                 color: AppColors.blackColor,
                    //                 fontWeight: FontWeight.w400),
                    //             maxLines: 3,
                    //             overflow: TextOverflow.ellipsis,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Expanded(flex: 2, child: 0.height),
                    //   ],
                    // ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: AppConstants.padding_20,
                        horizontal: AppConstants.padding_20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.note,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14,
                              color: AppColors.blackColor),
                        ),
                        10.height,
                        Container(
                          // height: 120,
                          width: getScreenWidth(context),
                          padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_10),
                          decoration: BoxDecoration(
                              color: AppColors.notesBGColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConstants.radius_5))),
                          child: TextField(
                            controller: noteController,
                            onChanged: onNoteChanged,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            maxLines: 5,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.padding_20),
                    child: CommonProductButtonWidget(
                      title: AppLocalizations.of(context)!.add_to_order,
                      isLoading: isLoading,
                      onPressed: onAddToOrderPressed,
                      width: double.maxFinite,
                      height: AppConstants.buttonHeight,
                      borderRadius: AppConstants.radius_5,
                      textSize: AppConstants.normalFont,
                      textColor: AppColors.whiteColor,
                      bgColor: AppColors.mainColor,
                    ),
                  ),
                  // 160.height,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
