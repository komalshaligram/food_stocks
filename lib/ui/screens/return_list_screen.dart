import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '/bloc/return/return_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/ui/utils/constants/app_strings.dart';
import '/ui/utils/constants/app_urls.dart';
import '/ui/widget/common_pdf_viewer.dart';
import '/ui/widget/order_summary_screen_shimmer_widget.dart';
import '/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/res_model/get_return_list_res_model/get_return_list_res_model.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
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
    final args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocBuilder<ReturnBloc, ReturnState>(builder: (context, state) {
      ReturnBloc bloc = context.read<ReturnBloc>();

      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.returns,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () {
              if (args?[AppStrings.isbackString] == 'Basket') {
                Navigator.pushReplacementNamed(context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.pushNavigationString: 'basketScreen'});
              } else if (args?[AppStrings.isbackString] == 'orderSummary') {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.pushNavigationString: 'profileScreen'});
              }
            },
            trailingWidget: InkWell(
              onTap: () {
                bloc.add(ReturnEvent.newRequestEvent(context: context));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_8),
                decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_5)),
                child: Text(AppLocalizations.of(context)!.new_return, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor)),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SmartRefresher(
            enablePullDown: true,
            controller: state.refreshController,
            header: const RefreshWidget(),
            footer: CustomFooter(builder: (context, mode) => const OrderSummaryScreenShimmerWidget(itemCount: 2)),
            enablePullUp: !state.isBottomOfProducts,
            onRefresh: () {
              context.read<ReturnBloc>().add(ReturnEvent.refreshListEvent(context: context));
            },
            onLoading: () {
              context.read<ReturnBloc>().add(ReturnEvent.getReturnListEvent(context: context));
            },
            child: SingleChildScrollView(
              physics: state.returnList.isEmpty ? const NeverScrollableScrollPhysics() : null,
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                state.isLoading
                    ? const OrderSummaryScreenShimmerWidget(containerHeight: 100)
                    : state.returnList.isNotEmpty
                        ? AnimationLimiter(
                            child: ListView.builder(
                              itemCount: state.returnList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                                duration: const Duration(seconds: 1),
                                position: index,
                                child: SlideAnimation(
                                  verticalOffset: 44.0,
                                  child: FadeInAnimation(child: returnListItem(index: index, context: context, list: state.returnList, state: state)),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: getScreenHeight(context) * 0.8,
                            child: noDataWidget(AppLocalizations.of(context)!.no_data),
                          ),
              ]),
            ),
          ),
        ),
      );
    });
  }

  Widget returnListItem({required int index, required BuildContext context, required List<Return> list, required ReturnState state}) {
    return GestureDetector(
      onTap: () {
        if (list[index].returnStatusNumber != 2) {
          Navigator.pushNamed(context, RouteDefine.createProductReturnListScreen.name, arguments: {
            AppStrings.idString: list[index].id,
            AppStrings.isUpdateParamString: true,
            'status': list[index].returnStatusNumber.toString().contains('1') ? true : false,
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(AppConstants.padding_10),
        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            '${AppLocalizations.of(context)!.return_number_text} ${list[index].returnNumber}',
            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor),
          ),
          2.height,
          list[index].returnStatusNumber != 4
              ? Text(
                  list[index].returnStatusNumber != 2 ? '${AppLocalizations.of(context)?.date_sent} ${list[index].createdAt}' : '${AppLocalizations.of(context)?.date_approved} ${list[index].invoiceDate}',
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, fontWeight: FontWeight.w400),
                )
              : 0.height,
          2.height,
          Text(
            "${list[index].productCount} ${AppLocalizations.of(context)!.products}",
            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, fontWeight: FontWeight.w400),
          ),
          2.height,
          Text(
            "${list[index].productUnit} ${AppLocalizations.of(context)!.units}",
            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, fontWeight: FontWeight.w400),
          ),
          2.height,
          list[index].returnStatusNumber == 2
              ? Text(
                  "${AppLocalizations.of(context)!.total_refund} ${list[index].totalPayment}",
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, fontWeight: FontWeight.bold),
                )
              : 0.height,
          5.height,
          Row(children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8, vertical: AppConstants.padding_5),
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(AppConstants.radius_7)),
                child: Text(
                  getStatus(state.statusList, list[index].returnStatusName ?? '', state.language),
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: getStatusColor(state.statusList, list[index].returnStatusName ?? '')),
                ),
              ),
            ),
            8.width,
            Expanded(
              child: list[index].returnStatusNumber == 2
                  ? InkWell(
                      onTap: () {
                        if (list[index].rivchitInvoiceLink!.isEmpty) {
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CommonPdfViewer(url: '${AppUrlEndPoints.baseFileUrl}${list[index].rivchitInvoiceLink}')));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8, vertical: AppConstants.padding_5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radius_7), gradient: AppColors.appMainGradientColor),
                        child: Text(
                          AppLocalizations.of(context)!.open_refund_invoice,
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor),
                        ),
                      ),
                    )
                  : 0.height,
            )
          ])
        ]),
      ),
    );
  }
}
