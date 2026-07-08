import 'dart:convert';

import '../../models/invoice_document.dart';
import '../../models/invoice_item.dart';

/// בונה מפת JSON לייצוא אקסל: מתחיל מ־[InvoiceDocument.parsedJson] (אם יש),
/// ודורס בשדות ובפריטים מהמודל — כך שינויים אחרי עריכה ושמירה משתקפים בייצוא.
class InvoiceExcelExportPayload {
  InvoiceExcelExportPayload._();

  /// מיזוג: JSON מקורי מהשרת + ערכים עדכניים מ־[document] (כולל [InvoiceDocument.items]).
  static Map<String, dynamic> buildExportMapFromDocument(InvoiceDocument document) {
    var map = <String, dynamic>{};
    final raw = document.parsedJson;
    if (raw != null && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          map = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        // נמשיך רק עם שדות מהמודל
      }
    }

    void put(String key, Object? value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      map[key] = value;
    }

    put('document_type', document.documentType);
    put('company_name', document.companyName);
    put('document_number', document.documentNumber);
    put('allocation_number', document.allocationNumber);
    put('company_id', document.companyId);
    put('date', document.documentDate);
    put('payment_due_date', document.paymentDueDate);

    if (document.subtotal != null) {
      map['subtotal'] = document.subtotal;
    }
    if (document.vatAmount != null) {
      map['vat'] = document.vatAmount;
    }
    if (document.totalAmount != null) {
      map['total'] = document.totalAmount;
    }

    map['items'] = document.items.map(_itemToExportRow).toList();
    map['items_count'] = document.items.length;

    return map;
  }

  static Map<String, dynamic> _itemToExportRow(InvoiceItem item) {
    return <String, dynamic>{
      'line_number': item.lineNumber,
      'sku': item.itemNumber ?? '',
      'description': item.description,
      'units_per_pack': item.units,
      'packs': item.packages,
      'quantity': item.quantity,
      'unit_price': item.pricePerUnit,
      'discount_percent': item.discountPercent,
      'packaging_deposit_tax': item.packagingDepositTax,
      'final_unit_price': item.finalUnitPrice,
      'line_total': item.totalPrice,
    };
  }
}
