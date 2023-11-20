import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';

class QuestionAndAnswerScreenShimmerWidget extends StatelessWidget {
  const QuestionAndAnswerScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: AppConstants.qnaPageLimit,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CommonShimmerWidget(
          child: Container(
            height: 65,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(
                vertical: AppConstants.padding_8,
                horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConstants.radius_5))),
          ),
        );
      },
    );
  }
}
