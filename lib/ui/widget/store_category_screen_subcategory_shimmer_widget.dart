import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class StoreCategoryScreenSubcategoryShimmerWidget extends StatelessWidget {
  const StoreCategoryScreenSubcategoryShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: AppConstants.productSubCategoryPageLimit,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return buildSubCategoryItem();
      },
    );
  }

  Widget buildSubCategoryItem() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.buttonHeight,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius:
                BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ]),
        margin: EdgeInsets.symmetric(
            vertical: AppConstants.padding_5,
            horizontal: AppConstants.padding_10),
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.padding_10,
            vertical: AppConstants.radius_5),
      ),
    );
  }
}
