import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:food_stock/ui/widget/custom_text_icon_button_widget.dart';
import 'package:food_stock/ui/widget/product_details_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import '../utils/themes/app_urls.dart';
import '../widget/balance_indicator.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_button.dart';
import '../widget/common_product_item_widget.dart';
import '../widget/common_sale_description_dialog.dart';
import '../widget/dashboard_stats_widget.dart';

class HomeRoute {
  static Widget get route => const HomeScreen();
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(HomeEvent.getCartCountEvent(context: context))
        ..add(HomeEvent.getPreferencesDataEvent())
        ..add(HomeEvent.getProductSalesListEvent(context: context))
        ..add(HomeEvent.getOrderCountEvent(context: context))
        ..add(HomeEvent.getWalletRecordEvent(context: context))
        ..add(HomeEvent.getMessageListEvent(context: context))
      ..add(HomeEvent.getRecommendationProductsListEvent(context: context)),
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
                bloc.add(HomeEvent.getPreferencesDataEvent());

                  bloc.add(
                      HomeEvent.getProductSalesListEvent(context: context));
                  bloc.add(HomeEvent.getRecommendationProductsListEvent(context: context));

                bloc.add(HomeEvent.getWalletRecordEvent(context: context));
                bloc.add(HomeEvent.getMessageListEvent(context: context));
                bloc.add(HomeEvent.getProfileDetailsEvent(context: context));
                bloc.add(HomeEvent.getCartCountEvent(context: context));
              },
              child: SafeArea(
                child: Column(
                  children: [
                    //appbar
                    Padding(
                      padding: const EdgeInsets.only(
                        top:AppConstants.padding_30 ,
                          bottom: AppConstants.padding_5,
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    //color: AppColors.whiteColor ,
                                    border: Border.all(
                                        color: AppColors.whiteColor,
                                        width: 0.5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.shadowColor.withOpacity(0.1) ,
                                          blurRadius: AppConstants.blur_10 )
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: state.UserImageUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) => Center(
                                                child:
                                                    const CupertinoActivityIndicator()),
                                            imageUrl: '${AppUrls.baseFileUrl}${state.UserImageUrl}',
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
                                15.width,
                                state.UserCompanyLogoUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .borderColor
                                                            .withOpacity(0.5),
                                                        width: 1),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: AppColors.shadowColor.withOpacity(0.15),
                                                          blurRadius: AppConstants.blur_10)
                                                    ]),
                                                alignment: Alignment.center,
                                                child: Container(
                                                    height: 50,
                                                    width: getScreenWidth(context) * 0.35,
                                                    alignment: Alignment.center,
                                                    child: const CupertinoActivityIndicator())),
                                        imageUrl:
                                            '${AppUrls.baseFileUrl}${state.UserCompanyLogoUrl}',
                                        height: 50,
                                        width: getScreenWidth(context) * 0.35,
                                        fit: BoxFit.fitHeight,
                                        alignment: context.rtl
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: AppColors
                                                          .shadowColor
                                                          .withOpacity(0.15),
                                                      blurRadius:
                                                          AppConstants.blur_10)
                                                ]),
                                            alignment: Alignment.center,
                                          );
                                        },
                                      )
                                    : SizedBox(),
                              ],
                            ),
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
                                                        .messageIdListString] ?? ''));
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
                                                    gradient: AppColors.appMainGradientColor,
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
                                InkWell(
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.height,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            10.height,
                            //dashboard stats
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
                                              MainAxisAlignment.start,
                                         // mainAxisSize: MainAxisSize.min,
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
                                                pendingBalance: ( state.balance.toString()),
                                                expense: state.expensePercentage.round(),
                                                totalBalance: 100),
                                            6.height,
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                '${AppLocalizations.of(context)!.currency}${state.balance.toString()}',
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
                                                    context: context,
                                                    image: AppImagePath.credits,
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .total_credit,
                                                    value:
                                                        '${AppLocalizations.of(context)!.currency}${state.totalCredit.toString()}'),
                                              ),
                                              10.width,
                                              Flexible(
                                                child: DashBoardStatsWidget(
                                                    context: context,
                                                    image: AppImagePath.expense,
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .this_months_expenses,
                                                    value:
                                                        '${AppLocalizations.of(context)!.currency}${state.thisMonthExpense.toString()}'),
                                              ),
                                            ],
                                          ),
                                          10.height,
                                          Row(
                                            children: [
                                              Flexible(
                                                child: DashBoardStatsWidget(
                                                    context: context,
                                                    image: AppImagePath.orders,
                                                    title: AppLocalizations.of(
                                                        context)!
                                                        .this_months_orders,
                                                    value:
                                                    '${state.orderThisMonth}'),
                                              ),
                                              10.width,
                                              Flexible(
                                                child: DashBoardStatsWidget(
                                                    context: context,
                                                    image: AppImagePath.expense,
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .last_months_expenses,
                                                    value:
                                                        '${AppLocalizations.of(context)!.currency}${state.lastMonthExpense.toString()}'),
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
                    /*        state.isProductSaleShimmering
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        buildListTitles(),
                                        buildListItems(context, height: 170),
                                        13.height,
                                      ])
                                :*/ 
                           /* state.productSalesList.isEmpty
                                    ? 0.width
                                    : Column  (
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          titleRowWidget(
                                              context: context,
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .sales,
                                              allContentTitle: state
                                                          .productSalesList
                                                          .length <
                                                      6 ? '' : AppLocalizations.of(context)!.all_sales,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    RouteDefine
                                                        .productSaleScreen
                                                        .name);
                                              }),
                                          SizedBox(
                                            height: 190,
                                            child: ListView.builder(
                                                itemCount: state
                                                            .productSalesList
                                                            .length < 6 ? state.productSalesList.length: 6,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (context, index) =>
                                                        DelayedWidget(
                                                          delay: Duration(milliseconds: 300 + (index * 30)),
                                                          slidingCurve: Curves.decelerate,
                                                          slidingBeginOffset: Offset(0, 20),
                                                          child:
                                                              CommonProductSaleItemWidget(
                                                                productName: state.productSalesList[index].productName??'',
                                                                  width: 140,
                                                                  height: 170,
                                                                  saleImage: state.productSalesList[index].mainImage ?? '',
                                                                  title: state.productSalesList[index].salesName ?? '',
                                                                  description:
                                                                      state.productSalesList[index].salesDescription ?? '',
                                                                  salePercentage: double.parse(state.productSalesList[index].discountPercentage ?? '0.0'),
                                                                  onButtonTap: () {
                                                                    showProductDetails(
                                                                        context: context,
                                                                        productId: state.productSalesList[index].id ?? '');
                                                                  }, discountedPrice: 0,),
                                                        )
                                                ),
                                          ),
                                          10.height,
                                        ],
                                      ),*/


                            AnimatedCrossFade(
                                firstChild:
                                getScreenWidth(context).width,
                                secondChild: Column(
                                  children: [
                                    buildListTitles(
                                        context: context,
                                        title: AppLocalizations.of(
                                            context)!
                                            .recommended_for_you,
                                        subTitle: /*state
                                              .recommendedProductsList
                                              .length <
                                              6
                                              ? ''
                                              : */
                                        AppLocalizations.of(
                                            context)!
                                            .more,
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              RouteDefine
                                                  .recommendationProductsScreen
                                                  .name);
                                        }),
                                    SizedBox(
                                      width: getScreenWidth(context),
                                      height: 170,
                                      child: ListView.builder(
                                          itemCount: state
                                              .recommendedProductsList
                                              .length,
                                          shrinkWrap: true,
                                          scrollDirection:
                                          Axis.horizontal,
                                          padding:
                                          EdgeInsets.symmetric(
                                              horizontal:
                                              AppConstants
                                                  .padding_5),
                                          itemBuilder: (context,
                                              index) =>
                                              CommonProductItemWidget(
                                                productStock: state
                                                    .recommendedProductsList[
                                                index]
                                                    .productStock ??
                                                    0,
                                                height: 150,
                                                width: 140,
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
                                                  print("tap 2");
                                                  showProductDetails(
                                                      context:
                                                      context,
                                                      productId: state
                                                          .recommendedProductsList[
                                                      index]
                                                          .id ??
                                                          '');
                                                },
                                              )
                                        // buildRecommendationAndPreviousOrderProductsListItem(
                                        //   context: context,
                                        //   productImage: state
                                        //       .recommendedProductsList[
                                        //   index]
                                        //       .mainImage ??
                                        //       '',
                                        //   productName: state
                                        //       .recommendedProductsList[
                                        //   index]
                                        //       .productName ??
                                        //       '',
                                        //   totalSale: state
                                        //       .recommendedProductsList[
                                        //   index]
                                        //       .totalSale ??
                                        //       0,
                                        //   price: state
                                        //       .recommendedProductsList[
                                        //   index]
                                        //       .productPrice
                                        //       ?.toDouble() ??
                                        //       0.0,
                                        //   onButtonTap: () {
                                        //     showProductDetails(
                                        //         context: context,
                                        //         productId: state
                                        //             .recommendedProductsList[
                                        //         index]
                                        //             .id ??
                                        //             '');
                                        //   },
                                        // )
                                      ),
                                    ),
                                  ],
                                ),
                                crossFadeState: state
                                    .recommendedProductsList
                                    .isEmpty
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                duration:
                                Duration(milliseconds: 300)),
                            
                            
                            state.cartCount == 0 ?  CustomTextIconButtonWidget(
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
                                ? Padding(
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
                                  )
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
                          ],
                        ),
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

