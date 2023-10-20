import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class ActivityTimeScreenShimmerWidget extends StatelessWidget {
  const ActivityTimeScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.padding_5,
              vertical: AppConstants.padding_5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(flex: 2, child: 0.height),
                  Expanded(
                    flex: 2,
                    child: CommonShimmerWidget(
                      child: Container(
                        height: AppConstants.shimmerTextHeight,
                        margin: EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_5),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_5)),
                        ),
                      ),
                    ),
                  ),
                  10.width,
                  Expanded(
                    flex: 2,
                    child: CommonShimmerWidget(
                      child: Container(
                        height: AppConstants.shimmerTextHeight,
                        margin: EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_5),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_5)),
                        ),
                      ),
                    ),
                  ),
                  10.width,
                  Expanded(flex: 1, child: 0.height),
                  10.width,
                ],
              ),
              15.height,
              ListView.builder(
                itemCount: 7,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppConstants.padding_3),
                      child: buildDayWiseShiftTime());
                },
              ),
              70.height,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getScreenWidth(context) * 0.1,
                ),
                child: buildButton(),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDayWiseShiftTime() => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: CommonShimmerWidget(
                child: Container(
                  height: AppConstants.shimmerTextHeight,
                  margin:
                      EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.radius_5)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: CommonShimmerWidget(
                child: Container(
                  height: AppConstants.textFormFieldHeight,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.radius_5)),
                  ),
                ),
              ),
            ),
            10.width,
            Expanded(
              flex: 2,
              child: CommonShimmerWidget(
                child: Container(
                  height: AppConstants.textFormFieldHeight,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.radius_5)),
                  ),
                ),
              ),
            ),
            10.width,
            Expanded(
                child: CommonShimmerWidget(
              child: Container(
                height: AppConstants.textFormFieldHeight,
                width: AppConstants.textFormFieldHeight,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                ),
              ),
            )),
            10.width,
          ],
        ),
      );

  Widget buildButton() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.buttonHeight,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        ),
      ),
    );
  }
}
