/// מחסן יעד לקליטת מסמך ל-Comax (מ-`GET /api/v1/warehouses`, §5c).
///
/// המשתמש בוחר מחסן, וה-[code] (+[name] לתיעוד) נשלחים ב-header של השליחה לקופה.
/// ה-[code] הוא המזהה הקובע; מחסן "סרק" (virtual) מסונן כברירת מחדל בצד הקרולר.
class Warehouse {
  const Warehouse({
    required this.code,
    required this.name,
    this.branch = '',
    this.branchName = '',
    this.virtual = false,
  });

  /// קוד המחסן — זה מה שנשלח כ-`header.warehouseCode` בקליטה.
  final String code;

  /// שם המחסן להצגה (נשלח כ-`header.warehouseName` לתיעוד).
  final String name;

  /// הסניף שהמחסן שייך אליו (ריק אם אין).
  final String branch;
  final String branchName;

  /// `true` = מחסן "סרק" (פגומים / איפוס ספירות). לא מוחזר כברירת מחדל.
  final bool virtual;

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        code: (json['code'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        branch: (json['branch'] ?? '').toString(),
        branchName: (json['branchName'] ?? '').toString(),
        virtual: json['virtual'] == true,
      );
}
