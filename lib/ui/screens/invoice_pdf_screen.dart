import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../bloc/invoice_pdf/invoice_pdf_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_divider_widget.dart';

class InvoicePdfRoute {
  static Widget get route => const InvoicePdfScreen();
}

class InvoicePdfScreen extends StatelessWidget {
  const InvoicePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
        create: (context) =>
            InvoicePdfBloc()..add(InvoicePdfEvent.getArgumentEvent(invoiceDetailsList: args?[AppStrings.invoiceListString], context: context)),
        child: InvoicePdfScreenWidget(invoiceDetailsList: args?[AppStrings.invoiceListString]));
  }
}

class InvoicePdfScreenWidget extends StatefulWidget {
  final Invoice invoiceDetailsList;
  const InvoicePdfScreenWidget({super.key, required this.invoiceDetailsList});

  @override
  State<InvoicePdfScreenWidget> createState() => _InvoicePdfScreenWidgetState();
}

class _InvoicePdfScreenWidgetState extends State<InvoicePdfScreenWidget> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  String? _cachedUrl;
  Uint8List? _cachedPdfBytes;
  bool _isCachingPdf = false;
  bool _isPreparingShare = false;
  bool _shareLocked = false;

  Future<Uint8List> _downloadPdfBytes(String url) async {
    final encodedUrl = Uri.encodeFull(url.trim());
    final res = await Dio().get<List<int>>(encodedUrl,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            receiveTimeout: const Duration(minutes: 2),
            sendTimeout: const Duration(minutes: 2)));
    final bytes = Uint8List.fromList(res.data ?? const <int>[]);
    if (bytes.isEmpty) throw Exception('Empty PDF bytes');
    return bytes;
  }

  void _startCacheIfNeeded(String url) {
    if (url.trim().isEmpty) return;
    if (_cachedUrl == url && _cachedPdfBytes != null) return;
    if (_cachedUrl == url && _isCachingPdf) return;

    _cachedUrl = url;
    _cachedPdfBytes = null;
    _isCachingPdf = true;

    _downloadPdfBytes(url).then((bytes) {
      if (!mounted || _cachedUrl != url) return;
      setState(() {
        _cachedPdfBytes = bytes;
        _isCachingPdf = false;
      });
    }).catchError((_) {
      if (mounted && _cachedUrl == url) {
        setState(() => _isCachingPdf = false);
      }
    });
  }

  Future<Uint8List> _getOrDownloadBytes(String url) async {
    if (_cachedUrl == url && _cachedPdfBytes != null) {
      return _cachedPdfBytes!;
    }
    final bytes = await _downloadPdfBytes(url);
    if (mounted) {
      setState(() {
        _cachedUrl = url;
        _cachedPdfBytes = bytes;
        _isCachingPdf = false;
      });
    }
    return bytes;
  }

  Future<void> _sharePdf({required BuildContext context, required String url, required String fileNameWithoutExt, Rect? sharePositionOrigin}) async {
    if (url.trim().isEmpty || _shareLocked) return;

    setState(() {
      _shareLocked = true;
      _isPreparingShare = true;
    });
    try {
      final bytes = await _getOrDownloadBytes(url);
      final tempDir = await getTemporaryDirectory();
      final rawName = fileNameWithoutExt.trim().isEmpty ? 'document' : fileNameWithoutExt.trim();
      final safeName = rawName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
      final trimmedName = safeName.length > 60 ? safeName.substring(0, 60) : safeName;
      final filePath = '${tempDir.path}/$trimmedName.pdf';
      await File(filePath).writeAsBytes(bytes, flush: true);

      if (mounted) setState(() => _isPreparingShare = false);

      await Share.shareXFiles([XFile(filePath, mimeType: 'application/pdf')], sharePositionOrigin: sharePositionOrigin);
    } catch (_) {
      if (!context.mounted) return;
      CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.unable_pdf, type: SnackBarType.failure);
    } finally {
      if (mounted) {
        setState(() {
          _isPreparingShare = false;
          _shareLocked = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicePdfBloc, InvoicePdfState>(builder: (context, state) {
      final bloc = context.read<InvoicePdfBloc>();
      final invoice = state.invoiceDetailsList;
      final String url = invoice.invoiceLink ?? '';
      final bool showShareIcon = state.hasValidLink == true && bloc.isValidLink(url);

      Widget itemOne() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [titleText(context, AppLocalizations.of(context)!.invoice), subTitleValueText(context, invoice.invoiceNumber.toString())]),
            invoice.paymentMethod != null
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_2, horizontal: AppConstants.padding_10),
                    decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(AppConstants.radius_50)),
                    child: Text(
                        invoice.paymentMethod.toString() == AppStrings.wallet
                            ? AppLocalizations.of(context)!.payment_wallet
                            : invoice.paymentMethod.toString() == AppStrings.creditCard
                                ? AppLocalizations.of(context)!.payment_credit_card
                                : invoice.paymentMethod.toString() == AppStrings.bankTransfer
                                    ? AppLocalizations.of(context)!.payment_bank_transfer
                                    : AppLocalizations.of(context)!.payment_bank_check,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor, fontWeight: FontWeight.normal)),
                  )
                : 0.width,
            invoice.paymentStatus != null ? getPaymentStatusWidget(invoice.paymentStatus!, context) : 0.width
          ]);

      Widget itemTwo() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                titleText(context, AppLocalizations.of(context)!.invoice_date),
                subTitleValueText(context, (invoice.invoiceDate ?? '').isNotEmpty ? invoice.invoiceDate!.substring(0, 10) : '')
              ]),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                titleText(context, AppLocalizations.of(context)!.due_date),
                subTitleValueText(context, (invoice.dueDate ?? '').isNotEmpty ? invoice.dueDate!.substring(0, 10) : '--')
              ]),
            ),
          ]);

      Widget itemThree() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                titleText(context, AppLocalizations.of(context)!.for_order),
                GestureDetector(
                  onTap: () {
                    if (invoice.orderNumber != null) {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => ProductDetailsScreen(
                                  statusList: state.statusList,
                                  orderNumber: invoice.orderNumber.toString(),
                                  orderId: invoice.orderId.toString(),
                                  isNavigateToProductDetailString: true),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                    position: animation.drive(Tween(
                                      begin: const Offset(0, 1),
                                      end: Offset.zero,
                                    ).chain(CurveTween(curve: Curves.easeInOut))),
                                    child: child);
                              }));
                    }
                  },
                  child: invoice.orderNumber == null
                      ? const Text('---')
                      : Stack(alignment: Alignment.bottomLeft, children: [
                          Text(invoice.orderNumber.toString(),
                              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.notificationColor)),
                          Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 1, color: AppColors.notificationColor))
                        ]),
                ),
              ]),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                titleText(context, AppLocalizations.of(context)!.total_invoice_amount),
                Directionality(textDirection: TextDirection.ltr, child: subTitleValueText(context, formatSignedNumber(invoice.invoiceAmount)))
              ]),
            ),
          ]);

      Widget pdfSection() {
        if (state.hasValidLink == null) {
          return const SizedBox.shrink();
        }
        if (state.hasValidLink == false || !bloc.isValidLink(url)) {
          return Center(child: Text(AppLocalizations.of(context)!.no_invoice_file));
        }

        _startCacheIfNeeded(url);

        return Container(
          color: Colors.white,
          child: SfPdfViewer.network(url,
              key: ValueKey(url),
              controller: _pdfViewerController,
              scrollDirection: PdfScrollDirection.vertical,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              canShowPaginationDialog: true),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: bloc.screenTitleName == AppLocalizations.of(context)!.my_invoices
                ? AppLocalizations.of(context)!.my_invoices
                : AppLocalizations.of(context)!.my_refunds,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () => Navigator.pop(context),
            trailingWidget: showShareIcon
                ? Builder(
                    builder: (shareContext) => GestureDetector(
                        onTap: _shareLocked
                            ? null
                            : () async {
                                final box = shareContext.findRenderObject() as RenderBox?;
                                final origin = box == null ? null : (box.localToGlobal(Offset.zero) & box.size);

                                await _sharePdf(
                                    context: shareContext,
                                    url: url,
                                    fileNameWithoutExt: 'invoice_${invoice.invoiceNumber ?? ''}',
                                    sharePositionOrigin: origin);
                              },
                        child: _isPreparingShare
                            ? SizedBox(width: 22, height: 22, child: CupertinoActivityIndicator(color: AppColors.mainColor))
                            : Icon(Icons.share, color: AppColors.mainColor)),
                  )
                : const SizedBox(),
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            Column(children: [
              SingleChildScrollView(
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.all(AppConstants.padding_8),
                      padding: const EdgeInsets.all(AppConstants.padding_8),
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10))),
                      child: Column(children: [itemOne(), const DividerWidget(height: 20), itemTwo(), const DividerWidget(height: 20), itemThree()])),
                  15.height
                ]),
              ),
              Expanded(child: pdfSection())
            ]),
            if (state.isDownloading)
              Container(
                height: getScreenHeight(context),
                width: getScreenWidth(context),
                color: const Color.fromARGB(20, 0, 0, 0),
                alignment: Alignment.center,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration:
                      BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10))),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    CupertinoActivityIndicator(color: AppColors.mainColor),
                    10.height,
                    Text('${state.downloadProgress}%', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor))
                  ]),
                ),
              ),
          ]),
        ),
      );
    });
  }
}
