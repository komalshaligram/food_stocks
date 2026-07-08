import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

/// תוצאת הפעלת שליפה (triggerFetch) — הקריאה הראשונה.
class TriggerResult {
  const TriggerResult({
    required this.phase,
    this.rowCounts,
    this.code,
    this.message,
  });

  /// 'success' (הסתיים מיד) | 'running' (התחיל, צריך polling) | 'error'.
  final String phase;
  final Map<String, dynamic>? rowCounts;
  final String? code;
  final String? message;
}

/// תוצאת בדיקת סטטוס (getRunStatus) — ל-polling.
class RunStatusResult {
  const RunStatusResult({
    required this.status,
    this.rowCounts,
    this.code,
    this.message,
  });

  /// queued | running | success | failed | session_in_use | bad_credentials | error | unknown.
  final String status;
  final Map<String, dynamic>? rowCounts;
  final String? code;
  final String? message;
}

/// שירות "הרצת שליפה" (סנכרון Comax) דרך Cloud Functions — trigger + polling בצד הקליינט.
/// השליפה אורכת ~3.5 דקות, ולכן לא ממתינים לתשובה ארוכה אחת.
class SyncService {
  SyncService({required FirebaseApp app, String region = 'europe-west1'})
      : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  /// מפעיל שליפה. מחזיר מיד 'success' / 'running' / 'error'.
  /// [customerCode] — אם נשלח, השרת ישתמש בו במקום בברירת המחדל שב-Secret.
  Future<TriggerResult> triggerFetch({String? customerCode}) async {
    final callable = _functions.httpsCallable(
      'triggerFetch',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 140)),
    );
    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
    });
    final data = _asMap(result.data);
    return TriggerResult(
      phase: (data['phase'] ?? 'error').toString(),
      rowCounts: _asMapOrNull(data['rowCounts']),
      code: data['code']?.toString(),
      message: data['message']?.toString(),
    );
  }

  /// בודק את סטטוס השליפה הנוכחית (ל-polling כל 10 שניות).
  Future<RunStatusResult> getRunStatus({String? customerCode}) async {
    final callable = _functions.httpsCallable(
      'getRunStatus',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );
    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
    });
    final data = _asMap(result.data);
    return RunStatusResult(
      status: (data['status'] ?? 'unknown').toString(),
      rowCounts: _asMapOrNull(data['rowCounts']),
      code: data['code']?.toString(),
      message: data['message']?.toString(),
    );
  }

  Map<String, dynamic> _asMap(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
  Map<String, dynamic>? _asMapOrNull(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : null;
}
