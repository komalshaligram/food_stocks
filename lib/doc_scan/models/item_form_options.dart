/// רשימות הבחירה של טופס "פריט חדש", כפי שהן קיימות אצל *אותו לקוח* ב-Comax.
///
/// מגיע מ-`GET /api/v1/item-form-options` (דרך ה-Cloud Function `getItemFormOptions`),
/// שמחזיר את כל שמונה הרשימות בקריאה אחת. תיעוד: `foodstockComaxCrawler/docs/API.md` §3ב.
///
/// ⚠️ שני כללים שאם שוברים אותם זה נכשל **בשקט**:
///
/// 1. **`present == false` ≠ "רשימה ריקה"** — לשדה הזה פשוט אין קיום בטופס של הלקוח
///    (לסופר האחים חזות, למשל, אין `promotion`/`clubCode`/`registerDiscount`).
///    את השדה לא מציגים בכלל; שליחת ערך תוחזר כשגיאת `field_not_available`.
///
/// 2. **הקודים הם פר-לקוח והם מתנגשים.** הקוד `7` הוא "גרם" אצל ל חגולי, "קרטון" אצל
///    גיא ודניאל ו-"ק״ג" אצל חזות. לכן אסור לקבע קוד בקוד ואסור להעביר קוד מלקוח
///    אחד לאחר — תמיד שולחים בחזרה את ה-`code` שהגיע ברשימה של אותו לקוח. טעות כאן
///    לא מייצרת שגיאה, היא פותחת פריט ביחידת מידה שגויה ומתגלה רק במלאי.
library;

/// אפשרות בודדת בדרופדאון. [barcode] קיים רק ברשימות פריטי פקדון/אריזה.
class ItemFormOption {
  const ItemFormOption({required this.code, required this.name, this.barcode});

  final String code;
  final String name;
  final String? barcode;

  /// מה שמוצג למשתמש. חלק מהאפשרויות מגיעות בלי שם (למשל הערך הריק של "שונות"),
  /// ואז מציגים את הקוד כדי שלא תופיע שורה ריקה בדרופדאון.
  String get label {
    final n = name.trim();
    if (n.isNotEmpty) return n;
    return code.trim();
  }

  factory ItemFormOption.fromJson(Map<String, dynamic> json) => ItemFormOption(
        code: (json['code'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        barcode: json['barcode']?.toString(),
      );
}

/// רשימה אחת + הדגל האם השדה בכלל קיים בטופס של הלקוח.
class ItemFormOptionList {
  const ItemFormOptionList({required this.present, required this.options});

  const ItemFormOptionList.absent()
      : present = false,
        options = const [];

  final bool present;
  final List<ItemFormOption> options;

  /// האם להציג את השדה: גם קיים אצל הלקוח וגם יש ממה לבחור.
  bool get visible => present && options.isNotEmpty;

  factory ItemFormOptionList.fromJson(dynamic raw) {
    if (raw is Map) {
      final opts = raw['options'];
      return ItemFormOptionList(
        present: raw['present'] == true,
        options: opts is List
            ? opts
                .whereType<Map>()
                .map((e) => ItemFormOption.fromJson(Map<String, dynamic>.from(e)))
                .toList(growable: false)
            : const [],
      );
    }
    // סובלנות לפורמט הישן (מערך שטוח, כמו ב-/deposit-items).
    if (raw is List) {
      return ItemFormOptionList(
        present: true,
        options: raw
            .whereType<Map>()
            .map((e) => ItemFormOption.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false),
      );
    }
    return const ItemFormOptionList.absent();
  }

  /// מאתר אפשרות לפי קוד. מחזיר null אם הקוד כבר לא קיים ברשימה של הלקוח —
  /// למשל טיוטה שנשמרה כשהמשתמש היה מחובר ללקוח אחר.
  ItemFormOption? byCode(String? code) {
    if (code == null || code.isEmpty) return null;
    for (final o in options) {
      if (o.code == code) return o;
    }
    return null;
  }
}

/// כל שמונה הרשימות של הטופס.
class ItemFormOptions {
  const ItemFormOptions({
    this.units = const ItemFormOptionList.absent(),
    this.conversionUnit = const ItemFormOptionList.absent(),
    this.draggedToRegister = const ItemFormOptionList.absent(),
    this.depositItem = const ItemFormOptionList.absent(),
    this.misc = const ItemFormOptionList.absent(),
    this.clubCode = const ItemFormOptionList.absent(),
    this.registerDiscount = const ItemFormOptionList.absent(),
    this.promotion = const ItemFormOptionList.absent(),
    this.updatedAt,
  });

  /// מידה.
  final ItemFormOptionList units;

  /// המרה ב.
  final ItemFormOptionList conversionUnit;

  /// נגרר לקופה.
  final ItemFormOptionList draggedToRegister;

  /// פריט פקדון.
  final ItemFormOptionList depositItem;

  /// שונות.
  final ItemFormOptionList misc;

  /// קוד מועדון. ⚠️ לא קיים אצל כל לקוח.
  final ItemFormOptionList clubCode;

  /// הנחת קופה. ⚠️ לא קיים אצל כל לקוח.
  final ItemFormOptionList registerDiscount;

  /// מבצע. ⚠️ לא קיים אצל כל לקוח.
  final ItemFormOptionList promotion;

  final String? updatedAt;

  /// אזור 6 בטופס ("קופה ומועדון") נעלם לגמרי כששלושת השדות שלו לא קיימים אצל הלקוח.
  bool get hasRegisterAndClubSection =>
      clubCode.visible || registerDiscount.visible || promotion.visible;

  factory ItemFormOptions.fromJson(Map<String, dynamic> json) => ItemFormOptions(
        units: ItemFormOptionList.fromJson(json['units']),
        conversionUnit: ItemFormOptionList.fromJson(json['conversionUnit']),
        draggedToRegister: ItemFormOptionList.fromJson(json['draggedToRegister']),
        depositItem: ItemFormOptionList.fromJson(json['depositItem']),
        misc: ItemFormOptionList.fromJson(json['misc']),
        clubCode: ItemFormOptionList.fromJson(json['clubCode']),
        registerDiscount: ItemFormOptionList.fromJson(json['registerDiscount']),
        promotion: ItemFormOptionList.fromJson(json['promotion']),
        updatedAt: json['updatedAt']?.toString(),
      );
}
