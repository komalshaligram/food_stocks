import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ScanExportService {
  ScanExportService._();

  static Future<String?> createPdfFromImages(List<String> imagePaths) async {
    if (imagePaths.isEmpty) return null;

    try {
      final files = imagePaths
          .map(File.new)
          .where((f) => f.path.trim().isNotEmpty)
          .toList(growable: false);
      if (files.isEmpty) return null;

      final doc = pw.Document();
      var pagesAdded = 0;

      for (final file in files) {
        try {
          if (!await file.exists()) continue;
          final bytes = await file.readAsBytes();
          if (bytes.isEmpty) continue;
          final imageProvider = pw.MemoryImage(bytes);
          doc.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (_) => pw.Center(
                child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
              ),
            ),
          );
          pagesAdded++;
        } catch (e, st) {
          debugPrint('ScanExportService: skip page (bad image): $e\n$st');
        }
      }

      if (pagesAdded == 0) return null;

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/vn_scan_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final out = File(path);
      await out.writeAsBytes(await doc.save(), flush: true);
      return out.path;
    } catch (e, st) {
      debugPrint('ScanExportService.createPdfFromImages failed: $e\n$st');
      return null;
    }
  }
}
