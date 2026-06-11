import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'scan_result.dart';
import 'scanner_service.dart';

/// מימוש דמה של שירות הסריקה – ברירת המחדל. האפליקציה פועלת בלעדיו ללא SDK.
class MockScannerService implements ScannerService {
  @override
  String? get lastImageExportError => null;

  @override
  Future<ScanResult> startScan({Locale? locale}) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return const ScanResult(success: true);
  }

  @override
  Future<File?> generatePdf(String outputPath) async {
    try {
      String basePath = outputPath;
      if (basePath.isEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        basePath = dir.path;
      }
      final file = File(
        '$basePath/mock_scan_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      // PDF מינימלי כדי לעבור ולידציה בצד השרת.
      const pdfBytes = '''
%PDF-1.4
1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj
2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj
3 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 612 792]>>endobj
xref
0 4
0000000000 65535 f 
0000000009 00000 n 
0000000052 00000 n 
0000000101 00000 n 
trailer<</Size 4/Root 1 0 R>>
startxref
178
%%EOF
''';
      await file.writeAsString(pdfBytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<File>?> generateImages(String outputPath) async {
    // במצב Mock אין לייצא תמונות אמיתיות.
    // ה-flow החדש יוכל ליפול ל-PDF אם לא קיימות תמונות.
    return const [];
  }
}
