import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/services/client_scanned_certificate_sync_service.dart';
import '../core/services/document_parser_service.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/invoice_document.dart';
import '../providers/document_parser_provider.dart';
import '../providers/documents_provider.dart';
import '../providers/model_provider.dart';

/// Processing screen – animated steps and Cloud Function `parseInvoice` submission.
/// Shows extracted JSON on the document details screen.
class ProcessingScreen extends ConsumerStatefulWidget {
  const ProcessingScreen({
    super.key,
    this.pdfPath,
    this.imagePaths,
    this.didTryImageExport = false,
    this.imageExportError,
    this.targetDocumentId,
    this.targetCreatedAt,
    this.initialDocumentType,
    this.initialSupplierName,
  });

  final String? pdfPath;
  final List<String>? imagePaths;
  final bool didTryImageExport;
  final String? imageExportError;
  final String? targetDocumentId;
  final DateTime? targetCreatedAt;
  final String? initialDocumentType;
  final String? initialSupplierName;

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  int _subtitleIndex = 0;
  Timer? _subtitleTimer;

  bool get _isRetry => widget.targetDocumentId != null;

  InvoiceDocument? _getTargetDocument() {
    final id = widget.targetDocumentId;
    if (id == null) return null;
    return ref.read(documentsProvider.notifier).getDocument(id);
  }

