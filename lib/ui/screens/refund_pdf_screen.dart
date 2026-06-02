import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../bloc/refund_pdf/refund_pdf_bloc.dart';
import '../../data/model/res_model/refund_invoice_common_res/refund_invoice_common.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../widget/common_app_bar.dart';

class RefundPdfRoute {
  static Widget get route => const RefundPdfScreen();
}

class RefundPdfScreen extends StatelessWidget {
  const RefundPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => RefundPdfBloc()..add(RefundPdfEvent.getArgumentEvent(invoiceDetailsList: args?[AppStrings.invoiceListString], context: context)),
      child: RefundPdfScreenWidget(invoiceDetailsList: args?[AppStrings.invoiceListString]),
    );
  }
}

class RefundPdfScreenWidget extends StatefulWidget {
  final RefundInvoiceCommon? invoiceDetailsList;
  const RefundPdfScreenWidget({super.key, required this.invoiceDetailsList});

  @override
  State<RefundPdfScreenWidget> createState() => _RefundPdfScreenWidgetState();
}

class _RefundPdfScreenWidgetState extends State<RefundPdfScreenWidget> {
  String? _pdfUrl;
  Future<Uint8List>? _pdfBytesFuture;

  Future<Uint8List> _downloadPdfBytes(String url) async {
    final encodedUrl = Uri.encodeFull(url.trim());
    final res = await Dio().get<List<int>>(
      encodedUrl,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        receiveTimeout: const Duration(minutes: 2),
        sendTimeout: const Duration(minutes: 2),
      ),
    );
    final bytes = Uint8List.fromList(res.data ?? const <int>[]);
    if (bytes.isEmpty) throw Exception('Empty PDF bytes');
    return bytes;
  }

  Future<void> _sharePdfFromUrl({
    required BuildContext context,
    required String url,
    required String fileNameWithoutExt,
    Rect? sharePositionOrigin,
  }) async {
    if (url.trim().isEmpty) return;

    try {
      final encodedUrl = Uri.encodeFull(url.trim());
      final tempDir = await getTemporaryDirectory();
      final rawName = fileNameWithoutExt.trim().isEmpty ? 'document' : fileNameWithoutExt.trim();
      final safeName = rawName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_').substring(0, rawName.length > 60 ? 60 : rawName.length);
      final filePath = '${tempDir.path}/$safeName.pdf';

      await Dio().download(
        encodedUrl,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      final file = File(filePath);
      if (!await file.exists() || await file.length() == 0) {
        throw Exception('Downloaded file missing');
      }

      await Share.shareXFiles(
        [XFile(filePath, mimeType: 'application/pdf')],
        text: safeName,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (_) {
      if (!context.mounted) return;
      CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.unable_pdf, type: SnackBarType.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundPdfBloc, RefundPdfState>(builder: (context, state) {
      final bloc = context.read<RefundPdfBloc>();
      final String? fullUrl = state.invoiceDetailsList?.invoiceLink;

      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.my_refunds,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () => Navigator.pop(context),
            trailingWidget: Builder(
              builder: (shareContext) => GestureDetector(
                onTap: () async {
                  String? urlToShare = fullUrl;

                  if (!bloc.isValidLink(urlToShare)) {
                    bloc.add(RefundPdfEvent.verifyInvoiceLink(context: context));
                    await Future.delayed(const Duration(milliseconds: 500));
                    urlToShare = bloc.state.invoiceDetailsList?.invoiceLink;
                  }

                  if (bloc.isValidLink(urlToShare)) {
                    final box = shareContext.findRenderObject() as RenderBox?;
                    final origin = box == null ? null : (box.localToGlobal(Offset.zero) & box.size);

                    await _sharePdfFromUrl(
                      context: shareContext,
                      url: urlToShare!,
                      fileNameWithoutExt: 'refund',
                      sharePositionOrigin: origin,
                    );
                  } else {
                    CustomSnackBar.showSnackBar(context: shareContext, title: AppLocalizations.of(context)!.no_invoice_file, type: SnackBarType.failure);
                  }
                },
                child: Icon(Icons.share, color: AppColors.mainColor),
              ),
            ),
          ),
        ),
        body: Builder(builder: (_) {
          if (state.hasValidLink == null) {
            return const SizedBox.shrink();
          }

          if (state.hasValidLink == false || !bloc.isValidLink(fullUrl)) {
            return Center(child: Text(AppLocalizations.of(context)!.no_invoice_file));
          }

          if (_pdfUrl != fullUrl || _pdfBytesFuture == null) {
            _pdfUrl = fullUrl;
            _pdfBytesFuture = _downloadPdfBytes(fullUrl!);
          }

          return FutureBuilder<Uint8List>(
            future: _pdfBytesFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CupertinoActivityIndicator());
              }
              if (snap.hasError || snap.data == null) {
                return Center(child: Text(AppLocalizations.of(context)!.no_invoice_file));
              }

              return SfPdfViewer.memory(
                snap.data!,
                scrollDirection: PdfScrollDirection.vertical,
                pageLayoutMode: PdfPageLayoutMode.continuous,
                canShowScrollHead: true,
                canShowScrollStatus: true,
                canShowPaginationDialog: true,
              );
            },
          );
        }),
      );
    });
  }
}
