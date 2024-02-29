import 'package:flutter/material.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class RelatedProductShimmerWidget extends StatelessWidget {
  const RelatedProductShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.maxFinite - 50,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CommonShimmerWidget(
            child: Container(
              height: 150,
              width: 150,
              margin: const EdgeInsets.all(AppConstants.padding_10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.all(
                    Radius.circular(AppConstants.radius_10)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTextTitle({double width = 140, double? height}) {
    return CommonShimmerWidget(
      child: Container(
        height: height ?? AppConstants.shimmerTextHeight,
        width: width,
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
