import 'package:flutter/material.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_constants.dart';

class FormDataScreenShimmerWidget extends StatelessWidget {
  const FormDataScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: getScreenWidth(context) * 0.1, right: getScreenWidth(context) * 0.1),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            3.height,
            buildTextFieldTitle(),
            buildTextField(),
            7.height,
            buildTextFieldTitle(),
            buildTextField(),
            7.height,
            buildTextFieldTitle(),
            buildTextField(),
            7.height,
            buildTextFieldTitle(),
            buildTextField(),
            7.height,
            buildTextFieldTitle(),
            buildTextField(),
            7.height,
            buildTextFieldTitle(),
            buildTextField(),
            7.height,
            buildTextFieldTitle(),
            buildTextField(),
            7.height,
            buildTextFieldTitle(),
            buildTextField(),
            7.height
          ]),
        ),
      ),
    );
  }

  Widget buildTextField() {
    return CommonShimmerWidget(
      child: Container(
          height: AppConstants.textFormFieldHeight,
          width: double.maxFinite,
          decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)))),
    );
  }

  Widget buildTextFieldTitle() {
    return CommonShimmerWidget(
      child: Container(
          height: AppConstants.shimmerTextHeight,
          width: 140,
          margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_10),
          decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_3)))),
    );
  }
}
