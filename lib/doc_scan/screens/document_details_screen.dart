import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';
import '../core/services/invoice_excel_export_payload.dart';
import '../core/services/invoice_excel_export_service.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../core/utils/date_utils.dart';
import '../core/utils/number_utils.dart';
import '../models/invoice_document.dart';
import '../models/invoice_item.dart';
import '../providers/documents_provider.dart';
import '../providers/embedded_ui_provider.dart';
import '../providers/model_provider.dart';
import '../router/app_router.dart';
import '../utils/document_media_resolver.dart';
import '../utils/embedded_app_bar.dart';
import '../widgets/adaptive_bottom_sheet.dart';
import '../widgets/editable_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/retrieve_scan_model_sheet.dart';
import '../widgets/status_badge.dart';
import 'package:food_stock/main.dart' show navigatorKey;
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/constants/app_colors.dart' as fs;

/// ×ž×¡×š × ×ª×•× ×™ ×ž×¡×ž×š â€“ ×›×•×ª×¨×ª, ×ª××¨×™×š ×¡×¨×™×§×”, ×›×¤×ª×•×¨ ×ž×¡×ž×š ×¡×¨×™×§×”, ×›×¨×˜×™×¡ × ×ª×•× ×™× ×›×œ×œ×™×™× ×•×˜×‘×œ×ª ×¤×¨×™×˜×™×.
class DocumentDetailsScreen extends ConsumerStatefulWidget {
  const DocumentDetailsScreen({
    super.key,
    this.document,
    this.embedded = false,
  });

  final InvoiceDocument? document;
  final bool embedded;

