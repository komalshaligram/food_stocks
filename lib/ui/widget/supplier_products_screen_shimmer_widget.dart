import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';

class SupplierProductsScreenShimmerWidget extends StatelessWidget {
  const SupplierProductsScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: 8,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio:
                    (getScreenWidth(context) + 50) / getScreenHeight(context)),
            itemBuilder: (context, index) =>
                buildSupplierProductsListItem(context: context)),
      ),
    );
  }

  Widget buildSupplierProductsListItem({required BuildContext context}) {
    return CommonShimmerWidget(
      child: Container(
        margin: EdgeInsets.all(AppConstants.padding_10),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10)
          ],
        ),
      ),
    );
  }
}
