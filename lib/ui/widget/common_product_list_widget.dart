import 'package:flutter/cupertino.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class CommonProductListShimmerWidget extends StatelessWidget {
  int itemCount;
  CommonProductListShimmerWidget({super.key,
    this.itemCount = 6
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return buildSubCategoryItem();
      },
    );
  }

  Widget buildSubCategoryItem() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.relatedProductItemHeight,
        width:140,
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
