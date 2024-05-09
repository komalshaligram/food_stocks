import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../bloc/invoice_pdf/invoice_pdf_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class InvoicePdfRoute {
  static Widget get route => InvoicePdfScreen();
}

class InvoicePdfScreen extends StatelessWidget {
  InvoicePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => InvoicePdfBloc()
        ..add(InvoicePdfEvent.getArgumentEvent(
            invoiceDetailsList: args?[AppStrings.invoiceListString])),
      child: InvoicePdfScreenWidget(),
    );
  }
}

class InvoicePdfScreenWidget extends StatelessWidget {
  InvoicePdfScreenWidget({super.key});

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    InvoicePdfBloc bloc = context.read<InvoicePdfBloc>();
    return BlocBuilder<InvoicePdfBloc, InvoicePdfState>(
      builder: (context, state) {
        print('invoiceDetailsList_____${state.invoiceDetailsList.link}');
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.my_invoices,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: GestureDetector(
                onTap: () async {
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();
                  if (Platform.isAndroid) {
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidInfo =
                        await deviceInfo.androidInfo;
                    debugPrint(
                        'Running on android version ${androidInfo.version.sdkInt}');
                    if (androidInfo.version.sdkInt < 33) {
                      if (!statuses[Permission.storage]!.isGranted) {
                        CustomSnackBar.showSnackBar(
                            context: context,
                            title:
                                '${AppLocalizations.of(context)!.storage_permission}',
                            type: SnackBarType.FAILURE);
                        return;
                      }
                    }
                  } else {
                    //for ios permission
                  }
                  if (state.invoiceDetailsList.link?.isNotEmpty ?? false) {
                    context
                        .read<InvoicePdfBloc>()
                        .add(InvoicePdfEvent.pdfDownloadEvent(
                          context: context,
                        ));
                  }
                },
                child: Icon(
                  Icons.download_outlined,
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(AppConstants.padding_8),
                        padding: EdgeInsets.symmetric(
                            vertical: AppConstants.padding_8,
                            horizontal: AppConstants.padding_8),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      AppColors.shadowColor.withOpacity(0.15),
                                  blurRadius: AppConstants.blur_10),
                            ],
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppConstants.radius_5))),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CommonOrderContentWidget(
                                    backGroundColor: AppColors.iconBGColor,
                                    borderCoder: AppColors.lightBorderColor,
                                    flexValue: 2,
                                    title: AppLocalizations.of(context)!
                                        .invoice_number,
                                    value: state.invoiceDetailsList.invoiceNumber
                                        .toString(),
                                    titleColor: AppColors.mainColor,
                                    valueColor: AppColors.blackColor,
                                    valueTextSize: AppConstants.font_12,
                                    titleTextSize: AppConstants.font_12,
                                    columnPadding: 2,
                                    maxLine: 2,
                                    titleMaxLine: 2,
                                    valueTextWeight: FontWeight.w400),
                                4.width,
                                CommonOrderContentWidget(
                                    backGroundColor: AppColors.iconBGColor,
                                    borderCoder: AppColors.lightBorderColor,
                                    flexValue: 2,
                                    title:
                                        AppLocalizations.of(context)!.invoice_date,
                                    value: state.invoiceDetailsList.invoiceDate
                                        .toString(),
                                    titleColor: AppColors.mainColor,
                                    valueColor: AppColors.blackColor,
                                    valueTextSize: AppConstants.font_12,
                                    columnPadding: 2,
                                    maxLine: 2,
                                    titleTextSize: AppConstants.font_12,
                                    titleMaxLine: 2,
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
                                    title:
                                    AppLocalizations.of(context)!.invoice_type,
                                    value: state.invoiceDetailsList.invoiceType
                                        .toString()
                                        .toCapitalized(),
                                    titleColor: AppColors.mainColor,
                                    valueColor: AppColors.blackColor,
                                    valueTextSize: AppConstants.font_12,
                                    columnPadding: 2,
                                    maxLine: 2,
                                    titleMaxLine: 2,
                                    titleTextSize: AppConstants.font_12,
                                    valueTextWeight: FontWeight.w400),
                                4.width,
                                CommonOrderContentWidget(
                                    backGroundColor: AppColors.iconBGColor,
                                    borderCoder: AppColors.lightBorderColor,
                                    flexValue: 2,
                                    title: AppLocalizations.of(context)!
                                        .invoice_status,
                                    value: state.invoiceDetailsList.paymentStatus
                                        .toString()
                                        .toCapitalized(),
                                    titleColor: AppColors.mainColor,
                                    valueColor: AppColors.blackColor,
                                    valueTextSize: AppConstants.font_12,
                                    columnPadding: 2,
                                    maxLine: 2,
                                    titleTextSize: AppConstants.font_12,
                                    titleMaxLine: 2,
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
                                    title: AppLocalizations.of(context)!
                                        .invoice_amount,
                                    value: formatNumber(
                                        value: (state
                                            .invoiceDetailsList.invoiceAmount ??
                                            '0.0'),
                                        local: AppStrings.hebrewLocal),
                                    titleColor: AppColors.mainColor,
                                    valueColor: AppColors.blackColor,
                                    valueTextSize: AppConstants.font_12,
                                    columnPadding: 2,
                                    maxLine: 2,
                                    titleTextSize: AppConstants.font_12,
                                    titleMaxLine: 2,
                                    valueTextWeight: FontWeight.w700),
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
                          '${AppUrls.baseFileUrl}${state.invoiceDetailsList.link ?? ''}',
                          key: _pdfViewerKey,
                          controller: _pdfViewerController,
                          onDocumentLoaded: (details) {
                            print('details_____++++${details}');
                          },
                          onDocumentLoadFailed: (details) {
                           bloc.add(InvoicePdfEvent.pdfRefreshEvent(pdfUrl: state.invoiceDetailsList.link ?? ''));
                          },

                        ),
                      ),
                    ],
                  ),
                  state.isDownloading
                      ? Container(
                          height: getScreenHeight(context),
                          width: getScreenWidth(context),
                          color: Color.fromARGB(20, 0, 0, 0),
                          alignment: Alignment.center,
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_10))),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CupertinoActivityIndicator(
                                  color: AppColors.blackColor,
                                  radius: AppConstants.radius_10,
                                ),
                                10.height,
                                Text(
                                  '${state.downloadProgress}%',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_14,
                                      color: AppColors.blackColor),
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