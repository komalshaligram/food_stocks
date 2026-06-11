import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/invoice_document.dart';
import '../providers/embedded_ui_provider.dart';
import '../router/app_router.dart';
import '../utils/document_media_resolver.dart';
import '../utils/embedded_app_bar.dart';
import '../widgets/gradient_button.dart';

/// מסך תצוגת PDF – קובץ מקומי או S3.
class PdfPreviewScreen extends ConsumerStatefulWidget {
  const PdfPreviewScreen({
    super.key,
    this.document,
    this.embedded = false,
  });

  final InvoiceDocument? document;
  final bool embedded;

  @override
  ConsumerState<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends ConsumerState<PdfPreviewScreen> {
  PdfController? _pdfController;
  bool _isLoading = true;
  String? _loadError;
  ResolvedDocumentMedia? _resolvedPdf;
  File? _downloadedPdfFile;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final document = widget.document;
    if (document == null) {
      setState(() {
        _isLoading = false;
        _loadError = 'no_path';
      });
      return;
    }

    try {
      final resolved = await DocumentMediaResolver.resolvePdf(document);
      if (resolved == null) {
        setState(() {
          _isLoading = false;
          _loadError = 'no_path';
        });
        return;
      }

      final PdfDocument pdfDocument;
      if (resolved.isLocal) {
        pdfDocument = await PdfDocument.openFile(resolved.pathOrUrl);
      } else {
        final response = await http.get(Uri.parse(resolved.pathOrUrl));
        if (response.statusCode != 200) {
          setState(() {
            _isLoading = false;
            _loadError = 'not_found';
          });
          return;
        }
        pdfDocument = await PdfDocument.openData(
          Uint8List.fromList(response.bodyBytes),
        );
      }

      final controller = PdfController(document: Future.value(pdfDocument));
      if (mounted) {
        setState(() {
          _resolvedPdf = resolved;
          _pdfController = controller;
          _isLoading = false;
          _loadError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  Future<File?> _resolveShareablePdfFile() async {
    final resolved = _resolvedPdf ??
        (widget.document == null
            ? null
            : await DocumentMediaResolver.resolvePdf(widget.document!));
    if (resolved == null) return null;

    if (resolved.isLocal) {
      final file = File(resolved.pathOrUrl);
      if (await file.exists()) return file;
      return null;
    }

    _downloadedPdfFile ??= await DocumentMediaResolver.downloadToTempFile(
      url: resolved.pathOrUrl,
      fileName: 'scanned_document.pdf',
    );
    return _downloadedPdfFile;
  }

  Future<void> _sharePdf() async {
    final l10n = AppLocalizations.of(context);
    final file = await _resolveShareablePdfFile();
    if (file == null || !await file.exists()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.fileNotFound)),
        );
      }
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: l10n.shareScannedDocument,
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.shareError(e.toString()))),
        );
      }
    }
  }

  void _syncEmbeddedHeaderAction(AppLocalizations l10n) {
    if (!widget.embedded) return;

    final location =
        resolveEmbeddedDocScanLocation(ref.read(docScanRouterProvider));
    if (location != AppConstants.routePdfPreview) return;

    final notifier = ref.read(embeddedDetailsHeaderActionsProvider.notifier);
    final canShare = _resolvedPdf != null ||
        (widget.document?.pdfPath?.isNotEmpty ?? false) ||
        (widget.document?.pdfUrl?.isNotEmpty ?? false);
    if (canShare) {
      notifier.state = [
        EmbeddedDetailsHeaderAction(
          tooltip: l10n.share,
          icon: CupertinoIcons.share,
          onPressed: _sharePdf,
        ),
      ];
    } else {
      notifier.state = const [];
    }
  }

  PreferredSizeWidget _buildStandaloneAppBar(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final canShare = _resolvedPdf != null ||
        (widget.document?.pdfPath?.isNotEmpty ?? false) ||
        (widget.document?.pdfUrl?.isNotEmpty ?? false);

    return AppBar(
      title: Text(l10n.pdfPreviewTitle),
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.back,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              AppColors.headerGradientStart,
              AppColors.headerGradientEnd,
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.share),
          onPressed: canShare ? _sharePdf : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (widget.embedded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncEmbeddedHeaderAction(l10n);
      });
    }

    return Scaffold(
      appBar: widget.embedded
          ? null
          : _buildStandaloneAppBar(context, l10n, theme),
      body: _buildBody(theme, l10n),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pdfController != null) {
      return PdfView(
        controller: _pdfController!,
        scrollDirection: Axis.vertical,
        onDocumentError: (err) {
          if (!mounted) return;
          final old = _pdfController;
          setState(() {
            _loadError = err.toString();
            _pdfController = null;
          });
          old?.dispose();
        },
        builders: PdfViewBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return _buildPlaceholder(theme, l10n);
  }

  Widget _buildPlaceholder(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.doc_text,
                size: 64,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _loadError != null ? l10n.unableToLoadDocument : l10n.pdfAvailable,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.pdfDemoHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GradientButton(
              label: l10n.share,
              icon: const Icon(CupertinoIcons.share),
              colors: const [
                AppColors.headerGradientStart,
                AppColors.headerGradientEnd,
              ],
              onPressed: _resolvedPdf != null ? _sharePdf : null,
            ),
          ],
        ),
      ),
    );
  }
}
