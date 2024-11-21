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
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_img_path.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_styles.dart';
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
import '../utils/themes/app_urls.dart';
import '../widget/common_dialog_with_one_button.dart';
import '../widget/common_product_list_widget.dart';
import '../widget/common_search_widget.dart';
import '../../ui/utils/push_notification_service.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/pesach_banner_shimmer.dart';
import '../widget/search_item_widget.dart';


class HomeRoute {
  static Widget get route => HomeScreen();
}

class HomeScreen extends StatelessWidget {
  String isSubCategory;
  HomeScreen({super.key, this.isSubCategory = ''});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(HomeEvent.getProfileDetailsEvent(context: context))
     // ..add(HomeEvent.getRecommendationProductsListEvent(context:context))
      ..add(HomeEvent.getProductSalesListEvent(context: context))
      ..add(const HomeEvent.getPreferencesDataEvent()),
      child: HomeScreenWidget(isNavigation: isSubCategory),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  String isNavigation = '';

  HomeScreenWidget({super.key, this.isNavigation = ''});
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = context.read<HomeBloc>();
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
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
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.pageColor,
            body: FocusDetector(
              onFocusGained: () {
                bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
              },
              child: SafeArea(
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: state.allShimmering,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppConstants.padding_5,
                              left: AppConstants.padding_10,
                              right: AppConstants.padding_10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: state.isSubUserSeeWallet ? 4 : 3, context: context));
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.whiteColor, width: 0.5),
                                      boxShadow: [BoxShadow(color: AppColors.shadowColor.withOpacity(0.1), blurRadius: AppConstants.blur_10)],
                                      shape: BoxShape.circle,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: state.userImageUrl.isNotEmpty
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                                        imageUrl: '${AppUrlEndPoints.baseFileUrl}${state.userImageUrl}',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            color: AppColors.whiteColor,
                                          );
                                        },
                                      ),
                                    )
                                        : Container(
                                      decoration: BoxDecoration(border: Border.all(color: AppColors.whiteColor, width: 5), borderRadius: BorderRadius.circular(40)),
                                      child: SvgPicture.asset(
                                        AppImagePath.placeholderProfile,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                  AppImagePath.splashLogo,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                                Container(
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                  decoration: BoxDecoration(color: AppColors.whiteColor, boxShadow: [BoxShadow(color: AppColors.shadowColor.withOpacity(0.3), blurRadius: AppConstants.blur_10)], borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100))),
                                  clipBehavior: Clip.hardEdge,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 54,
                                        width: 54,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.iconBGColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                                        ),
                                        child: InkWell(
                                          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                                          onTap: () async {
                                            dynamic messageResult = await Navigator.pushNamed(context, RouteDefine.messageScreen.name);
                                            if (messageResult != null) {
                                              bloc.add(HomeEvent.updateMessageListEvent(messageIdList: messageResult[AppStrings.messageIdListString] ?? ''));
                                            }
                                          },
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.rotationY(context.rtl ? pi : 0),
                                                child: SvgPicture.asset(
                                                  AppImagePath.message,
                                                  height: 26,
                                                  width: 24,
                                                  fit: BoxFit.scaleDown,
                                                ),
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
                                                    child: Text('${state.messageCount <= 99 ? state.messageCount : '99+'}', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_8, color: AppColors.whiteColor)),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                SmartRefresher(
                                  enablePullDown: true,
                                  controller: state.refreshController,
                                  header: CustomHeader(
                                    refreshStyle: RefreshStyle.Behind,
                                    builder: (c, m) {
                                      return Container(
                                        height: 30,
                                        width: 30,
                                        margin: const EdgeInsets.only(top: 90, bottom: 30),
                                        decoration: BoxDecoration(boxShadow: [BoxShadow(color: AppColors.shadowColor.withOpacity(0.1), blurRadius: AppConstants.blur_10)], color: AppColors.whiteColor, shape: BoxShape.circle),
                                        child: CupertinoActivityIndicator(
                                          color: AppColors.mainColor,
                                          radius: 10,
                                        ),
                                      );
                                    },
                                  ),
                                  onRefresh: () {
                                    bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
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
                                    child: Column(
                                      children: [
                                        80.height,
                                        state.pesachBannerShimmering && state.pesachBannerURL.isEmpty
                                            ? const PesachBannerShimmerWidget()
                                            : state.showPesachBanner && state.pesachBannerURL.isNotEmpty
                                            ? InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, RouteDefine.pesachScreen.name);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) => const PesachBannerShimmerWidget(),
                                                imageUrl: '${AppUrlEndPoints.baseFileUrl}${state.pesachBannerURL}',
                                                errorWidget: (context, url, error) {
                                                  return Container(
                                                    color: AppColors.whiteColor,
                                                  );
                                                },
                                              ),
                                            ))
                                            : 0.width,
                                        10.height,
                                        AnimatedCrossFade(
                                            firstChild: getScreenWidth(context).width,
                                            secondChild: Column(
                                              children: [
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
                                                  child: state.isProductSaleShimmering ? CommonProductListShimmerWidget(
                                                  ):AbsorbPointer(
                                                    absorbing: state.isProductSaleShimmering,
                                                    child: ListView.builder(
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
                                                            onButtonTap: () {
                                                              if (!state.isGuestUser) {
                                                                showProductDetails(isSaleOn: state.isSaleOn, productListIndex: 3, context: state.context??context, productId: state.productSalesList[index].id ?? '', productStock: state.productSalesList[index].productStock.toString());
                                                              } else {
                                                                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                              }
                                                            });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            crossFadeState: state.productSalesList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                            duration: const Duration(milliseconds: 300)),
                                        AnimatedCrossFade(
                                            firstChild: getScreenWidth(context).width,
                                            secondChild: Column(
                                              children: [
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
                                                  child: state.isShimmering?CommonProductListShimmerWidget():ListView.builder(
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
                                                          onButtonTap: () {
                                                            if (!state.isGuestUser) {
                                                              showProductDetails(
                                                                isSaleOn: state.isSaleOn,
                                                                context: state.context??context,
                                                                productId: state.recommendedProductsList[index].id ?? '',
                                                                productStock: (state.recommendedProductsList[index].productStock.toString()),
                                                                productListIndex: 1,
                                                              );
                                                            } else {
                                                              Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                                                            }
                                                          })),
                                                ),
                                              ],
                                            ),
                                            crossFadeState: state.recommendedProductsList.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                            duration: const Duration(milliseconds: 300)),
                                        state.cartCount == 0
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
                                        ),
                                        30.height,
                                        state.messageList.isEmpty
                                            ? 0.width
                                            : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
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
                                                      context.read<HomeBloc>().add(HomeEvent.removeOrUpdateMessageEvent(messageId: messageNewData[AppStrings.messageIdString], isRead: messageNewData[AppStrings.messageReadString], isDelete: messageNewData[AppStrings.messageDeleteString]));
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                        AppConstants.bottomNavSpace.height,
                                        //dashboard stats
                                      ],
                                    ),
                                  ),
                                ),
                                CommonSearchWidget(
                                  isFilterTap: true,
                                  isCategoryExpand: state.isCategoryExpand,
                                  isSearching: state.isSearching,
                                  onFilterTap: () {
                                    bloc.add(const HomeEvent.changeCategoryExpansion());
                                  },
                                  onCloseTap: () {
                                    bloc.add(const HomeEvent.changeCategoryExpansion(isOpened: false));
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
                                    Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()});
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
                                  searchResultWidget:state.isSearching ? const SizedBox() : state.searchList.isEmpty
                                      ? Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.search_result_not_found,
                                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor),
                                    ),
                                  )
                                      : ListView.builder(
                                    itemCount: state.searchList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (listViewContext, index) {
                                      return SearchItemWidget(
                                          isShowSeeAll: index==state.searchList.length-1?true:false,
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
                                          isShowSearchLabel: index == 0
                                              ? true
                                              : state.searchList[index].searchType != state.searchList[index - 1].searchType
                                              ? true
                                              : false,
                                          onSeeAllTap: () async {
                                            printData("searchType: ${state.searchList[index].searchType}");
                                            if (state.searchList[index].searchType == SearchTypes.category) {
                                              dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.productCategoryScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.reqSearchString: state.search, AppStrings.searchResultString: state.searchList});
                                              if (searchResult != null) {
                                                bloc.add(HomeEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                              }
                                            } else if (state.searchList[index].searchType == SearchTypes.subCategory) {
                                              dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.categoryIdString: state.searchList[index].categoryId, AppStrings.categoryNameString: state.searchList[index].categoryName, AppStrings.searchString: state.search, AppStrings.searchResultString: state.searchList});
                                              if (searchResult != null) {
                                                bloc.add(HomeEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                              }
                                            } else {
                                              state.searchList[index].searchType == SearchTypes.company
                                                  ? Navigator.pushNamed(context, RouteDefine.companyScreen.name, arguments: {AppStrings.searchString: state.search})
                                                  : state.searchList[index].searchType == SearchTypes.supplier
                                                  ? Navigator.pushNamed(context, RouteDefine.supplierScreen.name, arguments: {AppStrings.searchString: state.search})
                                                  : state.searchList[index].searchType == SearchTypes.sale
                                                  ? Navigator.pushNamed(context, RouteDefine.productSaleScreen.name, arguments: {AppStrings.searchString: state.search})
                                                  : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()});
                                            }
                                          },
                                          onTap: () async {
                                            if (state.searchList[index].searchType == SearchTypes.subCategory) {
                                              CustomSnackBar.showSnackBar(
                                                context: context,
                                                title: AppStrings.getLocalizedStrings('Oops! in progress', context),
                                                type: SnackBarType.success,
                                              );
                                              return;
                                            }
                                            if (state.searchList[index].searchType == SearchTypes.sale || state.searchList[index].searchType == SearchTypes.product) {

                                              showProductDetails(context: state.context??context, productId: state.searchList[index].searchId, isBarcode: true, productListIndex: 0, isSaleOn: state.isSaleOn, productStock: (state.searchList[index].productStock.toString()));
                                            } else if (state.searchList[index].searchType == SearchTypes.category) {
                                              dynamic searchResult = await Navigator.pushNamed(context, RouteDefine.storeCategoryScreen.name, arguments: {AppStrings.categoryIdString: state.searchList[index].searchId, AppStrings.categoryNameString: state.searchList[index].name, AppStrings.searchString: state.searchController.text, AppStrings.searchResultString: state.searchList});
                                              if (searchResult != null) {
                                                bloc.add(HomeEvent.updateGlobalSearchEvent(search: searchResult[AppStrings.searchString], searchList: searchResult[AppStrings.searchResultString]));
                                              }
                                            } else {
                                              state.searchList[index].searchType == SearchTypes.company ? Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {AppStrings.companyIdString: state.searchList[index].searchId}) : Navigator.pushNamed(context, RouteDefine.supplierProductsScreen.name, arguments: {AppStrings.supplierIdString: state.searchList[index].searchId});
                                            }
                                            bloc.add(const HomeEvent.changeCategoryExpansion());
                                          });
                                    },
                                  ),
                                  onScanTap: () async {
                                    String scanResult = await scanBarcodeOrQRCode(context: context, cancelText: AppLocalizations.of(context)!.cancel, scanMode: ScanMode.BARCODE);
                                    if (scanResult != '-1') {
                                      // -1 result for cancel scanning
                                      printData('result = $scanResult');
                                      showProductDetails(context: context, productId: scanResult, isBarcode: true, productStock: '1', productListIndex: 0, isSaleOn: state.isSaleOn);
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    state.allShimmering?Center(
                      child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CupertinoActivityIndicator(color: AppColors.mainColor,radius: 20,)),
                    ):0.height
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void handleMessageOnBackground() {
    if (isNavigation.isNotEmpty) {
      PushNotificationService().firebaseMessaging.getInitialMessage().then(
        (message) async {
          if (message != null) {
            if (message.data.isNotEmpty) {
              var data = json.decode(message.data['data'].toString());
              printData('data home:${data.toString()}');
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
        },
      );
      isNavigation = '';
    }
  }

  Widget titleRowWidget({required BuildContext context, required title, required allContentTitle, required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor),
          ),
          InkWell(
            onTap: onTap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              allContentTitle,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.mainColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildListTitles({required BuildContext context, required String title, required void Function() onTap, required subTitle}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.padding_10,
        right: AppConstants.padding_10,
        top: AppConstants.padding_10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor,fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              subTitle,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.mainColor),
            ),
          ),
        ],
      ),
    );
  }

  void showProductDetails({required BuildContext context, required String productId, bool isBarcode = false, String productStock = '0', int productListIndex = 0, required bool isSaleOn}) async {
    context.read<HomeBloc>().add(HomeEvent.getProductDetailsEvent(
          context: context,
          productId: productId,
          isBarcode: isBarcode,
          productListIndex: productListIndex,
        ));
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isDismissible: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: true,
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
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (blocContext, state) {
                    return Container(
                      height: getScreenHeight(context),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppConstants.radius_30),
                          topRight: Radius.circular(AppConstants.radius_30),
                        ),
                        color: AppColors.whiteColor,
                      ),
                      child: state.isProductLoading
                          ? const ProductDetailsShimmerWidget()
                          : state.productDetails.isEmpty
                              ? NoDataBottomSheet(dialogContext: context)
                              : SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: Column(
                                    children: [
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
                                            showMinQtyConfirmDialog(context, productId, state.productDetails.first.sale!.saleMinQuantity.toString());
                                          }
                                        },
                                        isLoading: state.isLoading,
                                        imageOnTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (dialogContext) {
                                              return Stack(
                                                children: [
                                                  SizedBox(
                                                    height: getScreenHeight(context) - MediaQuery.of(context).padding.top,
                                                    width: getScreenWidth(context),
                                                    child: GestureDetector(
                                                      onVerticalDragStart: (dragDetails) {
                                                      },
                                                      onVerticalDragUpdate: (dragDetails) {
                                                      },
                                                      onVerticalDragEnd: (endDetails) {
                                                        Navigator.pop(dialogContext);
                                                      },
                                                      child: PhotoView(
                                                        imageProvider: NetworkImage(
                                                          '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(dialogContext);
                                                      },
                                                      child: const Padding(
                                                        padding: EdgeInsets.only(top: 10.0),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        context: context,
                                        productImages: [state.productDetails.first.mainImage ?? ''],
                                        productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'),
                                        productPrice: (state.productDetails.first.sale?.isSale ?? false) ? double.parse(state.productDetails.first.sale?.salePrice ?? '') * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1) : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                        productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                        scrollController: scrollController,
                                        productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
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
                                        },   onCloseTap: (){Navigator.pop(context);},
                                      ),
                                      state.relatedProductList.isEmpty ? 0.height : relatedProductWidget(context1, state.relatedProductList, context, scrollController, isSaleOn),
                                    ],
                                  ),
                                ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget relatedProductWidget(BuildContext prevContext, List<RelatedProductDatum> relatedProductList, BuildContext context, ScrollController scrollController, bool isSaleOn) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
            child: Text(
              AppLocalizations.of(context)!.related_products,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.blackColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
         height: getItemHeight(context, isSaleOn),
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: ListView.builder(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2, i) {
              return CommonProductSaleItemWidget(
                isSale: relatedProductList.elementAt(i).sale?.isSale,
                isGuestUser: false,
                height: AppConstants.salesProductItemHeight,
                width:  getItemWidth(context),
                productName: relatedProductList.elementAt(i).productName ?? '',
                saleImage: relatedProductList.elementAt(i).mainImage ?? '',
                title: relatedProductList.elementAt(i).name,
                description: parse(relatedProductList.elementAt(i).sale?.saleDescription).body?.text ?? '',
                discountedPrice: double.parse(relatedProductList.elementAt(i).sale?.salePrice ?? '0'),
                originalPrice: relatedProductList.elementAt(i).productPrice,
                productStock: relatedProductList.elementAt(i).productStock.toString(),
                lowStock: relatedProductList.elementAt(i).lowStock ?? '',
                isPesach: relatedProductList.elementAt(i).isPesach,
                onButtonTap: () {
                  Navigator.pop(prevContext);
                  showProductDetails(isSaleOn: isSaleOn, context: context, productId: relatedProductList[i].id ?? '', isBarcode: false, productListIndex: 2, productStock: (relatedProductList[i].productStock.toString()));
                },
              );
            },
            itemCount: relatedProductList.length,
          ),
        )
      ],
    );
  }

  Widget messageListItem({required BuildContext context, required String title, required String content, required String dateTime, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.pageColor,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(context.rtl ? pi : 0),
              child: SvgPicture.asset(
                AppImagePath.message,
                fit: BoxFit.scaleDown,
                height: 16,
                width: 16,
                colorFilter: ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn),
              ),
            ),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w500),
                  ),
                  5.height,
                  Text(
                    content,
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.blackColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  3.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateTime,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor),
                      ),
                      Text(
                        AppLocalizations.of(context)!.read_more,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.mainColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  appUnderMaintenanceDialog({required BuildContext context, required HomeState state}) {
    if (!state.isDialogOpen) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context1) => BlocProvider.value(
          value: context.read<HomeBloc>(),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              HomeBloc bloc = context.read<HomeBloc>();
              return CustomOneButtonDialog(
                isLoading: state.retryLoading,
                directionality: state.language,
                title: AppLocalizations.of(context)!.under_maintenance,
                positiveTitle: AppLocalizations.of(context)!.retry,
                positiveOnTap: () async {
                  bloc.add(HomeEvent.generalSettings(context: context, dialogContext: context1, isRetryLoading: true));
                },
              );
            },
          ),
        ),
      );
    } else {
      context.read<HomeBloc>().add(HomeEvent.updateMaintenanceEvent(context: context));
    }
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox) {
    showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
        value: context.read<HomeBloc>(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            HomeBloc bloc = context.read<HomeBloc>();
            return CustomDialog(
              directionality: state.language,
              title: '${AppLocalizations.of(context)?.minimum_box_title}$minBox${AppLocalizations.of(context)?.confirm_minimum_box}',
              positiveTitle: AppLocalizations.of(context)!.yes,
              negativeTitle: AppLocalizations.of(context)!.no,
              negativeOnTap: () async {
                Navigator.pop(context);
              },
              positiveOnTap: () async {
                bloc.add(HomeEvent.addToCartProductEvent(context: context, productId: productId));
                await Future.delayed(const Duration(seconds: 1)).then((_){
                  printData('message');
                  Navigator.pop(context1);
                });
              },
            );
          },
        ),
      ),
    );
  }
}