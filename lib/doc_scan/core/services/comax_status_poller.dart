import 'dart:async';

import '../../models/comax_document_status.dart';
import '../../models/invoice_document.dart';
import 'client_scanned_certificate_sync_service.dart';

/// עוקב אחרי קליטת מסמך ל-Comax **דרך FoodStock-Backend**, לא דרך הקראולר.
///
/// למה דווקא כך: מאז שה-webhook הוסר, הקרון בשרת (`comaxDocumentStatusCron`) הוא
/// **הכותב היחיד** של `comaxStatus`. אם המכשיר היה שואל את הקראולר ישירות, המסך
/// היה יכול להציג `received` בזמן שהתעודה במסד עדיין `processing` — שני מקורות
/// אמת לאותו נתון. עדיף פיגור של עד דקה על תהליך שנמשך 1–4 דקות.
///
/// ⚠️ ההשהיה **עולה** (3s → 30s). הקרון רץ כל דקה; פולינג צפוף רק שורף סוללה.
class ComaxStatusPoller {
  ComaxStatusPoller(this._syncService);

  final ClientScannedCertificateSyncService _syncService;

  /// 3, 5, 8, 13, 21, ואז 30 שניות.
  static const List<int> _backoffSeconds = [3, 5, 8, 13, 21];
  static const int _maxIntervalSeconds = 30;

  /// אחרי זה מפסיקים ומסתמכים על הקרון — הסטטוס יופיע בפתיחה הבאה של המסך.
  static const Duration _maxTotalWait = Duration(minutes: 8);

  bool _cancelled = false;

  Duration _delayFor(int attempt) => Duration(
        seconds: attempt < _backoffSeconds.length
            ? _backoffSeconds[attempt]
            : _maxIntervalSeconds,
      );

  /// `received` / `failed` — אין טעם להמשיך לשאול את הקרון.
  static bool isTerminal(InvoiceDocument doc) =>
      doc.comaxStatus == 'received' || doc.comaxStatus == 'failed';

  /// שואל את הבקאנד עד שהתעודה מגיעה למצב סופי, או עד [_maxTotalWait] / [cancel].
  ///
  /// [onUpdate] נקרא על **כל** שינוי, גם לא-סופי (`queued → receiving`), כדי
  /// שהמסך לא ייתקע על "ממתין".
  Future<InvoiceDocument?> pollUntilTerminal(
    String mobileDocumentId, {
    void Function(InvoiceDocument doc)? onUpdate,
  }) async {
    _cancelled = false;
    final deadline = DateTime.now().add(_maxTotalWait);
    var attempt = 0;
    String? lastStatus;

    while (!_cancelled && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(_delayFor(attempt));
      if (_cancelled) return null;

      final doc = await refreshOnce(mobileDocumentId);
      if (doc != null) {
        if (doc.comaxStatus != lastStatus) {
          lastStatus = doc.comaxStatus;
          onUpdate?.call(doc);
        }
        if (isTerminal(doc)) return doc;
      }
      attempt++;
    }
    return null;
  }

  /// רענון חד-פעמי. מותר גם על מסמך סופי: `failed` אינו סופי לצמיתות — שליחה
  /// חוזרת מחזירה אותו ל-`processing`, והקרון יעדכן אותו שוב.
  Future<InvoiceDocument?> refreshOnce(String mobileDocumentId) async {
    try {
      final docs = await _syncService.fetchAll();
      for (final d in docs) {
        if (d.id == mobileDocumentId) return d;
      }
    } catch (_) {
      // כשל רשת אינו סיבה להפסיק — הניסיון הבא רחוק יותר ממילא.
    }
    return null;
  }

  void cancel() => _cancelled = true;
}