  @override
  ConsumerState<DocumentDetailsScreen> createState() =>
      _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState
    extends ConsumerState<DocumentDetailsScreen> {
  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String cancelLabel,
    required String confirmLabel,
    bool barrierDismissible = true,
    bool destructive = false,
  }) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => isIos
          ? CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    cancelLabel,
                    style: const TextStyle(color: AppColors.accentGreen),
                  ),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: destructive,
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(confirmLabel),
                ),
              ],
            )
          : AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(cancelLabel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(confirmLabel),
                ),
              ],
            ),
    );
  }

  bool get _canExportExcel =>
      (_parsedJson != null && _parsedJson!.trim().isNotEmpty) ||
      _items.isNotEmpty;

  Future<void> _exportDocumentToExcel() async {
    if (!_canExportExcel) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final snapshot = _documentSnapshotForPersist();
      final service = InvoiceExcelExportService();
      final exportMap =
          InvoiceExcelExportPayload.buildExportMapFromDocument(snapshot);
      final bytes = await service.buildFromMap(exportMap);
      final dir = await getTemporaryDirectory();
      final safeBase = (snapshot.documentNumber ?? 'invoice').trim();
      final safeName = safeBase.isEmpty
          ? 'invoice'
          : safeBase.replaceAll(RegExp(r'[^\w\-]+'), '_');
      final file = File('${dir.path}/$safeName.xlsx');
      await file.writeAsBytes(bytes);
      if (!mounted) return;
      context.push(
        AppConstants.routeExcelPreview,
        extra: <String, Object?>{
          'document': snapshot,
          'excelPath': file.path,
        },
      );
    } catch (e, st) {
      debugPrint('Excel export failed: $e\n$st');
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.exportExcelFailed)),
      );
    }
  }

  late String _documentType;
  late String _companyName;
  late String _companyId;
  late String _documentNumber;
  late String _documentDate;
  late String _subtotal;
  late String _vatAmount;
  late String _totalAmount;
  String? _parsedJson;
  late List<InvoiceItem> _items;
  String _itemSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _initFromDocument();
  }

  Future<void> _confirmAndDeleteDocument(InvoiceDocument doc) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _showConfirmDialog(
      title: l10n.deleteDocumentTitle,
      message: l10n.deleteDocumentConfirm,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (confirmed != true || !mounted) return;

    HapticFeedback.mediumImpact();
    await ref.read(documentsProvider.notifier).deleteById(doc.id);

    if (widget.embedded) {
      ref.read(embeddedDetailsHeaderActionsProvider.notifier).state = const [];
    }

    final successMessage = l10n.documentDeletedSuccess;
    ref.read(docScanRouterProvider).go(AppConstants.routeHome);

    // Flushbar pushes an overlay route â€” show only after doc-scan navigation
    // completes, on the app root navigator, to avoid go_router conflicts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rootContext = navigatorKey.currentContext;
      if (rootContext == null) return;
      CustomSnackBar.showSnackBar(
        context: rootContext,
        title: successMessage,
        type: SnackBarType.success,
      );
    });
  }

  void _syncEmbeddedHeaderAction(
    InvoiceDocument doc,
    AppLocalizations l10n, {
    required bool isCashSent,
    required bool isProcessing,
    required bool isCompleted,
  }) {
    if (!widget.embedded) return;

    final location =
        resolveEmbeddedDocScanLocation(ref.read(docScanRouterProvider));
    if (location != AppConstants.routeDetails) return;

    final notifier = ref.read(embeddedDetailsHeaderActionsProvider.notifier);
    final actions = <EmbeddedDetailsHeaderAction>[
      EmbeddedDetailsHeaderAction(
        tooltip: l10n.delete,
        icon: CupertinoIcons.trash,
        iconColor: fs.AppColors.redColor,
        onPressed: () => _confirmAndDeleteDocument(doc),
      ),
    ];
    if (!isCashSent &&
        !isProcessing &&
        !isCompleted &&
        canShowRetrieveScanHeaderAction(doc)) {
      actions.add(
        EmbeddedDetailsHeaderAction(
          tooltip: l10n.retrieveDataAgain,
          onPressed: () => showRetrieveScanModelSheet(context, ref, doc),
        ),
      );
    }
    notifier.state = actions;
  }

  @override
  void didUpdateWidget(DocumentDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.document != widget.document) _initFromDocument();
  }

  void _initFromDocument() {
    final doc = widget.document;
    if (doc == null) return;
    _documentType = doc.documentType ?? '';
    _companyName = doc.companyName ?? '';
    _companyId = doc.companyId ?? '';
    _documentNumber = doc.documentNumber ?? '';
    _documentDate = doc.documentDate ?? '';
    _subtotal = doc.subtotal != null ? formatCurrency(doc.subtotal!) : '';
    _vatAmount = doc.vatAmount != null ? formatCurrency(doc.vatAmount!) : '';
    _totalAmount =
        doc.totalAmount != null ? formatCurrency(doc.totalAmount!) : '';
    _parsedJson = doc.parsedJson;
    _items = List<InvoiceItem>.from(doc.items);
  }

  List<InvoiceItem> get _filteredItems {
    if (_itemSearchQuery.trim().isEmpty) return _items;
    final q = _itemSearchQuery.trim().toLowerCase();
    return _items.where((item) {
      final desc = item.description.toLowerCase();
      final num = (item.itemNumber ?? '').toLowerCase();
      return desc.contains(q) || num.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.document == null) {
      return Scaffold(
        appBar: widget.embedded
            ? null
            : AppBar(title: Text(l10n.documentDetails)),
        body: Center(child: Text(l10n.noDocumentSelected)),
      );
    }

    final doc = widget.document!;
    final stillExists =
        ref.watch(documentsProvider).any((d) => d.id == doc.id);
    if (!stillExists) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(docScanRouterProvider).go(AppConstants.routeHome);
      });
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isCashSent = doc.status == DocumentStatus.sentToCashRegister;
    final isProcessing = doc.status == DocumentStatus.processing;
    final isUploading = doc.status == DocumentStatus.uploading;
    final isError = doc.status == DocumentStatus.error;
    final isCompleted = doc.status == DocumentStatus.completed;

    if (widget.embedded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncEmbeddedHeaderAction(
          doc,
          l10n,
          isCashSent: isCashSent,
          isProcessing: isProcessing || isUploading,
          isCompleted: isCompleted,
        );
      });
    }

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
        title: Text(l10n.documentDetails),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            size: 20,
          ),
          onPressed: () => context.go(AppConstants.routeHome),
        ),
        actions: [
          IconButton(
            tooltip: l10n.jsonTitle,
            icon: const Icon(CupertinoIcons.chevron_left_slash_chevron_right),
            onPressed: _parsedJson == null
                ? null
                : () => context.push(
                      AppConstants.routeJsonPreview,
                      extra: _parsedJson,
                    ),
          ),
        ],
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.scanDateLabel(formatDisplayDateTime(doc.createdAt)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StatusBadge(status: doc.status),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (widget.embedded && _parsedJson != null)
                  _topIconActionButton(
                    tooltip: l10n.jsonTitle,
                    icon: CupertinoIcons.chevron_left_slash_chevron_right,
                    enabled: true,
                    onPressed: () => context.push(
                      AppConstants.routeJsonPreview,
                      extra: _parsedJson,
                    ),
                  ),
                if (widget.embedded && _parsedJson != null)
                  const SizedBox(width: 12),
                _topIconActionButton(
                  tooltip: l10n.exportToExcel,
                  icon: Icons.table_chart,
                  enabled: _canExportExcel,
                  onPressed: _canExportExcel ? _exportDocumentToExcel : null,
                ),
                const SizedBox(width: 12),
                if (DocumentMediaResolver.hasPdf(doc))
                  _topIconActionButton(
                    tooltip: l10n.showScanDocument,
                    icon: CupertinoIcons.doc_text,
                    enabled: true,
                    onPressed: () => context.push(
                      AppConstants.routePdfPreview,
                      extra: doc,
                    ),
                  ),
                if (DocumentMediaResolver.hasPdf(doc))
                  const SizedBox(width: 12),
                _topIconActionButton(
                  tooltip: l10n.showScannedImage,
                  icon: CupertinoIcons.photo,
                  enabled: DocumentMediaResolver.hasImages(doc),
                  onPressed: DocumentMediaResolver.hasImages(doc)
                      ? () => context.push(
                            AppConstants.routeImagesPreview,
                            extra: doc,
                          )
                      : null,
                ),
                const SizedBox(width: 12),
                if (!widget.embedded &&
                    !isCashSent &&
                    !isProcessing &&
                    !isUploading &&
                    !isCompleted)
                  _topIconActionButton(
                    tooltip: l10n.retrieveDataAgain,
                    icon: CupertinoIcons.refresh,
                    enabled: canShowRetrieveScanHeaderAction(doc),
                    onPressed: canShowRetrieveScanHeaderAction(doc)
                        ? () => showRetrieveScanModelSheet(context, ref, doc)
                        : null,
                  ),
              ],
            ),
            if ((doc.scanModel ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  availableModels[doc.scanModel] ?? doc.scanModel!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (isError) _buildErrorDiagnostics(context, l10n, doc),
            if (!isProcessing && !isUploading && !isError) ...[
              _buildGeneralCard(context, l10n, isCashSent),
              const SizedBox(height: 8),
              _buildItemsCard(context, l10n, isCashSent),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: isCashSent
          ? null
          : (isProcessing || isUploading || isError)
              ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox.expand(
                          child: GradientButton(
                            label: l10n.save,
                            colors: const [
                              AppColors.headerGradientStart,
                              AppColors.headerGradientEnd,
                            ],
                            onPressed: _onSave,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox.expand(
                          child: Material(
                            borderRadius: BorderRadius.circular(12),
                            elevation: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _onUpdateInCash,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  // Padding ×–×”×” ×œ-`GradientButton` ×©×œ× ×• (vertical: 14)
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.accentGreen.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.accentGreen,
                                    width: 1.2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    l10n.updateInCash,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: AppColors.accentGreen,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ),
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

  Widget _buildErrorDiagnostics(
    BuildContext context,
    AppLocalizations l10n,
    InvoiceDocument doc,
  ) {
    final details = (doc.errorMessage ?? doc.parsedJson ?? '').trim();
    final hasDetails = details.isNotEmpty;
    final text = hasDetails ? details : l10n.parseErrorInternal;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      color: Colors.red.withOpacity(0.06),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(CupertinoIcons.exclamationmark_triangle,
                    color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.statusError,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SelectableText(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Directionality.of(context) == TextDirection.rtl
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: text));
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.copiedToClipboard)),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.doc_on_clipboard,
                      color: Colors.red.shade700,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.copyTooltip,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topIconActionButton({
    required String tooltip,
    required IconData icon,
    required bool enabled,
    required VoidCallback? onPressed,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? onPressed : null,
          child: Tooltip(
            message: tooltip,
            child: Ink(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.accentGreen.withOpacity(0.45),
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: AppColors.accentGreen,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isReadOnly,
  ) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.generalData,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(
              height: 16,
              thickness: 1,
              color: AppColors.divider.withOpacity(0.9),
            ),
            const SizedBox(height: 12),
            // ××–×•×¨ ×¨××©×•×Ÿ: ×©× ×—×‘×¨×” + ×¡×•×’ ×ž×¡×ž×š
            Column(
              children: [
                EditableField(
                  label: l10n.companyName,
                  value: _companyName.isEmpty ? AppConstants.emptyFieldPlaceholder : _companyName,
                  icon: CupertinoIcons.briefcase,
                  onChanged: isReadOnly ? null : (v) => setState(() => _companyName = v),
                ),
                const SizedBox(height: 10),
                EditableField(
                  label: l10n.documentType,
                  value: _documentType.isEmpty ? AppConstants.emptyFieldPlaceholder : _documentType,
                  icon: CupertinoIcons.doc_text,
                  onTap: isReadOnly ? null : _showDocumentTypeSheet,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // ××–×•×¨ ×©× ×™: ×™×ž×™× ×” (×—.×¤ / ×ž×¡×¤×¨ ×ª×¢×•×“×” / ×ª××¨×™×š) ×•×©×ž××œ×” (×œ×œ× ×ž×¢"×ž / ×ž×¢"×ž / ×œ×ª×©×œ×•×)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      EditableField(
                        label: l10n.companyId,
                        value: _companyId.isEmpty ? AppConstants.emptyFieldPlaceholder : _companyId,
                        icon: CupertinoIcons.number,
                        keyboardType: TextInputType.number,
                        onChanged: isReadOnly ? null : (v) => setState(() => _companyId = v),
                      ),
                      const SizedBox(height: 10),
                      EditableField(
                        label: l10n.documentNumber,
                        value: _documentNumber.isEmpty ? AppConstants.emptyFieldPlaceholder : _documentNumber,
                        icon: CupertinoIcons.tag,
                        onChanged: isReadOnly
                            ? null
                            : (v) => setState(() => _documentNumber = v),
                      ),
                      const SizedBox(height: 10),
                      EditableField(
                        label: l10n.documentDate,
                        value: _documentDate.isEmpty ? AppConstants.emptyFieldPlaceholder : _documentDate,
                        icon: CupertinoIcons.calendar,
                        onTap: isReadOnly ? null : _pickDocumentDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      EditableField(
                        label: l10n.subtotalNoVat,
                        value: _subtotal.isEmpty ? AppConstants.emptyFieldPlaceholder : _subtotal,
                        icon: CupertinoIcons.sum,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged:
                            isReadOnly
                                ? null
                                : (v) => setState(
                                      () => _subtotal = _formatAmountForDisplay(v),
                                    ),
                      ),
                      const SizedBox(height: 10),
                      EditableField(
                        label: l10n.vatAmount,
                        value: _vatAmount.isEmpty ? AppConstants.emptyFieldPlaceholder : _vatAmount,
                        icon: CupertinoIcons.percent,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged:
                            isReadOnly
                                ? null
                                : (v) => setState(
                                      () => _vatAmount = _formatAmountForDisplay(v),
                                    ),
                      ),
                      const SizedBox(height: 10),
                      EditableField(
                        label: l10n.totalToPay,
                        value: _totalAmount.isEmpty ? AppConstants.emptyFieldPlaceholder : _totalAmount,
                        icon: CupertinoIcons.money_dollar_circle,
                        isBold: true,
                        valueColor: AppColors.statusCompleted,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: isReadOnly
                            ? null
                            : (v) => setState(
                                  () => _totalAmount = _formatAmountForDisplay(v),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isReadOnly,
  ) {
    final theme = Theme.of(context);
    final filtered = _filteredItems;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.items,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!isReadOnly)
                  TextButton.icon(
                    onPressed: _addNewItem,
                    icon: const Icon(CupertinoIcons.add, size: 20),
                    label: Text(l10n.addItem),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => setState(() => _itemSearchQuery = v),
              decoration: InputDecoration(
                hintText: l10n.searchItemHint,
                prefixIcon: const Icon(CupertinoIcons.search),
                filled: true,
                fillColor: AppColors.background,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: theme.copyWith(
                  // `DataTable` ×‘-Material3 ×™×›×•×œ ×œ×§×—×ª ××ª ×¦×‘×¢ ×”×§×•×•×™× ×“×¨×š:
                  // 1) `dividerColor` / `dividerTheme`
                  // 2) `colorScheme.outline` / `outlineVariant`
                  dividerColor: AppColors.divider,
                  dividerTheme: const DividerThemeData(
                    color: AppColors.divider,
                    thickness: 1,
                  ),
                  colorScheme: theme.colorScheme.copyWith(
                    outline: AppColors.divider,
                    outlineVariant: AppColors.divider,
                  ),
                ),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.accentGreen.withOpacity(0.08),
                  ),
                  headingTextStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.accentGreen,
                  ),
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 52,
                  horizontalMargin: 0,
                  columnSpacing: 12,
                  columns: [
                    const DataColumn(label: SizedBox.shrink()),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(l10n.colItemNumber, textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          l10n.colItemDescription,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(l10n.colUnits, textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(l10n.colPackages, textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(l10n.colQuantity, textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(
                          l10n.colPricePerUnit,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(l10n.colTotalNis, textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                  rows: filtered.asMap().entries.map((entry) {
                    final item = entry.value;
                    final globalIndex = _items.indexOf(item);
                    return DataRow(
                      color:
                          WidgetStateProperty.resolveWith<Color?>((states) {
                        // ×¤×¡ ×¢×“×™×Ÿ ×œ×”×¤×¨×“×ª ×©×•×¨×•×ª (×ž×•×“×¨× ×™ ×™×•×ª×¨).
                        final isEven = entry.key % 2 == 0;
                        return isEven
                            ? AppColors.accentGreen.withOpacity(0.035)
                            : null;
                      }),
                      cells: [
                        isReadOnly
                            ? const DataCell(SizedBox.shrink())
                            : _deleteCell(globalIndex),
                        isReadOnly
                            ? _cellReadOnly(item.itemNumber ?? AppConstants.emptyFieldPlaceholder)
                            : _cell(
                                item.itemNumber ?? AppConstants.emptyFieldPlaceholder,
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colItemNumber,
                                  item.itemNumber ?? '',
                                  (v) {
                                    setState(() {
                                      _items[globalIndex] = item.copyWith(
                                        itemNumber: v.isEmpty ? null : v,
                                      );
                                    });
                                  },
                                ),
                              ),
                        isReadOnly
                            ? _cellReadOnlyRight(item.description)
                            : _cellRight(
                                item.description,
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colItemDescription,
                                  item.description,
                                  (v) {
                                    setState(() {
                                      _items[globalIndex] =
                                          item.copyWith(description: v);
                                    });
                                  },
                                ),
                              ),
                        isReadOnly
                            ? _cellReadOnly(
                                displayOptionalInt(item.units))
                            : _cell(
                                displayOptionalInt(item.units),
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colUnits,
                                  item.units?.toString() ?? '',
                                  (v) {
                                    final n = int.tryParse(v);
                                    if (n == null) return;
                                    setState(() {
                                      _items[globalIndex] = item.copyWith(
                                        units: v.isEmpty ? null : n,
                                      );
                                    });
                                  },
                                ),
                              ),
                        isReadOnly
                            ? _cellReadOnly(displayOptionalInt(item.packages))
                            : _cell(
                                displayOptionalInt(item.packages),
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colPackages,
                                  item.packages?.toString() ?? '',
                                  (v) {
                                    final n = int.tryParse(v);
                                    setState(() {
                                      _items[globalIndex] = item.copyWith(
                                        packages: v.isEmpty ? null : n,
                                      );
                                    });
                                  },
                                ),
                              ),
                        isReadOnly
                            ? _cellReadOnly(item.quantity.toString())
                            : _cell(
                                item.quantity.toString(),
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colQuantity,
                                  item.quantity.toString(),
                                  (v) {
                                    final n = double.tryParse(v);
                                    if (n == null) return;
                                    setState(() {
                                      _items[globalIndex] = item.copyWith(
                                        quantity: n,
                                        totalPrice: n * item.pricePerUnit,
                                      );
                                    });
                                  },
                                ),
                              ),
                        isReadOnly
                            ? _cellReadOnly(formatCurrency(item.pricePerUnit))
                            : _cell(
                                formatCurrency(item.pricePerUnit),
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colPricePerUnit,
                                  item.pricePerUnit.toString(),
                                  (v) {
                                    final n = double.tryParse(v);
                                    if (n == null) return;
                                    setState(() {
                                      _items[globalIndex] = item.copyWith(
                                        pricePerUnit: n,
                                        totalPrice: item.quantity * n,
                                      );
                                    });
                                  },
                                ),
                              ),
                        isReadOnly
                            ? _cellReadOnly(formatCurrency(item.totalPrice))
                            : _cell(
                                formatCurrency(item.totalPrice),
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colTotalNis,
                                  item.totalPrice.toString(),
                                  (v) {
                                    final n = double.tryParse(v);
                                    if (n == null) return;
                                    setState(() {
                                      _items[globalIndex] =
                                          item.copyWith(totalPrice: n);
                                    });
                                  },
                                ),
                              ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataCell _cellReadOnly(String text) {
    return DataCell(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  DataCell _cellReadOnlyRight(String text) {
    return DataCell(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            text,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  DataCell _cell(String text, VoidCallback onTap) {
    return DataCell(
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  DataCell _cellRight(String text, VoidCallback onTap) {
    return DataCell(
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              text,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  DataCell _deleteCell(int globalIndex) {
    return DataCell(
      IconButton(
        icon: const Icon(CupertinoIcons.trash),
        color: Colors.red,
        onPressed: () => _confirmDeleteRow(globalIndex),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }

  void _confirmDeleteRow(int globalIndex) {
    final l10n = AppLocalizations.of(context);
    _showConfirmDialog(
      title: l10n.deleteRowTitle,
      message: l10n.deleteRowConfirm,
      cancelLabel: l10n.no,
      confirmLabel: l10n.yes,
      destructive: true,
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        setState(() {
          _items.removeAt(globalIndex);
          _renumberLineNumbers();
        });
      }
    });
  }

  void _renumberLineNumbers() {
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (item.lineNumber != i + 1) {
        _items[i] = item.copyWith(lineNumber: i + 1);
      }
    }
  }

  void _addNewItem() {
    final nextLine = _items.isEmpty
        ? 1
        : _items.map((e) => e.lineNumber).reduce((a, b) => a > b ? a : b) + 1;
    final newItem = InvoiceItem(
      lineNumber: nextLine,
      description: '',
      quantity: 0,
      pricePerUnit: 0,
      totalPrice: 0,
    );
    setState(() => _items.add(newItem));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final idx = _items.length - 1;
      final l10n = AppLocalizations.of(context);
      _editItemCell(
        context,
        l10n,
        idx,
        l10n.colItemDescription,
        '',
        (v) {
          if (!mounted) return;
          setState(() {
            _items[idx] = _items[idx].copyWith(description: v);
          });
        },
      );
    });
  }

  static const Color _actionSheetGreen = AppColors.accentGreen;

  void _editItemCell(
    BuildContext context,
    AppLocalizations l10n,
    int index,
    String label,
    String value,
    ValueChanged<String> onSaved,
  ) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: value);
    final isIntNumber = label.contains(l10n.colItemNumber) ||
        label.contains(l10n.colQuantity) ||
        label.contains(l10n.colPackages) ||
        label.contains(l10n.colUnits);
    final isDecimalNumber =
        label.contains(l10n.colPricePerUnit) ||
        label.contains(l10n.colTotalNis);
    showAdaptiveBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _actionSheetGreen,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: isIntNumber
                      ? TextInputType.number
                      : isDecimalNumber
                          ? const TextInputType.numberWithOptions(
                              decimal: true,
                            )
                          : TextInputType.text,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.accentGreen),
                    ),
                  ),
                  onSubmitted: (_) {
                    onSaved(controller.text);
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _actionSheetGreen,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientButton(
                        label: l10n.update,
                        colors: const [
                          AppColors.headerGradientStart,
                          AppColors.headerGradientEnd,
                        ],
                        onPressed: () {
                          onSaved(controller.text);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDocumentTypeSheet() {
    final l10n = AppLocalizations.of(context);
    final options = [
      l10n.docTypeInvoice,
      l10n.docTypeDelivery,
      l10n.docTypeReturn,
      l10n.docTypeOther,
    ];
    showAdaptiveBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.chooseDocumentType,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _actionSheetGreen,
                  ),
                ),
                const SizedBox(height: 16),
                ...options.map((opt) {
                  final isOther = opt == l10n.docTypeOther;
                  return ListTile(
                    title: Text(opt),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      if (!isOther) {
                        setState(() => _documentType = opt);
                      } else {
                        _showCustomDocumentTypeSheet();
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomDocumentTypeSheet() {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: '');
    showAdaptiveBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.enterDocumentType,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _actionSheetGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: l10n.documentTypeLabel,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      isDense: true,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _actionSheetGreen,
                        ),
                      ),
                    ),
                    onSubmitted: (v) {
                      final value = v.trim().isEmpty ? l10n.docTypeOther : v.trim();
                      setState(() => _documentType = value);
                      Navigator.of(ctx).pop();
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _actionSheetGreen,
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GradientButton(
                          label: l10n.update,
                          colors: const [
                            AppColors.headerGradientStart,
                            AppColors.headerGradientEnd,
                          ],
                          onPressed: () {
                            final value =
                                controller.text.trim().isEmpty
                                    ? l10n.docTypeOther
                                    : controller.text.trim();
                            setState(() => _documentType = value);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDocumentDate() async {
    final now = DateTime.now();
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    DateTime? picked;
    if (isIos) {
      final initialDate = now;
      final firstDate = DateTime(2000);
      final lastDate = DateTime(now.year + 5);
      DateTime tempPicked = initialDate;
      picked = await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (ctx) {
          final l10n = AppLocalizations.of(ctx);
          return Container(
            height: 320,
            color: CupertinoColors.systemBackground.resolveFrom(ctx),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  SizedBox(
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(
                            l10n.cancel,
                            style: const TextStyle(color: AppColors.accentGreen),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.headerGradientStart,
                                  AppColors.headerGradientEnd,
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CupertinoButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              borderRadius: BorderRadius.circular(10),
                              onPressed: () => Navigator.of(ctx).pop(tempPicked),
                              child: Text(
                                l10n.update,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initialDate,
                      minimumDate: firstDate,
                      maximumDate: lastDate,
                      onDateTimeChanged: (value) => tempPicked = value,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2000),
        lastDate: DateTime(now.year + 5),
        helpText: AppLocalizations.of(context).pickDocumentDate,
      );
    }
    if (picked != null) {
      final selectedDate = picked;
      setState(() {
        _documentDate = formatDisplayDate(selectedDate);
      });
    }
  }

  /// ×ž×¦×‘ ×ž×¡×ž×š ×ž×”×©×“×•×ª ×‘Ö¾UI (×œ×¤× ×™ ×©×™× ×•×™ ×¡×˜×˜×•×¡) â€” ×œ×©×ž×™×¨×”, ×©×œ×™×—×” ×œ×§×•×¤×” ×•×™×™×¦×•× ××§×¡×œ.
  InvoiceDocument _documentSnapshotForPersist() {
    final original = widget.document!;
    return InvoiceDocument(
      id: original.id,
      createdAt: original.createdAt,
      status: original.status,
      pdfPath: original.pdfPath,
      pdfUrl: original.pdfUrl,
      jobId: original.jobId,
      imagePaths: original.imagePaths,
      imageUrls: original.imageUrls,
      documentType: _documentType.isEmpty ? original.documentType : _documentType,
      companyName: _companyName.isEmpty ? original.companyName : _companyName,
      companyId: _companyId.isEmpty ? original.companyId : _companyId,
      documentNumber:
          _documentNumber.isEmpty ? original.documentNumber : _documentNumber,
      documentDate:
          _documentDate.isEmpty ? original.documentDate : _documentDate,
      subtotal: _parseAmount(_subtotal, fallback: original.subtotal),
      vatAmount: _parseAmount(_vatAmount, fallback: original.vatAmount),
      totalAmount: _parseAmount(_totalAmount, fallback: original.totalAmount),
      parsedJson: _parsedJson ?? original.parsedJson,
      errorMessage: original.errorMessage,
      scanModel: original.scanModel,
      items: _items,
    );
  }

  void _onSave() {
    final original = widget.document;
    if (original == null) {
      // ×œ×œ× ×ž×¡×ž×š ×ž×§×•×¨×™ â€“ ×‘×©×œ×‘ ×–×” ×œ× ×ž×•×¡×™×¤×™× ×œ×¨×©×™×ž×”.
      context.go(AppConstants.routeHome);
      return;
    }

    HapticFeedback.lightImpact();

    final updated = _documentSnapshotForPersist().copyWith(
      status: DocumentStatus.completed,
    );

    ref.read(documentsProvider.notifier).upsert(updated);
    context.go(AppConstants.routeHome);
  }

  void _onUpdateInCash() {
    final original = widget.document;
    if (original == null) {
      context.go(AppConstants.routeHome);
      return;
    }

    final l10n = AppLocalizations.of(context);

    _showConfirmDialog(
      title: l10n.confirmSendToCashTitle,
      message: l10n.confirmSendToCashMessage,
      cancelLabel: l10n.no,
      confirmLabel: l10n.yes,
      barrierDismissible: false,
    ).then((confirmed) {
      if (confirmed != true || !mounted) return;

      HapticFeedback.lightImpact();

      final updated = _documentSnapshotForPersist().copyWith(
        status: DocumentStatus.sentToCashRegister,
      );

      ref.read(documentsProvider.notifier).upsert(updated);
      context.go(AppConstants.routeHome);
    });
  }

  double? _parseAmount(String raw, {double? fallback}) {
    final normalized = raw
        .replaceAll(RegExp(r'[^0-9,.\-]'), '')
        .replaceAll(',', '')
        .trim();
    if (normalized.isEmpty) return fallback;
    return double.tryParse(normalized) ?? fallback;
  }

  String _formatAmountForDisplay(String raw) {
    final normalized = raw
        .replaceAll(RegExp(r'[^0-9,.\-]'), '')
        .replaceAll(',', '.')
        .trim();
    if (normalized.isEmpty) return '';
    final parsed = double.tryParse(normalized);
    if (parsed == null) return raw.trim();
    return formatCurrency(parsed);
  }
}
