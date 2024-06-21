import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/pesach_banner_shimmer.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class StoreScreenShimmerWidget extends StatelessWidget {
  const StoreScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            80.height,
            buildListTitles(),
            buildListItems(context),
            buildListTitles(),
            buildListItems(context),
            5.height,
            PesachBannerShimmerWidget(),
            5.height,
            buildListTitles(),
            buildListItems(context),
            buildListTitles(),
            buildListItems(context, height: 120),
            buildListTitles(),
            buildListItems(context, height: 120),
            90.height,
          ],
        ),
      ),
    );
  }

  CommonShimmerWidget buildListItems(BuildContext context, {double? height}) {
    return CommonShimmerWidget(
      child: Container(
        width: getScreenWidth(context),
        height: height ?? 110,
        margin: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.radius_10),
          ),
          color: AppColors.whiteColor,
        ),
      ),
    );
  }

  Widget buildListTitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextFieldTitle(),
          buildTextFieldTitle(),
        ],
      ),
    );
  }

  Widget buildCategoryListItem() {
    return CommonShimmerWidget(
        child: Container(
      height: 90,
      width: 90,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_10))),
    ));
  }

  Widget buildProductSaleListItem() {
    return CommonShimmerWidget(
        child: Container(
      height: 170,
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_10))),
    ));
  }

  Widget buildTextFieldTitle() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.shimmerTextHeight,
        width: 100,
        margin: EdgeInsets.symmetric(vertical: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_3)),
        ),
      ),
    );
  }
}
