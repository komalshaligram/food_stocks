import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../models/invoice_document.dart';

const String _kDocumentsFileName = 'scanned_documents.json';

/// שמירה וטעינה של רשימת המסמכים הסרוקים מהאחסון המקומי.
class DocumentsStorage {
  DocumentsStorage._();

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_kDocumentsFileName');
  }

  /// טוען את רשימת המסמכים מהאחסון. מחזיר רשימה ריקה אם הקובץ לא קיים או לא תקין.
  static Future<List<InvoiceDocument>> load() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final list = jsonDecode(content) as List<dynamic>;
      return list
          .map((e) => InvoiceDocument.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// שומר את רשימת המסמכים לאחסון.
  static Future<void> save(List<InvoiceDocument> documents) async {
    try {
      final file = await _getFile();
      final list = documents.map((e) => e.toJson()).toList();
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(list),
        flush: true,
      );
    } catch (_) {
      // נכשל בשמירה – הרשימה בזיכרון עדיין מעודכנת
    }
  }
}
