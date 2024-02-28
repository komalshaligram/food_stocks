import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/search_model/search_model.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';

class CommonSearchWidget extends StatelessWidget {
  final bool isCategoryExpand;
  final bool isSearching;
  final Widget searchResultWidget;
  final bool isBackButton;
  final void Function() onScanTap;
  final void Function() onCloseTap;
  final void Function() onFilterTap;
  final void Function() onSearchTap;
  final void Function() onOutSideTap;
  final void Function(String) onSearch;
  final void Function(String) onSearchSubmit;
  final void Function() onSearchItemTap;
  final List<SearchModel> searchList;
  final TextEditingController controller;
  final bool isFilterTap;

  const CommonSearchWidget({super.key,
    required this.isCategoryExpand,
    required this.isSearching,
    required this.searchResultWidget,
    this.isBackButton = false,
    required this.controller,
    required this.onScanTap,
    required this.onFilterTap,
    required this.onSearchTap,
    required this.onOutSideTap,
    required this.onSearch,
    required this.onSearchSubmit,
    required this.onSearchItemTap,
    required this.searchList,
    this.isFilterTap = false,
    required this.onCloseTap
  });

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
                      isFilterTap ? 0.width :  InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: onFilterTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.padding_10,
                              horizontal: AppConstants.padding_10),
                          width: 40,
                          child: isBackButton
                              ? Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.greyColor,
                            size: 26,
                          )
                              : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(context.rtl ? 0 : pi),
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
                            prefixIcon: Transform(
                              alignment: Alignment.center,
                              transform:
                              Matrix4.rotationY(context.rtl ? pi : 0),
                              child: Icon(
                                Icons.search,
                                color: AppColors.greyColor,
                              ),
                            ),
                            suffixIcon: controller.text.isNotEmpty ? GestureDetector(
                              onTap: (){
                                onCloseTap();
                                controller.clear();
                              },
                              child: Transform(
                                alignment: Alignment.center,
                                transform:
                                Matrix4.rotationY(context.rtl ? pi : 0),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ) : SizedBox(),
                          ),
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          onTap: onSearchTap,
                          onChanged: onSearch,
                          onSubmitted: onSearchSubmit,
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
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
                              isSearching
                                  ? LinearProgressIndicator(
                                color: AppColors.mainColor,
                                minHeight: 3,
                          /*      borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        AppConstants.radius_5)),*/
                                backgroundColor:
                                AppColors.mainColor.withOpacity(0.5),
                              )
                                  : 3.height,
                              Expanded(
                                child: searchResultWidget,
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
}