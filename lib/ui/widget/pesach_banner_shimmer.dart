import 'package:flutter/material.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import 'common_shimmer_widget.dart';

class PesachBannerShimmerWidget extends StatelessWidget {
  const PesachBannerShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  CommonShimmerWidget(
      child: Container(
        height: 70,
        width: getScreenWidth(context),
        padding: const EdgeInsets.only(left:8.0,right: 8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
        ),
      ),
    );

  }
}
