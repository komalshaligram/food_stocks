import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class ManageCreditCardShimmer extends StatelessWidget {
  const ManageCreditCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.1),
              child: SingleChildScrollView(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: AppColors.shimmer1Color, borderRadius: BorderRadius.circular(15)),
                    ),
                    buildTextFieldTitle(),
                    buildTextField(),
                    10.height,
                    buildTextFieldTitle(),
                    buildTextField(),
                  ],
                ),
              ),
            ),
          ),
          50.height,
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Container(
                  height: AppConstants.buttonHeight,
                  decoration: BoxDecoration(
                    color: AppColors.shimmer1Color,
                    borderRadius:
                    BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                  ),
                ),
                  15.height,
                  Container(
                    height: AppConstants.buttonHeight,
                    decoration: BoxDecoration(
                      color: AppColors.shimmer1Color,
                      borderRadius:
                      BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                    ),
                  ),
                  35.height,
                ],
              ),
            ),
          ),
        ],
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

