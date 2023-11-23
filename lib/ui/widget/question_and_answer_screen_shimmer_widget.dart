import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

class QuestionAndAnswerScreenShimmerWidget extends StatelessWidget {
  const QuestionAndAnswerScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: AppConstants.qnaPageLimit,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
            height: 65,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(
                vertical: AppConstants.padding_3,
                horizontal: AppConstants.padding_10),
            padding: EdgeInsets.symmetric(
                vertical: AppConstants.padding_10,
                horizontal: AppConstants.padding_10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonShimmerWidget(
                  child: Container(
                    height: 18,
                    width: getScreenWidth(context) * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppConstants.radius_5)),
                    ),
                  ),
                ),
                CommonShimmerWidget(
                  child: Container(
                    height: 18,
                    width: getScreenWidth(context) * 0.5,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppConstants.radius_5)),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
