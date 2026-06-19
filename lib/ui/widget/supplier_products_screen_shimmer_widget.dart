import 'package:flutter/material.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../utils/constants/app_constants.dart';

class SupplierProductsScreenShimmerWidget extends StatelessWidget {
  final int itemCount;
  const SupplierProductsScreenShimmerWidget({super.key, this.itemCount = 18});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: itemCount,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: AppConstants.productGridShimmerAspectRatio),
          itemBuilder: (context, index) => buildSupplierProductsListItem(context: context),
        ),
      ),
    );
  }

  Widget buildSupplierProductsListItem({required BuildContext context}) {
    return CommonShimmerWidget(
      child: Container(
        margin: const EdgeInsets.all(AppConstants.padding_10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
        ),
      ),
    );
  }
}
