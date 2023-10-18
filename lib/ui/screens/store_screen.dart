import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_product_button_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../bloc/store/store_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../widget/common_product_category_widget.dart';

class StoreRoute {
  static Widget get route => const StoreScreen();
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreBloc(),
      child: StoreScreenWidget(),
    );
  }
}

class StoreScreenWidget extends StatelessWidget {
  const StoreScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreBloc bloc = context.read<StoreBloc>();
    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) {},
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        80.height,
                        buildListTitles(
                            context: context,
                            title: AppLocalizations.of(context)!.categories,
                            subTitle:
                                AppLocalizations.of(context)!.all_categories,
                            onTap: () {}),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            itemCount: 10,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_5),
                            itemBuilder: (context, index) {
                              return buildCategoryListItem(
                                  categoryImage: AppImagePath.product3,
                                  categoryName: 'Fruits',
                                  onTap: () {});
                            },
                          ),
                        ),
                        buildListTitles(
                            context: context,
                            title: AppLocalizations.of(context)!.companies,
                            subTitle:
                                AppLocalizations.of(context)!.all_companies,
                            onTap: () {}),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            itemCount: 10,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_5),
                            itemBuilder: (context, index) {
                              return buildCompanyListItem(
                                  companyLogo: AppImagePath.profileImage,
                                  onTap: () {});
                            },
                          ),
                        ),
                        buildListTitles(
                            context: context,
                            title: AppLocalizations.of(context)!.sales,
                            subTitle: AppLocalizations.of(context)!.all_sales,
                            onTap: () {}),
                        SizedBox(
                          height: 190,
                          child: ListView.builder(
                            itemCount: 10,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_5),
                            itemBuilder: (context, index) {
                              return buildProductSaleListItem(
                                context: context,
                                promotionImage: AppImagePath.product1,
                                title: '2 Products discount',
                                description:
                                    'Buy 2 units of a of flat salted pretzels for a price of 250 grams',
                                price: 20,
                                onTap: () {
                                  showProductDetails(
                                      context: context,
                                      isMirror: state.isMirror);
                                },
                                onButtonTap: () {},
                              );
                            },
                          ),
                        ),
                        buildListTitles(
                            context: context,
                            title: AppLocalizations.of(context)!
                                .recommended_for_you,
                            subTitle: AppLocalizations.of(context)!.more,
                            onTap: () {}),
                        SizedBox(
                          height: 190,
                          child: ListView.builder(
                            itemCount: 10,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_5),
                            itemBuilder: (context, index) {
                              return buildProductSaleListItem(
                                context: context,
                                promotionImage: AppImagePath.product2,
                                title: '2 Products discount',
                                description:
                                    'Buy 2 units of a of flat salted pretzels for a price of 250 grams',
                                price: 20,
                                onTap: () {},
                                onButtonTap: () {},
                              );
                            },
                          ),
                        ),
                        85.height,
                      ],
                    ),
                  ),
                  CommonProductCategoryWidget(
                    isCategoryExpand: state.isCategoryExpand,
                    isMirror: !state.isMirror ? true : false,
                    onFilterTap: () {
                      bloc.add(StoreEvent.changeCategoryExpansion());
                    },
                    onScanTap: () {},
                    controller: TextEditingController(),
                    onOutSideTap: () {
                      bloc.add(
                          StoreEvent.changeCategoryExpansion(isOpened: true));
                    },
                    categoryList: [
                      'Category',
                      'Category',
                      'Category',
                      'Category',
                      'Category'
                    ],
                    onCatListItemTap: () {
                      Navigator.pushNamed(
                          context, RouteDefine.storeCategoryScreen.name);
                      bloc.add(
                          StoreEvent.changeCategoryExpansion(isOpened: true));
                    },
                    // child: !state.isCategoryExpand
                    //     ? 0.height
                    //     : Container(
                    //         child: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.only(
                    //                   left: AppConstants.padding_20,
                    //                   right: AppConstants.padding_20,
                    //                   top: AppConstants.padding_15,
                    //                   bottom: AppConstants.padding_5),
                    //               child: Text(
                    //                 AppLocalizations.of(context)!.categories,
                    //                 style: AppStyles.rkBoldTextStyle(
                    //                     size: AppConstants.smallFont,
                    //                     color: AppColors.blackColor,
                    //                     fontWeight: FontWeight.w500),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               child: ListView.builder(
                    //                 itemCount: 18,
                    //                 shrinkWrap: true,
                    //                 clipBehavior: Clip.hardEdge,
                    //                 itemBuilder: (context, index) {
                    //                   return buildCategoryFilterItem(
                    //                       category: 'category',
                    //                       onTap: () {
                    //                         Navigator.pushNamed(
                    //                             context,
                    //                             RouteDefine
                    //                                 .storeCategoryScreen.name);
                    //                       });
                    //                 },
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding buildListTitles(
      {required BuildContext context,
      required String title,
      required void Function() onTap,
      required subTitle}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.padding_10,
        right: AppConstants.padding_10,
        top: AppConstants.padding_10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.blackColor),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              subTitle,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: AppColors.mainColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryListItem(
      {required String categoryName,
      required void Function() onTap,
      required String categoryImage}) {
    return Container(
      height: 90,
      width: 90,
      margin: EdgeInsets.symmetric(
          horizontal: AppConstants.padding_5,
          vertical: AppConstants.padding_10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        // boxShadow: [
        //   BoxShadow(
        //       color: AppColors.shadowColor.withOpacity(0.15),
        //       blurRadius: AppConstants.blur_10)
        // ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Image.asset(
              categoryImage,
              fit: BoxFit.contain,
              height: 90,
              width: 90,
            ),
            Positioned(
              bottom: AppConstants.padding_5,
              left: AppConstants.padding_5,
              right: AppConstants.padding_5,
              child: Container(
                height: 20,
                alignment: Alignment.center,
                padding:
                    EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppConstants.radius_10)),
                  border: Border.all(color: AppColors.whiteColor, width: 1),
                ),
                clipBehavior: Clip.hardEdge,
                child: Text(
                  categoryName,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_12, color: AppColors.whiteColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProductSaleListItem(
      {required BuildContext context,
      required String promotionImage,
      required String title,
      required String description,
      required double price,
      required void Function() onButtonTap,
      required void Function() onTap}) {
    return Container(
      height: 170,
      width: 140,
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
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(promotionImage,
                  height: 70, fit: BoxFit.fitHeight),
            ),
            5.height,
            Text(
              title,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12,
                  color: AppColors.saleRedColor,
                  fontWeight: FontWeight.w600),
            ),
            5.height,
            Expanded(
              child: Text(
                description,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_10, color: AppColors.blackColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            5.height,
            Center(
              child: CommonProductButtonWidget(
                title:
                    "${price.toStringAsFixed(0)}${AppLocalizations.of(context)!.currency}",
                onPressed: () {},
                // height: 35,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCompanyListItem(
      {required String companyLogo, required void Function() onTap}) {
    return Container(
      height: 90,
      width: 90,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        onTap: onTap,
        child: Image.asset(
          companyLogo,
          fit: BoxFit.cover,
          height: 90,
          width: 90,
        ),
      ),
    );
  }

  Widget buildCategoryFilterItem(
      {required String category, required void Function() onTap}) {
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

  void showProductDetails(
      {required BuildContext context, required bool isMirror}) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: true,
          maxChildSize: 1 -
              (MediaQuery.of(context).viewPadding.top /
                  getScreenHeight(context)),
          minChildSize: 0.4,
          initialChildSize: 0.7,
          shouldCloseOnMinExtent: true,
          builder: (BuildContext context, ScrollController scrollController) {
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
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  // 10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: 0.width),
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Product name',
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
                          // alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 40,
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
                      '100gr | Company name',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: AppColors.blackColor),
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
                            child: Image.asset(
                              AppImagePath.product1,
                              height: 150,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.5),
                                    width: 1),
                                bottom: BorderSide(
                                    width: 1,
                                    color:
                                        AppColors.borderColor.withOpacity(0.5)),
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
                                      '11.90₪',
                                      style: AppStyles.rkBoldTextStyle(
                                          size: AppConstants.font_30,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '4.76 ש"ח ל- 100 גרם',
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
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.iconBGColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(isMirror
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_50),
                                            bottomLeft: Radius.circular(isMirror
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_50),
                                            bottomRight: Radius.circular(
                                                isMirror
                                                    ? AppConstants.radius_50
                                                    : AppConstants.radius_5),
                                            topRight: Radius.circular(isMirror
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
                                          topLeft: Radius.circular(
                                              AppConstants.radius_5),
                                          bottomLeft: Radius.circular(
                                              AppConstants.radius_5),
                                          bottomRight: Radius.circular(
                                              AppConstants.radius_5),
                                          topRight: Radius.circular(
                                              AppConstants.radius_5),
                                        ),
                                        border: Border.all(
                                            color: AppColors.navSelectedColor,
                                            width: 1),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '1',
                                        style: AppStyles.rkBoldTextStyle(
                                            size: AppConstants.font_30,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    5.width,
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.iconBGColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(isMirror
                                                ? AppConstants.radius_50
                                                : AppConstants.radius_5),
                                            bottomLeft: Radius.circular(isMirror
                                                ? AppConstants.radius_50
                                                : AppConstants.radius_5),
                                            bottomRight: Radius.circular(
                                                isMirror
                                                    ? AppConstants.radius_5
                                                    : AppConstants.radius_50),
                                            topRight: Radius.circular(isMirror
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_50),
                                          ),
                                          border: Border.all(
                                              color: AppColors.navSelectedColor,
                                              width: 1),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.remove,
                                            size: 26,
                                            color: AppColors.mainColor),
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
                                        color: AppColors.borderColor
                                            .withOpacity(0.5),
                                        width: 1))),
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding_10,
                                horizontal: AppConstants.padding_20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sale',
                                        style: AppStyles.rkBoldTextStyle(
                                            size: AppConstants.font_30,
                                            color: AppColors.saleRedColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      5.height,
                                      Text(
                                        '2 at discount Buy 2 units at a price there of ₪20',
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.font_14,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(flex: 2, child: 0.height),
                              ],
                            ),
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
                                  height: 120,
                                  width: getScreenWidth(context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppConstants.padding_10),
                                  decoration: BoxDecoration(
                                      color: AppColors.notesBGColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppConstants.radius_5))),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    maxLines: 4,
                                  ) /*Text(
                                    '',
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_12,
                                        color: AppColors.blackColor),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  )*/
                                  ,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(AppConstants.padding_20),
                            child: CommonProductButtonWidget(
                              title: AppLocalizations.of(context)!.add_to_order,
                              onPressed: () {},
                              width: double.maxFinite,
                              height: AppConstants.buttonHeight,
                              borderRadius: AppConstants.radius_5,
                              textSize: AppConstants.normalFont,
                              textColor: AppColors.whiteColor,
                              bgColor: AppColors.mainColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
