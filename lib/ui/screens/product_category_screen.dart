import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/product_category/product_category_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/common_marquee_widget.dart';
import '../../ui/widget/product_category_screen_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
import '../widget/refresh_widget.dart';

class ProductCategoryRoute {
  static Widget get route => const ProductCategoryScreen();
}

class ProductCategoryScreen extends StatelessWidget {
  const ProductCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => ProductCategoryBloc()
        ..add(ProductCategoryEvent.updateGlobalSearchEvent(search: args?[AppStrings.searchString] ?? '', searchList: args?[AppStrings.searchResultString] ?? []))
        ..add(ProductCategoryEvent.setSearchNavEvent(reqSearch: args?[AppStrings.reqSearchString] ?? '', isFromStoreCategory: args?[AppStrings.fromStoreCategoryString] ?? false))
        ..add(ProductCategoryEvent.getProductCategoriesListEvent(context: context)),
      child: const ProductCategoryScreenWidget(),
    );
  }
}

class ProductCategoryScreenWidget extends StatelessWidget {
  const ProductCategoryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCategoryBloc, ProductCategoryState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, {AppStrings.searchString: state.search, AppStrings.searchResultString: state.searchList});
          return Future.value(false);
        },
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.isBasketScreenString: 'true'});
            },
            child: Stack(children: [
              cartImageWidget(),
              state.cartCount != 0
                  ? Positioned(
                      top: 5,
                      right: context.rtl ? null : 0,
                      left: context.rtl ? 0 : null,
                      child: Stack(children: [
                        Container(
                          height: 18,
                          width: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                            border: Border.all(color: AppColors.whiteColor, width: 1),
                          ),
                          child: Text('${state.cartCount}', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.whiteColor)),
                        ),
                      ]),
                    )
                  : 0.width,
            ]),
          ),
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.categories,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context, {AppStrings.searchString: state.search, AppStrings.searchResultString: state.searchList});
                }),
          ),
          body: FocusDetector(
            onFocusGained: () {
              context.read<ProductCategoryBloc>().add(const ProductCategoryEvent.getCartCountEvent());
            },
            child: SafeArea(
              child: SmartRefresher(
                enablePullDown: true,
                controller: state.refreshController,
                header: const RefreshWidget(),
                footer: CustomFooter(
                  builder: (context, mode) => const ProductCategoryScreenShimmerWidget(),
                ),
                enablePullUp: !state.isBottomOfCategories,
                onRefresh: () {
                  context.read<ProductCategoryBloc>().add(ProductCategoryEvent.refreshListEvent(context: context));
                },
                onLoading: () {
                  context.read<ProductCategoryBloc>().add(ProductCategoryEvent.getProductCategoriesListEvent(context: context));
                },
                child: SingleChildScrollView(
                  physics: state.productCategoryList.isEmpty ? const NeverScrollableScrollPhysics() : null,
                  child: Column(children: [
                    state.isShimmering
                        ? const ProductCategoryScreenShimmerWidget()
                        : state.productCategoryList.isEmpty
                            ? Container(
                                height: getScreenHeight(context) - 80,
                                width: getScreenWidth(context),
                                alignment: Alignment.center,
                                child: noDataWidget(AppLocalizations.of(context)!.categories_not_available),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.productCategoryList.length,
                                padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.9),
                                itemBuilder: (context, index) => buildProductCategoryListItem(
                                    index: index,
                                    context: context,
                                    categoryImage: state.productCategoryList[index].categoryImage ?? '',
                                    categoryName: state.productCategoryList[index].categoryName ?? '',
                                    onTap: () async {
                                      if (state.isFromStoreCategory) {
                                        Navigator.pop(context, {
                                          AppStrings.categoryIdString: state.productCategoryList[index].id,
                                          AppStrings.categoryNameString: state.productCategoryList[index].categoryName,
                                          AppStrings.searchString: state.search,
                                          AppStrings.searchResultString: state.searchList,
                                        });
                                      } else {
                                        dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                                          AppStrings.categoryIdString: state.productCategoryList[index].id,
                                          AppStrings.categoryNameString: state.productCategoryList[index].categoryName,
                                          AppStrings.searchString: state.search,
                                          AppStrings.searchResultString: state.searchList,
                                        });
                                        if (searchResult != null) {
                                          context.read<ProductCategoryBloc>().add(ProductCategoryEvent.updateGlobalSearchEvent(
                                                search: searchResult[AppStrings.searchString],
                                                searchList: searchResult[AppStrings.searchResultString],
                                              ));
                                        }
                                      }
                                    }),
                              ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildProductCategoryListItem({
    required int index,
    required String categoryImage,
    required String categoryName,
    required BuildContext context,
    required void Function() onTap,
  }) {
    return Container(
      height: getScreenHeight(context),
      width: getScreenWidth(context),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        onTap: onTap,
        child: Column(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_10), topRight: Radius.circular(AppConstants.radius_10)),
              child: Image.network("${AppUrlEndPoints.baseFileUrl}$categoryImage", fit: BoxFit.cover, alignment: Alignment.center, loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress?.cumulativeBytesLoaded != loadingProgress?.expectedTotalBytes) {
                  return CommonShimmerWidget(
                    child: Container(
                      height: getScreenHeight(context),
                      width: getScreenWidth(context),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_10), topRight: Radius.circular(AppConstants.radius_10)),
                      ),
                    ),
                  );
                }
                return child;
              }, errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: getScreenHeight(context),
                  width: getScreenWidth(context),
                  color: AppColors.whiteColor,
                  child: Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover),
                );
              }),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_5),
            decoration: BoxDecoration(
              gradient: AppColors.appMainGradientColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppConstants.radius_10), bottomRight: Radius.circular(AppConstants.radius_10)),
            ),
            child: CommonMarqueeWidget(
              child: Text(
                categoryName,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