/*
  Widget buildListTitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextFieldTitle(),
          buildTextFieldTitle(),
        ],
      ),
    );
  }
*/

  Padding buildListTitles({required BuildContext context,
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
          Text(
            title,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.blackColor),
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
        // child: ListView.builder(
        //   itemCount: 6,
        //   shrinkWrap: true,
        //   scrollDirection: Axis.horizontal,
        //   padding:
        //       EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
        //   itemBuilder: (context, index) {
        //     return buildCategoryListItem();
        //   },
        // ),
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

  void showProductDetails({required BuildContext context,
    required String productId,}) async {
    context.read<HomeBloc>().add(HomeEvent.getProductDetailsEvent(
        context: context, productId: productId,));
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
        return BlocProvider.value(
          value: context.read<HomeBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding
                    .top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: AppConstants.bottomSheetInitHeight,
            //shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<HomeBloc>(),
                  child: BlocBuilder<HomeBloc, HomeState>(
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
                                AppLocalizations.of(context)!.no_data,
                                style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.normalFont,
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.w500,
                                )),
                          )
                              : CommonProductDetailsWidget(
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
                            isNoteOpen: state
                                .productStockList[
                            state.productStockUpdateIndex]
                                .isNoteOpen,
                            onNoteToggleChanged: () {
                              context.read<HomeBloc>().add(
                                  HomeEvent.toggleNoteEvent(
                                      ));
                            },
                            supplierWidget: state
                                .productSupplierList.isEmpty
                                ? Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: AppColors
                                              .borderColor
                                              .withOpacity(0.5),
                                          width: 1))),
                              padding:
                              const EdgeInsets.symmetric(
                                  vertical: AppConstants
                                      .padding_30),
                              alignment: Alignment.center,
                              child: Text(
                                '${AppLocalizations.of(context)!.out_of_stock}',
                                style: AppStyles
                                    .rkRegularTextStyle(
                                    size: AppConstants
                                        .smallFont,
                                    color:
                                    AppColors.redColor),
                              ),
                            )
                                : buildSupplierSelection(
                                context: context),
                            productStock: state
                                .productStockList[
                            state.productStockUpdateIndex]
                                .stock,
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
                              context.read<HomeBloc>().add(HomeEvent
                                  .increaseQuantityOfProduct(
                                  context: context1));
                            },
                            onQuantityDecreaseTap: () {
                              context.read<HomeBloc>().add(HomeEvent
                                  .decreaseQuantityOfProduct(
                                  context: context1));
                            },
                            noteController: state.noteController,
                            // TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note)..selection = TextSelection.fromPosition(TextPosition(offset: state.productStockList[state.productStockUpdateIndex].note.length)),
                            onNoteChanged: (newNote) {
                              context.read<HomeBloc>().add(
                                  HomeEvent.changeNoteOfProduct(
                                      newNote: newNote));
                            },
                            // isLoading: state.isLoading,
                            /*onAddToOrderPressed: state.isLoading
                                  ? null
                                  : () {
                                context.read<HomeBloc>().add(
                                    HomeEvent.addToCartProductEvent(
                                        context: context1));
                              }*/
                          ),
                          bottomNavigationBar: state.isProductLoading
                              ? 0.height
                              : CommonProductDetailsButton(
                              isLoading: state.isLoading,
                              isSupplierAvailable:
                              state.productSupplierList.isEmpty
                                  ? false
                                  : true,
                              productStock: state
                                  .productStockList[
                              state.productStockUpdateIndex]
                                  .stock,
                              onAddToOrderPressed: state.isLoading
                                  ? null
                                  : () {
                                context.read<HomeBloc>().add(
                                    HomeEvent.addToCartProductEvent(
                                        context: context1));
                              }),
                        ),
                      );
                    },
                  ));
            },
          ),
        );
      },
    );
  }



