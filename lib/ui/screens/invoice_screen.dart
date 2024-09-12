import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class InvoiceRoute {
  static Widget get route => const InvoiceScreen();
}

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceBloc()..add(InvoiceEvent.getInvoicesDataEvent(context: context)),
      child: const InvoiceScreenWidget(),
    );
  }
}

class InvoiceScreenWidget extends StatelessWidget {
  const InvoiceScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.my_invoices,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SmartRefresher(
              enablePullDown: true,
              controller: state.refreshController,
              header: const RefreshWidget(),
              footer: CustomFooter(
                  builder: (context, mode) => const OrderSummaryScreenShimmerWidget(containerHeight: 140,)
              ),
              enablePullUp: !state.isBottomOfProducts,
              onRefresh: () {
                context.read<InvoiceBloc>().add(
                    InvoiceEvent.refreshListEvent(
                        context: context));
              },
              onLoading: () {
                context.read<InvoiceBloc>().add(
                    InvoiceEvent.getInvoicesDataEvent(
                        context: context));
              },
              child: state.isShimmering ? const OrderSummaryScreenShimmerWidget(containerHeight: 140,) :
              !state.isShimmering && state.invoiceDetailsList.isEmpty ?
              SizedBox(
                height: getScreenHeight(context) * 0.8,
                child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.no_data,
                      style: AppStyles.pVRegularTextStyle(
                          size: AppConstants.normalFont,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400),
                    )),
              )  :
              ListView.builder(
                itemCount: state.invoiceDetailsList.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    invoiceList(
                      index: index,
                      invoicesList: state.invoiceDetailsList,
                        context: context,
                        invoiceType:
                            state.invoiceDetailsList[index].invoiceType.toString(),
                        invoiceDate:
                            state.invoiceDetailsList[index].invoiceDate.toString(),
                        invoicePrice: state
                            .invoiceDetailsList[index].invoiceAmount
                            .toString(),
                        invoiceNumber: state
                            .invoiceDetailsList[index].invoiceNumber
                            .toString(),
                        invoiceStatue: state
                            .invoiceDetailsList[index].paymentStatus
                            .toString(),

                    ),
              ),
            ),
          )),
        );
      },
    );
  }

  Widget invoiceList({
    required BuildContext context,
    required String invoiceDate,
    required String invoiceType,
    required String invoicePrice,
    required String invoiceStatue,
    required String invoiceNumber,
    required List<Invoice>invoicesList,
    required int index,
  }) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, RouteDefine.invoicePdfScreen.name,arguments:
        {AppStrings.invoiceListString : invoicesList[index] });
      },
      child: Container(
        margin: const EdgeInsets.all(AppConstants.padding_8),
        padding: const EdgeInsets.symmetric(
            vertical: AppConstants.padding_8, horizontal: AppConstants.padding_8),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ],
            borderRadius:
                const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 2,
                    title: AppLocalizations.of(context)!.invoice_number,
                    value: invoiceNumber,
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.font_12,
                    columnPadding: 2,
                    titleMaxLine: 2,
                    maxLine: 2,
                    titleTextSize: AppConstants.font_12,
                    valueTextWeight: FontWeight.w400,),
                4.width,
                CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 2,
                    titleMaxLine: 2,
                    maxLine: 2,
                    title: AppLocalizations.of(context)!.invoice_date,
                    value: invoiceDate,
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.font_12,
                    titleTextSize: AppConstants.font_12,
                    columnPadding: 2,
                    valueTextWeight: FontWeight.w400),
              ],
            ),
            5.height,
            Row(
              children: [
                CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 2,
                    titleMaxLine: 2,
                    maxLine: 2,
                    title: AppLocalizations.of(context)!.invoice_status,
                    value: invoiceStatue.toCapitalized(),
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.font_12,
                    titleTextSize: AppConstants.font_12,
                    columnPadding: 2,
                    valueTextWeight: FontWeight.w400),
                4.width,
                CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 2,
                    titleMaxLine: 2,
                    maxLine: 2,
                    title: AppLocalizations.of(context)!.invoice_amount,
                    value: formatNumber(value: invoicePrice, local: AppStrings.hebrewLocal),
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.font_12,
                    titleTextSize: AppConstants.font_12,
                    columnPadding: 2,
                    valueTextWeight: FontWeight.w700),
              ],
            ),
            5.height,
            Row(
              children: [
                CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 3,
                    titleMaxLine: 2,
                    maxLine: 2,
                    title: AppLocalizations.of(context)!.invoice_type,
                    value: invoiceType.toCapitalized(),
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.font_12,
                    titleTextSize: AppConstants.font_12,
                    columnPadding: 2,
                    valueTextWeight: FontWeight.w400),
              ],
            ),

          ],
        ),
      ),
    );
  }
}



