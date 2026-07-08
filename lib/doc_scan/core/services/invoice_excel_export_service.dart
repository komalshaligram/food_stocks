import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Builds an `.xlsx` from [invoice-sample.json]-shaped data using the bundled
/// template (same layout/styles as [invoice-sample.xlsx]).
///
/// The template was patched once: Excel had `numFmtId="44"` under custom
/// `numFmts`, which the `excel` package rejects (expects custom ids ≥ 164).
class InvoiceExcelExportService {
  static const String _assetPath =
      'assets/templates/invoice_export_template.xlsx';

  /// Template has 24 preallocated item rows (Excel rows 20–43 → 0-based 19–42).
  static const int _firstItemRowIndex = 19;
  static const int _templateItemRowCount = 24;
  static const int _lastTemplateItemRowIndex =
      _firstItemRowIndex + _templateItemRowCount - 1;

  /// First row index after the template item block (Excel row 44).
  static const int _insertExtraItemsAtRowIndex = 43;

  /// Item header row (Excel row 19 → 0-based 18), where column titles live.
  static const int _itemHeaderRowIndex = _firstItemRowIndex - 1;

  /// Extra item columns appended after the template's A–H (§12):
  /// I = discount %, J = packaging/tax/deposit, K = final unit price (read-only).
  static const int _discountColIndex = 8;
  static const int _packagingColIndex = 9;
  static const int _finalUnitPriceColIndex = 10;

  /// Empty template row used for the allocation number (Excel row 11 → 0-based 10).
  static const int _allocationRowIndex = 10;

