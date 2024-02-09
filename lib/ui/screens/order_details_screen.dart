import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/order_details/order_details_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/circular_button_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class OrderDetailsRoute {
  static Widget get route => OrderDetailsScreen();
}

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => OrderDetailsBloc()
        ..add(OrderDetailsEvent.getOrderByIdEvent(
            context: context, orderId: args?[AppStrings.orderIdString] ?? '')),
      child: OrderDetailsScreenWidget(
        orderId: args?[AppStrings.orderIdString] ?? '',
        orderNumber: args?[AppStrings.orderNumberString] ?? '',
      ),
    );
  }
}

class OrderDetailsScreenWidget extends StatelessWidget {
  final String orderId;
  final String orderNumber;

   OrderDetailsScreenWidget(
      {required this.orderId, required this.orderNumber});
  int onTheWayStatus = 6;
  int deliveryStatus = 5;
  @override
  Widget build(BuildContext context) {
  /*  OrderDetailsBloc bloc = context.read<OrderDetailsBloc>();*/
    return BlocListener<OrderDetailsBloc, OrderDetailsState>(
      listener: (context, state) {},
      child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
          print('BUILD');
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: orderNumber.toString(),
                iconData: Icons.arrow_back_ios_sharp,
                trailingWidget: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding_10,
                  ),
                  child:
                      (state.orderByIdList.data?.ordersBySupplier?.length ??
                                  0) ==
                              0
                          ? SizedBox()
                          : CircularButtonWidget(
                              buttonName: AppLocalizations.of(context)!.total,
                              buttonValue:
                              '${formatNumber(value: state.orderByIdList.data!.orderData!.first.totalAmount?.toStringAsFixed(2) ?? '0',local: AppStrings.hebrewLocal)}',
                            ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: FocusDetector(
                onFocusGained: () {
                },
                child: (state.orderByIdList.data?.ordersBySupplier?.length ??
                            0) ==
                        0
                    ? OrderSummaryScreenShimmerWidget()
                    : AnimationLimiter(
                      child: ListView.builder(
                          itemCount: state.orderByIdList.data?.ordersBySupplier?.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              vertical: AppConstants.padding_5),
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredList(
                                  duration: const Duration(seconds: 1),
                                  position: index,
                                  child: SlideAnimation(child: orderListItem(index: index, context: context, orderByIdList : state.orderByIdList))),
                        ),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget orderListItem({required int index, required BuildContext context, required GetOrderByIdModel orderByIdList}) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context,   PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(orderNumber: orderNumber,orderId: orderId,isNavigateToProductDetailString: false,
              productData: orderByIdList.data!.ordersBySupplier![index],
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.bounceIn;
            var tween = Tween(begin: begin, end: end,).chain(CurveTween(curve: curve));
            return SlideTransition(
            position: animation.drive(tween),
            child: child,
            );
            },
            ));

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
                      orderByIdList.data!.ordersBySupplier![index]
                          .supplierName!
                          .toString(),
                      style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_14,
                        color: AppColors.blackColor,
                      ),
                    ),
                    Text(
                     orderByIdList.data!.ordersBySupplier![index]
                          .deliverStatus!.statusName!
                          .toTitleCase(),
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                           color: orderByIdList.data!.ordersBySupplier![index]
                               .deliverStatus?.orderStatusNumber == onTheWayStatus
                      ? AppColors.blueColor
                          : orderByIdList.data!.ordersBySupplier![index]
                               .deliverStatus?.orderStatusNumber ==
                               deliveryStatus
                      ? AppColors.mainColor
                          : AppColors.orangeColor,

                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                7.height,
                Row(
                  children: [
                    CommonOrderContentWidget(
                      backGroundColor: AppColors.iconBGColor,
                      borderCoder: AppColors.lightBorderColor,
                      flexValue: 1,
                      title: AppLocalizations.of(context)!.products,
                      value: orderByIdList.data!.ordersBySupplier![index]
                          .products!.length
                          .toString(),
                      titleColor: AppColors.mainColor,
                      valueColor: AppColors.blackColor,
                      valueTextWeight: FontWeight.w700,
                      valueTextSize: AppConstants.smallFont,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      backGroundColor: AppColors.iconBGColor,
                      borderCoder: AppColors.lightBorderColor,
                      flexValue: 4,
                      title: AppLocalizations.of(context)!.delivery_date,
                      value: orderByIdList.data!.ordersBySupplier![index]
                                  .orderDeliveryDate !=
                              ''
                          ? '${orderByIdList.data!.ordersBySupplier![index].orderDeliveryDate.toString()}'
                          : '-',
                      titleColor: AppColors.mainColor,
                      valueColor: AppColors.blackColor,
                      valueTextSize: AppConstants.smallFont,
                      valueTextWeight: FontWeight.w500,
                     // columnPadding: AppConstants.padding_8,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      backGroundColor: AppColors.iconBGColor,
                      borderCoder: AppColors.lightBorderColor,
                      flexValue: 4,
                      title: AppLocalizations.of(context)!.total_order,
                      value: '${formatNumber(value: orderByIdList.data!.ordersBySupplier![index].totalPayment?.toStringAsFixed(2) ?? '0',local: AppStrings.hebrewLocal)}',
                      titleColor: AppColors.mainColor,
                      valueColor: AppColors.blackColor,
                      valueTextWeight: FontWeight.w500,
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



