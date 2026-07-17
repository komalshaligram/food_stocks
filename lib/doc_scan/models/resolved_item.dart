/// רמת הוודאות שה-resolver מייחס להתאמת שם-מוצר -> ברקוד.
///
/// חשבוניות של חלק מהספקים מגיעות **ללא ברקודים** (רק תיאור מקוצץ), וה-Cloud
/// Function `resolveInvoiceItems` משחזרת אותם מקטלוג הלקוח. לא כל שחזור שווה:
/// לפעמים הקטלוג מכיל שני פריטים **זהים בשם ובמחיר** ואין דרך להכריע ביניהם.
enum BarcodeConfidence {
  /// התאמה חד-משמעית. ממלאים אוטומטית, ללא סימון.
  high,

  /// הברקוד כנראה נכון, אך הוסק ממידע חלקי (למשל היעדר סימן-אורך בתיאור).
  /// ממלאים אוטומטית ומסמנים בכתום — לא חוסם שליחה.
  medium,

  /// יש כמה מועמדים שקולים. **לא ממלאים**; השורה נשארת ריקה ואדומה,
  /// בדיוק כמו ברקוד שאינו בקטלוג, והמשתמש בוחר מתוך [ResolvedItem.alternatives].
  low;

  static BarcodeConfidence? fromName(String? value) {
    switch (value) {
      case 'high':
        return BarcodeConfidence.high;
      case 'medium':
        return BarcodeConfidence.medium;
      case 'low':
        return BarcodeConfidence.low;
      default:
        return null;
    }
  }
}

/// מועמד להתאמה. **הברקוד והמחיר חייבים להיות מוצגים** ולא רק השם: הקטלוג מכיל
/// כפילויות שבהן שני פריטים נושאים שם זהה תו-בתו (למשל שני "מרלבורו גולד"),
/// ובלעדיהם המשתמש רואה שתי שורות זהות ואין לו על מה לבסס בחירה.
class ResolvedCandidate {
  const ResolvedCandidate({
    required this.barcode,
    required this.name,
    this.purchasePrice,
  });

  final String barcode;
  final String name;
  final double? purchasePrice;

  factory ResolvedCandidate.fromJson(Map<String, dynamic> json) {
    return ResolvedCandidate(
      barcode: (json['barcode'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
    );
  }
}

/// תוצאת ההצלבה לשורת חשבונית אחת.
class ResolvedItem {
  const ResolvedItem({
    required this.lineNumber,
    required this.confidence,
    this.barcode,
    this.matchedName,
    this.alternatives = const [],
  });

  final int lineNumber;
  final BarcodeConfidence confidence;
  final String? barcode;
  final String? matchedName;

  /// מועמדים נוספים, מדורגים. מוצגים ב-picker; רלוונטיים בעיקר ל-[BarcodeConfidence.low].
  final List<ResolvedCandidate> alternatives;

  /// האם למלא את הברקוד אוטומטית בשורה.
  bool get shouldAutoFill =>
      barcode != null &&
      barcode!.isNotEmpty &&
      confidence != BarcodeConfidence.low;

  factory ResolvedItem.fromJson(Map<String, dynamic> json) {
    final rawAlts = (json['alternatives'] as List?) ?? const [];
    return ResolvedItem(
      lineNumber: (json['lineNumber'] as num?)?.toInt() ?? 0,
      confidence:
          BarcodeConfidence.fromName(json['confidence']?.toString()) ??
              BarcodeConfidence.low,
      barcode: (json['barcode'] as String?)?.trim().isEmpty ?? true
          ? null
          : (json['barcode'] as String).trim(),
      matchedName: json['matchedName'] as String?,
      alternatives: rawAlts
          .whereType<Object?>()
          .map((e) => ResolvedCandidate.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

/// התשובה המלאה של `resolveInvoiceItems`.
class ResolveItemsResult {
  const ResolveItemsResult({
    required this.items,
    this.catalogDate,
    this.catalogSize = 0,
  });

  final List<ResolvedItem> items;
  final String? catalogDate;
  final int catalogSize;

  int get autoFilledCount => items.where((i) => i.shouldAutoFill).length;
  int get needsReviewCount =>
      items.where((i) => i.confidence == BarcodeConfidence.medium).length;
  int get unresolvedCount =>
      items.where((i) => i.confidence == BarcodeConfidence.low).length;
}
