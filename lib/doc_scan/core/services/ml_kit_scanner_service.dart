import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

import '../../gen_l10n/app_localizations.dart';
import '../../gen_l10n/app_localizations_en.dart';
import '../../gen_l10n/app_localizations_he.dart';
import 'scan_result.dart';
import 'scanner_service.dart';

/// Android document scanning via Google ML Kit Document Scanner API.
class MlKitDocumentScannerService implements ScannerService {
  static String? _lastGenerateImagesError;

  String? _cachedPdfPath;
  List<String> _cachedImagePaths = const [];

  @override
  String? get lastImageExportError => _lastGenerateImagesError;

  AppLocalizations _l10n(Locale? locale) {
    return locale?.languageCode == 'he'
        ? AppLocalizationsHe('he')
        : AppLocalizationsEn('en');
  }

  @override
  Future<ScanResult> startScan({Locale? locale}) async {
    final l10n = _l10n(locale);
    if (!Platform.isAndroid) {
      return ScanResult(
        success: false,
        errorMessage: l10n.docutainScanError('ML Kit scanner is Android only'),
      );
    }

    _lastGenerateImagesError = null;
    _cachedPdfPath = null;
    _cachedImagePaths = const [];

    final scanner = DocumentScanner(
      options: DocumentScannerOptions(
        // documentFormats: const {DocumentFormat.pdf, DocumentFormat.jpeg},
        pageLimit: 20,
        mode: ScannerMode.full,
        isGalleryImport: true,
      ),
    );

    try {
      final result = await scanner.scanDocument();
      _cachedPdfPath = result.pdf?.uri;
      _cachedImagePaths = result.images ?? const [];

      if ((_cachedPdfPath == null || _cachedPdfPath!.isEmpty) &&
          _cachedImagePaths.isEmpty) {
        return ScanResult(
          success: false,
          errorMessage: l10n.docutainScanCancelledError,
        );
      }

      return const ScanResult(success: true);
    } on PlatformException catch (e) {
      if (e.message == 'Operation cancelled') {
        return ScanResult(
          success: false,
          errorMessage: l10n.docutainScanCancelledError,
        );
      }
      return ScanResult(
        success: false,
        errorMessage: l10n.docutainScanError(e.message ?? e.code),
      );
    } catch (e) {
      return ScanResult(
        success: false,
        errorMessage: l10n.docutainScanError(e.toString()),
      );
    } finally {
      await scanner.close();
    }
  }

  @override
  Future<File?> generatePdf(String outputPath) async {
    final path = _cachedPdfPath;
    if (path == null || path.isEmpty) return null;
    final file = File(path);
    return file.existsSync() ? file : null;
  }

  @override
  Future<List<File>?> generateImages(String outputPath) async {
    _lastGenerateImagesError = null;
    if (_cachedImagePaths.isEmpty) {
      return const [];
    }

    final files = <File>[];
    for (final path in _cachedImagePaths) {
      final file = File(path);
      if (file.existsSync()) {
        files.add(file);
      }
    }

    if (files.isEmpty) {
      _lastGenerateImagesError = 'Scanned image files were not found on disk';
      return const [];
    }

    return files;
  }
}
