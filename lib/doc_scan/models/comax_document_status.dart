/// פריט שנשלח ולא הגיע ל-Comax.
class MissingItem {
  const MissingItem({required this.code, required this.name, required this.reason});

  final String code;
  final String name;

  /// `not_in_comax` — Comax דיווח "פריט לא קיים".
  /// `not_imported` — השורה נשלחה ולא יובאה.
  final String reason;

  factory MissingItem.fromJson(Map<String, dynamic> j) => MissingItem(
        code: (j['code'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        reason: (j['reason'] ?? '').toString(),
      );
}

/// שורה שיובאה עם ערכים שונים ממה ששלחנו.
class LineDiff {
  const LineDiff({required this.code, required this.name, this.delta});

  final String code;
  final String name;

  /// ההפרש הכספי בשורה (שלילי = יובא פחות ממה שנשלח).
  final double? delta;

  factory LineDiff.fromJson(Map<String, dynamic> j) => LineDiff(
        code: (j['code'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        delta: (j['delta'] as num?)?.toDouble(),
      );
}

/// הסיבה המדויקת לכישלון קליטה. מגיע **רק** כש-`receiveError == 'total_mismatch'`.
///
/// בלי זה המשתמש רואה "השליחה לקופה נכשלה" ואין לו מושג מה לעשות. איתו הוא רואה
/// "Comax ייבא 21 מתוך 22 שורות; 'טבק נקסט פיין' לא קיים ב-Comax; הפרש ₪369.45".
class InvoiceDiagnosis {
  const InvoiceDiagnosis({
    this.expectedCount,
    this.importedCount,
    this.expectedTotal,
    this.importedTotal,
    this.totalDelta,
    this.missingItems = const [],
    this.lineDiffs = const [],
  });

  final int? expectedCount;
  final int? importedCount;
  final double? expectedTotal;
  final double? importedTotal;
  final double? totalDelta;
  final List<MissingItem> missingItems;
  final List<LineDiff> lineDiffs;

  bool get isEmpty =>
      expectedCount == null &&
      importedCount == null &&
      missingItems.isEmpty &&
      lineDiffs.isEmpty;

  /// נוח לקוראים שמחזיקים את ה-diagnosis כ-Map גולמי על המסמך (nullable).
  static InvoiceDiagnosis? fromJsonOrNull(Map<String, dynamic>? j) =>
      j == null ? null : InvoiceDiagnosis.fromJson(j);

  factory InvoiceDiagnosis.fromJson(Map<String, dynamic> j) => InvoiceDiagnosis(
        expectedCount: (j['expectedCount'] as num?)?.toInt(),
        importedCount: (j['importedCount'] as num?)?.toInt(),
        expectedTotal: (j['expectedTotal'] as num?)?.toDouble(),
        importedTotal: (j['importedTotal'] as num?)?.toDouble(),
        totalDelta: (j['totalDelta'] as num?)?.toDouble(),
        missingItems: ((j['missingItems'] as List?) ?? const [])
            .whereType<Object?>()
            .map((e) => MissingItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        lineDiffs: ((j['lineDiffs'] as List?) ?? const [])
            .whereType<Object?>()
            .map((e) => LineDiff.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}

/// סטטוס קליטה של מסמך ב-Comax, כפי שמחזיר `GET /documents/status`.
class ComaxDocumentStatus {
  const ComaxDocumentStatus({
    required this.documentId,
    required this.comaxStatus,
    required this.terminal,
    this.comaxDocNumber,
    this.receivedAt,
    this.receiveError,
    this.receiveErrorMessage,
    this.diagnosis,
    this.updatedAt,
  });

  final String documentId;

  /// pending → queued → receiving → received / failed
  final String comaxStatus;

  /// ⚠️ `terminal: true` פירושו "ניסיון הקליטה הזה הסתיים", **לא** "לא ישתנה לעולם".
  /// מסמך `failed` יכול להישלח שוב ולהפוך ל-`received`, ולכן רענון יזום מותר גם עליו.
  final bool terminal;

  final String? comaxDocNumber;
  final String? receivedAt;

  /// total_mismatch | session_in_use | not_received | bad_credentials |
  /// transient | invoice_already_received | טקסט חופשי
  final String? receiveError;

  /// אותו כישלון **בעברית, מוכן להצגה**. ⚠️ זה השדה שמוצג למשתמש —
  /// [receiveError] הוא קוד מכונה (`total_mismatch`, `session_in_use`, ...)
  /// ואסור להציגו כטקסט. תיעוד: `foodstockComaxCrawler/docs/API.md` §5ג.
  final String? receiveErrorMessage;

  final InvoiceDiagnosis? diagnosis;
  final String? updatedAt;

  bool get isReceived => comaxStatus == 'received';
  bool get isFailed => comaxStatus == 'failed';

  factory ComaxDocumentStatus.fromJson(Map<String, dynamic> j) {
    final rawDiagnosis = j['diagnosis'] ?? j['receiveDetail'];
    return ComaxDocumentStatus(
      documentId: (j['documentId'] ?? '').toString(),
      comaxStatus: (j['comaxStatus'] ?? 'unknown').toString(),
      terminal: j['terminal'] == true,
      comaxDocNumber: j['comaxDocNumber']?.toString(),
      receivedAt: j['receivedAt']?.toString(),
      receiveError: j['receiveError']?.toString(),
      receiveErrorMessage: j['receiveErrorMessage']?.toString(),
      diagnosis: rawDiagnosis is Map
          ? InvoiceDiagnosis.fromJson(Map<String, dynamic>.from(rawDiagnosis))
          : null,
      updatedAt: j['updatedAt']?.toString(),
    );
  }
}

/// חשבונית שנמצאה ב-Comax בבדיקת הכפילות.
class ExistingComaxInvoice {
  const ExistingComaxInvoice({
    required this.comaxDocNumber,
    required this.match,
    this.reference,
    this.amount,
    this.warehouseName,
    this.invoiceDate,
  });

  final String comaxDocNumber;

  /// `exact` — אותה אסמכתא. `suffix` — הלקוח הקליד רק את הספרות האחרונות
  /// (שדה `#Ref` ב-Comax מוגבל ל-9 ספרות). סימן חזק, **לא ודאות**.
  final String match;

  final String? reference;
  final double? amount;
  final String? warehouseName;
  final String? invoiceDate;

  bool get isExact => match == 'exact';

  factory ExistingComaxInvoice.fromJson(Map<String, dynamic> j) =>
      ExistingComaxInvoice(
        comaxDocNumber: (j['comaxDocNumber'] ?? '').toString(),
        match: (j['match'] ?? '').toString(),
        reference: j['reference']?.toString(),
        amount: (j['amount'] as num?)?.toDouble(),
        warehouseName: j['warehouseName']?.toString(),
        invoiceDate: j['invoiceDate']?.toString(),
      );
}

/// תוצאת `GET /invoices/exists`.
class InvoiceExistsResult {
  const InvoiceExistsResult({
    required this.exists,
    required this.status,
    this.reversed = false,
    this.suffixMatchOnly = false,
    this.comaxInvoices = const [],
    this.snapshotDate,
  });

  final bool exists;

  /// in_comax | reversed | pending_receive | not_found
  final String status;

  /// המסמך נקלט ב-Comax אך **בוטל** (התאזן לאפס). אז `exists:false` (מותר
  /// לשלוח שוב) אבל כדאי ליידע את המשתמש שהיה קיים ובוטל, במקום לחסום.
  final bool reversed;

  /// כל ההתאמות הן סיומת בלבד — נסח "נמצאה חשבונית דומה", לא "כבר קיימת".
  final bool suffixMatchOnly;

  final List<ExistingComaxInvoice> comaxInvoices;

  /// התאריך שבו נשלף מ-Comax העתק רשימת החשבוניות.
  ///
  /// ⚠️ `status == 'not_found'` **אינו הוכחה** שהחשבונית לא ב-Comax: היא עשויה
  /// להיות מוקלדת ידנית אחרי התאריך הזה. ה-UI חייב לנסח את זה בכנות.
  final String? snapshotDate;

  bool get isKnownDuplicate => exists && status == 'in_comax';

  /// היה קיים ב-Comax אך בוטל — לא חוסם, רק מיידע ("היה קיים אך בוטל").
  bool get isReversed => reversed || status == 'reversed';

  factory InvoiceExistsResult.fromJson(Map<String, dynamic> j) => InvoiceExistsResult(
        exists: j['exists'] == true,
        status: (j['status'] ?? 'not_found').toString(),
        reversed: j['reversed'] == true,
        suffixMatchOnly: j['suffixMatchOnly'] == true,
        // ה-endpoint האחיד /documents/exists מחזיר `comaxDocuments`; הישן
        // /invoices/exists החזיר `comaxInvoices` — תומכים בשניהם.
        comaxInvoices: (((j['comaxDocuments'] ?? j['comaxInvoices']) as List?) ??
                const [])
            .whereType<Object?>()
            .map((e) => ExistingComaxInvoice.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        snapshotDate: (j['snapshot'] is Map)
            ? Map<String, dynamic>.from(j['snapshot'] as Map)['date']?.toString()
            : null,
      );
}