/*  void showProductDetails(
      {required BuildContext context, required String productId}) async {
    context.read<HomeBloc>().add(HomeEvent.getProductDetailsEvent(
        context: context, productId: productId));
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
        return BlocProvider.value(
          value: context.read<HomeBloc>(),
          child: DraggableScrollableSheet(
            expand: false,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: AppConstants.bottomSheetInitHeight,
            //shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<HomeBloc>(),
                  child: BlocBuilder<HomeBloc, HomeState>(
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
                          backgroundColor: AppColors.whiteColor,
                          body: state.isProductLoading
                              ? ProductDetailsShimmerWidget()
                              : CommonProductDetailsWidget(
                              context: context,

                                  productImageIndex: state.imageIndex,
                              onPageChanged: (index, p1) {
                                    context.read<HomeBloc>().add(
                                        HomeEvent.updateImageIndexEvent(
                                            index: index));
                                  },
                                  productImages: [
                                    state.productDetails.first.mainImage ?? '',
                                    ...state.productDetails.first.images?.map(
                                            (image) => image.imageUrl ?? '') ??
                                        []
                                  ],
                                  productPerUnit:
                                      state.productDetails.first.numberOfUnit ??
                                          0,
                                  productUnitPrice: state
                                      .productStockList[
                                          state.productStockUpdateIndex]
                                      .totalPrice,
                                  productName:
                                      state.productDetails.first.productName ??
                                          '',
                                  productCompanyName:
                                      state.productDetails.first.brandName ??
                                          '',
                                  productDescription: state.productDetails.first
                                          .productDescription ??
                                      '',
                                  productSaleDescription: state.productDetails
                                          .first.productDescription ??
                                      '',
                                  productPrice: state
                                          .productStockList[state.productStockUpdateIndex]
                                          .totalPrice *
                                      state.productStockList[state.productStockUpdateIndex].quantity *
                                      (state.productDetails.first.numberOfUnit ?? 0),
                                  productScaleType: state.productDetails.first.scales?.scaleType ?? '',
                                  productWeight: state.productDetails.first.itemsWeight?.toDouble() ?? 0.0,
                                  isNoteOpen: state.productStockList[state.productStockUpdateIndex].isNoteOpen,
                                  onNoteToggleChanged: () {
                                    context
                                        .read<HomeBloc>()
                                        .add(HomeEvent.toggleNoteEvent());
                                  },
                                  supplierWidget: state.productSupplierList.isEmpty
                                  ? Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: AppColors
                                                .borderColor
                                                .withOpacity(0.5),
                                            width: 1))),
                                padding: const EdgeInsets.symmetric(
                                    vertical:
                                    AppConstants.padding_30),
                                alignment: Alignment.center,
                                child: Text(
                                  '${AppLocalizations.of(context)!.suppliers_not_available}',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor),
                                ),
                              )
                                  : buildSupplierSelection(context: context),
                              productStock: state.productStockList[state.productStockUpdateIndex].stock,
                              isRTL: context.rtl,
                              isSupplierAvailable: state.productSupplierList.isEmpty ? false : true,
                              scrollController: scrollController,
                              productQuantity: state.productStockList[state.productStockUpdateIndex].quantity,
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
                                  noteController: state.noteController,
                                  // TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note)..selection = TextSelection.fromPosition(TextPosition(offset: state.productStockList[state.productStockUpdateIndex].note.length)),
                                  onNoteChanged: (newNote) {
                                    context.read<HomeBloc>().add(
                                        HomeEvent.changeNoteOfProduct(
                                            newNote: newNote));
                                  },
                                  // isLoading: state.isLoading,
                                  *//*onAddToOrderPressed: state.isLoading
                                  ? null
                                  : () {
                                context.read<HomeBloc>().add(
                                    HomeEvent.addToCartProductEvent(
                                        context: context));
                              }*//*
                                ),
                          bottomNavigationBar: state.isProductLoading
                              ? 0.height
                              : CommonProductDetailsButton(
                                  isLoading: state.isLoading,
                                  isSupplierAvailable:
                                      state.productSupplierList.isEmpty
                                          ? false
                                          : true,
                                  productStock: state
                                      .productStockList[
                                          state.productStockUpdateIndex]
                                      .stock,
                                  onAddToOrderPressed: state.isLoading
                                      ? null
                                      : () {
                                          context.read<HomeBloc>().add(
                                              HomeEvent.addToCartProductEvent(
                                                  context: context));
                                        }),
                        ),
                      );
                    },
                  ));
            },
          ),
        );
      },
    );
  }*/

  // Widget dashboardStatsWidget(
  //     {required BuildContext context,
  //     required String image,
  //     required String title,
  //     required String value}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: const BorderRadius.all(Radius.circular(5.0)),
  //         color: AppColors.iconBGColor),
  //     padding: const EdgeInsets.symmetric(
  //         horizontal: AppConstants.padding_10,
  //         vertical: AppConstants.padding_10),
  //     child: Row(
  //       children: [
  //         Transform(
  //             alignment: Alignment.center,
  //             transform: Matrix4.rotationY(context.rtl ? pi : 0),
  //             child: SvgPicture.asset(image)),
  //         10.width,
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 title,
  //                 style: AppStyles.rkRegularTextStyle(
  //                     size: AppConstants.font_10, color: AppColors.mainColor),
  //                 maxLines: 2,
  //                 overflow: TextOverflow.clip,
  //               ),
  //               Text(
  //                 value,
  //                 style: AppStyles.rkRegularTextStyle(
  //                     size: AppConstants.smallFont,
  //                     fontWeight: FontWeight.bold,
  //                     color: AppColors.blackColor),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget messageListItem({
    required BuildContext context,
    required String title,
    required String content,
    required String dateTime,
    required void Function() onTap,
  }) {
    return Container(
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
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        AppLocalizations.of(context)!.read_more,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_12,
                            color: AppColors.mainColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
                        child: Row(
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
                        ),
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
                                '${state.productSupplierList
                                    .firstWhere((supplier) =>
                                supplier.selectedIndex != -1)
                                    .companyName}',
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
                                        '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit} : ${AppLocalizations
                                            .of(context)!.currency}${state.productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex == -2)
                                            .basePrice
                                            .toStringAsFixed(AppConstants
                                            .amountFrLength)}',
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
                                        '${state.productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index].saleName}',
                                        style: AppStyles
                                            .rkRegularTextStyle(
                                            size: AppConstants
                                                .font_12,
                                            color: AppColors
                                                .saleRedColor),
                                      ),
                                      2.height,
                                      Text(
                                        '${AppLocalizations.of(context)?.price} ${AppLocalizations.of(context)?.per_unit} : ${AppLocalizations
                                            .of(context)!.currency}${state.productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index].salePrice
                                            .toStringAsFixed(AppConstants
                                            .amountFrLength)}(${state
                                            .productSupplierList
                                            .firstWhere((supplier) =>
                                        supplier.selectedIndex >= 0)
                                            .supplierSales[index].saleDiscount
                                            .toStringAsFixed(0)}%)',
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
                                    '${state.productSupplierList[index]
                                        .companyName}',
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
                                                  '${AppLocalizations.of(context)!.price} : ${AppLocalizations
                                                      .of(context)!.currency}${state
                                                      .productSupplierList[index]
                                                      .basePrice
                                                      .toStringAsFixed(
                                                      AppConstants
                                                          .amountFrLength)}',
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
                                                    color: state
                                                        .productSupplierList[index]
                                                        .selectedIndex ==
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
                                                  '${state
                                                      .productSupplierList[index]
                                                      .supplierSales[subIndex]
                                                      .saleName}',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                      size: AppConstants
                                                          .font_12,
                                                      color: AppColors
                                                          .saleRedColor),
                                                ),
                                                2.height,
                                                Text(
                                                  '${AppLocalizations.of(context)!.price} : ${state
                                                      .productSupplierList[index]
                                                      .supplierSales[subIndex]
                                                      .salePrice
                                                      .toStringAsFixed(
                                                      AppConstants
                                                          .amountFrLength)}${AppLocalizations
                                                      .of(context)!
                                                      .currency}(${state
                                                      .productSupplierList[index]
                                                      .supplierSales[subIndex]
                                                      .saleDiscount
                                                      .toStringAsFixed(0)}%)',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
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
                                                          '${state
                                                              .productSupplierList[index]
                                                              .supplierSales[subIndex]
                                                              .saleDescription}');
                                                    },
                                                    child: Text(
                                                      '${AppLocalizations.of(context)!.read_condition}',
                                                      style: AppStyles
                                                          .rkRegularTextStyle(
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
}
