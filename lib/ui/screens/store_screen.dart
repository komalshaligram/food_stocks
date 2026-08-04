import '../../ui/utils/club_agent.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/widget/related_product_title.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/widget/common_marquee_widget.dart';
import '../../ui/widget/common_product_list_widget.dart';
import '../../ui/widget/common_product_sale_item_widget.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../bloc/store/store_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_strings.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/dialogs/common_dialog_with_one_button.dart';
import '../widget/common_search_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/custom_text_icon_button_widget.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/pesach_banner_shimmer.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/sale_promotion_sheet.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_screen_shimmer_widget.dart';
import '../widget/build_list_title.dart';

class StoreRoute {
  static Widget get route => const StoreScreen();
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return StoreBloc()
            ..add(StoreEvent.getSuppliersDataListEvent(context: context))
            ..add(StoreEvent.getSuppliersListEvent(context: context))
            ..add(StoreEvent.getProductCategoriesListEvent(context: context))
            ..add(StoreEvent.getCompaniesListEvent(context: context))
            ..add(StoreEvent.getProductSalesListEvent(context: context))
            ..add(StoreEvent.getRecommendationProductsListEvent(context: context))
            ..add(StoreEvent.getPreviousOrderProductsListEvent(context: context))
            ..add(const StoreEvent.getPreferencesDataEvent());
        },
        child: const StoreScreenWidget());
  }
}

