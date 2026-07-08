/// מוצר מתוך קטלוג ה-API החיצוני (גרסה רזה: code/name/barcode + ספק).
class Product {
  const Product({
    required this.code,
    required this.name,
    required this.barcode,
    this.supplier = '',
    this.supplierCode = '',
  });

  /// קוד המוצר.
  final String code;

  /// שם המוצר.
  final String name;

  /// ברקוד המוצר.
  final String barcode;

  /// שם הספק של המוצר (מלא אם קיים) — לסינון לפי ספק החשבונית.
  final String supplier;

  /// קוד הספק של המוצר.
  final String supplierCode;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      barcode: (json['barcode'] ?? '').toString(),
      supplier: (json['supplier'] ?? '').toString(),
      supplierCode: (json['supplierCode'] ?? '').toString(),
    );
  }
}
