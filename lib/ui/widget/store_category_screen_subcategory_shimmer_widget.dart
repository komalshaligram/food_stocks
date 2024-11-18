import 'package:flutter/material.dart';
import '../../ui/widget/common_shimmer_widget.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class StoreCategoryScreenSubcategoryShimmerWidget extends StatelessWidget {
  int itemCount;
   StoreCategoryScreenSubcategoryShimmerWidget({super.key,
   this.itemCount = 18
   });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
              const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        margin: const EdgeInsets.symmetric(
            vertical: AppConstants.padding_5,
            horizontal: AppConstants.padding_10),
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.padding_10,
            vertical: AppConstants.radius_10),
      ),
    );
  }
}
