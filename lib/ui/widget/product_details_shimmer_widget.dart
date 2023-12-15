import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_shimmer_widget.dart';

class ProductDetailsShimmerWidget extends StatelessWidget {
  const ProductDetailsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: 0.width),
              Expanded(
                flex: 4,
                child: Center(child: buildTextTitle(width: 120)),
              ),
              Expanded(
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 36,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextTitle(width: 70),
              10.width,
              buildTextTitle(width: 80)
            ],
          ),
          10.height,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: CommonShimmerWidget(
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
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: AppColors.borderColor.withOpacity(0.5),
                        width: 1),
                    bottom: BorderSide(
                        width: 1,
                        color: AppColors.borderColor.withOpacity(0.5)),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_15,
                    vertical: AppConstants.padding_20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextTitle(width: 90, height: 30),
                        buildTextTitle(width: 120),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonShimmerWidget(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    context.rtl
                                        ? AppConstants.radius_5
                                        : AppConstants.radius_50),
                                bottomLeft: Radius.circular(
                                    context.rtl
                                        ? AppConstants.radius_5
                                        : AppConstants.radius_50),
                                bottomRight: Radius.circular(
                                    context.rtl
                                        ? AppConstants.radius_50
                                        : AppConstants.radius_5),
                                topRight: Radius.circular(
                                    context.rtl
                                        ? AppConstants.radius_50
                                        : AppConstants.radius_5),
                              ),
                            ),
                          ),
                        ),
                        5.width,
                        CommonShimmerWidget(
                          child: Container(
                            width: 80,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConstants.radius_5)),
                            ),
                          ),
                        ),
                        5.width,
                        CommonShimmerWidget(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    context.rtl
                                        ? AppConstants.radius_50
                                        : AppConstants.radius_5),
                                bottomLeft: Radius.circular(
                                    context.rtl
                                        ? AppConstants.radius_50
                                        : AppConstants.radius_5),
                                bottomRight: Radius.circular(
                                    context.rtl
                                        ? AppConstants.radius_5
                                        : AppConstants.radius_50),
                                topRight: Radius.circular(
                                    context.rtl
                                        ? AppConstants.radius_5
                                        : AppConstants.radius_50),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border(
              //           bottom: BorderSide(
              //               color: AppColors.borderColor.withOpacity(0.5),
              //               width: 1))),
              //   padding: const EdgeInsets.symmetric(
              //       vertical: AppConstants.padding_10,
              //       horizontal: AppConstants.padding_20),
              //   child: Row(
              //     children: [],
              //   ),
              // ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: AppConstants.padding_20,
                    horizontal: AppConstants.padding_20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextTitle(width: 70),
                    10.height,
                    CommonShimmerWidget(
                      child: Container(
                        height: 150,
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_10),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_5)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(AppConstants.padding_20),
                child: buildTextTitle(
                    height: AppConstants.buttonHeight, width: double.maxFinite),
              ),
              // 160.height,
            ],
          ),
        ],
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