  Future<void> _showImageExportFailedDialog({
    required List<String> expectedImagePaths,
    required List<String> existingImagePaths,
    String? error,
    String? pdfPath,
  }) async {
    final l10n = AppLocalizations.of(context);
    final debugText =
        <String>[
          l10n.imageExportDebugIntro,
          if (error != null && error.isNotEmpty)
            l10n.imageExportErrorLine(error),
          l10n.imageExportExpectedImages(expectedImagePaths.length),
          l10n.imageExportExistingImages(existingImagePaths.length),
          if (pdfPath != null && pdfPath.isNotEmpty) l10n.imageExportPdfPath(pdfPath),
        ].join('\n');

    final pathsPreview = expectedImagePaths.take(10).map((e) => '- $e');
    final fullMessage = <String>[
      debugText,
      if (expectedImagePaths.isNotEmpty)
        l10n.imageExportPathExamples(pathsPreview.join('\n')),
    ].join('\n\n');

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final isIos = Theme.of(dialogContext).platform == TargetPlatform.iOS;
        if (isIos) {
          return CupertinoAlertDialog(
            title: Text(l10n.imageExportFailureTitle),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SingleChildScrollView(
                child: SelectableText(
                  fullMessage,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: fullMessage));
                  if (!mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.copiedToClipboard)),
                  );
                },
                child: Text(l10n.copyTooltip),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.continueButton),
              ),
            ],
          );
        }

        return AlertDialog(
          title: Row(
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle, size: 22),
              const SizedBox(width: 8),
                      Text(l10n.imageExportFailureTitle),
              const Spacer(),
              IconButton(
                        tooltip: l10n.copyTooltip,
                icon: const Icon(CupertinoIcons.doc_on_clipboard),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: fullMessage),
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text(l10n.copiedToClipboard)),
                  );
                },
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: SingleChildScrollView(
              child: SelectableText(
                fullMessage,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.continueButton),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _subtitleTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (mounted) {
        setState(() {
          _subtitleIndex = (_subtitleIndex + 1) % 4;
        });
      }
    });
    // חשוב: _runParseAndNavigate משתמש ב־AppLocalizations.of(context),
    // וזה עלול לזרוק חריגה אם קוראים לזה לפני ש־initState הסתיים.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _runParseAndNavigate();
    });
  }

  Future<void> _runParseAndNavigate() async {
    final l10n = AppLocalizations.of(context);
    final pdfPath = widget.pdfPath;
    final imagePaths = widget.imagePaths ?? const [];
    final parser = ref.read(documentParserProvider);
    final selectedModel = await resolveSelectedModel(ref);
    debugPrint('[ProcessingScreen] using scan model: $selectedModel');

    final imageFiles = imagePaths
        .map((p) => File(p))
        .where((f) => f.path.isNotEmpty)
        .toList(growable: false);

    final filteredImageFiles = <File>[];
    for (final f in imageFiles) {
      if (await f.exists()) filteredImageFiles.add(f);
    }

    // אם יש תמונות קיימות – יוצרים רשומה, עוברים הביתה, ושולחים ל-Firebase ברקע.
    if (filteredImageFiles.isNotEmpty) {
      _subtitleTimer?.cancel();
      final now = DateTime.now();
      final existing = _getTargetDocument();
      final notifier = ref.read(documentsProvider.notifier);
      final resolvedImagePaths =
          filteredImageFiles.map((e) => e.path).toList(growable: false);

      late final String localDocumentId;
      late final DateTime localCreatedAt;

      if (_isRetry) {
        localDocumentId = widget.targetDocumentId!;
        localCreatedAt =
            widget.targetCreatedAt ?? existing?.createdAt ?? DateTime.now();
        notifier.upsert(
          InvoiceDocument(
            id: localDocumentId,
            createdAt: localCreatedAt,
            status: DocumentStatus.uploading,
            pdfPath: pdfPath ?? existing?.pdfPath,
            pdfUrl: existing?.pdfUrl,
            imagePaths: resolvedImagePaths,
            imageUrls: existing?.imageUrls ?? const [],
            documentType: existing?.documentType ?? widget.initialDocumentType,
            companyName: existing?.companyName ?? widget.initialSupplierName,
            companyId: existing?.companyId,
            documentNumber: existing?.documentNumber,
            documentDate: existing?.documentDate,
            subtotal: existing?.subtotal,
            vatAmount: existing?.vatAmount,
            totalAmount: existing?.totalAmount,
            parsedJson: existing?.parsedJson,
            scanModel: selectedModel,
            items: existing?.items ?? const [],
          ),
        );
      } else {
        localDocumentId = const Uuid().v4();
        localCreatedAt = now;
        notifier.addDocument(
          InvoiceDocument(
            id: localDocumentId,
            createdAt: localCreatedAt,
            status: DocumentStatus.uploading,
            pdfPath: pdfPath,
            imagePaths: resolvedImagePaths,
            documentType: widget.initialDocumentType,
            companyName: widget.initialSupplierName?.trim().isEmpty ?? true
                ? null
                : widget.initialSupplierName?.trim(),
            scanModel: selectedModel,
            items: const [],
          ),
        );
      }

      if (!mounted) return;
      context.go(AppConstants.routeHome);

      unawaited(
        _submitScanJobInBackground(
          parser: parser,
          notifier: notifier,
          localDocumentId: localDocumentId,
          localCreatedAt: localCreatedAt,
          pdfPath: pdfPath ?? existing?.pdfPath,
          imageFiles: filteredImageFiles,
          model: selectedModel,
        ),
      );
      return;
    }

    // אם ניסינו לייצא תמונות (ב-Real scan) אבל אין תמונות תקינות – לא נשלח PDF ל-API.
    if (widget.didTryImageExport) {
      _subtitleTimer?.cancel();
      await _showImageExportFailedDialog(
        expectedImagePaths: imagePaths,
        existingImagePaths: filteredImageFiles.map((e) => e.path).toList(),
        error: widget.imageExportError,
        pdfPath: pdfPath,
      );
      if (!mounted) return;
      if (_isRetry) {
        final existing = _getTargetDocument();
        if (existing != null) {
          context.push(AppConstants.routeDetails, extra: existing);
        } else {
          _finishWithEmptyDocument(pdfPath: pdfPath, imagePaths: imagePaths);
        }
      } else {
        _finishWithEmptyDocument(pdfPath: pdfPath, imagePaths: imagePaths);
      }
      return;
    }

    // אין תמונות זמינות לשליחה (ללא fallback ל-PDF בזרימת async).
    if (!mounted) return;
    _subtitleTimer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.noValidImagesToSend)),
    );
    if (_isRetry) {
      final existing = _getTargetDocument();
      if (existing != null) {
        context.push(AppConstants.routeDetails, extra: existing);
      }
      return;
    }

    // לא להשאיר את המשתמש תקוע במסך עיבוד ללא תוצאה:
    // ניצור רשומה מקומית ריקה ונעבור הביתה.
    final doc = InvoiceDocument(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      status: DocumentStatus.readyForUpdate,
      pdfPath: pdfPath,
      imagePaths: imagePaths,
      documentType: widget.initialDocumentType,
      companyName: widget.initialSupplierName,
    );
    ref.read(documentsProvider.notifier).addDocument(doc);
    context.go(AppConstants.routeHome);
  }

  Future<void> _submitScanJobInBackground({
    required DocumentParserService parser,
    required DocumentsNotifier notifier,
    required String localDocumentId,
    required DateTime localCreatedAt,
    required String? pdfPath,
    required List<File> imageFiles,
    required String model,
  }) async {
    final imagePaths =
        imageFiles.map((file) => file.path).toList(growable: false);
    final syncService = ClientScannedCertificateSyncService();

    try {
      final imageMeta = await Future.wait(
        imageFiles.map((file) async {
          final len = await file.length();
          return '${p.basename(file.path)} (${(len / 1024).toStringAsFixed(0)}KB)';
        }),
      );
      debugPrint(
        '[ProcessingScreen] background uploads: '
        'count=${imageFiles.length}, files=$imageMeta',
      );

      final current = notifier.getDocument(localDocumentId);
      if (current == null) return;

      final uploadDoc = current.copyWith(
        pdfPath: pdfPath ?? current.pdfPath,
        imagePaths: imagePaths,
        scanModel: model,
      );

      final results = await Future.wait<Object?>([
        syncService.uploadFiles(uploadDoc),
        parser.submitScanJob(imageFiles, model: model),
      ]);

      final storageKeys =
          results[0] as ({String? pdfUrl, List<String> imageUrls});
      final jobId = results[1] as String;

      final latest = notifier.getDocument(localDocumentId);
      if (latest == null) return;

      final processingDoc = latest.copyWith(
        id: localDocumentId,
        createdAt: localCreatedAt,
        status: DocumentStatus.processing,
        jobId: jobId,
        pdfPath: pdfPath ?? latest.pdfPath,
        pdfUrl: storageKeys.pdfUrl ?? latest.pdfUrl,
        imagePaths: imagePaths,
        imageUrls: storageKeys.imageUrls.isNotEmpty
            ? storageKeys.imageUrls
            : latest.imageUrls,
        scanModel: model,
        errorMessage: null,
      );
      notifier.upsert(processingDoc, syncToServer: false);

      unawaited(
        syncService.sync(
          processingDoc,
          pdfUrl: storageKeys.pdfUrl,
          imageUrls: storageKeys.imageUrls,
          uploadFiles: false,
        ),
      );

      debugPrint(
        '[ProcessingScreen] uploads completed jobId=$jobId '
        'pdfUrl=${storageKeys.pdfUrl}',
      );
    } on DocumentParseException catch (e) {
      debugPrint(
        '[ProcessingScreen] background upload/submit failed: '
        'code=${e.code} params=${e.params} original=${e.originalError}',
      );
      final current = notifier.getDocument(localDocumentId);
      if (current != null) {
        unawaited(syncService.uploadFiles(current));
      }
      await _runDirectParseFallbackInBackground(
        parser: parser,
        notifier: notifier,
        localDocumentId: localDocumentId,
        localCreatedAt: localCreatedAt,
        pdfPath: pdfPath,
        imagePaths: imagePaths,
        model: model,
      );
    } catch (e) {
      debugPrint('[ProcessingScreen] background uploads unexpected: $e');
      final current = notifier.getDocument(localDocumentId);
      if (current != null) {
        notifier.upsert(
          current.copyWith(
            status: DocumentStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _runDirectParseFallbackInBackground({
    required DocumentParserService parser,
    required DocumentsNotifier notifier,
    required String localDocumentId,
    required DateTime localCreatedAt,
    required String? pdfPath,
    required List<String> imagePaths,
    required String model,
  }) async {
    try {
      debugPrint(
        '[ProcessingScreen] background fallback started for doc=$localDocumentId model=$model',
      );
      final files = imagePaths.map(File.new).toList(growable: false);
      final parsed = await parser.parseImages(files, model: model);
      final current = notifier.getDocument(localDocumentId);
      final parsedDoc = parsed.toInvoiceDocument(
        pdfPath: pdfPath ?? current?.pdfPath,
        imagePaths: imagePaths,
      );
      notifier.upsert(
        parsedDoc.copyWith(
          id: localDocumentId,
          createdAt: localCreatedAt,
          status: DocumentStatus.readyForUpdate,
          jobId: null,
          pdfPath: pdfPath ?? current?.pdfPath,
          imagePaths: imagePaths,
          documentType: parsedDoc.documentType ?? current?.documentType,
          companyName: parsedDoc.companyName ?? current?.companyName,
          companyId: parsedDoc.companyId ?? current?.companyId,
          scanModel: model,
          errorMessage: null,
        ),
      );
      debugPrint(
        '[ProcessingScreen] background fallback completed for doc=$localDocumentId',
      );
    } catch (fallbackError) {
      debugPrint(
        '[ProcessingScreen] parseImages background fallback failed: $fallbackError',
      );
      final current = notifier.getDocument(localDocumentId);
      if (current != null) {
        notifier.upsert(
          current.copyWith(
            status: DocumentStatus.error,
            errorMessage: fallbackError.toString(),
          ),
        );
      }
    }
  }

  void _finishWithEmptyDocument({
    required String? pdfPath,
    required List<String> imagePaths,
  }) {
    if (!mounted) return;
    final doc = InvoiceDocument(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      status: DocumentStatus.readyForUpdate,
      pdfPath: pdfPath,
      imagePaths: imagePaths,
      items: const [],
    );
    ref.read(documentsProvider.notifier).addDocument(doc);
    context.push(AppConstants.routeDetails, extra: doc);
  }

  @override
  void dispose() {
    _subtitleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final subtitles = [
      l10n.processingSub1,
      l10n.processingSub2,
      l10n.processingSub3,
      l10n.processingSub4,
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.processingTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    subtitles[_subtitleIndex],
                    key: ValueKey<int>(_subtitleIndex),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
