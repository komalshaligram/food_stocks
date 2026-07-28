import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../bootstrap/doc_scan_bootstrap.dart';
import '../core/constants/app_constants.dart';
import '../core/services/direct_image_capture_service.dart';
import '../core/services/invoice_api_client.dart';
import '../core/services/scan_export_service.dart';
import '../core/services/document_parser_service.dart';
import '../core/services/sync_service.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/invoice_document.dart';
import '../providers/customer_code_provider.dart';
import '../providers/documents_provider.dart';
import '../core/services/doc_scan_notifications.dart';
import '../providers/document_parser_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/suppliers_provider.dart';
import '../core/utils/date_utils.dart';
import '../widgets/document_card.dart';
import '../widgets/staggered_fade_in.dart';
import '../widgets/adaptive_bottom_sheet.dart';
import '../widgets/pre_scan_setup_sheet.dart';
import '../widgets/scan_source_sheet.dart';

enum _HomeSortMode {
  none,
  createdAtAsc,
  createdAtDesc,
  totalAmountAsc,
  totalAmountDesc,
}

class _SortChoiceChip extends StatelessWidget {
  const _SortChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      label: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          color: selected ? Colors.white : AppColors.textPrimary,
        ),
      ),
      selectedColor: AppColors.accentGreen,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: selected ? AppColors.accentGreen : AppColors.divider,
        ),
      ),
      onSelected: (_) => onSelected(),
    );
  }
}

