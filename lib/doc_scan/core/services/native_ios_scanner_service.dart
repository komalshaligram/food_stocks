import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../gen_l10n/app_localizations.dart';
import '../../gen_l10n/app_localizations_en.dart';
import '../../gen_l10n/app_localizations_he.dart';
import '../platform/native_scanner_channel.dart';
import 'scan_export_service.dart';
import 'scan_result.dart';
import 'scanner_service.dart';

/// iOS document scanning via Apple VisionKit (VNDocumentCameraViewController).
class NativeIosScannerService implements ScannerService {
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
    if (!Platform.isIOS) {
      return ScanResult(
        success: false,
        errorMessage: l10n.docutainScanError('VisionKit scanner is iOS only'),
      );
    }

    _lastGenerateImagesError = null;
    _cachedPdfPath = null;
    _cachedImagePaths = const [];

    try {
      final imagePaths = await _captureDocumentScan();
      if (imagePaths.isEmpty) {
        return ScanResult(
          success: false,
          errorMessage: l10n.docutainScanCancelledError,
        );
      }

      _cachedImagePaths = imagePaths;
      _cachedPdfPath = await ScanExportService.createPdfFromImages(imagePaths);
      if (_cachedPdfPath == null || _cachedPdfPath!.isEmpty) {
        _lastGenerateImagesError = 'Could not create PDF from scanned images';
      }

      return const ScanResult(success: true);
    } on PlatformException catch (e) {
      return ScanResult(
        success: false,
        errorMessage: l10n.docutainScanError(e.message ?? e.code),
      );
    } catch (e) {
      return ScanResult(
        success: false,
        errorMessage: l10n.docutainScanError(e.toString()),
      );
    }
  }

  Future<List<String>> _captureDocumentScan() async {
    try {
      return await NativeScannerChannel.captureDocumentScan();
    } on MissingPluginException {
      return const [];
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
