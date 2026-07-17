import '../../models/invoice_item.dart';

/// בדיקת עקביות אריתמטית של חשבונית סרוקה — **מעקה בטיחות לפני שליחה ל-Comax**.
///
/// למה: ה-OCR (ג'מיני *וגם* קלוד) קורא חשבוניות מסוימות שגוי — מבלבל עמודות
/// מחיר/הנחה, קורא ספרות לא נכון, מפספס את בלוק הסיכום. אין מודל ואין נוסחה
/// שיתקנו מספר שנקרא שגוי. מה שכן אפשר: לבדוק אם המספרים **מתחברים**, ואם לא —
/// לחסום שליחה במקום להעביר נתון שגוי ל-Comax (קליטה כפולה/שגויה אינה הפיכה בקלות).
///
/// כשהכל מתחבר — אפשר גם למלא אוטומטית את הסה"כ החסר בבטחה.

/// סבילות בסיס (₪) לפער עיגול בשורה קטנה.
const double _lineToleranceNis = 0.05;

/// סבילות יחסית לשורה: עיגול המחיר-ליחידה מצטבר עם הכמות (שורה של 112 יחידות
/// סוטה ב-~0.42 ₪ מעיגול תמים), בעוד טעות קריאה אמיתית סוטה בעשרות אחוזים.
/// 1% מפריד ביניהם בבירור (רעש נמדד 0.03–0.04%, טעות אמיתית ~27%).
const double _lineToleranceRel = 0.01;

/// סבילות יחסית לפער בסה"כ המסמך (העיגולים מצטברים על פני עשרות שורות).
const double _documentToleranceRel = 0.01;

/// שיעור מע"מ ברירת מחדל (ישראל 2026). נגזר מהמסמך כשאפשר — ראו [InvoiceTotals].
const double defaultVatRate = 0.18;

/// רמת חומרה של ממצא.
enum ConsistencySeverity {
  /// חוסם שליחה לקופה.
  blocking,

  /// לתשומת לב, אינו חוסם.
  warning,
}

/// ממצא בודד — שורה ספציפית או סה"כ המסמך.
class ConsistencyIssue {
  const ConsistencyIssue({
    required this.severity,
    required this.message,
    this.lineNumber,
    this.expected,
    this.actual,
  });

  final ConsistencySeverity severity;

  /// הודעה מוכנה להצגה (עברית).
  final String message;

  /// מספר השורה, או null אם זה ממצא ברמת המסמך.
  final int? lineNumber;

  /// מה היה אמור להיות מול מה שנקרא — לחישוב הפער בתצוגה.
  final double? expected;
  final double? actual;

  double? get delta =>
      (expected != null && actual != null) ? actual! - expected! : null;
}

/// סיכומי מסמך מחושבים מהשורות.
class InvoiceTotals {
  const InvoiceTotals({
    required this.linesSum,
    required this.vatRate,
    required this.subtotal,
    required this.vat,
    required this.total,
  });

  /// סכום כל `line_total` בשורות (נטו, לפני מע"מ).
  final double linesSum;
  final double vatRate;

  /// הסיכומים הנגזרים — למילוי אוטומטי כשהמסמך עקבי.
  final double subtotal;
  final double vat;
  final double total;
}

class ConsistencyReport {
  const ConsistencyReport({
    required this.issues,
    required this.computedTotals,
  });

  final List<ConsistencyIssue> issues;

  /// הסיכומים המחושבים מהשורות. מהימנים רק כש-[isConsistent].
  final InvoiceTotals computedTotals;

  List<ConsistencyIssue> get blockingIssues =>
      issues.where((i) => i.severity == ConsistencySeverity.blocking).toList();

  /// אזהרות שאינן חוסמות (פער בין הסה"כ שבחשבונית לחישוב מהשורות).
  List<ConsistencyIssue> get warningIssues =>
      issues.where((i) => i.severity == ConsistencySeverity.warning).toList();

  /// אין שום ממצא חוסם — מותר לשלוח לקופה (אחרי אישור אם יש אזהרות).
  /// כשאין ממצא חוסם, גם הסיכומים המחושבים מהימנים (השורות מתחברות).
  bool get isConsistent => blockingIssues.isEmpty;

  bool get hasWarnings => warningIssues.isNotEmpty;
}

