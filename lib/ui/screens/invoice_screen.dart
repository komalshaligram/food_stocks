import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
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
    return BlocBuilder<InvoiceBloc, InvoiceState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: context.read<InvoiceBloc>().screenTitleName == AppLocalizations.of(context)!.my_invoices ? AppLocalizations.of(context)!.my_invoices : AppLocalizations.of(context)!.my_refunds,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
          child: SmartRefresher(
            enablePullDown: true,
            controller: state.refreshController,
            header: const RefreshWidget(),
            footer: CustomFooter(builder: (context, mode) => const OrderSummaryScreenShimmerWidget(containerHeight: 140)),
            enablePullUp: !state.isBottomOfProducts,
            onRefresh: () {
              context.read<InvoiceBloc>().add(InvoiceEvent.refreshListEvent(context: context));
            },
            onLoading: () {
              context.read<InvoiceBloc>().add(InvoiceEvent.getInvoicesDataEvent(context: context));
            },
            child: state.isShimmering
                ? const OrderSummaryScreenShimmerWidget(containerHeight: 140)
                : !state.isShimmering && state.invoiceDetailsList.isEmpty
                    ? SizedBox(height: getScreenHeight(context) * 0.8, child: noDataWidget(AppLocalizations.of(context)!.no_data))
                    : ListView.builder(
                        itemCount: state.invoiceDetailsList.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) => invoiceList(
                          index: index,
                          invoicesList: state.invoiceDetailsList,
                          context: context,
                          invoiceType: state.invoiceDetailsList[index].invoiceType.toString(),
                          invoiceDate: state.invoiceDetailsList[index].invoiceDate.toString(),
                          invoicePrice: state.invoiceDetailsList[index].invoiceAmount.toString(),
                          invoiceNumber: state.invoiceDetailsList[index].invoiceNumber.toString(),
                          invoiceStatus: state.statusList.isNotEmpty ? getStatus(state.statusList, state.invoiceDetailsList[index].paymentStatus.toString(), state.language).toCapitalized() : '',
                          supplierName: state.invoiceDetailsList[index].supplierName ?? '',
                          dueDate: state.invoiceDetailsList[index].dueDate.toString(),
                        ),
                      ),
          ),
        )),
      );
    });
  }

  Widget invoiceList({
    required BuildContext context,
    required String invoiceDate,
    required String invoiceType,
    required String invoicePrice,
    required String invoiceStatus,
    required String invoiceNumber,
    required String dueDate,
    required List<Invoice> invoicesList,
    required int index,
    required String supplierName,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteDefine.invoicePdfScreen.name,
          arguments: {
            AppStrings.invoiceListString: invoicesList[index],
            AppStrings.invoiceTitleNameString: context.read<InvoiceBloc>().screenTitleName == AppLocalizations.of(context)!.my_invoices ? AppLocalizations.of(context)!.my_invoices :
            AppLocalizations.of(context)!.my_refunds,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(AppConstants.padding_8),
        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_8, horizontal: AppConstants.padding_8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 2,
              title: AppLocalizations.of(context)!.invoice_number,
              value: invoiceNumber,
              titleColor: AppColors.mainColor,
              valueColor: AppColors.blackColor,
              valueTextSize: AppConstants.smallFont,
              columnPadding: AppConstants.padding_2,
              titleMaxLine: 2,
              maxLine: 2,
              titleTextSize: AppConstants.smallFont,
              valueTextWeight: FontWeight.w400,
            ),
            4.width,
            CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 2,
              titleMaxLine: 2,
              maxLine: 2,
              title: AppLocalizations.of(context)!.invoice_date,
              value: invoiceDate.replaceRange(10, 16, ''),
              titleColor: AppColors.mainColor,
              valueColor: AppColors.blackColor,
              valueTextSize: AppConstants.smallFont,
              titleTextSize: AppConstants.smallFont,
              columnPadding: AppConstants.padding_2,
              valueTextWeight: FontWeight.w400,
            ),
          ]),
          5.height,
          Row(children: [
            CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 2,
              titleMaxLine: 2,
              maxLine: 2,
              title: AppLocalizations.of(context)!.invoice_status,
              value: invoiceStatus.toString(),
              titleColor: AppColors.mainColor,
              valueColor: AppColors.blackColor,
              valueTextSize: AppConstants.smallFont,
              titleTextSize: AppConstants.smallFont,
              columnPadding: AppConstants.padding_2,
              valueTextWeight: FontWeight.w400,
            ),
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
              valueTextSize: AppConstants.smallFont,
              titleTextSize: AppConstants.smallFont,
              columnPadding: 2,
              valueTextWeight: FontWeight.w700,
            ),
          ]),
          5.height,
          Row(children: [
            CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 2,
              titleMaxLine: 2,
              maxLine: 2,
              title: AppLocalizations.of(context)!.invoice_type,
              value: invoiceType.toCapitalized(),
              titleColor: AppColors.mainColor,
              valueColor: AppColors.blackColor,
              valueTextSize: AppConstants.smallFont,
              titleTextSize: AppConstants.smallFont,
              columnPadding: AppConstants.padding_2,
              valueTextWeight: FontWeight.w400,
            ),
            4.width,
            CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 2,
              titleMaxLine: 2,
              maxLine: 2,
              title: AppLocalizations.of(context)!.due_date,
              value: dueDate.isNotEmpty ? dueDate.replaceRange(10, 16, '') : '',
              titleColor: AppColors.mainColor,
              valueColor: AppColors.blackColor,
              valueTextSize: AppConstants.smallFont,
              titleTextSize: AppConstants.smallFont,
              columnPadding: AppConstants.padding_2,
              valueTextWeight: FontWeight.w400,
            ),
          ]),
          5.height,
          Row(children: [
            CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 2,
              titleMaxLine: 2,
              maxLine: 2,
              title: AppLocalizations.of(context)!.supplier_name,
              value: supplierName,
              titleColor: AppColors.mainColor,
              valueColor: AppColors.blackColor,
              valueTextSize: AppConstants.smallFont,
              titleTextSize: AppConstants.smallFont,
              columnPadding: AppConstants.padding_2,
              valueTextWeight: FontWeight.w400,
            ),
          ]),
        ]),
      ),
    );
  }
}
