import 'package:flutter/material.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import 'common_shimmer_widget.dart';

class ProductReturnShimmerWidget extends StatelessWidget {
  const ProductReturnShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        10.height,
        CommonShimmerWidget(
          child: Container(
              height: 100,
              decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)))),
        ),
        10.height,
        buildTextTitle(width: 200),
        5.height,
        buildTextTitle(width: 150, height: 50),
        10.height,
        buildTextTitle(width: getScreenWidth(context) - 50),
        8.height,
        CommonShimmerWidget(
          child: Container(
              height: 50,
              decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)))),
        ),
        10.height,
        CommonShimmerWidget(
          child: Container(
              height: 50,
              decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)))),
        ),
        10.height,
        CommonShimmerWidget(
          child: Container(
              height: 50,
              decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)))),
        ),
        15.height,
        buildTextTitle(width: 200),
        10.height,
        SizedBox(
          height: 150,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonShimmerWidget(
                    child: Container(
                        decoration:
                            BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10))),
                        height: 150,
                        width: 150),
                  ),
                );
              },
              itemCount: 3),
        ),
        buildTextTitle(width: 200),
        10.height,
        CommonShimmerWidget(
          child: Container(
              height: 50,
              decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)))),
        ),
      ]),
    );
  }

  Widget buildTextTitle({double width = 140, double? height}) {
    return CommonShimmerWidget(
      child: Container(
          height: height ?? AppConstants.shimmerTextHeight,
          width: width,
          margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
          decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_3)))),
    );
  }
}
