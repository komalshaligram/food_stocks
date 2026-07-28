import 'invoice_item.dart';

/// סטטוס מסמך בסקירה.
enum DocumentStatus {
  scanning,
  uploading,
  processing,
  readyForUpdate,
  completed,
  sentToCashRegister,
  error,
  deleted,
}

/// מסמך חשבונית/תעודת משלוח.
class InvoiceDocument {
  const InvoiceDocument({
    required this.id,
    required this.createdAt,
    required this.status,
    this.pdfPath,
    this.pdfUrl,
    this.jobId,
    this.imagePaths = const [],
    this.imageUrls = const [],
    this.documentType,
    this.companyName,
    this.companyId,
    this.documentNumber,
    this.allocationNumber,
    this.documentDate,
    this.paymentDueDate,
    this.discount,
    this.subtotal,
    this.vatAmount,
    this.totalAmount,
    this.discountPercent,
    this.warehouseCode,
    this.warehouseName,
    this.parsedJson,
    this.errorMessage,
    this.scanModel,
    this.items = const [],
    this.comaxDocNumber,
    this.comaxDocumentId,
    this.comaxStatus,
    this.comaxReceiveError,
    this.comaxReceiveErrorMessage,
    this.comaxDiagnosis,
  });

  final String id;
  final DateTime createdAt;
  final DocumentStatus status;
  final String? pdfPath;
  /// S3 storage key or URL — used when local [pdfPath] is unavailable.
  final String? pdfUrl;
  final String? jobId;
  final List<String> imagePaths;
  /// S3 storage keys — used when local [imagePaths] are unavailable.
  final List<String> imageUrls;
  final String? documentType;
  final String? companyName;
  final String? companyId;
  final String? documentNumber;
  /// מספר הקצאה (אם מופיע במסמך).
  final String? allocationNumber;
  final String? documentDate;
  /// תאריך פירעון / תאריך לתשלום (אם מופיע במסמך).
  final String? paymentDueDate;
  /// הנחה ברמת המסמך (לא ברמת השורה), אם מופיעה במסמך.
  final double? discount;
  /// סכום ביניים **אחרי** [discount] — זה מה שהמע"מ מחושב עליו.
  final double? subtotal;
  final double? vatAmount;
  final double? totalAmount;

  /// אחוז הנחה על המסמך (למשל 5 = 5%). ההנחה חלה על הסה"כ לפני מע"מ, ואז המע"מ
  /// והסה"כ לתשלום מחושבים מחדש על הסכום שאחרי ההנחה. null/0 = אין הנחה.
  final double? discountPercent;

  /// קוד מחסן היעד לקליטה ל-Comax (§5c). נבחר ע"י המשתמש; null/ריק = מחסן
  /// ברירת המחדל של Comax. נשלח כ-`header.warehouseCode` בקליטה.
  final String? warehouseCode;

  /// שם מחסן היעד (לתצוגה ולתיעוד; נשלח כ-`header.warehouseName`).
  final String? warehouseName;

  /// JSON שחזר מ-parseInvoice (לצורכי דיבוג בלבד).
  final String? parsedJson;
  /// הודעת שגיאה אחרונה לעיבוד המסמך (אם קיימת).
  final String? errorMessage;
  /// מפתח מודל ה-AI ששימש לסריקת המסמך.
  final String? scanModel;
  final List<InvoiceItem> items;

  /// מספר המסמך שנוצר ב-Comax לאחר קליטה מוצלחת ("שלח לקופה").
  final String? comaxDocNumber;

  /// ה-documentId שהוחזר מ-/validate ושומש ל-/submit — מפתח הקורלציה ל-webhook
  /// שמעדכן את הסטטוס הסופי בצד השרת. ראו §11.
  final String? comaxDocumentId;

  /// סטטוס הקליטה ל-Comax: processing | received | failed (ריק = לא נשלח עדיין).
  final String? comaxStatus;

