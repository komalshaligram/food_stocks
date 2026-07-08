import 'dart:convert';
import 'dart:io';

import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/invoice_document.dart';

/// שמירה וטעינה של רשימת המסמכים הסרוקים מהאחסון המקומי.
///
/// המטמון **מסונן לפי לקוח** — לכל לקוח (clientId המחובר) קובץ נפרד — כדי שמסמכים
/// של משתמש אחד לא ידלפו למשתמש אחר על אותו מכשיר. ה-backend נשאר מקור האמת:
/// המטמון רק מאיץ תצוגה offline-first עד שה-fetchAll/sync חוזרים.
class DocumentsStorage {
  DocumentsStorage._();

  static const String _filePrefix = 'scanned_documents_';

  /// קובץ ה-legacy הישן (לא מסונן לפי לקוח) — מקור הדליפה בין משתמשים; נמחק חד-פעמית.
  static const String _legacyFileName = 'scanned_documents.json';

  /// ה-clientId המחובר (= ה-customerCode) או 'anon' כשלא מחובר.
  static Future<String> _currentClientId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = SharedPreferencesHelper(prefs: prefs).getUserId().trim();
    return id.isEmpty ? 'anon' : id;
  }

  static Future<File> _fileFor(String clientId) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_filePrefix$clientId.json');
  }

  static Future<void> _deleteLegacyFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final legacy = File('${dir.path}/$_legacyFileName');
      if (await legacy.exists()) await legacy.delete();
    } catch (_) {
      // best-effort
    }
  }

  /// טוען את רשימת המסמכים של הלקוח הנוכחי. מחזיר רשימה ריקה אם אין קובץ / לא תקין.
  static Future<List<InvoiceDocument>> load() async {
    try {
      // ניקוי חד-פעמי של הקובץ הישן הלא-מסונן (מונע הצגת מסמכים של משתמש קודם).
      await _deleteLegacyFile();
      final file = await _fileFor(await _currentClientId());
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

  /// שומר את רשימת המסמכים לאחסון של הלקוח הנוכחי.
  static Future<void> save(List<InvoiceDocument> documents) async {
    try {
      final file = await _fileFor(await _currentClientId());
      final list = documents.map((e) => e.toJson()).toList();
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(list),
        flush: true,
      );
    } catch (_) {
      // נכשל בשמירה – הרשימה בזיכרון עדיין מעודכנת
    }
  }

  /// (א) ניקוי המטמון של הלקוח הנוכחי — נקרא ב-logout (פרטיות + רעננות במכשיר משותף).
  static Future<void> clearForCurrentClient() async {
    try {
      final file = await _fileFor(await _currentClientId());
      if (await file.exists()) await file.delete();
    } catch (_) {
      // best-effort
    }
  }
}
