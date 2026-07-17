/// ספק מתוך ה-API החיצוני (רשימת ספקים של הלקוח).
class Supplier {
  const Supplier({
    required this.code,
    required this.name,
    this.fields = const {},
  });

  /// קוד הספק.
  final String code;

  /// שם הספק.
  final String name;

  /// כל העמודות מקומקס (מפתחות בעברית), as-is.
  final Map<String, String> fields;

  /// ח.פ / עוסק מורשה. ה-OCR מחלץ אותו מהחשבונית, אבל `/invoices/exists` דורש
  /// **`supplierCode`** ואינו מקבל ח.פ — לכן הממיר יושב כאן.
  String get taxId => (fields['עוסק מורשה'] ?? '').trim();

  factory Supplier.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    final fields = <String, String>{};
    if (rawFields is Map) {
      rawFields.forEach((key, value) {
        fields[key.toString()] = value?.toString() ?? '';
      });
    }
    return Supplier(
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      fields: fields,
    );
  }
}