  /// סיבת כשל הקליטה ל-Comax (כש-comaxStatus == 'failed').
  /// ⚠️ **קוד מכונה** מהקרולר (`total_mismatch`, `session_in_use`, ...).
  /// לא להצגה למשתמש — לתצוגה יש [comaxReceiveErrorMessage].
  final String? comaxReceiveError;

  /// סיבת הכישלון **בעברית, מוכנה להצגה**, כפי שנוסחה בקרולר במקום שבו
  /// הכישלון מובן (למשל `session_in_use` → "משתמש כבר מחובר ל-Comax של לקוח
  /// זה..."). זה השדה שמופיע במסך ובהתראה.
  final String? comaxReceiveErrorMessage;

  /// פירוט הכישלון מהקראולר, כפי שהבקאנד שמר אותו. קיים רק כש-
  /// `comaxReceiveError == 'total_mismatch'`. גולמי (Map) — נוסח ב-UI.
  final Map<String, dynamic>? comaxDiagnosis;

  /// האם קיימת קליטת Comax בתהליך/הושלמה — חוסם שליחה כפולה.
  bool get isComaxIntakeInFlightOrDone =>
      status == DocumentStatus.sentToCashRegister ||
      comaxStatus == 'processing' ||
      comaxStatus == 'received';

  InvoiceDocument copyWith({
    String? id,
    DateTime? createdAt,
    DocumentStatus? status,
    String? pdfPath,
    String? pdfUrl,
    String? jobId,
    List<String>? imagePaths,
    List<String>? imageUrls,
    String? documentType,
    String? companyName,
    String? companyId,
    String? documentNumber,
    String? allocationNumber,
    String? documentDate,
    String? paymentDueDate,
    double? discount,
    double? subtotal,
    double? vatAmount,
    double? totalAmount,
    double? discountPercent,
    String? warehouseCode,
    String? warehouseName,
    String? parsedJson,
    String? errorMessage,
    String? scanModel,
    List<InvoiceItem>? items,
    String? comaxDocNumber,
    String? comaxDocumentId,
    String? comaxStatus,
    String? comaxReceiveError,
    String? comaxReceiveErrorMessage,
    Map<String, dynamic>? comaxDiagnosis,
  }) {
    return InvoiceDocument(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      pdfPath: pdfPath ?? this.pdfPath,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      jobId: jobId ?? this.jobId,
      imagePaths: imagePaths ?? this.imagePaths,
      imageUrls: imageUrls ?? this.imageUrls,
      documentType: documentType ?? this.documentType,
      companyName: companyName ?? this.companyName,
      companyId: companyId ?? this.companyId,
      documentNumber: documentNumber ?? this.documentNumber,
      allocationNumber: allocationNumber ?? this.allocationNumber,
      documentDate: documentDate ?? this.documentDate,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      discount: discount ?? this.discount,
      subtotal: subtotal ?? this.subtotal,
      vatAmount: vatAmount ?? this.vatAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      discountPercent: discountPercent ?? this.discountPercent,
      warehouseCode: warehouseCode ?? this.warehouseCode,
      warehouseName: warehouseName ?? this.warehouseName,
      parsedJson: parsedJson ?? this.parsedJson,
      errorMessage: errorMessage ?? this.errorMessage,
      scanModel: scanModel ?? this.scanModel,
      items: items ?? this.items,
      comaxDocNumber: comaxDocNumber ?? this.comaxDocNumber,
      comaxDocumentId: comaxDocumentId ?? this.comaxDocumentId,
      comaxStatus: comaxStatus ?? this.comaxStatus,
      comaxReceiveError: comaxReceiveError ?? this.comaxReceiveError,
      comaxReceiveErrorMessage:
          comaxReceiveErrorMessage ?? this.comaxReceiveErrorMessage,
      comaxDiagnosis: comaxDiagnosis ?? this.comaxDiagnosis,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'pdfPath': pdfPath,
        'pdfUrl': pdfUrl,
        'jobId': jobId,
        'imagePaths': imagePaths,
        'imageUrls': imageUrls,
        'documentType': documentType,
        'companyName': companyName,
        'companyId': companyId,
        'documentNumber': documentNumber,
        'allocationNumber': allocationNumber,
        'documentDate': documentDate,
        'paymentDueDate': paymentDueDate,
        'discount': discount,
        'subtotal': subtotal,
        'vatAmount': vatAmount,
        'totalAmount': totalAmount,
        'discountPercent': discountPercent,
        'warehouseCode': warehouseCode,
        'warehouseName': warehouseName,
        'parsedJson': parsedJson,
        'errorMessage': errorMessage,
        'scanModel': scanModel,
        'items': items.map((e) => e.toJson()).toList(),
        'comaxDocNumber': comaxDocNumber,
        'comaxDocumentId': comaxDocumentId,
        'comaxStatus': comaxStatus,
        'comaxReceiveError': comaxReceiveError,
        'comaxReceiveErrorMessage': comaxReceiveErrorMessage,
        'comaxDiagnosis': comaxDiagnosis,
      };

  factory InvoiceDocument.fromJson(Map<String, dynamic> json) {
    return InvoiceDocument(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: _statusFromJson(json['status'] as String?),
      pdfPath: json['pdfPath'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
      jobId: json['jobId'] as String?,
      imagePaths: (json['imagePaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      documentType: json['documentType'] as String?,
      companyName: json['companyName'] as String?,
      companyId: json['companyId'] as String?,
      documentNumber: json['documentNumber'] as String?,
      allocationNumber: json['allocationNumber'] as String?,
      documentDate: json['documentDate'] as String?,
      paymentDueDate: json['paymentDueDate'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      vatAmount: (json['vatAmount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      warehouseCode: json['warehouseCode'] as String?,
      warehouseName: json['warehouseName'] as String?,
      parsedJson: json['parsedJson'] as String?,
      errorMessage: json['errorMessage'] as String?,
      scanModel: json['scanModel'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comaxDocNumber: json['comaxDocNumber'] as String?,
      comaxDocumentId: json['comaxDocumentId'] as String?,
      comaxStatus: json['comaxStatus'] as String?,
      comaxReceiveError: json['comaxReceiveError'] as String?,
      comaxReceiveErrorMessage: json['comaxReceiveErrorMessage'] as String?,
      comaxDiagnosis: json['comaxDiagnosis'] is Map
          ? Map<String, dynamic>.from(json['comaxDiagnosis'] as Map)
          : null,
    );
  }

  static DocumentStatus _statusFromJson(String? rawStatus) {
    if (rawStatus == null) {
      return DocumentStatus.readyForUpdate;
    }

    for (final status in DocumentStatus.values) {
      if (status.name == rawStatus) {
        return status;
      }
    }

    return DocumentStatus.readyForUpdate;
  }

  /// מסמך דמו – נתונים בסיסיים לבדיקות. לנתוני דמה מלאים (30 פריטים) השתמש ב־createFullMockDocument מ־mock_invoice_data.
  factory InvoiceDocument.createMockDemo({
    required String id,
    required DateTime createdAt,
    DocumentStatus status = DocumentStatus.readyForUpdate,
  }) {
    final items = [
      const InvoiceItem(
        lineNumber: 1,
        description: 'פריט דמו',
        quantity: 1,
        pricePerUnit: 100,
        totalPrice: 100,
      ),
    ];
    return InvoiceDocument(
      id: id,
      createdAt: createdAt,
      status: status,
      documentType: 'חשבונית',
      companyName: 'חברה בע"מ',
      companyId: '00-000000-0',
      documentNumber: 'DEMO-001',
      documentDate: '${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year}',
      subtotal: 100,
      vatAmount: 17,
      totalAmount: 117,
      items: items,
    );
  }
}
