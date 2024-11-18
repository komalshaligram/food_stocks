import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../bloc/order_summary/order_summary_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class OrderSummaryRoute {
  static Widget get route => const OrderSummaryScreen();
}

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => OrderSummaryBloc()..add(OrderSummaryEvent.getDataEvent(context: context,cartItemList: args?[AppStrings.getCartListString])),
      child: const OrderSummaryScreenWidget(),
    );
  }
}

class OrderSummaryScreenWidget extends StatelessWidget {
  const OrderSummaryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    OrderSummaryBloc bloc = context.read<OrderSummaryBloc>();
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              trailingWidget: Container(
                padding: const EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 2),
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  border: Border.all(color: AppColors.whiteColor,width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 8,right: 8,top: 3,bottom: 3),
                    decoration: BoxDecoration(color: AppColors.greyColor,
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    child: Text('${AppLocalizations.of(context)!.total} :${formatNumber(value:vatCalculation(price: state.orderSummaryList.data?.cart?.first.totalAmount?? 0,vat: state.orderSummaryList.data?.vatPercentage ?? 0).toStringAsFixed(2),local: AppStrings.hebrewLocal)}',
                      style:  TextStyle(
                color:AppColors.whiteColor
                    ),)),
              ),
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.order_summary,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (state.orderSummaryList.data?.data?.length ?? 0) == 0
                    ? const Expanded(child: OrderSummaryScreenShimmerWidget())
                    : Expanded(
                        child: AnimationLimiter(
                          child: ListView.builder(
                            itemCount: state.orderSummaryList.data?.data?.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.padding_5),
                            itemBuilder: (context, index) =>
                                AnimationConfiguration.staggeredList(
                                    duration: const Duration(seconds: 1),
                                    position: index,
                                    child: SlideAnimation(
                                        child: FadeInAnimation(
                                            child: orderListItem(index: index, context: context,bloc:bloc)))),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget orderListItem({required int index, required BuildContext context,required OrderSummaryBloc bloc}) {
   /* OrderSummaryBloc bloc = context.read<OrderSummaryBloc>();*/
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(AppConstants.padding_10),
          padding: const EdgeInsets.symmetric(
              vertical: AppConstants.padding_10,
              horizontal: AppConstants.padding_10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ],
            borderRadius:
                const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.orderSummaryList.data?.data?[index].suppliers
                        ?.contactName! ?? '',
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14,
                  color: AppColors.blackColor,
                ),
              ),
              10.height,
              Row(
                children: [
                  CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 3,
                    title: AppLocalizations.of(context)!.products,
                    value: state
                            .orderSummaryList.data?.data?[index].totalQuantity
                            ?.toString() ??
                        '',
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextWeight: FontWeight.w700,
                    valueTextSize: AppConstants.smallFont,
                  ),
                  5.width,
                  CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 5,
                    title: AppLocalizations.of(context)!.savings_for_sales,
                    value: state
                        .orderSummaryList.data?.data?[index].totalQuantity
                        ?.toString() ??
                        '',
                    titleColor: AppColors.orangeColor,
                    valueColor: AppColors.blackColor,
                    valueTextWeight: FontWeight.w700,
                    valueTextSize: AppConstants.smallFont,
                  ),
                  5.width,
                  CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 7,
                    title: AppLocalizations.of(context)!.total_order,
                    value:
                    formatNumber(value: vatCalculation(price: state.orderSummaryList.data?.data?[index].totalAmount ?? 0,vat: state.orderSummaryList.data?.vatPercentage ?? 0).toStringAsFixed(2),local: AppStrings.hebrewLocal),
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextWeight: FontWeight.w500,
                    valueTextSize: AppConstants.smallFont,
                  ),

                ],
              ),
             8.height,
          /*    Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left:10,right: 10,top: 5,bottom: 5),
                decoration: BoxDecoration(
                  color: AppColors.redColor,
                ),
                child: Text(AppLocalizations.of(context)!.not_minimum_order,style: TextStyle(color: AppColors.whiteColor),),
              ),
            */
              CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!.send_order,
                bGColor: AppColors.mainColor,
                height: 40,
                isLoading: state.isLoading,
                onPressed: () {
                  if (!state.isLoading) {
                    bloc.add(
                        OrderSummaryEvent.orderSendEvent(
                          context: context,
                        ));
                  }
                },
                fontColors: AppColors.whiteColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
