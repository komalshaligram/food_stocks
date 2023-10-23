import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class MoreDetailsScreenShimmerWidget extends StatelessWidget {
  const MoreDetailsScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: getScreenWidth(context) * 0.1,
              right: getScreenWidth(context) * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
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
              CommonShimmerWidget(
                child: Container(
                  height: 130,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.radius_5)),
                  ),
                ),
              ),
              50.height,
              buildTextField(),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.textFormFieldHeight,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
      ),
    );
  }

  Widget buildTextFieldTitle() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.shimmerTextHeight,
        width: 140,
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
