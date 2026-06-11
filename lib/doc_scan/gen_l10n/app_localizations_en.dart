// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Invoice Scanner';

  @override
  String get searchHint => 'Search by document type or company name';

  @override
  String get sortAndFilter => 'Sort & Filter';

  @override
  String get sortBy => 'Sort by';

  @override
  String get filterBy => 'Filter by';

  @override
  String get clearSortAndFilter => 'Clear sort and filter';

  @override
  String get close => 'Close';

  @override
  String get emptyTitle => 'No scanned documents';

  @override
  String get emptySubtitle => 'Tap the button below to scan an invoice';

  @override
  String get scanInvoice => 'Scan document';

  @override
  String get chooseScanModelTitle => 'Choose scan model';

  @override
  String get deleteDocumentTitle => 'Delete document';

  @override
  String get deleteDocumentConfirm =>
      'Are you sure you want to delete this document?';

  @override
  String get documentDeletedSuccess => 'Document deleted successfully';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get filterDate => 'Date';

  @override
  String get filterCompanyName => 'Company name';

  @override
  String get filterAmount => 'Amount';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterCreatedDate => 'Created date';

  @override
  String get filterDocumentDate => 'Document date';

  @override
  String get filterDocumentType => 'Document type';

  @override
  String get scan => 'Scan';

  @override
  String get scanPlaceholder => 'Place the invoice in the frame';

  @override
  String get scanMockHint => 'Or tap for mock scan';

  @override
  String get scanButton => 'Scan';

  @override
  String get pageScanned => 'Page scanned';

  @override
  String get previewPlaceholder => 'Page preview';

  @override
  String get send => 'Send';

  @override
  String get processingTitle => 'Scanning document data...';

  @override
  String get processingSub1 => 'Detecting text...';

  @override
  String get processingSub2 => 'Analyzing data...';

  @override
  String get processingSub3 => 'Extracting details...';

  @override
  String get processingSub4 => 'Almost done...';

  @override
  String get documentDetails => 'Document details';

  @override
  String get noDocumentSelected => 'No document selected';

  @override
  String scanDateLabel(String formatted) {
    return 'Scanned: $formatted';
  }

  @override
  String get showScanDocument => 'Show scan document';

  @override
  String get exportToExcel => 'Export to Excel';

  @override
  String get exportExcelFailed =>
      'Could not export to Excel. Check that the document data is valid.';

  @override
  String get save => 'Save';

  @override
  String get updateInCash => 'Send to cash register';

  @override
  String get generalData => 'General data';

  @override
  String get documentType => 'Document type';

  @override
  String get companyName => 'Company name';

  @override
  String get companyId => 'Company ID';

  @override
  String get documentNumber => 'Document number';

  @override
  String get documentDate => 'Document date';

  @override
  String get subtotalNoVat => 'Subtotal (excl. VAT)';

  @override
  String get vatAmount => 'VAT amount';

  @override
  String get totalToPay => 'Total to pay';

  @override
  String get items => 'Items';

  @override
  String get addItem => 'Add item';

  @override
  String get searchItemHint => 'Search item by description or item number';

  @override
  String get colLineNumber => '#';

  @override
  String get colItemNumber => 'Item no.';

  @override
  String get colItemDescription => 'Description';

  @override
  String get colQuantity => 'Qty';

  @override
  String get colPackages => 'Packages';

  @override
  String get colUnits => 'Units in package';

  @override
  String get colPricePerUnit => 'Price per unit';

  @override
  String get colTotalNis => 'Total (NIS)';

  @override
  String get deleteRowTitle => 'Delete row';

  @override
  String get deleteRowConfirm => 'Are you sure you want to delete this row?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get update => 'Update';

  @override
  String get docTypeInvoice => 'Invoice';

  @override
  String get docTypeDelivery => 'Delivery note';

  @override
  String get docTypeReturn => 'Return note';

  @override
  String get docTypeOther => 'Other';

  @override
  String get chooseDocumentType => 'Choose document type';

  @override
  String get enterDocumentType => 'Enter document type';

  @override
  String get documentTypeLabel => 'Document type';

  @override
  String get pickDocumentDate => 'Pick document date';

  @override
  String get excelPreviewTitle => 'Excel preview';

  @override
  String get excelShareText => 'Excel spreadsheet';

  @override
  String get pdfPreviewTitle => 'PDF Preview';

  @override
  String get pdfAvailable => 'PDF available for viewing';

  @override
  String get pdfDemoHint => 'Preview in demo mode';

  @override
  String get share => 'Share';

  @override
  String get statusScanning => 'Scanning document data';

  @override
  String get statusUploading => 'Uploading documents';

  @override
  String get statusReadyForUpdate => 'Waiting to send to cash register';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusDeleted => 'Deleted';

  @override
  String get statusSentToCashRegister => 'Sent to cash register';

  @override
  String get docNumberLabel => 'Doc. number';

  @override
  String docNumberValue(String num) {
    return 'Doc. number: $num';
  }

  @override
  String dateLabel(String date) {
    return 'Date: $date';
  }

  @override
  String get itemNumber => 'Item no.';

  @override
  String get itemDescription => 'Description';

  @override
  String get quantity => 'Quantity';

  @override
  String get packages => 'Packages';

  @override
  String get units => 'Units';

  @override
  String get pricePerUnitNis => 'Price per unit (NIS)';

  @override
  String get totalNis => 'Total (NIS)';

  @override
  String get preScanDocumentDetailsTitle => 'Document details before scan';

  @override
  String get supplierNameLabel => 'Supplier name';

  @override
  String get supplierNameHint => 'Type supplier name (or pick from the list)';

  @override
  String get supplierQuickTip => 'Tip: type to quickly filter';

  @override
  String get supplierListTitle => 'Suppliers list';

  @override
  String get continueToScan => 'Continue to scan';

  @override
  String get pickSupplierTitle => 'Pick a supplier';

  @override
  String get supplierSearchHint => 'Search supplier...';

  @override
  String get supplierSearchPlaceholder => 'Search...';

  @override
  String suppliersFoundCount(Object count) {
    return 'Found $count suppliers';
  }

  @override
  String get noResults => 'No results found';

  @override
  String get noSavedSuppliers => 'No saved suppliers';

  @override
  String get select => 'Select';

  @override
  String get clear => 'Clear';

  @override
  String get unknownSupplierInitial => 'S';

  @override
  String get sortTileTitle => 'Sort';

  @override
  String get sortNone => 'No sorting';

  @override
  String get sortByCreatedAtOldest => 'Date: oldest first';

  @override
  String get sortByCreatedAtNewest => 'Date: newest first';

  @override
  String get sortByTotalAmountLow => 'Amount: low first';

  @override
  String get sortByTotalAmountHigh => 'Amount: high first';

  @override
  String get helpTextChooseRange => 'Choose range';

  @override
  String get rangeNoneLabel => 'None';

  @override
  String filterCreatedDatePreview(Object range) {
    return 'Created date: $range';
  }

  @override
  String filterDocumentDatePreview(Object range) {
    return 'Document date: $range';
  }

  @override
  String filterDocumentTypePreview(Object types) {
    return 'Document type: $types';
  }

  @override
  String filterSupplierPreview(Object suppliers) {
    return 'Supplier name: $suppliers';
  }

  @override
  String filterStatusPreview(Object statuses) {
    return 'Status: $statuses';
  }

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusError => 'Error';

  @override
  String get documentProcessing => 'The document is still processing';

  @override
  String get noImagesForRetry => 'No images available for retry';

  @override
  String get showScannedImage => 'Show scanned image';

  @override
  String get retrieveDataAgain => 'Retrieve data again';

  @override
  String get confirmRetrieveDataAgainTitle => 'Confirm';

  @override
  String get confirmRetrieveDataAgainMessage =>
      'Are you sure you want to retrieve the document data again?\nThis may take some time...';

  @override
  String get confirmSendToCashTitle => 'Confirm';

  @override
  String get confirmSendToCashMessage =>
      'Are you sure you want to send the document for updating your cash register?';

  @override
  String get imageExportFailureTitle => 'Image export error';

  @override
  String get copyTooltip => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get continueButton => 'Continue';

  @override
  String get imageExportDebugIntro =>
      'We couldn\'t export images from the scan. We won\'t send the PDF to the API.';

  @override
  String imageExportErrorLine(Object error) {
    return 'Error: $error';
  }

  @override
  String imageExportExpectedImages(Object count) {
    return 'Expected images: $count';
  }

  @override
  String imageExportExistingImages(Object count) {
    return 'Existing images: $count';
  }

  @override
  String imageExportPdfPath(Object path) {
    return 'pdfPath: $path';
  }

  @override
  String get imageExportFailedNull => 'Failed to export images (null)';

  @override
  String get imageExportReturnedEmpty =>
      'Image export returned an empty list (no valid images)';

  @override
  String imageExportPathExamples(Object paths) {
    return 'Examples of paths (up to 10):\n$paths';
  }

  @override
  String serverError(Object error) {
    return 'Server error: $error';
  }

  @override
  String unexpectedError(Object error) {
    return 'Unexpected error: $error';
  }

  @override
  String get noValidImagesToSend => 'No valid images found for sending';

  @override
  String get jsonTitle => 'JSON';

  @override
  String get jsonContentLabel => 'JSON content';

  @override
  String get jsonCopiedSnackBar => 'JSON copied';

  @override
  String get noJsonToShow => 'No JSON to display';

  @override
  String get copy => 'Copy';

  @override
  String get shareScannedDocument => 'Scanned document';

  @override
  String get fileNotFound => 'File not found';

  @override
  String shareError(Object error) {
    return 'Share error: $error';
  }

  @override
  String get unableToLoadDocument => 'Unable to load the document';

  @override
  String get scannedImagesPreviewTitle => 'Scanned images preview';

  @override
  String get scannedImagesShareText => 'Scanned images';

  @override
  String get unableToLoadImages => 'Unable to load images';

  @override
  String get noImagesToShow => 'No images to display';

  @override
  String get docTypeReceipt => 'Receipt';

  @override
  String get docTypeCreditInvoice => 'Credit invoice';

  @override
  String get languageEnglishOptionLabel => 'EN';

  @override
  String get languageHebrewOptionLabel => 'HE';

  @override
  String parseErrorImageTooLarge(Object maxMB, Object sizeMB) {
    return 'Image is too large (${sizeMB}MB). Max ${maxMB}MB.';
  }

  @override
  String get parseErrorImagesNotReceived => 'No images received';

  @override
  String parseErrorPdfTooLarge(Object maxMB, Object sizeMB) {
    return 'File is too large (${sizeMB}MB). Max ${maxMB}MB.';
  }

  @override
  String get parseErrorScanJobEmptyResponse =>
      'Error creating scan job: empty response';

  @override
  String get parseErrorScanJobMissingJobId =>
      'Error creating scan job: missing jobId';

  @override
  String get parseErrorDocumentProcessingEmptyResponse =>
      'Error processing document: empty response';

  @override
  String get parseErrorUnauthenticated =>
      'Please sign in before sending documents';

  @override
  String get parseErrorInvalidArgument => 'Invalid file';

  @override
  String get parseErrorResourceExhausted =>
      'Too many requests. Please try again in a minute';

  @override
  String get parseErrorInternal => 'Error processing document';

  @override
  String parseErrorUnknown(Object code) {
    return 'Error ($code)';
  }

  @override
  String get docutainScanTitleScanPage => 'Scan doc';

  @override
  String get docutainScanFocusHint => 'Please hold steady';

  @override
  String get docutainButtonScanTorchTitle => 'Flash';

  @override
  String get docutainButtonScanFinishTitle => 'Continue';

  @override
  String get docutainButtonScanAutoCaptureOnTitle => 'Auto scan';

  @override
  String get docutainButtonScanAutoCaptureOffTitle => 'Manual scan';

  @override
  String get docutainButtonEditDeleteTitle => 'Delete';

  @override
  String get docutainButtonEditFinishTitle => 'Finish';

  @override
  String get docutainButtonEditCropTitle => 'Crop';

  @override
  String get docutainButtonEditRotateTitle => 'Rotate';

  @override
  String get docutainButtonEditArrangeTitle => 'Arrange';

  @override
  String get docutainTextTitleArrangementPage => 'Arrange';

  @override
  String get docutainTextDeleteDialogCurrentPage => 'Delete current page';

  @override
  String get docutainTextDeleteDialogAllPages => 'Delete all pages';

  @override
  String get docutainTextDeleteDialogCancel => 'Cancel';

  @override
  String get docutainScanCancelledError => 'Scan was cancelled.';

  @override
  String docutainScanError(Object error) {
    return 'Scan error: $error';
  }

  @override
  String get docutainInitLicenseKeyMissing =>
      'Docutain license key is not configured. Add it in app_config.dart (defaultValue) or run with: --dart-define=DOCUTAIN_LICENSE_KEY=YOUR_KEY';

  @override
  String docutainInitFailedWithSdkError(Object sdkError) {
    return 'Docutain initialization failed: $sdkError\n\nThe license is tied to the application\'s applicationId. In this app: scanner.tavili.com. Get a trial license with this ID: https://sdk.docutain.com/TrialLicense';
  }

  @override
  String get docutainInitFailedWithoutSdkError =>
      'Docutain initialization failed. The license is tied to the application\'s applicationId. In this app: scanner.tavili.com. Get a trial license with this ID: https://sdk.docutain.com/TrialLicense';

  @override
  String get scanSourceTitle => 'How would you like to capture the document?';

  @override
  String get scanSourceCamera => 'Camera';

  @override
  String get scanSourceGallery => 'Gallery';

  @override
  String get scanAddAnotherPageTitle => 'Add another page';

  @override
  String scanAddAnotherPageMessage(int count) {
    return 'You captured $count page(s). Add another page?';
  }

  @override
  String get scanFinishCapture => 'Finish';

  @override
  String get scanAddPage => 'Capture another page';

  @override
  String get scanCropPageTitle => 'Edit page';

  @override
  String scanCropPageCounter(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String scanMaxPagesReached(int max) {
    return 'Maximum of $max pages reached';
  }

  @override
  String get scanPermissionDenied => 'Camera or gallery permission is required';

  @override
  String get scanNoImagesSelected => 'No images selected';
}
