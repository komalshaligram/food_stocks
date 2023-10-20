import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/bloc/store_category/store_category_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_product_category_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../bloc/store/store_bloc.dart';

class StoreCategoryRoute {
  static Widget get route => const StoreCategoryScreen();
}

class StoreCategoryScreen extends StatelessWidget {
  const StoreCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreCategoryBloc()
        ..add(StoreCategoryEvent.changeUIUponAppLangEvent()),
      child: StoreCategoryScreenWidget(),
    );
  }
}

class StoreCategoryScreenWidget extends StatelessWidget {
  const StoreCategoryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    StoreCategoryBloc bloc = context.read<StoreCategoryBloc>();
    return BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
      builder: (context, state) => WillPopScope(
        onWillPop: () {
          if (state.isCategory) {
            return Future.value(true);
          } else {
            bloc.add(StoreCategoryEvent.changeCategoryOrSubCategoryEvent(
                isCategory: true));
            return Future.value(false);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.pageColor,
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  height: getScreenHeight(context),
                  width: getScreenWidth(context),
                  child: state.isCategory
                      ? Stack(
                          children: [
                            SingleChildScrollView(
                              child: GestureDetector(
                                onTap: () {
                                  bloc.add(StoreCategoryEvent
                                      .changeCategoryOrSubCategoryEvent(
                                          isCategory: false));
                                },
                                child: Column(
                                  children: [
                                    80.height,
                                    buildTopNavigation(
                                        context: context,
                                        categoryName: 'Category'),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 60,
                                margin: EdgeInsets.only(bottom: 25),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppConstants.padding_5,
                                  vertical: AppConstants.padding_5,
                                ),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppConstants.radius_100)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowColor
                                            .withOpacity(0.3),
                                        blurRadius: AppConstants.blur_10,
                                      )
                                    ]),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          AppImagePath.store,
                                          height: 26,
                                          width: 26,
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              AppColors.navSelectedColor,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              state.isMirror
                                                  ? AppConstants.radius_5
                                                  : AppConstants.radius_100),
                                          bottomLeft: Radius.circular(
                                              state.isMirror
                                                  ? AppConstants.radius_5
                                                  : AppConstants.radius_100),
                                          topRight: Radius.circular(
                                              state.isMirror
                                                  ? AppConstants.radius_100
                                                  : AppConstants.radius_5),
                                          bottomRight: Radius.circular(
                                              state.isMirror
                                                  ? AppConstants.radius_100
                                                  : AppConstants.radius_5),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppConstants.padding_10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${AppLocalizations.of(context)!.total}: ",
                                            style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.normalFont,
                                              color: AppColors.whiteColor,
                                            ),
                                          ),
                                          Text(
                                            "11.90${AppLocalizations.of(context)!.currency}",
                                            style: AppStyles.rkBoldTextStyle(
                                                size: AppConstants.normalFont,
                                                color: AppColors.whiteColor,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    5.width,
                                    GestureDetector(
                                      onTap: () {
                                        debugPrint('finish');
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.navSelectedColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                state.isMirror
                                                    ? AppConstants.radius_100
                                                    : AppConstants.radius_5),
                                            bottomLeft: Radius.circular(
                                                state.isMirror
                                                    ? AppConstants.radius_100
                                                    : AppConstants.radius_5),
                                            topRight: Radius.circular(
                                                state.isMirror
                                                    ? AppConstants.radius_5
                                                    : AppConstants.radius_100),
                                            bottomRight: Radius.circular(
                                                state.isMirror
                                                    ? AppConstants.radius_5
                                                    : AppConstants.radius_100),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                AppConstants.padding_10),
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context)!.finish,
                                          style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.normalFont,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              80.height,
                              buildTopNavigation(
                                  context: context,
                                  categoryName: 'Category',
                                  subCategoryName: 'Sub Category'),
                              16.height,
                              Container(
                                color: AppColors.whiteColor,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppConstants.padding_10,
                                              vertical: AppConstants.padding_3),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .planogram,
                                            style: AppStyles.rkBoldTextStyle(
                                                size: AppConstants.mediumFont,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.height,
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        itemCount: 10,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: AppConstants.padding_5),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return buildPlanoGramListItem(
                                              context: context,
                                              isMirror: false,
                                              width: getScreenWidth(context) /
                                                  3.2);
                                        },
                                      ),
                                    ),
                                    10.height,
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      AppLocalizations.of(context)!.planogram,
                                      style: AppStyles.rkBoldTextStyle(
                                          size: AppConstants.mediumFont,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio:
                                            (getScreenWidth(context) + 70) /
                                                getScreenHeight(context)),
                                shrinkWrap: true,
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return buildPlanoGramListItem(
                                      context: context,
                                      isMirror: false,
                                      width: getScreenWidth(context) / 3.2);
                                },
                              )
                            ],
                          ),
                        ),
                ),
                CommonProductCategoryWidget(
                  isCategoryExpand: state.isCategoryExpand,
                  isMirror: !state.isMirror ? true : false,
                  onFilterTap: () {
                    bloc.add(StoreCategoryEvent.changeCategoryExpansionEvent());
                  },
                  onScanTap: () {},
                  controller: TextEditingController(),
                  onOutSideTap: () {
                    bloc.add(StoreCategoryEvent.changeCategoryExpansionEvent(
                        isOpened: true));
                  },
                  onCatListItemTap: () {},
                  categoryList: ['Category', 'Category'],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildPlanoGramListItem(
      {required BuildContext context, double? width, required bool isMirror}) {
    return Container(
      // height: 190,
      width: width,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
        horizontal: AppConstants.padding_10,
        vertical: AppConstants.padding_10,
      ),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.radius_10),
          ),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImagePath.product3,
            height: 80,
            fit: BoxFit.fitHeight,
          ),
          4.height,
          Text(
            'ProductName',
            style: AppStyles.rkBoldTextStyle(
                size: AppConstants.font_14, color: AppColors.blackColor),
            textAlign: TextAlign.center,
          ),
          4.height,
          Text(
            "23.00${AppLocalizations.of(context)!.currency}",
            style: AppStyles.rkBoldTextStyle(
                size: AppConstants.font_12, color: AppColors.blackColor),
            textAlign: TextAlign.center,
          ),
          4.height,
          Expanded(
            child: Text(
              "Sale 2 at a discount",
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12, color: AppColors.saleRedColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 35,
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: AppColors.borderColor.withOpacity(0.7), width: 1)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    debugPrint('+');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.iconBGColor,
                      border: Border(
                        left: isMirror
                            ? BorderSide.none
                            : BorderSide(
                                color: AppColors.borderColor.withOpacity(0.7),
                                width: 1),
                        right: isMirror
                            ? BorderSide(
                                color: AppColors.borderColor.withOpacity(0.7),
                                width: 1)
                            : BorderSide.none,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_8),
                    alignment: Alignment.center,
                    child: Icon(Icons.add, color: AppColors.mainColor),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.whiteColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_5),
                    alignment: Alignment.center,
                    child: Text(
                      '0',
                      style: AppStyles.rkBoldTextStyle(
                          size: 24,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint('-');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.iconBGColor,
                      border: Border(
                        left: isMirror
                            ? BorderSide(
                                color: AppColors.borderColor.withOpacity(0.7),
                                width: 1)
                            : BorderSide.none,
                        right: isMirror
                            ? BorderSide.none
                            : BorderSide(
                                color: AppColors.borderColor.withOpacity(0.7),
                                width: 1),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_8),
                    alignment: Alignment.center,
                    child: Icon(Icons.remove, color: AppColors.mainColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildTopNavigation(
      {required BuildContext context,
      required String categoryName,
      String? subCategoryName}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.home,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: AppColors.mainColor),
                  textAlign: TextAlign.center,
                ),
                1.width,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.mainColor,
                  size: 16,
                ),
                1.width,
              ],
            ),
          ),
          GestureDetector(
            onTap: subCategoryName?.isEmpty ?? true
                ? null
                : () {
                    debugPrint('cate');
                    BlocProvider.of<StoreCategoryBloc>(context).add(
                        StoreCategoryEvent.changeCategoryOrSubCategoryEvent(
                            isCategory: true));
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  categoryName,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: subCategoryName?.isEmpty ?? true
                          ? AppColors.blackColor
                          : AppColors.mainColor),
                  textAlign: TextAlign.center,
                ),
                1.width,
                subCategoryName?.isEmpty ?? true
                    ? 0.height
                    : Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: subCategoryName?.isEmpty ?? true
                            ? AppColors.blackColor
                            : AppColors.mainColor,
                        size: 16,
                      ),
                1.width,
              ],
            ),
          ),
          Text(
            subCategoryName ?? '',
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.blackColor),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
