import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/order_details/order_details_bloc.dart';
import '../../routes/app_routes.dart';
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
      create: (context) =>
          OrderDetailsBloc() /*..add(OrderDetailsEvent.getOrderByIdEvent(context: context,orderId: args?[AppStrings.idString] ?? ''))*/,
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

  const OrderDetailsScreenWidget(
      {required this.orderId, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    OrderDetailsBloc bloc = context.read<OrderDetailsBloc>();
    return BlocListener<OrderDetailsBloc, OrderDetailsState>(
      listener: (context, state) {},
      child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: CommonAppBar(
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
                            ? CupertinoActivityIndicator()
                            : CircularButtonWidget(
                                buttonName: AppLocalizations.of(context)!.total,
                                buttonValue:
                                    '${state.orderByIdList.data!.orderData!.first.totalAmount!.toString()}${AppLocalizations.of(context)!.currency}',
                              ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: FocusDetector(
                onFocusGained: () => bloc.add(
                    OrderDetailsEvent.getOrderByIdEvent(
                        context: context, orderId: orderId)),
                child: (state.orderByIdList.data?.ordersBySupplier?.length ??
                            0) ==
                        0
                    ? OrderSummaryScreenShimmerWidget()
                    : ListView.builder(
                        itemCount:
                            state.orderByIdList.data?.ordersBySupplier?.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            vertical: AppConstants.padding_5),
                        itemBuilder: (context, index) =>
                            orderListItem(index: index, context: context),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget orderListItem({required int index, required BuildContext context}) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteDefine.productDetailsScreen.name,
                arguments: {
                  AppStrings.productIndexString: index,
                  AppStrings.orderIdString: orderId,
                  AppStrings.orderNumberString: orderNumber,
                });
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
                      state.orderByIdList.data!.ordersBySupplier![index]
                          .supplierName!
                          .toString(),
                      style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_14,
                        color: AppColors.blackColor,
                      ),
                    ),
                    Text(
                      state.orderByIdList.data!.ordersBySupplier![index]
                          .deliverStatus!.statusName
                          .toString(),
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: state.orderByIdList.data!.ordersBySupplier![index]
                              .deliverStatus!.statusName == AppLocalizations.of(context)!.pending_delivery ?AppColors.orangeColor :
                              AppColors.mainColor,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                7.height,
                Row(
                  children: [
                    CommonOrderContentWidget(
                      flexValue: 1,
                      title: AppLocalizations.of(context)!.products,
                      value: state.orderByIdList.data!.ordersBySupplier![index]
                          .products!.length
                          .toString(),
                      titleColor: AppColors.mainColor,
                      valueColor: AppColors.blackColor,
                      valueTextWeight: FontWeight.w700,
                      valueTextSize: AppConstants.smallFont,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      flexValue: 2,
                      title: AppLocalizations.of(context)!.delivery_date,
                      value: state.orderByIdList.data!.ordersBySupplier![index]
                          .deliverStatus!.statusName
                          != AppLocalizations.of(context)!.pending_delivery? '${state.orderByIdList.data!.ordersBySupplier![index].orderDeliveryDate.toString().replaceRange(10, 24, '')}' : '-',
                      titleColor: AppColors.mainColor,
                      valueColor: AppColors.blackColor,
                      valueTextSize: AppConstants.font_10,
                      valueTextWeight: FontWeight.w500,
                      columnPadding: AppConstants.padding_8,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      flexValue: 2,
                      title: AppLocalizations.of(context)!.total_order,
                      value:
                          '${state.orderByIdList.data!.ordersBySupplier![index].totalPayment.toString()}${AppLocalizations.of(context)!.currency}',
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
      },
    );
  }
}

/*Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_100)),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
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
                          child: RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.total ,
                             style: TextStyle(
                          color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
                               children: <TextSpan>[
                            TextSpan(text: ' : 12,450₪',
                                style: TextStyle(
                                    color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w700)
                            ),
                            ],
                          ),
                          ),
                        ),
                      )*/
