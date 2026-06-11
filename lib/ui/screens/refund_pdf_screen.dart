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
import 'package:food_stock/l10n/generated/app_localizations.dart';
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
    final Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => RefundPdfBloc()
        ..add(RefundPdfEvent.getArgumentEvent(
            invoiceDetailsList: args?[AppStrings.invoiceListString],
            context: context)),
      child: RefundPdfScreenWidget(
          invoiceDetailsList: args?[AppStrings.invoiceListString]),
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
  String? _cachedUrl;
  Uint8List? _cachedPdfBytes;
  bool _isCachingPdf = false;
  bool _isPreparingShare = false;
  bool _shareLocked = false;

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

  Future<void> _sharePdf({
    required BuildContext context,
    required String url,
    required String fileNameWithoutExt,
    Rect? sharePositionOrigin,
  }) async {
    if (url.trim().isEmpty || _shareLocked) return;

    setState(() {
      _shareLocked = true;
      _isPreparingShare = true;
    });
    try {
      final bytes = await _getOrDownloadBytes(url);
      final tempDir = await getTemporaryDirectory();
      final rawName = fileNameWithoutExt.trim().isEmpty
          ? 'document'
          : fileNameWithoutExt.trim();
      final safeName = rawName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
      final trimmedName =
          safeName.length > 60 ? safeName.substring(0, 60) : safeName;
      final filePath = '${tempDir.path}/$trimmedName.pdf';
      await File(filePath).writeAsBytes(bytes, flush: true);

      if (mounted) setState(() => _isPreparingShare = false);

      await Share.shareXFiles(
        [XFile(filePath, mimeType: 'application/pdf')],
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (_) {
      if (!context.mounted) return;
      CustomSnackBar.showSnackBar(
          context: context,
          title: AppLocalizations.of(context)!.unable_pdf,
          type: SnackBarType.failure);
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
    return BlocBuilder<RefundPdfBloc, RefundPdfState>(
        builder: (context, state) {
      final bloc = context.read<RefundPdfBloc>();
      final String? fullUrl = state.invoiceDetailsList?.invoiceLink;
      final bool showShareIcon =
          state.hasValidLink == true && bloc.isValidLink(fullUrl);

      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.my_refunds,
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () => Navigator.pop(context),
            trailingWidget: showShareIcon
                ? Builder(
                    builder: (shareContext) => GestureDetector(
                      onTap: _shareLocked
                          ? null
                          : () async {
                              final box =
                                  shareContext.findRenderObject() as RenderBox?;
                              final origin = box == null
                                  ? null
                                  : (box.localToGlobal(Offset.zero) & box.size);

                              await _sharePdf(
                                context: shareContext,
                                url: fullUrl!,
                                fileNameWithoutExt: 'refund',
                                sharePositionOrigin: origin,
                              );
                            },
                      child: _isPreparingShare
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CupertinoActivityIndicator(
                                  color: AppColors.mainColor))
                          : Icon(Icons.share, color: AppColors.mainColor),
                    ),
                  )
                : const SizedBox(),
          ),
        ),
        body: Builder(builder: (_) {
          if (state.hasValidLink == null) {
            return const SizedBox.shrink();
          }

          if (state.hasValidLink == false || !bloc.isValidLink(fullUrl)) {
            return Center(
                child: Text(AppLocalizations.of(context)!.no_invoice_file));
          }

          _startCacheIfNeeded(fullUrl!);

          return SfPdfViewer.network(
            fullUrl,
            key: ValueKey(fullUrl),
            scrollDirection: PdfScrollDirection.vertical,
            pageLayoutMode: PdfPageLayoutMode.continuous,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            canShowPaginationDialog: true,
          );
        }),
      );
    });
  }
}
