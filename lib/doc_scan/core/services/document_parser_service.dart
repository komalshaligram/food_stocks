import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../models/invoice_document.dart';
import '../../models/invoice_item.dart';

/// בחירת המשתמש לפני הסריקה מקבלת עדיפות; רק אם לא נבחר ספק — נשאר מה שחולץ ב-OCR.
String? mergeCompanyNamePreferPreScan(String? preScanName, String? ocrName) {
  final p = preScanName?.trim();
  if (p != null && p.isNotEmpty) return p;
  final o = ocrName?.trim();
  if (o != null && o.isNotEmpty) return o;
  return null;
}

/// חילוץ שם ספק/חברה מתשובת השרת — מפתחות חלופיים ומבנים מקוננים (Firestore / job result).
String? extractCompanyNameFromPayload(
  Map<String, dynamic> map, [
  int depth = 0,
]) {
  if (depth > 5) return null;
  const directKeys = [
    'company_name',
    'supplier_name',
    'vendor_name',
    'business_name',
    'seller_name',
    'companyName',
    'supplier',
  ];
  for (final k in directKeys) {
    final v = map[k];
    if (v == null) continue;
    final s = v.toString().trim();
    if (s.isNotEmpty) return s;
  }
  const nestedKeys = [
    'data',
    'extracted',
    'result',
    'parsed',
    'invoice',
    'document',
    'fields',
  ];
  for (final nk in nestedKeys) {
    final inner = map[nk];
    if (inner is Map<String, dynamic>) {
      final hit = extractCompanyNameFromPayload(inner, depth + 1);
      if (hit != null) return hit;
    } else if (inner is Map) {
      final hit = extractCompanyNameFromPayload(
        Map<String, dynamic>.from(inner),
        depth + 1,
      );
      if (hit != null) return hit;
    }
  }
  return null;
}

/// פריט בודד במסמך לאחר חילוץ.
class DocumentItem {
  final int lineNumber;
  final String description;
  final String? sku;
  final num? packs;
  final num? unitsPerPack;
  final num quantity;
  final double unitPrice;
  final double? discountPercent;
  final double? packagingDepositTax;
  final double lineTotal;

  DocumentItem({
    required this.lineNumber,
    required this.description,
    this.sku,
    this.packs,
    this.unitsPerPack,
    required this.quantity,
    required this.unitPrice,
    this.discountPercent,
    this.packagingDepositTax,
    required this.lineTotal,
  });

  factory DocumentItem.fromMap(Map<String, dynamic> map) {
    num? toNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      if (v is String) return num.tryParse(v);
      return null;
    }

    return DocumentItem(
      lineNumber: toNum(map['line_number'])?.toInt() ?? 0,
      description: map['description'] ?? '',
      sku: map['sku'],
      packs: toNum(map['packs']),
      unitsPerPack: toNum(map['units_per_pack']),
      quantity: toNum(map['quantity']) ?? 0,
      unitPrice: toNum(map['unit_price'])?.toDouble() ?? 0,
      discountPercent: toNum(map['discount_percent'])?.toDouble(),
      packagingDepositTax: toNum(map['packaging_deposit_tax'])?.toDouble(),
      lineTotal: toNum(map['line_total'])?.toDouble() ?? 0,
    );
  }

  InvoiceItem toInvoiceItem() {
    return InvoiceItem(
      lineNumber: lineNumber,
      itemNumber: sku,
      description: description,
      quantity: quantity.toDouble(),
      packages: packs?.toInt(),
      units: unitsPerPack?.toInt(),
      pricePerUnit: unitPrice,
      discountPercent: discountPercent,
      packagingDepositTax: packagingDepositTax,
      totalPrice: lineTotal,
    );
  }
}

/// תוצאת חילוץ מסמך עסקי.
class ParsedDocument {
  final String? documentType;
  final String? documentNumber;
  final String? allocationNumber;
  final String? companyName;
  final String? companyId;
  final String? date;
  final String? time;
  final String? customerNumber;
  final String? agentName;
  final String? paymentDueDate;
  final double? subtotal;
  final double? discount;
  final double? subtotalAfterDiscount;
  final double? vat;
  final double? total;
  final int? itemsCount;
  final List<DocumentItem> items;
  final Map<String, dynamic> usage;
  final Map<String, dynamic> rawJson;

