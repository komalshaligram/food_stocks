import 'package:flutter/material.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../utils/constants/app_constants.dart';

class SupplierScreenShimmerWidget extends StatelessWidget {
  const SupplierScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(shrinkWrap: true, itemCount: AppConstants.supplierPageLimit, padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemBuilder: (context, index) => buildSupplierListItem(context: context)),
    );
  }

  Widget buildSupplierListItem({required BuildContext context}) {
    return CommonShimmerWidget(
      child: Container(
        height: getScreenWidth(context),
        width: getScreenWidth(context),
        margin: const EdgeInsets.all(AppConstants.padding_10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10)],
        ),
      ),
    );
  }
}