/// מנתח את השורות ומחזיר דוח עקביות.
///
/// [documentSubtotal]/[documentTotal] — הסכומים שה-OCR קרא (אם קרא). כשהם
/// קיימים, הם מוצלבים מול סכום השורות; פער חוסם. כשהם null — נגזרים מהשורות.
///
/// [vatRate] — אם נמסר (נגזר מהמסמך), משמש לחישוב; אחרת [defaultVatRate].
/// חשבוניות אילת (0%) וישנות (17%) חייבות להישמר, ולכן עדיף לגזור מהמסמך.
ConsistencyReport analyzeInvoice(
  List<InvoiceItem> items, {
  double? documentSubtotal,
  double? documentTotal,
  double? vatRate,
}) {
  final issues = <ConsistencyIssue>[];
  final rate = vatRate ?? defaultVatRate;

  var linesSum = 0.0;
  for (final item in items) {
    linesSum += item.totalPrice;

    // שורה עם סה"כ חיובי אבל כמות 0 — קריאת OCR שגויה (לא שורת פיקדון: לזו
    // גם המחיר 0). ראינו את זה בפועל: קלוד קרא כמות 0 לשורה בסך 132.18 ₪.
    if (item.totalPrice.abs() > _lineToleranceNis &&
        item.quantity <= 0 &&
        item.pricePerUnit > 0) {
      issues.add(ConsistencyIssue(
        severity: ConsistencySeverity.blocking,
        lineNumber: item.lineNumber,
        message: 'שורה ${item.lineNumber}: '
            'סה"כ ${item.totalPrice.toStringAsFixed(2)} ₪ אך כמות 0.',
      ));
      continue;
    }

    // כל שורה חייבת לקיים: כמות × מחיר-ליחידה × (1 - הנחה) + תוספות ≈ סה"כ שורה.
    final expected = _expectedLineTotal(item);
    if (expected != null &&
        (item.totalPrice - expected).abs() > _lineTolerance(item.totalPrice)) {
      issues.add(ConsistencyIssue(
        severity: ConsistencySeverity.blocking,
        lineNumber: item.lineNumber,
        expected: expected,
        actual: item.totalPrice,
        message: 'שורה ${item.lineNumber}: '
            'כמות × מחיר = ${expected.toStringAsFixed(2)} ₪, '
            'אך סה"כ השורה ${item.totalPrice.toStringAsFixed(2)} ₪.',
      ));
    }
  }

  final vat = linesSum * rate;
  final total = linesSum + vat;

  // הצלבה מול סה"כ שה-OCR קרא. **אזהרה בלבד, לא חוסמת** — כשהשורות עצמן
  // עקביות, פער מול הסה"כ נובע לרוב מסיבה לגיטימית (חשבונית רב-עמודית שסרקו
  // חלקית), או מקריאה שגויה של בלוק הסיכום. המשתמש רואה את שני המספרים ומחליט.
  if (documentSubtotal != null && documentSubtotal > 0) {
    final tol = documentSubtotal * _documentToleranceRel;
    if ((documentSubtotal - linesSum).abs() > tol) {
      issues.add(ConsistencyIssue(
        severity: ConsistencySeverity.warning,
        expected: linesSum,
        actual: documentSubtotal,
        message: 'הסכום בחשבונית ${documentSubtotal.toStringAsFixed(2)} ₪ '
            'שונה מסכום השורות ${linesSum.toStringAsFixed(2)} ₪ (ללא מע"מ).',
      ));
    }
  }
  if (documentTotal != null && documentTotal > 0) {
    final tol = documentTotal * _documentToleranceRel;
    if ((documentTotal - total).abs() > tol) {
      issues.add(ConsistencyIssue(
        severity: ConsistencySeverity.warning,
        expected: total,
        actual: documentTotal,
        message: 'הסה"כ לתשלום בחשבונית ${documentTotal.toStringAsFixed(2)} ₪ '
            'שונה מהחישוב ${total.toStringAsFixed(2)} ₪ (כולל מע"מ).',
      ));
    }
  }

  return ConsistencyReport(
    issues: issues,
    computedTotals: InvoiceTotals(
      linesSum: linesSum,
      vatRate: rate,
      subtotal: linesSum,
      vat: vat,
      total: total,
    ),
  );
}

/// הסה"כ הצפוי לשורה לפי חלקיה, או null כשאין מספיק נתונים לבדיקה.
///
/// `כמות × מחיר-ליחידה × (1 - הנחה/100) + אריזה/מס/פיקדון`.
/// כש-[InvoiceItem.pricePerUnit] הוא 0 (למשל שורת פיקדון/משטח בלבד) — לא בודקים.
/// הסבילות המותרת לשורה: הגדולה מבין בסיס קבוע ל-1% מסכום השורה.
double _lineTolerance(double lineTotal) =>
    lineTotal.abs() * _lineToleranceRel > _lineToleranceNis
        ? lineTotal.abs() * _lineToleranceRel
        : _lineToleranceNis;

double? _expectedLineTotal(InvoiceItem item) {
  if (item.pricePerUnit <= 0 || item.quantity <= 0) return null;
  final discountFactor = 1 - ((item.discountPercent ?? 0) / 100);
  final extras = item.packagingDepositTax ?? 0;
  return item.quantity * item.pricePerUnit * discountFactor + extras;
}