  ParsedDocument({
    this.documentType,
    this.documentNumber,
    this.allocationNumber,
    this.companyName,
    this.companyId,
    this.date,
    this.time,
    this.customerNumber,
    this.agentName,
    this.paymentDueDate,
    this.subtotal,
    this.discount,
    this.subtotalAfterDiscount,
    this.vat,
    this.total,
    this.itemsCount,
    required this.items,
    required this.usage,
    required this.rawJson,
  });

  factory ParsedDocument.fromResponse(Map<String, dynamic> response) {
    // במקרים מסוימים callable מחזיר { data: {...}, usage: {...} }.
    // ובמקרים אחרים מחזירים ישירות את ה-fields של המסמך.
    final inner = response['data'];
    final payload = inner is Map ? Map<String, dynamic>.from(inner) : response;

    final usageRaw = response['usage'];
    final usage =
        usageRaw is Map ? Map<String, dynamic>.from(usageRaw) : <String, dynamic>{};

    num? toNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      if (v is String) return num.tryParse(v);
      return null;
    }

    double? toDouble(dynamic v) => toNum(v)?.toDouble();

    final itemsList = (payload['items'] as List<dynamic>?)
            ?.map((e) => DocumentItem.fromMap(Map<String, dynamic>.from(e)))
            .toList() ??
        const [];

    final companyFromPayload = extractCompanyNameFromPayload(payload) ??
        extractCompanyNameFromPayload(response);

    return ParsedDocument(
      documentType: payload['document_type'],
      documentNumber: payload['document_number'],
      allocationNumber: payload['allocation_number']?.toString(),
      companyName: companyFromPayload,
      companyId: payload['company_id'],
      date: payload['date'],
      time: payload['time'],
      customerNumber: payload['customer_number'],
      agentName: payload['agent_name'],
      paymentDueDate: payload['payment_due_date'],
      subtotal: toDouble(payload['subtotal']),
      discount: toDouble(payload['discount']),
      subtotalAfterDiscount: toDouble(payload['subtotal_after_discount']),
      vat: toDouble(payload['vat']),
      total: toDouble(payload['total']),
      itemsCount: toNum(payload['items_count'])?.toInt(),
      items: itemsList,
      usage: usage,
      rawJson: payload,
    );
  }

  InvoiceDocument toInvoiceDocument({
    String? pdfPath,
    List<String> imagePaths = const [],
  }) {
    // ה-UI משתמש ב-subtotal ללא מע״מ, ו-vat/total.
    final subtotalValue =
        subtotalAfterDiscount ?? subtotal ?? 0.0; // fallback מקומי.

    // UI מציג createdAt -> אין לנו createdAt מהתשובה, לכן:
    // ניצור createdAt ש״ווה עכשיו״ וה-documentDate נשמור בנפרד.
    final now = DateTime.now();
    final parsedJsonText = const JsonEncoder.withIndent('  ').convert(rawJson);

    return InvoiceDocument(
      id: const Uuid().v4(),
      createdAt: now,
      status: DocumentStatus.readyForUpdate,
      pdfPath: pdfPath,
      imagePaths: imagePaths,
      documentType: documentType,
      companyName: companyName,
      companyId: companyId,
      documentNumber: documentNumber,
      allocationNumber: allocationNumber,
      documentDate: date,
      paymentDueDate: paymentDueDate,
      subtotal: subtotalValue,
      vatAmount: vat,
      totalAmount: total,
      parsedJson: parsedJsonText,
      items: items.map((e) => e.toInvoiceItem()).toList(),
    );
  }
}

/// Error codes for document parsing failures.
enum DocumentParseErrorCode {
  imageTooLarge,
  imagesNotReceived,
  pdfTooLarge,
  scanJobEmptyResponse,
  scanJobMissingJobId,
  documentProcessingEmptyResponse,
  storageUploadFailed,
  unauthenticated,
  invalidArgument,
  resourceExhausted,
  internal,
  unknown,
  unexpected,
}