/// ×ž×¡×š ×¨××©×™ â€“ ×ž×¦×‘ ×¨×™×§ ××• ×¨×©×™×ž×ª ×›×¨×˜×™×¡×™ ×ž×¡×ž×›×™×.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Map<String, StreamSubscription<Map<String, dynamic>>>
      _jobSubscriptions = {};
  final Map<String, Timer> _jobTimers = {};

  /// מתי כל job נכנס למצב processing (בזיכרון). לא ניתן להסתמך על `doc.createdAt`
  /// כי סריקה-מחדש מחזירה מסמך ישן ל-processing, ו-createdAt נשאר הישן —
  /// אחרת הטיימר "פג תוקף אחרי 20 דק'" יורה מיד על מסמך שנסרק לפני יומיים.
  final Map<String, DateTime> _processingSince = {};
  ProviderSubscription<List<InvoiceDocument>>? _documentsSubscription;
  Timer? _processingTimeoutTimer;
  Timer? _comaxRefreshTimer;

  /// ערכי comaxStatus שמשמעם "נשלח וממשיך ברקע" (טרם סופי) — כאלה מרעננים.
  static const Set<String> _comaxInFlightStatuses = {
    'pending',
    'processing',
    'queued',
    'receiving',
  };
  static const Duration _processingTimeout = Duration(minutes: 20);

  _HomeSortMode _sortMode = _HomeSortMode.none;

  /// §8: האם "הרצת שליפה" (סנכרון Comax) רצה כעת.
  bool _isSyncing = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  DateTime? _createdAtFrom;
  DateTime? _createdAtTo;
  DateTime? _documentDateFrom;
  DateTime? _documentDateTo;

  final Set<DocumentStatus> _selectedStatuses = {};
  final Set<String> _selectedDocumentTypes = {};
  final Set<String> _selectedSupplierNames = {};

  List<String> _documentTypeOptionsForLocale(AppLocalizations l10n) => [
        l10n.docTypeInvoice,
        l10n.docTypeDelivery,
        l10n.docTypeReceipt,
        l10n.docTypeReturn,
        l10n.docTypeCreditInvoice,
      ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startWatchingProcessingJobs(ref.read(documentsProvider));
      // מסמכים שנשלחו לקופה וממתינים (comaxStatus in-flight) — מרעננים את הסטטוס
      // מהקרולר, כדי לתפוס מסמכים שנקלטו/נכשלו בזמן שהאפליקציה הייתה סגורה (או
      // מסמכים ישנים שנתקעו על "processing" לפני שהתשאול האוטומטי נוסף).
      _refreshInFlightComaxStatuses();
    });

    _documentsSubscription = ref.listenManual<List<InvoiceDocument>>(
      documentsProvider,
      (previous, next) {
        _startWatchingProcessingJobs(next);
        _notifyComaxTransitions(next);
      },
      fireImmediately: true,
    );
    _processingTimeoutTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _markStuckProcessingAsError(),
    );
    // רענון תקופתי של סטטוס הקליטה כל עוד יש מסמכים in-flight.
    _comaxRefreshTimer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => _refreshInFlightComaxStatuses(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _documentsSubscription?.close();
    _processingTimeoutTimer?.cancel();
    _comaxRefreshTimer?.cancel();
    for (final timer in _jobTimers.values) {
      timer.cancel();
    }
    _jobTimers.clear();
    for (final sub in _jobSubscriptions.values) {
      sub.cancel();
    }
    _jobSubscriptions.clear();
    super.dispose();
  }

  /// סטטוסים שראינו לאחרונה פר-מסמך — לזיהוי **מעבר** (לא כל rebuild).
  /// מקור אמת יחיד לכל ההתראות: גם סטטוס הסריקה וגם סטטוס הקליטה ל-Comax
  /// עוברים דרך documentsProvider, כך שכל המסלולים (בית / ProcessingScreen /
  /// שליחה לקופה / קרון) מכוסים במקום אחד.
  final Map<String, DocumentStatus> _lastStatus = {};
  final Map<String, String?> _lastComaxStatus = {};

  void _notifyComaxTransitions(List<InvoiceDocument> documents) {
    for (final d in documents) {
      // מסמך שנראה בפעם הראשונה (טעינה מהאחסון/שרת, hot restart) — רק רושמים
      // את מצבו, בלי להתריע. כך אין מבול התראות על מסמכים ישנים שכבר סופיים.
      final firstSeen = !_lastStatus.containsKey(d.id);

      final prevStatus = _lastStatus[d.id];
      _lastStatus[d.id] = d.status;
      if (!firstSeen && d.status != prevStatus) {
        if (d.status == DocumentStatus.readyForUpdate) {
          DocScanNotifications.instance.scanReady(d);
        } else if (d.status == DocumentStatus.error) {
          DocScanNotifications.instance.scanFailed(d);
        }
      }

      final prevComax = _lastComaxStatus[d.id];
      _lastComaxStatus[d.id] = d.comaxStatus;
      if (!firstSeen && d.comaxStatus != prevComax) {
        if (d.comaxStatus == 'received') {
          DocScanNotifications.instance.intakeReceived(d);
        } else if (d.comaxStatus == 'failed') {
          DocScanNotifications.instance.intakeFailed(d);
        }
      }
    }
  }

  /// מרענן את סטטוס הקליטה של מסמכים in-flight מהקרולר (`getDocumentsStatus`).
  /// תופס מסמכים שנקלטו/נכשלו בזמן שהאפליקציה הייתה סגורה, ומסמכים ישנים שנתקעו
  /// על "processing" לפני שהתשאול האוטומטי נוסף. מעבר ל-received/failed יורה
  /// התראה דרך [_notifyComaxTransitions] — בין אם הרענון הזה או תשאול מסך הפרטים
  /// תפס אותו ראשון (upsert כפול של אותו סטטוס לא יורה פעמיים).
  Future<void> _refreshInFlightComaxStatuses() async {
    if (!mounted) return;
    final docs = ref.read(documentsProvider);
    final inFlight = docs
        .where((d) =>
            (d.comaxDocumentId?.isNotEmpty ?? false) &&
            d.comaxStatus != null &&
            _comaxInFlightStatuses.contains(d.comaxStatus))
        .toList();
    if (inFlight.isEmpty) return;

    final apiClient = InvoiceApiClient(app: DocScanBootstrap.firebaseApp);
    final customerCode = ref.read(customerCodeProvider);
    final notifier = ref.read(documentsProvider.notifier);
    try {
      final statuses = await apiClient.getDocumentsStatus(
        inFlight.map((d) => d.comaxDocumentId!).toList(),
        customerCode: customerCode,
      );
      if (!mounted) return;
      final byId = {for (final s in statuses) s.documentId: s};
      for (final d in inFlight) {
        final s = byId[d.comaxDocumentId];
        if (s == null || s.comaxStatus.isEmpty || s.comaxStatus == 'unknown') {
          continue;
        }
        if (s.comaxStatus == d.comaxStatus) continue;
        // לא מדכאים התראה: מעבר ל-received/failed יורה "נקלט/נכשל בקופה" גם אם
        // הרענון של מסך הבית הוא זה שתפס אותו (ולא תשאול מסך הפרטים).
        notifier.upsert(d.copyWith(
          comaxStatus: s.comaxStatus,
          comaxDocNumber: s.comaxDocNumber ?? d.comaxDocNumber,
          comaxReceiveError: s.receiveError,
          comaxReceiveErrorMessage: s.receiveErrorMessage,
          status:
              s.isReceived ? DocumentStatus.sentToCashRegister : d.status,
        ));
      }
    } catch (_) {
      // כשל רשת — הרענון הבא (טיימר/פתיחת מסך) ינסה שוב.
    }
  }

  void _startWatchingProcessingJobs(List<InvoiceDocument> documents) {
    final activeProcessingJobIds = <String>{};

    for (final doc in documents) {
      final jobId = doc.jobId;
      if (doc.status == DocumentStatus.uploading) continue;
      if (doc.status == DocumentStatus.processing &&
          jobId != null &&
          jobId.isNotEmpty) {
        activeProcessingJobIds.add(jobId);
        _processingSince.putIfAbsent(jobId, () => DateTime.now());
        _watchJob(doc.id, jobId);
      }
    }

    final stale = _jobTimers.keys
        .where((jobId) => !activeProcessingJobIds.contains(jobId))
        .toList(
          growable: false,
        );
    for (final jobId in stale) {
      _jobTimers.remove(jobId)?.cancel();
      _processingSince.remove(jobId);
    }
  }

  void _watchJob(String localDocumentId, String jobId) {
    if (_jobTimers.containsKey(jobId)) return;

    // Use polling instead of realtime listener to avoid gRPC connectivity issues
    late final Timer pollTimer;
    pollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      try {
        final payload =
            await ref.read(documentParserProvider).getJobStatusViaRest(jobId);
        if (payload == null) {
          debugPrint(
            '[HomeScreen] Job $jobId not yet in Firestore, still waiting...',
          );
          return;
        }

        _handleJobPayload(localDocumentId, jobId, payload);

        // Stop polling if job is done
        final status = (payload['status'] as String?)?.toLowerCase();
        if (status == 'completed' || status == 'error' || status == 'failed') {
          pollTimer.cancel();
          _jobTimers.remove(jobId);
          _jobSubscriptions.remove(jobId);
        }
      } catch (e) {
        debugPrint('[HomeScreen] Poll error for job $jobId: $e');
      }
    });

    _jobTimers[jobId] = pollTimer;
  }

  void _handleJobPayload(
    String localDocumentId,
    String jobId,
    Map<String, dynamic> payload,
  ) {
    try {
      final status = (payload['status'] as String?)?.toLowerCase();
      final notifier = ref.read(documentsProvider.notifier);
      final current = notifier.getDocument(localDocumentId);
      if (current == null) {
        _jobSubscriptions.remove(jobId)?.cancel();
        return;
      }

      if (status == 'completed') {
        final dynamic resultRaw = payload['result'];
        final resultMap = resultRaw is Map<String, dynamic>
            ? resultRaw
            : resultRaw is Map
                ? Map<String, dynamic>.from(resultRaw)
                : payload;
        final parsed = ParsedDocument.fromResponse(resultMap);
        final parsedDoc = parsed.toInvoiceDocument(
          pdfPath: current.pdfPath,
          imagePaths: current.imagePaths,
        );

        final readyDoc = parsedDoc.copyWith(
          id: current.id,
          createdAt: current.createdAt,
          status: DocumentStatus.readyForUpdate,
          jobId: null,
          pdfPath: current.pdfPath,
          imagePaths: current.imagePaths,
          // §13: בחירת המשתמש לפני הסריקה גוברת על מה שחולץ ב-OCR.
          documentType: current.documentType ?? parsedDoc.documentType,
          companyName: mergeCompanyNamePreferPreScan(
            current.companyName,
            parsedDoc.companyName,
          ),
          scanModel: _extractJobModelKey(payload) ?? current.scanModel,
          errorMessage: null,
        );
        notifier.upsert(readyDoc);
        _jobSubscriptions.remove(jobId)?.cancel();
        return;
      }

      if (status == 'error' || status == 'failed') {
        final errorDetails = _extractJobError(payload);
        final failedDoc = current.copyWith(
          status: DocumentStatus.error,
          scanModel: _extractJobModelKey(payload) ?? current.scanModel,
          errorMessage: errorDetails,
          parsedJson: const JsonEncoder.withIndent('  ').convert(payload),
        );
        notifier.upsert(failedDoc);
        _jobSubscriptions.remove(jobId)?.cancel();
        return;
      }

      // Job document is not present in Firestore (or we don't have access),
      // so the UI would otherwise stay stuck in `processing` forever.
      if (status == 'missing') {
        debugPrint(
            '[HomeScreen] Job $jobId not yet in Firestore, still waiting...');
        return;
      }
    } catch (_) {
      final notifier = ref.read(documentsProvider.notifier);
      final current = notifier.getDocument(localDocumentId);
      if (current != null) {
        notifier.upsert(
          current.copyWith(
            status: DocumentStatus.error,
            errorMessage: 'Failed to parse job payload',
          ),
        );
      }
      _jobSubscriptions.remove(jobId)?.cancel();
    }
  }

  String _extractJobError(Map<String, dynamic> payload) {
    final candidates = <Object?>[
      payload['error'],
      payload['message'],
      payload['details'],
      payload['reason'],
      payload['code'],
    ];
    for (final value in candidates) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return 'Document processing failed';
  }

  String? _extractJobModelKey(Map<String, dynamic> payload) {
    final candidates = <Object?>[
      payload['model'],
      payload['modelKey'],
      payload['selectedModel'],
      payload['usedModel'],
      (payload['result'] is Map<String, dynamic>)
          ? (payload['result'] as Map<String, dynamic>)['model']
          : null,
    ];
    for (final value in candidates) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return null;
  }

  void _markStuckProcessingAsError() {
    final notifier = ref.read(documentsProvider.notifier);
    final now = DateTime.now();
    for (final doc in ref.read(documentsProvider)) {
      if (doc.status != DocumentStatus.processing &&
          doc.status != DocumentStatus.uploading) {
        continue;
      }
      // נמדד מרגע שה-job נכנס ל-processing (בסשן הנוכחי), לא מ-createdAt.
      // מסמך שסונכרן משרת ואיננו מכירים מתי החל — לא נפסול בטעות; נתחיל למדוד עכשיו.
      final jobId0 = doc.jobId;
      final since = jobId0 != null
          ? _processingSince.putIfAbsent(jobId0, () => now)
          : (_processingSince[doc.id] ??= now);
      if (now.difference(since) < _processingTimeout) continue;
      notifier.upsert(
        doc.copyWith(
          status: DocumentStatus.error,
          jobId: null,
          errorMessage:
              'Processing timed out after ${_processingTimeout.inMinutes} minutes',
        ),
      );
      final jobId = doc.jobId;
      if (jobId != null) {
        _jobSubscriptions.remove(jobId)?.cancel();
      }
    }
  }

  List<String> _supplierSuggestions() {
    final docs = ref.read(documentsProvider);
    final names = docs
        .map((d) => (d.companyName ?? '').trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
    names.sort();
    return names;
  }

  // ===== §8: "הרצת שליפה" — סנכרון נתוני Comax (trigger + polling בצד הקליינט) =====

  /// אישור לפני שליפה: המשתמש חייב להיות מנותק מה-Comax שלו (חיבור יחיד).
  Future<bool> _confirmRunSync(AppLocalizations l10n) async {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) {
        if (isIos) {
          return CupertinoAlertDialog(
            title: Text(l10n.syncConfirmTitle),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l10n.syncConfirmMessage),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogCtx).pop(false),
                child: Text(l10n.cancel),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(dialogCtx).pop(true),
                child: Text(l10n.syncConfirmContinue),
              ),
            ],
          );
        }
        return AlertDialog(
          title: Row(
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle,
                  color: AppColors.accentGreen, size: 22),
              const SizedBox(width: 8),
              Expanded(child: Text(l10n.syncConfirmTitle)),
            ],
          ),
          content: Text(l10n.syncConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accentGreen),
              onPressed: () => Navigator.of(dialogCtx).pop(true),
              child: Text(l10n.syncConfirmContinue),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _runSync() async {
    if (_isSyncing) return;
    final l10n = AppLocalizations.of(context);
    // אישור — לוודא שהמשתמש מנותק מ-Comax לפני שליפה (חיבור יחיד; אחרת session_in_use).
    final confirmed = await _confirmRunSync(l10n);
    if (confirmed != true || !mounted) return;
    setState(() => _isSyncing = true);
    final svc = SyncService(app: DocScanBootstrap.firebaseApp);
    final customerCode = ref.read(customerCodeProvider);
    try {
      // שלב 1: הפעלה (POST /run) — מחזיר מיד success / running / error.
      final trigger = await svc.triggerFetch(customerCode: customerCode);
      if (!mounted) return;

      if (trigger.phase == 'success') {
        _onSyncSuccess(l10n);
        return;
      }
      if (trigger.phase == 'error') {
        await _showSyncErrorDialog(
          _syncCodeMessage(trigger.code, trigger.message, l10n),
        );
        return;
      }

      // שלב 2: polling (התקבל running) — בודקים סטטוס כל 10 שניות, עד 6 דקות.
      final deadline = DateTime.now().add(const Duration(minutes: 6));
      while (DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(seconds: 10));
        if (!mounted) return;
        RunStatusResult st;
        try {
          st = await svc.getRunStatus(customerCode: customerCode);
        } catch (_) {
          continue; // שגיאת רשת זמנית — ממשיכים ל-poll.
        }
        if (!mounted) return;
        final s = st.status;
        if (s == 'success') {
          _onSyncSuccess(l10n);
          return;
        }
        if (s == 'session_in_use' ||
            s == 'bad_credentials' ||
            s == 'failed' ||
            s == 'error') {
          await _showSyncErrorDialog(
            _syncCodeMessage(s == 'error' ? st.code : s, st.message, l10n),
          );
          return;
        }
        // queued / running / unknown → ממשיכים.
      }
      await _showSyncErrorDialog(l10n.syncTimeout);
    } on FirebaseFunctionsException catch (e) {
      if (!mounted) return;
      final code =
          e.details is Map ? (e.details as Map)['error']?.toString() : null;
      await _showSyncErrorDialog(_syncCodeMessage(code, e.message, l10n));
    } catch (e) {
      if (!mounted) return;
      await _showSyncErrorDialog(l10n.unexpectedError(e.toString()));
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  void _onSyncSuccess(AppLocalizations l10n) {
    // הנתונים התעדכנו — מרעננים את ה-cache של הספקים והקטלוג.
    ref.read(suppliersProvider.notifier).load(force: true);
    _showSyncSuccessDialog(l10n);
  }

  Future<void> _showSyncSuccessDialog(AppLocalizations l10n) async {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        if (isIos) {
          return CupertinoAlertDialog(
            title: Text(l10n.syncDone),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l10n.syncDoneMessage),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(l10n.ok),
              ),
            ],
          );
        }
        return AlertDialog(
          title: Row(
            children: [
              const Icon(CupertinoIcons.check_mark_circled_solid,
                  color: AppColors.accentGreen, size: 24),
              const SizedBox(width: 8),
              Text(l10n.syncDone),
            ],
          ),
          content: Text(l10n.syncDoneMessage),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  String _syncCodeMessage(
    String? code,
    String? apiMessage,
    AppLocalizations l10n,
  ) {
    switch (code) {
      case 'session_in_use':
        return l10n.syncSessionInUse;
      case 'bad_credentials':
        return l10n.syncBadCredentials;
      case 'fetch_failed':
      case 'failed':
        return l10n.syncFailed;
      case 'rate_limited':
        return l10n.syncRateLimited;
      case 'insufficient_scope':
        return l10n.syncNoPermission;
      default:
        final m = (apiMessage ?? '').trim();
        return m.isNotEmpty ? m : l10n.syncFailed;
    }
  }

  Future<void> _showSyncErrorDialog(String message) async {
    final l10n = AppLocalizations.of(context);
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        if (isIos) {
          return CupertinoAlertDialog(
            title: Text(l10n.syncErrorTitle),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(message),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(l10n.ok),
              ),
            ],
          );
        }
        return AlertDialog(
          title: Row(
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle,
                  color: Colors.red, size: 22),
              const SizedBox(width: 8),
              Text(l10n.syncErrorTitle),
            ],
          ),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentsProvider);
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final visibleDocuments = _applySortMode(
      _applySearch(
        _applyFilters(documents),
      ),
    );
    return Scaffold(
      appBar: widget.embedded ? null : _buildAppBar(context, ref, l10n, locale),
      body: Column(
        children: [
          _buildSearchAndFilter(context, l10n),
          _buildActiveSortBar(l10n),
          _buildActiveFiltersBar(l10n),
          Expanded(
            child: visibleDocuments.isEmpty
                ? _buildEmptyState(context, l10n)
                : _buildList(context, ref, visibleDocuments, l10n),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context, ref, l10n),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Locale locale,
  ) {
    final theme = Theme.of(context);
    final isHebrew = locale.languageCode == 'he';
    return AppBar(
      title: Text(l10n.appName),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(localeProvider.notifier).state =
                isHebrew ? localeEn : localeHe;
          },
          child: Text(
            isHebrew
                ? l10n.languageEnglishOptionLabel
                : l10n.languageHebrewOptionLabel,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
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
    );
  }

  /// ××–×•×¨ ×—×™×¤×•×© ×•×¡×™× ×•×Ÿ (UI ×‘×œ×‘×“ â€“ ×œ×œ× ×œ×•×’×™×§×” ××ž×™×ª×™×ª).
  Widget _buildSearchAndFilter(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) {
                setState(() => _searchQuery = v);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(CupertinoIcons.search),
                hintText: l10n.searchHint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppColors.accentGreen,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // §8: "הרצת שליפה" — רענון נתוני ה-Comax (ספקים/מוצרים/מחירים/מבצעים).
          IconButton(
            tooltip: l10n.runSyncButton,
            onPressed: _isSyncing ? null : _runSync,
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accentGreen,
                    ),
                  )
                : const Icon(CupertinoIcons.arrow_2_circlepath,
                    color: AppColors.accentGreen),
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: () => _showFilterSheet(context, l10n),
            icon: const Icon(CupertinoIcons.slider_horizontal_3,
                color: AppColors.accentGreen),
            label: Text(
              l10n.sortAndFilter,
              style: const TextStyle(color: AppColors.accentGreen),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accentGreen,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          ),
        ],
      ),
    );
  }

  List<InvoiceDocument> _applySearch(List<InvoiceDocument> documents) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return documents;

    bool contains(String? raw) {
      if (raw == null) return false;
      return raw.toLowerCase().contains(q);
    }

    return documents.where((d) {
      return contains(d.documentNumber) ||
          contains(d.companyName) ||
          contains(d.documentType);
    }).toList(growable: false);
  }

  List<InvoiceDocument> _applySortMode(List<InvoiceDocument> documents) {
    final list = List<InvoiceDocument>.from(documents);
    switch (_sortMode) {
      case _HomeSortMode.none:
        return list;
      case _HomeSortMode.createdAtAsc:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return list;
      case _HomeSortMode.createdAtDesc:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      case _HomeSortMode.totalAmountAsc:
        list.sort((a, b) => (a.totalAmount ?? 0).compareTo(b.totalAmount ?? 0));
        return list;
      case _HomeSortMode.totalAmountDesc:
        list.sort((a, b) => (b.totalAmount ?? 0).compareTo(a.totalAmount ?? 0));
        return list;
    }
  }

  Widget _buildActiveSortBar(AppLocalizations l10n) {
    if (_sortMode == _HomeSortMode.none && !_hasActiveFilters) {
      return const SizedBox.shrink();
    }

    final label = switch (_sortMode) {
      _HomeSortMode.createdAtAsc => l10n.sortByCreatedAtOldest,
      _HomeSortMode.createdAtDesc => l10n.sortByCreatedAtNewest,
      _HomeSortMode.totalAmountAsc => l10n.sortByTotalAmountLow,
      _HomeSortMode.totalAmountDesc => l10n.sortByTotalAmountHigh,
      _HomeSortMode.none => l10n.sortNone,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(CupertinoIcons.arrow_up_arrow_down,
                color: AppColors.accentGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
            ),
            TextButton.icon(
              onPressed: () => setState(() => _sortMode = _HomeSortMode.none),
              icon: const Icon(CupertinoIcons.xmark,
                  size: 18, color: AppColors.accentGreen),
              label: Text(l10n.clearSortAndFilter),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime? _tryParseDocumentDate(String? raw) {
    if (raw == null) return null;
    final v = raw.trim();
    if (v.isEmpty || v == AppConstants.emptyFieldPlaceholder) return null;

    final direct = DateTime.tryParse(v);
    if (direct != null) return direct;

    if (v.contains('.')) {
      final parts = v.split('.');
      if (parts.length == 3) {
        final dd = int.tryParse(parts[0]);
        final mm = int.tryParse(parts[1]);
        final yyyy = int.tryParse(parts[2]);
        if (dd != null && mm != null && yyyy != null) {
          return DateTime(yyyy, mm, dd);
        }
      }
    }
    return null;
  }

  bool get _hasActiveFilters =>
      _createdAtFrom != null ||
      _createdAtTo != null ||
      _documentDateFrom != null ||
      _documentDateTo != null ||
      _selectedStatuses.isNotEmpty ||
      _selectedDocumentTypes.isNotEmpty ||
      _selectedSupplierNames.isNotEmpty;

  String _rangeLabel(DateTime? from, DateTime? to, AppLocalizations l10n) {
    final f = from != null ? _dateOnly(from) : null;
    final t = to != null ? _dateOnly(to) : null;
    if (f == null && t == null) return l10n.rangeNoneLabel;
    if (f != null && t != null)
      return '${formatDisplayDate(f)} - ${formatDisplayDate(t)}';
    if (f != null) return '${formatDisplayDate(f)} +';
    return formatDisplayDate(t!);
  }

  Future<DateTimeRange?> _pickDateRangeAdaptive({
    required BuildContext context,
    DateTime? currentFrom,
    DateTime? currentTo,
    required AppLocalizations l10n,
  }) async {
    final now = DateTime.now();
    final firstDate = DateTime(2000);
    final lastDate = DateTime(2100);
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIos) {
      DateTime tempFrom = _dateOnly(currentFrom ?? now);
      DateTime tempTo = _dateOnly(currentTo ?? tempFrom);
      if (tempTo.isBefore(tempFrom)) tempTo = tempFrom;

      final picked = await showCupertinoModalPopup<DateTimeRange>(
        context: context,
        builder: (ctx) {
          return Container(
            height: 360,
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
                            style:
                                const TextStyle(color: AppColors.accentGreen),
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          onPressed: () => Navigator.of(ctx).pop(
                            DateTimeRange(
                              start: _dateOnly(tempFrom),
                              end: _dateOnly(tempTo),
                            ),
                          ),
                          child: Text(
                            l10n.save,
                            style:
                                const TextStyle(color: AppColors.accentGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  '×‘×—×¨ ×ž×ª××¨×™×š',
                                  style: Theme.of(ctx)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  minimumDate: firstDate,
                                  maximumDate: lastDate,
                                  initialDateTime: tempFrom,
                                  onDateTimeChanged: (value) {
                                    tempFrom = _dateOnly(value);
                                    if (tempTo.isBefore(tempFrom)) {
                                      tempTo = tempFrom;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  '×‘×—×¨ ×¢×“ ×ª××¨×™×š',
                                  style: Theme.of(ctx)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  minimumDate: firstDate,
                                  maximumDate: lastDate,
                                  initialDateTime: tempTo,
                                  onDateTimeChanged: (value) {
                                    tempTo = _dateOnly(value);
                                    if (tempTo.isBefore(tempFrom)) {
                                      tempFrom = tempTo;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      return picked;
    }

    return showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: (currentFrom != null || currentTo != null)
          ? DateTimeRange(
              start: currentFrom ?? currentTo!,
              end: currentTo ?? currentFrom!,
            )
          : null,
      helpText: l10n.helpTextChooseRange,
    );
  }

  String _statusLabel(DocumentStatus status, AppLocalizations l10n) {
    switch (status) {
      case DocumentStatus.scanning:
        return l10n.statusScanning;
      case DocumentStatus.uploading:
        return l10n.statusUploading;
      case DocumentStatus.processing:
        return l10n.statusProcessing;
      case DocumentStatus.readyForUpdate:
        return l10n.statusReadyForUpdate;
      case DocumentStatus.completed:
        return l10n.statusCompleted;
      case DocumentStatus.sentToCashRegister:
        return l10n.statusSentToCashRegister;
      case DocumentStatus.error:
        return l10n.statusError;
      case DocumentStatus.deleted:
        return l10n.statusDeleted;
    }
  }

  List<InvoiceDocument> _applyFilters(List<InvoiceDocument> documents) {
    final createdFrom =
        _createdAtFrom != null ? _dateOnly(_createdAtFrom!) : null;
    final createdTo = _createdAtTo != null ? _dateOnly(_createdAtTo!) : null;
    final documentFrom =
        _documentDateFrom != null ? _dateOnly(_documentDateFrom!) : null;
    final documentTo =
        _documentDateTo != null ? _dateOnly(_documentDateTo!) : null;

    return documents.where((d) {
      // ×¡×˜×˜×•×¡
      if (_selectedStatuses.isNotEmpty &&
          !_selectedStatuses.contains(d.status)) {
        return false;
      }

      // ×¡×•×’ ×ž×¡×ž×š
      if (_selectedDocumentTypes.isNotEmpty) {
        if (d.documentType == null ||
            !_selectedDocumentTypes.contains(d.documentType)) {
          return false;
        }
      }

      // ×©× ×¡×¤×§
      if (_selectedSupplierNames.isNotEmpty) {
        final name = d.companyName?.trim();
        if (name == null ||
            name.isEmpty ||
            !_selectedSupplierNames.contains(name)) {
          return false;
        }
      }

      // ×ª××¨×™×š ×™×¦×™×¨×”
      if (createdFrom != null || createdTo != null) {
        final date = _dateOnly(d.createdAt);
        if (createdFrom != null && date.isBefore(createdFrom)) return false;
        if (createdTo != null && date.isAfter(createdTo)) return false;
      }

      // ×ª××¨×™×š ×ž×¡×ž×š
      if (documentFrom != null || documentTo != null) {
        final parsed = _tryParseDocumentDate(d.documentDate);
        if (parsed == null) return false;
        final date = _dateOnly(parsed);
        if (documentFrom != null && date.isBefore(documentFrom)) return false;
        if (documentTo != null && date.isAfter(documentTo)) return false;
      }

      return true;
    }).toList(growable: false);
  }

  Widget _buildActiveFiltersBar(AppLocalizations l10n) {
    if (!_hasActiveFilters) return const SizedBox.shrink();

    String previewTwoOrLess(List<String> items) {
      final sorted = List<String>.from(items)..sort();
      if (sorted.isEmpty) return '';
      if (sorted.length == 1) return sorted.first;
      if (sorted.length == 2) return '${sorted[0]}, ${sorted[1]}';
      return '${sorted[0]}, ${sorted[1]}...';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                if (_createdAtFrom != null || _createdAtTo != null)
                  _activeFilterChip(
                    label: l10n.filterCreatedDatePreview(
                      _rangeLabel(_createdAtFrom, _createdAtTo, l10n),
                    ),
                    onClear: () => setState(() {
                      _createdAtFrom = null;
                      _createdAtTo = null;
                    }),
                  ),
                if (_documentDateFrom != null || _documentDateTo != null)
                  _activeFilterChip(
                    label: l10n.filterDocumentDatePreview(
                      _rangeLabel(_documentDateFrom, _documentDateTo, l10n),
                    ),
                    onClear: () => setState(() {
                      _documentDateFrom = null;
                      _documentDateTo = null;
                    }),
                  ),
                if (_selectedDocumentTypes.isNotEmpty)
                  _activeFilterChip(
                    label: l10n.filterDocumentTypePreview(
                      previewTwoOrLess(_selectedDocumentTypes.toList()),
                    ),
                    onClear: () =>
                        setState(() => _selectedDocumentTypes.clear()),
                  ),
                if (_selectedSupplierNames.isNotEmpty)
                  _activeFilterChip(
                    label: l10n.filterSupplierPreview(
                      previewTwoOrLess(_selectedSupplierNames.toList()),
                    ),
                    onClear: () =>
                        setState(() => _selectedSupplierNames.clear()),
                  ),
                if (_selectedStatuses.isNotEmpty)
                  _activeFilterChip(
                    label: l10n.filterStatusPreview(
                      previewTwoOrLess(
                        _selectedStatuses
                            .map((s) => _statusLabel(s, l10n))
                            .toList(),
                      ),
                    ),
                    onClear: () => setState(() => _selectedStatuses.clear()),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() {
                  _createdAtFrom = null;
                  _createdAtTo = null;
                  _documentDateFrom = null;
                  _documentDateTo = null;
                  _selectedStatuses.clear();
                  _selectedDocumentTypes.clear();
                  _selectedSupplierNames.clear();
                }),
                icon: const Icon(CupertinoIcons.trash,
                    color: AppColors.accentGreen),
                label: Text(
                  l10n.clearSortAndFilter,
                  style: const TextStyle(
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeFilterChip({
    required String label,
    required VoidCallback onClear,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.check_mark_circled_solid,
              size: 16, color: AppColors.accentGreen),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onClear,
            borderRadius: BorderRadius.circular(12),
            child: const Icon(CupertinoIcons.xmark,
                size: 18, color: AppColors.accentGreen),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterSheet(
      BuildContext context, AppLocalizations l10n) async {
    final theme = Theme.of(context);
    await showAdaptiveBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: StatefulBuilder(
              builder: (ctx, setModalState) {
                final createdLabel =
                    _rangeLabel(_createdAtFrom, _createdAtTo, l10n);
                final documentLabel =
                    _rangeLabel(_documentDateFrom, _documentDateTo, l10n);

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.sortAndFilter,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentGreen,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      _filterTile(
                        icon: CupertinoIcons.calendar,
                        title: l10n.filterCreatedDate,
                        subtitle: createdLabel,
                        onTap: () {
                          _pickDateRangeAdaptive(
                            context: ctx,
                            currentFrom: _createdAtFrom,
                            currentTo: _createdAtTo,
                            l10n: l10n,
                          ).then((picked) {
                            if (picked == null) return;
                            setState(() {
                              _createdAtFrom = _dateOnly(picked.start);
                              _createdAtTo = _dateOnly(picked.end);
                            });
                            setModalState(() {});
                          });
                        },
                      ),
                      _filterTile(
                        icon: CupertinoIcons.doc_text,
                        title: l10n.filterDocumentDate,
                        subtitle: documentLabel,
                        onTap: () {
                          _pickDateRangeAdaptive(
                            context: ctx,
                            currentFrom: _documentDateFrom,
                            currentTo: _documentDateTo,
                            l10n: l10n,
                          ).then((picked) {
                            if (picked == null) return;
                            setState(() {
                              _documentDateFrom = _dateOnly(picked.start);
                              _documentDateTo = _dateOnly(picked.end);
                            });
                            setModalState(() {});
                          });
                        },
                      ),
                      _filterTile(
                        icon: CupertinoIcons.list_bullet,
                        title: l10n.filterDocumentType,
                        subtitle: _selectedDocumentTypes.isEmpty
                            ? l10n.rangeNoneLabel
                            : _previewFromSet(_selectedDocumentTypes.toList()),
                        onTap: () {
                          _pickDocumentTypes(
                            context: ctx,
                            initiallySelected: _selectedDocumentTypes.toSet(),
                          ).then((picked) {
                            if (picked == null) return;
                            setState(() {
                              _selectedDocumentTypes
                                ..clear()
                                ..addAll(picked);
                            });
                            setModalState(() {});
                          });
                        },
                      ),
                      _filterTile(
                        icon: CupertinoIcons.person,
                        title: l10n.supplierNameLabel,
                        subtitle: _selectedSupplierNames.isEmpty
                            ? l10n.rangeNoneLabel
                            : _previewFromSet(_selectedSupplierNames.toList()),
                        onTap: () {
                          _pickSupplierNamesToggle(
                            context: ctx,
                            options: _supplierSuggestions(),
                            initiallySelected: _selectedSupplierNames.toSet(),
                          ).then((picked) {
                            if (picked == null) return;
                            setState(() => _selectedSupplierNames
                              ..clear()
                              ..addAll(picked));
                            setModalState(() {});
                          });
                        },
                      ),
                      _filterTile(
                        icon: CupertinoIcons.tag,
                        title: l10n.filterStatus,
                        subtitle: _selectedStatuses.isEmpty
                            ? l10n.rangeNoneLabel
                            : _previewFromSet(_selectedStatuses
                                .map((s) => _statusLabel(s, l10n))
                                .toList()),
                        onTap: () {
                          _pickStatusesToggle(
                            context: ctx,
                            initiallySelected: _selectedStatuses.toSet(),
                            l10n: l10n,
                          ).then((picked) {
                            if (picked == null) return;
                            setState(() => _selectedStatuses
                              ..clear()
                              ..addAll(picked));
                            setModalState(() {});
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.sortTileTitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _SortChoiceChip(
                            label: l10n.sortNone,
                            selected: _sortMode == _HomeSortMode.none,
                            onSelected: () {
                              setState(() => _sortMode = _HomeSortMode.none);
                              setModalState(() {});
                            },
                          ),
                          _SortChoiceChip(
                            label: l10n.sortByCreatedAtNewest,
                            selected: _sortMode == _HomeSortMode.createdAtDesc,
                            onSelected: () {
                              setState(() =>
                                  _sortMode = _HomeSortMode.createdAtDesc);
                              setModalState(() {});
                            },
                          ),
                          _SortChoiceChip(
                            label: l10n.sortByCreatedAtOldest,
                            selected: _sortMode == _HomeSortMode.createdAtAsc,
                            onSelected: () {
                              setState(
                                  () => _sortMode = _HomeSortMode.createdAtAsc);
                              setModalState(() {});
                            },
                          ),
                          _SortChoiceChip(
                            label: l10n.sortByTotalAmountHigh,
                            selected:
                                _sortMode == _HomeSortMode.totalAmountDesc,
                            onSelected: () {
                              setState(() =>
                                  _sortMode = _HomeSortMode.totalAmountDesc);
                              setModalState(() {});
                            },
                          ),
                          _SortChoiceChip(
                            label: l10n.sortByTotalAmountLow,
                            selected: _sortMode == _HomeSortMode.totalAmountAsc,
                            onSelected: () {
                              setState(() =>
                                  _sortMode = _HomeSortMode.totalAmountAsc);
                              setModalState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.accentGreen,
                                side: const BorderSide(
                                    color: AppColors.accentGreen),
                              ),
                              onPressed: () {
                                setState(() {
                                  _sortMode = _HomeSortMode.none;
                                  _createdAtFrom = null;
                                  _createdAtTo = null;
                                  _documentDateFrom = null;
                                  _documentDateTo = null;
                                  _selectedStatuses.clear();
                                  _selectedDocumentTypes.clear();
                                  _selectedSupplierNames.clear();
                                });
                                setModalState(() {});
                              },
                              child: Text(l10n.clearSortAndFilter),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accentGreen,
                              ),
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(l10n.save),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _filterTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.accentGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? CupertinoIcons.chevron_back
                      : CupertinoIcons.chevron_forward,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _previewFromSet(List<String> items) {
    final sorted = List<String>.from(items)..sort();
    if (sorted.length <= 2) return sorted.join(', ');
    return '${sorted[0]}, ${sorted[1]}...';
  }

  Future<Set<DocumentStatus>?> _pickStatusesToggle({
    required BuildContext context,
    required Set<DocumentStatus> initiallySelected,
    required AppLocalizations l10n,
  }) async {
    final options = <DocumentStatus>[
      DocumentStatus.scanning,
      DocumentStatus.uploading,
      DocumentStatus.processing,
      DocumentStatus.readyForUpdate,
      DocumentStatus.completed,
      DocumentStatus.sentToCashRegister,
      DocumentStatus.error,
    ];

    final picked = await showAdaptiveBottomSheet<Set<DocumentStatus>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final selected = <DocumentStatus>{...initiallySelected};
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  height: MediaQuery.of(ctx).size.height * 0.58,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              AppColors.headerGradientStart,
                              AppColors.headerGradientEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.info,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.filterStatus,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(null),
                              icon: const Icon(
                                CupertinoIcons.xmark,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          children: options.map((status) {
                            final isOn = selected.contains(status);
                            return SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                _statusLabel(status, l10n),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              value: isOn,
                              // activeThumbColor: AppColors.accentGreen,
                              activeTrackColor:
                                  AppColors.accentGreen.withOpacity(0.35),
                              trackOutlineColor: WidgetStateProperty.all(
                                Colors.grey.shade300.withOpacity(0.9),
                              ),
                              inactiveThumbColor: Colors.grey.shade300,
                              inactiveTrackColor:
                                  Colors.grey.shade300.withOpacity(0.35),
                              onChanged: (v) {
                                setModalState(() {
                                  if (v) {
                                    selected.add(status);
                                  } else {
                                    selected.remove(status);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setModalState(() => selected.clear());
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.accentGreen,
                                  side: const BorderSide(
                                    color: AppColors.accentGreen,
                                  ),
                                ),
                                child: Text(l10n.clear),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(selected),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.accentGreen,
                                ),
                                child: Text(l10n.select),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    return picked;
  }

  Future<Set<String>?> _pickDocumentTypes({
    required BuildContext context,
    required Set<String> initiallySelected,
  }) async {
    final picked = await showAdaptiveBottomSheet<Set<String>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        final documentTypeOptions = _documentTypeOptionsForLocale(l10n);
        final selected = <String>{...initiallySelected};
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  height: MediaQuery.of(ctx).size.height * 0.8,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              AppColors.headerGradientStart,
                              AppColors.headerGradientEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.doc_text,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.filterDocumentType,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(null),
                              icon: const Icon(CupertinoIcons.xmark,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: documentTypeOptions.map<Widget>((type) {
                            final isOn = selected.contains(type);
                            return SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              value: isOn,
                              // activeThumbColor: AppColors.accentGreen,
                              activeTrackColor:
                                  AppColors.accentGreen.withOpacity(0.35),
                              trackOutlineColor: WidgetStateProperty.all(
                                Colors.grey.shade300.withOpacity(0.9),
                              ),
                              inactiveThumbColor: Colors.grey.shade300,
                              inactiveTrackColor:
                                  Colors.grey.shade300.withOpacity(0.35),
                              onChanged: (v) {
                                setModalState(() {
                                  if (v) {
                                    selected.add(type);
                                  } else {
                                    selected.remove(type);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setModalState(() => selected.clear());
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.accentGreen,
                                  side: const BorderSide(
                                    color: AppColors.accentGreen,
                                  ),
                                ),
                                child: Text(l10n.clear),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(selected),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.accentGreen,
                                ),
                                child: Text(l10n.select),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    return picked;
  }

  Future<Set<String>?> _pickSupplierNamesToggle({
    required BuildContext context,
    required List<String> options,
    required Set<String> initiallySelected,
  }) async {
    final l10n = AppLocalizations.of(context);
    final sortedOptions = List<String>.from(options)..sort();
    final picked = await showAdaptiveBottomSheet<Set<String>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final selected = <String>{...initiallySelected};
        String query = '';
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filteredOptions = query.trim().isEmpty
                ? sortedOptions
                : sortedOptions
                    .where((n) =>
                        n.toLowerCase().contains(query.trim().toLowerCase()))
                    .toList(growable: false);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  height: MediaQuery.of(ctx).size.height * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              AppColors.headerGradientStart,
                              AppColors.headerGradientEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.person,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.supplierNameLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(null),
                              icon: const Icon(
                                CupertinoIcons.xmark,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          onChanged: (v) {
                            query = v;
                            setModalState(() {});
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              CupertinoIcons.search,
                              color: AppColors.accentGreen,
                            ),
                            hintText: l10n.supplierSearchHint,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: AppColors.accentGreen,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: sortedOptions.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    l10n.noSavedSuppliers,
                                    style: Theme.of(ctx)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                              )
                            : filteredOptions.isEmpty
                                ? Center(
                                    child: Text(
                                      l10n.noResults,
                                      style: Theme.of(ctx)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    itemCount: filteredOptions.length,
                                    itemBuilder: (context, index) {
                                      final name = filteredOptions[index];
                                      final isOn = selected.contains(name);
                                      return SwitchListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        value: isOn,
                                        // activeThumbColor: AppColors.accentGreen,
                                        activeTrackColor: AppColors.accentGreen
                                            .withOpacity(0.35),
                                        trackOutlineColor:
                                            WidgetStateProperty.all(
                                          Colors.grey.shade300.withOpacity(0.9),
                                        ),
                                        inactiveThumbColor:
                                            Colors.grey.shade300,
                                        inactiveTrackColor: Colors.grey.shade300
                                            .withOpacity(0.35),
                                        onChanged: (v) {
                                          setModalState(() {
                                            if (v) {
                                              selected.add(name);
                                            } else {
                                              selected.remove(name);
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setModalState(() => selected.clear());
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.accentGreen,
                                  side: const BorderSide(
                                    color: AppColors.accentGreen,
                                  ),
                                ),
                                child: Text(l10n.clear),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(selected),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.accentGreen,
                                ),
                                child: Text(l10n.select),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    return picked;
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.doc_text_viewfinder,
                size: 64,
                color: AppColors.accentGreen.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.emptyTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref,
      List<InvoiceDocument> documents, AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: () => ref.read(documentsProvider.notifier).loadFromStorage(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return StaggeredFadeIn(
            // Prevent "empty list" feeling when scrolling back up:
            // stagger delay grows with index; cap it so items appear quickly.
            delay: Duration(milliseconds: (80 * index).clamp(0, 220)),
            child: Dismissible(
              key: ValueKey(doc.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _confirmDelete(context, ref, doc.id, l10n),
              background: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Icon(
                  CupertinoIcons.trash,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              child: DocumentCard(document: doc),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, WidgetRef ref, String id,
      AppLocalizations l10n) async {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => isIos
          ? CupertinoAlertDialog(
              title: Text(l10n.deleteDocumentTitle),
              content: Text(l10n.deleteDocumentConfirm),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.cancel),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.delete),
                ),
              ],
            )
          : AlertDialog(
              title: Text(l10n.deleteDocumentTitle),
              content: Text(l10n.deleteDocumentConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.delete),
                ),
              ],
            ),
    );

    if (result == true) {
      HapticFeedback.mediumImpact();
      await ref.read(documentsProvider.notifier).deleteById(id);
      return true;
    }
    return false;
  }

  Widget _buildFAB(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            AppColors.headerGradientStart,
            AppColors.headerGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.headerGradientStart.withOpacity(0.45),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () async {
          HapticFeedback.lightImpact();

          // §6/§13: בחירת סוג מסמך + ספק לפני הסריקה (גוברת על ה-OCR).
          final setup = await showPreScanSetupSheet(context, ref);
          if (!context.mounted || setup == null) return;

          final source = await showScanSourceSheet(context);
          if (!context.mounted || source == null) return;

          final capture = DirectImageCaptureService();
          List<File>? imageFiles;
          String? pdfPath;

          if (source == ScanCaptureSource.gallery) {
            imageFiles = await capture.captureFromGallery(context, l10n);
          } else if (Platform.isIOS) {
            imageFiles = await capture.captureFromVisionKit();
            if (imageFiles != null && imageFiles.isNotEmpty) {
              pdfPath = await ScanExportService.createPdfFromImages(
                imageFiles.map((f) => f.path).toList(growable: false),
              );
            }
          } else {
            imageFiles = await capture.captureFromCamera(context, l10n);
          }

          if (!context.mounted) return;
          if (imageFiles == null) return;
          if (imageFiles.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.scanNoImagesSelected)),
            );
            return;
          }

          context.push(
            AppConstants.routeProcessing,
            extra: {
              'pdfPath': pdfPath,
              'imagePaths':
                  imageFiles.map((f) => f.path).toList(growable: false),
              'didTryImageExport': true,
              'imageExportError': null,
              'initialDocumentType': setup.documentType,
              'initialSupplierName': setup.supplierName,
            },
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(CupertinoIcons.camera),
        label: Text(
          l10n.scanInvoice,
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
