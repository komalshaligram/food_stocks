import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import '../utils/themes/app_constants.dart';

class CompanyScreenShimmerWidget extends StatelessWidget {
  const CompanyScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: AppConstants.companyPageLimit,
          padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio:0.9 ),
          itemBuilder: (context, index) =>
              buildCompanyListItem(context: context)),
    );
  }

  Widget buildCompanyListItem({required BuildContext context}) {
    return CommonShimmerWidget(
      child: Container(
        height: getScreenWidth(context),
        width: getScreenWidth(context),
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
