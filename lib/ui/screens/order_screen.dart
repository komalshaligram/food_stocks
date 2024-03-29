import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_stock/bloc/order/order_bloc.dart';
import 'package:food_stock/data/model/res_model/get_all_order_res_model/get_all_order_res_model.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/widget/common_order_content_widget.dart';

import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class OrderRoute {
  static Widget get route => const OrderScreen();
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderBloc()..add(OrderEvent.getAllOrderEvent(context: context)),
      child: OrderScreenWidget(),
    );
  }
}

class OrderScreenWidget extends StatefulWidget {
  const OrderScreenWidget({super.key});

  @override
  State<OrderScreenWidget> createState() => _OrderScreenWidgetState();
}

class _OrderScreenWidgetState extends State<OrderScreenWidget> {


  int onTheWayStatus = 6;
  int deliveryStatus = 5;
  int cancelStatus = 4;
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.orders,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child:
                SmartRefresher(
              enablePullDown: true,
              controller: state.refreshController,
              header: RefreshWidget(),
              footer: CustomFooter(
                  builder: (context, mode) => OrderSummaryScreenShimmerWidget(
                        itemCount: 2,
                      )),
              enablePullUp: !state.isBottomOfProducts,
              onRefresh: () {
                context
                    .read<OrderBloc>()
                    .add(OrderEvent.refreshListEvent(context: context));
              },
              onLoading: () {
                context
                    .read<OrderBloc>()
                    .add(OrderEvent.getAllOrderEvent(context: context));
              },
              child: SingleChildScrollView(
                physics: state.orderDetailsList.isEmpty
                    ? const NeverScrollableScrollPhysics()
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    state.isShimmering
                        ? OrderSummaryScreenShimmerWidget(
                            itemCount: 10,
                          )
                        : (state.orderDetailsList.length) != 0
                            ?
                    AnimationLimiter(
                              child: ListView.builder(
                                  itemCount: state.orderDetailsList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      AnimationConfiguration.staggeredList(
                                        duration: const Duration(seconds: 1),
                                        position: index,
                                        child: SlideAnimation(
                                          verticalOffset: 44.0,
                                          child: FadeInAnimation(
                                            child: orderListItem(
                                                index: index, context: context,orderDetailsList : state.orderDetailsList),
                                          ),
                                        ),
                                      ),
                                ),
                            )
                            : SizedBox(
                                height: getScreenHeight(context) * 0.8,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.no_data,
                                  style: AppStyles.pVRegularTextStyle(
                                      size: AppConstants.normalFont,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w400),
                                )),
                              ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget orderListItem({required int index, required BuildContext context, required List<Datum> orderDetailsList}) {
        return GestureDetector(
          onTap: () async {
            SharedPreferencesHelper preferencesHelper =
            SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
            preferencesHelper.setOrderId(productOrderId:  orderDetailsList[index].id ?? '');
            if(orderDetailsList[index].status?.orderStatusNo == cancelStatus){
            }
           else if ((orderDetailsList[index].suppliers ?? 0) > 1) {
              Navigator.pushNamed(
                  context, RouteDefine.orderDetailsScreen.name,
                  arguments: {
                    AppStrings.orderIdString:
                        orderDetailsList[index].id,
                    AppStrings.orderNumberString:
                        orderDetailsList[index].orderNumber,
                  });
            } else {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ProductDetailsScreen(
                      orderNumber:
                          orderDetailsList[index].orderNumber ?? '',
                      orderId: orderDetailsList[index].id ?? '',
                      isNavigateToProductDetailString: true,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.bounceIn;
                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ));
            }
          },
          child: Container(
            margin: EdgeInsets.all(AppConstants.padding_10),
            padding: EdgeInsets.symmetric(
                vertical: AppConstants.padding_15,
                horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.15),
                    blurRadius: AppConstants.blur_10),
              ],
              borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderDetailsList[index].orderNumber.toString(),
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.normalFont,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_100)),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_10,
                            vertical: AppConstants.padding_5),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_100)),
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                            orderDetailsList[index].comaxInvoicePrice != '0' ? '${(formatNumber(value: orderDetailsList[index].comaxInvoicePrice.toString(), local: AppStrings.hebrewLocal))}'  :'${(formatNumber(value: orderDetailsList[index].totalAmount.toString(), local: AppStrings.hebrewLocal))}',
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                7.height,
                Row(
                  children: [
                    CommonOrderContentWidget(
                      backGroundColor: AppColors.iconBGColor,
                      borderCoder: AppColors.lightBorderColor,
                      flexValue: 2,
                      title: AppLocalizations.of(context)!.products,
                      value:
                          orderDetailsList[index].products.toString(),
                      titleColor: AppColors.blackColor,
                      valueColor: AppColors.blackColor,
                      valueTextSize: AppConstants.smallFont,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      backGroundColor: AppColors.iconBGColor,
                      borderCoder: AppColors.lightBorderColor,
                      flexValue: 2,
                      title: AppLocalizations.of(context)!.suppliers,
                      value:
                          orderDetailsList[index].suppliers.toString(),
                      titleColor: AppColors.blackColor,
                      valueColor: AppColors.blackColor,
                      valueTextSize: AppConstants.smallFont,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      backGroundColor: AppColors.iconBGColor,
                      borderCoder: AppColors.lightBorderColor,
                      flexValue: 4,
                      title: AppLocalizations.of(context)!.order_date,
                      value: orderDetailsList[index].createdAt
                              ?.replaceRange(11, 16, '').replaceRange(6, 8, '') ??
                          '',
                      titleColor: AppColors.blackColor,
                      valueColor: AppColors.blackColor,
                      valueTextSize: getScreenWidth(context) < 380
                          ? AppConstants.font_14
                          : AppConstants.smallFont,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      backGroundColor: AppColors.iconBGColor,
                      borderCoder: AppColors.lightBorderColor,
                      flexValue: 4,
                      title: AppLocalizations.of(context)!.order_status,
                      value: orderDetailsList[index].status?.statusName
                              ?.toTitleCase() ??
                          '',
                      titleColor: AppColors.blackColor,
                      valueColor: orderDetailsList[index].status?.orderStatusNo == onTheWayStatus
                          ? AppColors.blueColor: orderDetailsList[index].status?.orderStatusNo ==
                          deliveryStatus
                          ? AppColors.mainColor : AppColors.orangeColor,
                      valueTextSize: AppConstants.smallFont,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }
}
