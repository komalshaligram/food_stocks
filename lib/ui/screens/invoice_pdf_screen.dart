import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../bloc/invoice_pdf/invoice_pdf_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';

class InvoicePdfRoute {
  static Widget get route => const InvoicePdfScreen();
}

class InvoicePdfScreen extends StatelessWidget {
  const InvoicePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => InvoicePdfBloc()
        ..add(InvoicePdfEvent.getArgumentEvent(
          invoiceDetailsList: args?[AppStrings.invoiceListString],
          context: context,
        )),
      child: InvoicePdfScreenWidget(invoiceDetailsList: args?[AppStrings.invoiceListString]),
    );
  }
}

class InvoicePdfScreenWidget extends StatelessWidget {
  final Invoice invoiceDetailsList;
  InvoicePdfScreenWidget({super.key, required this.invoiceDetailsList});

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicePdfBloc, InvoicePdfState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: context.read<InvoicePdfBloc>().screenTitleName == AppLocalizations.of(context)!.my_invoices ? AppLocalizations.of(context)!.my_invoices : AppLocalizations.of(context)!.my_refunds,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: GestureDetector(
                onTap: () async {
                  Share.share('${AppUrlEndPoints.baseFileUrl}${state.invoiceDetailsList.link}');
                },
                child: Icon(
                  Icons.download_outlined,
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(AppConstants.padding_8),
                        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_8, horizontal: AppConstants.padding_8),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
                            ],
                            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CommonOrderContentWidget(backGroundColor: AppColors.iconBGColor, borderCoder: AppColors.lightBorderColor, flexValue: 2, title: AppLocalizations.of(context)!.invoice_number, value: invoiceDetailsList.invoiceNumber.toString(), titleColor: AppColors.mainColor, valueColor: AppColors.blackColor, valueTextSize: AppConstants.smallFont, titleTextSize: AppConstants.smallFont, columnPadding: 2, maxLine: 2, titleMaxLine: 2, valueTextWeight: FontWeight.w400),
                                4.width,
                                CommonOrderContentWidget(backGroundColor: AppColors.iconBGColor, borderCoder: AppColors.lightBorderColor, flexValue: 2, title: AppLocalizations.of(context)!.invoice_date, value: invoiceDetailsList.invoiceDate.toString().replaceRange(10, 16, ''), titleColor: AppColors.mainColor, valueColor: AppColors.blackColor, valueTextSize: AppConstants.smallFont, columnPadding: 2, maxLine: 2, titleTextSize: AppConstants.smallFont, titleMaxLine: 2, valueTextWeight: FontWeight.w400),
                              ],
                            ),
                            5.height,
                            Row(
                              children: [
                                CommonOrderContentWidget(backGroundColor: AppColors.iconBGColor, borderCoder: AppColors.lightBorderColor, flexValue: 2, title: AppLocalizations.of(context)!.invoice_type, value: invoiceDetailsList.invoiceType.toString().toCapitalized(), titleColor: AppColors.mainColor, valueColor: AppColors.blackColor, valueTextSize: AppConstants.smallFont, columnPadding: 2, maxLine: 2, titleMaxLine: 2, titleTextSize: AppConstants.smallFont, valueTextWeight: FontWeight.w400),
                                4.width,
                                CommonOrderContentWidget(backGroundColor: AppColors.iconBGColor, borderCoder: AppColors.lightBorderColor, flexValue: 2, title: AppLocalizations.of(context)!.invoice_status, value: invoiceDetailsList.paymentStatus.toString().toCapitalized(), titleColor: AppColors.mainColor, valueColor: AppColors.blackColor, valueTextSize: AppConstants.smallFont, columnPadding: 2, maxLine: 2, titleTextSize: AppConstants.smallFont, titleMaxLine: 2, valueTextWeight: FontWeight.w400),
                              ],
                            ),
                            5.height,
                            Row(
                              children: [
                                CommonOrderContentWidget(backGroundColor: AppColors.iconBGColor, borderCoder: AppColors.lightBorderColor, flexValue: 2, title: AppLocalizations.of(context)!.invoice_amount, value: formatNumber(value: (invoiceDetailsList.invoiceAmount ?? '0.0'), local: AppStrings.hebrewLocal), titleColor: AppColors.mainColor, valueColor: AppColors.blackColor, valueTextSize: AppConstants.smallFont, columnPadding: 2, maxLine: 2, titleTextSize: AppConstants.smallFont, titleMaxLine: 2, valueTextWeight: FontWeight.w700),
                                4.width,
                                CommonOrderContentWidget(backGroundColor: AppColors.iconBGColor, borderCoder: AppColors.lightBorderColor, flexValue: 2, titleMaxLine: 2, maxLine: 2, title: AppLocalizations.of(context)!.due_date, value: invoiceDetailsList.dueDate!.isNotEmpty ? invoiceDetailsList.dueDate.toString().replaceRange(10, 16, '') : '', titleColor: AppColors.mainColor, valueColor: AppColors.blackColor, valueTextSize: AppConstants.smallFont, titleTextSize: AppConstants.smallFont, columnPadding: 2, valueTextWeight: FontWeight.w400),
                              ],
                            ),
                            5.height,
                            Row(
                              children: [
                                CommonOrderContentWidget(backGroundColor: AppColors.iconBGColor, borderCoder: AppColors.lightBorderColor, flexValue: 2, titleMaxLine: 2, maxLine: 2, title: AppLocalizations.of(context)!.supplier_name, value: invoiceDetailsList.supplierName ?? '', titleColor: AppColors.mainColor, valueColor: AppColors.blackColor, valueTextSize: AppConstants.smallFont, titleTextSize: AppConstants.smallFont, columnPadding: 2, valueTextWeight: FontWeight.w400),
                              ],
                            ),
                          ],
                        ),
                      ),
                      15.height,
                      Container(
                        color: Colors.white,
                        height: getScreenHeight(context) * 0.7,
                        child: SfPdfViewer.network(
                          '${AppUrlEndPoints.baseFileUrl}${invoiceDetailsList.link ?? ''}',
                          key: _pdfViewerKey,
                          controller: _pdfViewerController,
                        ),
                      ),
                    ],
                  ),
                  state.isDownloading
                      ? Container(
                          height: getScreenHeight(context),
                          width: getScreenWidth(context),
                          color: const Color.fromARGB(20, 0, 0, 0),
                          alignment: Alignment.center,
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10))),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CupertinoActivityIndicator(
                                  color: AppColors.mainColor,
                                  radius: AppConstants.radius_10,
                                ),
                                10.height,
                                Text(
                                  '${state.downloadProgress}%',
                                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor),
                                )
                              ],
                            ),
                          ),
                        )
                      : 0.width,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
