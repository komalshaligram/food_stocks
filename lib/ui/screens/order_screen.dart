import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/order/order_bloc.dart';
import 'package:food_stock/ui/widget/common_order_content_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class OrderRoute {
  static Widget get route => const OrderScreen();
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc()..add(OrderEvent.getAllOrderEvent(context: context)),
      child: OrderScreenWidget(),
    );
  }
}

class OrderScreenWidget extends StatelessWidget {
  const OrderScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {},
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: AppLocalizations.of(context)!.orders,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: state.isShimmering ? OrderSummaryScreenShimmerWidget():(state.orderList.data?.length) != 0
                ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.orderList.data?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    orderListItem(index: index, context: context),
              ) : Expanded(
                child: Center(child: Text('No order',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.normalFont,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w400
                  ),
                )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget orderListItem({required int index, required BuildContext context}) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        return Container(
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
            borderRadius: BorderRadius.all(
                Radius.circular(AppConstants.radius_5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.orderList.data?[index].orderNumber.toString() ?? '',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.normalFont,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteDefine.orderDetailsScreen.name ,
                          arguments: {
                            AppStrings.orderIdString: state.orderList.data?[index].id ,
                            AppStrings.orderNumberString: state.orderList.data?[index].orderNumber,
                          }
                      );
                    },
                    child: Container(
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
                          '${state.orderList.data?[index].totalAmount ?? ''}${AppLocalizations.of(context)!.currency}',
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              7.height,
              Row(
                children: [
                  CommonOrderContentWidget(
                    flexValue: 2,
                    title: AppLocalizations.of(context)!.products,
                    value: state.orderList.data?[index].products.toString() ?? '',
                    titleColor: AppColors.blackColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.smallFont,
                  ),
                  5.width,
                  CommonOrderContentWidget(
                    flexValue: 2,
                    title: AppLocalizations.of(context)!.suppliers,
                    value: state.orderList.data?[index].suppliers.toString() ?? '',
                    titleColor: AppColors.blackColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.smallFont,
                  ),
                  5.width,
                  CommonOrderContentWidget(
                    flexValue: 3,
                    title: AppLocalizations.of(context)!.order_date,
                    value: state.orderList.data?[index].createdAt?.replaceRange(11, 16, '') ?? '',
                    titleColor: AppColors.blackColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.smallFont,
                  ),
                  5.width,
                CommonOrderContentWidget(
                    flexValue: 3,
                    title: AppLocalizations.of(context)!.order_status,
                    value:state.orderList.data?[index].status?.statusName?.toString() ?? '',
                    titleColor: AppColors.blackColor,
                    valueColor:
                    state.orderList.data?[index].status?.statusName == AppLocalizations.of(context)!.pending_delivery ? AppColors.orangeColor : AppColors.mainColor,
                    valueTextSize: AppConstants.smallFont,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
