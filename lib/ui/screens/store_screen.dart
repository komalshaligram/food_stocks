import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_product_button_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../bloc/store/store_bloc.dart';
import '../utils/themes/app_colors.dart';

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
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        10.height,
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
                          height: 185,
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
                                  showProductDetails(context: context);
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
                          height: 185,
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
                  Container(
                    height: getScreenHeight(context),
                    width: getScreenWidth(context),
                    color: state.isCategoryExpand
                        ? AppColors.shadowColor.withOpacity(0.3)
                        : null,
                    child: Column(
                      children: [
                        AnimatedContainer(
                          height: state.isCategoryExpand
                              ? getScreenHeight(context) * 0.7
                              : 60,
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_10),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppConstants.radius_30)),
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
                                      color: AppColors.borderColor
                                          .withOpacity(0.5)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.shadowColor
                                            .withOpacity(0.3),
                                        blurRadius:
                                            state.isCategoryExpand ? 0 : 10)
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        bloc.add(StoreEvent
                                            .changeCategoryExpansion());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                AppConstants.padding_10),
                                        child: SvgPicture.asset(
                                          AppImagePath.filter,
                                          colorFilter: ColorFilter.mode(
                                              AppColors.greyColor,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: AppStyles.searchFieldStyle(),
                                          enabledBorder:
                                              AppStyles.searchFieldStyle(),
                                          focusedBorder:
                                              AppStyles.searchFieldStyle(),
                                          errorBorder:
                                              AppStyles.searchFieldStyle(),
                                          focusedErrorBorder:
                                              AppStyles.searchFieldStyle(),
                                          disabledBorder:
                                              AppStyles.searchFieldStyle(),
                                          filled: true,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .search,
                                          constraints:
                                              BoxConstraints(maxHeight: 40),
                                          fillColor: AppColors.pageColor,
                                          contentPadding: EdgeInsets.only(
                                              top: AppConstants.padding_3),
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
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                AppConstants.padding_10),
                                        child: SvgPicture.asset(
                                          AppImagePath.scan,
                                          colorFilter: ColorFilter.mode(
                                              AppColors.greyColor,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              !state.isCategoryExpand
                                  ? 0.height
                                  : Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    AppConstants.padding_20,
                                                vertical:
                                                    AppConstants.padding_15),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .categories,
                                              style: AppStyles.rkBoldTextStyle(
                                                  size: AppConstants.smallFont,
                                                  color: AppColors.blackColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          ListView.builder(
                                            itemCount: 8,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return buildCategoryFilterItem(
                                                  category: 'category',
                                                  onTap: () {});
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
      height: 165,
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

  void showProductDetails({required BuildContext context}) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: true,
          maxChildSize: 1,
          minChildSize: 0.4,
          initialChildSize: 0.5,
          shouldCloseOnMinExtent: true,
          builder: (context, state) {
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: AppColors.blackColor,
                            ),
                          ),
                          Expanded(
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
                          20.width,
                        ],
                      ),
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
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.iconBGColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(AppConstants.radius_5),
                                    bottomLeft:
                                        Radius.circular(AppConstants.radius_5),
                                    bottomRight:
                                        Radius.circular(AppConstants.radius_50),
                                    topRight:
                                        Radius.circular(AppConstants.radius_50),
                                  ),
                                  border: Border.all(
                                      color: AppColors.navSelectedColor,
                                      width: 1),
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        AppConstants.padding_10),
                                    child: Icon(Icons.add,
                                        color: AppColors.mainColor),
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
                                  '1',
                                  style: AppStyles.rkBoldTextStyle(
                                      size: AppConstants.font_30,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              5.width,
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.iconBGColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(AppConstants.radius_50),
                                    bottomLeft:
                                        Radius.circular(AppConstants.radius_50),
                                    bottomRight:
                                        Radius.circular(AppConstants.radius_5),
                                    topRight:
                                        Radius.circular(AppConstants.radius_5),
                                  ),
                                  border: Border.all(
                                      color: AppColors.navSelectedColor,
                                      width: 1),
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        AppConstants.padding_10),
                                    child: Icon(Icons.remove,
                                        color: AppColors.mainColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.padding_10,
                          horizontal: AppConstants.padding_15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Sale',
                                  style: AppStyles.rkBoldTextStyle(
                                      size: AppConstants.font_30,
                                      color: AppColors.saleRedColor,
                                      fontWeight: FontWeight.w700),
                                ),
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
                          Expanded(child: 0.height),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
