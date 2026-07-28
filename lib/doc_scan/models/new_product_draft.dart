/// טיוטת "פריט חדש" שנוצרת עבור שורה שהברקוד שלה אינו קיים בקטלוג הלקוח.
///
/// נשמרת על שורת הפריט (ולכן שורדת סגירה/פתיחה של המסמך) ונשלחת בתוך אותה שורה
/// ב-`lines` של `POST /api/v1/documents/validate` — **לא** ב-`header`.
/// שורה שיש עליה טיוטה לא תיפסל כ-`line_item_not_found`.
///
/// תיעוד: `foodstockComaxCrawler/docs/new-product-spec.md`, `docs/API.md` §3א-3ג.
///
/// ⚠️ כל קודי הדרופדאונים (`unitCode`, `conversionUnitCode`, `misc`, ...) הם **פר-לקוח**
/// ומתנגשים בין לקוחות — ראו ההסבר ב-`ItemFormOptions`. הם נשמרים כאן בדיוק כפי
/// שהגיעו מרשימת אותו לקוח, בלי נרמול.
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
    // --- אזור 1: זיהוי ---
    this.unitCode,
    this.unitName,
    this.weighable = false,
    // --- אזור 3: תמחור ---
    this.noSupplierDiscount = false,
    // --- אזור 4: אריזה והמרות ---
    this.conversionQty,
    this.conversionUnitCode,
    this.conversionUnitName,
    this.packageWeight,
    this.calcQty,
    // --- אזור 5: מאפיינים ---
    this.delicatessen = false,
    // --- אזור 6: קופה ומועדון (לא קיים אצל כל לקוח) ---
    this.clubCode,
    this.registerDiscount,
    this.promotion,
  });

  // ===== אזור 1 — זיהוי הפריט =====

  /// קוד/מספר הפריט בקטלוג Comax. ברירת מחדל: הברקוד. **ספרות בלבד** — טקסט מייצר
  /// בקומקס "קוד שגוי !" והשדה נזרק.
  final String itemCode;
  final String barcode;
  final String name;

  /// מידה — קוד מרשימת `units` של אותו לקוח.
  final String? unitCode;
  final String? unitName;

  /// שקיל.
  final bool weighable;

  // ===== אזור 2 — שיוך =====

  final String? departmentCode;
  final String? departmentName;

  /// קוד הקבוצה. ⚠️ אינו ייחודי — תמיד בהקשר של [departmentCode].
  final String? groupCode;
  final String? groupName;

  /// ספק ראשי.
  final String? supplierCode;
  final String? supplierName;

  /// פריט ספק = מק"ט הספק. **ספרות בלבד** (כמו [itemCode]).
  final String? supplierItem;

  // ===== אזור 3 — תמחור =====

  /// מחיר ספק / מחיר קניה (לפני מע"מ).
  final double? supplierPrice;
  final double? discountPct;

  /// ⚠️ חייב להיות < 100. בדיוק 100 = חלוקה באפס, וקומקס כותב מחיר מכירה 0.
  final double? profitPct;

  /// מחיר מכירה. בטופס זהו שדה מחושב לתצוגה בלבד — הערך המחייב הוא
  /// `resolved.lines[i].newProduct.computedSalePrice` שחוזר מ-`/documents/validate`.
  final double? salePrice;

  /// ללא הנחת ספק (מאפס בקומקס את "% הנחת ספק").
  ///
  /// שימו לב: "% הנחת ספק" עצמו **אינו** בטופס ואינו נשלח — `#DisSpk` הוא readonly,
  /// קומקס מחשב אותו, וה-API דוחה ניסיון לקבוע אותו.
  final bool noSupplierDiscount;

  // ===== אזור 4 — אריזה והמרות =====

  final double? conversionQty;
  final String? conversionUnitCode;
  final String? conversionUnitName;
  final double? packageWeight;
  final double? calcQty;

  // ===== אזור 5 — פקדון ומאפיינים =====

  final bool manageDeposit;

  /// נגרר לקופה — קוד פריט פקדון/אריזה מרשימת הלקוח (לא enum).
  final String? draggedToRegister;

  /// פריט פקדון — קוד פריט פקדון/אריזה מרשימת הלקוח (לא enum).
  ///
  /// ⚠️ ידוע: קומקס לפעמים דורס את השדה הזה בערך של "נגרר לקופה". הקרולר מנסה שוב
  /// בסוף הקליטה, אבל אם לא נתפס — הקליטה ממשיכה והשדה עלול לצאת שגוי.
  final String? depositItem;

  /// מעדניה.
  final bool delicatessen;

  /// שונות — enum קבוע 0–13, זהה לכל הלקוחות.
  final String? misc;

  // ===== אזור 6 — קופה ומועדון =====

  /// ⚠️ שלושת השדות הבאים לא קיימים אצל כל לקוח (`present:false` ב-item-form-options).
  /// שליחת ערך ללקוח שאין לו את השדה מוחזרת כ-`field_not_available`.
  final String? clubCode;
  final String? registerDiscount;
  final String? promotion;

  /// שדות החובה מולאו (אזורים 1–2 בלבד — כך משתמש שממהר מסיים מהר).
  bool get isComplete =>
      itemCode.trim().isNotEmpty &&
      barcode.trim().isNotEmpty &&
      name.trim().isNotEmpty &&
      (departmentCode ?? '').isNotEmpty &&
      (groupCode ?? '').isNotEmpty &&
      (supplierCode ?? '').isNotEmpty;

  NewProductDraft copyWith({
    String? itemCode,
    String? barcode,
    String? name,
    String? departmentCode,
    String? departmentName,
    String? groupCode,
    String? groupName,
    String? supplierCode,
    String? supplierName,
    String? supplierItem,
    double? supplierPrice,
    double? discountPct,
    double? profitPct,
    double? salePrice,
    bool? manageDeposit,
    String? draggedToRegister,
    String? depositItem,
    String? misc,
    String? unitCode,
    String? unitName,
    bool? weighable,
    bool? noSupplierDiscount,
    double? conversionQty,
    String? conversionUnitCode,
    String? conversionUnitName,
    double? packageWeight,
    double? calcQty,
    bool? delicatessen,
    String? clubCode,
    String? registerDiscount,
    String? promotion,
  }) {
    return NewProductDraft(
      itemCode: itemCode ?? this.itemCode,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      departmentCode: departmentCode ?? this.departmentCode,
      departmentName: departmentName ?? this.departmentName,
      groupCode: groupCode ?? this.groupCode,
      groupName: groupName ?? this.groupName,
      supplierCode: supplierCode ?? this.supplierCode,
      supplierName: supplierName ?? this.supplierName,
      supplierItem: supplierItem ?? this.supplierItem,
      supplierPrice: supplierPrice ?? this.supplierPrice,
      discountPct: discountPct ?? this.discountPct,
      profitPct: profitPct ?? this.profitPct,
      salePrice: salePrice ?? this.salePrice,
      manageDeposit: manageDeposit ?? this.manageDeposit,
      draggedToRegister: draggedToRegister ?? this.draggedToRegister,
      depositItem: depositItem ?? this.depositItem,
      misc: misc ?? this.misc,
      unitCode: unitCode ?? this.unitCode,
      unitName: unitName ?? this.unitName,
      weighable: weighable ?? this.weighable,
      noSupplierDiscount: noSupplierDiscount ?? this.noSupplierDiscount,
      conversionQty: conversionQty ?? this.conversionQty,
      conversionUnitCode: conversionUnitCode ?? this.conversionUnitCode,
      conversionUnitName: conversionUnitName ?? this.conversionUnitName,
      packageWeight: packageWeight ?? this.packageWeight,
      calcQty: calcQty ?? this.calcQty,
      delicatessen: delicatessen ?? this.delicatessen,
      clubCode: clubCode ?? this.clubCode,
      registerDiscount: registerDiscount ?? this.registerDiscount,
      promotion: promotion ?? this.promotion,
    );
  }

  /// ה-payload שנשלח ל-API.
  ///
  /// שדות אופציונליים ריקים **מושמטים** ולא נשלחים כ-null: אצל לקוח שאין לו שדה
  /// מסוים (`present:false`) שליחת המפתח עלולה לחזור כ-`field_not_available`, ואין
  /// שום ערך בלשלוח מפתח ריק. שדות החובה נשלחים תמיד.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'itemCode': itemCode,
      'barcode': barcode,
      'name': name,
      'departmentCode': departmentCode,
      'groupCode': groupCode,
      'supplierCode': supplierCode,
      // בוליאנים נשלחים תמיד — ל-false יש משמעות, והוא לא "ערך חסר".
      'manageDeposit': manageDeposit,
      'weighable': weighable,
      'delicatessen': delicatessen,
      'noSupplierDiscount': noSupplierDiscount,
    };

    void put(String key, Object? value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      json[key] = value;
    }

    // שמות — לנוחות/תצוגה בצד השרת בלבד.
    put('departmentName', departmentName);
    put('groupName', groupName);
    put('supplierName', supplierName);
    put('unitName', unitName);
    put('conversionUnitName', conversionUnitName);

    put('supplierItem', supplierItem);
    put('supplierPrice', supplierPrice);
    put('discountPct', discountPct);
    put('profitPct', profitPct);
    put('salePrice', salePrice);
    put('unitCode', unitCode);
    put('conversionQty', conversionQty);
    put('conversionUnitCode', conversionUnitCode);
    put('packageWeight', packageWeight);
    put('calcQty', calcQty);
    put('draggedToRegister', draggedToRegister);
    put('depositItem', depositItem);
    put('misc', misc);
    put('clubCode', clubCode);
    put('registerDiscount', registerDiscount);
    put('promotion', promotion);

    return json;
  }

  factory NewProductDraft.fromJson(Map<String, dynamic> json) {
    double? asDouble(Object? v) => (v as num?)?.toDouble();
    String? asString(Object? v) {
      final s = v?.toString().trim();
      return (s == null || s.isEmpty) ? null : s;
    }

    return NewProductDraft(
      itemCode: (json['itemCode'] ?? '').toString(),
      barcode: (json['barcode'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      departmentCode: asString(json['departmentCode']),
      departmentName: asString(json['departmentName']),
      groupCode: asString(json['groupCode']),
      groupName: asString(json['groupName']),
      supplierCode: asString(json['supplierCode']),
      supplierName: asString(json['supplierName']),
      supplierItem: asString(json['supplierItem']),
      supplierPrice: asDouble(json['supplierPrice']),
      discountPct: asDouble(json['discountPct']),
      profitPct: asDouble(json['profitPct']),
      salePrice: asDouble(json['salePrice']),
      manageDeposit: json['manageDeposit'] == true,
      draggedToRegister: asString(json['draggedToRegister']),
      depositItem: asString(json['depositItem']),
      misc: asString(json['misc']),
      unitCode: asString(json['unitCode']),
      unitName: asString(json['unitName']),
      weighable: json['weighable'] == true,
      noSupplierDiscount: json['noSupplierDiscount'] == true,
      conversionQty: asDouble(json['conversionQty']),
      conversionUnitCode: asString(json['conversionUnitCode']),
      conversionUnitName: asString(json['conversionUnitName']),
      packageWeight: asDouble(json['packageWeight']),
      calcQty: asDouble(json['calcQty']),
      delicatessen: json['delicatessen'] == true,
      clubCode: asString(json['clubCode']),
      registerDiscount: asString(json['registerDiscount']),
      promotion: asString(json['promotion']),
    );
  }
}
