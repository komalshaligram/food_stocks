import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/constants/app_constants.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import 'common_shimmer_widget.dart';

class PesachBannerShimmerWidget extends StatelessWidget {
  const PesachBannerShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonShimmerWidget(
      child: Container(
        height: 70,
        width: getScreenWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8),
        decoration: BoxDecoration(color: AppColors.whiteColor),
      ),
    );
  }
}
