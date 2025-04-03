import 'package:flutter/material.dart';
import '../../ui/widget/common_shimmer_widget.dart';

import '../utils/constants/app_constants.dart';

class ProductSaleScreenShimmerWidget extends StatelessWidget {
  const ProductSaleScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: AppConstants.saleProductPageLimit,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: AppConstants.productGridAspectRatio7),
      itemBuilder: (context, index) {
        return buildProductSaleListItem();
      },
    );
  }

  Widget buildProductSaleListItem() {
    return CommonShimmerWidget(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(
            vertical: AppConstants.padding_10,
            horizontal: AppConstants.padding_5),
      ),
    );
  }
}
