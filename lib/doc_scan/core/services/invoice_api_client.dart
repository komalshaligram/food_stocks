import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

/// שגיאת ולידציה בודדת שחזרה מה-API (422).
class ValidationError {
  const ValidationError({
    required this.field,
    required this.code,
    required this.message,
    this.lineIndex,
    this.extra = const {},
  });

  final String field;
  final String code;
  final String message;

  /// אינדקס השורה הבעייתית (מ-0) — רק לשגיאות שורה.
  final int? lineIndex;

  /// מידע עזר (candidates / provided / computed / difference וכו').
  final Map<String, dynamic> extra;

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    final known = {'field', 'code', 'message', 'lineIndex'};
    final extra = <String, dynamic>{};
    json.forEach((k, v) {
      if (!known.contains(k)) extra[k] = v;
    });
    return ValidationError(
      field: (json['field'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      lineIndex: (json['lineIndex'] as num?)?.toInt(),
      extra: extra,
    );
  }
}

/// תוצאת ולידציית חשבונית.
class ValidationResponse {
  const ValidationResponse({
    required this.httpStatus,
    required this.valid,
    this.message,
    this.resolved,
    this.errors = const [],
    this.generalErrorCode,
    this.documentId,
  });

  final int httpStatus;

  /// הנתונים תקינים ומוכנים לקליטה (200 + valid:true).
  final bool valid;

  /// מזהה המסמך מתשובת הוולידציה — נדרש לשליחה לקופה (/submit).
  final String? documentId;

  /// הודעת הצלחה מהשרת (אם יש).
  final String? message;

  /// תצוגה מקדימה של מה שזוהה (ספק, שורות, סיכומים) — בהצלחה.
  final Map<String, dynamic>? resolved;

  /// רשימת שגיאות ולידציה (422).
  final List<ValidationError> errors;

  /// קוד שגיאה כללי לשגיאות תשתית/הרשאה (401/403/404/409/429/...),
  /// או 'network' לכשל תקשורת. null כשהתשובה היא 200/422 רגילה.
  final String? generalErrorCode;

  bool get hasLineErrors => errors.any((e) => e.lineIndex != null);
}

/// תוצאת שליחה לקופה (/documents/submit).
class SubmitResponse {
  const SubmitResponse({
    required this.httpStatus,
    required this.success,
    required this.processing,
    this.comaxDocNumber,
    this.message,
    this.errorCode,
  });

  final int httpStatus;

  /// נקלט בהצלחה (200 + success:true).
  final bool success;

  /// חרג מ-6 דק' — ממשיך ברקע (202); יש לבצע polling.
  final bool processing;

  /// מספר המסמך שנוצר ב-Comax (בהצלחה, או ב-invoice_already_received).
  final String? comaxDocNumber;

  /// הודעה מוכנה בעברית מהשרת (להצגה למשתמש).
  final String? message;

  /// קוד שגיאה (invoice_already_received / session_in_use / busy / ...).
  final String? errorCode;
}

/// תוצאת בדיקת סטטוס קליטה (/documents/<id>/status).
class DocStatusResponse {
  const DocStatusResponse({
    required this.comaxStatus,
    this.comaxDocNumber,
    this.receiveError,
  });

  /// pending → queued → receiving → received / failed.
  final String comaxStatus;
  final String? comaxDocNumber;
  final String? receiveError;

