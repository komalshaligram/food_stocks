/// קבועים גלובליים: נתיבי ניווט. טקסטים להצגה ב־gen_l10n (AppLocalizations).
class AppConstants {
  AppConstants._();

  static const String routeSplash = '/';
  static const String routeHome = '/home';
  static const String routeScan = '/scan';
  static const String routeProcessing = '/processing';
  static const String routeDetails = '/details';
  static const String routePdfPreview = '/pdf_preview';
  static const String routeExcelPreview = '/excel_preview';
  static const String routeImagesPreview = '/images_preview';
  static const String routeJsonPreview = '/json_preview';

  /// Maximum pages per scanned document (camera / gallery).
  static const int maxScanPages = 20;

  /// Placeholder for empty document fields (em dash, unicode escape avoids file encoding issues).
  static const String emptyFieldPlaceholder = '\u2014';
}
