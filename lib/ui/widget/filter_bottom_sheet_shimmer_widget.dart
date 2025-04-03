import 'package:flutter/material.dart';
import '../../ui/widget/sized_box_widget.dart';

import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import 'common_shimmer_widget.dart';

class FilterBottomSheetShimmerWidget extends StatelessWidget {
  const FilterBottomSheetShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        buildTextFieldTitle(),
       7.height,
        buildTextField(),
        7.height,
        buildTextFieldTitle(),
        7.height,
        buildTextField(),
        10.height,
        buildTextField(),
        10.height,
        buildTextField(),
        10.height,
        buildTextField(),
        50.height,
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildButton(),
              buildButton()
            ],
          ),
        )
      ],
    );
  }
  Widget buildTextFieldTitle() {
    return CommonShimmerWidget(
      child: Container(
        height: 25,
        width: 140,
        margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
          const BorderRadius.all(Radius.circular(AppConstants.radius_3)),
        ),
      ),
    );
  }
  Widget buildTextField() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.containerSize_50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
          const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
      ),
    );
  }
  Widget buildButton() {
    return CommonShimmerWidget(
      child: Container(
        width: 120,
        height: AppConstants.containerHeight,
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
          const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        ),
      ),
    );
  }
}