  bool get isReceived => comaxStatus == 'received';
  bool get isFailed => comaxStatus == 'failed';
}

/// קליינט מבודד ל-API החיצוני של אימות/קליטת חשבוניות, דרך Cloud Functions
/// (proxy מאובטח — המפתח וקוד הלקוח נשמרים בצד השרת בלבד).
///
/// כרגע יש [validateInvoice] (אימות בלבד). בעתיד יתווסף כאן `postInvoice`
/// (קליטה בפועל ל-Comax) לאותו base URL, באותה תבנית.
class InvoiceApiClient {
  InvoiceApiClient({required FirebaseApp app, String region = 'europe-west1'})
      : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  /// מאמת payload של חשבונית מול ה-API. מחזיר תוצאה מובנית (לא זורק על 200/422).
  /// זורק [FirebaseFunctionsException] רק על כשל תשתית/תקשורת.
  /// [customerCode] — אם נשלח, השרת ישתמש בו במקום בברירת המחדל שב-Secret.
  Future<ValidationResponse> validateInvoice(
    Map<String, dynamic> payload, {
    String? customerCode,
  }) async {
    final callable = _functions.httpsCallable(
      'validateInvoice',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );
    final result = await callable.call(<String, dynamic>{
      'payload': payload,
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
    });
    final root = _asMap(result.data);
    final httpStatus = (root['httpStatus'] as num?)?.toInt() ?? 0;
    final data = _asMap(root['data']);

    if (httpStatus == 200 && data['valid'] == true) {
      return ValidationResponse(
        httpStatus: 200,
        valid: true,
        message: data['message']?.toString(),
        resolved: _asMapOrNull(data['resolved']),
        documentId: data['documentId']?.toString(),
      );
    }

    if (httpStatus == 422) {
      final rawErrors = (data['errors'] as List?) ?? const [];
      final errors = rawErrors
          .whereType<Object?>()
          .map((e) => ValidationError.fromJson(_asMap(e)))
          .toList();
      return ValidationResponse(
        httpStatus: 422,
        valid: false,
        errors: errors,
      );
    }

    // שגיאת תשתית/הרשאה — מיפוי קוד כללי.
    final code = data['error']?.toString() ?? _codeForStatus(httpStatus);
    return ValidationResponse(
      httpStatus: httpStatus,
      valid: false,
      generalErrorCode: code,
    );
  }

  /// שולח חשבונית לקליטה בפועל ל-Comax (POST /documents/submit).
  /// קריאה ארוכה (עד ~6 דק'); בחריגה מוחזר processing (202) ויש לבצע polling.
  Future<SubmitResponse> submitDocument(
    String documentId, {
    String? customerCode,
  }) async {
    final callable = _functions.httpsCallable(
      'submitDocument',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 410)),
    );
    final result = await callable.call(<String, dynamic>{
      'documentId': documentId,
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
    });
    final root = _asMap(result.data);
    final httpStatus = (root['httpStatus'] as num?)?.toInt() ?? 0;
    final data = _asMap(root['data']);
    return SubmitResponse(
      httpStatus: httpStatus,
      success: httpStatus == 200 && data['success'] == true,
      processing: httpStatus == 202 || data['status'] == 'processing',
      comaxDocNumber: data['comaxDocNumber']?.toString(),
      message: data['message']?.toString(),
      errorCode: data['error']?.toString(),
    );
  }

  /// בודק את סטטוס הקליטה (GET /documents/<id>/status), ל-polling אחרי 202.
  Future<DocStatusResponse> getDocumentStatus(
    String documentId, {
    String? customerCode,
  }) async {
    final callable = _functions.httpsCallable(
      'getDocumentStatus',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );
    final result = await callable.call(<String, dynamic>{
      'documentId': documentId,
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
    });
    final root = _asMap(result.data);
    final data = _asMap(root['data']);
    return DocStatusResponse(
      comaxStatus: (data['comaxStatus'] ?? 'unknown').toString(),
      comaxDocNumber: data['comaxDocNumber']?.toString(),
      receiveError: data['receiveError']?.toString(),
    );
  }

  String _codeForStatus(int status) {
    switch (status) {
      case 401:
        return 'unauthorized';
      case 403:
        return 'insufficient_scope';
      case 404:
        return 'customer_not_found';
      case 409:
        return 'ambiguous_customer_code';
      case 429:
        return 'rate_limited';
      default:
        return 'unknown';
    }
  }

  Map<String, dynamic> _asMap(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
  Map<String, dynamic>? _asMapOrNull(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : null;
}
