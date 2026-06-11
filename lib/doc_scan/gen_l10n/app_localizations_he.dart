// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appName => 'סורק חשבוניות';

  @override
  String get searchHint => 'חיפוש לפי סוג מסמך או שם חברה';

  @override
  String get sortAndFilter => 'מיון וסינון';

  @override
  String get sortBy => 'מיון לפי';

  @override
  String get filterBy => 'סינון לפי';

  @override
  String get clearSortAndFilter => 'נקה מיון וסינון';

  @override
  String get close => 'סגור';

  @override
  String get emptyTitle => 'אין מסמכים סרוקים';

  @override
  String get emptySubtitle => 'לחץ על הכפתור למטה כדי לסרוק חשבונית';

  @override
  String get scanInvoice => 'סרוק תעודה';

  @override
  String get chooseScanModelTitle => 'בחר מודל סריקה';

  @override
  String get deleteDocumentTitle => 'מחיקת מסמך';

  @override
  String get deleteDocumentConfirm =>
      'האם אתה בטוח שאתה רוצה למחוק את המסמך הזה?';

  @override
  String get documentDeletedSuccess => 'המסמך נמחק בהצלחה';

  @override
  String get cancel => 'ביטול';

  @override
  String get delete => 'מחק';

  @override
  String get filterDate => 'תאריך';

  @override
  String get filterCompanyName => 'שם חברה';

  @override
  String get filterAmount => 'סכום';

  @override
  String get filterStatus => 'סטטוס';

  @override
  String get filterCreatedDate => 'תאריך יצירה';

  @override
  String get filterDocumentDate => 'תאריך מסמך';

  @override
  String get filterDocumentType => 'סוג מסמך';

  @override
  String get scan => 'סריקה';

  @override
  String get scanPlaceholder => 'הנח את החשבונית במסגרת';

  @override
  String get scanMockHint => 'או לחץ לסריקה מדומה';

  @override
  String get scanButton => 'סרוק';

  @override
  String get pageScanned => 'העמוד נסרק';

  @override
  String get previewPlaceholder => 'תצוגה מקדימה של העמוד';

  @override
  String get send => 'שלח';

  @override
  String get processingTitle => 'סורק נתוני מסמך...';

  @override
  String get processingSub1 => 'מזהה טקסט...';

  @override
  String get processingSub2 => 'מנתח נתונים...';

  @override
  String get processingSub3 => 'מחלץ פרטים...';

  @override
  String get processingSub4 => 'כמעט סיים...';

  @override
  String get documentDetails => 'נתוני מסמך';

  @override
  String get noDocumentSelected => 'לא נבחר מסמך';

  @override
  String scanDateLabel(String formatted) {
    return 'נסרק: $formatted';
  }

  @override
  String get showScanDocument => 'הצג מסמך סריקה';

  @override
  String get exportToExcel => 'ייצוא לאקסל';

  @override
  String get exportExcelFailed =>
      'לא ניתן לייצא לאקסל. ודא שנתוני המסמך תקינים.';

  @override
  String get save => 'שמור';

  @override
  String get updateInCash => 'שלח לקופה';

  @override
  String get generalData => 'נתונים כלליים';

  @override
  String get documentType => 'סוג מסמך';

  @override
  String get companyName => 'שם חברה';

  @override
  String get companyId => 'מספר ח.פ.';

  @override
  String get documentNumber => 'מספר תעודה';

  @override
  String get documentDate => 'תאריך המסמך';

  @override
  String get subtotalNoVat => 'סה\"כ ללא מע\"מ';

  @override
  String get vatAmount => 'סה\"כ מע\"מ';

  @override
  String get totalToPay => 'סה\"כ לתשלום';

  @override
  String get items => 'פריטים';

  @override
  String get addItem => 'הוסף פריט';

  @override
  String get searchItemHint => 'חיפוש פריט לפי תיאור או מס\' פריט';

  @override
  String get colLineNumber => '#';

  @override
  String get colItemNumber => 'מס\' פריט';

  @override
  String get colItemDescription => 'תיאור פריט';

  @override
  String get colQuantity => 'כמות';

  @override
  String get colPackages => 'מארזים';

  @override
  String get colUnits => 'יח\' במארז';

  @override
  String get colPricePerUnit => 'מחיר ליח\'';

  @override
  String get colTotalNis => 'סה\"כ';

  @override
  String get deleteRowTitle => 'מחיקת שורה';

  @override
  String get deleteRowConfirm => 'האם אתה בטוח שברצונך למחוק את השורה?';

  @override
  String get yes => 'כן';

  @override
  String get no => 'לא';

  @override
  String get update => 'עדכן';

  @override
  String get docTypeInvoice => 'חשבונית';

  @override
  String get docTypeDelivery => 'תעודת משלוח';

  @override
  String get docTypeReturn => 'תעודת חזרה';

  @override
  String get docTypeOther => 'אחר';

  @override
  String get chooseDocumentType => 'בחר סוג מסמך';

  @override
  String get enterDocumentType => 'הזן סוג מסמך';

  @override
  String get documentTypeLabel => 'סוג מסמך';

  @override
  String get pickDocumentDate => 'בחר תאריך מסמך';

  @override
  String get excelPreviewTitle => 'תצוגת אקסל';

  @override
  String get excelShareText => 'גיליון אקסל';

  @override
  String get pdfPreviewTitle => 'תצוגת PDF';

  @override
  String get pdfAvailable => 'PDF זמין לצפייה';

  @override
  String get pdfDemoHint => 'תצוגה מקדימה במצב הדגמה';

  @override
  String get share => 'שיתוף';

  @override
  String get statusScanning => 'סורק נתוני מסמך';

  @override
  String get statusUploading => 'מעלה מסמכים';

  @override
  String get statusReadyForUpdate => 'ממתין לשליחה לקופה';

  @override
  String get statusCompleted => 'בוצע';

  @override
  String get statusDeleted => 'נמחק';

  @override
  String get statusSentToCashRegister => 'נשלח לקופה';

  @override
  String get docNumberLabel => 'מס\' תעודה';

  @override
  String docNumberValue(String num) {
    return 'מס\' תעודה: $num';
  }

  @override
  String dateLabel(String date) {
    return 'תאריך: $date';
  }

  @override
  String get itemNumber => 'מס\' פריט';

  @override
  String get itemDescription => 'תיאור פריט';

  @override
  String get quantity => 'כמות';

  @override
  String get packages => 'מארזים';

  @override
  String get units => 'יחידות';

  @override
  String get pricePerUnitNis => 'ש\"ח ליחידה';

  @override
  String get totalNis => 'סה\"כ ש\"ח';

  @override
  String get preScanDocumentDetailsTitle => 'פרטי מסמך לפני סריקה';

  @override
  String get supplierNameLabel => 'שם ספק';

  @override
  String get supplierNameHint => 'הקלד שם ספק (או בחר מהרשימה)';

  @override
  String get supplierQuickTip => 'טיפ: אפשר להקליד לסינון מהיר';

  @override
  String get supplierListTitle => 'רשימת ספקים';

  @override
  String get continueToScan => 'המשך לסריקה';

  @override
  String get pickSupplierTitle => 'בחירת ספק';

  @override
  String get supplierSearchHint => 'חפש ספק...';

  @override
  String get supplierSearchPlaceholder => 'חיפוש...';

  @override
  String suppliersFoundCount(Object count) {
    return 'נמצאו $count ספקים';
  }

  @override
  String get noResults => 'לא נמצאו תוצאות';

  @override
  String get noSavedSuppliers => 'אין ספקים שמורים';

  @override
  String get select => 'בחר';

  @override
  String get clear => 'נקה';

  @override
  String get unknownSupplierInitial => 'ס';

  @override
  String get sortTileTitle => 'מיון';

  @override
  String get sortNone => 'ללא מיון';

  @override
  String get sortByCreatedAtOldest => 'תאריך: ישן קודם';

  @override
  String get sortByCreatedAtNewest => 'תאריך: חדש קודם';

  @override
  String get sortByTotalAmountLow => 'סכום: נמוך קודם';

  @override
  String get sortByTotalAmountHigh => 'סכום: גבוה קודם';

  @override
  String get helpTextChooseRange => 'בחר טווח';

  @override
  String get rangeNoneLabel => 'ללא';

  @override
  String filterCreatedDatePreview(Object range) {
    return 'תאריך יצירה: $range';
  }

  @override
  String filterDocumentDatePreview(Object range) {
    return 'תאריך מסמך: $range';
  }

  @override
  String filterDocumentTypePreview(Object types) {
    return 'סוג מסמך: $types';
  }

  @override
  String filterSupplierPreview(Object suppliers) {
    return 'שם ספק: $suppliers';
  }

  @override
  String filterStatusPreview(Object statuses) {
    return 'סטטוס: $statuses';
  }

  @override
  String get statusProcessing => 'בעיבוד';

  @override
  String get statusError => 'שגיאה';

  @override
  String get documentProcessing => 'המסמך עדיין בעיבוד';

  @override
  String get noImagesForRetry => 'אין תמונות לשליחה מחדש';

  @override
  String get showScannedImage => 'הצג תמונה סרוקה';

  @override
  String get retrieveDataAgain => 'אחזר נתונים מחדש';

  @override
  String get confirmRetrieveDataAgainTitle => 'אישור';

  @override
  String get confirmRetrieveDataAgainMessage =>
      'האם אתה בטוח שאתה רוצה לאחזר את נתוני המסמך מחדש?\nזה יכול לקחת זמן...';

  @override
  String get confirmSendToCashTitle => 'אישור';

  @override
  String get confirmSendToCashMessage =>
      'האם אתה בטוח שברצונך לשלוח את המסמך לעדכון הקופה שלך?';

  @override
  String get imageExportFailureTitle => 'שגיאה בייצוא תמונות';

  @override
  String get copyTooltip => 'העתקה';

  @override
  String get copiedToClipboard => 'הועתק ללוח';

  @override
  String get continueButton => 'המשך';

  @override
  String get imageExportDebugIntro =>
      'לא הצלחנו לייצא תמונות מהסריקה. לא נשלח PDF ל-API.';

  @override
  String imageExportErrorLine(Object error) {
    return 'שגיאה: $error';
  }

  @override
  String imageExportExpectedImages(Object count) {
    return 'תמונות צפויות: $count';
  }

  @override
  String imageExportExistingImages(Object count) {
    return 'תמונות קיימות: $count';
  }

  @override
  String imageExportPdfPath(Object path) {
    return 'pdfPath: $path';
  }

  @override
  String get imageExportFailedNull => 'ייצוא תמונות נכשל (null)';

  @override
  String get imageExportReturnedEmpty =>
      'ייצוא תמונות החזיר רשימה ריקה (לא נמצאו תמונות תקינות)';

  @override
  String imageExportPathExamples(Object paths) {
    return 'דוגמאות נתיבים (עד 10):\n$paths';
  }

  @override
  String serverError(Object error) {
    return 'שגיאה בשרת: $error';
  }

  @override
  String unexpectedError(Object error) {
    return 'שגיאה לא צפויה: $error';
  }

  @override
  String get noValidImagesToSend => 'לא נמצאו תמונות תקינות לשליחה';

  @override
  String get jsonTitle => 'JSON';

  @override
  String get jsonContentLabel => 'תוכן JSON';

  @override
  String get jsonCopiedSnackBar => 'ה-JSON הועתק';

  @override
  String get noJsonToShow => 'אין JSON להצגה';

  @override
  String get copy => 'העתקה';

  @override
  String get shareScannedDocument => 'מסמך סרוק';

  @override
  String get fileNotFound => 'הקובץ לא נמצא';

  @override
  String shareError(Object error) {
    return 'שגיאה בשיתוף: $error';
  }

  @override
  String get unableToLoadDocument => 'לא ניתן לטעון את המסמך';

  @override
  String get scannedImagesPreviewTitle => 'תצוגת תמונות סרוקות';

  @override
  String get scannedImagesShareText => 'תמונות סרוקות';

  @override
  String get unableToLoadImages => 'לא ניתן לטעון את התמונות';

  @override
  String get noImagesToShow => 'אין תמונות להצגה';

  @override
  String get docTypeReceipt => 'קבלה';

  @override
  String get docTypeCreditInvoice => 'חשבונית זיכוי';

  @override
  String get languageEnglishOptionLabel => 'EN';

  @override
  String get languageHebrewOptionLabel => 'עב';

  @override
  String parseErrorImageTooLarge(Object maxMB, Object sizeMB) {
    return 'התמונה גדולה מדי (${sizeMB}MB). מקסימום ${maxMB}MB.';
  }

  @override
  String get parseErrorImagesNotReceived => 'לא התקבלו תמונות';

  @override
  String parseErrorPdfTooLarge(Object maxMB, Object sizeMB) {
    return 'הקובץ גדול מדי (${sizeMB}MB). מקסימום ${maxMB}MB.';
  }

  @override
  String get parseErrorScanJobEmptyResponse =>
      'שגיאה ביצירת משימת סריקה: תשובה ריקה';

  @override
  String get parseErrorScanJobMissingJobId =>
      'שגיאה ביצירת משימת סריקה: jobId חסר';

  @override
  String get parseErrorDocumentProcessingEmptyResponse =>
      'שגיאה בעיבוד המסמך: תשובה ריקה';

  @override
  String get parseErrorUnauthenticated => 'יש להתחבר לפני שליחת מסמכים';

  @override
  String get parseErrorInvalidArgument => 'קובץ לא תקין';

  @override
  String get parseErrorResourceExhausted => 'יותר מדי בקשות. נסה שוב בעוד דקה';

  @override
  String get parseErrorInternal => 'שגיאה בעיבוד המסמך';

  @override
  String parseErrorUnknown(Object code) {
    return 'שגיאה ($code)';
  }

  @override
  String get docutainScanTitleScanPage => 'סריקת מסמך';

  @override
  String get docutainScanFocusHint => 'נא להחזיק יציב';

  @override
  String get docutainButtonScanTorchTitle => 'פלאש';

  @override
  String get docutainButtonScanFinishTitle => 'המשך';

  @override
  String get docutainButtonScanAutoCaptureOnTitle => 'סרוק אוטומטית';

  @override
  String get docutainButtonScanAutoCaptureOffTitle => 'סרוק ידנית';

  @override
  String get docutainButtonEditDeleteTitle => 'מחק';

  @override
  String get docutainButtonEditFinishTitle => 'סיום';

  @override
  String get docutainButtonEditCropTitle => 'חיתוך';

  @override
  String get docutainButtonEditRotateTitle => 'סיבוב';

  @override
  String get docutainButtonEditArrangeTitle => 'סידור';

  @override
  String get docutainTextTitleArrangementPage => 'סידור';

  @override
  String get docutainTextDeleteDialogCurrentPage => 'מחק דף נוכחי';

  @override
  String get docutainTextDeleteDialogAllPages => 'מחק את כל הדפים';

  @override
  String get docutainTextDeleteDialogCancel => 'ביטול';

  @override
  String get docutainScanCancelledError => 'הסריקה בוטלה.';

  @override
  String docutainScanError(Object error) {
    return 'שגיאה בסריקה: $error';
  }

  @override
  String get docutainInitLicenseKeyMissing =>
      'מפתח רישיון Docutain לא הוגדר. הוסף ב־app_config.dart (defaultValue) או הרץ עם: --dart-define=DOCUTAIN_LICENSE_KEY=המפתח_שלך';

  @override
  String docutainInitFailedWithSdkError(Object sdkError) {
    return 'אתחול Docutain נכשל: $sdkError\n\nהרישיון קשור ל-applicationId של האפליקציה. באפליקציה זו: scanner.tavili.com. יש להנפיק רישיון ניסיון עם ה-ID הזה ב־ https://sdk.docutain.com/TrialLicense';
  }

  @override
  String get docutainInitFailedWithoutSdkError =>
      'אתחול Docutain נכשל. הרישיון קשור ל-applicationId. באפליקציה זו: scanner.tavili.com. הנפק רישיון ניסיון עם ID זה: https://sdk.docutain.com/TrialLicense';

  @override
  String get scanSourceTitle => 'איך לצלם את המסמך?';

  @override
  String get scanSourceCamera => 'מצלמה';

  @override
  String get scanSourceGallery => 'גלריה';

  @override
  String get scanAddAnotherPageTitle => 'הוספת דף';

  @override
  String scanAddAnotherPageMessage(int count) {
    return 'צילמת $count דפים. להוסיף עוד דף?';
  }

  @override
  String get scanFinishCapture => 'סיום';

  @override
  String get scanAddPage => 'צלם דף נוסף';

  @override
  String get scanCropPageTitle => 'עריכת דף';

  @override
  String scanCropPageCounter(int current, int total) {
    return 'דף $current מתוך $total';
  }

  @override
  String scanMaxPagesReached(int max) {
    return 'הגעת למקסימום $max דפים';
  }

  @override
  String get scanPermissionDenied => 'נדרשת הרשאה למצלמה או לגלריה';

  @override
  String get scanNoImagesSelected => 'לא נבחרו תמונות';
}