class StoreScreenWidget extends StatelessWidget {
  const StoreScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreBloc bloc = context.read<StoreBloc>();
    return BlocListener<StoreBloc, StoreState>(
      listener: (context, state) async {
        if (state.isCartCountChange) {
          BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.updateCartCountEvent(context: context));
        }
        if (state.isAccountPermissionShimmering) {
          BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.seeWalletPermissionUpdateEvent(context: context));
        }
        if (state.isAppOnMaintenance && !state.isDialogOpen) {
          appUnderMaintenanceDialog(context: context, state: state);
          BlocProvider.of<StoreBloc>(context).add(StoreEvent.updateMaintenanceEvent(context: context));
        }
      },
      child: BlocBuilder<StoreBloc, StoreState>(builder: (context, state) {
        return FocusDetector(
          onFocusGained: () {
            bloc.add(StoreEvent.getPermissionList(context: context));
            if (!state.isAppOnMaintenance) {
              bloc.add(StoreEvent.generalSettings(context: context, dialogContext: context, isRetryLoading: false));
            }
            bloc.add(StoreEvent.getSuppliersDataListEvent(context: context));
            bloc.add(StoreEvent.getProductSalesListEvent(context: context));
            bloc.add(StoreEvent.getRecommendationProductsListEvent(context: context));
            bloc.add(StoreEvent.getPreviousOrderProductsListEvent(context: context));
          },
          child: Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Stack(children: [
                SmartRefresher(
                  physics: const ClampingScrollPhysics(),
                  enablePullDown: true,
                  controller: state.refreshController,
                  header: smartRefreshCustomHeaderWidget(),
                  footer: CustomFooter(builder: (context, mode) => const StoreScreenShimmerWidget()),
                  onRefresh: () {
                    if (!state.isAppOnMaintenance) {
                      bloc.add(StoreEvent.generalSettings(context: context, dialogContext: context, isRetryLoading: false));
                    }
                    bloc.add(StoreEvent.getSuppliersDataListEvent(context: context));
                    bloc.add(StoreEvent.getProductCategoriesListEvent(context: context));
                    bloc.add(StoreEvent.getCompaniesListEvent(context: context));
                    bloc.add(StoreEvent.getSuppliersListEvent(context: context));
                    bloc.add(StoreEvent.getProductSalesListEvent(context: context));
                    bloc.add(StoreEvent.getRecommendationProductsListEvent(context: context));
                    bloc.add(StoreEvent.getPreviousOrderProductsListEvent(context: context));
                    bloc.add(const StoreEvent.getPreferencesDataEvent());
                    state.refreshController.refreshCompleted();
                    state.refreshController.loadComplete();
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: state.isShimmering && state.productCategoryList.isEmpty
                        ? const StoreScreenShimmerWidget()
                        : AnimationLimiter(
                            child: Column(
                                children: AnimationConfiguration.toStaggeredList(
                                    duration: const Duration(seconds: 1),
                                    childAnimationBuilder: (widget) => SlideAnimation(
                                          verticalOffset: MediaQuery.of(context).size.height / 5,
                                          child: FadeInAnimation(child: widget),
                                        ),
                                    children: [
                                  80.height,
                                  dataAnalyticsButtonWidget(context, state),
                                  supplierDataListWidget(context, bloc, state),
                                  categoryListWidget(context, bloc, state),
                                  companyListWidget(context, bloc, state),
                                  pesachBannerWidget(context, state),
                                  productSaleWidget(context, bloc, state),
                                  productRecommendedWidget(context, bloc, state),
                                  previousOrderProductWidget(context, bloc, state),
                                  AppConstants.bottomNavSpace.height,
                                ])),
                          ),
                  ),
                ),
                searchWidget(context, bloc, state),
              ]),
            ),
          ),
        );
      }),
    );
  }

  Widget supplierDataListWidget(BuildContext context, StoreBloc bloc, StoreState state) => AnimatedCrossFade(
      firstChild: getScreenWidth(context).width,
      secondChild: Column(children: [
        buildListTitles(
            context: context,
            title: AppLocalizations.of(context)!.suppliers,
            subTitle: AppLocalizations.of(context)!.all_suppliers,
            onTap: () {
              Navigator.pushNamed(context, RouteDefine.supplierScreen.name);
            }),
        SizedBox(
          width: getScreenWidth(context),
          height: 130,
          child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: state.suppliersDataList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
              itemBuilder: (context, index) {
                return buildCompanyListItem(
                    companyLogo: state.suppliersDataList[index].logo ?? '',
                    companyName: state.suppliersDataList[index].supplierDetail?.displayName ?? '',
                    isHomePreference: true,
                    onTap: () {
                      Navigator.pushNamed(context, RouteDefine.supplierListProductsScreen.name, arguments: {
                        AppStrings.supplierIdString: state.suppliersDataList[index].id ?? '',
                        AppStrings.supplierNameString: state.suppliersDataList[index].supplierDetail?.displayName,
                        AppStrings.minimumOrderText: state.suppliersDataList[index].supplierDetail?.minOrderAmount
                      });
                    });
              }),
        ),
      ]),
      crossFadeState: state.suppliersDataList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300));

  Widget categoryListWidget(BuildContext context, StoreBloc bloc, StoreState state) => AnimatedCrossFade(
      firstChild: getScreenWidth(context).width,
      secondChild: Column(children: [
        state.isCatVisible
            ? buildListTitles(
                context: context,
                title: AppLocalizations.of(context)!.categories,
                subTitle: AppLocalizations.of(context)!.all_categories,
                onTap: () async {
                  dynamic searchResult = await Navigator.pushNamed(
                    context,
                    RouteDefine.productCategoryScreen.name,
                    arguments: {AppStrings.searchString: state.search, AppStrings.searchResultString: state.searchList},
                  );
                  if (searchResult != null) {
                    bloc.add(StoreEvent.updateGlobalSearchEvent(
                        search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                  }
                })
            : Container(),
        SizedBox(
          width: getScreenWidth(context),
          height: state.isCatVisible ? 135 : 0,
          child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: state.productCategoryList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
              itemBuilder: (context, index) {
                bool isHomePreference = state.productCategoryList[index].isHomePreference ?? false;
                return !isHomePreference
                    ? 0.width
                    : Container(
                        height: 150,
                        width: 105,
                        margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5, vertical: AppConstants.padding_10),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
                          color: AppColors.whiteColor,
                          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
                        ),
                        child: InkWell(
                          onTap: () async {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: state.productCategoryList[index].id,
                              AppStrings.categoryNameString: state.productCategoryList[index].categoryName,
                            });
                            if (searchResult != null) {
                              bloc.add(StoreEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          },
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.padding_10)),
                              child: (state.productCategoryList[index].categoryImage ?? '').isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: "${AppUrlEndPoints.baseFileUrl}${state.productCategoryList[index].categoryImage}",
                                      fit: BoxFit.cover,
                                      height: 140,
                                      width: 105,
                                      alignment: Alignment.center,
                                      placeholder: (context, url) {
                                        return CommonShimmerWidget(
                                            child: Container(height: 140, width: 105, decoration: BoxDecoration(color: AppColors.whiteColor)));
                                      },
                                      errorWidget: (context, error, stackTrace) {
                                        return Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover, width: 140, height: 110);
                                      })
                                  : Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover, width: 140, height: 110),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5, vertical: AppConstants.padding_2),
                                decoration: BoxDecoration(
                                  gradient: AppColors.appMainGradientColor,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(AppConstants.radius_10), bottomRight: Radius.circular(AppConstants.radius_10)),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: CommonMarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Text(
                                    state.productCategoryList[index].categoryName ?? '',
                                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      );
              }),
        ),
      ]),
      crossFadeState: state.productCategoryList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300));

  Widget companyListWidget(BuildContext context, StoreBloc bloc, StoreState state) => AnimatedCrossFade(
      firstChild: getScreenWidth(context).width,
      secondChild: Column(children: [
        state.isCompanyVisible
            ? buildListTitles(
                context: context,
                title: AppLocalizations.of(context)!.brands,
                subTitle: AppLocalizations.of(context)!.all_brands,
                onTap: () {
                  Navigator.pushNamed(context, RouteDefine.companyScreen.name);
                })
            : Container(),
        SizedBox(
          width: getScreenWidth(context),
          height: state.isCompanyVisible ? 130 : 0,
          child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: state.companiesList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
              itemBuilder: (context, index) {
                return buildCompanyListItem(
                    companyLogo: state.companiesList[index].brandLogo ?? '',
                    companyName: state.companiesList[index].brandName ?? '',
                    isHomePreference: state.companiesList[index].isHomePreference ?? false,
                    onTap: () {
                      Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {
                        AppStrings.companyIdString: state.companiesList[index].id ?? '',
                        AppStrings.companyLogo: state.companiesList[index].brandLogo ?? '',
                        AppStrings.companyName: state.companiesList[index].brandName ?? '',
                      });
                    });
              }),
        ),
      ]),
      crossFadeState: state.companiesList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300));

  Widget buildCompanyListItem({required String companyLogo, required String companyName, required void Function() onTap, bool? isHomePreference}) {
    return !(isHomePreference ?? true)
        ? 0.width
        : Container(
            height: 150,
            width: 105,
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
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.padding_20),
                  child: companyLogo.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: "${AppUrlEndPoints.baseFileUrl}$companyLogo",
                          fit: BoxFit.scaleDown,
                          height: 110,
                          width: 105,
                          placeholder: (context, url) {
                            return CommonShimmerWidget(
                                child: Container(height: 110, width: 105, decoration: BoxDecoration(color: AppColors.whiteColor)));
                          },
                          errorWidget: (context, error, stackTrace) {
                            return Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover, width: 110, height: 105);
                          })
                      : Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover, width: 110, height: 105),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 25,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5, vertical: AppConstants.padding_2),
                    decoration: BoxDecoration(
                      gradient: AppColors.appMainGradientColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(AppConstants.radius_10), bottomLeft: Radius.circular(AppConstants.radius_10)),
                    ),
                    child: CommonMarqueeWidget(
                      direction: Axis.horizontal,
                      child: Text(
                        companyName,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ]),
            ),
          );
  }

  Widget pesachBannerWidget(BuildContext context, StoreState state) => state.pesachBannerShimmering && state.pesachBannerURL.isEmpty
      ? const PesachBannerShimmerWidget()
      : state.showPesachBanner && state.pesachBannerURL.isNotEmpty
          ? InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteDefine.pesachScreen.name);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8),
                child: CachedNetworkImage(
                    placeholder: (context, url) => const PesachBannerShimmerWidget(),
                    imageUrl: '${AppUrlEndPoints.baseFileUrl}${state.pesachBannerURL}',
                    errorWidget: (context, url, error) {
                      return Container(color: AppColors.whiteColor);
                    }),
              ))
          : Container();

  Widget productSaleWidget(BuildContext context, StoreBloc bloc, StoreState state) => AnimatedCrossFade(
      firstChild: getScreenWidth(context).width,
      secondChild: Column(children: [
        buildListTitles(
            context: context,
            title: AppLocalizations.of(context)!.sales,
            subTitle: AppLocalizations.of(context)!.all_sales,
            onTap: () {
              Navigator.pushNamed(context, RouteDefine.productSaleScreen.name);
            }),
        SizedBox(
          width: getScreenWidth(context),
          height: getItemHeight(context, state.isSaleOn),
          child: state.isSaleShimmering
              ? const CommonProductListShimmerWidget()
              : AbsorbPointer(
                  absorbing: state.isSaleShimmering,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: state.productSalesList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                      itemBuilder: (context, index) {
                        var productSaleData = state.productSalesList[index];
                        var productStockData = state.productStockList[3][index];
                        return CommonProductSaleItemWidget(
                            isSale: productSaleData.sale?.isSale,
                            isGuestUser: state.isGuestUser,
                            onGuestLoginRequired: () => Navigator.pushNamed(context, RouteDefine.connectScreen.name),
                            height: AppConstants.salesProductItemHeight,
                            width: getItemWidth(context),
                            productName: productSaleData.productName ?? '',
                            saleImage: productSaleData.mainImage ?? '',
                            title: productSaleData.name,
                            description: parse(productSaleData.sale?.saleDescription).body?.text ?? '',
                            discountedPrice: double.parse(productSaleData.sale?.salePrice ?? ""),
                            originalPrice: productSaleData.productPrice,
                            productStock: productSaleData.productStock.toString(),
                            lowStock: productSaleData.lowStock ?? '',
                            isPesach: productSaleData.isPesach,
                            quantity: productStockData.quantity,
                            minQuantity: productSaleData.sale?.saleMinQuantity,
                            maxQuantity: productSaleData.sale?.saleMaxQuantity,
                            isMixedSale: productSaleData.sale?.isMixedSale,
                            numberOfUnits: productSaleData.numberOfUnit.toString(),
                            scaleType: productSaleData.scaleType,
                            onQuantityChanged: () {
                              context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                                    context: context,
                                    quantity: productStockData.quantity.toString(),
                                    productListIndex: 3,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: productSaleData.supplierId.toString(),
                                  ));
                            },
                            onQuantityIncreaseTap: () {
                              if (!(productSaleData.sale?.isMixedSale ?? false) &&
                                  int.parse(productSaleData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity + 1) {
                                context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                      context: context,
                                      productListIndex: 3,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: productSaleData.supplierId.toString(),
                                    ));

                                context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                      context: context,
                                      productId: productSaleData.id.toString(),
                                      productListIndex: 3,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: productSaleData.supplierId.toString(),
                                    ));
                              } else {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: productSaleData.id.toString(),
                                  minBox: productSaleData.sale?.saleMinQuantity.toString() ?? '0',
                                  index: index,
                                  supplierId: productSaleData.supplierId.toString(),
                                  productListIndex: 3,
                                  isIncrease: true,
                                  isMixedSale: productSaleData.sale?.isMixedSale,
                                  sameSaleProducts: productSaleData.sale?.sameSaleProducts,
                                );
                              }
                            },
                            onQuantityDecreaseTap: () {
                              if (productStockData.quantity != 0) {
                                if (!(productSaleData.sale?.isMixedSale ?? false) &&
                                    int.parse(productSaleData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                                  context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                        context: context,
                                        productListIndex: 3,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: productSaleData.supplierId.toString(),
                                      ));

                                  context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                        context: context,
                                        productId: productSaleData.id.toString(),
                                        productListIndex: 3,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: productSaleData.supplierId.toString(),
                                      ));
                                } else {
                                  showMinMaxQtyConfirmDialog(
                                    context: context,
                                    productId: productSaleData.id.toString(),
                                    minBox: productSaleData.sale?.saleMinQuantity.toString() ?? '0',
                                    index: index,
                                    supplierId: productSaleData.supplierId.toString(),
                                    productListIndex: 3,
                                    isIncrease: false,
                                    isMixedSale: productSaleData.sale?.isMixedSale,
                                    sameSaleProducts: productSaleData.sale?.sameSaleProducts,
                                  );
                                }
                              }
                            },
                            onButtonTap: () {
                              if (!state.isGuestUser) {
                                showProductDetails(
                                  isSaleOn: state.isSaleOn,
                                  productListIndex: 3,
                                  context: context,
                                  productId: productSaleData.id ?? '',
                                  productStock: productSaleData.productStock.toString(),
                                );
                              } else {
                                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                              }
                            });
                      }),
                ),
        ),
      ]),
      crossFadeState: state.productSalesList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300));

  Widget productRecommendedWidget(BuildContext context, StoreBloc bloc, StoreState state) => !state.isGuestUser
      ? AnimatedCrossFade(
          firstChild: getScreenWidth(context).width,
          secondChild: Column(children: [
            buildListTitles(
                context: context,
                title: AppLocalizations.of(context)!.recommended_for_you,
                subTitle: AppLocalizations.of(context)!.more,
                onTap: () {
                  Navigator.pushNamed(context, RouteDefine.recommendationProductsScreen.name);
                }),
            SizedBox(
              width: getScreenWidth(context),
              height: getItemHeight(context, state.isSaleOn),
              child: state.isRecommendedShimmering
                  ? const CommonProductListShimmerWidget()
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: state.recommendedProductsList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                      itemBuilder: (context, index) {
                        var productRecommendedData = state.recommendedProductsList[index];
                        var productStockData = state.productStockList[1][index];
                        return CommonProductSaleItemWidget(
                            isSale: productRecommendedData.sale?.isSale,
                            isGuestUser: state.isGuestUser,
                            onGuestLoginRequired: () => Navigator.pushNamed(context, RouteDefine.connectScreen.name),
                            height: AppConstants.salesProductItemHeight,
                            width: getItemWidth(context),
                            productName: productRecommendedData.productName ?? '',
                            saleImage: productRecommendedData.mainImage ?? '',
                            title: productRecommendedData.name,
                            description: parse(productRecommendedData.sale?.saleDescription).body?.text ?? '',
                            discountedPrice: double.parse(productRecommendedData.sale?.salePrice ?? ''),
                            originalPrice: productRecommendedData.productPrice,
                            productStock: productRecommendedData.productStock.toString(),
                            lowStock: productRecommendedData.lowStock ?? '',
                            isPesach: productRecommendedData.isPesach,
                            quantity: productStockData.quantity,
                            minQuantity: productRecommendedData.sale?.saleMinQuantity,
                            maxQuantity: productRecommendedData.sale?.saleMaxQuantity,
                            isMixedSale: productRecommendedData.sale?.isMixedSale,
                            numberOfUnits: productRecommendedData.numberOfUnit.toString(),
                            scaleType: productRecommendedData.scaleType,
                            onQuantityChanged: () {
                              context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                                    context: context,
                                    quantity: productStockData.quantity.toString(),
                                    productListIndex: 1,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: productRecommendedData.supplierId.toString(),
                                  ));
                            },
                            onQuantityIncreaseTap: () {
                              if (!(productRecommendedData.sale?.isMixedSale ?? false) &&
                                  int.parse(productRecommendedData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity + 1) {
                                context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                      context: context,
                                      productListIndex: 1,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: productRecommendedData.supplierId.toString(),
                                    ));

                                context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                      context: context,
                                      productId: productRecommendedData.id.toString(),
                                      productListIndex: 1,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: productRecommendedData.supplierId.toString(),
                                    ));
                              } else {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: productRecommendedData.id.toString(),
                                  minBox: productRecommendedData.sale?.saleMinQuantity.toString() ?? '0',
                                  index: index,
                                  supplierId: productRecommendedData.supplierId.toString(),
                                  productListIndex: 1,
                                  isIncrease: true,
                                  isMixedSale: productRecommendedData.sale?.isMixedSale,
                                  sameSaleProducts: productRecommendedData.sale?.sameSaleProducts,
                                );
                              }
                            },
                            onQuantityDecreaseTap: () {
                              if (productStockData.quantity != 0) {
                                if (!(productRecommendedData.sale?.isMixedSale ?? false) &&
                                    int.parse(productRecommendedData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                                  context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                        context: context,
                                        productListIndex: 1,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: productRecommendedData.supplierId.toString(),
                                      ));

                                  context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                        context: context,
                                        productId: productRecommendedData.id.toString(),
                                        productListIndex: 1,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: productRecommendedData.supplierId.toString(),
                                      ));
                                } else {
                                  showMinMaxQtyConfirmDialog(
                                    context: context,
                                    productId: productRecommendedData.id.toString(),
                                    minBox: productRecommendedData.sale?.saleMinQuantity.toString() ?? '0',
                                    index: index,
                                    supplierId: productRecommendedData.supplierId.toString(),
                                    productListIndex: 1,
                                    isIncrease: false,
                                    isMixedSale: productRecommendedData.sale?.isMixedSale,
                                    sameSaleProducts: productRecommendedData.sale?.sameSaleProducts,
                                  );
                                }
                              }
                            },
                            onButtonTap: () {
                              if (!state.isGuestUser) {
                                showProductDetails(
                                  isSaleOn: state.isSaleOn,
                                  context: Platform.isIOS ? context : context,
                                  productId: productRecommendedData.id ?? '',
                                  productStock: productRecommendedData.productStock.toString(),
                                  productListIndex: 1,
                                );
                              } else {
                                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                              }
                            });
                      }),
            ),
          ]),
          crossFadeState: state.recommendedProductsList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300))
      : 0.width;

  Widget previousOrderProductWidget(BuildContext context, StoreBloc bloc, StoreState state) => !state.isGuestUser
      ? AnimatedCrossFade(
          firstChild: getScreenWidth(context).width,
          secondChild: Column(children: [
            buildListTitles(
                context: context,
                title: AppLocalizations.of(context)!.previous_order_products,
                subTitle: AppLocalizations.of(context)!.more,
                onTap: () {
                  Navigator.pushNamed(context, RouteDefine.reorderScreen.name);
                }),
            SizedBox(
              width: getScreenWidth(context),
              height: getItemHeight(context, state.isSaleOn),
              child: state.isPreviousOrderShimmering
                  ? const CommonProductListShimmerWidget()
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: state.previousOrderProductsList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
                      itemBuilder: (context, index) {
                        var previousOrderData = state.previousOrderProductsList[index];
                        var productStockData = state.productStockList[0][index];
                        return CommonProductSaleItemWidget(
                            isSale: previousOrderData.sale?.isSale,
                            isGuestUser: state.isGuestUser,
                            onGuestLoginRequired: () => Navigator.pushNamed(context, RouteDefine.connectScreen.name),
                            height: AppConstants.salesProductItemHeight,
                            width: getItemWidth(context),
                            productName: previousOrderData.productName ?? '',
                            saleImage: previousOrderData.mainImage ?? '',
                            title: previousOrderData.name,
                            description: parse(previousOrderData.sale?.saleDescription).body?.text ?? '',
                            discountedPrice: double.parse(previousOrderData.sale?.salePrice ?? ''),
                            originalPrice: previousOrderData.productPrice,
                            productStock: previousOrderData.productStock.toString(),
                            lowStock: previousOrderData.lowStock ?? '',
                            isPesach: previousOrderData.isPesach,
                            quantity: productStockData.quantity,
                            minQuantity: previousOrderData.sale?.saleMinQuantity,
                            maxQuantity: previousOrderData.sale?.saleMaxQuantity,
                            isMixedSale: previousOrderData.sale?.isMixedSale,
                            numberOfUnits: previousOrderData.numberOfUnit.toString(),
                            scaleType: previousOrderData.scaleType,
                            onQuantityChanged: () {
                              context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                                    context: context,
                                    quantity: productStockData.quantity.toString(),
                                    productListIndex: 0,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: previousOrderData.supplierId.toString(),
                                  ));
                            },
                            onQuantityIncreaseTap: () {
                              if (!(previousOrderData.sale?.isMixedSale ?? false) &&
                                  int.parse(previousOrderData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity + 1) {
                                context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                      context: context,
                                      productListIndex: 0,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: previousOrderData.supplierId.toString(),
                                    ));

                                context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                      context: context,
                                      productId: previousOrderData.id.toString(),
                                      productListIndex: 0,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: previousOrderData.supplierId.toString(),
                                    ));
                              } else {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: previousOrderData.id.toString(),
                                  minBox: previousOrderData.sale?.saleMinQuantity.toString() ?? '0',
                                  index: index,
                                  supplierId: previousOrderData.supplierId.toString(),
                                  productListIndex: 0,
                                  isIncrease: true,
                                  isMixedSale: previousOrderData.sale?.isMixedSale,
                                  sameSaleProducts: previousOrderData.sale?.sameSaleProducts,
                                );
                              }
                            },
                            onQuantityDecreaseTap: () {
                              if (productStockData.quantity != 0) {
                                if (!(previousOrderData.sale?.isMixedSale ?? false) &&
                                    int.parse(previousOrderData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                                  context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                        context: context,
                                        productListIndex: 0,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: previousOrderData.supplierId.toString(),
                                      ));

                                  context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                        context: context,
                                        productId: previousOrderData.id.toString(),
                                        productListIndex: 0,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: previousOrderData.supplierId.toString(),
                                      ));
                                } else {
                                  showMinMaxQtyConfirmDialog(
                                    context: context,
                                    productId: previousOrderData.id.toString(),
                                    minBox: previousOrderData.sale?.saleMinQuantity.toString() ?? '0',
                                    index: index,
                                    supplierId: previousOrderData.supplierId.toString(),
                                    productListIndex: 0,
                                    isIncrease: false,
                                    isMixedSale: previousOrderData.sale?.isMixedSale,
                                    sameSaleProducts: previousOrderData.sale?.sameSaleProducts,
                                  );
                                }
                              }
                            },
                            onButtonTap: () {
                              if (!state.isGuestUser) {
                                showProductDetails(
                                  isSaleOn: state.isSaleOn,
                                  context: Platform.isIOS ? context : context,
                                  productId: previousOrderData.id ?? '',
                                  productStock: previousOrderData.productStock.toString(),
                                  productListIndex: 0,
                                );
                              } else {
                                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                              }
                            });
                      }),
            ),
          ]),
          crossFadeState: state.previousOrderProductsList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300))
      : 0.width;

  Widget searchWidget(BuildContext context, StoreBloc bloc, StoreState state) => CommonSearchWidget(
      isFilterTap: true,
      isCategoryExpand: state.isCategoryExpand,
      isSearching: state.isSearching,
      onFilterTap: () {
        bloc.add(const StoreEvent.changeCategoryExpansion());
      },
      onCloseTap: () {
        bloc.add(const StoreEvent.changeCategoryExpansion(isOpened: false));
        context.read<StoreBloc>().add(StoreEvent.getProductSalesListEvent(context: context));
        context.read<StoreBloc>().add(StoreEvent.getRecommendationProductsListEvent(context: context));
        context.read<StoreBloc>().add(StoreEvent.getPreviousOrderProductsListEvent(context: context));
      },
      onSearchTap: () {
        if (state.searchController.text.isNotEmpty) {
          bloc.add(const StoreEvent.changeCategoryExpansion(isOpened: true));
        }
      },
      onSearch: (String search) {
        if (search.length > 1) {
          bloc.add(const StoreEvent.changeCategoryExpansion(isOpened: true));
          bloc.add(StoreEvent.globalSearchEvent(context: context));
        }
      },
      onSearchSubmit: (String search) {
        Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
          AppStrings.searchString: state.search,
          AppStrings.searchType: SearchTypes.product.toString(),
        });
      },
      onOutSideTap: () {
        state.searchController.clear();
        bloc.add(const StoreEvent.changeCategoryExpansion(isOpened: false));
      },
      onSearchItemTap: () {
        bloc.add(const StoreEvent.changeCategoryExpansion());
      },
      controller: state.searchController,
      searchList: state.searchList,
      searchResultWidget: state.isSearching
          ? const SizedBox()
          : state.searchList.isEmpty
              ? noDataWidget(AppLocalizations.of(context)!.search_result_not_found)
              : ListView.builder(
                  itemCount: state.searchList.length,
                  shrinkWrap: true,
                  itemBuilder: (listViewContext, index) {
                    var productSearchData = state.searchList[index];
                    var productStockData = state.productStockList[4][index];
                    return SearchItemWidget(
                        isShowSeeAll: index == state.searchList.length - 1 ? true : false,
                        isGuestUser: state.isGuestUser,
                        priceOfBox: productSearchData.priceOfBox,
                        salePrice: productSearchData.salePrice,
                        saleDesc: productSearchData.salesDesc,
                        isPesach: productSearchData.isPesach,
                        lowStock: productSearchData.lowStock.toString(),
                        numberOfUnits: productSearchData.numberOfUnits,
                        scaleType: productSearchData.scaleType,
                        productStock: productSearchData.productStock.toString(),
                        context: context,
                        searchName: productSearchData.name,
                        searchImage: productSearchData.image,
                        searchType: productSearchData.searchType,
                        isMoreResults: state.searchList.where((search) => search.searchType == productSearchData.searchType).toList().isNotEmpty,
                        isLastItem: state.searchList.length - 1 == index,
                        quantity: productStockData.quantity,
                        isSale: productSearchData.isSale,
                        minQuantity: productSearchData.saleMinQuantity,
                        maxQuantity: productSearchData.saleMaxQuantity,
                        isMixedSale: productSearchData.isMixedSale,
                        onQuantityChanged: () {
                          context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                                context: context,
                                quantity: productStockData.quantity.toString(),
                                productListIndex: 4,
                                productStockUpdateIndex: index,
                                productSupplierIds: productSearchData.supplierId.toString(),
                              ));
                        },
                        onQuantityIncreaseTap: () {
                          if (!(productSearchData.isMixedSale ?? false) &&
                              int.parse(productSearchData.saleMinQuantity ?? '0') <= productStockData.quantity + 1) {
                            context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 4,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: productSearchData.supplierId.toString(),
                                ));

                            context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: productSearchData.searchId,
                                  productListIndex: 4,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: productSearchData.supplierId.toString(),
                                ));
                          } else {
                            showMinMaxQtyConfirmDialog(
                              context: context,
                              productId: productSearchData.searchId,
                              minBox: productSearchData.saleMinQuantity.toString(),
                              index: index,
                              supplierId: productSearchData.supplierId.toString(),
                              productListIndex: 4,
                              isIncrease: true,
                              isMixedSale: productSearchData.isMixedSale,
                              sameSaleProducts: productSearchData.sameSaleProducts,
                            );
                          }
                        },
                        onQuantityDecreaseTap: () {
                          if (productStockData.quantity != 0) {
                            if (!(productSearchData.isMixedSale ?? false) &&
                                int.parse(productSearchData.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                              context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 4,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: productSearchData.supplierId.toString(),
                                  ));

                              context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                    context: context,
                                    productId: productSearchData.searchId,
                                    productListIndex: 4,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: productSearchData.supplierId.toString(),
                                  ));
                            } else {
                              showMinMaxQtyConfirmDialog(
                                context: context,
                                productId: productSearchData.searchId,
                                minBox: productSearchData.saleMinQuantity.toString(),
                                index: index,
                                supplierId: productSearchData.supplierId.toString(),
                                productListIndex: 4,
                                isIncrease: false,
                                isMixedSale: productSearchData.isMixedSale,
                                sameSaleProducts: productSearchData.sameSaleProducts,
                              );
                            }
                          }
                        },
                        isShowSearchLabel: index == 0
                            ? true
                            : productSearchData.searchType != state.searchList[index - 1].searchType
                                ? true
                                : false,
                        onSeeAllTap: () async {
                          if (productSearchData.searchType == SearchTypes.category) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.productCategoryScreen.name, arguments: {
                              AppStrings.searchString: state.search,
                              AppStrings.reqSearchString: state.search,
                              AppStrings.searchResultString: state.searchList,
                            });
                            if (searchResult != null) {
                              bloc.add(StoreEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else if (productSearchData.searchType == SearchTypes.subCategory) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: productSearchData.categoryId,
                              AppStrings.categoryNameString: productSearchData.categoryName,
                              AppStrings.searchString: state.search,
                              AppStrings.searchResultString: state.searchList,
                            });
                            if (searchResult != null) {
                              bloc.add(StoreEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            productSearchData.searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyScreen.name, arguments: {AppStrings.searchString: state.search})
                                : productSearchData.searchType == SearchTypes.supplier
                                    ? Navigator.pushNamed(context, RouteDefine.supplierScreen.name,
                                        arguments: {AppStrings.searchString: state.search})
                                    : productSearchData.searchType == SearchTypes.sale
                                        ? Navigator.pushNamed(context, RouteDefine.productSaleScreen.name,
                                            arguments: {AppStrings.searchString: state.search})
                                        : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                            AppStrings.searchString: state.search,
                                            AppStrings.searchType: SearchTypes.product.toString(),
                                          });
                          }
                        },
                        onTap: () async {
                          if (productSearchData.searchType == SearchTypes.subCategory) {
                            inProgressSnackBarWidget(context);
                            return;
                          }
                          if (productSearchData.searchType == SearchTypes.sale || productSearchData.searchType == SearchTypes.product) {
                            showProductDetails(
                              context: context,
                              productId: productSearchData.searchId,
                              isBarcode: true,
                              planoGramIndex: 4,
                              isSaleOn: state.isSaleOn,
                              productStock: (productSearchData.productStock.toString()),
                            );
                          } else if (productSearchData.searchType == SearchTypes.category) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: productSearchData.searchId,
                              AppStrings.categoryNameString: productSearchData.name,
                              AppStrings.searchString: state.searchController.text,
                              AppStrings.searchResultString: state.searchList,
                            });
                            if (searchResult != null) {
                              bloc.add(StoreEvent.updateGlobalSearchEvent(
                                  search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            productSearchData.searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name,
                                    arguments: {AppStrings.companyIdString: productSearchData.searchId})
                                : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                    AppStrings.supplierIdString: productSearchData.searchId,
                                  });
                          }
                          bloc.add(const StoreEvent.changeCategoryExpansion());
                        });
                  }),
      onScanTap: () async {
        String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
        if (scanResult != '-1') {
          showProductDetails(
              context: context, productId: scanResult, isBarcode: true, productStock: '1', planoGramIndex: 4, isSaleOn: state.isSaleOn);
        }
      });

  void showProductDetails({
    required BuildContext context,
    required String productId,
    bool? isBarcode,
    String productStock = '0',
    bool isRelated = false,
    int planoGramIndex = 0,
    required bool isSaleOn,
    int productListIndex = 0,
  }) async {
    context.read<StoreBloc>().add(
        StoreEvent.getProductDetailsEvent(context: context, productId: productId, isBarcode: isBarcode ?? false, productListIndex: productListIndex));
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        clipBehavior: Clip.hardEdge,
        enableDrag: false,
        builder: (context1) {
          return SafeArea(
            bottom: false,
            child: DraggableScrollableSheet(
                expand: true,
                maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                minChildSize: productStock == '0' || productStock == '0.0'
                    ? 0.9
                    : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                initialChildSize: productStock == '0' || productStock == '0.0'
                    ? 0.9
                    : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                builder: (BuildContext context1, ScrollController scrollController) {
                  return BlocProvider.value(
                    value: context.read<StoreBloc>(),
                    child: BlocBuilder<StoreBloc, StoreState>(builder: (blocContext, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                          color: AppColors.whiteColor,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: state.isProductLoading
                            ? const ProductDetailsShimmerWidget()
                            : state.productDetails.isEmpty
                                ? NoDataBottomSheet(dialogContext: context)
                                : SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: ModalScrollController.of(context),
                                    child: Column(children: [
                                      CommonProductDetailsWidget(
                                          isIncludedVat: state.isIncludedVat,
                                          productDetails: state.productDetails,
                                          isSubUserAddToBasket: state.isSubUserAddToBasket,
                                          bottleTax: state.bottlePrice,
                                          totalBottleDeposit: (state.bottlePrice *
                                              (state.productDetails.first.numberOfUnit ?? 1) *
                                              state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                          isBottle: (state.productDetails.first.isBottle ?? false),
                                          addToOrderTap: () {
                                            final isMixedSale = state.productDetails.first.sale?.isMixedSale ?? false;
                                            if (!isMixedSale &&
                                                int.parse(state.productDetails.first.sale!.saleMinQuantity!) <=
                                                    state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
                                              context
                                                  .read<StoreBloc>()
                                                  .add(StoreEvent.addToCartProductEvent(context: context1, productId: productId));
                                            } else {
                                              showMinQtyConfirmDialog(
                                                context,
                                                productId,
                                                state.productDetails.first.sale!.saleMinQuantity.toString(),
                                                state.productDetails.first.sale!.isMixedSale,
                                                state.productDetails.first.sale!.sameSaleProducts,
                                              );
                                            }
                                          },
                                          isLoading: state.isLoading,
                                          imageOnTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Stack(children: [
                                                    SizedBox(
                                                      height: getScreenHeight(context) - MediaQuery.of(context).padding.top,
                                                      width: getScreenWidth(context),
                                                      child: GestureDetector(
                                                        onVerticalDragStart: (dragDetails) {},
                                                        onVerticalDragUpdate: (dragDetails) {},
                                                        onVerticalDragEnd: (endDetails) {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: PhotoView(
                                                          imageProvider: NetworkImage(
                                                              '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}'),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: const Padding(
                                                            padding: EdgeInsets.only(top: AppConstants.padding_10),
                                                            child: Icon(Icons.close, color: Colors.white))),
                                                  ]);
                                                });
                                          },
                                          context: context,
                                          productImages: [state.productDetails.first.mainImage ?? ''],
                                          productUnitPrice:
                                              double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? ''),
                                          scaleType: state.productDetails.first.scaleType,
                                          productPrice: (state.productDetails.first.sale?.isSale ?? false)
                                              ? double.parse(state.productDetails.first.sale?.salePrice ?? '') *
                                                  state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity *
                                                  (state.productDetails.first.numberOfUnit ?? 1)
                                              : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice *
                                                  state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity *
                                                  (state.productDetails.first.numberOfUnit ?? 1),
                                          productStock:
                                              (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                          scrollController: scrollController,
                                          productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                          isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                          recommendedRetailConsumerPricerOffer: ClubAgent.isClubClient(state.clubAgentId)
                                              ? state.productDetails.first.sale?.isSale == true
                                                  ? state.productDetails.first.recommendedConsumerOffer
                                                  : state.productDetails.first.recommendedRetailPrice
                                              : '',
                                          onQuantityChanged: (quantity) {
                                            context.read<StoreBloc>().add(StoreEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                          },
                                          onQuantityIncreaseTap: () {
                                            context.read<StoreBloc>().add(StoreEvent.increaseQuantityOfProduct(context: context1));
                                          },
                                          onQuantityDecreaseTap: () {
                                            if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                              context.read<StoreBloc>().add(StoreEvent.decreaseQuantityOfProduct(context: context1));
                                            }
                                          },
                                          onCloseTap: () {
                                            context.read<StoreBloc>().add(StoreEvent.getProductSalesListEvent(context: context1));
                                            context.read<StoreBloc>().add(StoreEvent.getRecommendationProductsListEvent(context: context1));
                                            context.read<StoreBloc>().add(StoreEvent.getPreviousOrderProductsListEvent(context: context1));
                                            Navigator.pop(context);
                                          }),
                                      10.height,
                                      state.isRelatedShimmering
                                          ? const RelatedProductShimmerWidget()
                                          : state.relatedProductList.isEmpty
                                              ? 0.width
                                              : relatedProductWidget(context1, state.relatedProductList, context, isSaleOn)
                                    ]),
                                  ),
                      );
                    }),
                  );
                }),
          );
        });
  }

  Widget relatedProductWidget(BuildContext prevContext, List<RelatedProductDatum> relatedProductList, BuildContext context, bool isSaleOn) {
    return BlocProvider.value(
        value: context.read<StoreBloc>(),
        child: BlocBuilder<StoreBloc, StoreState>(builder: (blocContext, state) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            relatedProductTitle(context),
            Container(
              height: getItemHeight(context, isSaleOn),
              padding: const EdgeInsets.only(left: AppConstants.padding_10, right: AppConstants.padding_10, top: AppConstants.padding_10),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context2, i) {
                  var relatedProductData = relatedProductList.elementAt(i);
                  var productStockData = state.productStockList[2].firstWhere;
                  var productStockIndexData = state.productStockList[2].indexWhere;
                  return CommonProductSaleItemWidget(
                      isSale: relatedProductData.sale?.isSale,
                      isGuestUser: state.isGuestUser,
                      onGuestLoginRequired: () => Navigator.pushNamed(context, RouteDefine.connectScreen.name),
                      height: isSaleOn ? AppConstants.salesProductItemHeight : AppConstants.withoutSaleItemHeight,
                      width: getItemWidth(context),
                      productName: relatedProductData.productName ?? '',
                      saleImage: relatedProductData.mainImage ?? '',
                      title: relatedProductData.name,
                      description: parse(relatedProductData.sale?.saleDescription).body?.text ?? '',
                      discountedPrice: double.parse(relatedProductData.sale?.salePrice ?? '0'),
                      originalPrice: relatedProductData.productPrice,
                      productStock: relatedProductData.productStock.toString(),
                      lowStock: relatedProductData.lowStock ?? '',
                      isPesach: relatedProductData.isPesach,
                      quantity: productStockData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id).quantity,
                      minQuantity: relatedProductData.sale?.saleMinQuantity,
                      maxQuantity: relatedProductData.sale?.saleMaxQuantity,
                      isMixedSale: relatedProductData.sale?.isMixedSale,
                      numberOfUnits: relatedProductData.numberOfUnit.toString(),
                      scaleType: relatedProductData.scaleType,
                      onQuantityChanged: () {
                        context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                              context: context,
                              quantity: productStockData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id)
                                  .quantity
                                  .toString(),
                              productListIndex: 2,
                              productStockUpdateIndex:
                                  productStockIndexData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                              productSupplierIds: relatedProductList[i].supplierId.toString(),
                            ));
                      },
                      onQuantityIncreaseTap: () {
                        if (!(relatedProductList[i].sale?.isMixedSale ?? false) &&
                            int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <=
                                productStockData((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id)
                                        .quantity +
                                    1) {
                          context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 2,
                                productStockUpdateIndex:
                                    productStockIndexData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                                productSupplierIds: relatedProductList[i].supplierId.toString(),
                              ));

                          context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                context: context,
                                productId: relatedProductList[i].id.toString(),
                                productListIndex: 2,
                                productStockUpdateIndex:
                                    productStockIndexData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                                productSupplierIds: relatedProductList[i].supplierId.toString(),
                              ));
                        } else {
                          showMinMaxQtyConfirmDialog(
                            context: context,
                            productId: relatedProductList[i].id.toString(),
                            minBox: relatedProductData.sale?.saleMinQuantity.toString() ?? '0',
                            index: productStockIndexData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                            supplierId: relatedProductList[i].supplierId.toString(),
                            productListIndex: 2,
                            isIncrease: true,
                            isMixedSale: relatedProductList[i].sale?.isMixedSale,
                            sameSaleProducts: relatedProductList[i].sale?.sameSaleProducts,
                          );
                        }
                      },
                      onQuantityDecreaseTap: () {
                        if (productStockData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id).quantity != 0) {
                          if (!(relatedProductList[i].sale?.isMixedSale ?? false) &&
                              int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <=
                                  productStockData(
                                              (relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id)
                                          .quantity -
                                      1) {
                            context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 2,
                                  productStockUpdateIndex:
                                      productStockIndexData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                                  productSupplierIds: relatedProductList[i].supplierId.toString(),
                                ));

                            context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: relatedProductList[i].id.toString(),
                                  productListIndex: 2,
                                  productStockUpdateIndex:
                                      productStockIndexData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                                  productSupplierIds: relatedProductList[i].supplierId.toString(),
                                ));
                          } else {
                            showMinMaxQtyConfirmDialog(
                              context: context,
                              productId: relatedProductList[i].id.toString(),
                              minBox: relatedProductData.sale?.saleMinQuantity.toString() ?? '0',
                              index: productStockIndexData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                              supplierId: relatedProductList[i].supplierId.toString(),
                              productListIndex: 2,
                              isIncrease: false,
                              isMixedSale: relatedProductList[i].sale?.isMixedSale,
                              sameSaleProducts: relatedProductList[i].sale?.sameSaleProducts,
                            );
                          }
                        }
                      },
                      onButtonTap: () {
                        Navigator.pop(prevContext);
                        showProductDetails(
                          isSaleOn: isSaleOn,
                          context: context,
                          productId: relatedProductList[i].id ?? '',
                          isBarcode: false,
                          productStock: (relatedProductList[i].productStock.toString()),
                          productListIndex: 2,
                        );
                      });
                },
                itemCount: relatedProductList.length,
              ),
            )
          ]);
        }));
  }

  // The min-quantity promotion now opens a rich bottom sheet (steppers per
  // participating product + a cumulative progress bar toward the minimum)
  // instead of the old read-only dialog. Legacy params are kept so the many
  // call sites stay unchanged; only [productId] is needed by the sheet.
  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox, bool? isMixedSale, List? sameSaleProducts) {
    _openSalePromotionSheet(context, productId);
  }

  void showMinMaxQtyConfirmDialog({
    required BuildContext context,
    required String productId,
    required String minBox,
    required int index,
    required dynamic supplierId,
    required int productListIndex,
    required bool isIncrease,
    bool? isMixedSale,
    List? sameSaleProducts,
  }) {
    _openSalePromotionSheet(context, productId);
  }

  Future<void> _openSalePromotionSheet(BuildContext context, String productId) async {
    final StoreBloc bloc = context.read<StoreBloc>();
    if (bloc.state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final bool changed = await showSalePromotionSheet(context: context, productId: productId, l10n: l10n);
    if (!changed || !context.mounted) return;
    final cartMap = await fetchCartQuantities(context);
    if (!context.mounted) return;
    bloc.add(StoreEvent.applyCartQuantitiesEvent(cartQuantities: cartMap));
    bloc.add(StoreEvent.getCartCountEvent(context: context));
  }

  appUnderMaintenanceDialog({required BuildContext context, required StoreState state}) {
    if (!state.isDialogOpen) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context1) => BlocProvider.value(
                value: context.read<StoreBloc>(),
                child: BlocBuilder<StoreBloc, StoreState>(builder: (context, state) {
                  StoreBloc bloc = context.read<StoreBloc>();
                  return CustomOneButtonDialog(
                      isLoading: state.retryLoading,
                      directionality: state.language,
                      title: AppLocalizations.of(context)!.under_maintenance,
                      positiveTitle: AppLocalizations.of(context)!.retry,
                      positiveOnTap: () async {
                        bloc.add(StoreEvent.generalSettings(context: context, dialogContext: context1, isRetryLoading: true));
                      });
                }),
              ));
    } else {
      context.read<StoreBloc>().add(StoreEvent.updateMaintenanceEvent(context: context));
    }
  }

  Widget dataAnalyticsButtonWidget(BuildContext context, StoreState state) {
    final buttonText = state.language == 'en' ? state.buttonEnglishText : state.buttonHebrewText;
    if (!state.showClientDataOnApp || buttonText == null || buttonText.isEmpty) {
      return 0.width;
    }
    return CustomTextIconButtonWidget(
      width: double.maxFinite,
      title: buttonText,
      onPressed: () {
        Navigator.pushNamed(context, RouteDefine.webViewScreen.name);
      },
    );
  }
}
