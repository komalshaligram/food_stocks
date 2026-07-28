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
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/widget/common_product_details_widget.dart';
import '../../ui/widget/common_product_sale_item_widget.dart';
import '../../ui/widget/sale_promotion_sheet.dart';
import '../../ui/widget/custom_text_icon_button_widget.dart';
import '../../ui/widget/product_details_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_dialog_with_one_button.dart';
import '../widget/customer_service_contact_widget.dart';
import '../widget/whatsapp_optin_dialog.dart';
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
      create: (context) {
        final bloc = HomeBloc();
        bloc.add(const HomeEvent.getPreferencesDataEvent());
        bloc.add(HomeEvent.getSuppliersDataListEvent(context: context));
        bloc.add(HomeEvent.getProductCategoriesListEvent(context: context));
        bloc.add(HomeEvent.getCompaniesListEvent(context: context));
        bloc.add(HomeEvent.getProductSalesListEvent(context: context));
        bloc.add(HomeEvent.getRecommendationProductsListEvent(context: context));
        bloc.add(HomeEvent.getPreviousOrderProductsListEvent(context: context));
        bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
        bloc.add(HomeEvent.checkVersionOfAppEvent(context: context));
        return bloc;
      },
      child: HomeScreenWidget(isNavigation: isSubCategory),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  final String isNavigation;
  static bool _noMinimumDialogShownInSession = false;
  static bool _whatsappOptinDialogShownInSession = false;
  // Source tag recorded with the WhatsApp consent (per app).
  static const String _whatsappOptinSource = 'tavili_app_popup';
  static final Set<String> _handledBackgroundNavigations = {};
  const HomeScreenWidget({super.key, this.isNavigation = ''});

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = context.read<HomeBloc>();
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.cartCount != current.cartCount ||
          previous.isCartCountChange != current.isCartCountChange ||
          previous.messageCount != current.messageCount ||
          previous.isAccountPermissionShimmering != current.isAccountPermissionShimmering ||
          previous.noMinimumDialogEventKey != current.noMinimumDialogEventKey ||
          previous.showWhatsappOptinPopup != current.showWhatsappOptinPopup ||
          previous.whatsappOptIn != current.whatsappOptIn,
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
        // WhatsApp marketing opt-in: show once per session while the global
        // setting is on and the client hasn't approved yet. Dismissing it
        // ("not now") lets it reappear on the next app launch.
        if (!_whatsappOptinDialogShownInSession &&
            state.showWhatsappOptinPopup &&
            !state.whatsappOptIn &&
            !state.isGuestUser &&
            !state.isAppOnMaintenance) {
          _whatsappOptinDialogShownInSession = true;
          whatsappOptinDialog(context: context, state: state);
        }
        final isHomeTabActive = context.read<BottomNavBloc>().state.index == 0;
        if (!isHomeTabActive) {
          return;
        }
        if (!_noMinimumDialogShownInSession &&
            state.noMinimumDialogEventKey != null &&
            state.noMinimumDialogEventKey!.isNotEmpty &&
            state.supplierCustomerDetails.isNotEmpty) {
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
              final preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
              bloc.add(const HomeEvent.getPreferencesDataEvent());
              if (!preferences.getGuestUser()) {
                bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
              }
              bloc.add(HomeEvent.getSuppliersDataListEvent(context: context));
              bloc.add(HomeEvent.getProductSalesListEvent(context: context));
              bloc.add(HomeEvent.getRecommendationProductsListEvent(context: context));
              bloc.add(HomeEvent.getPreviousOrderProductsListEvent(context: context));
              if (!preferences.getGuestUser()) {
                bloc.add(HomeEvent.getCartCountEvent(context: context));
              }
              final currentState = bloc.state;
              if (!_noMinimumDialogShownInSession &&
                  currentState.noMinimumDialogEventKey != null &&
                  currentState.noMinimumDialogEventKey!.isNotEmpty &&
                  currentState.supplierCustomerDetails.isNotEmpty) {
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
                        CustomerServiceContactButton(
                          customerServicePhone: state.customerServicePhone,
                          customerServiceWhatsApp: state.customerServiceWhatsApp,
                          isGuestUser: state.isGuestUser,
                          onGuestLoginRequired: () => Navigator.pushNamed(context, RouteDefine.connectScreen.name),
                        ),
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
                          onRefresh: () async {
                            final preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                            bloc.add(const HomeEvent.getPreferencesDataEvent());
                            if (!preferences.getGuestUser()) {
                              bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
                              bloc.add(HomeEvent.userApproveEvent(context: context));
                              bloc.add(HomeEvent.getMessageListEvent(context: context));
                              bloc.add(HomeEvent.getCartCountEvent(context: context));
                              bloc.add(HomeEvent.getPermissionList(context: context));
                            }
                            bloc.add(HomeEvent.getSuppliersDataListEvent(context: context));
                            bloc.add(HomeEvent.getProductCategoriesListEvent(context: context));
                            bloc.add(HomeEvent.getCompaniesListEvent(context: context));
                            bloc.add(HomeEvent.getRecommendationProductsListEvent(context: context));
                            bloc.add(HomeEvent.getProductSalesListEvent(context: context));
                            bloc.add(HomeEvent.getPreviousOrderProductsListEvent(context: context));
                            handleMessageOnBackground();
                            if (!state.isAppOnMaintenance) {
                              bloc.add(HomeEvent.generalSettings(context: context, dialogContext: context, isRetryLoading: false));
                            }
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
                              categoryListWidget(context, bloc, state),
                              companyListWidget(context, bloc, state),
                              productSaleWidget(context, bloc, state),
                              productRecommendedWidget(context, bloc, state),
                              previousOrderProductWidget(context, bloc, state),
                              // bottomButtonWidget(context, state),
                              // 30.height,
                              // messageListWidget(context, state),
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
                        child: SizedBox(
                            height: 120, width: 120, child: CupertinoActivityIndicator(color: AppColors.mainColor, radius: AppConstants.radius_20)),
                      )
                    : 0.height
              ]),
            ),
          ),
        );
      }),
    );
  }

  Widget appLogoWidget(HomeState state) => state.clubAgentId == AppStrings.clubAgentIdText
      ? Image.asset(
          AppImagePath.clubAgentBlueLogo,
          fit: BoxFit.fill,
          width: 150,
          height: 80,
        )
      : SvgPicture.asset(AppImagePath.splashLogo, fit: BoxFit.cover, width: 100, height: 100);

  Widget dataAnalyticsButtonWidget(BuildContext context, HomeState state) {
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

  Widget supplierDataListWidget(BuildContext context, HomeBloc bloc, HomeState state) {
    if (state.suppliersDataList.isEmpty) {
      return 0.width;
    }
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return 0.width;
    }
    return Column(children: [
      buildListTitles(
          context: context,
          title: l10n.suppliers,
          subTitle: l10n.all_suppliers,
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
    ]);
  }

  Widget categoryListWidget(BuildContext context, HomeBloc bloc, HomeState state) => AnimatedCrossFade(
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
                    bloc.add(HomeEvent.updateGlobalSearchEvent(
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
                              bloc.add(HomeEvent.updateGlobalSearchEvent(
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

  Widget companyListWidget(BuildContext context, HomeBloc bloc, HomeState state) => AnimatedCrossFade(
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
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(AppConstants.radius_10), bottomLeft: Radius.circular(AppConstants.radius_10)),
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
                              context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
                                    context: context,
                                    quantity: productStockData.quantity.toString(),
                                    productListIndex: 3,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: productSaleData.supplierId.toString(),
                                  ));
                            },
                            onQuantityIncreaseTap: () {
                              final minQty = int.parse(productSaleData.sale?.saleMinQuantity ?? '0');
                              final isMixed = productSaleData.sale?.isMixedSale ?? false;
                              if (isMixed || minQty > productStockData.quantity + 1) {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: productSaleData.id.toString(),
                                  minBox: productSaleData.sale?.saleMinQuantity.toString() ?? '0',
                                  index: index,
                                  supplierId: productSaleData.supplierId.toString(),
                                  productListIndex: 3,
                                  isMixedSale: productSaleData.sale?.isMixedSale ?? false,
                                  sameSaleProducts: productSaleData.sale?.sameSaleProducts,
                                  isIncrease: true,
                                );
                              } else {
                                bloc.add(HomeEvent.increaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 3,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: productSaleData.supplierId.toString(),
                                ));

                                bloc.add(HomeEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: productSaleData.id.toString(),
                                  productListIndex: 3,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: productSaleData.supplierId.toString(),
                                ));
                              }
                            },
                            onQuantityDecreaseTap: () {
                              if (productStockData.quantity != 0) {
                                if (!(productSaleData.sale?.isMixedSale ?? false) &&
                                    int.parse(productSaleData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                                  bloc.add(HomeEvent.decreaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 3,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: productSaleData.supplierId.toString(),
                                  ));

                                  bloc.add(HomeEvent.addToCartListProductEvent(
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
                                    isMixedSale: productSaleData.sale?.isMixedSale ?? false,
                                    sameSaleProducts: productSaleData.sale?.sameSaleProducts,
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
      crossFadeState: (state.isProductSaleShimmering || state.productSalesList.isNotEmpty) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
                        discountedPrice: double.parse(productRecommendedData.sale?.salePrice ?? '0'),
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
                          context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
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
                            context.read<HomeBloc>().add(HomeEvent.increaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 1,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: productRecommendedData.supplierId.toString(),
                                ));

                            context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
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
                              isMixedSale: productRecommendedData.sale?.isMixedSale ?? false,
                              sameSaleProducts: productRecommendedData.sale?.sameSaleProducts,
                              isIncrease: true,
                            );
                          }
                        },
                        onQuantityDecreaseTap: () {
                          if (productStockData.quantity != 0) {
                            if (!(productRecommendedData.sale?.isMixedSale ?? false) &&
                                int.parse(productRecommendedData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                              context.read<HomeBloc>().add(HomeEvent.decreaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 1,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: productRecommendedData.supplierId.toString(),
                                  ));

                              context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
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
                                isMixedSale: productRecommendedData.sale?.isMixedSale ?? false,
                                sameSaleProducts: productRecommendedData.sale?.sameSaleProducts,
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
                              productId: productRecommendedData.id ?? '',
                              productStock: (productRecommendedData.productStock.toString()),
                              productListIndex: 1,
                            );
                          } else {
                            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                          }
                        });
                  }),
        ),
      ]),
      crossFadeState: (state.isShimmering || state.recommendedProductsList.isNotEmpty) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300));

  Widget previousOrderProductWidget(BuildContext context, HomeBloc bloc, HomeState state) => !state.isGuestUser
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
                        var productStockData = state.productStockList[4][index];
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
                            discountedPrice: double.parse(previousOrderData.sale?.salePrice ?? '0'),
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
                              context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
                                    context: context,
                                    quantity: productStockData.quantity.toString(),
                                    productListIndex: 4,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: previousOrderData.supplierId.toString(),
                                  ));
                            },
                            onQuantityIncreaseTap: () {
                              if (!(previousOrderData.sale?.isMixedSale ?? false) &&
                                  int.parse(previousOrderData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity + 1) {
                                bloc.add(HomeEvent.increaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 4,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: previousOrderData.supplierId.toString(),
                                ));

                                bloc.add(HomeEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: previousOrderData.id.toString(),
                                  productListIndex: 4,
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
                                  productListIndex: 4,
                                  isMixedSale: previousOrderData.sale?.isMixedSale ?? false,
                                  sameSaleProducts: previousOrderData.sale?.sameSaleProducts,
                                  isIncrease: true,
                                );
                              }
                            },
                            onQuantityDecreaseTap: () {
                              if (productStockData.quantity != 0) {
                                if (!(previousOrderData.sale?.isMixedSale ?? false) &&
                                    int.parse(previousOrderData.sale?.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                                  bloc.add(HomeEvent.decreaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 4,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: previousOrderData.supplierId.toString(),
                                  ));

                                  bloc.add(HomeEvent.addToCartListProductEvent(
                                    context: context,
                                    productId: previousOrderData.id.toString(),
                                    productListIndex: 4,
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
                                    productListIndex: 4,
                                    isMixedSale: previousOrderData.sale?.isMixedSale ?? false,
                                    sameSaleProducts: previousOrderData.sale?.sameSaleProducts,
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
                                  productId: previousOrderData.id ?? '',
                                  productStock: previousOrderData.productStock.toString(),
                                  productListIndex: 4,
                                );
                              } else {
                                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                              }
                            });
                      }),
            ),
          ]),
          crossFadeState:
              (state.isPreviousOrderShimmering || state.previousOrderProductsList.isNotEmpty) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300))
      : 0.width;

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
        printData("check here 1");
        if (search.length > 1) {
          printData("check here 2");
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
                    var productSearchData = state.searchList[index];
                    var productStockData = state.productStockList[0][index];
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
                          context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
                                context: context,
                                quantity: productStockData.quantity.toString(),
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: productSearchData.supplierId.toString(),
                              ));
                        },
                        onQuantityIncreaseTap: () {
                          if (!(productSearchData.isMixedSale ?? false) &&
                              int.parse(productSearchData.saleMinQuantity ?? '0') <= productStockData.quantity + 1) {
                            context.read<HomeBloc>().add(HomeEvent.increaseListQuantityOfProduct(
                                  context: context,
                                  productListIndex: 0,
                                  productStockUpdateIndex: index,
                                  productSupplierIds: productSearchData.supplierId.toString(),
                                ));

                            context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
                                  context: context,
                                  productId: productSearchData.searchId,
                                  productListIndex: 0,
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
                              productListIndex: 0,
                              isMixedSale: productSearchData.isMixedSale ?? false,
                              sameSaleProducts: productSearchData.sameSaleProducts,
                              isIncrease: true,
                            );
                          }
                        },
                        onQuantityDecreaseTap: () {
                          if (productStockData.quantity != 0) {
                            if (!(productSearchData.isMixedSale ?? false) &&
                                int.parse(productSearchData.saleMinQuantity ?? '0') <= productStockData.quantity - 1) {
                              context.read<HomeBloc>().add(HomeEvent.decreaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 0,
                                    productStockUpdateIndex: index,
                                    productSupplierIds: productSearchData.supplierId.toString(),
                                  ));

                              context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
                                    context: context,
                                    productId: productSearchData.searchId,
                                    productListIndex: 0,
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
                                productListIndex: 0,
                                isMixedSale: productSearchData.isMixedSale ?? false,
                                sameSaleProducts: productSearchData.sameSaleProducts,
                                isIncrease: false,
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
                              bloc.add(HomeEvent.updateGlobalSearchEvent(
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
                              bloc.add(HomeEvent.updateGlobalSearchEvent(
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
                                        : Navigator.pushNamed(
                                            context,
                                            RouteDefine.supplierProductsScreen.name,
                                            arguments: {AppStrings.searchString: state.search, AppStrings.searchType: SearchTypes.product.toString()},
                                          );
                          }
                        },
                        onTap: () async {
                          if (productSearchData.searchType == SearchTypes.subCategory) {
                            inProgressSnackBarWidget(context);
                            return;
                          }
                          if (productSearchData.searchType == SearchTypes.sale || productSearchData.searchType == SearchTypes.product) {
                            showProductDetails(
                              context: Platform.isIOS ? (state.context ?? context) : context,
                              productId: productSearchData.searchId,
                              isBarcode: true,
                              productListIndex: 0,
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
                              bloc.add(HomeEvent.updateGlobalSearchEvent(
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
    context
        .read<HomeBloc>()
        .add(HomeEvent.getProductDetailsEvent(context: context, productId: productId, isBarcode: isBarcode, productListIndex: productListIndex));
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
                      // var productDetailsData = state.productDetails.first;
                      // var productStockData = state.productStockList[state.productListIndex][state.productStockUpdateIndex];
                      return Container(
                        height: getScreenHeight(blocContext),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
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
                                          totalBottleDeposit: (state.bottlePrice *
                                              (state.productDetails.first.numberOfUnit ?? 1) *
                                              state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                          isBottle: (state.productDetails.first.isBottle ?? false),
                                          addToOrderTap: () {
                                            final isMixedSale = state.productDetails.first.sale?.isMixedSale ?? false;
                                            if (!isMixedSale &&
                                                int.parse(state.productDetails.first.sale!.saleMinQuantity!) <=
                                                    state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity) {
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
                                                          imageProvider: NetworkImage(
                                                              '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}'),
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
                                          productUnitPrice:
                                              double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'),
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
                                          recommendedRetailConsumerPricerOffer: state.clubAgentId == AppStrings.clubAgentIdText
                                              ? state.productDetails.first.sale?.isSale == true
                                                  ? state.productDetails.first.recommendedConsumerOffer
                                                  : state.productDetails.first.recommendedRetailPrice
                                              : '',
                                          onQuantityChanged: (quantity) {
                                            if (state.isGuestUser) {
                                              Navigator.pushNamed(context1, RouteDefine.connectScreen.name);
                                              return;
                                            }
                                            context.read<HomeBloc>().add(HomeEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                          },
                                          onQuantityIncreaseTap: () {
                                            if (state.isGuestUser) {
                                              Navigator.pushNamed(context1, RouteDefine.connectScreen.name);
                                              return;
                                            }
                                            context.read<HomeBloc>().add(HomeEvent.increaseQuantityOfProduct(context: context1));
                                          },
                                          onQuantityDecreaseTap: () {
                                            if (state.isGuestUser) {
                                              Navigator.pushNamed(context1, RouteDefine.connectScreen.name);
                                              return;
                                            }
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
                                              : relatedProductWidget(context1, state.relatedProductList, context, isSaleOn),
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
        value: context.read<HomeBloc>(),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (blocContext, state) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                      var relatedProductData = relatedProductList.elementAt(i);
                      var productStockData = state.productStockList[2].firstWhere;
                      var productStockIndexData = state.productStockList[2].indexWhere;
                      return CommonProductSaleItemWidget(
                          isSale: relatedProductData.sale?.isSale,
                          isGuestUser: state.isGuestUser,
                          onGuestLoginRequired: () => Navigator.pushNamed(context, RouteDefine.connectScreen.name),
                          height: AppConstants.salesProductItemHeight,
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
                          quantity:
                              productStockData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id).quantity,
                          minQuantity: relatedProductData.sale?.saleMinQuantity,
                          maxQuantity: relatedProductData.sale?.saleMaxQuantity,
                          isMixedSale: relatedProductData.sale?.isMixedSale,
                          numberOfUnits: relatedProductData.numberOfUnit.toString(),
                          scaleType: relatedProductData.scaleType,
                          onQuantityChanged: () {
                            context.read<HomeBloc>().add(HomeEvent.updateListQuantityOfProduct(
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
                                    productStockData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id)
                                            .quantity +
                                        1) {
                              context.read<HomeBloc>().add(HomeEvent.increaseListQuantityOfProduct(
                                    context: context,
                                    productListIndex: 2,
                                    productStockUpdateIndex: productStockIndexData(
                                        (relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                                    productSupplierIds: relatedProductList[i].supplierId.toString(),
                                  ));

                              context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
                                    context: context,
                                    productId: relatedProductList[i].id.toString(),
                                    productListIndex: 2,
                                    productStockUpdateIndex: productStockIndexData(
                                        (relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
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
                                isMixedSale: relatedProductList[i].sale?.isMixedSale ?? false,
                                sameSaleProducts: relatedProductList[i].sale?.sameSaleProducts,
                                isIncrease: true,
                              );
                            }
                          },
                          onQuantityDecreaseTap: () {
                            if (productStockData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id).quantity !=
                                0) {
                              if (!(relatedProductList[i].sale?.isMixedSale ?? false) &&
                                  int.parse(relatedProductList[i].sale?.saleMinQuantity ?? '0') <=
                                      productStockData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id)
                                              .quantity -
                                          1) {
                                context.read<HomeBloc>().add(HomeEvent.decreaseListQuantityOfProduct(
                                      context: context,
                                      productListIndex: 2,
                                      productStockUpdateIndex: productStockIndexData(
                                          (relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                                      productSupplierIds: relatedProductList[i].supplierId.toString(),
                                    ));

                                context.read<HomeBloc>().add(HomeEvent.addToCartListProductEvent(
                                      context: context,
                                      productId: relatedProductList[i].id.toString(),
                                      productListIndex: 2,
                                      productStockUpdateIndex: productStockIndexData(
                                          (relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
                                      productSupplierIds: relatedProductList[i].supplierId.toString(),
                                    ));
                              } else {
                                showMinMaxQtyConfirmDialog(
                                  context: context,
                                  productId: relatedProductList[i].id.toString(),
                                  minBox: relatedProductData.sale?.saleMinQuantity.toString() ?? '0',
                                  index:
                                      productStockIndexData((relatedProductStockList) => relatedProductStockList.productId == relatedProductData.id),
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

  // Min-quantity promotions now open the rich promotion bottom sheet (steppers
  // per participating product + a cumulative progress bar). Legacy params are
  // kept so the many call sites stay unchanged; only [productId] is used.
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
    required bool isMixedSale,
    required bool isIncrease,
    List? sameSaleProducts,
  }) {
    _openSalePromotionSheet(context, productId);
  }

  Future<void> _openSalePromotionSheet(BuildContext context, String productId) async {
    final HomeBloc bloc = context.read<HomeBloc>();
    if (bloc.state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final bool changed = await showSalePromotionSheet(context: context, productId: productId, l10n: l10n);
    if (!changed || !context.mounted) return;
    final cartMap = await fetchCartQuantities(context);
    if (!context.mounted) return;
    bloc.add(HomeEvent.applyCartQuantitiesEvent(cartQuantities: cartMap));
    bloc.add(HomeEvent.getCartCountEvent(context: context));
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
          buildListTitles(
              context: context,
              title: AppLocalizations.of(context)!.messages,
              subTitle: AppLocalizations.of(context)!.all_messages,
              onTap: () {
                Navigator.pushNamed(context, RouteDefine.messageScreen.name);
              }),
          10.height,
          ListView.builder(
              itemCount: state.messageList.length > 1 ? 2 : 1,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var messageData = state.messageList[index];
                return messageListItem(
                    context: context,
                    title: messageData.message?.title ?? '',
                    content: parse(messageData.message?.body ?? '').body?.text ?? '',
                    dateTime: messageData.updatedAt?.replaceRange(11, 19, '') ?? '',
                    onTap: () async {
                      dynamic messageNewData = await Navigator.pushNamed(context, RouteDefine.messageContentScreen.name, arguments: {
                        AppStrings.messageDataString: messageData,
                        AppStrings.messageIdString: messageData.id,
                        AppStrings.isReadMoreString: true,
                      });
                      if (messageNewData != null) {
                        context.read<HomeBloc>().add(HomeEvent.removeOrUpdateMessageEvent(
                              messageId: messageNewData[AppStrings.messageIdString],
                              isRead: messageNewData[AppStrings.messageReadString],
                              isDelete: messageNewData[AppStrings.messageDeleteString],
                            ));
                      }
                    });
              }),
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
                if (state.isGuestUser) {
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                  return;
                }
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
                          decoration: BoxDecoration(
                              gradient: AppColors.appMainGradientColor,
                              border: Border.all(color: AppColors.whiteColor, width: 1),
                              shape: BoxShape.circle),
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
    if (isNavigation.isNotEmpty && !_handledBackgroundNavigations.contains(isNavigation)) {
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
      _handledBackgroundNavigations.add(isNavigation);
    }
  }

  Widget messageListItem(
      {required BuildContext context, required String title, required String content, required String dateTime, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.pageColor,
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(context.rtl ? pi : 0),
            child: SvgPicture.asset(AppImagePath.message,
                fit: BoxFit.scaleDown, height: 16, width: 16, colorFilter: ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn)),
          ),
          10.width,
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(title, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w500)),
              5.height,
              Text(content,
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.blackColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              3.height,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(dateTime, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor)),
                Text(AppLocalizations.of(context)!.read_more,
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.mainColor)),
              ]),
            ]),
          ),
        ]),
      ),
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
    if (suppliers.isEmpty) return;
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

  /// WhatsApp marketing consent popup. "Approve" records consent on the server
  /// (the dialog auto-closes once the opt-in succeeds); "Not now" just dismisses.
  whatsappOptinDialog({required BuildContext context, required HomeState state}) {
    // Tapping outside the popup is treated like "Not now" — it just closes and
    // reappears on the next app open (no opt-out recorded).
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (dialogContext) => BlocProvider.value(
              value: context.read<HomeBloc>(),
              child: BlocConsumer<HomeBloc, HomeState>(
                listenWhen: (previous, current) => previous.whatsappOptIn != current.whatsappOptIn,
                listener: (context, state) {
                  if (state.whatsappOptIn) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                builder: (context, state) {
                  // Title/text come from the admin settings; fall back to the
                  // bundled localized defaults when the settings value is empty.
                  final String title =
                      state.whatsappOptinPopupTitle.isNotEmpty ? state.whatsappOptinPopupTitle : AppLocalizations.of(context)!.whatsapp_optin_title;
                  final String body =
                      state.whatsappOptinPopupText.isNotEmpty ? state.whatsappOptinPopupText : AppLocalizations.of(context)!.whatsapp_optin_body;
                  return WhatsappOptinDialog(
                    directionality: state.language,
                    title: title,
                    body: body,
                    approveTitle: AppLocalizations.of(context)!.whatsapp_optin_approve,
                    notNowTitle: AppLocalizations.of(context)!.whatsapp_optin_not_now,
                    isProcessing: state.isWhatsappOptinProcessing,
                    onApprove: () {
                      // Record the exact text shown to the client as the consent.
                      context
                          .read<HomeBloc>()
                          .add(HomeEvent.sendWhatsappOptinEvent(context: context, source: _whatsappOptinSource, consentText: body));
                    },
                    onNotNow: () => Navigator.of(dialogContext).pop(),
                  );
                },
              ),
            ));
  }
}
