import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:food_stock/bloc/home/home_bloc.dart';
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
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_product_button_widget.dart';

class HomeRoute {
  static Widget get route => const HomeScreen();
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(HomeEvent.getPreferencesDataEvent())
        ..add(HomeEvent.getProductSalesListEvent(context: context)),
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
      listener: (context, state) {},
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.pageColor,
            body: FocusDetector(
              onFocusGained: () =>
                  bloc.add(HomeEvent.getPreferencesDataEvent()),
              child: SafeArea(
                child: Column(
                  children: [
                    //appbar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.padding_10,
                          horizontal: AppConstants.padding_10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<BottomNavBloc>()
                                  .add(BottomNavEvent.changePage(index: 0));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: state.UserImageUrl.isNotEmpty
                                        ? AppColors.whiteColor
                                        : AppColors.mainColor.withOpacity(0.1),
                                    boxShadow: [
                                      BoxShadow(
                                          color: state.UserImageUrl.isNotEmpty
                                              ? AppColors.shadowColor
                                                  .withOpacity(0.3)
                                              : AppColors.whiteColor,
                                          blurRadius:
                                              state.UserImageUrl.isNotEmpty
                                                  ? AppConstants.blur_10
                                                  : 0)
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
                                      : Icon(
                                          Icons.person,
                                          size: 40,
                                          color: AppColors.textColor,
                                        ),
                                ),
                                15.width,
                                state.UserCompanyLogoUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        placeholder: (context, url) => Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                border: Border.all(
                                                    color: AppColors.borderColor
                                                        .withOpacity(0.5),
                                                    width: 1)),
                                            alignment: Alignment.center,
                                            child: Container(
                                                height: 50,
                                                width: getScreenWidth(context) *
                                                    0.35,
                                                alignment: Alignment.center,
                                                child:
                                                    const CupertinoActivityIndicator())),
                                        imageUrl:
                                            '${AppUrls.baseFileUrl}${state.UserCompanyLogoUrl}',
                                        height: 50,
                                        width: getScreenWidth(context) * 0.35,
                                        fit: BoxFit.fitHeight,
                                        alignment:
                                            isRTLContent(context: context)
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                border: Border.all(
                                                    color: AppColors.borderColor
                                                        .withOpacity(0.5),
                                                    width: 1)),
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
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          RouteDefine.messageScreen.name);
                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        SvgPicture.asset(
                                          AppImagePath.message,
                                          height: 26,
                                          width: 24,
                                          fit: BoxFit.scaleDown,
                                        ),
                                        Positioned(
                                            right: 7,
                                            top: 8,
                                            child: Container(
                                              height: 16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .notificationColor,
                                                  border: Border.all(
                                                      color:
                                                          AppColors.whiteColor,
                                                      width: 1),
                                                  shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: Text('4',
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
                                    .add(BottomNavEvent.changePage(index: 1));
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
                                            SizedBox(
                                              height: 70,
                                              width: 70,
                                              child: SfRadialGauge(
                                                backgroundColor:
                                                    Colors.transparent,
                                                axes: [
                                                  RadialAxis(
                                                    minimum: 0,
                                                    maximum: 10000,
                                                    showLabels: false,
                                                    showTicks: false,
                                                    startAngle: 270,
                                                    endAngle: 270,
                                                    // radiusFactor: 0.8,
                                                    axisLineStyle:
                                                        AxisLineStyle(
                                                            thicknessUnit:
                                                                GaugeSizeUnit
                                                                    .factor,
                                                            thickness: 0.2,
                                                            color: AppColors
                                                                .borderColor),
                                                    annotations: [
                                                      GaugeAnnotation(
                                                        angle: 270,
                                                        widget: Text(
                                                          '7550\n${AppLocalizations.of(context)!.currency}',
                                                          style: AppStyles
                                                              .rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .font_14,
                                                                  color: AppColors
                                                                      .blackColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                    pointers: [
                                                      RangePointer(
                                                        color:
                                                            AppColors.mainColor,
                                                        enableAnimation: true,
                                                        animationDuration: 300,
                                                        animationType:
                                                            AnimationType.ease,
                                                        cornerStyle: CornerStyle
                                                            .bothCurve,
                                                        value: 7550,
                                                        width: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ],
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
                                                child: dashboardStatsWidget(
                                                    context: context,
                                                    image: AppImagePath.credits,
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .total_credit,
                                                    value:
                                                        '20,000${AppLocalizations.of(context)!.currency}'),
                                              ),
                                              10.width,
                                              Flexible(
                                                child: dashboardStatsWidget(
                                                    context: context,
                                                    image: AppImagePath.expense,
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .this_months_expenses,
                                                    value:
                                                        '7,550${AppLocalizations.of(context)!.currency}'),
                                              ),
                                            ],
                                          ),
                                          10.height,
                                          Row(
                                            children: [
                                              Flexible(
                                                child: dashboardStatsWidget(
                                                    context: context,
                                                    image: AppImagePath.expense,
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .last_months_expenses,
                                                    value:
                                                        '18,360${AppLocalizations.of(context)!.currency}'),
                                              ),
                                              10.width,
                                              Flexible(
                                                child: dashboardStatsWidget(
                                                    context: context,
                                                    image: AppImagePath.orders,
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .this_months_orders,
                                                    value: '23'),
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
                            state.isShimmering
                                ? 0.width
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      titleRowWidget(
                                          context: context,
                                          title: AppLocalizations.of(context)!
                                              .sales,
                                          allContentTitle:
                                              AppLocalizations.of(context)!
                                                  .all_sales,
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .productSaleScreen.name);
                                          }),
                                      SizedBox(
                                        height: 190,
                                        child: ListView.builder(
                                            itemCount: (state.productSalesList
                                                            .data?.length ??
                                                        0) <
                                                    6
                                                ? state.productSalesList.data
                                                    ?.length
                                                : 6,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) =>
                                                buildProductSaleListItem(
                                                  context: context,
                                                  saleImage: state
                                                          .productSalesList
                                                          .data?[index]
                                                          .mainImage ??
                                                      '',
                                                  title: state
                                                          .productSalesList
                                                          .data?[index]
                                                          .salesName ??
                                                      '',
                                                  description: state
                                                          .productSalesList
                                                          .data?[index]
                                                          .salesDescription ??
                                                      '',
                                                  price: state
                                                          .productSalesList
                                                          .data?[index]
                                                          .discountPercentage
                                                          ?.toDouble() ??
                                                      0.0,
                                                  onButtonTap: () {
                                                    showProductDetails(
                                                        context: context,
                                                        productId: state
                                                                .productSalesList
                                                                .data?[index]
                                                                .id ??
                                                            '');
                                                  },
                                                )),
                                      ),
                                      10.height,
                                    ],
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: CustomTextIconButtonWidget(
                                    title:
                                        AppLocalizations.of(context)!.new_order,
                                    onPressed: () {
                                      context.read<BottomNavBloc>().add(
                                          BottomNavEvent.changePage(index: 3));
                                    },
                                    svgImage: AppImagePath.add,
                                  ),
                                ),
                                Flexible(
                                  child: CustomTextIconButtonWidget(
                                    title:
                                        AppLocalizations.of(context)!.my_basket,
                                    onPressed: () {
                                      context.read<BottomNavBloc>().add(
                                          BottomNavEvent.changePage(index: 2));
                                    },
                                    svgImage: AppImagePath.cart,
                                    cartCount: state.cartCount,
                                  ),
                                ),
                              ],
                            ),
                            30.height,
                            titleRowWidget(
                                context: context,
                                title: AppLocalizations.of(context)!.messages,
                                allContentTitle:
                                    AppLocalizations.of(context)!.all_messages,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteDefine.messageScreen.name);
                                }),
                            10.height,
                            ListView.builder(
                              itemCount: 2,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => messageListItem(
                                  index: index, context: context),
                            ),
                            85.height,
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

  Widget buildProductSaleListItem({
    required BuildContext context,
    required String saleImage,
    required String title,
    required String description,
    required double price,
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              "${AppUrls.baseFileUrl}$saleImage",
              height: 70,
              fit: BoxFit.fitHeight,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress?.cumulativeBytesLoaded !=
                    loadingProgress?.expectedTotalBytes) {
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
                }
                return child;
              },
              errorBuilder: (context, error, stackTrace) {
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
              description,
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
                  "${price.toStringAsFixed(0)}${AppLocalizations.of(context)!.currency}",
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
    );
  }

  void showProductDetails(
      {required BuildContext context, required String productId}) async {
    context.read<HomeBloc>().add(HomeEvent.getProductDetailsEvent(
        context: context, productId: productId));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      // showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<HomeBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: 0.7,
            shouldCloseOnMinExtent: true,
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
                              : CommonProductDetailsWidget(
                                  context: context,
                                  productImage:
                                      state.productDetails.first.mainImage ??
                                          '',
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
                                          .productDetails.first.numberOfUnit
                                          ?.toDouble() ??
                                      0.0,
                                  productScaleType:
                                      state.productDetails.first.scales?.scaleType ??
                                          '',
                                  productWeight:
                                      state.productDetails.first.itemsWeight?.toDouble() ??
                                          0.0,
                                  supplierWidget: 0.width,
                                  productStock: state
                                      .productStockList[state.productStockUpdateIndex]
                                      .stock,
                                  isRTL: isRTLContent(context: context),
                                  scrollController: scrollController,
                                  productQuantity: state.productStockList[state.productStockUpdateIndex].quantity,
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
                                  noteController: TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note),
                                  onNoteChanged: (newNote) {
                                    context.read<HomeBloc>().add(
                                        HomeEvent.changeNoteOfProduct(
                                            newNote: newNote));
                                  },
                                  isLoading: state.isLoading,
                                  onAddToOrderPressed: state.isLoading
                                      ? null
                                      : () {
                                          context.read<HomeBloc>().add(
                                              HomeEvent.verifyProductStockEvent(
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

  Widget dashboardStatsWidget(
      {required BuildContext context,
      required String image,
      required String title,
      required String value}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color: AppColors.iconBGColor),
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_10),
      child: Row(
        children: [
          SvgPicture.asset(image),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_10, color: AppColors.mainColor),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  value,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messageListItem({required int index, required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppImagePath.message,
            fit: BoxFit.scaleDown,
            height: 16,
            width: 16,
            colorFilter:
                ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn),
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'כותרת של ההודעה',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_12,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500),
                ),
                5.height,
                Text(
                  'גולר מונפרר סוברט לורם שבצק יהול, לכנוץ בעריר גק ליץ, ושבעגט ליבם סולגק. בראיט ולחת צורק מונחף, בגורמי מגמש. תרבנך וסתעד לכנו סתשם השמה - לתכי מורגם בורק? לתיג ישבעס.',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_10, color: AppColors.blackColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '15.02.2023',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_12,
                          color: AppColors.blackColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteDefine.messageContentScreen.name,
                            arguments: {
                              AppStrings.messageContentString: index
                            });
                      },
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
}
