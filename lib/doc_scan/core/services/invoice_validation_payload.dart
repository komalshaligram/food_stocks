import '../../models/invoice_document.dart';
import '../../models/invoice_item.dart';

/// בונה את גוף הבקשה לאימות חשבונית (POST /documents/validate) ממסמך נתון.
/// המיפוי לפי תיעוד ה-API §5 (foodstockComaxCrawler/docs/API.md).
class InvoiceValidationPayload {
  InvoiceValidationPayload._();

  /// [supplierCode] — אם נשלח (אחרי שהמשתמש בחר ספק מההצעות), נכנס ל-header
  /// וגובר על התאמת הח.פ. שדה supplierTaxId נשאר תמיד.
  /// [barcodeOf] — אופציונלי: מחזיר את הברקוד שיישלח לשורה (למשל הברקוד **המלא**
  /// מהקטלוג כשבחשבונית הופיע ברקוד מקוצר). אם null — נשלח item.itemNumber כפי שהוא.
  static Map<String, dynamic> fromDocument(
    InvoiceDocument doc, {
    String? supplierCode,
    String Function(InvoiceItem item)? barcodeOf,
  }) {
    final header = <String, dynamic>{
      // זיהוי הספק לפי ח.פ. (מספר עוסק מורשה) — שדה חובה.
      'supplierTaxId': _digitsOnly(doc.companyId),
      // שם הספק — רשות (לתיעוד ורמז בלבד; לא משמש לזיהוי).
      'supplierName': (doc.companyName ?? '').trim(),
      'invoiceDate': _toIsoDate(doc.documentDate) ?? (doc.documentDate ?? '').trim(),
      'supplierInvoiceNumber': _digitsOnly(doc.documentNumber),
      'allocationNumber': (doc.allocationNumber ?? '').trim(),
      'totalWithVat': _round2(doc.totalAmount) ?? 0,
    };
    if (supplierCode != null && supplierCode.trim().isNotEmpty) {
      header['supplierCode'] = supplierCode.trim();
    }
    // תאריך לתשלום — רשות; נכלל רק אם קיים ותקין.
    final iso = _toIsoDate(doc.paymentDueDate);
    if (iso != null) header['paymentDate'] = iso;

    final lines = <Map<String, dynamic>>[];
    for (final item in doc.items) {
      lines.add(_lineFromItem(item, barcodeOf));
    }

    return <String, dynamic>{
      'documentType': 'purchase_invoice',
      'header': header,
      'lines': lines,
    };
  }

  static Map<String, dynamic> _lineFromItem(
    InvoiceItem item,
    String Function(InvoiceItem item)? barcodeOf,
  ) {
    final barcode = (barcodeOf?.call(item) ?? item.itemNumber ?? '').trim();
    final line = <String, dynamic>{
      'barcode': barcode,
      'quantity': _round2(item.quantity) ?? 0,
      // מחיר ליח' סופי (נטו ליחידה, לפני מע"מ, אחרי הנחה) — מעוגל ל-2 ספרות.
      'unitPrice': _round2(item.finalUnitPrice) ?? 0,
      // סה"כ השורה לפני מע"מ — מקור האמת להצלבת הסה"כ (חסין לעיגול unitPrice).
      'lineTotal': _round2(item.totalPrice) ?? 0,
    };
    // discountPct מושמט בכוונה — ההנחה כבר מגולמת ב-unitPrice.
    // "פריט חדש" — כרגע אין תמיכה ב-API; נשלח כהכנה לעתיד.
    if (item.newProduct != null) {
      line['newProduct'] = item.newProduct!.toJson();
    }
    return line;
  }

  /// ח.פ. הספק כפי שנשלח (ספרות בלבד) — מפתח לזיכרון המקומי {ח.פ → קוד ספק}.
  static String supplierTaxIdOf(InvoiceDocument doc) => _digitsOnly(doc.companyId);

  /// משאיר ספרות בלבד (מספר חשבונית ספק חייב להיות ספרתי).
  static String _digitsOnly(String? raw) =>
      (raw ?? '').replaceAll(RegExp(r'[^0-9]'), '');

  /// עיגול ל-2 ספרות אחרי הנקודה.
  static double? _round2(double? v) {
    if (v == null) return null;
    return double.parse(v.toStringAsFixed(2));
  }

  /// נרמול תאריך ל-YYYY-MM-DD מתוך פורמטים נפוצים (DD/MM/YYYY, DD.MM.YYYY,
  /// YYYY-MM-DD וכו'). מחזיר null אם לא ניתן לפענח.
  static String? _toIsoDate(String? raw) {
    final s = (raw ?? '').trim();
    if (s.isEmpty) return null;
    // כבר ISO?
    final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(s);
    if (iso != null) {
      return '${iso.group(1)}-${_pad(iso.group(2)!)}-${_pad(iso.group(3)!)}';
    }
    final parts = s.split(RegExp(r'[/.\-]'));
    if (parts.length != 3) return null;
    final a = parts[0].trim(), b = parts[1].trim(), c = parts[2].trim();
    if (a.isEmpty || b.isEmpty || c.isEmpty) return null;
    // YYYY בתחילה → YYYY MM DD
    if (a.length == 4) {
      return '$a-${_pad(b)}-${_pad(c)}';
    }
    // אחרת DD MM YYYY
    if (c.length == 4) {
      return '$c-${_pad(b)}-${_pad(a)}';
    }
    return null;
  }

  static String _pad(String n) => n.padLeft(2, '0');
}
