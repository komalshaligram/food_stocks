import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/ml_kit_scanner_service.dart';
import '../core/services/mock_scanner_service.dart';
import '../core/services/native_ios_scanner_service.dart';
import '../core/services/scanner_service.dart';

/// Scan service – ML Kit on Android, VisionKit on iOS, mock elsewhere.
final scannerProvider = Provider<ScannerService>((ref) {
  if (Platform.isAndroid) {
    return MlKitDocumentScannerService();
  }
  if (Platform.isIOS) {
    return NativeIosScannerService();
  }
  return MockScannerService();
});

@Deprecated('Use scannerProvider instead')
final scannerServiceProvider = scannerProvider;
