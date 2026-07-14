import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import '../../data/model/search_model/search_model.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';

class SearchItemWidget extends StatelessWidget {
  const SearchItemWidget({
    super.key,
    required this.isShowSearchLabel,
    required this.searchType,
    required this.isMoreResults,
    required this.isLastItem,
    required this.isPesach,
    required this.saleDesc,
    required this.productStock,
    required this.lowStock,
    required this.onTap,
    required this.onSeeAllTap,
    required this.context,
    required this.searchName,
    required this.searchImage,
    required this.isGuestUser,
    required this.numberOfUnits,
    this.scaleType,
    required this.priceOfBox,
    required this.salePrice,
    required this.isShowSeeAll,
    this.quantity = 0,
    this.onQuantityChanged,
    this.onQuantityIncreaseTap,
    this.onQuantityDecreaseTap,
    this.isSale,
    this.minQuantity,
    this.maxQuantity,
    required this.isMixedSale,
  });

  final String lowStock;
  final BuildContext context;
  final String searchName;
  final String searchImage;
  final SearchTypes searchType;
  final bool isShowSearchLabel;
  final bool isMoreResults;
  final bool? isLastItem;
  final String productStock;
  final bool isGuestUser;
  final int numberOfUnits;
  final String? scaleType;
  final bool isPesach;
  final Function() onTap;
  final Function() onSeeAllTap;
  final String saleDesc;
  final double priceOfBox;
  final double salePrice;
  final bool isShowSeeAll;
  final int? quantity;
  final void Function()? onQuantityChanged;
  final void Function()? onQuantityIncreaseTap;
  final void Function()? onQuantityDecreaseTap;
  final bool? isSale;
  final String? minQuantity;
  final String? maxQuantity;
  final bool? isMixedSale;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
      isShowSearchLabel
          ? Padding(
              padding: const EdgeInsets.only(left: AppConstants.padding_20, right: AppConstants.padding_20, top: AppConstants.padding_15, bottom: AppConstants.padding_5),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  searchType == SearchTypes.category
                      ? AppLocalizations.of(context)!.categories
                      : searchType == SearchTypes.subCategory
                          ? AppLocalizations.of(context)!.sub_categories
                          : searchType == SearchTypes.company
                              ? AppLocalizations.of(context)!.brands
                              : searchType == SearchTypes.sale
                                  ? AppLocalizations.of(context)!.sales
                                  : searchType == SearchTypes.supplier
                                      ? AppLocalizations.of(context)!.suppliers
                                      : AppLocalizations.of(context)!.products,
                  style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.w500),
                ),
                isMoreResults
                    ? GestureDetector(
                        onTap: onSeeAllTap,
                        child: Text(AppLocalizations.of(context)!.see_all, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.mainColor)),
                      )
                    : 0.width,
              ]),
            )
          : 0.width,
      InkWell(
        onTap: onTap,
        child: Container(
          height: (searchType == SearchTypes.category || searchType == SearchTypes.subCategory || searchType == SearchTypes.company)
              ? 80
              : double.parse(productStock.toString()) > 0 || lowStock.isEmpty
                  ? isPesach
                      ? 230
                      : salePrice != 0.0
                          ? minQuantity != '0' || maxQuantity != '0' && isMixedSale == true
                              ? 220
                              : 195
                          : 150
                  : isPesach
                      ? 130
                      : salePrice != 0.0
                          ? minQuantity != '0' || maxQuantity != '0' && isMixedSale == true
                              ? 220
                              : 150
                          : 140,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border(bottom: (isLastItem ?? false) ? BorderSide.none : BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5), width: 1)),
          ),
          padding: EdgeInsets.only(
            top: AppConstants.padding_5,
            left: getScreenHeight(context) > 850 ? AppConstants.padding_20 : AppConstants.padding_10,
            right: getScreenHeight(context) > 850 ? AppConstants.padding_20 : AppConstants.padding_10,
            bottom: AppConstants.padding_5,
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              height: getItemHeight(context, false) == 350
                  ? 120
                  : getItemHeight(context, false) == 260
                  ? 100
                  : 60,
              width: getItemWidth(context) == 190
                  ? 130
                  : getItemWidth(context) == 160
                  ? 100
                  : 50,
              child: !isGuestUser
                  ? Image.network('${AppUrlEndPoints.baseFileUrl}$searchImage', fit: BoxFit.scaleDown, loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const SizedBox(height: 60, width: 50, child: CupertinoActivityIndicator());
                      }
                    }, errorBuilder: (context, error, stackTrace) {
                      return searchType == SearchTypes.subCategory
                          ? Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover)
                          : SvgPicture.asset(
                              AppImagePath.splashLogo,
                              fit: BoxFit.scaleDown,
                            );
                    })
                  : Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover),
            ),
            10.width,
            Column(mainAxisAlignment: searchType == SearchTypes.category || searchType == SearchTypes.subCategory || searchType == SearchTypes.company ? MainAxisAlignment.center : MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: getScreenWidth(context) / 1.5,
                child: Text(
                  searchName,
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor),
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                ),
              ),
              Row(children: [
                SizedBox(
                  width: 200,
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    searchType == SearchTypes.category || searchType == SearchTypes.subCategory || searchType == SearchTypes.company
                        ? 0.width
                        : double.parse(productStock) > 0 && lowStock.isEmpty
                            ? 0.width
                            : (productStock == '0' || productStock == '0.0')
                                ? Text(
                                    AppLocalizations.of(context)!.out_of_stock1,
                                    style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.redColor, fontWeight: FontWeight.w400),
                                  )
                                : Text(
                                    lowStock,
                                    style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.orangeColor, fontWeight: FontWeight.w400),
                                  ),
                    numberOfUnits != 0
                        ? scaleType == 'מארזים'
                            ? Text(
                                '${numberOfUnits.toString()} ${AppLocalizations.of(context)!.unit_in_box}',
                                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w400),
                              )
                            : Text(
                                '${AppLocalizations.of(context)!.approx}${' '}${numberOfUnits.toString()}${' '}${AppLocalizations.of(context)!.kgBox}',
                                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w400),
                              )
                        : 0.width,
                    !isGuestUser
                        ? numberOfUnits != 0 && priceOfBox != 0.0
                            ? salePrice != 0.0
                                ? Text.rich(
                                    TextSpan(
                                      text: '${AppLocalizations.of(context)?.price_par_box} ',
                                      style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '${AppLocalizations.of(context)?.currency}${(priceOfBox * (numberOfUnits)).toStringAsFixed(2)} ',
                                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor).copyWith(
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ${AppLocalizations.of(context)?.currency}${(salePrice * (numberOfUnits)).toStringAsFixed(2)}',
                                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.redColor),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    '${AppLocalizations.of(context)?.price_par_box}${' '}${AppLocalizations.of(context)?.currency}'
                                    '${(priceOfBox * numberOfUnits).toStringAsFixed(2)}',
                                    style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blueColor, fontWeight: FontWeight.w400),
                                  )
                            : 0.width
                        : 0.width
                  ]),
                ),
                !isGuestUser
                    ? salePrice != 0.0
                        ? Column(
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.currency}${priceOfBox.toString()}',
                                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blueColor, fontWeight: FontWeight.w400).copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.currency}${salePrice.toString()}',
                                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.redColor, fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        : !isGuestUser
                            ? priceOfBox != 0.0
                                ? SizedBox(
                                    width: 60,
                                    child: Text(
                                      '${AppLocalizations.of(context)!.currency}${priceOfBox.toString()}',
                                      style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blueColor, fontWeight: FontWeight.w400),
                                    ),
                                  )
                                : 0.width
                            : 0.width
                    : 0.width,
              ]),
              3.height,
              isPesach ? isPesachLabelShow(isPesach, context) : 0.height,
              saleDesc.isNotEmpty
                  ? Container(
                      width: getScreenWidth(context) / 1.5,
                      padding: const EdgeInsets.all(3),
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: AppColors.saleBGColor,
                        border: Border.all(color: AppColors.saleBGColor),
                        borderRadius: BorderRadius.circular(AppConstants.radius_3),
                      ),
                      child: Center(
                        child: Text(
                          "${parse(saleDesc).body?.text}",
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.whiteColor),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : 0.height,
              5.height,
              isSale!
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        minQuantity != '0'
                            ? Text(
                                '${AppLocalizations.of(context)!.minimumList}: ${minQuantity.toString()}',
                                style: AppStyles.rkRegularTextStyle(color: AppColors.redColor, size: AppConstants.font_14),
                              )
                            : const IgnorePointer(),
                        maxQuantity != '0'
                            ? Text(
                                '${AppLocalizations.of(context)!.maximumList}: ${maxQuantity.toString()}',
                                style: AppStyles.rkRegularTextStyle(color: AppColors.redColor, size: AppConstants.font_14),
                              )
                            : const IgnorePointer(),
                      ],
                    )
                  : const IgnorePointer(),
              isMixedSale!
                  ? Text(AppLocalizations.of(context)!.mixedSale,
                      style: AppStyles.rkRegularTextStyle(
                        color: AppColors.redColor,
                        size: AppConstants.font_14,
                      ))
                  : const IgnorePointer(),
              const Spacer(),
              Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: onQuantityIncreaseTap,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radius_2), border: Border.all(color: AppColors.greyColor), color: AppColors.pageColor),
                    child: const Icon(Icons.add, size: 15),
                  ),
                ),
                15.width,
                Text(quantity.toString(), style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.font_17)),
                15.width,
                GestureDetector(
                  onTap: onQuantityDecreaseTap,
                  child: Container(
                    alignment: Alignment.center,
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radius_3), border: Border.all(color: AppColors.greyColor), color: AppColors.pageColor),
                    child: const Icon(Icons.remove, size: 15),
                  ),
                )
              ]),
              5.height,
            ]),
          ]),
        ),
      ),
      isShowSeeAll
          ? Padding(
              padding: const EdgeInsets.only(left: AppConstants.padding_20, right: AppConstants.padding_20, bottom: AppConstants.padding_8),
              child: CustomButtonWidget(buttonText: AppLocalizations.of(context)!.show_all_results, bGColor: AppColors.mainColor, onPressed: onSeeAllTap, fontColors: AppColors.whiteColor),
            )
          : 0.height
    ]);
  }
}
