import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/search_model/search_model.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';

class CommonSearchWidget extends StatelessWidget {
  final bool isCategoryExpand;
  final bool isRTL;
  final void Function() onScanTap;
  final void Function() onFilterTap;
  final void Function() onOutSideTap;
  final void Function() onSearchItemTap;
  final List<SearchModel> searchList;
  final TextEditingController controller;

  const CommonSearchWidget(
      {super.key,
      required this.isCategoryExpand,
      this.isRTL = false,
      required this.controller,
      required this.onScanTap,
      required this.onFilterTap,
      required this.onOutSideTap,
      required this.onSearchItemTap,
      required this.searchList});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onOutSideTap,
          child: Container(
            height: getScreenHeight(context),
            width: getScreenWidth(context),
            padding: EdgeInsets.only(top: AppConstants.padding_10),
            color: isCategoryExpand ? Color.fromARGB(65, 0, 0, 0) : null,
          ),
        ),
        Positioned(
          top: AppConstants.padding_10,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            width: getScreenWidth(context),
            height: isCategoryExpand ? getScreenHeight(context) * 0.65 : 60,
            duration: Duration(milliseconds: 100),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
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
                              vertical: AppConstants.padding_10,
                              horizontal: AppConstants.padding_10),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(isRTL ? 0 : pi),
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
                              vertical: AppConstants.padding_10,
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
                                child: searchList.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Search result not found',
                                          style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.smallFont,
                                              color: AppColors.textColor),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: searchList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return _buildSearchItem(
                                              searchName:
                                                  searchList[index].name,
                                              searchImage:
                                                  searchList[index].image,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    RouteDefine
                                                        .storeCategoryScreen
                                                        .name,
                                                    arguments: {
                                                      AppStrings
                                                              .categoryIdString:
                                                          searchList[index]
                                                              .searchId,
                                                      AppStrings
                                                              .categoryNameString:
                                                          searchList[index].name
                                                    });
                                                onSearchItemTap;
                                              });
                                        },
                                      ),
                              ),
                              10.height,
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchItem(
      {required String searchName,
      required String searchImage,
      required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border(
                bottom: BorderSide(
                    color: AppColors.borderColor.withOpacity(0.5), width: 1))),
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.padding_20,
            vertical: AppConstants.padding_5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              '${AppUrls.baseFileUrl}$searchImage',
              fit: BoxFit.fitHeight,
              height: 35,
              width: 40,
              errorBuilder: (context, error, stackTrace) {
                return 40.width;
              },
            ),
            10.width,
            Text(
              searchName,
              style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_12,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