  Future<Uint8List> buildFromParsedJsonString(String jsonString) async {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object at root');
    }
    return buildFromMap(decoded);
  }

  Future<Uint8List> buildFromMap(Map<String, dynamic> data) async {
    final template = await rootBundle.load(_assetPath);
    final bytes = template.buffer.asUint8List();
    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) {
      throw StateError('Excel template has no sheets');
    }
    final sheet = excel.tables[excel.tables.keys.first]!;

    _writeHeaderBlock(sheet, data);
    _writeHeaderLabels(sheet);
    _writeAllocationNumber(sheet, data);
    _writeTotalsBlock(sheet, data);

    final items = _readItems(data);
    _writeItemRows(sheet, items);

    _stripBoldRichTextAndBorders(sheet);

    return Uint8List.fromList(excel.encode()!);
  }

  /// Template cells use bold + borders; user wants plain text and no borders.
  void _stripBoldRichTextAndBorders(Sheet sheet) {
    final rows = sheet.rows;
    for (final row in rows) {
      for (final data in row) {
        if (data == null) continue;
        var v = data.value;
        if (v is TextCellValue) {
          v = TextCellValue(v.value.toString());
          data.value = v;
        }
        data.cellStyle = CellStyle(
          bold: false,
          italic: false,
          numberFormat: NumFormat.defaultFor(v),
          leftBorder: Border(),
          rightBorder: Border(),
          topBorder: Border(),
          bottomBorder: Border(),
          diagonalBorder: Border(),
        );
      }
    }
  }

  void _writeHeaderLabels(Sheet sheet) {
    // Column A labels (template row indices 0–9). Ensures correct Hebrew even if
    // the bundled xlsx template has typos.
    const labels = <String>[
      'סוג מסמך',
      'שם חברה',
      'מספר מסמך',
      'ח.פ. חברה',
      'תאריך מסמך',
      'שעת מסמך',
      'תאריך לתשלום',
      'מספר לקוח',
      'שם סוכן',
      'סה"כ שורות',
    ];
    for (var i = 0; i < labels.length; i++) {
      _setCellText(sheet, 0, i, labels[i]);
    }
  }

  /// מספר הקצאה אינו בתבנית — נכתב בשורה הריקה 11 (תווית A11, ערך B11) אם קיים.
  void _writeAllocationNumber(Sheet sheet, Map<String, dynamic> data) {
    final value = _stringify(data['allocation_number']);
    if (value.trim().isEmpty) return;
    _setCellText(sheet, 0, _allocationRowIndex, 'מספר הקצאה');
    _setCellText(sheet, 1, _allocationRowIndex, value);
  }

  void _writeHeaderBlock(Sheet sheet, Map<String, dynamic> data) {
    // B1–B10 → row indices 0–9, column index 1
    final pairs = <String>[
      'document_type',
      'company_name',
      'document_number',
      'company_id',
      'date',
      'time',
      'payment_due_date',
      'customer_number',
      'agent_name',
      'items_count',
    ];
    for (var i = 0; i < pairs.length; i++) {
      _setCellText(
        sheet,
        1,
        i,
        _stringify(data[pairs[i]]),
      );
    }
  }

  void _writeTotalsBlock(Sheet sheet, Map<String, dynamic> data) {
    // B12–B16 → row indices 11–15, column 1
    final keys = <String>[
      'subtotal',
      'discount',
      'subtotal_after_discount',
      'vat',
      'total',
    ];
    for (var i = 0; i < keys.length; i++) {
      _setCellNumber(sheet, 1, 11 + i, _toDouble(data[keys[i]]));
    }
  }

  List<Map<String, dynamic>> _readItems(Map<String, dynamic> data) {
    final raw = data['items'];
    if (raw is! List) return const [];
    return raw
        .whereType<Object?>()
        .map((e) => e is Map<String, dynamic>
            ? e
            : Map<String, dynamic>.from(e as Map))
        .toList();
  }

  void _writeItemRows(Sheet sheet, List<Map<String, dynamic>> items) {
    final n = items.length;

    // §12: העמודות הנוספות אינן בתבנית — כותבים כותרות (I/J/K) בשורת כותרות הפריטים.
    _setCellText(sheet, _discountColIndex, _itemHeaderRowIndex, 'אחוז הנחה');
    _setCellText(sheet, _packagingColIndex, _itemHeaderRowIndex, 'אריזה/מס/פיקדון');
    _setCellText(
        sheet, _finalUnitPriceColIndex, _itemHeaderRowIndex, 'מחיר ליח\' סופי');

    // Fill up to 24 rows in the template range.
    final fillCount = n < _templateItemRowCount ? n : _templateItemRowCount;
    for (var i = 0; i < fillCount; i++) {
      _writeOneItemRow(sheet, _firstItemRowIndex + i, items[i]);
    }

    // Extra rows beyond the template: insert after row 43 (0-based 42) repeatedly.
    if (n > _templateItemRowCount) {
      var insertAt = _insertExtraItemsAtRowIndex;
      for (var i = _templateItemRowCount; i < n; i++) {
        sheet.insertRow(insertAt);
        _writeOneItemRow(sheet, insertAt, items[i]);
        insertAt++;
      }
    } else {
      // Clear leftover template rows so old demo data never remains.
      for (var r = _firstItemRowIndex + n;
          r <= _lastTemplateItemRowIndex;
          r++) {
        _clearItemRow(sheet, r);
      }
    }
  }

  void _writeOneItemRow(
    Sheet sheet,
    int rowIndex,
    Map<String, dynamic> item,
  ) {
    // A–H : line, sku, description, units_per_pack, packs, qty, unit_price, line_total
    _setCellNumber(sheet, 0, rowIndex, _toDouble(item['line_number']));
    _setCellText(sheet, 1, rowIndex, _stringify(item['sku']));
    _setCellText(sheet, 2, rowIndex, _stringify(item['description']));
    _setCellNumber(sheet, 3, rowIndex, _toDouble(item['units_per_pack']));
    _setCellNumber(sheet, 4, rowIndex, _toDouble(item['packs']));
    _setCellNumber(sheet, 5, rowIndex, _toDouble(item['quantity']));
    _setCellNumber(sheet, 6, rowIndex, _toDouble(item['unit_price']));
    _setCellNumber(sheet, 7, rowIndex, _toDouble(item['line_total']));
    // §12: עמודות נוספות I/J/K — ריקות כשאין נתון.
    _setCellNumber(
        sheet, _discountColIndex, rowIndex, _toDouble(item['discount_percent']));
    _setCellNumber(sheet, _packagingColIndex, rowIndex,
        _toDouble(item['packaging_deposit_tax']));
    _setCellNumber(sheet, _finalUnitPriceColIndex, rowIndex,
        _toDouble(item['final_unit_price']));
  }

  void _clearItemRow(Sheet sheet, int rowIndex) {
    for (var c = 0; c <= _finalUnitPriceColIndex; c++) {
      sheet.updateCell(
        CellIndex.indexByColumnRow(columnIndex: c, rowIndex: rowIndex),
        TextCellValue(''),
      );
    }
  }

  void _setCellText(Sheet sheet, int colIndex, int rowIndex, String text) {
    sheet.updateCell(
      CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
      TextCellValue(text),
    );
  }

  void _setCellNumber(Sheet sheet, int colIndex, int rowIndex, double? value) {
    if (value == null) {
      _setCellText(sheet, colIndex, rowIndex, '');
      return;
    }
    final v = value;
    if (v == v.roundToDouble() && v.abs() < 1e12) {
      sheet.updateCell(
        CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
        IntCellValue(v.round()),
      );
    } else {
      sheet.updateCell(
        CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
        DoubleCellValue(v),
      );
    }
  }

  String _stringify(Object? value) {
    if (value == null) return '';
    return value.toString();
  }

  double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final t = value.trim();
      if (t.isEmpty) return null;
      return double.tryParse(t.replaceAll(',', ''));
    }
    return null;
  }
}
