import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:food_stock/bloc/home/home_bloc.dart';
import 'package:food_stock/data/model/product_supplier_model/product_supplier_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/common_product_details_widget.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/company_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/custom_text_icon_button_widget.dart';
import 'package:food_stock/ui/widget/product_details_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:photo_view/photo_view.dart';
import '../../data/model/search_model/search_model.dart';
import '../utils/themes/app_urls.dart';
import '../widget/balance_indicator.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_button.dart';
import '../widget/common_product_item_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/common_search_widget.dart';
import '../widget/dashboard_stats_widget.dart';
import 'package:food_stock/ui/utils/push_notification_service.dart';


class HomeRoute {
  static Widget get route =>  HomeScreen();
}

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(HomeEvent.getCartCountEvent(context: context))
        ..add(HomeEvent.getPreferencesDataEvent())
        ..add(HomeEvent.getOrderCountEvent(context: context))
        ..add(HomeEvent.getWalletRecordEvent(context: context))
        ..add(HomeEvent.getMessageListEvent(context: context))
        ..add(HomeEvent.getRecommendationProductsListEvent(context: context))
       /*..add(HomeEvent.checkVersionOfAppEvent(context: context))*/,
      child: HomeScreenWidget(),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  HomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = context.read<HomeBloc>();
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        BlocProvider.of<BottomNavBloc>(context)
            .add(BottomNavEvent.updateCartCountEvent());
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.pageColor,
            body: FocusDetector(
              onFocusGained: () {
                handleMessageOnBackground();
                bloc.add(HomeEvent.getPreferencesDataEvent());
                bloc.add(HomeEvent.getRecommendationProductsListEvent(
                    context: context));
                bloc.add(HomeEvent.getWalletRecordEvent(context: context));
                bloc.add(HomeEvent.getMessageListEvent(context: context));
                bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
                bloc.add(HomeEvent.getCartCountEvent(context: context));
                bloc.add(HomeEvent.checkVersionOfAppEvent(context: context));
              },
              child: SafeArea(
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
                              context
                                  .read<BottomNavBloc>()
                                  .add(BottomNavEvent.changePage(index: 4));
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.whiteColor, width: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor
                                          .withOpacity(0.1),
                                      blurRadius: AppConstants.blur_10)
                                ],
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: state.UserImageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => Center(
                                            child:
                                                const CupertinoActivityIndicator()),
                                        imageUrl:
                                            '${AppUrls.baseFileUrl}${state.UserImageUrl}',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            color: AppColors.whiteColor,
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.whiteColor,
                                              width: 5),
                                          borderRadius:
                                              BorderRadius.circular(40)),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor
                                          .withOpacity(0.3),
                                      blurRadius: AppConstants.blur_10)
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppConstants.radius_100))),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            AppConstants.radius_100)),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppConstants.radius_100)),
                                    onTap: () async {
                                      dynamic messageResult =
                                          await Navigator.pushNamed(context,
                                              RouteDefine.messageScreen.name);
                                      debugPrint('delete = ${messageResult}');
                                      if (messageResult != null) {
                                        debugPrint(
                                            'delete = ${messageResult[AppStrings.messageIdListString]}');
                                        bloc.add(HomeEvent.updateMessageListEvent(
                                            messageIdList: messageResult[
                                                    AppStrings
                                                        .messageIdListString] ??
                                                ''));
                                      }
                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(
                                              context.rtl ? pi : 0),
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
                                                  height: 18,
                                                  width: 18,
                                                  decoration: BoxDecoration(
                                                      gradient: AppColors
                                                          .appMainGradientColor,
                                                      /*   color: AppColors
                                                          .notificationColor,*/
                                                      border: Border.all(
                                                          color: AppColors
                                                              .whiteColor,
                                                          width: 1),
                                                      shape: BoxShape.circle),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      '${state.messageCount <= 99 ? state.messageCount : '99+'}',
                                                      style: AppStyles
                                                          .rkRegularTextStyle(
                                                              size: AppConstants
                                                                  .font_8,
                                                              color: AppColors
                                                                  .whiteColor)),
                                                ))
                                      ],
                                    ),
                                  ),
                                ),
                             /*   InkWell(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppConstants.radius_100)),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RouteDefine.menuScreen.name);
                                  },
                                  child: SvgPicture.asset(
                                    AppImagePath.menuVertical,
                                    fit: BoxFit.scaleDown,
                                    width: 54,
                                    height: 54,
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                   // 5.height,
                    Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                80.height,
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<BottomNavBloc>()
                                        .add(BottomNavEvent.changePage(index: 3));
                                  },
                                  child: Container(
                                    width: getScreenWidth(context),
                                    clipBehavior: Clip.hardEdge,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.padding_10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_10,
                                        horizontal: AppConstants.padding_10),
                                    decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.shadowColor
                                                  .withOpacity(0.15),
                                              blurRadius: AppConstants.blur_10)
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .balance_status,
                                                  style:
                                                  AppStyles.rkRegularTextStyle(
                                                    size: AppConstants.smallFont,
                                                    color: AppColors.blackColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                6.height,
                                                BalanceIndicator(
                                                    pendingBalance: formatNumber(
                                                        value: state.balance.toString(),local: AppStrings.hebrewLocal),
                                                    expense:
                                                    state.expensePercentage.round(),
                                                    totalBalance: 100),
                                                6.height,
                                                Directionality(
                                                  textDirection: TextDirection.rtl,
                                                  child: Text(
                                                    '${formatNumber( value: state.balance.toString(),local: AppStrings.hebrewLocal)}',
                                                    style: AppStyles.rkRegularTextStyle(
                                                        size: AppConstants.font_14,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.blackColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        5.width,
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: DashBoardStatsWidget(
                                                        fontSize:  AppConstants.font_14,
                                                        context: context,
                                                        image: AppImagePath.credits,
                                                        title: AppLocalizations.of(
                                                            context)!.total_credit,
                                                        value: '${formatNumber(value: state.totalCredit.toString() ,local: AppStrings.hebrewLocal) }'),
                                                  ),
                                                  10.width,
                                                  Flexible(
                                                    child: DashBoardStatsWidget(
                                                        fontSize:  AppConstants.font_14,
                                                        context: context,
                                                        image: AppImagePath.expense,
                                                        title: AppLocalizations.of(
                                                            context)!
                                                            .this_months_expenses,
                                                        value:
                                                        '${formatNumber(value: state.thisMonthExpense.toString() ,local: AppStrings.hebrewLocal) }'),

                                                  ),
                                                ],
                                              ),
                                              10.height,
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: DashBoardStatsWidget(
                                                        fontSize:  AppConstants.font_14,
                                                        context: context,
                                                        image: AppImagePath.orders,
                                                        title: AppLocalizations.of(
                                                            context)!
                                                            .this_months_orders,
                                                        value: state.orderThisMonth.toString()),
                                                  ),
                                                  10.width,
                                                  Flexible(
                                                    child: DashBoardStatsWidget(
                                                        fontSize:  AppConstants.font_14,
                                                        context: context,
                                                        image: AppImagePath.expense,
                                                        title: AppLocalizations.of(
                                                            context)!
                                                            .last_months_expenses,
                                                        value:
                                                        '${formatNumber(value: state.lastMonthExpense.toString(),local:AppStrings.hebrewLocal)}'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                20.height,
                                AnimatedCrossFade(
                                    firstChild: getScreenWidth(context).width,
                                    secondChild: Column(
                                      children: [
                                        buildListTitles(
                                            context: context,
                                            title: AppLocalizations.of(context)!
                                                .recommended_for_you,
                                            subTitle: /*state
                                                  .recommendedProductsList
                                                  .length <
                                                  6
                                                  ? ''
                                                  : */
                                            AppLocalizations.of(context)!.more,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .recommendationProductsScreen
                                                      .name);
                                            }),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height:  190,
                                          child: ListView.builder(
                                              itemCount: state
                                                  .recommendedProductsList.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                  AppConstants.padding_5),
                                              itemBuilder: (context, index) =>
                                                  CommonProductItemWidget(
                                                    productStock: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .productStock.toString() ??
                                                        '0',
                                                    height: 160,
                                                    width:  140,
                                                    productImage: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .mainImage ??
                                                        '',
                                                    productName: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .productName ??
                                                        '',
                                                    totalSaleCount: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .totalSale ??
                                                        0,
                                                    price: state
                                                        .recommendedProductsList[
                                                    index]
                                                        .productPrice
                                                        ?.toDouble() ??
                                                        0.0,
                                                    onButtonTap: () {

                                                        showProductDetails(
                                                            context: context,
                                                            productId: state
                                                                .recommendedProductsList[
                                                            index]
                                                                .id ??
                                                                '',
                                                        productStock:(state
                                                            .recommendedProductsList[
                                                        index]
                                                            .productStock.toString()) ?? '',
                                                        );


                                                    },
                                                  )

                                          ),
                                        ),
                                      ],
                                    ),
                                    crossFadeState:
                                    state.recommendedProductsList.isEmpty
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    duration: Duration(milliseconds: 300)),

                                state.cartCount == 0
                                    ? CustomTextIconButtonWidget(
                                  width: double.maxFinite,
                                  title:
                                  AppLocalizations.of(context)!.new_order,
                                  onPressed: () {
                                    context.read<BottomNavBloc>().add(
                                        BottomNavEvent.changePage(index: 1));
                                  },
                                  svgImage: AppImagePath.add,
                                )
                                    : CustomTextIconButtonWidget(
                                  width: double.maxFinite,
                                  title:
                                  AppLocalizations.of(context)!.my_basket,
                                  onPressed: () {
                                    context.read<BottomNavBloc>().add(
                                        BottomNavEvent.changePage(index: 2));
                                  },
                                  svgImage: AppImagePath.cart,
                                  cartCount: state.cartCount,
                                ),
                                30.height,
                                state.messageList.isEmpty
                                    ? 0.width/*Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppConstants.padding_10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .messages,
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont,
                                            color: AppColors.blackColor),
                                      ),
                                      Container(
                                        height: getScreenHeight(context) / 6,
                                        width: getScreenWidth(context),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${AppLocalizations.of(context)!.messages_not_found}',
                                          style: AppStyles.pVRegularTextStyle(
                                              size: AppConstants.mediumFont,
                                              color: AppColors.textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                )*/
                                    : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    titleRowWidget(
                                        context: context,
                                        title: AppLocalizations.of(context)!
                                            .messages,
                                        allContentTitle:
                                        AppLocalizations.of(context)!
                                            .all_messages,
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              RouteDefine.messageScreen.name);
                                        }),
                                    10.height,
                                    ListView.builder(
                                      itemCount: state.messageList.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          messageListItem(
                                              context: context,
                                              title: state.messageList[index]
                                                  .message?.title ??
                                                  '',
                                              content: parse(state
                                                  .messageList[
                                              index]
                                                  .message
                                                  ?.body ??
                                                  '')
                                                  .body
                                                  ?.text ??
                                                  '',
                                              dateTime: state
                                                  .messageList[index]
                                                  .updatedAt
                                                  ?.replaceRange(
                                                  11, 19, '') ??
                                                  '',
                                              onTap: () async {
                                                dynamic messageNewData =
                                                await Navigator.pushNamed(
                                                    context,
                                                    RouteDefine
                                                        .messageContentScreen
                                                        .name,
                                                    arguments: {
                                                      AppStrings
                                                          .messageDataString:
                                                      state.messageList[
                                                      index],
                                                      AppStrings
                                                          .messageIdString:
                                                      state
                                                          .messageList[
                                                      index]
                                                          .id,
                                                      AppStrings
                                                          .isReadMoreString:
                                                      true,
                                                    });
                                                debugPrint(
                                                    'message = $messageNewData');
                                                if (messageNewData != null) {
                                                  context.read<HomeBloc>().add(
                                                      HomeEvent.removeOrUpdateMessageEvent(
                                                          messageId:
                                                          messageNewData[
                                                          AppStrings
                                                              .messageIdString],
                                                          isRead: messageNewData[
                                                          AppStrings
                                                              .messageReadString],
                                                          isDelete:
                                                          messageNewData[
                                                          AppStrings
                                                              .messageDeleteString]));
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
                          CommonSearchWidget(
                            isFilterTap: true,
                            isCategoryExpand: state.isCategoryExpand,
                            isSearching: state.isSearching,
                            onFilterTap: () {
                              bloc.add(HomeEvent.changeCategoryExpansion());
                            },
                            onSearchTap: () {
                              if(state.searchController.text != ''){
                                bloc.add(HomeEvent.changeCategoryExpansion(isOpened: true));
                              }
                            },
                            onSearch: (String search) {
                              if (search.length > 1) {
                                bloc.add(HomeEvent.changeCategoryExpansion(isOpened: true));
                                bloc.add(
                                    HomeEvent.globalSearchEvent(context: context));
                              }
                            },
                            onSearchSubmit: (String search) {
                              bloc.add(
                                  HomeEvent.globalSearchEvent(context: context));
                            },
                            onOutSideTap: () {
                              bloc.add(HomeEvent.changeCategoryExpansion(
                                  isOpened: false));
                            },
                            onSearchItemTap: () {
                              bloc.add(HomeEvent.changeCategoryExpansion());
                            },
                            controller: state.searchController,
                            searchList: state.searchList,
                            searchResultWidget: state.searchList.isEmpty
                                ? Center(
                              child: Text(
                                '${AppLocalizations.of(context)!
                                    .search_result_not_found}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.textColor),
                              ),
                            )
                                : ListView.builder(
                              itemCount: state.searchList.length,
                              shrinkWrap: true,
                              itemBuilder: (listViewContext, index) {
                                return _buildSearchItem(
                                    productStock : state.searchList[index].productStock,
                                    context: context,
                                    searchName: state.searchList[index].name,
                                    searchImage: state.searchList[index].image,
                                    searchType:
                                    state.searchList[index].searchType,
                                    isMoreResults: state.searchList
                                        .where((search) =>
                                    search.searchType ==
                                        state.searchList[index]
                                            .searchType)
                                        .toList()
                                        .length ==
                                        10,
                                    isLastItem:
                                    state.searchList.length - 1 == index,
                                    isShowSearchLabel: index == 0
                                        ? true
                                        : state.searchList[index].searchType !=
                                        state.searchList[index - 1]
                                            .searchType
                                        ? true
                                        : false,
                                    onSeeAllTap: () async {
                                      debugPrint("searchType: ${state.searchList[index].searchType}");
                                      if (state.searchList[index].searchType ==
                                          SearchTypes.category) {
                                        dynamic searchResult =
                                        await Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .productCategoryScreen.name,
                                            arguments: {
                                              AppStrings.searchString:
                                              state.search,
                                              AppStrings.reqSearchString:
                                              state.search,
                                              AppStrings.searchResultString:
                                              state.searchList
                                            });
                                        if (searchResult != null) {
                                          bloc.add(HomeEvent
                                              .updateGlobalSearchEvent(
                                              search: searchResult[
                                              AppStrings.searchString],
                                              searchList: searchResult[
                                              AppStrings
                                                  .searchResultString]));
                                        }
                                      } else if (state
                                          .searchList[index].searchType ==
                                          SearchTypes.subCategory) {
                                        dynamic searchResult =
                                        await Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .storeCategoryScreen.name,
                                            arguments: {
                                              AppStrings.categoryIdString: state
                                                  .searchList[index].categoryId,
                                              AppStrings.categoryNameString:
                                              state.searchList[index]
                                                  .categoryName,
                                              AppStrings.searchString:
                                              state.search,
                                              AppStrings.searchResultString:
                                              state.searchList
                                            });
                                        if (searchResult != null) {
                                          bloc.add(HomeEvent
                                              .updateGlobalSearchEvent(
                                              search: searchResult[
                                              AppStrings.searchString],
                                              searchList: searchResult[
                                              AppStrings
                                                  .searchResultString]));
                                        }
                                      } else {
                                        state.searchList[index].searchType ==
                                            SearchTypes.company
                                            ? Navigator.pushNamed(
                                            context, RouteDefine.companyScreen.name,
                                            arguments: {AppStrings.searchString: state.search})
                                            : state.searchList[index].searchType ==
                                            SearchTypes.supplier
                                            ? Navigator.pushNamed(
                                            context, RouteDefine.supplierScreen.name,
                                            arguments: {
                                              AppStrings.searchString:
                                              state.search
                                            })
                                            : state.searchList[index].searchType ==
                                            SearchTypes.sale
                                            ? Navigator.pushNamed(
                                            context,
                                            RouteDefine.productSaleScreen.name,
                                            arguments: {
                                              AppStrings.searchString: state.search
                                            })
                                            : Navigator.pushNamed(
                                            context,
                                            RouteDefine.supplierProductsScreen.name,
                                            arguments: {
                                              AppStrings.searchString: state.search,
                                              AppStrings.searchType : SearchTypes.product.toString()
                                            });
                                      }
                                    },
                                    onTap: () async {
                                      if (state.searchList[index].searchType ==
                                          SearchTypes.subCategory) {
                                        CustomSnackBar.showSnackBar(
                                          context: context,
                                          title: AppStrings.getLocalizedStrings(
                                              'Oops! in progress', context),
                                          type: SnackBarType.SUCCESS,
                                        );
                                        return;
                                      }
                                      if (state.searchList[index].searchType ==
                                          SearchTypes.sale ||
                                          state.searchList[index].searchType ==
                                              SearchTypes.product) {
                                        print("tap 4");
                                        showProductDetails(
                                            context: context,
                                            productId: state
                                                .searchList[index].searchId,
                                            isBarcode: true,
                                          productStock: (state.searchList[index].productStock.toString() ?? '')
                                        );
                                      } else if (state
                                          .searchList[index].searchType ==
                                          SearchTypes.category) {
                                        dynamic searchResult =
                                        await Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .storeCategoryScreen.name,
                                            arguments: {
                                              AppStrings.categoryIdString: state
                                                  .searchList[index].searchId,
                                              AppStrings.categoryNameString:
                                              state.searchList[index].name,
                                              AppStrings.searchString:
                                              state.searchController.text,
                                              AppStrings.searchResultString:
                                              state.searchList
                                            });
                                        if (searchResult != null) {
                                          bloc.add(HomeEvent
                                              .updateGlobalSearchEvent(
                                              search: searchResult[
                                              AppStrings.searchString],
                                              searchList: searchResult[
                                              AppStrings
                                                  .searchResultString]));
                                        }
                                      } else {
                                        state.searchList[index].searchType ==
                                            SearchTypes.company
                                            ? Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .companyProductsScreen.name,
                                            arguments: {
                                              AppStrings.companyIdString:
                                              state.searchList[index]
                                                  .searchId
                                            })
                                            : Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .supplierProductsScreen
                                                .name,
                                            arguments: {
                                              AppStrings.supplierIdString:
                                              state.searchList[index]
                                                  .searchId
                                            });
                                      }
                                      bloc.add(
                                          HomeEvent.changeCategoryExpansion());
                                    });
                              },
                            ),
                            onScanTap: () async {
                              String scanResult = await scanBarcodeOrQRCode(
                                  context: context,
                                  cancelText: AppLocalizations.of(context)!.cancel,
                                  scanMode: ScanMode.BARCODE);
                              if (scanResult != '-1') {
                                // -1 result for cancel scanning
                                debugPrint('result = $scanResult');
                                print("tap 5");
                                showProductDetails(
                                    context: context,
                                    productId: scanResult,
                                    isBarcode: true,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )
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
    PushNotificationService().firebaseMessaging.getInitialMessage().then(
          (remoteMessage) {
        if (remoteMessage != null) {
          debugPrint("onMessageClosedApp: ${remoteMessage.data}");
          PushNotificationService().manageNavigation( true, remoteMessage.data['data']['message']['mainPage'], remoteMessage.data['data']['message']['subPage'] , remoteMessage.data['data']['message']['id']);
        }
      },
    );
  }

  Widget titleRowWidget(
      {required BuildContext context,
      required title,
      required allContentTitle,
      required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.blackColor),
          ),
          InkWell(
            onTap: onTap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              allContentTitle,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
  

  Padding buildListTitles(
      {required BuildContext context,
      required String title,
      required void Function() onTap,
      required subTitle}) {
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
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: AppColors.blackColor),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              subTitle,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: AppColors.mainColor),
            ),
          ),
        ],
      ),
    );
  }

  CommonShimmerWidget buildListItems(BuildContext context, {double? height}) {
    return CommonShimmerWidget(
      child: Container(
        width: getScreenWidth(context),
        height: height ?? 110,
        margin: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.radius_10),
          ),
          color: AppColors.whiteColor,
        ),
      ),
    );
  }

  Widget buildTextFieldTitle() {
    return CommonShimmerWidget(
      child: Container(
        height: AppConstants.shimmerTextHeight,
        width: 100,
        margin: EdgeInsets.symmetric(vertical: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_3)),
        ),
      ),
    );
  }

  Widget buildProductSaleListItem({
    required BuildContext context,
    required String saleImage,
    required String title,
    required String description,
    required double salePercentage,
    required void Function() onButtonTap,
  }) {
    return Container(
      height: 170,
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: AppConstants.blur_10),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      padding: EdgeInsets.symmetric(
          vertical: AppConstants.padding_5,
          horizontal: AppConstants.padding_10),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onButtonTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: "${AppUrls.baseFileUrl}$saleImage",
                height: 70,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) {
                  return CommonShimmerWidget(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_10)),
                      ),
                      // alignment: Alignment.center,
                      // child: CupertinoActivityIndicator(
                      //   color: AppColors.blackColor,
                      // ),
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  // debugPrint('sale list image error : $error');
                  return Container(
                    child: Image.asset(AppImagePath.imageNotAvailable5,
                        height: 70, width: double.maxFinite, fit: BoxFit.cover),
                  );
                },
              ),
            ),
            5.height,
            Text(
              title,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12,
                  color: AppColors.saleRedColor,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            5.height,
            Expanded(
              child: Text(
                "${parse(description).body?.text}",
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_10, color: AppColors.blackColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            5.height,
            Center(
              child: CommonProductButtonWidget(
                title:
                    "${salePercentage.toStringAsFixed(0)}%" /*${AppLocalizations.of(context)!.currency}*/,
                onPressed: onButtonTap,
                // height: 35,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_12,
              ),
            )
          ],
        ),
      ),
    );
  }

  void showProductDetails({
    required BuildContext context,
    required String productId,
    bool? isBarcode,
     String productStock  = '0',
  }) async {
    context.read<HomeBloc>().add(HomeEvent.getProductDetailsEvent(
          context: context,
          productId: productId,
      isBarcode: isBarcode ?? false
        ));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        print('productStock_11____${productStock}');
        return BlocProvider.value(
          value: context.read<HomeBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: AppConstants.bottomSheetInitHeight,
            //shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.radius_30),
                        topRight: Radius.circular(AppConstants.radius_30),
                      ),
                      color: AppColors.whiteColor,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Scaffold(
                      body: state.isProductLoading
                          ? ProductDetailsShimmerWidget()
                          : state.productDetails.isEmpty
                              ? Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.no_product,
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.redColor,
                                        fontWeight: FontWeight.w500,
                                      )),
                                )
                              : CommonProductDetailsWidget(
                        addToOrderTap: () {
                          context.read<HomeBloc>().add(
                              HomeEvent.addToCartProductEvent(
                                  context: context1,
                                  productId: productId
                              ));
                        },
                        isLoading: state.isLoading,
                                imageOnTap: (){
                                 showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: getScreenHeight(context) - MediaQuery.of(context).padding.top ,
                                              width: getScreenWidth(context),
                                              child: PhotoView(
                                                imageProvider: CachedNetworkImageProvider(
                                                  '${AppUrls.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}',
                                                ),
                                              ),
                                            ),

                                           GestureDetector(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(Icons.close,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        );
                                      },);

                                },
                                 isPreview: state.isPreview,
                                  context: context,
                                  productImageIndex: state.imageIndex,
                                  onPageChanged: (index, p1) {
                                    context.read<HomeBloc>().add(
                                        HomeEvent.updateImageIndexEvent(
                                            index: index));
                                  },
                                  productImages: [
                                    state.productDetails.first.mainImage ??
                                        '',
                                    ...state.productDetails.first.images
                                            ?.map((image) =>
                                                image.imageUrl ?? '') ??
                                        []
                                  ],
                                  productPerUnit: state.productDetails.first
                                          .numberOfUnit ??
                                      0,
                                  productUnitPrice: state
                                      .productStockList[
                                          state.productStockUpdateIndex]
                                      .totalPrice,
                                  productName: state.productDetails.first
                                          .productName ??
                                      '',
                                  productCompanyName: state
                                          .productDetails.first.brandName ??
                                      '',
                                  productDescription: parse(state
                                                  .productDetails
                                                  .first
                                                  .productDescription ??
                                              '')
                                          .body
                                          ?.text ??
                                      '',
                                  productSaleDescription: parse(state
                                                  .productDetails
                                                  .first
                                                  .productDescription ??
                                              '')
                                          .body
                                          ?.text ??
                                      '',
                                  productPrice: state
                                          .productStockList[
                                              state.productStockUpdateIndex]
                                          .totalPrice *
                                      state
                                          .productStockList[
                                              state.productStockUpdateIndex]
                                          .quantity *
                                      (state.productDetails.first
                                              .numberOfUnit ??
                                          0),
                                  productScaleType: state.productDetails
                                          .first.scales?.scaleType ??
                                      '',
                                  productWeight: state
                                          .productDetails.first.itemsWeight
                                          ?.toDouble() ??
                                      0.0,
                        productStock: state.productStockList[state.productStockUpdateIndex].stock != 0 ?
                        int.parse(state.productStockList[state.productStockUpdateIndex].stock.toString()):
                        int.parse(productStock.toString() ?? '0'),
                        isRTL: context.rtl,
                                  isSupplierAvailable:
                                      state.productSupplierList.isEmpty
                                          ? false
                                          : true,
                                  scrollController: scrollController,
                                  productQuantity: state
                                      .productStockList[
                                          state.productStockUpdateIndex]
                                      .quantity,
                                  onQuantityChanged: (quantity) {
                                    context.read<HomeBloc>().add(
                                        HomeEvent.updateQuantityOfProduct(
                                            context: context1,
                                            quantity: quantity));
                                  },
                                  onQuantityIncreaseTap: () {
                                    context.read<HomeBloc>().add(
                                        HomeEvent.increaseQuantityOfProduct(
                                            context: context1));
                                  },
                                  onQuantityDecreaseTap: () {
                                    context.read<HomeBloc>().add(
                                        HomeEvent.decreaseQuantityOfProduct(
                                            context: context1));
                                  },
                                ),
                      bottomNavigationBar: state.isRelatedShimmering
                          ? 0.height
                          :
                      Container(
                        height: 200,
                        padding: EdgeInsets.only(bottom:10,left: 10,right: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context,i){
                            return CommonProductItemWidget(
                              productStock:state.relatedProductList.elementAt(i).productStock.toString()??'0',
                            width: 140,
                            productImage:state.relatedProductList[i].mainImage??'',
                            productName: state.relatedProductList.elementAt(i).productName??'',
                            totalSaleCount: state.relatedProductList.elementAt(i).totalSale??0,
                            price:state.relatedProductList.elementAt(i).productPrice??0.0,
                            onButtonTap: () {
                              print("tap 2");
                            },
                          );},itemCount: state.relatedProductList.length,),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget messageListItem({
    required BuildContext context,
    required String title,
    required String content,
    required String dateTime,
    required void Function() onTap,
  }) {
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
                colorFilter:
                    ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn),
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
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500),
                  ),
                  5.height,
                  Text(
                    content,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_10, color: AppColors.blackColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  3.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateTime,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_12,
                            color: AppColors.blackColor),
                      ),
                      Text(
                        AppLocalizations.of(context)!.read_more,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_12,
                            color: AppColors.mainColor),
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

  Widget buildSupplierSelection({required BuildContext context}) {
    return BlocProvider.value(
      value: context.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return AnimatedCrossFade(
              firstChild: Container(
                width: getScreenWidth(context),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: AppColors.borderColor.withOpacity(0.5),
                            width: 1))),
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding_10,
                    horizontal: AppConstants.padding_30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppConstants.padding_5),
                      child: InkWell(
                        onTap: () {
                          context.read<HomeBloc>().add(HomeEvent
                              .changeSupplierSelectionExpansionEvent());
                        },
                        child: state.productSupplierList.length > 1 ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.suppliers,
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.smallFont,
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 26,
                              color: AppColors.blackColor,
                            )
                          ],
                        ) : 0.width,
                      ),
                    ),
                    state.productSupplierList
                            .where((supplier) => supplier.selectedIndex != -1)
                            .isEmpty
                        ? InkWell(
                            onTap: () {
                              context.read<HomeBloc>().add(HomeEvent
                                  .changeSupplierSelectionExpansionEvent());
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: 60,
                              width: getScreenWidth(context),
                              alignment: Alignment.center,
                              child: Text(
                                '${AppLocalizations.of(context)!.select_supplier}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.blackColor),
                              ),
                            ))
                        : ListView.builder(
                            itemCount: state.productSupplierList
                                    .where((supplier) =>
                                        supplier.selectedIndex != -1)
                                    .isNotEmpty
                                ? 1
                                : 0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 85,
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5,
                                    horizontal: AppConstants.padding_10),
                                margin: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5),
                                decoration: BoxDecoration(
                                  color: AppColors.iconBGColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppConstants.radius_5)),
                                  border: Border.all(
                                      color: AppColors.borderColor
                                          .withOpacity(0.8),
                                      width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex != -1).companyName}',
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: getScreenWidth(context),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.borderColor
                                                    .withOpacity(0.5),
                                                width: 1),
                                            color: AppColors.whiteColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    AppConstants.radius_5))),
                                        padding: EdgeInsets.symmetric(
                                            vertical: AppConstants.padding_3,
                                            horizontal: AppConstants.padding_5),
                                        margin: EdgeInsets.only(
                                          top: AppConstants.padding_5,
                                        ),
                                        child: state.productSupplierList
                                                    .firstWhere(
                                                      (supplier) =>
                                                          supplier
                                                              .selectedIndex ==
                                                          -2,
                                                      orElse: () =>
                                                          ProductSupplierModel(
                                                              supplierId: '',
                                                              companyName: ''),
                                                    )
                                                    .selectedIndex ==
                                                -2
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit}:${AppLocalizations.of(context)!.currency}${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex == -2).basePrice.toStringAsFixed(AppConstants.amountFrLength)}',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                            size: AppConstants
                                                                .font_14,
                                                            color: AppColors
                                                                .blackColor),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    '${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].saleName}',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                            size: AppConstants
                                                                .font_12,
                                                            color: AppColors
                                                                .saleRedColor),
                                                  ),
                                                  2.height,
                                                  Text(
                                                    '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit} : ${AppLocalizations.of(context)!.currency}${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].salePrice.toStringAsFixed(AppConstants.amountFrLength)}(${state.productSupplierList.firstWhere((supplier) => supplier.selectedIndex >= 0).supplierSales[index].saleDiscount.toStringAsFixed(0)}%)',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                            size: AppConstants
                                                                .font_14,
                                                            color: AppColors
                                                                .blackColor),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                  ],
                ),
              ),
              secondChild: state.productSupplierList.isEmpty
                  ? Center(
                      child: Text(
                        '${AppLocalizations.of(context)!.suppliers_not_available}',
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont,
                            color: AppColors.textColor),
                      ),
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: getScreenHeight(context) * 0.5,
                          maxWidth: getScreenWidth(context)),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.5),
                                    width: 1))),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.padding_10,
                            horizontal: AppConstants.padding_30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppConstants.padding_5),
                              child: InkWell(
                                onTap: () {
                                  context.read<HomeBloc>().add(HomeEvent
                                      .changeSupplierSelectionExpansionEvent());
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.suppliers,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.smallFont,
                                          color: AppColors.mainColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.remove,
                                      size: 26,
                                      color: AppColors.blackColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.productSupplierList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 105,
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_5,
                                        horizontal: AppConstants.padding_10),
                                    margin: EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_10),
                                    decoration: BoxDecoration(
                                        color: AppColors.iconBGColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppConstants.radius_10)),
                                        boxShadow: [
                                          state.productSupplierList[index]
                                                      .selectedIndex !=
                                                  -1
                                              ? BoxShadow(
                                                  color: AppColors.shadowColor
                                                      .withOpacity(0.15),
                                                  blurRadius:
                                                      AppConstants.blur_10)
                                              : BoxShadow()
                                        ],
                                        border: Border.all(
                                            color: AppColors.lightBorderColor,
                                            width: 1)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${state.productSupplierList[index].companyName}',
                                          style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.font_14,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: state
                                                    .productSupplierList[index]
                                                    .supplierSales
                                                    .length +
                                                1,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, subIndex) {
                                              return subIndex ==
                                                      state
                                                          .productSupplierList[
                                                              index]
                                                          .supplierSales
                                                          .length
                                                  ? InkWell(
                                                      onTap: () {
                                                        //for base price selection /without sale pass -2
                                                        context
                                                            .read<HomeBloc>()
                                                            .add(HomeEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    context:
                                                                        context,
                                                                    supplierSaleIndex:
                                                                        -2));
                                                        context
                                                            .read<HomeBloc>()
                                                            .add(HomeEvent
                                                                .changeSupplierSelectionExpansionEvent());
                                                      },
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .whiteColor,
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    AppConstants
                                                                        .radius_10)),
                                                            border: Border.all(
                                                                color: state
                                                                            .productSupplierList[
                                                                                index]
                                                                            .selectedIndex ==
                                                                        -2
                                                                    ? AppColors
                                                                        .mainColor
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : Colors
                                                                        .transparent,
                                                                width: 1.5)),
                                                        padding: EdgeInsets.symmetric(
                                                            vertical:
                                                                AppConstants
                                                                    .padding_3,
                                                            horizontal:
                                                                AppConstants
                                                                    .padding_5),
                                                        margin: EdgeInsets.only(
                                                            top: AppConstants
                                                                .padding_5,
                                                            left: AppConstants
                                                                .padding_5,
                                                            right: AppConstants
                                                                .padding_5),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              '${AppLocalizations.of(context)!.price} : ${AppLocalizations.of(context)!.currency}${state.productSupplierList[index].basePrice.toStringAsFixed(AppConstants.amountFrLength)}',
                                                              style: AppStyles.rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .font_14,
                                                                  color: AppColors
                                                                      .blackColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        context
                                                            .read<HomeBloc>()
                                                            .add(HomeEvent
                                                                .supplierSelectionEvent(
                                                                    supplierIndex:
                                                                        index,
                                                                    context:
                                                                        context,
                                                                    supplierSaleIndex:
                                                                        subIndex));
                                                        context
                                                            .read<HomeBloc>()
                                                            .add(HomeEvent
                                                                .changeSupplierSelectionExpansionEvent());
                                                      },
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .whiteColor,
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    AppConstants
                                                                        .radius_10)),
                                                            border: Border.all(
                                                                color: state.productSupplierList[index].selectedIndex ==
                                                                        subIndex
                                                                    ? AppColors
                                                                        .mainColor
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : Colors
                                                                        .transparent,
                                                                width: 1.5)),
                                                        padding: EdgeInsets.symmetric(
                                                            vertical:
                                                                AppConstants
                                                                    .padding_3,
                                                            horizontal:
                                                                AppConstants
                                                                    .padding_5),
                                                        margin: EdgeInsets.only(
                                                            top: AppConstants
                                                                .padding_5,
                                                            left: AppConstants
                                                                .padding_5,
                                                            right: AppConstants
                                                                .padding_5),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              '${state.productSupplierList[index].supplierSales[subIndex].saleName}',
                                                              style: AppStyles.rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .font_12,
                                                                  color: AppColors
                                                                      .saleRedColor),
                                                            ),
                                                            2.height,
                                                            Text(
                                                              '${AppLocalizations.of(context)!.price} : ${state.productSupplierList[index].supplierSales[subIndex].salePrice.toStringAsFixed(AppConstants.amountFrLength)}${AppLocalizations.of(context)!.currency}(${state.productSupplierList[index].supplierSales[subIndex].saleDiscount.toStringAsFixed(0)}%)',
                                                              style: AppStyles.rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .font_14,
                                                                  color: AppColors
                                                                      .blackColor),
                                                            ),
                                                            2.height,
                                                            GestureDetector(
                                                                onTap: () {
                                                                  showConditionDialog(
                                                                      context:
                                                                          context,
                                                                      saleCondition:
                                                                          '${state.productSupplierList[index].supplierSales[subIndex].saleDescription}');
                                                                },
                                                                child: Text(
                                                                  '${AppLocalizations.of(context)!.read_condition}',
                                                                  style: AppStyles.rkRegularTextStyle(
                                                                      size: AppConstants
                                                                          .font_10,
                                                                      color: AppColors
                                                                          .blueColor),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              crossFadeState: state.isSelectSupplier
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300));
        },
      ),
    );
  }

  void showConditionDialog(
      {required BuildContext context, required String saleCondition}) {
    showDialog(
        context: context,
        builder: (context) => CommonSaleDescriptionDialog(
            title: saleCondition,
            onTap: () {
              Navigator.pop(context);
            },
            buttonTitle: "${AppLocalizations.of(context)!.price}"));
  }

  Widget _buildSearchItem({
    required BuildContext context,
    required String searchName,
    required String searchImage,
    required SearchTypes searchType,
    required bool isShowSearchLabel,
    required bool isMoreResults,
    required void Function() onTap,
    required void Function() onSeeAllTap,
    bool? isLastItem, required int productStock,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isShowSearchLabel
            ? Padding(
          padding: const EdgeInsets.only(
              left: AppConstants.padding_20,
              right: AppConstants.padding_20,
              top: AppConstants.padding_15,
              bottom: AppConstants.padding_5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                searchType == SearchTypes.category
                    ? AppLocalizations.of(context)!.categories
                    : searchType == SearchTypes.subCategory
                    ? AppLocalizations.of(context)!.sub_categories
                    : searchType == SearchTypes.company
                    ? AppLocalizations.of(context)!.companies
                    : searchType == SearchTypes.sale
                    ? AppLocalizations.of(context)!.sales
                    : searchType == SearchTypes.supplier
                    ? AppLocalizations.of(context)!
                    .suppliers
                    : AppLocalizations.of(context)!
                    .products,
                style: AppStyles.rkBoldTextStyle(
                    size: AppConstants.smallFont,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500),
              ),

              isMoreResults
                  ? GestureDetector(
                onTap: onSeeAllTap,
                child: Text(
                  AppLocalizations.of(context)!.see_all,
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_14,
                      color: AppColors.mainColor),
                ),
              )
                  : 0.width,
            ],
          ),
        )
            : 0.width,
        InkWell(
          onTap: onTap,
          child: Container(
            height: (productStock) != 0 ? 35 : 50,
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border(
                    bottom: (isLastItem ?? false)
                        ? BorderSide.none
                        : BorderSide(
                        color: AppColors.borderColor.withOpacity(0.5),
                        width: 1))),
            padding: EdgeInsets.only(
                top: AppConstants.padding_5,
                left: AppConstants.padding_20,
                right: AppConstants.padding_20,
                bottom: AppConstants.padding_5),
            // padding: EdgeInsets.symmetric(
            //     horizontal: AppConstants.padding_20,
            //     vertical: AppConstants.padding_5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 35,
                  width: 40,
                  child: Image.network(
                    '${AppUrls.baseFileUrl}$searchImage',
                    fit: BoxFit.scaleDown,
                    height: 35,
                    width: 40,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                            width: 40,
                            height: 35,
                            child: CupertinoActivityIndicator())
                        /*CommonShimmerWidget(
                            child: Container(
                              width: 40,
                              height: 35,
                              color: AppColors.whiteColor,
                            ))*/
                        ;
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return searchType == SearchTypes.subCategory
                          ? Image.asset(AppImagePath.imageNotAvailable5,
                          height: 35, width: 40, fit: BoxFit.cover)
                          : SvgPicture.asset(
                        AppImagePath.splashLogo,
                        fit: BoxFit.scaleDown,
                        width: 40,
                        height: 35,
                      );
                    },
                  ),
                ),
                10.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        searchName,
                        style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_12,
                          color: AppColors.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    (productStock) != 0 ? 0.width : Text(
                      AppLocalizations.of(context)!
                          .out_of_stock1,
                      style: AppStyles.rkBoldTextStyle(
                          size: AppConstants.font_12,
                          color: AppColors.redColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
