import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';

class CommonProductCategoryWidget extends StatelessWidget {
  final bool isCategoryExpand;
  final bool isMirror;
  final void Function() onScanTap;
  final void Function() onFilterTap;
  final void Function() onOutSideTap;
  final void Function() onCatListItemTap;
  final List<String> categoryList;
  final TextEditingController controller;

  const CommonProductCategoryWidget(
      {super.key,
      required this.isCategoryExpand,
      this.isMirror = false,
      required this.controller,
      required this.onScanTap,
      required this.onFilterTap,
      required this.onOutSideTap,
      required this.onCatListItemTap,
      required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOutSideTap,
      child: Container(
        height: getScreenHeight(context),
        width: getScreenWidth(context),
        padding: EdgeInsets.only(top: AppConstants.padding_10),
        color: isCategoryExpand ? Color.fromARGB(80, 0, 0, 0) : null,
        child: Column(
          children: [
            AnimatedContainer(
              height: isCategoryExpand ? getScreenHeight(context) * 0.7 : 60,
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConstants.radius_30)),
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.3),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: getScreenWidth(context),
                    height: 60,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_10),
                    // margin: EdgeInsets.symmetric(
                    //     horizontal: AppConstants.padding_10),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppConstants.radius_100)),
                      color: AppColors.whiteColor,
                      border: Border.all(
                          color: AppColors.borderColor.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.3),
                            blurRadius: isCategoryExpand ? 0 : 10)
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onFilterTap,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_10),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(isMirror ? pi : 0),
                              child: SvgPicture.asset(
                                AppImagePath.filter,
                                colorFilter: ColorFilter.mode(
                                    AppColors.greyColor, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: AppStyles.searchFieldStyle(),
                              enabledBorder: AppStyles.searchFieldStyle(),
                              focusedBorder: AppStyles.searchFieldStyle(),
                              errorBorder: AppStyles.searchFieldStyle(),
                              focusedErrorBorder: AppStyles.searchFieldStyle(),
                              disabledBorder: AppStyles.searchFieldStyle(),
                              filled: true,
                              hintText: AppLocalizations.of(context)!.search,
                              constraints: BoxConstraints(maxHeight: 40),
                              fillColor: AppColors.pageColor,
                              contentPadding:
                              EdgeInsets.only(top: AppConstants.padding_3),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.greyColor,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                        GestureDetector(
                          onTap: onScanTap,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_10),
                            child: SvgPicture.asset(
                              AppImagePath.scan,
                              colorFilter: ColorFilter.mode(
                                  AppColors.greyColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: !isCategoryExpand
                          ? 0.height
                          : Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: AppConstants.padding_20,
                                  right: AppConstants.padding_20,
                                  top: AppConstants.padding_15,
                                  bottom: AppConstants.padding_5),
                              child: Text(
                                AppLocalizations.of(context)!.categories,
                                style: AppStyles.rkBoldTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: categoryList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return _buildCategoryFilterItem(
                                      category: 'category',
                                      onTap: onCatListItemTap);
                                },
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterItem({required String category, required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border(
                bottom: BorderSide(
                    color: AppColors.borderColor.withOpacity(0.5), width: 1))),
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.padding_20,
            vertical: AppConstants.padding_15),
        child: Text(
          category,
          style: AppStyles.rkRegularTextStyle(
            size: AppConstants.font_12,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
