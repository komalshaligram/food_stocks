import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_stock/bloc/order_summary/order_summary_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
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
      create: (context) => OrderSummaryBloc()..add(OrderSummaryEvent.getDataEvent(context: context,CartItemList: args?[AppStrings.getCartListString] ?? GetAllCartResModel())),
      child: OrderSummaryScreenWidget(),
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
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
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
                    ? Expanded(child: OrderSummaryScreenShimmerWidget())
                    : Expanded(
                        child: AnimationLimiter(
                          child: ListView.builder(
                            itemCount: state.orderSummaryList.data?.data?.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding_5),
                            itemBuilder: (context, index) =>
                                AnimationConfiguration.staggeredList(
                                    duration: const Duration(seconds: 1),
                                    position: index,
                                    child: SlideAnimation(
                                        child: FadeInAnimation(
                                            child: orderListItem(index: index, context: context)))),
                          ),
                        ),
                      ),
                (state.orderSummaryList.data?.data?.length ?? 0) == 0
                    ? 0.width
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: AppConstants.padding_20,
                              right: AppConstants.padding_20,
                              top: AppConstants.padding_10,
                              bottom: AppConstants.padding_40),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withOpacity(0.95),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      AppColors.shadowColor.withOpacity(0.20),
                                  blurRadius: AppConstants.blur_10),
                            ],
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppConstants.radius_40)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding_5,
                                horizontal: AppConstants.padding_5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius_40),
                              color: AppColors.whiteColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                      height: AppConstants.containerHeight_65,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.padding_5,
                                          horizontal: AppConstants.padding_5),
                                      decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: context.rtl
                                                  ? Radius.circular(
                                                      AppConstants.radius_6)
                                                  : Radius.circular(
                                                      AppConstants.radius_30),
                                              bottomLeft: context.rtl
                                                  ? Radius.circular(
                                                      AppConstants.radius_6)
                                                  : Radius.circular(
                                                      AppConstants.radius_30),
                                              bottomRight: context.rtl
                                                  ? Radius.circular(
                                                      AppConstants.radius_30)
                                                  : Radius.circular(
                                                      AppConstants.radius_6),
                                              topRight: context.rtl
                                                  ? Radius.circular(
                                                      AppConstants.radius_30)
                                                  : Radius.circular(AppConstants.radius_6))),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context)!.total}${' : '}',
                                            style: AppStyles.rkRegularTextStyle(
                                              color: AppColors.whiteColor,
                                              size:
                                                  getScreenWidth(context) <= 380
                                                      ? AppConstants.smallFont
                                                      : AppConstants.mediumFont,
                                            ),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                                '${formatNumber(value: state.orderSummaryList.data?.cart?.first.totalAmount?.toStringAsFixed(2) ?? '0',local: AppStrings.hebrewLocal)}',
                                                style:
                                                    AppStyles.rkRegularTextStyle(
                                                        color:
                                                            AppColors.whiteColor,
                                                        size: getScreenWidth(
                                                                    context) <=
                                                                380
                                                            ? AppConstants
                                                                .smallFont
                                                            : AppConstants
                                                                .mediumFont,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                          ),
                                        ],
                                      )
                                      ),
                                ),
                                6.width,
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!state.isLoading) {
                                        bloc.add(
                                            OrderSummaryEvent.orderSendEvent(
                                          context: context,
                                        ));
                                      }
                                    },
                                    child: Container(
                                      height: AppConstants.containerHeight_65,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.padding_5,
                                          horizontal: AppConstants.padding_5),
                                      decoration: BoxDecoration(
                                          color: AppColors.navSelectedColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: context.rtl
                                                  ? Radius.circular(
                                                      AppConstants.radius_30)
                                                  : Radius.circular(
                                                      AppConstants.radius_6),
                                              bottomLeft: context.rtl
                                                  ? Radius.circular(
                                                      AppConstants.radius_30)
                                                  : Radius.circular(
                                                      AppConstants.radius_6),
                                              bottomRight: context.rtl
                                                  ? Radius.circular(
                                                      AppConstants.radius_6)
                                                  : Radius.circular(
                                                      AppConstants.radius_30),
                                              topRight: context.rtl
                                                  ? Radius.circular(
                                                      AppConstants.radius_6)
                                                  : Radius.circular(
                                                      AppConstants.radius_30))),
                                      child: state.isLoading
                                          ? CupertinoActivityIndicator()
                                          : Text(
                                              AppLocalizations.of(context)!
                                                  .send_order,
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                size: getScreenWidth(context) <=
                                                        380
                                                    ? AppConstants.normalFont
                                                    : AppConstants.mediumFont,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  Widget orderListItem({required int index, required BuildContext context}) {
   /* OrderSummaryBloc bloc = context.read<OrderSummaryBloc>();*/
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(AppConstants.padding_10),
          padding: EdgeInsets.symmetric(
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
                BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.orderSummaryList.data?.data?[index].suppliers
                        ?.contactName! ??
                    '',
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
                    flexValue: 2,
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
                    backGroundColor: AppColors.whiteColor,
                    borderCoder: AppColors.whiteColor,
                    flexValue: 1,
                    title: AppLocalizations.of(context)!.delivery_date,
                    value: '-',
                    titleColor: AppColors.whiteColor,
                    valueColor: AppColors.whiteColor,
                    valueTextSize: AppConstants.font_10,
                    valueTextWeight: FontWeight.w500,
                    columnPadding: AppConstants.padding_10,
                  ),
                  5.width,
                  CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 7,
                    title: AppLocalizations.of(context)!.total_order,
                    value:
                    '${formatNumber(value: state.orderSummaryList.data?.data?[index].totalAmount?.toStringAsFixed(2) ?? '0',local: AppStrings.hebrewLocal)}',
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextWeight: FontWeight.w500,
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
