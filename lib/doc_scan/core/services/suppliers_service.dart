import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/supplier.dart';

/// תוצאת טעינת ספקים מה-Cloud Function getSuppliers.
class SuppliersResult {
  const SuppliersResult({
    required this.suppliers,
    this.customerName,
    this.date,
    this.total = 0,
  });

  final List<Supplier> suppliers;
  final String? customerName;

  /// התאריך שבו הרשימה עודכנה לאחרונה (YYYY-MM-DD) או null.
  final String? date;
  final int total;
}

/// שירות לקריאת רשימת הספקים דרך ה-Cloud Function (proxy מאובטח ל-API החיצוני).
/// המפתח וקוד הלקוח נשמרים בצד השרת בלבד.
///
/// ⚠️ ב-food_stocks חובה להעביר את ה-[FirebaseApp] המשני (docScan) כדי לפנות
/// לפרויקט `tavilidocscan` שבו הפונקציות פרוסות — ולא ל-app ברירת המחדל
/// (`foodstock-dev`) שבו הן אינן קיימות.
class SuppliersService {
  SuppliersService({required FirebaseApp app, String region = 'europe-west1'})
      : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  /// טוען ספקים. בלי [search] מחזיר את כל הרשימה (לפי תיעוד ה-API).
  /// [customerCode] — אם נשלח, השרת ישתמש בו במקום בברירת המחדל שב-Secret.
  Future<SuppliersResult> fetchSuppliers({
    String? customerCode,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final callable = _functions.httpsCallable(
      'getSuppliers',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );

    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    final rawList = (data['suppliers'] as List?) ?? const [];
    final parsed = rawList
        .whereType<Object?>()
        .map((e) => Supplier.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    // הסרת כפילויות — נתוני Comax עשויים להחזיר את אותו ספק פעמיים. מזהים לפי קוד
    // (כשקיים), אחרת לפי שם. שומרים את ההופעה הראשונה.
    final seen = <String>{};
    final suppliers = <Supplier>[];
    for (final s in parsed) {
      final key = s.code.trim().isNotEmpty
          ? 'code:${s.code.trim()}'
          : 'name:${s.name.trim()}';
      if (seen.add(key)) suppliers.add(s);
    }

    final customer = data['customer'];
    return SuppliersResult(
      suppliers: suppliers,
      customerName: customer is Map ? customer['name']?.toString() : null,
      date: data['date']?.toString(),
      total: (data['total'] as num?)?.toInt() ?? suppliers.length,
    );
  }
}
