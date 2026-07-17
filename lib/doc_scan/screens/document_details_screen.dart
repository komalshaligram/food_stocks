import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../bootstrap/doc_scan_bootstrap.dart';
import '../core/constants/app_constants.dart';
import '../core/services/invoice_api_client.dart';
import '../core/services/invoice_excel_export_payload.dart';
import '../core/services/invoice_excel_export_service.dart';
import '../core/services/invoice_validation_payload.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../core/utils/date_utils.dart';
import '../core/utils/number_utils.dart';
import '../models/invoice_document.dart';
import '../models/invoice_item.dart';
import '../models/resolved_item.dart';
import '../models/comax_document_status.dart';
import '../core/services/invoice_items_resolver_service.dart';
import '../core/services/invoice_consistency.dart';
import '../models/product.dart';
import '../models/supplier.dart';
import '../providers/customer_code_provider.dart';
import '../providers/documents_provider.dart';
import '../providers/embedded_ui_provider.dart';
import '../providers/model_provider.dart';
import '../providers/products_provider.dart';
import '../providers/supplier_code_cache_provider.dart';
import '../providers/suppliers_provider.dart';
import '../router/app_router.dart';
import '../utils/document_media_resolver.dart';
import '../utils/embedded_app_bar.dart';
import '../widgets/adaptive_bottom_sheet.dart';
import '../widgets/editable_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/pre_scan_setup_sheet.dart';
import '../widgets/retrieve_scan_model_sheet.dart';
import '../widgets/searchable_picker.dart';
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

  /// קוד הספק שנבחר מהרשימה — נשלח ב-header.supplierCode (גובר על ח.פ; מזהה ספק
  /// מדויק גם כשלאותה ישות יש כמה רשומות, רשת מול "לעסקים"). null עד שהמשתמש בוחר.
  String? _supplierCode;
  late String _companyId;
  late String _documentNumber;
  late String _documentDate;
  late String _subtotal;
  late String _vatAmount;
  late String _totalAmount;

  /// הנחה ברמת המסמך כפי שנקראה מה-OCR — נשמרת בין עריכות שורה כדי שלא
  /// "תיעלם" מהסכום ביניים. 0 כשאין הנחה כללית.
  double _documentDiscount = 0;

  /// הסה"כ שה-OCR קרא מבלוק הסיכום — נשמר גם אחרי שהתצוגה מוחלפת בערך המחושב,
  /// כדי להשוות ולהזהיר על פער. null כשה-OCR לא קרא סיכום.
  double? _ocrSubtotal;
  double? _ocrTotal;

  /// שיעור המע"מ של המסמך, נגזר מהערכים שבמסמך עצמו ולא מקובע —
  /// חשבוניות אילת (0%) וחשבוניות ישנות (17%) חייבות להישמר כפי שהן.
  double _vatRate = _defaultVatRate;
  late String _allocationNumber;
  late String _paymentDueDate;
  String? _parsedJson;
  late List<InvoiceItem> _items;
  String _itemSearchQuery = '';

  /// אינדקסי שורות שקיבלו שגיאת אימות (422) — לסימון רקע אדום. ראו §10.
  Set<int> _validationErrorLines = <int>{};

  /// מפתחות לגלילה אל בעיית הברקוד הראשונה (§9).
  final GlobalKey _itemsCardKey = GlobalKey();
  final GlobalKey _firstBadCellKey = GlobalKey();

  /// "שלח לקופה" — אימות (§10) ואז קליטה ל-Comax (§11).
  bool _isValidating = false;
  bool _isSubmitting = false;
  String? _validatedDocumentId;
  late final InvoiceApiClient _apiClient =
      InvoiceApiClient(app: DocScanBootstrap.firebaseApp);

  /// שחזור ברקודים לחשבונית שהגיעה בלעדיהם (§13). רץ פעם אחת לכל פתיחת מסך.
  late final InvoiceItemsResolverService _resolverService =
      InvoiceItemsResolverService(app: DocScanBootstrap.firebaseApp);
  bool _isResolvingBarcodes = false;
  bool _barcodeResolveAttempted = false;

  /// תוצאת בדיקת "האם החשבונית כבר ב-Comax", מיד עם פתיחת המסמך. null = לא נבדק
  /// או שהבדיקה נכשלה — **אף פעם לא חוסמים בגלל כשל בדיקה**.
  InvoiceExistsResult? _duplicateCheck;
  bool _duplicateCheckDone = false;

  /// מועמדים מדורגים לכל שורה שההצלבה לא הכריעה בה, לפי globalIndex.
  /// מוצגים ב-picker של תא הברקוד כדי שהמשתמש לא יחפש בעיוורון.
  final Map<int, List<ResolvedCandidate>> _barcodeSuggestions = {};

  // §5: סיבוב מסך מותר רק בדף הפרטים (לראות טבלה רחבה).
  static const List<DeviceOrientation> _rotatableOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  /// נעילת ה-orientation של האפליקציה הראשית (main.dart) — לשחזור ביציאה מהדף,
  /// כדי לא לשבור את התנהגות שאר האפליקציה (embedded-safe).
  static const List<DeviceOrientation> _mainAppOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  @override
  void initState() {
    super.initState();
    _initFromDocument();
    // אפשר סיבוב מסך — רק בדף פרטי המסמך.
    SystemChrome.setPreferredOrientations(_rotatableOrientations);
    // טעינת קטלוג המוצרים לזיהוי ברקודים שאינם בקטלוג (§9).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(productsProvider.notifier).load();
      // §13: חשבונית ללא ברקודים — שחזור מהקטלוג בצד השרת.
      _maybeResolveMissingBarcodes();
      // §14: האם החשבונית הזו כבר נקלטה ל-Comax (כולל הקלדה ידנית)?
      _maybeCheckDuplicate();
    });
  }

  @override
  void dispose() {
    // החזרת נעילת ה-orientation של האפליקציה הראשית ביציאה מהדף.
    SystemChrome.setPreferredOrientations(_mainAppOrientations);
    super.dispose();
  }

  /// כפתור סיבוב ידני: **נועל** לכיוון ההפוך מהנוכחי, ונשאר שם עד לחיצה חוזרת.
  ///
  /// קודם היה בכך באג: אחרי הכפייה ל-landscape הקוד שיחזר מיד "סיבוב חופשי"
  /// (שכולל portrait), והמכשיר — שמוחזק פיזית לאורך — קפץ מיד בחזרה ל-portrait,
  /// כך שנראה שהכפתור לא עושה כלום. עכשיו הכיוון נעול עד שלוחצים שוב.
  Future<void> _toggleRotation() async {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    await SystemChrome.setPreferredOrientations(
      isPortrait
          ? const [
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ]
          : const [DeviceOrientation.portraitUp],
    );
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
      // §5: סיבוב מסך — רק בדף הפרטים.
      EmbeddedDetailsHeaderAction(
        tooltip: l10n.rotateScreen,
        icon: Icons.screen_rotation,
        onPressed: _toggleRotation,
      ),
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
    if (oldWidget.document != widget.document) {
      // רענון רקע של ה-sync יוצר instance חדש של אותו מסמך (InvoiceDocument הוא
      // reference-equality). כשמדובר באותו מסמך, לא לאבד את קוד הספק שהמשתמש בחר
      // ידנית — אחרת ה-toggle "רק ספק זה" נעלם אחרי כל רענון. מאפסים רק כשה-id
      // באמת מתחלף (מעבר למסמך אחר).
      final sameDocument = oldWidget.document?.id == widget.document?.id;
      final pickedSupplierCode = sameDocument ? _supplierCode : null;
      _initFromDocument();
      if (pickedSupplierCode != null && pickedSupplierCode.isNotEmpty) {
        _supplierCode = pickedSupplierCode;
      }
      // במסמך שזה עתה נסרק, `initState` רץ בזמן ש-`status == processing` ומספר
      // החשבונית עדיין ריק — בדיוק המצב שבו שתי הבדיקות למטה יוצאות מוקדם.
      // כשה-OCR מסתיים, המסמך מתחלף והן חייבות לרוץ עכשיו.
      _maybeCheckDuplicate();
      _maybeResolveMissingBarcodes();
    }
  }

  void _initFromDocument() {
    final doc = widget.document;
    if (doc == null) return;
    _documentType = doc.documentType ?? '';
    _companyName = doc.companyName ?? '';
    // אם שם החברה תואם ספק ידוע בקטלוג (למשל הספק שנבחר בזמן הסריקה) — גוזרים
    // את קוד הספק מיד, כדי שה-toggle "רק ספק זה" והוולידציה יעבדו בלי לבחור ספק
    // שוב. חשוב לספקים ללא ח.פ בקומקס (רגבים) שבהם codesForTaxId ריק.
    final codeFromName = ref.read(suppliersProvider).codeForName(_companyName);
    _supplierCode = codeFromName.isEmpty ? null : codeFromName;
    _companyId = doc.companyId ?? '';
    _documentNumber = doc.documentNumber ?? '';
    _documentDate = doc.documentDate ?? '';
    _subtotal = doc.subtotal != null ? formatCurrency(doc.subtotal!) : '';
    _vatAmount = doc.vatAmount != null ? formatCurrency(doc.vatAmount!) : '';
    _totalAmount =
        doc.totalAmount != null ? formatCurrency(doc.totalAmount!) : '';
    _allocationNumber = doc.allocationNumber ?? '';
    _paymentDueDate = doc.paymentDueDate ?? '';
    _parsedJson = doc.parsedJson;
    _items = List<InvoiceItem>.from(doc.items);
    _documentDiscount = doc.discount ?? 0;
    _vatRate = _deriveVatRate(doc);
    _ocrSubtotal = doc.subtotal;
    _ocrTotal = doc.totalAmount;
    _applyComputedTotals();
  }

  /// כשהשורות עקביות (אין ממצא חוסם) — **מציג את הסיכומים לפי החישוב מהשורות**,
  /// גם אם ה-OCR קרא סה"כ אחר. הפער מול מה שקרא ה-OCR מוצג כאזהרה (לא חוסמת),
  /// ו-[_ocrSubtotal]/[_ocrTotal] שומרים את המקור להשוואה. כשיש ממצא חוסם
  /// (שורה שגויה) — לא נוגעים, המחושב לא מהימן.
  void _applyComputedTotals() {
    final report = _consistencyReport;
    if (!report.isConsistent) return;
    final t = report.computedTotals;
    _subtotal = t.subtotal.toStringAsFixed(2);
    _vatAmount = t.vat.toStringAsFixed(2);
    _totalAmount = t.total.toStringAsFixed(2);
  }

  /// שיעור המע"מ של המסמך = מע"מ ÷ סכום ביניים (שכבר אחרי הנחה). נופל ל-18%
  /// כשאין ממה לגזור, ומתעלם מערכים לא סבירים שנובעים מקריאת OCR שגויה.
  static double _deriveVatRate(InvoiceDocument doc) {
    final subtotal = doc.subtotal;
    final vat = doc.vatAmount;
    if (subtotal == null || vat == null || subtotal <= 0) return _defaultVatRate;
    final rate = double.parse((vat / subtotal).toStringAsFixed(4));
    if (rate < 0 || rate > 0.5) return _defaultVatRate;
    return rate;
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
    // נשלח לקופה — או שהקליטה ל-Comax בתהליך/הושלמה (חוסם שליחה כפולה ועריכה).
    final isCashSent = doc.isComaxIntakeInFlightOrDone;
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
              if (_duplicateCheck != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildDuplicateBanner(l10n, _duplicateCheck!),
                ),
              if (_isResolvingBarcodes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildResolvingBarcodesBanner(l10n),
                ),
              Builder(builder: (context) {
                final badCount =
                    _unknownBarcodeIndices(ref.watch(productsProvider)).length;
                if (badCount == 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildBarcodeWarningBanner(l10n, badCount),
                );
              }),
              Builder(builder: (context) {
                final autoFilled = _mediumConfidenceCount;
                if (autoFilled == 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildAutoFilledBanner(l10n, autoFilled),
                );
              }),
              Builder(builder: (context) {
                if (isCashSent) return const SizedBox.shrink();
                final report = _consistencyReport;
                if (!report.isConsistent) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildConsistencyBanner(l10n, report),
                  );
                }
                if (report.hasWarnings) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildTotalsWarningBanner(l10n, report),
                  );
                }
                return const SizedBox.shrink();
              }),
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
                            onPressed: (_isValidating || _isSubmitting)
                                ? null
                                : _onSave,
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
                              onTap: (_isValidating || _isSubmitting)
                                  ? null
                                  : _onUpdateInCash,
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
                                  child: (_isValidating || _isSubmitting)
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _isSubmitting
                                                  ? l10n.submitting
                                                  : l10n.validating,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                    color:
                                                        AppColors.accentGreen,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        )
                                      : Text(
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
                  // §6: שם הספק נבחר מתוך רשימת הספקים (לא הקלדה חופשית).
                  label: l10n.companyName,
                  value: _companyName.isEmpty ? AppConstants.emptyFieldPlaceholder : _companyName,
                  icon: CupertinoIcons.briefcase,
                  onTap: isReadOnly ? null : _pickSupplierForCompanyName,
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
            const SizedBox(height: 12),
            // §4: מספר הקצאה + תאריך לתשלום
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: EditableField(
                    label: l10n.allocationNumber,
                    value: _allocationNumber.isEmpty
                        ? AppConstants.emptyFieldPlaceholder
                        : _allocationNumber,
                    icon: CupertinoIcons.number_square,
                    keyboardType: TextInputType.number,
                    onChanged: isReadOnly
                        ? null
                        : (v) => setState(() => _allocationNumber = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: EditableField(
                    label: l10n.paymentDueDate,
                    value: _paymentDueDate.isEmpty
                        ? AppConstants.emptyFieldPlaceholder
                        : _paymentDueDate,
                    icon: CupertinoIcons.calendar_badge_plus,
                    onChanged: isReadOnly
                        ? null
                        : (v) => setState(() => _paymentDueDate = v),
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
    final productsState = ref.watch(productsProvider);
    final badIndices = _unknownBarcodeIndices(productsState);
    final badIndexSet = badIndices.toSet();
    // שורות שבהן כמות×מחיר ≠ סה"כ — לצביעה אדומה ולקישור לבאנר העקביות.
    final inconsistentLines = _consistencyReport.blockingIssues
        .where((i) => i.lineNumber != null)
        .map((i) => i.lineNumber! - 1)
        .toSet();
    final firstBadIndex = badIndices.isEmpty ? -1 : badIndices.first;
    return Card(
      key: _itemsCardKey,
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
                    const DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text('#', textAlign: TextAlign.center),
                      ),
                    ),
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
                        child: Text(
                          l10n.colDiscountPercent,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(
                          l10n.colPackagingDepositTax,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(
                          l10n.colFinalUnitPrice,
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
                        if (_validationErrorLines.contains(globalIndex) ||
                            inconsistentLines.contains(globalIndex)) {
                          return AppColors.error.withOpacity(0.10);
                        }
                        final isEven = entry.key % 2 == 0;
                        return isEven
                            ? AppColors.accentGreen.withOpacity(0.035)
                            : null;
                      }),
                      cells: [
                        isReadOnly
                            ? const DataCell(SizedBox.shrink())
                            : _deleteCell(globalIndex),
                        // מספר השורה — תואם למספרים בדיאלוג שגיאות האימות
                        // (שם: lineIndex + 1), ולכן יציב גם כשהטבלה מסוננת בחיפוש.
                        _cellReadOnly('${globalIndex + 1}'),
                        isReadOnly
                            ? _cellReadOnly(item.itemNumber ?? AppConstants.emptyFieldPlaceholder)
                            : _cellColored(
                                item.itemNumber ?? AppConstants.emptyFieldPlaceholder,
                                () => _editBarcodeCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  item,
                                ),
                                // אותו מקור אמת כמו הבאנר האדום וחסימת השליחה:
                                // ברקוד חסר, או ברקוד שאינו בקטלוג.
                                background: item.newProduct != null
                                    ? AppColors.accentGreen.withOpacity(0.15)
                                    : badIndexSet.contains(globalIndex)
                                        ? AppColors.error.withOpacity(0.18)
                                        // מולא אוטומטית ממידע חלקי — כתום, לאימות.
                                        : item.barcodeConfidence ==
                                                BarcodeConfidence.medium
                                            ? AppColors.warning.withOpacity(0.22)
                                            : null,
                                cellKey: globalIndex == firstBadIndex
                                    ? _firstBadCellKey
                                    : null,
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
                                    _setItem(
                                      globalIndex,
                                      _recalcItemFromPacks(
                                        item.copyWith(units: n),
                                      ),
                                    );
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
                                    _setItem(
                                      globalIndex,
                                      _recalcItemFromPacks(
                                        item.copyWith(
                                          packages: v.isEmpty ? null : n,
                                        ),
                                      ),
                                    );
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
                                    _setItem(
                                      globalIndex,
                                      _withRecalculatedLineTotal(
                                        item.copyWith(quantity: n),
                                      ),
                                    );
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
                                    _setItem(
                                      globalIndex,
                                      _withRecalculatedLineTotal(
                                        item.copyWith(pricePerUnit: n),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        // אחוז הנחה לשורה (ניתן לעריכה; ריק = ללא הנחה).
                        isReadOnly
                            ? _cellReadOnly(_discountCellText(item.discountPercent))
                            : _cell(
                                _discountCellText(item.discountPercent),
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colDiscountPercent,
                                  item.discountPercent?.toString() ?? '',
                                  (v) {
                                    final t = v.trim().replaceAll('%', '');
                                    if (t.isEmpty) {
                                      _setItem(
                                        globalIndex,
                                        _withRecalculatedLineTotal(
                                          item.copyWith(discountPercent: null),
                                        ),
                                      );
                                      return;
                                    }
                                    final n = double.tryParse(t);
                                    if (n == null) return;
                                    _setItem(
                                      globalIndex,
                                      _withRecalculatedLineTotal(
                                        item.copyWith(discountPercent: n),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        // אריזה/מס/פיקדון לשורה (ניתן לעריכה; ריק = ללא תוספת).
                        isReadOnly
                            ? _cellReadOnly(
                                _amountOrDash(item.packagingDepositTax))
                            : _cell(
                                _amountOrDash(item.packagingDepositTax),
                                () => _editItemCell(
                                  context,
                                  l10n,
                                  globalIndex,
                                  l10n.colPackagingDepositTax,
                                  item.packagingDepositTax?.toString() ?? '',
                                  (v) {
                                    final t = v.trim();
                                    if (t.isEmpty) {
                                      _setItem(
                                        globalIndex,
                                        _withRecalculatedLineTotal(
                                          item.copyWith(
                                              packagingDepositTax: null),
                                        ),
                                      );
                                      return;
                                    }
                                    final n = double.tryParse(t);
                                    if (n == null) return;
                                    _setItem(
                                      globalIndex,
                                      _withRecalculatedLineTotal(
                                        item.copyWith(packagingDepositTax: n),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        // מחיר ליחידה סופי (סה"כ ÷ כמות) — קריאה בלבד.
                        _cellReadOnly(_finalUnitPriceText(item)),
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
                                    _setItem(
                                      globalIndex,
                                      item.copyWith(totalPrice: n),
                                    );
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

  /// תא ניתן-ללחיצה עם רקע אופציונלי (לסימון ברקוד שאינו בקטלוג) ומפתח אופציונלי
  /// (לגלילה אל הבעיה הראשונה). ראו §9.
  DataCell _cellColored(
    String text,
    VoidCallback onTap, {
    Color? background,
    Key? cellKey,
  }) {
    return DataCell(
      InkWell(
        onTap: onTap,
        child: Container(
          key: cellKey,
          color: background,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
          _shiftBarcodeSuggestionsAfterRemoval(globalIndex);
          _renumberLineNumbers();
          _recalculateDocumentTotals(allowEmpty: true);
        });
      }
    });
  }

  /// ההצעות ממופתחות לפי מיקום השורה, ולכן מחיקת שורה חייבת להזיז אותן —
  /// אחרת ההצעות של שורה 5 יידבקו לשורה 4 אחרי מחיקת שורה 3.
  void _shiftBarcodeSuggestionsAfterRemoval(int removedIndex) {
    if (_barcodeSuggestions.isEmpty) return;
    final shifted = <int, List<ResolvedCandidate>>{};
    _barcodeSuggestions.forEach((index, candidates) {
      if (index == removedIndex) return;
      shifted[index > removedIndex ? index - 1 : index] = candidates;
    });
    _barcodeSuggestions
      ..clear()
      ..addAll(shifted);
  }

  void _renumberLineNumbers() {
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (item.lineNumber != i + 1) {
        _items[i] = item.copyWith(lineNumber: i + 1);
      }
    }
  }

  static const double _defaultVatRate = 0.18;

  /// חישוב מחדש של סכומי המסמך מתוך שורות הפריטים:
  /// סכום ביניים = סכום סה"כ השורות − הנחת המסמך, מע"מ = סכום ביניים × שיעור
  /// המע"מ של המסמך, סה"כ = סכום ביניים + מע"מ.
  /// כשאין פריטים — לא נוגעים בערכים שהגיעו מה-OCR (למסמכים ללא שורות),
  /// אלא אם [allowEmpty] — כלומר המשתמש מחק את השורה האחרונה ומצפה לאיפוס.
  void _recalculateDocumentTotals({bool allowEmpty = false}) {
    if (_items.isEmpty && !allowEmpty) return;
    final lineSum = _items.fold<double>(0, (sum, it) => sum + it.totalPrice);
    // מחיקת שורות עלולה להוריד את סכום השורות מתחת להנחה — אין סכום ביניים שלילי.
    final subtotal =
        (lineSum - _documentDiscount).clamp(0.0, double.infinity).toDouble();
    final vat = subtotal * _vatRate;
    final total = subtotal + vat;
    _subtotal = formatCurrency(double.parse(subtotal.toStringAsFixed(2)));
    _vatAmount = formatCurrency(double.parse(vat.toStringAsFixed(2)));
    _totalAmount = formatCurrency(double.parse(total.toStringAsFixed(2)));
  }

  /// עדכון פריט בודד ברשימה + חישוב מחדש של סכומי המסמך, בתוך setState אחד.
  void _setItem(int index, InvoiceItem newItem) {
    setState(() {
      _items[index] = newItem;
      _recalculateDocumentTotals();
      // עריכת שורה מבטלת סימוני שגיאות אימות ישנים.
      _validationErrorLines = {};
    });
  }

  /// חישוב מחדש של סה"כ השורה: כמות × מחיר ליחידה, בניכוי אחוז הנחה (אם קיים),
  /// בתוספת אריזה/מס/פיקדון. מעוגל ל-2 ספרות אחרי הנקודה.
  InvoiceItem _withRecalculatedLineTotal(InvoiceItem it) {
    final gross = it.quantity * it.pricePerUnit;
    final factor = 1 - ((it.discountPercent ?? 0) / 100);
    final extras = it.packagingDepositTax ?? 0;
    final total = double.parse((gross * factor + extras).toStringAsFixed(2));
    return it.copyWith(totalPrice: total);
  }

  /// בעריכת מארזים / יח' במארז: גוזר כמות = מארזים × יח' (כששניהם קיימים וגדולים מ-0),
  /// ואז מחשב מחדש את סה"כ השורה.
  InvoiceItem _recalcItemFromPacks(InvoiceItem it) {
    final packs = it.packages;
    final units = it.units;
    if (packs != null && units != null && packs > 0 && units > 0) {
      it = it.copyWith(quantity: (packs * units).toDouble());
    }
    return _withRecalculatedLineTotal(it);
  }

  /// תצוגת סכום כספי או '—' כשאין נתון (לעמודת אריזה/מס/פיקדון).
  String _amountOrDash(double? value) =>
      value == null ? '—' : formatCurrency(value);

  /// תצוגת מחיר ליחידה סופי (סה"כ ÷ כמות) או '—' כשאין כמות.
  String _finalUnitPriceText(InvoiceItem item) {
    final p = item.finalUnitPrice;
    return p == null ? '—' : formatCurrency(p);
  }

  /// תצוגת אחוז הנחה: '99.99%' או '—' כשאין נתון. מסיר אפסים עשרוניים מיותרים.
  String _discountCellText(double? percent) {
    if (percent == null) return '—';
    var s = percent.toStringAsFixed(2);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return '$s%';
  }

  // ===== §14: האם החשבונית כבר נקלטה ל-Comax? =====

  /// נקרא מיד עם פתיחת המסמך, לפני שהמשתמש נוגע במשהו.
  ///
  /// הרקע: אותה חשבונית של פיליפ מוריס (₪26,075) נקלטה ל-Comax **פעמיים** —
  /// פעם בהקלדה ידנית של הלקוח ופעם דרכנו. שדה האסמכתא ב-Comax מוגבל ל-9 ספרות,
  /// הלקוח הקליד רק את הסיומת, ובדיקת הייחודיות של Comax לא ראתה בזה אותה חשבונית.
  ///
  /// ⚠️ **מזהיר, לא חוסם.** `match: "suffix"` הוא סימן חזק אך לא ודאות, וכשל
  /// בבדיקה עצמה לא ימנע מהמשתמש להמשיך.
  Future<void> _maybeCheckDuplicate() async {
    if (_duplicateCheckDone) return;
    if (widget.document?.isComaxIntakeInFlightOrDone ?? false) return;
    // הממשק האחיד /documents/exists בודק לפי סוג המסמך — עובד גם לחשבוניות וגם
    // לתעודות כניסה, כל אחת מול הטבלה שלה (בלי הצלבה).
    final apiType =
        apiDocumentTypeForLabel(AppLocalizations.of(context), _documentType);
    // עוד אין תוצאת OCR — נחזור לכאן מ-didUpdateWidget כשהיא תגיע.
    final invoiceNumber = _documentNumber.trim();
    if (invoiceNumber.isEmpty) return;

    _duplicateCheckDone = true;
    try {
      await ref.read(customerCodeProvider.notifier).ready;
      if (!mounted) return;

      // /documents/exists **דורש supplierCode**. קדימות: הבחירה הידנית → קוד
      // הספק הנגזר משם החברה (חשוב לספקים ללא ח.פ כמו רגבים) → תרגום הח.פ.
      final candidates = <String>{
        if (_supplierCode != null && _supplierCode!.isNotEmpty) _supplierCode!,
      };
      if (candidates.isEmpty) {
        await ref.read(suppliersProvider.notifier).load();
        if (!mounted) return;
        final s = ref.read(suppliersProvider);
        final byName = s.codeForName(_companyName);
        if (byName.isNotEmpty) candidates.add(byName);
        // ח.פ אחד יכול להתאים לכמה רשומות ספק — בודקים את כולן, כי הכפילות
        // רשומה תחת אחת מהן ואיננו יודעים מראש איזו.
        candidates.addAll(s.codesForTaxId(_companyId).take(3));
      }
      if (candidates.isEmpty) {
        // ספק לא מזוהה — לא ניתן לבדוק. הבדיקה תרוץ שוב אם המשתמש יבחר ספק.
        _duplicateCheckDone = false;
        return;
      }

      final customerCode = ref.read(customerCodeProvider);
      for (final supplierCode in candidates) {
        final result = await _apiClient.checkInvoiceExists(
          invoiceNumber: invoiceNumber,
          documentType: apiType,
          supplierCode: supplierCode,
          customerCode: customerCode,
        );
        if (!mounted) return;
        // מציגים באנר גם על כפילות חיה (exists) וגם על מסמך שבוטל (reversed).
        if (result != null && (result.exists || result.isReversed)) {
          setState(() => _duplicateCheck = result);
          return;
        }
      }
    } catch (e) {
      debugPrint('checkInvoiceExists failed: $e');
      // כשל בדיקה = "לא ידוע". לא מציגים כלום ולא חוסמים.
    }
  }

  /// `2026-07-09` -> `09/07/2026`. הקראולר מחזיר ISO; המשתמש קורא אירופאי,
  /// כמו כל שאר התאריכים במסך.
  String _formatIsoDate(String iso) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(iso.trim());
    return m == null ? iso : '${m.group(3)}/${m.group(2)}/${m.group(1)}';
  }

  /// באנר "נמצאה חשבונית דומה". מנוסח בזהירות בכוונה — ראו [_maybeCheckDuplicate].
  Widget _buildDuplicateBanner(AppLocalizations l10n, InvoiceExistsResult r) {
    final theme = Theme.of(context);
    // מסמך שבוטל (reversed) — לא כפילות חוסמת אלא מידע: אפשר לשלוח שוב.
    final isReversed = r.isReversed && !r.exists;
    final exactMatch = r.comaxInvoices.any((i) => i.isExact);
    final title = isReversed
        ? l10n.duplicateReversedTitle
        : (exactMatch ? l10n.duplicateFoundTitle : l10n.duplicateSimilarTitle);
    final accent = isReversed ? AppColors.accentGreen : AppColors.warning;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                  isReversed
                      ? CupertinoIcons.info_circle_fill
                      : CupertinoIcons.exclamationmark_circle_fill,
                  color: accent,
                  size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final inv in r.comaxInvoices) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '${l10n.comaxDocumentLabel} ${inv.comaxDocNumber}'
                '${inv.amount != null ? ' · ${formatCurrency(inv.amount!)}' : ''}'
                '${inv.invoiceDate != null && inv.invoiceDate!.isNotEmpty ? ' · ${inv.invoiceDate}' : ''}'
                '${inv.warehouseName != null && inv.warehouseName!.isNotEmpty ? ' · ${inv.warehouseName}' : ''}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),
            // **חובה להסביר למה זו התאמה.** בלי זה האזהרה נראית שרירותית: האסמכתא
            // ב-Comax היא "42386" בעוד מספר החשבונית שלנו הוא "8003542386", כי
            // שדה האסמכתא מוגבל באורך והלקוח מקליד רק את הסיומת.
            if (inv.reference != null && inv.reference!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  inv.isExact
                      ? '${l10n.duplicateReferenceLabel} ${inv.reference}'
                      : '${l10n.duplicateReferenceLabel} ${inv.reference} — ${l10n.duplicateSuffixExplain}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
          if (r.snapshotDate != null) ...[
            const SizedBox(height: 4),
            // הצילום הוא מהשליפה האחרונה: היעדר התאמה אינו הוכחה, ונוכחות התאמה
            // עשויה להיות ישנה. אומרים את זה למשתמש במקום להעמיד פנים.
            Text(
              '${l10n.duplicateSnapshotNote} ${_formatIsoDate(r.snapshotDate!)}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  // ===== §13: שחזור ברקודים לחשבונית שהגיעה בלעדיהם =====

  /// חלק מהספקים (למשל פיליפ מוריס) מדפיסים חשבונית **ללא ברקודים** — רק תיאור
  /// מוצר מקוצץ. `/documents/validate` מזהה פריטים לפי ברקוד בלבד, ולכן בלי
  /// השחזור הזה אי אפשר לשלוח מסמך כזה לקופה.
  ///
  /// רץ פעם אחת, ורק כשיש בפועל שורה בלי ברקוד. שורות שכבר יש להן ברקוד
  /// (מה-OCR או מהמשתמש) **לעולם לא נדרסות** — הן נשלחות רק כדי שהשיבוץ
  /// החד-חד-ערכי בשרת ידע שהמועמד שלהן תפוס.
  Future<void> _maybeResolveMissingBarcodes() async {
    if (_barcodeResolveAttempted || _isResolvingBarcodes) return;
    // מסמך שכבר בדרכו לקופה (או נקלט) הוא לקריאה בלבד.
    if (widget.document?.isComaxIntakeInFlightOrDone ?? false) return;

    final hasMissing = _items.any(
      (it) => (it.itemNumber ?? '').trim().isEmpty && it.newProduct == null,
    );
    if (!hasMissing) return;

    _barcodeResolveAttempted = true;
    setState(() => _isResolvingBarcodes = true);

    try {
      // ה-clientId נקרא מהדיסק אסינכרונית; בלי ההמתנה נשלח את לקוח ברירת המחדל
      // ונצליב מול הקטלוג של לקוח אחר לגמרי.
      await ref.read(customerCodeProvider.notifier).ready;
      if (!mounted) return;
      final result = await _resolverService.resolve(
        items: _items,
        customerCode: ref.read(customerCodeProvider),
        supplierCode: _supplierCode,
      );
      if (!mounted) return;

      final byLine = {for (final r in result.items) r.lineNumber: r};
      setState(() {
        for (var i = 0; i < _items.length; i++) {
          final item = _items[i];
          final resolved = byLine[item.lineNumber];
          if (resolved == null) continue;

          _barcodeSuggestions[i] = [
            // המועמד המוביל הוא עצמו חלופה לגיטימית כשלא מילאנו אותו.
            if (!resolved.shouldAutoFill && resolved.barcode != null)
              ResolvedCandidate(
                barcode: resolved.barcode!,
                name: resolved.matchedName ?? '',
              ),
            ...resolved.alternatives,
          ];

          final alreadyHasBarcode = (item.itemNumber ?? '').trim().isNotEmpty;
          if (alreadyHasBarcode || !resolved.shouldAutoFill) continue;

          _items[i] = item.copyWith(
            itemNumber: resolved.barcode,
            barcodeConfidence: resolved.confidence,
          );
        }
        _isResolvingBarcodes = false;
      });
      // לא שומרים כאן: המסמך נשמר כשהמשתמש לוחץ "שמור" (_onSave), כמו כל עריכה
      // אחרת בדף. כך מילוי אוטומטי לעולם לא כותב לדיסק בלי ידיעתו.
    } catch (e, st) {
      debugPrint('resolveInvoiceItems failed: $e\n$st');
      if (!mounted) return;
      // כישלון אינו חוסם: השורות פשוט נשארות אדומות והמשתמש ימלא ידנית.
      setState(() => _isResolvingBarcodes = false);
    }
  }

  // ===== §9: זיהוי מול קטלוג + עורך ברקוד "חלופי" =====

  /// אינדקסי שורות שאי אפשר לשלוח לקופה: **ברקוד חסר**, או ברקוד שאינו בקטלוג.
  /// (לסימון אדום + חסימת שליחה.)
  ///
  /// ⚠️ שורה **ריקה** חייבת להיספר כאן. `ProductsState.isKnownItemNumber('')`
  /// מחזיר `true` בכוונה ("אין מה לסמן"), וזה היה תקף כל עוד ה-OCR תמיד ייצר
  /// ברקוד כלשהו. מאז ההצלבה האוטומטית (§13), שורה שלא הוכרעה נשארת **ריקה** —
  /// ובלי הבדיקה הזו היא עוברת בשקט ל-`/documents/validate` בלי מזהה פריט.
  /// קוד הספק לזיהוי/סינון: הבחירה הידנית, אחרת נגזר משם החברה (הספק שנבחר
  /// בסריקה). null כשלא ניתן לזהות ספק — אז ההתאמה נשארת גלובלית.
  String? get _effectiveSupplierCode {
    if (_supplierCode != null && _supplierCode!.isNotEmpty) return _supplierCode;
    final byName = ref.read(suppliersProvider).codeForName(_companyName);
    return byName.isEmpty ? null : byName;
  }

  List<int> _unknownBarcodeIndices(ProductsState products) {
    final out = <int>[];
    final sup = _effectiveSupplierCode;
    for (var i = 0; i < _items.length; i++) {
      final it = _items[i];
      // שורה שנוצר לה "פריט חדש" נחשבת מסודרת — לא חוסמת ולא אדומה.
      if (it.newProduct != null) continue;
      if ((it.itemNumber ?? '').trim().isEmpty) {
        out.add(i);
        continue;
      }
      // בלי קטלוג טעון אי אפשר לדעת אם הברקוד קיים — לא מסמנים.
      if (products.hasCatalog &&
          !products.isKnownItemNumber(it.itemNumber, supplierCode: sup)) {
        out.add(i);
      }
    }
    return out;
  }

  /// באנר אזהרה בראש הדף כשיש ברקודים שאינם קיימים בקטלוג.
  /// כמה שורות מולאו אוטומטית בוודאות בינונית (כתומות). אינן חוסמות שליחה.
  int get _mediumConfidenceCount => _items
      .where((it) => it.barcodeConfidence == BarcodeConfidence.medium)
      .length;

  /// חיווי בזמן ההצלבה מול הקטלוג (רץ פעם אחת בפתיחת המסך).
  Widget _buildResolvingBarcodesBanner(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.resolvingBarcodes,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// באנר כתום — שורות שהברקוד שלהן שוחזר ממידע חלקי. **אינו חוסם** שליחה,
  /// בניגוד לבאנר האדום; הוא רק מבקש אימות ויזואלי של התאים הכתומים.
  Widget _buildAutoFilledBanner(AppLocalizations l10n, int count) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.55)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.info_circle_fill,
              color: AppColors.warning, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.autoFilledBarcodesTitle} ($count)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.autoFilledBarcodesSubtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// באנר כתום — הסה"כ שבחשבונית שונה מהחישוב. **אינו חוסם**; המשתמש מחליט.
  Widget _buildTotalsWarningBanner(AppLocalizations l10n, ConsistencyReport report) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.55)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.exclamationmark_circle_fill,
              color: AppColors.warning, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.consistencyWarnTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                for (final w in report.warningIssues)
                  Text(w.message,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// באנר אדום — המספרים בשורות עצמן לא מתחברים. חוסם שליחה (טעות קריאה ודאית).
  Widget _buildConsistencyBanner(AppLocalizations l10n, ConsistencyReport report) {
    final theme = Theme.of(context);
    final count = report.blockingIssues.length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.exclamationmark_triangle_fill,
              color: AppColors.error, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.consistencyBlockTitle} ($count)',
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.error, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(l10n.consistencyBannerSubtitle,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeWarningBanner(AppLocalizations l10n, int count) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle_fill,
                  color: AppColors.error, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.barcodeIssuesTitle} ($count)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.barcodeIssuesMessage,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
              icon: const Icon(CupertinoIcons.arrow_down_circle, size: 18),
              label: Text(l10n.jumpToFirstIssue),
              onPressed: _jumpToFirstBadBarcode,
            ),
          ),
        ],
      ),
    );
  }

  /// גולל אל בעיית הברקוד הראשונה (אל התא עצמו אם גלוי, אחרת אל כרטיס הפריטים).
  void _jumpToFirstBadBarcode() {
    final cellCtx = _firstBadCellKey.currentContext;
    final target = cellCtx ?? _itemsCardKey.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  /// המועמדים שההצלבה האוטומטית הציעה לשורה, מדורגים. ריק כשלא הוצע דבר.
  ///
  /// ⚠️ מציג **שם + ברקוד + מחיר קניה**, לא רק שם: הקטלוג מכיל פריטים שונים
  /// בעלי שם זהה תו-בתו (שני "מרלבורו גולד" ב-33.46 ₪), ובלי הברקוד המשתמש
  /// היה רואה שתי שורות זהות ואין לו על מה לבסס בחירה.
  Widget _suggestionsBlock(
    ThemeData theme,
    AppLocalizations l10n,
    int index, {
    required String selected,
    required ValueChanged<ResolvedCandidate> onPick,
  }) {
    final candidates = _barcodeSuggestions[index] ?? const <ResolvedCandidate>[];
    if (candidates.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.suggestedMatches,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          for (final c in candidates)
            InkWell(
              onTap: () => onPick(c),
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: c.barcode == selected
                        ? AppColors.accentGreen
                        : AppColors.divider,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: c.barcode == selected
                      ? AppColors.accentGreen.withOpacity(0.08)
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            c.purchasePrice != null
                                ? '${c.barcode}  ·  ${formatCurrency(c.purchasePrice!)}'
                                : c.barcode,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (c.barcode == selected)
                      const Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        size: 18,
                        color: AppColors.accentGreen,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// עורך תא הברקוד: עריכה ידנית + חיפוש מוצר לפי שם (רק מוצרי ספק החשבונית).
  void _editBarcodeCell(
    BuildContext context,
    AppLocalizations l10n,
    int index,
    InvoiceItem item,
  ) {
    final theme = Theme.of(context);
    final products = ref.read(productsProvider);
    final barcodeController = TextEditingController(text: item.itemNumber ?? '');

    void save(String value) {
      final v = value.trim();
      setState(() {
        _items[index] = _items[index].copyWith(
          itemNumber: v.isEmpty ? null : v,
          // המשתמש הכריע — השורה כבר לא "מולאה אוטומטית", ולכן לא כתומה.
          barcodeConfidence: null,
        );
        _validationErrorLines = {};
      });
    }

    showAdaptiveBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (ctx, setSheet) {
                final barcode = barcodeController.text.trim();
                final sup = _effectiveSupplierCode;
                final matched =
                    products.productForBarcode(barcode, supplierCode: sup);
                final known =
                    products.isKnownItemNumber(barcode, supplierCode: sup);

                Widget statusLine() {
                  if (!products.hasCatalog || barcode.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final ok = known;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(
                          ok
                              ? CupertinoIcons.check_mark_circled_solid
                              : CupertinoIcons.xmark_circle_fill,
                          size: 18,
                          color: ok ? AppColors.accentGreen : AppColors.error,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            ok
                                ? (matched != null
                                    ? '${l10n.barcodeInCatalog}: ${matched.name}'
                                    : l10n.barcodeInCatalog)
                                : l10n.barcodeNotInCatalog,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  ok ? AppColors.accentGreen : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (item.description.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.accentGreen.withOpacity(0.25)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // מה שה-OCR קרא לשורה הזו — כדי לזכור מה מחפשים.
                                Text(l10n.fromInvoiceLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 11)),
                                const SizedBox(height: 2),
                                Text(item.description.trim(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary)),
                                if ((item.itemNumber ?? '').trim().isNotEmpty)
                                  Text('${l10n.barcodeLabel}: ${item.itemNumber!.trim()}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ),
                      Text(
                        l10n.editBarcodeTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _actionSheetGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: barcodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.barcodeLabel,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                          ),
                          isDense: true,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.accentGreen),
                          ),
                        ),
                        onChanged: (_) => setSheet(() {}),
                      ),
                      statusLine(),
                      _suggestionsBlock(
                        theme,
                        l10n,
                        index,
                        selected: barcode,
                        onPick: (candidate) {
                          barcodeController.text = candidate.barcode;
                          setSheet(() {});
                          save(candidate.barcode);
                        },
                      ),
                      const SizedBox(height: 16),
                      // §9: חיפוש מוצר נפתח כמסך חיפוש נגלל (כמו בורר הספק),
                      // מסונן למוצרי ספק החשבונית. כך אין overflow כשהמקלדת פתוחה.
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accentGreen,
                            side:
                                const BorderSide(color: AppColors.accentGreen),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(CupertinoIcons.search, size: 20),
                          label: Text(l10n.searchByProductName),
                          onPressed: () async {
                            // חיפוש בכל מוצרי הלקוח (לא מסונן לפי ספק).
                            final items = products.products;
                            if (items.isEmpty) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.noProductsFound)),
                              );
                              return;
                            }
                            // קודי הספק של החשבונית (מהבחירה, מהשם, או מהח.פ שה-OCR
                            // קרא), ל-toggle "רק ספק זה". כבוי כברירת מחדל.
                            final suppliersState = ref.read(suppliersProvider);
                            final codeByName =
                                suppliersState.codeForName(_companyName);
                            final supplierCodes = <String>{
                              if (_supplierCode != null &&
                                  _supplierCode!.isNotEmpty)
                                _supplierCode!,
                              if (codeByName.isNotEmpty) codeByName,
                              ...suppliersState.codesForTaxId(_companyId),
                            };
                            final picked = await showSearchablePicker<Product>(
                              context: context,
                              title: l10n.searchByProductName,
                              searchHint: l10n.productSearchHint,
                              // מה שנקרא מהחשבונית לשורה הזו, כהקשר לחיפוש.
                              contextTitle: item.description.trim().isEmpty
                                  ? null
                                  : item.description.trim(),
                              contextSubtitle:
                                  (item.itemNumber ?? '').trim().isEmpty
                                      ? null
                                      : '${l10n.barcodeLabel}: ${item.itemNumber!.trim()}',
                              items: items,
                              labelOf: (p) => p.name,
                              // מציג "קוד מוצר, ברקוד" (הקוד לפני הברקוד). תת-הכותרת
                              // נכללת גם בטקסט החיפוש, אז זה גם מאפשר חיפוש לפי קוד מוצר.
                              sublabelOf: (p) {
                                final code = p.code.trim();
                                final barcode = p.barcode.trim();
                                if (code.isEmpty) return barcode;
                                if (barcode.isEmpty) return code;
                                return '$code, $barcode';
                              },
                              filterLabel: supplierCodes.isEmpty
                                  ? null
                                  : l10n.filterBySupplier,
                              matchesFilter: supplierCodes.isEmpty
                                  ? null
                                  : (p) => supplierCodes.contains(p.supplierCode),
                            );
                            if (picked != null) {
                              barcodeController.text = picked.barcode;
                              setSheet(() {});
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
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
                                save(barcodeController.text);
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// בחירת שם הספק מתוך רשימת הספקים (במקום הקלדה חופשית).
  Future<void> _pickSupplierForCompanyName() async {
    final l10n = AppLocalizations.of(context);
    if (!ref.read(suppliersProvider).loaded) {
      await ref.read(suppliersProvider.notifier).load();
      if (!mounted) return;
    }
    final suppliers = ref.read(suppliersProvider).suppliers;
    final picked = await showSearchablePicker<Supplier>(
      context: context,
      title: l10n.supplierNameField,
      searchHint: l10n.searchHintGeneric,
      items: suppliers,
      labelOf: (s) => s.name,
      // מציגים וגם מחפשים לפי ח.פ (עוסק מורשה) — לא לפי מספר הספק הפנימי.
      sublabelOf: (s) => s.taxId.isEmpty ? '' : 'ח.פ ${s.taxId}',
      searchExtra: (s) => s.taxId,
    );
    if (picked != null && mounted) {
      final code = picked.code.trim();
      setState(() {
        _companyName = picked.name;
        _supplierCode = code.isEmpty ? null : code;
        // עכשיו יש קוד ספק — אם בדיקת הכפילות דילגה מחוסר זיהוי, היא יכולה לרוץ.
        if (!_duplicateCheckDone) _maybeCheckDuplicate();
        _validationErrorLines = {};
      });
      // שמירת הקוד שנבחר לסשן לפי ח.פ של החשבונית — לשליחה אוטומטית בעתיד.
      final taxId =
          InvoiceValidationPayload.supplierTaxIdOf(_documentSnapshotForPersist());
      if (taxId.isNotEmpty && _supplierCode != null) {
        final cache =
            Map<String, String>.from(ref.read(supplierCodeCacheProvider));
        cache[taxId] = _supplierCode!;
        ref.read(supplierCodeCacheProvider.notifier).state = cache;
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
    // אותן אפשרויות בדיוק כמו בסריקה חדשה (מקור אמת משותף): פעילים —
    // חשבונית מס/כניסה + תעודת כניסה; השאר מושבתים.
    final options = docScanDocumentTypeOptions(l10n);
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
            // הכותרת + 4 ה-ListTile חורגים ב-3px מגובה ה-sheet במסכים מסוימים.
            child: SingleChildScrollView(
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
                  return ListTile(
                    enabled: opt.active,
                    title: Text(
                      opt.active
                          ? opt.label
                          : '${opt.label}  (${l10n.docTypeInactiveSuffix})',
                    ),
                    onTap: opt.active
                        ? () {
                            Navigator.of(ctx).pop();
                            setState(() => _documentType = opt.label);
                          }
                        : null,
                  );
                }),
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
      allocationNumber:
          _allocationNumber.isEmpty ? original.allocationNumber : _allocationNumber,
      documentDate:
          _documentDate.isEmpty ? original.documentDate : _documentDate,
      paymentDueDate:
          _paymentDueDate.isEmpty ? original.paymentDueDate : _paymentDueDate,
      discount: _documentDiscount,
      subtotal: _parseAmount(_subtotal, fallback: original.subtotal),
      vatAmount: _parseAmount(_vatAmount, fallback: original.vatAmount),
      totalAmount: _parseAmount(_totalAmount, fallback: original.totalAmount),
      parsedJson: _parsedJson ?? original.parsedJson,
      errorMessage: original.errorMessage,
      scanModel: original.scanModel,
      items: _items,
      // ⚠️ חובה להעביר את שדות ה-Comax מהמסמך המקורי.
      //
      // הפונקציה בונה InvoiceDocument **חדש** מהשדות שב-UI, ולא copyWith. לפני
      // התיקון הזה, לחיצה על "שמור" אחרי "שלח לקופה" אִפְסה את `comaxDocumentId` —
      // מפתח הקורלציה היחיד שלנו מול הקראולר. בלעדיו קרון הפולינג לא מוצא את
      // התעודה לעולם, והיא נשארת "ממתין לשליחה" בזמן שהחשבונית כבר ב-Comax.
      // זה בדיוק מה שקרה לחשבונית 0122538768 (מסמך Comax 2501470) בפרודקשן.
      comaxDocumentId: original.comaxDocumentId,
      comaxDocNumber: original.comaxDocNumber,
      comaxStatus: original.comaxStatus,
      comaxReceiveError: original.comaxReceiveError,
      comaxDiagnosis: original.comaxDiagnosis,
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

    final snapshot = _documentSnapshotForPersist();
    // "שמור" לא רשאי להוריד בדרגה מסמך שכבר בדרכו לקופה או שנקלט בה. אחרת
    // מסמך ב-`processing` היה חוזר ל-`completed`, קרון הפולינג היה מפסיק לחפש
    // אותו (הוא סורק לפי `comaxStatus`), והסטטוס האמיתי מ-Comax לא היה מגיע לעולם.
    final updated = snapshot.isComaxIntakeInFlightOrDone
        ? snapshot
        : snapshot.copyWith(status: DocumentStatus.completed);

    ref.read(documentsProvider.notifier).upsert(updated);
    context.go(AppConstants.routeHome);
  }

  // ===== §15: מעקה בטיחות — עקביות אריתמטית לפני שליחה ל-Comax =====

  /// דוח העקביות הנוכחי (מחושב מהשורות + הסכומים ב-UI).
  ///
  /// מוצלב מול הסה"כ שה-OCR קרא. כשהמסמך עקבי — הדוח נותן גם את הסיכומים
  /// המחושבים למילוי אוטומטי. כשלא — הוא זה שחוסם את "שלח לקופה".
  ConsistencyReport get _consistencyReport => analyzeInvoice(
        _items,
        // מול הסה"כ **שה-OCR קרא**, לא מול השדה המוצג (שהוחלף בערך המחושב) —
        // אחרת ההשוואה הייתה מחושב-מול-מחושב והאזהרה לעולם לא הייתה עולה.
        documentSubtotal: _ocrSubtotal,
        documentTotal: _ocrTotal,
        vatRate: _vatRate,
      );

  // ===== §10/§11: "שלח לקופה" = אימות → קליטה ל-Comax (דרך הקראולר) =====

  /// "שלח לקופה" — שלב ראשון: אימות מול ה-API. חסום אם יש ברקודים שאינם בקטלוג,
  /// **או** אם המספרים לא מתחברים (השורות/הסה"כ) — קריאת OCR שגויה לא תגיע ל-Comax.
  void _onUpdateInCash() {
    final l10n = AppLocalizations.of(context);
    final productsState = ref.read(productsProvider);
    if (_unknownBarcodeIndices(productsState).isNotEmpty) {
      _showValidationInfoDialog(
        l10n.barcodeIssuesTitle,
        l10n.barcodeIssuesMessage,
        isError: true,
      );
      _jumpToFirstBadBarcode();
      return;
    }
    final report = _consistencyReport;
    if (!report.isConsistent) {
      _showConsistencyBlockDialog(report);
      return;
    }
    if (report.hasWarnings) {
      // פער מול הסה"כ שבחשבונית — לא חוסם, אבל מבקשים אישור מפורש.
      _showConsistencyWarningDialog(report);
      return;
    }
    _runValidation();
  }

  /// אזהרת פער-סכומים לפני שליחה. המשתמש מחליט אם לשלוח בכל זאת.
  void _showConsistencyWarningDialog(ConsistencyReport report) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(CupertinoIcons.exclamationmark_circle_fill,
                color: AppColors.warning, size: 22),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.consistencyWarnTitle)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final w in report.warningIssues)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• ${w.message}', style: theme.textTheme.bodySmall),
              ),
            const SizedBox(height: 8),
            Text(l10n.consistencyWarnQuestion,
                style: theme.textTheme.bodyMedium),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _runValidation();
            },
            child: Text(l10n.consistencyWarnSendAnyway),
          ),
        ],
      ),
    );
  }

  /// דיאלוג חסימה כשהמספרים לא מתחברים — מראה את הממצאים המדויקים.
  void _showConsistencyBlockDialog(ConsistencyReport report) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final blocking = report.blockingIssues;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(CupertinoIcons.exclamationmark_triangle_fill,
                color: AppColors.error, size: 22),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.consistencyBlockTitle)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.consistencyBlockSubtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              for (final issue in blocking.take(12))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• ${issue.message}',
                      style: theme.textTheme.bodySmall),
                ),
              if (blocking.length > 12)
                Text('… ועוד ${blocking.length - 12}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  /// מריץ אימות. [supplierCode] — אם נשלח (אחרי בחירת ספק מההצעות), נשלח ב-header.
  /// אם לא נשלח — נבדק זיכרון מקומי {ח.פ → קוד} לשליחה אוטומטית.
  Future<void> _runValidation({String? supplierCode}) async {
    final original = widget.document;
    if (original == null) {
      context.go(AppConstants.routeHome);
      return;
    }
    if (_isValidating || _isSubmitting) return;

    HapticFeedback.lightImpact();
    setState(() {
      _isValidating = true;
      _validationErrorLines = {};
    });

    final snapshot = _documentSnapshotForPersist();
    final taxId = InvoiceValidationPayload.supplierTaxIdOf(snapshot);
    final cache = ref.read(supplierCodeCacheProvider);
    // קדימות: בחירת מועמד מפורשת → ספק שהמשתמש בחר מהרשימה → זיכרון לפי ח.פ.
    final effectiveCode = supplierCode ??
        ((_supplierCode != null && _supplierCode!.isNotEmpty)
            ? _supplierCode
            : null) ??
        (taxId.isNotEmpty ? cache[taxId] : null);

    // סוג המסמך שנבחר → ערך ה-API (תעודת כניסה/משלוח → goods_receipt).
    final docTypeForApi =
        apiDocumentTypeForLabel(AppLocalizations.of(context), _documentType);

    // שולחים את הברקוד **המלא מהקטלוג** כשבחשבונית הופיע ברקוד מקוצר (התאמה קנונית),
    // כדי שה-validate/קליטה ב-Comax ימצאו את הפריט (אחרת line_item_not_found).
    final productsState = ref.read(productsProvider);
    final payload = InvoiceValidationPayload.fromDocument(
      snapshot,
      supplierCode: effectiveCode,
      documentType: docTypeForApi,
      barcodeOf: (item) =>
          productsState
              .productForBarcode(item.itemNumber, supplierCode: effectiveCode)
              ?.barcode ??
          (item.itemNumber ?? ''),
    );

    ValidationResponse? res;
    Object? failure;
    try {
      res = await _apiClient.validateInvoice(
        payload,
        customerCode: ref.read(customerCodeProvider),
      );
    } catch (e) {
      failure = e;
    }

    if (!mounted) return;
    setState(() => _isValidating = false);

    final l10n = AppLocalizations.of(context);
    if (failure != null) {
      _showValidationInfoDialog(l10n.validationNetworkErrorTitle,
          l10n.validationNetworkErrorMessage,
          isError: true);
      return;
    }

    final r = res!;
    if (r.valid) {
      _validatedDocumentId = r.documentId;
      _showValidationSuccessDialog(l10n, r);
      return;
    }
    if (r.httpStatus == 422) {
      setState(() {
        _validationErrorLines =
            r.errors.map((e) => e.lineIndex).whereType<int>().toSet();
      });
      _showValidationErrorsDialog(l10n, r.errors, taxId);
      return;
    }
    _showValidationInfoDialog(
      l10n.validationFailedTitle,
      _generalErrorMessage(l10n, r.generalErrorCode),
      isError: true,
    );
  }

  /// המשתמש בחר ספק מההצעות: שומר את הקוד לח.פ זה (לסשן) ושולח שוב עם supplierCode.
  void _onPickSupplierCandidate(String taxId, String code) {
    if (code.trim().isNotEmpty) {
      _supplierCode = code.trim();
    }
    if (taxId.isNotEmpty && code.isNotEmpty) {
      final cache =
          Map<String, String>.from(ref.read(supplierCodeCacheProvider));
      cache[taxId] = code;
      ref.read(supplierCodeCacheProvider.notifier).state = cache;
    }
    _runValidation(supplierCode: code);
  }

  String _generalErrorMessage(AppLocalizations l10n, String? code) {
    switch (code) {
      case 'unauthorized':
      case 'insufficient_scope':
      case 'customer_not_found':
      case 'customer_not_allowed':
      case 'ambiguous_customer_code':
        return l10n.validationConfigError;
      case 'rate_limited':
        return l10n.validationRateLimited;
      default:
        return l10n.validationGenericError;
    }
  }

  /// שלב שני: קליטה בפועל ל-Comax. עם ?wait=false הקראולר מחזיר 202 מיד,
  /// והסטטוס הסופי מגיע דרך webhook → FoodStock-Backend (לא polling מהמכשיר).
  Future<void> _startSubmit(String documentId) async {
    if (_isSubmitting) return;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.lightImpact();
    setState(() => _isSubmitting = true);

    SubmitResponse? res;
    Object? failure;
    try {
      res = await _apiClient.submitDocument(
        documentId,
        customerCode: ref.read(customerCodeProvider),
      );
    } catch (e) {
      failure = e;
    }
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (failure != null) {
      _showSubmitErrorDialog(l10n.submitNetworkError, documentId,
          canRetry: true);
      return;
    }

    final r = res!;
    // אזהרות כפילות מגיעות **רק** מ-/documents/exists **לפני** השליחה. הקראולר
    // הסיר את possibleDuplicate מתשובת ה-submit (כפילות אמיתית נחסמת שם ב-409
    // לפני הקליטה), אז אין כאן יותר טיפול בכפילות — קליטה מוצלחת = תשובה נקייה.
    // נקלט מיד (לרוב לא יקרה עם wait=false, אבל נתמך).
    if (r.success) {
      _onSubmitReceived(documentId, r.comaxDocNumber, r.message);
      return;
    }
    // 202 — ממשיך ברקע; הסטטוס הסופי נקבע ע"י קרון הפולינג בשרת.
    if (r.processing) {
      _onSubmitProcessing(documentId);
      return;
    }
    _handleSubmitError(r, documentId);
  }

  /// 202: לסמן "ממשיך ברקע" + לשמור את comaxDocumentId ולסנכרן לבקאנד — זהו
  /// מפתח הקורלציה שקרון הפולינג בשרת מחפש לפיו. חוזרים לבית.
  void _onSubmitProcessing(String documentId) {
    final l10n = AppLocalizations.of(context);
    final updated = _documentSnapshotForPersist().copyWith(
      comaxDocumentId: documentId,
      comaxStatus: 'processing',
    );
    ref.read(documentsProvider.notifier).upsert(updated);
    HapticFeedback.mediumImpact();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.submitSuccessTitle),
        content: Text(l10n.submitBackground),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(AppConstants.routeHome);
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  /// קליטה הצליחה מיד — לסמן נשלחה (מונע שליחה כפולה) ולהציג הצלחה.
  void _onSubmitReceived(
      String documentId, String? comaxDocNumber, String? message) {
    final l10n = AppLocalizations.of(context);
    final updated = _documentSnapshotForPersist().copyWith(
      status: DocumentStatus.sentToCashRegister,
      comaxDocumentId: documentId,
      comaxDocNumber: comaxDocNumber,
      comaxStatus: 'received',
    );
    ref.read(documentsProvider.notifier).upsert(updated);
    HapticFeedback.mediumImpact();

    final text = (message != null && message.isNotEmpty)
        ? message
        : (comaxDocNumber != null && comaxDocNumber.isNotEmpty
            ? '${l10n.submitSuccessMessage} ($comaxDocNumber)'
            : l10n.submitSuccessMessage);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(CupertinoIcons.check_mark_circled_solid,
                color: AppColors.accentGreen),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.submitSuccessTitle)),
          ],
        ),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(AppConstants.routeHome);
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _handleSubmitError(SubmitResponse r, String documentId) {
    final l10n = AppLocalizations.of(context);
    final code = r.errorCode ?? '';
    final msg = (r.message != null && r.message!.isNotEmpty)
        ? r.message!
        : l10n.submitGenericError;

    // החשבונית כבר נקלטה — לחסום שליחה חוזרת ולסמן כ"נשלחה".
    if (code == 'invoice_already_received') {
      final updated = _documentSnapshotForPersist().copyWith(
        status: DocumentStatus.sentToCashRegister,
        comaxDocumentId: documentId,
        comaxDocNumber: r.comaxDocNumber,
        comaxStatus: 'received',
      );
      ref.read(documentsProvider.notifier).upsert(updated);
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.submitAlreadyReceivedTitle),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go(AppConstants.routeHome);
              },
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }

    final retryable = code == 'session_in_use' ||
        code == 'busy' ||
        r.httpStatus >= 500 ||
        code.isEmpty ||
        code == 'unknown';
    _showSubmitErrorDialog(msg, documentId, canRetry: retryable);
  }

  void _showSubmitErrorDialog(String message, String documentId,
      {required bool canRetry}) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(CupertinoIcons.exclamationmark_triangle_fill,
                color: AppColors.error),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.submitErrorTitle)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.ok),
          ),
          if (canRetry)
            FilledButton(
              style:
                  FilledButton.styleFrom(backgroundColor: AppColors.accentGreen),
              onPressed: () {
                Navigator.of(ctx).pop();
                _startSubmit(documentId);
              },
              child: Text(l10n.retry),
            ),
        ],
      ),
    );
  }

  /// דיאלוג הצלחת אימות — תצוגה מקדימה מ-resolved + כפתור "שלח לקופה" (submit).
  void _showValidationSuccessDialog(
      AppLocalizations l10n, ValidationResponse r) {
    final theme = Theme.of(context);
    final resolved = r.resolved ?? const {};
    final supplier = resolved['supplier'];
    final lines = resolved['lines'];
    final supplierName =
        supplier is Map ? (supplier['name']?.toString() ?? '') : '';
    final supplierCode =
        supplier is Map ? (supplier['code']?.toString() ?? '') : '';
    final linesCount = lines is List ? lines.length : 0;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(CupertinoIcons.check_mark_circled_solid,
                color: AppColors.accentGreen),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.validationSuccessTitle)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.message ?? l10n.validationSuccessMessage),
              const SizedBox(height: 12),
              if (supplierName.isNotEmpty)
                _kvRow(
                    theme,
                    l10n.supplierNameLabel,
                    supplierCode.isEmpty
                        ? supplierName
                        : '$supplierName ($supplierCode)'),
              _kvRow(theme, l10n.items, '$linesCount'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          if (_validatedDocumentId != null)
            FilledButton(
              style:
                  FilledButton.styleFrom(backgroundColor: AppColors.accentGreen),
              onPressed: () {
                Navigator.of(ctx).pop();
                _startSubmit(_validatedDocumentId!);
              },
              child: Text(l10n.updateInCash),
            ),
        ],
      ),
    );
  }

  Widget _kvRow(ThemeData theme, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$key: ',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  /// דיאלוג שגיאות אימות — מציג את *כל* ההודעות (כולל בחירת ספק לפי ח.פ).
  void _showValidationErrorsDialog(
      AppLocalizations l10n, List<ValidationError> errors, String taxId) {
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) {
        void pick(String code) {
          Navigator.of(ctx).pop();
          _onPickSupplierCandidate(taxId, code);
        }

        return AlertDialog(
          title: Row(
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle_fill,
                  color: AppColors.error),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(
                      '${l10n.validationErrorsTitle} (${errors.length})')),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final e in errors)
                    _validationErrorTile(theme, l10n, e, pick),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  bool _isSupplierCandidateError(ValidationError e) =>
      (e.code == 'supplier_not_found' || e.code == 'supplier_ambiguous') &&
      e.field == 'header.supplierTaxId' &&
      e.extra['candidates'] is List &&
      (e.extra['candidates'] as List).isNotEmpty;

  Widget _validationErrorTile(ThemeData theme, AppLocalizations l10n,
      ValidationError e, void Function(String code) onPick) {
    final prefix =
        e.lineIndex != null ? '${l10n.lineLabel} ${e.lineIndex! + 1}: ' : '';
    final candidates = e.extra['candidates'];
    final isSupplierPick = _isSupplierCandidateError(e);

    String? hint;
    if (!isSupplierPick && candidates is List && candidates.isNotEmpty) {
      final names = candidates.whereType<Object?>().map((c) {
        if (c is Map) {
          final n = c['name']?.toString() ?? '';
          final code = c['code']?.toString() ?? '';
          return code.isEmpty ? n : '$n ($code)';
        }
        return c.toString();
      }).join(', ');
      hint = '${l10n.suggestionsLabel}: $names';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(CupertinoIcons.circle_fill,
                size: 8, color: AppColors.error),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$prefix${e.message}', style: theme.textTheme.bodyMedium),
                if (hint != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(hint,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary)),
                  ),
                if (isSupplierPick)
                  _supplierCandidatePicker(
                      theme, l10n, candidates as List, onPick),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _supplierCandidatePicker(ThemeData theme, AppLocalizations l10n,
      List candidates, void Function(String code) onPick) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l10n.chooseCorrectSupplier}:',
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          for (final c in candidates.whereType<Object?>())
            if (c is Map)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentGreen,
                      side: const BorderSide(color: AppColors.accentGreen),
                      alignment: AlignmentDirectional.centerStart,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    onPressed: () => onPick((c['code'] ?? '').toString()),
                    child: Text(
                      _supplierCandidateLabel(c),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  String _supplierCandidateLabel(Map c) {
    final name = (c['name'] ?? '').toString();
    final code = (c['code'] ?? '').toString();
    final taxId = (c['taxId'] ?? '').toString();
    final parts = <String>[
      if (name.isNotEmpty) name,
      if (code.isNotEmpty) '($code)',
      if (taxId.isNotEmpty) 'ח.פ. $taxId',
    ];
    return parts.join('  ');
  }

  void _showValidationInfoDialog(String title, String message,
      {bool isError = false}) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isError
                  ? CupertinoIcons.exclamationmark_triangle_fill
                  : CupertinoIcons.info_circle_fill,
              color: isError ? AppColors.error : AppColors.accentGreen,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
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
