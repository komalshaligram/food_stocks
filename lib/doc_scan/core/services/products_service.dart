import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/product.dart';

/// תוצאת טעינת קטלוג המוצרים מה-Cloud Function getProducts.
class ProductsResult {
  const ProductsResult({
    required this.products,
    this.customerName,
    this.date,
    this.total = 0,
  });

  final List<Product> products;
  final String? customerName;

  /// התאריך שבו הקטלוג עודכן לאחרונה (YYYY-MM-DD) או null.
  final String? date;
  final int total;
}

/// שירות לקריאת קטלוג המוצרים דרך ה-Cloud Function (proxy מאובטח ל-API החיצוני).
/// המפתח וקוד הלקוח נשמרים בצד השרת בלבד. ה-backend מחזיר גרסה רזה (code/name/barcode).
class ProductsService {
  ProductsService({required FirebaseApp app, String region = 'europe-west1'})
      : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  /// טוען את קטלוג המוצרים. בלי [search] מחזיר את כל הקטלוג (לפי תיעוד ה-API).
  /// הקטלוג גדול (~13.5k) — נותנים timeout נדיב.
  Future<ProductsResult> fetchProducts({
    String? customerCode,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final callable = _functions.httpsCallable(
      'getProducts',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 60)),
    );

    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    final rawList = (data['products'] as List?) ?? const [];
    final products = rawList
        .whereType<Object?>()
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    final customer = data['customer'];
    return ProductsResult(
      products: products,
      customerName: customer is Map ? customer['name']?.toString() : null,
      date: data['date']?.toString(),
      total: (data['total'] as num?)?.toInt() ?? products.length,
    );
  }
}
