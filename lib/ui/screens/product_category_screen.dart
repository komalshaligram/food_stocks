import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/product_category/product_category_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/common_marquee_widget.dart';
import 'package:food_stock/ui/widget/product_category_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_pagination_end_widget.dart';
import '../widget/common_shimmer_widget.dart';

class ProductCategoryRoute {
  static Widget get route => ProductCategoryScreen();
}

class ProductCategoryScreen extends StatelessWidget {
  const ProductCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCategoryBloc()
        ..add(ProductCategoryEvent.getProductCategoriesListEvent(
            context: context)),
      child: ProductCategoryScreenWidget(),
    );
  }
}

class ProductCategoryScreenWidget extends StatelessWidget {
  const ProductCategoryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: AppLocalizations.of(context)!.categories,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: NotificationListener<ScrollNotification>(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  state.isShimmering
                      ? ProductCategoryScreenShimmerWidget()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.productCategoryList.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) =>
                              buildProductCategoryListItem(
                                  context: context,
                                  categoryImage: state
                                          .productCategoryList[index]
                                          .categoryImage ??
                                      '',
                                  categoryName: state.productCategoryList[index]
                                          .categoryName ??
                                      '',
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        RouteDefine.storeCategoryScreen.name,
                                        arguments: {
                                          AppStrings.categoryIdString: state
                                              .productCategoryList[index].id,
                                          AppStrings.categoryNameString: state
                                              .productCategoryList[index]
                                              .categoryName
                                        });
                                  }),
                        ),
                  state.isLoadMore
                      ? ProductCategoryScreenShimmerWidget()
                      : 0.width,
                  state.isBottomOfCategories
                      ? CommonPaginationEndWidget(
                          pageEndText: 'No more Categories')
                      : 0.width,
                ],
              ),
            ),
            onNotification: (notification) {
              if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
                context.read<ProductCategoryBloc>().add(
                    ProductCategoryEvent.getProductCategoriesListEvent(
                        context: context));
              }
              return true;
            },
          )),
        );
      },
    );
  }

  Widget buildProductCategoryListItem(
      {required String categoryImage,
      required String categoryName,
      required BuildContext context,
      required void Function() onTap}) {
    return Container(
      height: getScreenHeight(context),
      width: getScreenWidth(context),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                "${AppUrls.baseFileUrl}$categoryImage",
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress?.cumulativeBytesLoaded !=
                      loadingProgress?.expectedTotalBytes) {
                    return CommonShimmerWidget(
                      child: Container(
                        height: getScreenHeight(context),
                        width: getScreenWidth(context),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppConstants.radius_10),
                              topRight:
                                  Radius.circular(AppConstants.radius_10)),
                        ),
                      ),
                    );
                  }
                  return child;
                },
                errorBuilder: (context, error, stackTrace) {
                  // debugPrint('product category list image error : $error');
                  return Container(
                    height: getScreenHeight(context),
                    width: getScreenWidth(context),
                    color: AppColors.whiteColor,
                    padding: EdgeInsets.only(bottom: AppConstants.padding_20),
                    child: Image.asset(
                      AppImagePath.imageNotAvailable5,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_5,
                  horizontal: AppConstants.padding_5),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppConstants.radius_10),
                    bottomRight: Radius.circular(AppConstants.radius_10)),
                // border: Border.all(color: AppColors.whiteColor, width: 1),
              ),
              child: CommonMarqueeWidget(
                child: Text(
                  categoryName,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_12, color: AppColors.whiteColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}