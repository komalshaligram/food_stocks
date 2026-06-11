import 'package:flutter/services.dart';

class NativeScannerChannel {
  NativeScannerChannel._();

  static const MethodChannel _channel = MethodChannel(
    'scanner.tavili.com/native_scanner',
  );

  static Future<String?> captureDocumentPhoto() async {
    final path = await _channel.invokeMethod<String>('captureDocumentPhoto');
    if (path == null || path.trim().isEmpty) {
      return null;
    }
    return path;
  }

  static Future<List<String>> captureDocumentScan() async {
    final raw = await _channel.invokeMethod<List<dynamic>>('captureDocumentScan');
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    return raw
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }
}
