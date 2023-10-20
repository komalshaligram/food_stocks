import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';

class ProfileScreenShimmerWidget extends StatelessWidget {
  final bool isMirror;

  const ProfileScreenShimmerWidget({super.key, this.isMirror = false});

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
              Center(
                child: Stack(
                  children: [
                    CommonShimmerWidget(
                      child: Container(
                        height: AppConstants.containerHeight_80,
                        width: AppConstants.containerHeight_80,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          shape: BoxShape.circle,
                        ),
                        margin: EdgeInsets.only(
                            bottom: AppConstants.padding_3,
                            right: AppConstants.padding_3,
                            left: AppConstants.padding_3),
                      ),
                    ),
                    // Positioned(
                    //   right: 1,
                    //   bottom: 1,
                    //   child: CommonShimmerWidget(
                    //     child: Container(
                    //       height: 29,
                    //       width: 29,
                    //       decoration: BoxDecoration(
                    //         color: AppColors.whiteColor,
                    //         shape: BoxShape.circle,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              3.height,
              Center(
                child: CommonShimmerWidget(
                  child: Container(
                    width: 90,
                    height: AppConstants.shimmerTextHeight,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
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
              40.height,
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