import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_stock/bloc/return/return_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/order_summary_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/res_model/get_return_list_res_model/get_return_list_res_model.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/refresh_widget.dart';

class ReturnListRoute {
  static Widget get route => const ReturnListScreen();
}

class ReturnListScreen extends StatelessWidget {
  const ReturnListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReturnBloc()..add(ReturnEvent.getReturnListEvent(context: context)),
      child: const ReturnListWidget(),
    );
  }
}

class ReturnListWidget extends StatelessWidget {
  const ReturnListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReturnBloc, ReturnState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.returns,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: InkWell(
                onTap: (){
                  Navigator.pushNamed(context,RouteDefine.scanReturnProduct.name);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(5.0)),
                  child: Text(
                    AppLocalizations.of(context)!.new_return,
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
                physics: state.returnList.isEmpty
                  ? const NeverScrollableScrollPhysics()
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                         state.isLoading
                      ? const OrderSummaryScreenShimmerWidget(containerHeight: 100,)
                      : state.returnList.isNotEmpty
                      ?
                  AnimationLimiter(
                    child: ListView.builder(
                      itemCount:state.returnList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                        duration: const Duration(seconds: 1),
                        position: index,
                        child: SlideAnimation(
                          verticalOffset: 44.0,
                          child: FadeInAnimation(
                            child: returnListItem(index: index, context: context, list: state.returnList,state: state),
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
        );
      },
    );
  }

  Widget returnListItem({required int index, required BuildContext context, required List<Return> list, required ReturnState state}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(AppConstants.padding_10),
        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.height,
            Text(
              '${AppLocalizations.of(context)?.date_sent} ${list[index].createdAt}',
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, fontWeight: FontWeight.w400),
            ),
            2.height,
            Text(
              list[index].returnNumber.toString()+" "+AppLocalizations.of(context)!.products,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, fontWeight: FontWeight.w400),
            ),
            2.height,
            Text(
              list[index].returnNumber.toString()+" "+AppLocalizations.of(context)!.units,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, fontWeight: FontWeight.w400),
            ),
            2.height,
            list[index].totalPayment!='0'?Text(
             AppLocalizations.of(context)!.total_refund+" "+list[index].totalPayment.toString(),
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, fontWeight: FontWeight.bold),
            ):0.height,
            5.height,
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8.0)),
                    child: Text(getStatus(state.statusList, list[index].returnStatusName??'', state.language),style:
                    AppStyles.rkRegularTextStyle(size: AppConstants.font_14,color: getStatusColor(state.statusList,list[index].returnStatusName??'')),),
                  ),
                ),
                8.width,
                 Expanded(
                  child: list[index].returnStatusNumber==2?Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                    decoration: BoxDecoration( borderRadius: BorderRadius.circular(8.0),gradient: AppColors.appMainGradientColor),
                    child: Text(AppLocalizations.of(context)!.open_refund_invoice,style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14,color: AppColors.whiteColor),),
                  ):0.height,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
