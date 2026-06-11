import 'dart:io';

import 'package:flutter/material.dart';

import 'scan_result.dart';

/// ממשק שירות הסריקה – ML Kit (Android) / VisionKit (iOS) / Mock.
abstract class ScannerService {
  /// שגיאת ייצוא תמונות אחרונה (אם הייתה).
  String? get lastImageExportError;

  /// התחלת סריקה – מחזיר תוצאה (הצלחה/כישלון ונתיב PDF אם רלוונטי).
  /// [locale] – אם מועבר, משמש להתאמת טקסטים בממשק הסורק (למשל עברית).
  Future<ScanResult> startScan({Locale? locale});

  /// יצירת קובץ PDF בנתיב נתון – מחזיר את הקובץ או null.
  Future<File?> generatePdf(String outputPath);

  /// יצוא תמונות מקוריות לכל עמוד.
  /// מוחזר כ-list של קבצים, או null/empty אם לא ניתן לייצא.
  Future<List<File>?> generateImages(String outputPath);
}