/// Exception thrown from parsing/Cloud Function submission.
class DocumentParseException implements Exception {
  final DocumentParseErrorCode code;
  final Map<String, Object?> params;
  final Object? originalError;

  DocumentParseException(
    this.code, {
    this.params = const {},
    this.originalError,
  });

  @override
  String toString() => 'DocumentParseException: $code $params';
}

/// שירות חילוץ מסמכים עסקיים מקובצי PDF סרוקים.
class DocumentParserService {
  final FirebaseApp _app;
  final FirebaseFunctions _functions;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  DocumentParserService({FirebaseApp? app, String region = 'europe-west1'})
      : _app = app ?? Firebase.app(),
        _functions = FirebaseFunctions.instanceFor(
          app: app ?? Firebase.app(),
          region: region,
        ),
        _firestore = FirebaseFirestore.instanceFor(app: app ?? Firebase.app()),
        _storage = FirebaseStorage.instanceFor(
          app: app ?? Firebase.app(),
          bucket: 'tavilidocscan.firebasestorage.app',
        );

  FirebaseAuth get _auth => FirebaseAuth.instanceFor(app: _app);

  /// פרסור מסמך עסקי מתמונת עמוד בודד.
  ///
  /// שולח `fileBase64` ל-`parseInvoice`.
  Future<ParsedDocument> parseImage(
    File imageFile, {
    String? model,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final sizeMB = bytes.length / (1024 * 1024);
    if (sizeMB > 20) {
      throw DocumentParseException(
        DocumentParseErrorCode.imageTooLarge,
        params: {
          'sizeMB': sizeMB.toStringAsFixed(1),
          'maxMB': 20,
        },
      );
    }

    return _callFunction({'fileBase64': base64Image}, model: model);
  }

  /// פרסור מסמך עסקי ממערך תמונות (מרובה עמודים).
  ///
  /// שולח `images` ל-`parseInvoice`.
  Future<ParsedDocument> parseImages(
    List<File> imageFiles, {
    String? model,
  }) async {
    if (imageFiles.isEmpty) {
      throw DocumentParseException(DocumentParseErrorCode.imagesNotReceived);
    }

    final List<String> base64Images = [];
    for (final file in imageFiles) {
      final bytes = await file.readAsBytes();
      final sizeMB = bytes.length / (1024 * 1024);
      if (sizeMB > 20) {
        throw DocumentParseException(
          DocumentParseErrorCode.imageTooLarge,
          params: {
            'sizeMB': sizeMB.toStringAsFixed(1),
            'maxMB': 20,
          },
        );
      }
      base64Images.add(base64Encode(bytes));
    }

    return _callFunction({'images': base64Images}, model: model);
  }

  /// פרסור מסמך עסקי מקובץ PDF (תאימות לאחור).
  ///
  /// שולח `pdfBase64` ל-`parseInvoice`.
  Future<ParsedDocument> parsePdf(
    File pdfFile, {
    String? model,
  }) async {
    final bytes = await pdfFile.readAsBytes();
    final base64Pdf = base64Encode(bytes);

    final sizeMB = bytes.length / (1024 * 1024);
    if (sizeMB > 32) {
      throw DocumentParseException(
        DocumentParseErrorCode.pdfTooLarge,
        params: {
          'sizeMB': sizeMB.toStringAsFixed(1),
          'maxMB': 32,
        },
      );
    }

    return _callFunction({'pdfBase64': base64Pdf}, model: model);
  }

  @Deprecated('Use parsePdf / parseImages instead')
  Future<ParsedDocument> parse(File pdfFile) => parsePdf(pdfFile);

  /// Submit async Firestore-backed scan job and return `jobId`.
  Future<String> submitScanJob(
    List<File> imageFiles, {
    String? model,
  }) async {
    if (imageFiles.isEmpty) {
      throw DocumentParseException(DocumentParseErrorCode.imagesNotReceived);
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw DocumentParseException(DocumentParseErrorCode.unauthenticated);
    }

    final uid = user.uid;
    final batchId = const Uuid().v4();

    // Upload images to Storage first; then call the callable with storage paths.
    final List<String> storagePaths = [];
    final List<Reference> uploadedRefs = [];
    try {
      for (var i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final bytes = await file.readAsBytes();
        final sizeMB = bytes.length / (1024 * 1024);
        if (sizeMB > 20) {
          throw DocumentParseException(
            DocumentParseErrorCode.imageTooLarge,
            params: {
              'sizeMB': sizeMB.toStringAsFixed(1),
              'maxMB': 20,
            },
          );
        }

        // Detect file type from magic numbers (bytes at the beginning).
        // JPEG: FF D8
        // PNG : 89 50 4E 47 0D 0A 1A 0A
        // PDF : 25 50 44 46 2D
        final int b0 = bytes.isNotEmpty ? bytes[0] : -1;
        final int b1 = bytes.length > 1 ? bytes[1] : -1;

        String ext = 'jpg';
        String contentType = 'image/jpeg';

        final isJpeg = bytes.length >= 2 && b0 == 0xFF && b1 == 0xD8;

        final isPng = bytes.length >= 8 &&
            bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4E &&
            bytes[3] == 0x47 &&
            bytes[4] == 0x0D &&
            bytes[5] == 0x0A &&
            bytes[6] == 0x1A &&
            bytes[7] == 0x0A;

        final isPdf = bytes.length >= 5 &&
            bytes[0] == 0x25 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x44 &&
            bytes[3] == 0x46 &&
            bytes[4] == 0x2D;

        if (isPdf) {
          ext = 'pdf';
          contentType = 'application/pdf';
        } else if (isPng) {
          ext = 'png';
          contentType = 'image/png';
        } else if (isJpeg) {
          ext = 'jpg';
          contentType = 'image/jpeg';
        } else {
          // Fallback: assume JPEG (most scanner SDK outputs).
          ext = 'jpg';
          contentType = 'image/jpeg';
        }

        final storagePath = 'scans/$uid/$batchId/page_$i.$ext';
        final ref = _storage.ref().child(storagePath);
        await ref.putData(
          bytes,
          SettableMetadata(contentType: contentType),
        );

        storagePaths.add(storagePath);
        uploadedRefs.add(ref);
      }
    } catch (e) {
      // If uploading fails midway, delete what already got uploaded.
      if (uploadedRefs.isNotEmpty) {
        await Future.wait(
          uploadedRefs.map(
            (ref) async {
              try {
                await ref.delete();
              } catch (_) {
                // Best-effort cleanup.
              }
            },
          ),
        );
      }

      if (e is DocumentParseException) {
        rethrow;
      }

      throw DocumentParseException(
        DocumentParseErrorCode.storageUploadFailed,
        params: {'error': e.toString()},
        originalError: e,
      );
    }

    try {
      final callable = _functions.httpsCallable(
        'submitScanJob',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 120),
        ),
      );
      final result = await callable.call<Map<String, dynamic>>({
        'imagePaths': storagePaths,
        if (model != null && model.isNotEmpty) 'model': model,
      });
      final data = result.data;

      final map = Map<String, dynamic>.from(data);
      final jobId = map['jobId'] as String?;
      if (jobId == null || jobId.isEmpty) {
        throw DocumentParseException(
          DocumentParseErrorCode.scanJobMissingJobId,
        );
      }
      return jobId;
    } on FirebaseFunctionsException catch (e) {
      throw _fromFirebaseFunctionsException(e);
    } catch (e) {
      if (e is DocumentParseException) {
        rethrow;
      }
      throw DocumentParseException(
        DocumentParseErrorCode.unexpected,
        params: {'error': e.toString()},
        originalError: e,
      );
    }
  }

  /// Watch async job updates from Firestore.
  Stream<Map<String, dynamic>> watchJob(String jobId) {
    return _firestore.collection('scan_jobs').doc(jobId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        return <String, dynamic>{'status': 'missing', 'jobId': jobId};
      }
      return <String, dynamic>{...data, 'jobId': jobId};
    });
  }

  /// Read current async job status once from Firestore.
  Future<Map<String, dynamic>?> getJobStatus(String jobId) async {
    final snapshot = await _firestore.collection('scan_jobs').doc(jobId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return <String, dynamic>{...data, 'jobId': jobId};
  }

  /// Read job status via Firestore REST API (bypasses gRPC SDK).
  /// Returns null if document doesn't exist yet.
  Future<Map<String, dynamic>?> getJobStatusViaRest(String jobId) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final token = await user.getIdToken();
    if (token == null) return null;

    final url = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/tavilidocscan/databases/(default)/documents/scan_jobs/$jobId',
    );

    final response = await HttpClient()
        .getUrl(url)
        .then((req) {
          req.headers.set('Authorization', 'Bearer $token');
          return req.close();
        });

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) return null;

    final body = await response.transform(utf8.decoder).join();
    final json = jsonDecode(body) as Map<String, dynamic>;
    final fields = json['fields'] as Map<String, dynamic>?;
    if (fields == null) return null;

    // Convert Firestore REST format to flat map
    final flat = _flattenFirestoreFields(fields);
    flat['jobId'] = jobId;
    return flat;
  }

  /// Convert Firestore REST field format to simple key-value map.
  /// Firestore REST returns: {"fieldName": {"stringValue": "..."}} etc.
  static dynamic _extractFirestoreValue(dynamic field) {
    if (field is! Map<String, dynamic>) return field;
    if (field.containsKey('stringValue')) return field['stringValue'];
    if (field.containsKey('integerValue')) {
      return int.tryParse(field['integerValue'].toString()) ??
          field['integerValue'];
    }
    if (field.containsKey('doubleValue')) return field['doubleValue'];
    if (field.containsKey('booleanValue')) return field['booleanValue'];
    if (field.containsKey('nullValue')) return null;
    if (field.containsKey('arrayValue')) {
      final values = field['arrayValue']['values'] as List<dynamic>?;
      return values?.map(_extractFirestoreValue).toList() ?? [];
    }
    if (field.containsKey('mapValue')) {
      final fields = field['mapValue']['fields'] as Map<String, dynamic>?;
      if (fields == null) return {};
      return _flattenFirestoreFields(fields);
    }
    return field;
  }

  static Map<String, dynamic> _flattenFirestoreFields(
    Map<String, dynamic> fields,
  ) {
    return fields
        .map((key, value) => MapEntry(key, _extractFirestoreValue(value)));
  }

  /// קריאה ל-Cloud Function parseInvoice.
  Future<ParsedDocument> _callFunction(
    Map<String, dynamic> data, {
    String? model,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'parseInvoice',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 300),
        ),
      );

      final result = await callable.call<Map<String, dynamic>>({
        ...data,
        if (model != null && model.isNotEmpty) 'model': model,
      });

      final resData = result.data;

      return ParsedDocument.fromResponse(Map<String, dynamic>.from(resData));
    } on FirebaseFunctionsException catch (e) {
      throw _fromFirebaseFunctionsException(e);
    } catch (e) {
      throw DocumentParseException(
        DocumentParseErrorCode.unexpected,
        params: {'error': e.toString()},
        originalError: e,
      );
    }
  }

  DocumentParseException _fromFirebaseFunctionsException(
    FirebaseFunctionsException e,
  ) {
    final params = <String, Object?>{
      if ((e.message ?? '').trim().isNotEmpty) 'message': e.message,
      if (e.details != null) 'details': e.details.toString(),
      'code': e.code,
    };
    switch (e.code) {
      case 'unauthenticated':
        return DocumentParseException(
          DocumentParseErrorCode.unauthenticated,
          params: params,
          originalError: e,
        );
      case 'invalid-argument':
        return DocumentParseException(
          DocumentParseErrorCode.invalidArgument,
          params: params,
          originalError: e,
        );
      case 'resource-exhausted':
        return DocumentParseException(
          DocumentParseErrorCode.resourceExhausted,
          params: params,
          originalError: e,
        );
      case 'internal':
        return DocumentParseException(
          DocumentParseErrorCode.internal,
          params: params,
          originalError: e,
        );
      default:
        return DocumentParseException(
          DocumentParseErrorCode.unknown,
          params: params,
          originalError: e,
        );
    }
  }
}

