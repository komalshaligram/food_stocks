import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/warehouse.dart';

/// תוצאת טעינת מחסנים מה-Cloud Function getWarehouses.
class WarehousesResult {
  const WarehousesResult({
    required this.warehouses,
    this.customerName,
    this.date,
  });

  final List<Warehouse> warehouses;
  final String? customerName;

  /// התאריך שבו הרשימה עודכנה לאחרונה (YYYY-MM-DD) או null.
  final String? date;
}

/// שירות לקריאת רשימת מחסני היעד דרך ה-Cloud Function (proxy מאובטח ל-API).
/// המפתח וקוד הלקוח נשמרים בצד השרת בלבד.
///
/// ⚠️ חובה להעביר את ה-[FirebaseApp] המשני (docScan) — הפונקציות פרוסות בפרויקט
/// `tavilidocscan`, לא ב-app ברירת המחדל.
class WarehousesService {
  WarehousesService({required FirebaseApp app, String region = 'europe-west1'})
      : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  /// טוען את רשימת המחסנים. מחסני "סרק" מסוננים אלא אם [includeVirtual].
  Future<WarehousesResult> fetchWarehouses({
    String? customerCode,
    bool includeVirtual = false,
  }) async {
    final callable = _functions.httpsCallable(
      'getWarehouses',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );

    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
      if (includeVirtual) 'includeVirtual': true,
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    final rawList = (data['warehouses'] as List?) ?? const [];
    final parsed = rawList
        .whereType<Object?>()
        .map((e) => Warehouse.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    final customer = data['customer'];
    return WarehousesResult(
      warehouses: parsed,
      customerName: customer is Map ? customer['name']?.toString() : null,
      date: data['date']?.toString(),
    );
  }
}
