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
  String get deleteDocumentConfirm => 'Are you sure you want to delete this document?';

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
  String get exportExcelFailed => 'Could not export to Excel. Check that the document data is valid.';

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
  String get docTypeTaxInvoice => 'Tax/entry invoice';

  @override
  String get docTypeReturnInvoice => 'Return invoice';

  @override
  String get docTypeEntryCertificate => 'Entry certificate';

  @override
  String get docTypeReturnCertificate => 'Return certificate';

  @override
  String get docTypeInactiveSuffix => 'not active yet';

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
  String get statusCompleted => 'Saved – not sent to cash register';

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
  String get confirmRetrieveDataAgainMessage => 'Are you sure you want to retrieve the document data again?\nThis may take some time...';

  @override
  String get confirmSendToCashTitle => 'Confirm';

  @override
  String get confirmSendToCashMessage => 'Are you sure you want to send the document for updating your cash register?';

  @override
  String get imageExportFailureTitle => 'Image export error';

  @override
  String get copyTooltip => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get continueButton => 'Continue';

  @override
  String get imageExportDebugIntro => 'We couldn\'t export images from the scan. We won\'t send the PDF to the API.';

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
  String get imageExportReturnedEmpty => 'Image export returned an empty list (no valid images)';

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
  String get parseErrorScanJobEmptyResponse => 'Error creating scan job: empty response';

  @override
  String get parseErrorScanJobMissingJobId => 'Error creating scan job: missing jobId';

  @override
  String get parseErrorDocumentProcessingEmptyResponse => 'Error processing document: empty response';

  @override
  String get parseErrorUnauthenticated => 'Please sign in before sending documents';

  @override
  String get parseErrorInvalidArgument => 'Invalid file';

  @override
  String get parseErrorResourceExhausted => 'Too many requests. Please try again in a minute';

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
  String get docutainInitLicenseKeyMissing => 'Docutain license key is not configured. Add it in app_config.dart (defaultValue) or run with: --dart-define=DOCUTAIN_LICENSE_KEY=YOUR_KEY';

  @override
  String docutainInitFailedWithSdkError(Object sdkError) {
    return 'Docutain initialization failed: $sdkError\n\nThe license is tied to the application\'s applicationId. In this app: scanner.tavili.com. Get a trial license with this ID: https://sdk.docutain.com/TrialLicense';
  }

  @override
  String get docutainInitFailedWithoutSdkError => 'Docutain initialization failed. The license is tied to the application\'s applicationId. In this app: scanner.tavili.com. Get a trial license with this ID: https://sdk.docutain.com/TrialLicense';

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

  @override
  String get scanDocumentSdk => 'Scan document SDK';

  @override
  String get scanDocumentFlutter => 'Scan document Flutter';

  @override
  String get scanDocumentNative => 'Scan document Native';

  @override
  String get manualScannerSelectScanTrack => 'Choose scan track';

  @override
  String get manualScannerAddPage => 'Add page';

  @override
  String get manualScannerFinishScan => 'Finish scan';

  @override
  String get manualScannerApplyFilter => 'Apply B/W filter';

  @override
  String get manualScannerFilterBw => 'B/W document';

  @override
  String get manualScannerFilterGrayscale => 'Grayscale';

  @override
  String get manualScannerFilterContrast => 'High contrast';

  @override
  String get manualScannerFilterThreshold => 'Threshold B/W';

  @override
  String get manualScannerFilterCleanDocument => 'Clean document';

  @override
  String get supplierNameField => 'Supplier name';

  @override
  String get allocationNumber => 'Allocation number';

  @override
  String get paymentDueDate => 'Payment due date';

  @override
  String get colDiscountPercent => 'Discount %';

  @override
  String get colPackagingDepositTax => 'Pkg/Tax/Deposit';

  @override
  String get colFinalUnitPrice => 'Final unit price';

  @override
  String get loadingSuppliers => 'Loading suppliers…';

  @override
  String get suppliersLoadError => 'Failed to load suppliers';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get runSyncButton => 'Sync';

  @override
  String get syncConfirmTitle => 'Run Comax sync';

  @override
  String get syncConfirmMessage => 'The sync connects to your Comax and pulls all the data again (suppliers, products, prices and promotions).\n\nFor it to succeed you must be logged out of your Comax user — Comax allows only a single session. Log out of Comax first, then continue.';

  @override
  String get syncConfirmContinue => 'I\'m logged out — run sync';

  @override
  String get syncing => 'Syncing...';

  @override
  String get syncDone => 'Synced successfully';

  @override
  String get syncDoneMessage => 'Supplier and product data were updated from Comax.';

  @override
  String get syncErrorTitle => 'Sync error';

  @override
  String get syncSessionInUse => 'A user is logged into Comax. Log out of Comax, wait ~3 minutes, and try again.';

  @override
  String get syncBadCredentials => 'Permissions need updating in the admin system.';

  @override
  String get syncFailed => 'Sync failed, try again later.';

  @override
  String get syncRateLimited => 'Try again in a minute.';

  @override
  String get syncNoPermission => 'The API key lacks permission to trigger a fetch.';

  @override
  String get syncTimeout => 'Sync is taking longer than expected, check again later.';

  @override
  String get rotateScreen => 'Rotate screen';

  @override
  String get editBarcodeTitle => 'Item no. / Barcode';

  @override
  String get barcodeLabel => 'Barcode';

  @override
  String get barcodeInCatalog => 'In catalog';

  @override
  String get barcodeNotInCatalog => 'Not in catalog — this may be an alternative barcode; choose the product\'s primary barcode';

  @override
  String get searchByProductName => 'Search product by name';

  @override
  String get productSearchHint => 'Type a product name…';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get catalogLoading => 'Loading product catalog…';

  @override
  String get barcodeIssuesTitle => 'Barcodes not in catalog';

  @override
  String get barcodeIssuesMessage => 'Some items have a barcode that is not in the catalog. It may be an alternative barcode — choose the product\'s primary barcode. You cannot send to the cash register until fixed.';

  @override
  String get jumpToFirstIssue => 'Jump to first issue';

  @override
  String get validating => 'Validating...';

  @override
  String get validationSuccessTitle => 'Data is valid';

  @override
  String get validationSuccessMessage => 'The data is valid and ready to be posted to the cash register.';

  @override
  String get validationErrorsTitle => 'Issues to fix';

  @override
  String get validationFailedTitle => 'Validation failed';

  @override
  String get validationNetworkErrorTitle => 'Connection problem';

  @override
  String get validationNetworkErrorMessage => 'Could not reach the server. Check your connection and try again.';

  @override
  String get validationConfigError => 'System configuration error. Contact support (scope/customer code).';

  @override
  String get validationRateLimited => 'Too many requests. Try again in a moment.';

  @override
  String get validationGenericError => 'Validation failed, please try again later.';

  @override
  String get lineLabel => 'Line';

  @override
  String get suggestionsLabel => 'Suggestions';

  @override
  String get chooseCorrectSupplier => 'Choose the correct supplier';

  @override
  String get submitting => 'Sending to register...';

  @override
  String get submitBackground => 'Continuing in background…';

  @override
  String get submitSuccessTitle => 'Received successfully';

  @override
  String get submitSuccessMessage => 'The invoice was received into Comax successfully.';

  @override
  String get submitErrorTitle => 'Send to register failed';

  @override
  String get submitNetworkError => 'Connection problem while sending to the register. Try again.';

  @override
  String get submitGenericError => 'Send to register failed, try again.';

  @override
  String get submitTimeout => 'Receiving is taking a while. Check later whether the invoice was received.';

  @override
  String get submitAlreadyReceivedTitle => 'Invoice already received';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get customerCodeLabel => 'Customer code';

  @override
  String get customerCodeHint => 'Enter customer code';

  @override
  String get scanModelLabel => 'Scan model';

  @override
  String get createNewProductButton => 'Create new product';

  @override
  String get editNewProductButton => 'Edit new product';

  @override
  String get newProductTitle => 'New product';

  @override
  String get editProductTitle => 'Edit product';

  @override
  String get npItem => 'Item';

  @override
  String get npBarcode => 'Barcode';

  @override
  String get npName => 'Name';

  @override
  String get npDepartment => 'Department';

  @override
  String get npGroup => 'Group';

  @override
  String get npMainSupplier => 'Main supplier';

  @override
  String get npSupplierItem => 'Supplier item';

  @override
  String get npSupplierPrice => 'Supplier price';

  @override
  String get npDiscountPct => 'Discount %';

  @override
  String get npProfitPct => 'Profit %';

  @override
  String get npSalePrice => 'Sale price';

  @override
  String get npManageDeposit => 'Manage deposit';

  @override
  String get npDraggedToRegister => 'Dragged to register';

  @override
  String get npDepositItem => 'Deposit item';

  @override
  String get npMisc => 'Misc';

  @override
  String get npRequiredMissing => 'Please fill in all required fields';

  @override
  String get npSelectDepartmentFirst => 'Select a department first';

  @override
  String get selectHint => 'Select';

  @override
  String get tbdOptions => 'To be defined';

  @override
  String get loadingEllipsis => 'Loading…';

  @override
  String get searchHintGeneric => 'Search…';

  @override
  String get npSectionItem => 'Item details';

  @override
  String get npSectionClassification => 'Classification';

  @override
  String get npSectionSupplier => 'Supplier';

  @override
  String get npSectionPricing => 'Pricing';

  @override
  String get npSectionMore => 'Additional settings';

  @override
  String get scannerUnknownFailure => 'Could not open the scanner. Please try again.';

  @override
  String get suggestedMatches => 'Suggested matches';

  @override
  String get resolvingBarcodes => 'Matching barcodes from the catalog…';

  @override
  String get autoFilledBarcodesTitle => 'Auto-filled rows';

  @override
  String get autoFilledBarcodesSubtitle => 'The barcode was reconstructed from the catalog by name and price. Please verify the rows marked in orange before sending to the cash register.';

  @override
  String get duplicateFoundTitle => 'This invoice already exists in Comax';

  @override
  String get duplicateSimilarTitle => 'A similar invoice was found in Comax';

  @override
  String get duplicateReversedTitle => 'This document existed in Comax but was reversed — you can send it again';

  @override
  String get comaxDocumentLabel => 'Document';

  @override
  String get duplicateSnapshotNote => 'Data is from the last Comax fetch:';

  @override
  String get duplicateReferenceLabel => 'Comax reference:';

  @override
  String get duplicateSuffixExplain => 'a suffix of the invoice number';

  @override
  String get consistencyBlockTitle => 'Invoice figures don\'t add up';

  @override
  String get consistencyBlockSubtitle => 'Cannot send to the cash register until the figures are corrected. The OCR likely misread some rows:';

  @override
  String get consistencyBannerSubtitle => 'The line totals don\'t match the invoice total. Check the flagged rows before sending.';

  @override
  String get consistencyWarnTitle => 'Invoice total differs from calculation';

  @override
  String get consistencyWarnQuestion => 'Send to the cash register anyway?';

  @override
  String get consistencyWarnSendAnyway => 'Send anyway';

  @override
  String get filterBySupplier => 'Show only this invoice\'s supplier';

  @override
  String get fromInvoiceLabel => 'From the invoice:';
}
