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
    this.documentDate,
    this.subtotal,
    this.vatAmount,
    this.totalAmount,
    this.parsedJson,
    this.errorMessage,
    this.scanModel,
    this.items = const [],
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
  final String? documentDate;
  final double? subtotal;
  final double? vatAmount;
  final double? totalAmount;
  /// JSON שחזר מ-parseInvoice (לצורכי דיבוג בלבד).
  final String? parsedJson;
  /// הודעת שגיאה אחרונה לעיבוד המסמך (אם קיימת).
  final String? errorMessage;
  /// מפתח מודל ה-AI ששימש לסריקת המסמך.
  final String? scanModel;
  final List<InvoiceItem> items;

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
    String? documentDate,
    double? subtotal,
    double? vatAmount,
    double? totalAmount,
    String? parsedJson,
    String? errorMessage,
    String? scanModel,
    List<InvoiceItem>? items,
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
      documentDate: documentDate ?? this.documentDate,
      subtotal: subtotal ?? this.subtotal,
      vatAmount: vatAmount ?? this.vatAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      parsedJson: parsedJson ?? this.parsedJson,
      errorMessage: errorMessage ?? this.errorMessage,
      scanModel: scanModel ?? this.scanModel,
      items: items ?? this.items,
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
        'documentDate': documentDate,
        'subtotal': subtotal,
        'vatAmount': vatAmount,
        'totalAmount': totalAmount,
        'parsedJson': parsedJson,
        'errorMessage': errorMessage,
        'scanModel': scanModel,
        'items': items.map((e) => e.toJson()).toList(),
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
      documentDate: json['documentDate'] as String?,
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      vatAmount: (json['vatAmount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      parsedJson: json['parsedJson'] as String?,
      errorMessage: json['errorMessage'] as String?,
      scanModel: json['scanModel'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
