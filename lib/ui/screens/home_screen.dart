import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../bloc/home/home_bloc.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/common_product_details_widget.dart';
import '../../ui/widget/common_product_sale_item_widget.dart';
import '../../ui/widget/custom_dialog.dart';
import '../../ui/widget/custom_text_icon_button_widget.dart';
import '../../ui/widget/product_details_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/search_model/search_model.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_dialog_with_one_button.dart';
import '../widget/common_marquee_widget.dart';
import '../widget/common_product_list_widget.dart';
import '../widget/common_search_widget.dart';
import '../../ui/utils/push_notification_service.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/multi_supplier_countdown_dialog.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/pesach_banner_shimmer.dart';
import '../widget/related_product_title.dart';
import '../widget/search_item_widget.dart';
import '../widget/build_list_title.dart';

class HomeRoute {
  static Widget get route => const HomeScreen();
}

class HomeScreen extends StatelessWidget {
  final String isSubCategory;
  const HomeScreen({super.key, this.isSubCategory = ''});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(HomeEvent.getProfileDetailsEvent(context: context))
        ..add(HomeEvent.getSuppliersDataListEvent(context: context))
        ..add(HomeEvent.getProductSalesListEvent(context: context))
        ..add(const HomeEvent.getPreferencesDataEvent())
        ..add(HomeEvent.getCartCountEvent(context: context)),
      child: HomeScreenWidget(isNavigation: isSubCategory),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  String isNavigation;
  static bool _noMinimumDialogShownInSession = false;
  HomeScreenWidget({super.key, this.isNavigation = ''});
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = context.read<HomeBloc>();
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) => previous.cartCount != current.cartCount || previous.isCartCountChange != current.isCartCountChange || previous.messageCount != current.messageCount || previous.isAccountPermissionShimmering != current.isAccountPermissionShimmering || previous.noMinimumDialogEventKey != current.noMinimumDialogEventKey,
      listener: (context, state) async {
        if (state.isCartCountChange) {
          BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.updateCartCountEvent(context: context));
        }
        if (state.isAccountPermissionShimmering) {
          BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.seeWalletPermissionUpdateEvent(context: context));
        }
        if (state.isAppOnMaintenance && !state.isDialogOpen) {
          appUnderMaintenanceDialog(context: context, state: state);
          BlocProvider.of<HomeBloc>(context).add(HomeEvent.updateMaintenanceEvent(context: context));
        }
        final isHomeTabActive = context.read<BottomNavBloc>().state.index == 0;
        if (!isHomeTabActive) {
          return;
        }
        if (!_noMinimumDialogShownInSession && state.noMinimumDialogEventKey != null && state.noMinimumDialogEventKey!.isNotEmpty && state.supplierCustomerDetails.isNotEmpty) {
          await allowOrdersWithoutMinimumDialog(context: context, state: state);
          if (context.mounted) {
            _noMinimumDialogShownInSession = true;
            context.read<HomeBloc>().add(const HomeEvent.clearNoMinimumDialogTriggerEvent());
          }
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.pageColor,
          key: const PageStorageKey('home_screen'),
          body: FocusDetector(
            onFocusGained: () async {
              bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
              bloc.add(HomeEvent.getSuppliersDataListEvent(context: context));
              bloc.add(HomeEvent.getProductSalesListEvent(context: context));
              bloc.add(HomeEvent.getRecommendationProductsListEvent(context: context));
              bloc.add(HomeEvent.getCartCountEvent(context: context));
              final currentState = bloc.state;
              if (!_noMinimumDialogShownInSession && currentState.noMinimumDialogEventKey != null && currentState.noMinimumDialogEventKey!.isNotEmpty && currentState.supplierCustomerDetails.isNotEmpty) {
                await allowOrdersWithoutMinimumDialog(context: context, state: currentState);
                if (context.mounted) {
                  _noMinimumDialogShownInSession = true;
                  context.read<HomeBloc>().add(const HomeEvent.clearNoMinimumDialogTriggerEvent());
                }
              }
            },
            child: SafeArea(
              child: Stack(children: [
                AbsorbPointer(
                  absorbing: state.allShimmering,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppConstants.padding_5, left: AppConstants.padding_10, right: AppConstants.padding_10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        userProfileWidget(context, state),
                        appLogoWidget(state),
                        messageWidget(context, bloc, state),
                      ]),
                    ),
                    Expanded(
                      child: Stack(children: [
                        SmartRefresher(
                          physics: const ClampingScrollPhysics(),
                          enablePullDown: true,
                          controller: state.refreshController,
                          header: smartRefreshCustomHeaderWidget(),
                          onRefresh: () {
                            bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
                            bloc.add(HomeEvent.getSuppliersDataListEvent(context: context));
                            bloc.add(HomeEvent.userApproveEvent(context: context));
                            bloc.add(HomeEvent.getRecommendationProductsListEvent(context: context));
                            bloc.add(HomeEvent.getProductSalesListEvent(context: context));
                            handleMessageOnBackground();
                            bloc.add(const HomeEvent.getPreferencesDataEvent());
                            bloc.add(HomeEvent.getMessageListEvent(context: context));
                            bloc.add(HomeEvent.getCartCountEvent(context: context));
                            bloc.add(HomeEvent.checkVersionOfAppEvent(context: context));
                            if (!state.isAppOnMaintenance) {
                              bloc.add(HomeEvent.generalSettings(context: context, dialogContext: context, isRetryLoading: false));
                            }
                            bloc.add(HomeEvent.getPermissionList(context: context));
                            state.refreshController.refreshCompleted();
                            state.refreshController.loadComplete();
                          },
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(children: [
                              80.height,
                              dataAnalyticsButtonWidget(context, state),
                              0.height,
                              pesachBannerWidget(context, state),
                              10.height,
                              supplierDataListWidget(context, bloc, state),
                              productSaleWidget(context, bloc, state),
                              productRecommendedWidget(context, bloc, state),
                              bottomButtonWidget(context, state),
                              30.height,
                              messageListWidget(context, state),
                              AppConstants.bottomNavSpace.height,
                            ]),
                          ),
                        ),
                        searchWidget(context, bloc, state),
                      ]),
                    ),
                  ]),
                ),
                state.allShimmering
                    ? Center(
                        child: SizedBox(height: 120, width: 120, child: CupertinoActivityIndicator(color: AppColors.mainColor, radius: AppConstants.radius_20)),
                      )
                    : 0.height
              ]),
            ),
          ),
        );
      }),
    );
  }

  Widget userProfileWidget(BuildContext context, HomeState state) => GestureDetector(
        onTap: () {
          context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: state.isSubUserSeeWallet ? 4 : 3, context: context));
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.whiteColor, width: 0.5),
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.1), blurRadius: AppConstants.blur_10)],
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.hardEdge,
          child: state.userImageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radius_10),
                  child: CachedNetworkImage(
                      placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                      imageUrl: '${AppUrlEndPoints.baseFileUrl}${state.userImageUrl}',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Container(color: AppColors.whiteColor);
                      }),
                )
              : Container(
                  decoration: BoxDecoration(border: Border.all(color: AppColors.whiteColor, width: 5), borderRadius: BorderRadius.circular(AppConstants.radius_40)),
                  child: SvgPicture.asset(AppImagePath.placeholderProfile, width: 80, height: 80, fit: BoxFit.scaleDown),
                ),
        ),
      );

  Widget appLogoWidget(HomeState state) => state.clubAgentId == AppStrings.clubAgentIdText
      ? Image.asset(
          AppImagePath.clubAgentBlueLogo,
          fit: BoxFit.fill,
          width: 150,
          height: 80,
        )
      : SvgPicture.asset(AppImagePath.splashLogo, fit: BoxFit.cover, width: 100, height: 100);

  Widget dataAnalyticsButtonWidget(BuildContext context, HomeState state) => state.showClientDataOnApp
      ? CustomTextIconButtonWidget(
          width: double.maxFinite,
          title: state.language == 'en' ? state.buttonEnglishText! : state.buttonHebrewText!,
          onPressed: () {
            Navigator.pushNamed(context, RouteDefine.webViewScreen.name);
          })
      : 0.width;

  Widget pesachBannerWidget(BuildContext context, HomeState state) => state.pesachBannerShimmering && state.pesachBannerURL.isEmpty
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
          : 0.width;

  Widget supplierDataListWidget(BuildContext context, HomeBloc bloc, HomeState state) => AnimatedCrossFade(
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
                return buildSupplierListDataItem(
                    supplierLogo: state.suppliersDataList[index].logo ?? '',
                    supplierContactName: state.suppliersDataList[index].supplierDetail?.displayName ?? '',
                    onTap: () {
                      Navigator.pushNamed(context, RouteDefine.supplierListProductsScreen.name, arguments: {
                        AppStrings.supplierIdString: state.suppliersDataList[index].id ?? '',
                        AppStrings.supplierNameString: state.suppliersDataList[index].supplierDetail?.displayName,
                        AppStrings.minimumOrderText: state.suppliersDataList[index].supplierDetail?.minOrderAmount,
                      });
                    });
              }),
        ),
      ]),
      crossFadeState: state.suppliersDataList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300));

  Widget buildSupplierListDataItem({required String supplierLogo, required String supplierContactName, required void Function() onTap}) {
    return Container(
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
            child: supplierLogo.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: "${AppUrlEndPoints.baseFileUrl}$supplierLogo",
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
                  supplierContactName,
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

  Widget productSaleWidget(BuildContext context, HomeBloc bloc, HomeState state) => AnimatedCrossFade(
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
          child: state.isProductSaleShimmering
              ? const CommonProductListShimmerWidget()
              : AbsorbPointer(
                  absorbing: state.isProductSaleShimmering,
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
                              context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
                                    context: context,
                                    quantity: state.productStockList[3][index].quantity.toString(),
                                    productListIndex: 3,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                  ));
                            },
                            onQuantityIncreaseTap: () {
                              if (int.parse(state.productSalesList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[3][index].quantity + 1) {
                                bloc.add(HomeEvent.increaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 3,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                ));

                                bloc.add(HomeEvent.addToCartListProductEvent(
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
                                  isMixedSale: state.productSalesList[index].sale?.isMixedSale ?? false,
                                  sameSaleProducts: state.productSalesList[index].sale?.sameSaleProducts,
                                  isIncrease: true,
                                );
                              }
                            },
                            onQuantityDecreaseTap: () {
                              if (state.productStockList[3][index].quantity != 0) {
                                if (int.parse(state.productSalesList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[3][index].quantity - 1) {
                                  bloc.add(HomeEvent.decreaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 3,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.productSalesList[index].supplierId.toString(),
                                  ));

                                  bloc.add(HomeEvent.addToCartListProductEvent(
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
                                    isMixedSale: state.productSalesList[index].sale?.isMixedSale ?? false,
                                    sameSaleProducts: state.productSalesList[index].sale?.sameSaleProducts,
                                    isIncrease: false,
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

  Widget productRecommendedWidget(BuildContext context, HomeBloc bloc, HomeState state) => AnimatedCrossFade(
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
          child: state.isShimmering
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
                      discountedPrice: double.parse(state.recommendedProductsList[index].sale?.salePrice ?? '0'),
                      originalPrice: state.recommendedProductsList[index].productPrice,
                      productStock: state.recommendedProductsList[index].productStock.toString(),
                      lowStock: state.recommendedProductsList[index].lowStock ?? '',
                      isPesach: state.recommendedProductsList[index].isPesach,
                      quantity: state.productStockList[1][index].quantity,
                      minQuantity: state.recommendedProductsList[index].sale?.saleMinQuantity,
                      maxQuantity: state.recommendedProductsList[index].sale?.saleMaxQuantity,
                      isMixedSale: state.recommendedProductsList[index].sale?.isMixedSale,
                      onQuantityChanged: () {
                        context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
                              context: context,
                              quantity: state.productStockList[1][index].quantity.toString(),
                              productListIndex: 1,
                              productStockUpdateIndex: index,
                              productSupplierIds: state.recommendedProductsList[index].supplierId.toString(),
                            ));
                      },
                      onQuantityIncreaseTap: () {
                        if (int.parse(state.recommendedProductsList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity + 1) {
                          context.read<HomeBloc>().add(HomeEvent.increaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 1,
                                productStockUpdateIndex: index,
                                productSupplierIds: state.recommendedProductsList[index].supplierId.toString(),
                              ));

                          context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
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
                            isMixedSale: state.recommendedProductsList[index].sale?.isMixedSale ?? false,
                            sameSaleProducts: state.recommendedProductsList[index].sale?.sameSaleProducts,
                            isIncrease: true,
                          );
                        }
                      },
                      onQuantityDecreaseTap: () {
                        if (state.productStockList[1][index].quantity != 0) {
                          if (int.parse(state.recommendedProductsList[index].sale?.saleMinQuantity ?? '0') <= state.productStockList[1][index].quantity - 1) {
                            context.read<HomeBloc>().add(HomeEvent.decreaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 1,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.recommendedProductsList[index].supplierId.toString(),
                                ));

                            context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
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
                              isMixedSale: state.recommendedProductsList[index].sale?.isMixedSale ?? false,
                              sameSaleProducts: state.recommendedProductsList[index].sale?.sameSaleProducts,
                              isIncrease: false,
                            );
                          }
                        }
                      },
                      onButtonTap: () {
                        if (!state.isGuestUser) {
                          showProductDetails(
                            isSaleOn: state.isSaleOn,
                            context: context,
                            productId: state.recommendedProductsList[index].id ?? '',
                            productStock: (state.recommendedProductsList[index].productStock.toString()),
                            productListIndex: 1,
                          );
                        } else {
                          Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                        }
                      })),
        ),
      ]),
      crossFadeState: state.recommendedProductsList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300));

  Widget searchWidget(BuildContext context, HomeBloc bloc, HomeState state) => CommonSearchWidget(
      isFilterTap: true,
      isCategoryExpand: state.isCategoryExpand,
      isSearching: state.isSearching,
      onFilterTap: () {
        bloc.add(const HomeEvent.changeCategoryExpansion());
      },
      onCloseTap: () {
        bloc.add(const HomeEvent.changeCategoryExpansion(isOpened: false));
        context.read<HomeBloc>().add(HomeEvent.getProductSalesListEvent(context: context));
        context.read<HomeBloc>().add(HomeEvent.getRecommendationProductsListEvent(context: context));
      },
      onSearchTap: () {
        if (state.searchController.text.isNotEmpty) {
          bloc.add(const HomeEvent.changeCategoryExpansion(isOpened: true));
        }
      },
      onSearch: (String search) {
        if (search.length > 1) {
          bloc.add(const HomeEvent.changeCategoryExpansion(isOpened: true));
          bloc.add(HomeEvent.globalSearchEvent(context: context));
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
        bloc.add(const HomeEvent.changeCategoryExpansion(isOpened: false));
      },
      onSearchItemTap: () {
        bloc.add(const HomeEvent.changeCategoryExpansion());
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
                        isMoreResults: state.searchList
                            .where(
                              (search) => search.searchType == state.searchList[index].searchType,
                            )
                            .toList()
                            .isNotEmpty,
                        isLastItem: state.searchList.length - 1 == index,
                        quantity: state.productStockList[0][index].quantity,
                        isSale: state.searchList[index].isSale,
                        minQuantity: state.searchList[index].saleMinQuantity,
                        maxQuantity: state.searchList[index].saleMaxQuantity,
                        isMixedSale: state.searchList[index].isMixedSale,
                        onQuantityChanged: () {
                          context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
                                context: context,
                                quantity: state.productStockList[0][index].quantity.toString(),
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: state.searchList[index].supplierId.toString(),
                              ));
                        },
                        onQuantityIncreaseTap: () {
                          if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity + 1) {
                            context.read<HomeBloc>().add(HomeEvent.increaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: state.searchList[index].supplierId.toString(),
                                ));

                            context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: state.searchList[index].searchId,
                                  productListIndex: 0,
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
                              productListIndex: 0,
                              isMixedSale: state.searchList[index].isMixedSale ?? false,
                              sameSaleProducts: state.searchList[index].sameSaleProducts,
                              isIncrease: true,
                            );
                          }
                        },
                        onQuantityDecreaseTap: () {
                          if (state.productStockList[0][index].quantity != 0) {
                            if (int.parse(state.searchList[index].saleMinQuantity ?? '0') <= state.productStockList[0][index].quantity - 1) {
                              context.read<HomeBloc>().add(HomeEvent.decreaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 0,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: state.searchList[index].supplierId.toString(),
                                  ));

                              context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
                                    context: context,
                                    productId: state.searchList[index].searchId,
                                    productListIndex: 0,
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
                                productListIndex: 0,
                                isMixedSale: state.searchList[index].isMixedSale ?? false,
                                sameSaleProducts: state.searchList[index].sameSaleProducts,
                                isIncrease: false,
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
                              bloc.add(HomeEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else if (state.searchList[index].searchType == SearchTypes.subCategory) {
                            dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {
                              AppStrings.categoryIdString: state.searchList[index].categoryId,
                              AppStrings.categoryNameString: state.searchList[index].categoryName,
                              AppStrings.searchString: state.search,
                              AppStrings.searchResultString: state.searchList,
                            });
                            if (searchResult != null) {
                              bloc.add(HomeEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            state.searchList[index].searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyScreen.name, arguments: {AppStrings.searchString: state.search})
                                : state.searchList[index].searchType == SearchTypes.supplier
                                    ? Navigator.pushNamed(context, RouteDefine.supplierScreen.name, arguments: {AppStrings.searchString: state.search})
                                    : state.searchList[index].searchType == SearchTypes.sale
                                        ? Navigator.pushNamed(context, RouteDefine.productSaleScreen.name, arguments: {
                                            AppStrings.searchString: state.search,
                                          })
                                        : Navigator.pushNamed(
                                            context,
                                            RouteDefine.supplierProductsScreen.name,
                                            arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()},
                                          );
                          }
                        },
                        onTap: () async {
                          if (state.searchList[index].searchType == SearchTypes.subCategory) {
                            inProgressSnackBarWidget(context);
                            return;
                          }
                          if (state.searchList[index].searchType == SearchTypes.sale || state.searchList[index].searchType == SearchTypes.product) {
                            showProductDetails(
                              context: Platform.isIOS ? (state.context ?? context) : context,
                              productId: state.searchList[index].searchId,
                              isBarcode: true,
                              productListIndex: 0,
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
                              bloc.add(HomeEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                            }
                          } else {
                            state.searchList[index].searchType == SearchTypes.company
                                ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {
                                    AppStrings.companyIdString: state.searchList[index].searchId,
                                  })
                                : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {
                                    AppStrings.supplierIdString: state.searchList[index].searchId,
                                  });
                          }
                          bloc.add(const HomeEvent.changeCategoryExpansion());
                        });
                  }),
      onScanTap: () async {
        String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
        if (scanResult != '-1') {
          showProductDetails(
            context: context,
            productId: scanResult,
            isBarcode: true,
            productStock: '1',
            productListIndex: 0,
            isSaleOn: state.isSaleOn,
          );
        }
      });

  void showProductDetails({
    required BuildContext context,
    required String productId,
    bool isBarcode = false,
    String productStock = '0',
    int productListIndex = 0,
    required bool isSaleOn,
  }) async {
    context.read<HomeBloc>().add(HomeEvent.getProductDetailsEvent(context: context, productId: productId, isBarcode: isBarcode, productListIndex: productListIndex));
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        expand: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radius_10))),
        isDismissible: false,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        enableDrag: false,
        builder: (context1) {
          return SafeArea(
            bottom: false,
            child: DraggableScrollableSheet(
                expand: true,
                maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.1),
                minChildSize: productStock == '0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.1),
                initialChildSize: productStock == '0' ? 0.9 : 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context) * 0.1),
                builder: (BuildContext context1, ScrollController scrollController) {
                  return BlocProvider.value(
                    value: context.read<HomeBloc>(),
                    child: BlocBuilder<HomeBloc, HomeState>(builder: (blocContext, state) {
                      return Container(
                        height: getScreenHeight(context),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                          color: AppColors.whiteColor,
                        ),
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
                                bottleTax: state.bottlePrice,
                                isSubUserAddToBasket: state.isSubUserAddToBasket,
                                totalBottleDeposit: (state.bottlePrice * (state.productDetails.first.numberOfUnit ?? 1) * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                isBottle: (state.productDetails.first.isBottle ?? false),
                                addToOrderTap: () {
                                  if (int.parse(state.productDetails.first.sale!.saleMinQuantity!) <= state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
                                    context.read<HomeBloc>().add(HomeEvent.addToCartProductEvent(context: context1, productId: productId));
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
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: AppConstants.padding_10),
                                              child: Icon(Icons.close, color: AppColors.whiteColor),
                                            ),
                                          ),
                                        ]);
                                      });
                                },
                                context: context,
                                productImages: [state.productDetails.first.mainImage ?? ''],
                                productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'),
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
                                  context.read<HomeBloc>().add(HomeEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                },
                                onQuantityIncreaseTap: () {
                                  context.read<HomeBloc>().add(HomeEvent.increaseQuantityOfProduct(context: context1));
                                },
                                onQuantityDecreaseTap: () {
                                  if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                    context.read<HomeBloc>().add(HomeEvent.decreaseQuantityOfProduct(context: context1));
                                  }
                                },
                                onCloseTap: () {
                                  context.read<HomeBloc>().add(HomeEvent.getProductSalesListEvent(context: context1));
                                  context.read<HomeBloc>().add(HomeEvent.getRecommendationProductsListEvent(context: context1));
                                  Navigator.pop(context);
                                }),
                            state.isRelatedShimmering
                                ? const RelatedProductShimmerWidget()
                                : state.relatedProductList.isEmpty
                                ? 0.height
                                : relatedProductWidget(context1, state.relatedProductList, context, scrollController, isSaleOn),
                          ]),
                        ),
                      );
                    }),
                  );
                }),
          );
        });
  }

  Widget relatedProductWidget(BuildContext prevContext, List<RelatedProductDatum> relatedProductList, BuildContext context, ScrollController scrollController, bool isSaleOn) {
    return BlocProvider.value(
        value: context.read<HomeBloc>(),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (blocContext, state) {
          return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            relatedProductTitle(context),
            Container(
              height: getItemHeight(context, isSaleOn),
              padding: const EdgeInsets.only(left: AppConstants.padding_10, right: AppConstants.padding_10, bottom: AppConstants.padding_5),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context2, i) {
                  return CommonProductSaleItemWidget(
                      isSale: relatedProductList.elementAt(i).sale?.isSale,
                      isGuestUser: false,
                      height: AppConstants.salesProductItemHeight,
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
                      quantity: state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity,
                      minQuantity: relatedProductList.elementAt(i).sale?.saleMinQuantity,
                      maxQuantity: relatedProductList.elementAt(i).sale?.saleMaxQuantity,
                      isMixedSale: relatedProductList[i].sale?.isMixedSale,
                      onQuantityChanged: () {
                        context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
                          context: context,
                          quantity: state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity.toString(),
                          productListIndex: 2,
                          productStockUpdateIndex: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                          productSupplierIds: relatedProductList[i].supplierId.toString(),
                        ));
                      },
                      onQuantityIncreaseTap: () {
                        if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity + 1) {
                          context.read<HomeBloc>().add(HomeEvent.increaseListQuantityOfProduct(
                            context: context,
                            productListIndex: 2,
                            productStockUpdateIndex: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                            productSupplierIds: relatedProductList[i].supplierId.toString(),
                          ));

                          context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
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
                            isMixedSale: relatedProductList[i].sale?.isMixedSale ?? false,
                            sameSaleProducts: relatedProductList[i].sale?.sameSaleProducts,
                            isIncrease: true,
                          );
                        }
                      },
                      onQuantityDecreaseTap: () {
                        if (state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity != 0) {
                          if (int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <= state.productStockList[2].firstWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id).quantity - 1) {
                            context.read<HomeBloc>().add(HomeEvent.decreaseListQuantityOfProduct(
                              context: context,
                              productListIndex: 2,
                              productStockUpdateIndex: state.productStockList[2].indexWhere((relatedProductStockList) => relatedProductStockList.productId == relatedProductList.elementAt(i).id),
                              productSupplierIds: relatedProductList[i].supplierId.toString(),
                            ));

                            context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
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
                              isMixedSale: relatedProductList[i].sale?.isMixedSale ?? false,
                              sameSaleProducts: relatedProductList[i].sale?.sameSaleProducts,
                              isIncrease: false,
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
                          productListIndex: 2,
                          productStock: (relatedProductList[i].productStock.toString()),
                        );
                      });
                },
                itemCount: relatedProductList.length,
              ),
            )
          ]);
        }));
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox, bool? isMixedSale, List? sameSaleProducts) {
    HomeBloc bloc = context.read<HomeBloc>();
    showDialog(
        context: context,
        builder: (dialogContext) => BlocProvider.value(
          value: context.read<HomeBloc>(),
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context1, state) {
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
                negativeOnTap: () {
                  Navigator.pop(dialogContext);
                  bloc.add(HomeEvent.addToCartProductEvent(context: context, productId: productId));
                },
                positiveOnTap: () {
                  Navigator.pop(dialogContext);
                  bloc.add(HomeEvent.getCartCountEvent(context: context));
                });
          }),
        ));
  }

  void showMinMaxQtyConfirmDialog({
    required BuildContext context,
    required String productId,
    required String minBox,
    required int index,
    required dynamic supplierId,
    required int productListIndex,
    required bool isMixedSale,
    required bool isIncrease,
    List? sameSaleProducts,
  }) {
    final HomeBloc bloc = context.read<HomeBloc>();
    String mixedSale = isMixedSale ? AppStrings.minSaleText(context, minBox) : AppStrings.otherSaleText(context, minBox);
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context1, state) {
            return CustomDialog(
                directionality: state.language,
                title: mixedSale,
                content: isMixedSale ? (sameSaleProducts ?? []) : [],
                isMixedSale: isMixedSale,
                positiveTitle: AppLocalizations.of(context)!.closeText,
                negativeTitle: AppLocalizations.of(context)!.addText,
                negativeOnTap: () async {
                  Navigator.pop(dialogContext);

                  if (isIncrease) {
                    bloc.add(HomeEvent.increaseListQuantityOfProduct(
                      context: context,
                      productListIndex: productListIndex,
                      productStockUpdateIndex: index,
                      productSupplierIds: supplierId,
                    ));
                  } else {
                    bloc.add(HomeEvent.decreaseListQuantityOfProduct(
                      context: context,
                      productListIndex: productListIndex,
                      productStockUpdateIndex: index,
                      productSupplierIds: supplierId,
                    ));
                  }
                  bloc.add(HomeEvent.addToCartListProductEvent(
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
          },
        ),
      ),
    );
  }

  Widget bottomButtonWidget(BuildContext context, HomeState state) => state.cartCount == 0
      ? CustomTextIconButtonWidget(
    width: double.maxFinite,
    title: AppLocalizations.of(context)!.new_order,
    onPressed: () {
      context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: 1, context: context));
    },
    svgImage: AppImagePath.add,
  )
      : CustomTextIconButtonWidget(
    width: double.maxFinite,
    title: AppLocalizations.of(context)!.my_basket,
    onPressed: () {
      context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: 2, context: context));
    },
    svgImage: AppImagePath.cart,
    cartCount: state.cartCount,
  );

  Widget messageListWidget(BuildContext context, HomeState state) => state.messageList.isEmpty
      ? 0.width
      : Column(mainAxisSize: MainAxisSize.min, children: [
    titleRowWidget(
        context: context,
        title: AppLocalizations.of(context)!.messages,
        allContentTitle: AppLocalizations.of(context)!.all_messages,
        onTap: () {
          Navigator.pushNamed(context, RouteDefine.messageScreen.name);
        }),
    10.height,
    ListView.builder(
        itemCount: state.messageList.length > 1 ? 2 : 1,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => messageListItem(
            context: context,
            title: state.messageList[index].message?.title ?? '',
            content: parse(state.messageList[index].message?.body ?? '').body?.text ?? '',
            dateTime: state.messageList[index].updatedAt?.replaceRange(11, 19, '') ?? '',
            onTap: () async {
              dynamic messageNewData = await Navigator.pushNamed(context, RouteDefine.messageContentScreen.name, arguments: {
                AppStrings.messageDataString: state.messageList[index],
                AppStrings.messageIdString: state.messageList[index].id,
                AppStrings.isReadMoreString: true,
              });
              if (messageNewData != null) {
                context.read<HomeBloc>().add(HomeEvent.removeOrUpdateMessageEvent(
                  messageId: messageNewData[AppStrings.messageIdString],
                  isRead: messageNewData[AppStrings.messageReadString],
                  isDelete: messageNewData[AppStrings.messageDeleteString],
                ));
              }
            })),
  ]);

  Widget messageWidget(BuildContext context, HomeBloc bloc, HomeState state) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_3),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.3), blurRadius: AppConstants.blur_10)],
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
        ),
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 54,
            width: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.iconBGColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100))),
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
              onTap: () async {
                dynamic messageResult = await Navigator.pushNamed(context, RouteDefine.messageScreen.name);
                if (messageResult != null) {
                  bloc.add(HomeEvent.updateMessageListEvent(messageIdList: messageResult[AppStrings.messageIdListString] ?? ''));
                }
              },
              child: Stack(fit: StackFit.expand, children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(context.rtl ? pi : 0),
                  child: SvgPicture.asset(AppImagePath.message, height: 26, width: 24, fit: BoxFit.scaleDown),
                ),
                state.messageCount <= 0
                    ? 0.width
                    : Positioned(
                        top: 8,
                        right: context.rtl ? null : 7,
                        left: context.rtl ? 7 : null,
                        child: Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, border: Border.all(color: AppColors.whiteColor, width: 1), shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text(
                            '${state.messageCount <= 99 ? state.messageCount : '99+'}',
                            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_8, color: AppColors.whiteColor),
                          ),
                        ))
              ]),
            ),
          ),
        ]),
      );

  void handleMessageOnBackground() {
    if (isNavigation.isNotEmpty) {
      PushNotificationService().firebaseMessaging.getInitialMessage().then((message) async {
        if (message != null) {
          if (message.data.isNotEmpty) {
            var data = json.decode(message.data['data'].toString());
            if (data != null) {
              FlutterAppBadger.removeBadge();
              PushNotificationService().showNotification(
                notiId: message.notification.hashCode,
                data: data,
                imageUrl: Platform.isAndroid ? message.notification?.android?.imageUrl ?? '' : message.notification?.apple?.imageUrl ?? '',
                title: message.notification?.title ?? '',
                body: message.notification?.body ?? '',
              );
            }
          }
        }
      });
      isNavigation = '';
    }
  }

  Widget messageListItem({required BuildContext context, required String title, required String content, required String dateTime, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.pageColor,
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(context.rtl ? pi : 0),
            child: SvgPicture.asset(AppImagePath.message, fit: BoxFit.scaleDown, height: 16, width: 16, colorFilter: ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
          ),
          10.width,
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(title, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w500)),
              5.height,
              Text(content, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.blackColor), maxLines: 2, overflow: TextOverflow.ellipsis),
              3.height,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(dateTime, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor)),
                Text(AppLocalizations.of(context)!.read_more, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.mainColor)),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget titleRowWidget({required BuildContext context, required title, required allContentTitle, required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
      child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
        InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Text(allContentTitle, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.mainColor, fontWeight: FontWeight.w500)),
        ),
      ]),
    );
  }

  Future<void> allowOrdersWithoutMinimumDialog({required BuildContext context, required HomeState state}) async {
    if (!context.mounted) return;
    if (context.read<BottomNavBloc>().state.index != 0) return;

    final storage = PageStorage.of(context);
    if (storage.readState(context, identifier: 'no_min_dialog') == true) {
      return;
    }

    final suppliers = state.supplierCustomerDetails;
    if (suppliers == null || suppliers.isEmpty) return;
    List<SupplierTimer> validSupplier = [];

    for (var supplier in suppliers) {
      final rawDate = supplier.lastOrderAboveMinimumAt;
      if (rawDate == null || rawDate.isEmpty) continue;
      DateTime? lastOrderUtc;
      try {
        lastOrderUtc = DateTime.parse(rawDate);
      } catch (e) {
        continue;
      }

      int hours = supplier.noMinimumOrderHours ?? 0;
      DateTime endUtc = lastOrderUtc.add(Duration(hours: hours));
      DateTime nowUtc = DateTime.now().toUtc();
      Duration remaining = endUtc.difference(nowUtc);

      if (remaining.isNegative || remaining.inSeconds <= 0) continue;
      validSupplier.add(SupplierTimer(supplierName: supplier.supplierContactName ?? '', remainingSeconds: remaining.inSeconds));
    }

    if (validSupplier.isEmpty) return;
    storage.writeState(context, true, identifier: 'no_min_dialog');

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MultiSupplierCountdownDialog(suppliers: validSupplier, title: state.supplierCustomerDetails[0].text ?? ''),
    );
  }

  appUnderMaintenanceDialog({required BuildContext context, required HomeState state}) {
    if (!state.isDialogOpen) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context1) => BlocProvider.value(
                value: context.read<HomeBloc>(),
                child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  HomeBloc bloc = context.read<HomeBloc>();
                  return CustomOneButtonDialog(
                      isLoading: state.retryLoading,
                      directionality: state.language,
                      title: AppLocalizations.of(context)!.under_maintenance,
                      positiveTitle: AppLocalizations.of(context)!.retry,
                      positiveOnTap: () async {
                        bloc.add(HomeEvent.generalSettings(context: context, dialogContext: context1, isRetryLoading: true));
                      });
                }),
              ));
    } else {
      context.read<HomeBloc>().add(HomeEvent.updateMaintenanceEvent(context: context));
    }
  }
}
