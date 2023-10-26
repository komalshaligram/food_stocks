import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class ProductSaleScreenShimmerWidget extends StatelessWidget {
  const ProductSaleScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 8,
      padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 9 / 13),
      itemBuilder: (context, index) {
        return buildProductSaleListItem();
      },
    );
  }

  Widget buildProductSaleListItem() {
    return CommonShimmerWidget(
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(
            vertical: AppConstants.padding_10,
            horizontal: AppConstants.padding_5),
      ),
    );
  }
}