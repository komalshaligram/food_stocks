/// תוצאת סריקה – מוחזר מ־ScannerService.startScan().
class ScanResult {
  const ScanResult({
    required this.success,
    this.pdfPath,
    this.errorMessage,
  });

  final bool success;
  final String? pdfPath;
  final String? errorMessage;
}
