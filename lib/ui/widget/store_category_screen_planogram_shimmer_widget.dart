import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class StoreCategoryScreenPlanoGramShimmerWidget extends StatelessWidget {
  const StoreCategoryScreenPlanoGramShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: AppConstants.planogramProductPageLimit,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return buildPlanogramItem();
      },
    );
  }

  Widget buildListTitles() {
    return Container(
      width: double.maxFinite,
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

  Widget buildPlanogramItem() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildListTitles(),
          5.height,
          CommonShimmerWidget(
            child: Container(
              height: 200,
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppConstants.radius_10)),
                  color: AppColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
