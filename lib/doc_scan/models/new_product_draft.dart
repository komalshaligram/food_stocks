/// טיוטת "פריט חדש" שנוצר עבור שורה שהברקוד שלה אינו קיים בקטלוג.
/// נשמרת על שורת הפריט (נשמרת עם המסמך) ותישלח ל-API בעתיד (כרגע אין תמיכה).
class NewProductDraft {
  const NewProductDraft({
    required this.itemCode,
    required this.barcode,
    required this.name,
    this.departmentCode,
    this.departmentName,
    this.groupCode,
    this.groupName,
    this.supplierCode,
    this.supplierName,
    this.supplierItem,
    this.supplierPrice,
    this.discountPct,
    this.profitPct,
    this.salePrice,
    this.manageDeposit = false,
    this.draggedToRegister,
    this.depositItem,
    this.misc,
  });

  /// פריט = מספר הפריט בקטלוג (ברירת מחדל: הברקוד).
  final String itemCode;
  final String barcode;
  final String name;

  final String? departmentCode;
  final String? departmentName;
  final String? groupCode;
  final String? groupName;

  /// ספק ראשי.
  final String? supplierCode;
  final String? supplierName;

  /// פריט ספק = מק"ט הספק.
  final String? supplierItem;

  /// מחיר ספק / מחיר קניה.
  final double? supplierPrice;
  final double? discountPct;
  final double? profitPct;
  final double? salePrice;

  final bool manageDeposit;

  /// דרופדאונים שהערכים שלהם יסופקו בהמשך.
  final String? draggedToRegister; // נגרר לקופה
  final String? depositItem; // פריט פקדון
  final String? misc; // שונות

  Map<String, dynamic> toJson() => {
        'itemCode': itemCode,
        'barcode': barcode,
        'name': name,
        'departmentCode': departmentCode,
        'departmentName': departmentName,
        'groupCode': groupCode,
        'groupName': groupName,
        'supplierCode': supplierCode,
        'supplierName': supplierName,
        'supplierItem': supplierItem,
        'supplierPrice': supplierPrice,
        'discountPct': discountPct,
        'profitPct': profitPct,
        'salePrice': salePrice,
        'manageDeposit': manageDeposit,
        'draggedToRegister': draggedToRegister,
        'depositItem': depositItem,
        'misc': misc,
      };

  factory NewProductDraft.fromJson(Map<String, dynamic> json) => NewProductDraft(
        itemCode: (json['itemCode'] ?? '').toString(),
        barcode: (json['barcode'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        departmentCode: json['departmentCode'] as String?,
        departmentName: json['departmentName'] as String?,
        groupCode: json['groupCode'] as String?,
        groupName: json['groupName'] as String?,
        supplierCode: json['supplierCode'] as String?,
        supplierName: json['supplierName'] as String?,
        supplierItem: json['supplierItem'] as String?,
        supplierPrice: (json['supplierPrice'] as num?)?.toDouble(),
        discountPct: (json['discountPct'] as num?)?.toDouble(),
        profitPct: (json['profitPct'] as num?)?.toDouble(),
        salePrice: (json['salePrice'] as num?)?.toDouble(),
        manageDeposit: json['manageDeposit'] == true,
        draggedToRegister: json['draggedToRegister'] as String?,
        depositItem: json['depositItem'] as String?,
        misc: json['misc'] as String?,
      );
}
