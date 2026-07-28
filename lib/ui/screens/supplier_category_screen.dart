import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/supplier_list_products_response_model/supplier_list_products_response_model.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_shimmer_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

class SupplierCategoryRoute {
  static Widget get route => const SupplierCategoryScreen();
}

class SupplierCategoryScreen extends StatelessWidget {
  const SupplierCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    final String? supplierId = args?[AppStrings.supplierIdString];
    final String? supplierName = args?[AppStrings.supplierNameString];
    final List<SupplierCategoryData> categoryList =
        args?[AppStrings.categoryListText] ?? [];

    return Scaffold(
      backgroundColor: AppColors.pageColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
        child: CommonAppBar(
          bgColor: AppColors.pageColor,
          title: AppLocalizations.of(context)?.categories ?? '',
          iconData: Icons.arrow_back_ios_sharp,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: categoryList.isEmpty
            ? Center(
                child: Text(
                    AppLocalizations.of(context)?.categories_not_available ??
                        ''))
            : GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.padding_10),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: categoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.9),
                itemBuilder: (context, index) {
                  final item = categoryList[index];
                  return buildSupplierCategoryGridItem(
                    context: context,
                    categoryImage: item.categoryImage ?? '',
                    categoryName: item.categoryName ?? '',
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteDefine.supplierBrandProductsScreen.name,
                          arguments: {
                            AppStrings.categoryIdString: item.id ?? '',
                            AppStrings.categoryNameString:
                                item.categoryName ?? '',
                            AppStrings.supplierIdString: supplierId ?? '',
                            AppStrings.supplierNameString: supplierName ?? '',
                          });
                    },
                  );
                }),
      ),
    );
  }

  Widget buildSupplierCategoryGridItem({
    required BuildContext context,
    required String categoryImage,
    required String categoryName,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppConstants.radius_10),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(children: [
          Expanded(
            child: categoryImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: "${AppUrlEndPoints.baseFileUrl}$categoryImage",
                    fit: BoxFit.scaleDown,
                    placeholder: (_, __) => CommonShimmerWidget(
                      child: Container(
                        height: getScreenHeight(context),
                        width: getScreenWidth(context),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppConstants.radius_10),
                              topRight:
                                  Radius.circular(AppConstants.radius_10)),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Image.asset(
                        AppImagePath.imageNotAvailable5,
                        fit: BoxFit.cover),
                  )
                : Image.asset(AppImagePath.imageNotAvailable5,
                    fit: BoxFit.cover),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.padding_6),
            decoration: BoxDecoration(
              gradient: AppColors.appMainGradientColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.radius_10),
                  bottomRight: Radius.circular(AppConstants.radius_10)),
            ),
            child: Text(
              categoryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14, color: AppColors.whiteColor),
            ),
          ),
        ]),
      ),
    );
  }
}
