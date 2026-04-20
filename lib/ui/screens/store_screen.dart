import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import '../widget/common_dialog_with_one_button.dart';
import '../widget/common_search_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/custom_dialog.dart';
import '../widget/custom_text_icon_button_widget.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/pesach_banner_shimmer.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_screen_shimmer_widget.dart';
import 'build_list_title.dart';

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
          ..add(StoreEvent.getSuppliersListEvent(context: context))
          ..add(StoreEvent.getProductCategoriesListEvent(context: context))
          ..add(StoreEvent.getCompaniesListEvent(context: context))
          ..add(StoreEvent.getProductSalesListEvent(context: context))
          ..add(StoreEvent.getRecommendationProductsListEvent(context: context))
          ..add(StoreEvent.getPreviousOrderProductsListEvent(context: context))
          ..add(const StoreEvent.getPreferencesDataEvent());
      },
      child: const StoreScreenWidget(),
    );
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
                                  categoryListWidget(context, bloc, state),
                                  companyListWidget(context, bloc, state),
                                  pesachBannerWidget(context, state),
                                  supplierListWidget(context, bloc, state),
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

  Widget dataAnalyticsButtonWidget(BuildContext context, StoreState state) => state.showClientDataOnApp
      ? CustomTextIconButtonWidget(
          width: double.maxFinite,
          title: state.language == 'en' ? state.buttonEnglishText! : state.buttonHebrewText!,
          onPressed: () {
            Navigator.pushNamed(context, RouteDefine.webViewScreen.name);
          })
      : 0.width;

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
                    bloc.add(StoreEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
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
                              bloc.add(StoreEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          },
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.padding_10)),
                              child: state.productCategoryList[index].categoryImage!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: "${AppUrlEndPoints.baseFileUrl}${state.productCategoryList[index].categoryImage}",
                                      fit: BoxFit.cover,
                                      height: 140,
                                      width: 105,
                                      alignment: Alignment.center,
                                      placeholder: (context, url) {
                                        return CommonShimmerWidget(child: Container(height: 140, width: 105, decoration: BoxDecoration(color: AppColors.whiteColor)));
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
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppConstants.radius_10), bottomRight: Radius.circular(AppConstants.radius_10)),
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
                title: AppLocalizations.of(context)!.companies,
                subTitle: AppLocalizations.of(context)!.all_companies,
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
                            return CommonShimmerWidget(child: Container(height: 110, width: 105, decoration: BoxDecoration(color: AppColors.whiteColor)));
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
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(AppConstants.radius_10), bottomLeft: Radius.circular(AppConstants.radius_10)),
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

  Widget supplierListWidget(BuildContext context, StoreBloc bloc, StoreState state) => AnimatedCrossFade(
      firstChild: getScreenWidth(context).width,
      secondChild: Column(children: [
        state.isSupplierVisible
            ? buildListTitles(
                context: context,
                title: AppLocalizations.of(context)!.suppliers,
                subTitle: AppLocalizations.of(context)!.all_suppliers,
                onTap: () {
                  Navigator.pushNamed(context, RouteDefine.supplierScreen.name);
                })
            : Container(),
        SizedBox(
          width: getScreenWidth(context),
          height: state.isSupplierVisible ? 130 : 0,
          child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: state.suppliersList.data?.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
              itemBuilder: (context, index) {
                return buildCompanyListItem(
                    companyLogo: state.suppliersList.data?[index].logo ?? '',
                    companyName: state.suppliersList.data?[index].supplierDetail?.companyName ?? '',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteDefine.supplierProductsScreen.name,
                        arguments: {AppStrings.supplierIdString: state.suppliersList.data?[index].id ?? ''},
                      );
                    });
              }),
        ),
      ]),
      crossFadeState: state.suppliersList.data?.isEmpty ?? true ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300));

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
                        return CommonProductSaleItemWidget(
                            isSale: state.productSalesList[index].sale?.isSale,
                            isGuestUser: state.isGuestUser,
                            height: AppConstants.salesProductItemHeight,
                            width: getItemWidth(context),
                            productName: state.productSalesList[index].productName ?? '',
                            saleImage: state.productSalesList[index].mainImage ?? '',
                            title: state.productSalesList[index].name,
                            description: parse(state.productSalesList[index].sale?.saleDescription).body?.text ?? '',
                            discountedPrice: double.parse(state.productSalesList[index].sale?.salePrice ?? ""),
                            originalPrice: state.productSalesList[index].productPrice,
                            productStock: state.productSalesList[index].productStock.toString(),
                            lowStock: state.productSalesList[index].lowStock ?? '',
                            isPesach: state.productSalesList[index].isPesach,
                            quantity: state.productStockList[3][index].quantity,
                            minQuantity: state.productSalesList[index].sale?.saleMinQuantity,
                            maxQuantity: state.productSalesList[index].sale?.saleMaxQuantity,
                            isMixedSale: state.productSalesList[index].sale?.isMixedSale,
                            onQuantityChanged: () {
                              context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                                    context: context,
                                    quantity: state.productStockList[3][index].quantity.toString(),
                                    productListIndex: 3,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                  ));
                            },
                            onQuantityIncreaseTap: () {
                              if (int.parse(state.productSalesList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[3][index].quantity + 1) {
                                context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                      context: context,
                                      productListIndex: 3,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                    ));

                                context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                      context: context,
                                      productId: state.productSalesList[index].id.toString(),
                                      productListIndex: 3,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                    ));
                              } else {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: state.productSalesList[index].id.toString(),
                                  minBox: state.productSalesList[index].sale?.saleMinQuantity.toString() ?? '0',
                                  index: index,
                                  supplierId: state.productSalesList[index].supplierId.toString(),
                                  productListIndex: 3,
                                  isIncrease: true,
                                  isMixedSale: state.productSalesList[index].sale?.isMixedSale,
                                  sameSaleProducts: state.productSalesList[index].sale?.sameSaleProducts,
                                );
                              }
                            },
                            onQuantityDecreaseTap: () {
                              if (state.productStockList[3][index].quantity != 0) {
                                if (int.parse(state.productSalesList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[3][index].quantity - 1) {
                                  context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                        context: context,
                                        productListIndex: 3,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                      ));

                                  context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                        context: context,
                                        productId: state.productSalesList[index].id.toString(),
                                        productListIndex: 3,
                                        productStockUpdateIndex: index,
                                        productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                      ));
                                } else {
                                  showMinMaxQtyConfirmDialog(
                                    context: context,
                                    productId: state.productSalesList[index].id.toString(),
                                    minBox: state.productSalesList[index].sale?.saleMinQuantity.toString() ?? '0',
                                    index: index,
                                    supplierId: state.productSalesList[index].supplierId.toString(),
                                    productListIndex: 3,
                                    isIncrease: false,
                                    isMixedSale: state.productSalesList[index].sale?.isMixedSale,
                                    sameSaleProducts: state.productSalesList[index].sale?.sameSaleProducts,
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
                                  productId: state.productSalesList[index].id ?? '',
                                  productStock: state.productSalesList[index].productStock.toString(),
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
                      itemBuilder: (context, index) => CommonProductSaleItemWidget(
                          isSale: state.recommendedProductsList[index].sale?.isSale,
                          isGuestUser: state.isGuestUser,
                          height: AppConstants.salesProductItemHeight,
                          width: getItemWidth(context),
                          productName: state.recommendedProductsList[index].productName ?? '',
                          saleImage: state.recommendedProductsList[index].mainImage ?? '',
                          title: state.recommendedProductsList[index].name,
                          description: parse(state.recommendedProductsList[index].sale?.saleDescription).body?.text ?? '',
                          discountedPrice: double.parse(state.recommendedProductsList[index].sale?.salePrice ?? ''),
                          originalPrice: state.recommendedProductsList[index].productPrice,
                          productStock: state.recommendedProductsList[index].productStock.toString(),
                          lowStock: state.recommendedProductsList[index].lowStock ?? '',
                          isPesach: state.recommendedProductsList[index].isPesach,
                          quantity: state.productStockList[1][index].quantity,
                          minQuantity: state.recommendedProductsList[index].sale?.saleMinQuantity,
                          maxQuantity: state.recommendedProductsList[index].sale?.saleMaxQuantity,
                          isMixedSale: state.recommendedProductsList[index].sale?.isMixedSale,

                          onQuantityChanged: () {
                            context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                                  context: context,
                                  quantity: state.productStockList[1][index].quantity.toString(),
                                  productListIndex: 1,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.recommendedProductsList[index].supplierId.toString(),
                                ));
                          },
                          onQuantityIncreaseTap: () {
                            if (int.parse(state.recommendedProductsList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity + 1) {
                              context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 1,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.recommendedProductsList[index].supplierId.toString(),
                                  ));

                              context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                    context: context,
                                    productId: state.recommendedProductsList[index].id.toString(),
                                    productListIndex: 1,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.recommendedProductsList[index].supplierId.toString(),
                                  ));
                            } else {
                              showMinMaxQtyConfirmDialog(
                                context: context,
                                productId: state.recommendedProductsList[index].id.toString(),
                                minBox: state.recommendedProductsList[index].sale?.saleMinQuantity.toString() ?? '0',
                                index: index,
                                supplierId: state.recommendedProductsList[index].supplierId.toString(),
                                productListIndex: 1,
                                isIncrease: true,
                                isMixedSale: state.recommendedProductsList[index].sale?.isMixedSale,
                                sameSaleProducts: state.recommendedProductsList[index].sale?.sameSaleProducts,
                              );
                            }
                          },
                          onQuantityDecreaseTap: () {
                            if (state.productStockList[1][index].quantity != 0) {
                              if (int.parse(state.recommendedProductsList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity - 1) {
                                context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                      context: context,
                                      productListIndex: 1,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: state.recommendedProductsList[index].supplierId.toString(),
                                    ));

                                context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                      context: context,
                                      productId: state.recommendedProductsList[index].id.toString(),
                                      productListIndex: 1,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: state.recommendedProductsList[index].supplierId.toString(),
                                    ));
                              } else {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: state.recommendedProductsList[index].id.toString(),
                                  minBox: state.recommendedProductsList[index].sale?.saleMinQuantity.toString() ?? '0',
                                  index: index,
                                  supplierId: state.recommendedProductsList[index].supplierId.toString(),
                                  productListIndex: 1,
                                  isIncrease: false,
                                  isMixedSale: state.recommendedProductsList[index].sale?.isMixedSale,
                                  sameSaleProducts: state.recommendedProductsList[index].sale?.sameSaleProducts,
                                );
                              }
                            }
                          },
                          onButtonTap: () {
                            if (!state.isGuestUser) {
                              showProductDetails(
                                isSaleOn: state.isSaleOn,
                                context: Platform.isIOS ? context : context,
                                productId: state.recommendedProductsList[index].id ?? '',
                                productStock: state.recommendedProductsList[index].productStock.toString(),
                                productListIndex: 1,
                              );
                            } else {
                              Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                            }
                          })),
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
                      itemBuilder: (context, index) => CommonProductSaleItemWidget(
                          isSale: state.previousOrderProductsList[index].sale?.isSale,
                          isGuestUser: state.isGuestUser,
                          height: AppConstants.salesProductItemHeight,
                          width: getItemWidth(context),
                          productName: state.previousOrderProductsList[index].productName ?? '',
                          saleImage: state.previousOrderProductsList[index].mainImage ?? '',
                          title: state.previousOrderProductsList[index].name,
                          description: parse(state.previousOrderProductsList[index].sale?.saleDescription).body?.text ?? '',
                          discountedPrice: double.parse(state.previousOrderProductsList[index].sale?.salePrice ?? ''),
                          originalPrice: state.previousOrderProductsList[index].productPrice,
                          productStock: state.previousOrderProductsList[index].productStock.toString(),
                          lowStock: state.previousOrderProductsList[index].lowStock ?? '',
                          isPesach: state.previousOrderProductsList[index].isPesach,
                          quantity: state.productStockList[0][index].quantity,
                          minQuantity: state.previousOrderProductsList[index].sale?.saleMinQuantity,
                          maxQuantity: state.previousOrderProductsList[index].sale?.saleMaxQuantity,
                          isMixedSale: state.previousOrderProductsList[index].sale?.isMixedSale,

                          onQuantityChanged: () {
                            context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                                  context: context,
                                  quantity: state.productStockList[0][index].quantity.toString(),
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.previousOrderProductsList[index].supplierId.toString(),
                                ));
                          },
                          onQuantityIncreaseTap: () {
                            if (int.parse(state.previousOrderProductsList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity + 1) {
                              context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 0,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.previousOrderProductsList[index].supplierId.toString(),
                                  ));

                              context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                    context: context,
                                    productId: state.previousOrderProductsList[index].id.toString(),
                                    productListIndex: 0,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.previousOrderProductsList[index].supplierId.toString(),
                                  ));
                            } else {
                              showMinMaxQtyConfirmDialog(
                                context: context,
                                productId: state.previousOrderProductsList[index].id.toString(),
                                minBox: state.previousOrderProductsList[index].sale?.saleMinQuantity.toString() ?? '0',
                                index: index,
                                supplierId: state.previousOrderProductsList[index].supplierId.toString(),
                                productListIndex: 0,
                                isIncrease: true,
                                isMixedSale: state.previousOrderProductsList[index].sale?.isMixedSale,
                                sameSaleProducts: state.previousOrderProductsList[index].sale?.sameSaleProducts,
                              );
                            }
                          },
                          onQuantityDecreaseTap: () {
                            if (state.productStockList[0][index].quantity != 0) {
                              if (int.parse(state.previousOrderProductsList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity - 1) {
                                context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                      context: context,
                                      productListIndex: 0,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: state.previousOrderProductsList[index].supplierId.toString(),
                                    ));

                                context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                      context: context,
                                      productId: state.previousOrderProductsList[index].id.toString(),
                                      productListIndex: 0,
                                      productStockUpdateIndex: index,
                                      productSupplierIds: state.previousOrderProductsList[index].supplierId.toString(),
                                    ));
                              } else {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: state.previousOrderProductsList[index].id.toString(),
                                  minBox: state.previousOrderProductsList[index].sale?.saleMinQuantity.toString() ?? '0',
                                  index: index,
                                  supplierId: state.previousOrderProductsList[index].supplierId.toString(),
                                  productListIndex: 0,
                                  isIncrease: false,
                                  isMixedSale: state.previousOrderProductsList[index].sale?.isMixedSale,
                                  sameSaleProducts: state.previousOrderProductsList[index].sale?.sameSaleProducts,
                                );
                              }
                            }
                          },
                          onButtonTap: () {
                            if (!state.isGuestUser) {
                              showProductDetails(
                                isSaleOn: state.isSaleOn,
                                context: Platform.isIOS ? context : context,
                                productId: state.previousOrderProductsList[index].id ?? '',
                                productStock: state.previousOrderProductsList[index].productStock.toString(),
                                productListIndex: 0,
                              );
                            } else {
                              Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                            }
                          })),
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
                    return SearchItemWidget(
                        isShowSeeAll: index == state.searchList.length - 1 ? true : false,
                        isGuestUser: state.isGuestUser,
                        priceOfBox: state.searchList[index].priceOfBox,
                        salePrice: state.searchList[index].salePrice,
                        saleDesc: state.searchList[index].salesDesc,
                        isPesach: state.searchList[index].isPesach,
                        lowStock: state.searchList[index].lowStock.toString(),
                        numberOfUnits: state.searchList[index].numberOfUnits,
                        productStock: state.searchList[index].productStock.toString(),
                        context: context,
                        searchName: state.searchList[index].name,
                        searchImage: state.searchList[index].image,
                        searchType: state.searchList[index].searchType,
                        isMoreResults: state.searchList.where((search) => search.searchType == state.searchList[index].searchType).toList().isNotEmpty,
                        isLastItem: state.searchList.length - 1 == index,
                        quantity: state.productStockList[4][index].quantity,
                        isSale: state.searchList[index].isSale,
                        minQuantity: state.searchList[index].saleMinQuantity,
                        maxQuantity: state.searchList[index].saleMaxQuantity,
                        isMixedSale: state.searchList[index].isMixedSale,

                        onQuantityChanged: () {
                          context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                                context: context,
                                quantity: state.productStockList[4][index].quantity.toString(),
                                productListIndex: 4,
                                productStockUpdateIndex: index,
                                productSupplierIds: state.searchList[index].supplierId.toString(),
                              ));
                        },
                        onQuantityIncreaseTap: () {
                          if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[4][index].quantity + 1) {
                            context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 4,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.searchList[index].supplierId.toString(),
                                ));

                            context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: state.searchList[index].searchId,
                                  productListIndex: 4,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.searchList[index].supplierId.toString(),
                                ));
                          } else {
                            showMinMaxQtyConfirmDialog(
                              context: context,
                              productId: state.searchList[index].searchId,
                              minBox: state.searchList[index].saleMinQuantity.toString(),
                              index: index,
                              supplierId: state.searchList[index].supplierId.toString(),
                              productListIndex: 4,
                              isIncrease: true,
                              isMixedSale: state.searchList[index].isMixedSale,
                              sameSaleProducts: state.searchList[index].sameSaleProducts,
                            );
                          }
                        },
                        onQuantityDecreaseTap: () {
                          if (state.productStockList[4][index].quantity != 0) {
                            if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[4][index].quantity - 1) {
                              context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 4,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.searchList[index].supplierId.toString(),
                                  ));

                              context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                    context: context,
                                    productId: state.searchList[index].searchId,
                                    productListIndex: 4,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.searchList[index].supplierId.toString(),
                                  ));
                            } else {
                              showMinMaxQtyConfirmDialog(
                                context: context,
                                productId: state.searchList[index].searchId,
                                minBox: state.searchList[index].saleMinQuantity.toString(),
                                index: index,
                                supplierId: state.searchList[index].supplierId.toString(),
                                productListIndex: 4,
                                isIncrease: false,
                                isMixedSale: state.searchList[index].isMixedSale,
                                sameSaleProducts: state.searchList[index].sameSaleProducts,
                              );
                            }
                          }
                        },
                        isShowSearchLabel: index == 0
                            ? true
                            : state.searchList[index].searchType != state.searchList[index - 1].searchType
                                ? true
                                : false,
                        onSeeAllTap: () async {
                          if (state.searchList[index].searchType == SearchTypes.category) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.productCategoryScreen.name, arguments: {
                              AppStrings.searchString: state.search,
                              AppStrings.reqSearchString: state.search,
                              AppStrings.searchResultString: state.searchList,
                            });
                            if (searchResult != null) {
                              bloc.add(StoreEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else if (state.searchList[index].searchType == SearchTypes.subCategory) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: state.searchList[index].categoryId,
                              AppStrings.categoryNameString: state.searchList[index].categoryName,
                              AppStrings.searchString: state.search,
                              AppStrings.searchResultString: state.searchList,
                            });
                            if (searchResult != null) {
                              bloc.add(StoreEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            state.searchList[index].searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyScreen.name, arguments: {
                                    AppStrings.searchString: state.search,
                                  })
                                : state.searchList[index].searchType == SearchTypes.supplier
                                    ? Navigator.pushNamed(context, RouteDefine.supplierScreen.name, arguments: {
                                        AppStrings.searchString: state.search,
                                      })
                                    : state.searchList[index].searchType == SearchTypes.sale
                                        ? Navigator.pushNamed(context, RouteDefine.productSaleScreen.name, arguments: {
                                            AppStrings.searchString: state.search,
                                          })
                                        : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                            AppStrings.searchString: state.search,
                                            AppStrings.searchType: SearchTypes.product.toString(),
                                          });
                          }
                        },
                        onTap: () async {
                          if (state.searchList[index].searchType == SearchTypes.subCategory) {
                            inProgressSnackBarWidget(context);
                            return;
                          }
                          if (state.searchList[index].searchType == SearchTypes.sale || state.searchList[index].searchType == SearchTypes.product) {
                            showProductDetails(
                              context: context,
                              productId: state.searchList[index].searchId,
                              isBarcode: true,
                              planoGramIndex: 4,
                              isSaleOn: state.isSaleOn,
                              productStock: (state.searchList[index].productStock.toString()),
                            );
                          } else if (state.searchList[index].searchType == SearchTypes.category) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: state.searchList[index].searchId,
                              AppStrings.categoryNameString: state.searchList[index].name,
                              AppStrings.searchString: state.searchController.text,
                              AppStrings.searchResultString: state.searchList,
                            });
                            if (searchResult != null) {
                              bloc.add(StoreEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            state.searchList[index].searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {AppStrings.companyIdString: state.searchList[index].searchId})
                                : Navigator.pushNamed(
                                    context,
                                    RouteDefine.supplierProductsScreen.name,
                                    arguments: {AppStrings.supplierIdString: state.searchList[index].searchId},
                                  );
                          }
                          bloc.add(const StoreEvent.changeCategoryExpansion());
                        });
                  }),
      onScanTap: () async {
        String scanResult = await scanBarcodeOrQRCode(
          context: context,
          cancelText: AppLocalizations.of(context)!.cancel,
          scanMode: ScanMode.BARCODE,
        );
        if (scanResult != '-1') {
          showProductDetails(
            context: context,
            productId: scanResult,
            isBarcode: true,
            productStock: '1',
            planoGramIndex: 4,
            isSaleOn: state.isSaleOn,
          );
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
    context.read<StoreBloc>().add(StoreEvent.getProductDetailsEvent(context: context, productId: productId, isBarcode: isBarcode ?? false, productListIndex: productListIndex));
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
                minChildSize: productStock == '0' || productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                initialChildSize: productStock == '0' || productStock == '0.0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.2),
                builder: (BuildContext context1, ScrollController scrollController) {
                  return BlocProvider.value(
                    value: context.read<StoreBloc>(),
                    child: BlocBuilder<StoreBloc, StoreState>(builder: (blocContext, state) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
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
                                          totalBottleDeposit: (state.bottlePrice * (state.productDetails.first.numberOfUnit ?? 1) * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                          isBottle: (state.productDetails.first.isBottle ?? false),
                                          addToOrderTap: () {
                                            if (int.parse(state.productDetails.first.sale!.saleMinQuantity!) <= state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
                                              context.read<StoreBloc>().add(StoreEvent.addToCartProductEvent(context: context1, productId: productId));
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
                                                          imageProvider: NetworkImage('${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}'),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets.only(top: AppConstants.padding_10),
                                                          child: Icon(Icons.close, color: Colors.white),
                                                        )),
                                                  ]);
                                                });
                                          },
                                          context: context,
                                          productImages: [state.productDetails.first.mainImage ?? ''],
                                          productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? ''),
                                          productPrice: (state.productDetails.first.sale?.isSale ?? false) ? double.parse(state.productDetails.first.sale?.salePrice ?? '') * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1) : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                          productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                          scrollController: scrollController,
                                          productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                          isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                          recommendedRetailConsumerPricerOffer: state.clubAgentId == AppStrings.clubAgentIdText
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
                  return CommonProductSaleItemWidget(
                      isSale: relatedProductList.elementAt(i).sale?.isSale,
                      isGuestUser: false,
                      height: isSaleOn ? AppConstants.salesProductItemHeight : AppConstants.withoutSaleItemHeight,
                      width: getItemWidth(context),
                      productName: relatedProductList.elementAt(i).productName ?? '',
                      saleImage: relatedProductList.elementAt(i).mainImage ?? '',
                      title: relatedProductList.elementAt(i).name,
                      description: parse(relatedProductList.elementAt(i).sale?.saleDescription).body?.text ?? '',
                      discountedPrice: double.parse(relatedProductList.elementAt(i).sale?.salePrice ?? '0'),
                      originalPrice: relatedProductList.elementAt(i).productPrice,
                      productStock: relatedProductList.elementAt(i).productStock.toString(),
                      lowStock: relatedProductList.elementAt(i).lowStock ?? '',
                      isPesach: relatedProductList.elementAt(i).isPesach,
                      quantity: state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity, //[i].quantity,
                      minQuantity: relatedProductList.elementAt(i).sale?.saleMinQuantity,
                      maxQuantity: relatedProductList.elementAt(i).sale?.saleMaxQuantity,
                      isMixedSale: relatedProductList.elementAt(i).sale?.isMixedSale,

                      onQuantityChanged: () {
                        context.read<StoreBloc>().add(StoreEvent.updateListQuantityOfProduct(
                              context: context,
                              quantity: state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity.toString(),
                              productListIndex: 2,
                              productStockUpdateIndex: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                              productSupplierIds: relatedProductList[i].supplierId.toString(),
                            ));
                      },
                      onQuantityIncreaseTap: () {
                        if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity + 1) {
                          context.read<StoreBloc>().add(StoreEvent.increaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 2,
                                productStockUpdateIndex: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                                productSupplierIds: relatedProductList[i].supplierId.toString(),
                              ));

                          context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                context: context,
                                productId: relatedProductList[i].id.toString(),
                                productListIndex: 2,
                                productStockUpdateIndex: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                                productSupplierIds: relatedProductList[i].supplierId.toString(),
                              ));
                        } else {
                          showMinMaxQtyConfirmDialog(
                            context: context,
                            productId: relatedProductList[i].id.toString(),
                            minBox: relatedProductList.elementAt(i).sale?.saleMinQuantity.toString() ?? '0',
                            index: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            supplierId: relatedProductList[i].supplierId.toString(),
                            productListIndex: 2,
                            isIncrease: true,
                            isMixedSale: relatedProductList[i].sale?.isMixedSale,
                            sameSaleProducts: relatedProductList[i].sale?.sameSaleProducts,
                          );
                        }
                      },
                      onQuantityDecreaseTap: () {
                        if (state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity != 0) {
                          if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity - 1) {
                            context.read<StoreBloc>().add(StoreEvent.decreaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 2,
                                  productStockUpdateIndex: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                                  productSupplierIds: relatedProductList[i].supplierId.toString(),
                                ));

                            context.read<StoreBloc>().add(StoreEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: relatedProductList[i].id.toString(),
                                  productListIndex: 2,
                                  productStockUpdateIndex: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                                  productSupplierIds: relatedProductList[i].supplierId.toString(),
                                ));
                          } else {
                            showMinMaxQtyConfirmDialog(
                              context: context,
                              productId: relatedProductList[i].id.toString(),
                              minBox: relatedProductList.elementAt(i).sale?.saleMinQuantity.toString() ?? '0',
                              index: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
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
        ),
      );
    } else {
      context.read<StoreBloc>().add(StoreEvent.updateMaintenanceEvent(context: context));
    }
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox, bool? isMixedSale, List? sameSaleProducts) {
    StoreBloc bloc = context.read<StoreBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<StoreBloc>(),
        child: BlocBuilder<StoreBloc, StoreState>(builder: (context1, state) {
          String mixedSale = '';
          if (isMixedSale!) {
            mixedSale = AppStrings.minSaleText(context, minBox);
          } else {
            mixedSale = AppStrings.otherSaleText(context, minBox);
          }
          return CustomDialog(
              directionality: state.language,
              title: mixedSale,
              content: isMixedSale ? sameSaleProducts! : [],
              isMixedSale: isMixedSale,
              positiveTitle: AppLocalizations.of(context)!.closeText,
              negativeTitle: AppLocalizations.of(context)!.addText,
              negativeOnTap: () async {
                Navigator.pop(dialogContext);
                bloc.add(StoreEvent.addToCartProductEvent(context: context, productId: productId));
              },
              positiveOnTap: () async {
                Navigator.pop(context);
                bloc.add(StoreEvent.getCartCountEvent(context: context));
              });
        }),
      ),
    );
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
    final StoreBloc bloc = context.read<StoreBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<StoreBloc, StoreState>(builder: (context1, state) {
          final bool mixedSaleFlag = isMixedSale ?? false;
          final String mixedSale = mixedSaleFlag ? AppStrings.minSaleText(context, minBox) : AppStrings.otherSaleText(context, minBox);

          return CustomDialog(
              directionality: state.language,
              title: mixedSale,
              content: mixedSaleFlag ? (sameSaleProducts ?? []) : [],
              isMixedSale: mixedSaleFlag,
              positiveTitle: AppLocalizations.of(context)!.closeText,
              negativeTitle: AppLocalizations.of(context)!.addText,
              negativeOnTap: () {
                Navigator.pop(dialogContext);

                if (isIncrease) {
                  bloc.add(StoreEvent.increaseListQuantityOfProduct(
                    context: context,
                    productListIndex: productListIndex,
                    productStockUpdateIndex: index,
                    productSupplierIds: supplierId,
                  ));
                } else {
                  bloc.add(StoreEvent.decreaseListQuantityOfProduct(
                    context: context,
                    productListIndex: productListIndex,
                    productStockUpdateIndex: index,
                    productSupplierIds: supplierId,
                  ));
                }

                bloc.add(StoreEvent.addToCartListProductEvent(
                  context: context,
                  productId: productId,
                  productListIndex: productListIndex,
                  productStockUpdateIndex: index,
                  productSupplierIds: supplierId,
                ));
              },
              positiveOnTap: () {
                Navigator.pop(dialogContext);
              });
        }),
      ),
    );
  }
}
