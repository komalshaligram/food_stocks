import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he')
  ];

  /// No description provided for @appName.
  ///
  /// In he, this message translates to:
  /// **'סורק חשבוניות'**
  String get appName;

  /// No description provided for @searchHint.
  ///
  /// In he, this message translates to:
  /// **'חיפוש לפי סוג מסמך או שם חברה'**
  String get searchHint;

  /// No description provided for @sortAndFilter.
  ///
  /// In he, this message translates to:
  /// **'מיון וסינון'**
  String get sortAndFilter;

  /// No description provided for @sortBy.
  ///
  /// In he, this message translates to:
  /// **'מיון לפי'**
  String get sortBy;

  /// No description provided for @filterBy.
  ///
  /// In he, this message translates to:
  /// **'סינון לפי'**
  String get filterBy;

  /// No description provided for @clearSortAndFilter.
  ///
  /// In he, this message translates to:
  /// **'נקה מיון וסינון'**
  String get clearSortAndFilter;

  /// No description provided for @close.
  ///
  /// In he, this message translates to:
  /// **'סגור'**
  String get close;

  /// No description provided for @emptyTitle.
  ///
  /// In he, this message translates to:
  /// **'אין מסמכים סרוקים'**
  String get emptyTitle;

  /// No description provided for @emptySubtitle.
  ///
  /// In he, this message translates to:
  /// **'לחץ על הכפתור למטה כדי לסרוק חשבונית'**
  String get emptySubtitle;

  /// No description provided for @scanInvoice.
  ///
  /// In he, this message translates to:
  /// **'סרוק תעודה'**
  String get scanInvoice;

  /// No description provided for @chooseScanModelTitle.
  ///
  /// In he, this message translates to:
  /// **'בחר מודל סריקה'**
  String get chooseScanModelTitle;

  /// No description provided for @deleteDocumentTitle.
  ///
  /// In he, this message translates to:
  /// **'מחיקת מסמך'**
  String get deleteDocumentTitle;

  /// No description provided for @deleteDocumentConfirm.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח שאתה רוצה למחוק את המסמך הזה?'**
  String get deleteDocumentConfirm;

  /// No description provided for @documentDeletedSuccess.
  ///
  /// In he, this message translates to:
  /// **'המסמך נמחק בהצלחה'**
  String get documentDeletedSuccess;

  /// No description provided for @cancel.
  ///
  /// In he, this message translates to:
  /// **'ביטול'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In he, this message translates to:
  /// **'מחק'**
  String get delete;

  /// No description provided for @filterDate.
  ///
  /// In he, this message translates to:
  /// **'תאריך'**
  String get filterDate;

  /// No description provided for @filterCompanyName.
  ///
  /// In he, this message translates to:
  /// **'שם חברה'**
  String get filterCompanyName;

  /// No description provided for @filterAmount.
  ///
  /// In he, this message translates to:
  /// **'סכום'**
  String get filterAmount;

  /// No description provided for @filterStatus.
  ///
  /// In he, this message translates to:
  /// **'סטטוס'**
  String get filterStatus;

  /// No description provided for @filterCreatedDate.
  ///
  /// In he, this message translates to:
  /// **'תאריך יצירה'**
  String get filterCreatedDate;

  /// No description provided for @filterDocumentDate.
  ///
  /// In he, this message translates to:
  /// **'תאריך מסמך'**
  String get filterDocumentDate;

  /// No description provided for @filterDocumentType.
  ///
  /// In he, this message translates to:
  /// **'סוג מסמך'**
  String get filterDocumentType;

  /// No description provided for @scan.
  ///
  /// In he, this message translates to:
  /// **'סריקה'**
  String get scan;

  /// No description provided for @scanPlaceholder.
  ///
  /// In he, this message translates to:
  /// **'הנח את החשבונית במסגרת'**
  String get scanPlaceholder;

  /// No description provided for @scanMockHint.
  ///
  /// In he, this message translates to:
  /// **'או לחץ לסריקה מדומה'**
  String get scanMockHint;

  /// No description provided for @scanButton.
  ///
  /// In he, this message translates to:
  /// **'סרוק'**
  String get scanButton;

  /// No description provided for @pageScanned.
  ///
  /// In he, this message translates to:
  /// **'העמוד נסרק'**
  String get pageScanned;

  /// No description provided for @previewPlaceholder.
  ///
  /// In he, this message translates to:
  /// **'תצוגה מקדימה של העמוד'**
  String get previewPlaceholder;

  /// No description provided for @send.
  ///
  /// In he, this message translates to:
  /// **'שלח'**
  String get send;

  /// No description provided for @processingTitle.
  ///
  /// In he, this message translates to:
  /// **'סורק נתוני מסמך...'**
  String get processingTitle;

  /// No description provided for @processingSub1.
  ///
  /// In he, this message translates to:
  /// **'מזהה טקסט...'**
  String get processingSub1;

  /// No description provided for @processingSub2.
  ///
  /// In he, this message translates to:
  /// **'מנתח נתונים...'**
  String get processingSub2;

  /// No description provided for @processingSub3.
  ///
  /// In he, this message translates to:
  /// **'מחלץ פרטים...'**
  String get processingSub3;

  /// No description provided for @processingSub4.
  ///
  /// In he, this message translates to:
  /// **'כמעט סיים...'**
  String get processingSub4;

  /// No description provided for @documentDetails.
  ///
  /// In he, this message translates to:
  /// **'נתוני מסמך'**
  String get documentDetails;

  /// No description provided for @noDocumentSelected.
  ///
  /// In he, this message translates to:
  /// **'לא נבחר מסמך'**
  String get noDocumentSelected;

  /// No description provided for @scanDateLabel.
  ///
  /// In he, this message translates to:
  /// **'נסרק: {formatted}'**
  String scanDateLabel(String formatted);

  /// No description provided for @showScanDocument.
  ///
  /// In he, this message translates to:
  /// **'הצג מסמך סריקה'**
  String get showScanDocument;

  /// No description provided for @exportToExcel.
  ///
  /// In he, this message translates to:
  /// **'ייצוא לאקסל'**
  String get exportToExcel;

  /// No description provided for @exportExcelFailed.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לייצא לאקסל. ודא שנתוני המסמך תקינים.'**
  String get exportExcelFailed;

  /// No description provided for @save.
  ///
  /// In he, this message translates to:
  /// **'שמור'**
  String get save;

  /// No description provided for @updateInCash.
  ///
  /// In he, this message translates to:
  /// **'שלח לקופה'**
  String get updateInCash;

  /// No description provided for @generalData.
  ///
  /// In he, this message translates to:
  /// **'נתונים כלליים'**
  String get generalData;

  /// No description provided for @documentType.
  ///
  /// In he, this message translates to:
  /// **'סוג מסמך'**
  String get documentType;

  /// No description provided for @discountPercentLabel.
  ///
  /// In he, this message translates to:
  /// **'אחוז הנחה'**
  String get discountPercentLabel;

  /// No description provided for @companyName.
  ///
  /// In he, this message translates to:
  /// **'שם חברה'**
  String get companyName;

  /// No description provided for @companyId.
  ///
  /// In he, this message translates to:
  /// **'מספר ח.פ.'**
  String get companyId;

  /// No description provided for @documentNumber.
  ///
  /// In he, this message translates to:
  /// **'מספר תעודה'**
  String get documentNumber;

  /// No description provided for @documentDate.
  ///
  /// In he, this message translates to:
  /// **'תאריך המסמך'**
  String get documentDate;

  /// No description provided for @subtotalNoVat.
  ///
  /// In he, this message translates to:
  /// **'סה\"כ ללא מע\"מ'**
  String get subtotalNoVat;

  /// No description provided for @vatAmount.
  ///
  /// In he, this message translates to:
  /// **'סה\"כ מע\"מ'**
  String get vatAmount;

  /// No description provided for @totalToPay.
  ///
  /// In he, this message translates to:
  /// **'סה\"כ לתשלום'**
  String get totalToPay;

  /// No description provided for @items.
  ///
  /// In he, this message translates to:
  /// **'פריטים'**
  String get items;

  /// No description provided for @addItem.
  ///
  /// In he, this message translates to:
  /// **'הוסף פריט'**
  String get addItem;

  /// No description provided for @searchItemHint.
  ///
  /// In he, this message translates to:
  /// **'חיפוש פריט לפי תיאור או מס\' פריט'**
  String get searchItemHint;

  /// No description provided for @colLineNumber.
  ///
  /// In he, this message translates to:
  /// **'#'**
  String get colLineNumber;

  /// No description provided for @colItemNumber.
  ///
  /// In he, this message translates to:
  /// **'מס\' פריט'**
  String get colItemNumber;

  /// No description provided for @colItemDescription.
  ///
  /// In he, this message translates to:
  /// **'תיאור פריט'**
  String get colItemDescription;

  /// No description provided for @colQuantity.
  ///
  /// In he, this message translates to:
  /// **'כמות'**
  String get colQuantity;

  /// No description provided for @colPackages.
  ///
  /// In he, this message translates to:
  /// **'מארזים'**
  String get colPackages;

  /// No description provided for @colUnits.
  ///
  /// In he, this message translates to:
  /// **'יח\' במארז'**
  String get colUnits;

  /// No description provided for @colPricePerUnit.
  ///
  /// In he, this message translates to:
  /// **'מחיר ליח\''**
  String get colPricePerUnit;

  /// No description provided for @colTotalNis.
  ///
  /// In he, this message translates to:
  /// **'סה\"כ'**
  String get colTotalNis;

  /// No description provided for @deleteRowTitle.
  ///
  /// In he, this message translates to:
  /// **'מחיקת שורה'**
  String get deleteRowTitle;

  /// No description provided for @deleteRowConfirm.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח שברצונך למחוק את השורה?'**
  String get deleteRowConfirm;

  /// No description provided for @yes.
  ///
  /// In he, this message translates to:
  /// **'כן'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In he, this message translates to:
  /// **'לא'**
  String get no;

  /// No description provided for @update.
  ///
  /// In he, this message translates to:
  /// **'עדכן'**
  String get update;

  /// No description provided for @docTypeInvoice.
  ///
  /// In he, this message translates to:
  /// **'חשבונית'**
  String get docTypeInvoice;

  /// No description provided for @docTypeDelivery.
  ///
  /// In he, this message translates to:
  /// **'תעודת משלוח'**
  String get docTypeDelivery;

  /// No description provided for @docTypeReturn.
  ///
  /// In he, this message translates to:
  /// **'תעודת חזרה'**
  String get docTypeReturn;

  /// No description provided for @docTypeOther.
  ///
  /// In he, this message translates to:
  /// **'אחר'**
  String get docTypeOther;

  /// No description provided for @docTypeTaxInvoice.
  ///
  /// In he, this message translates to:
  /// **'חשבונית מס/כניסה'**
  String get docTypeTaxInvoice;

  /// No description provided for @docTypeReturnInvoice.
  ///
  /// In he, this message translates to:
  /// **'חשבונית החזר'**
  String get docTypeReturnInvoice;

  /// No description provided for @docTypeEntryCertificate.
  ///
  /// In he, this message translates to:
  /// **'תעודת כניסה'**
  String get docTypeEntryCertificate;

  /// No description provided for @docTypeReturnCertificate.
  ///
  /// In he, this message translates to:
  /// **'תעודת החזר'**
  String get docTypeReturnCertificate;

  /// No description provided for @docTypeInactiveSuffix.
  ///
  /// In he, this message translates to:
  /// **'לא פעיל כרגע'**
  String get docTypeInactiveSuffix;

  /// No description provided for @chooseDocumentType.
  ///
  /// In he, this message translates to:
  /// **'בחר סוג מסמך'**
  String get chooseDocumentType;

  /// No description provided for @enterDocumentType.
  ///
  /// In he, this message translates to:
  /// **'הזן סוג מסמך'**
  String get enterDocumentType;

  /// No description provided for @documentTypeLabel.
  ///
  /// In he, this message translates to:
  /// **'סוג מסמך'**
  String get documentTypeLabel;

  /// No description provided for @pickDocumentDate.
  ///
  /// In he, this message translates to:
  /// **'בחר תאריך מסמך'**
  String get pickDocumentDate;

  /// No description provided for @excelPreviewTitle.
  ///
  /// In he, this message translates to:
  /// **'תצוגת אקסל'**
  String get excelPreviewTitle;

  /// No description provided for @excelShareText.
  ///
  /// In he, this message translates to:
  /// **'גיליון אקסל'**
  String get excelShareText;

  /// No description provided for @pdfPreviewTitle.
  ///
  /// In he, this message translates to:
  /// **'תצוגת PDF'**
  String get pdfPreviewTitle;

  /// No description provided for @pdfAvailable.
  ///
  /// In he, this message translates to:
  /// **'PDF זמין לצפייה'**
  String get pdfAvailable;

  /// No description provided for @pdfDemoHint.
  ///
  /// In he, this message translates to:
  /// **'תצוגה מקדימה במצב הדגמה'**
  String get pdfDemoHint;

  /// No description provided for @share.
  ///
  /// In he, this message translates to:
  /// **'שיתוף'**
  String get share;

  /// No description provided for @statusScanning.
  ///
  /// In he, this message translates to:
  /// **'סורק נתוני מסמך'**
  String get statusScanning;

  /// No description provided for @statusUploading.
  ///
  /// In he, this message translates to:
  /// **'מעלה מסמכים'**
  String get statusUploading;

  /// No description provided for @statusReadyForUpdate.
  ///
  /// In he, this message translates to:
  /// **'ממתין לשליחה לקופה'**
  String get statusReadyForUpdate;

  /// No description provided for @statusCompleted.
  ///
  /// In he, this message translates to:
  /// **'נשמר, טרם נשלח לקופה'**
  String get statusCompleted;

  /// No description provided for @statusSentInBackground.
  ///
  /// In he, this message translates to:
  /// **'נשמר, נשלח לקופה ברקע'**
  String get statusSentInBackground;

  /// No description provided for @statusIntakeFailedRetry.
  ///
  /// In he, this message translates to:
  /// **'קליטה נכשלה, נסה שנית'**
  String get statusIntakeFailedRetry;

  /// No description provided for @statusDeleted.
  ///
  /// In he, this message translates to:
  /// **'נמחק'**
  String get statusDeleted;

  /// No description provided for @statusSentToCashRegister.
  ///
  /// In he, this message translates to:
  /// **'נשלח לקופה'**
  String get statusSentToCashRegister;

  /// No description provided for @docNumberLabel.
  ///
  /// In he, this message translates to:
  /// **'מס\' תעודה'**
  String get docNumberLabel;

  /// No description provided for @docNumberValue.
  ///
  /// In he, this message translates to:
  /// **'מס\' תעודה: {num}'**
  String docNumberValue(String num);

  /// No description provided for @dateLabel.
  ///
  /// In he, this message translates to:
  /// **'תאריך: {date}'**
  String dateLabel(String date);

  /// No description provided for @itemNumber.
  ///
  /// In he, this message translates to:
  /// **'מס\' פריט'**
  String get itemNumber;

  /// No description provided for @itemDescription.
  ///
  /// In he, this message translates to:
  /// **'תיאור פריט'**
  String get itemDescription;

  /// No description provided for @quantity.
  ///
  /// In he, this message translates to:
  /// **'כמות'**
  String get quantity;

  /// No description provided for @packages.
  ///
  /// In he, this message translates to:
  /// **'מארזים'**
  String get packages;

  /// No description provided for @units.
  ///
  /// In he, this message translates to:
  /// **'יחידות'**
  String get units;

  /// No description provided for @pricePerUnitNis.
  ///
  /// In he, this message translates to:
  /// **'ש\"ח ליחידה'**
  String get pricePerUnitNis;

  /// No description provided for @totalNis.
  ///
  /// In he, this message translates to:
  /// **'סה\"כ ש\"ח'**
  String get totalNis;

  /// No description provided for @preScanDocumentDetailsTitle.
  ///
  /// In he, this message translates to:
  /// **'פרטי מסמך לפני סריקה'**
  String get preScanDocumentDetailsTitle;

  /// No description provided for @supplierNameLabel.
  ///
  /// In he, this message translates to:
  /// **'שם ספק'**
  String get supplierNameLabel;

  /// No description provided for @supplierNameHint.
  ///
  /// In he, this message translates to:
  /// **'הקלד שם ספק (או בחר מהרשימה)'**
  String get supplierNameHint;

  /// No description provided for @supplierQuickTip.
  ///
  /// In he, this message translates to:
  /// **'טיפ: אפשר להקליד לסינון מהיר'**
  String get supplierQuickTip;

  /// No description provided for @supplierListTitle.
  ///
  /// In he, this message translates to:
  /// **'רשימת ספקים'**
  String get supplierListTitle;

  /// No description provided for @continueToScan.
  ///
  /// In he, this message translates to:
  /// **'המשך לסריקה'**
  String get continueToScan;

  /// No description provided for @pickSupplierTitle.
  ///
  /// In he, this message translates to:
  /// **'בחירת ספק'**
  String get pickSupplierTitle;

  /// No description provided for @supplierSearchHint.
  ///
  /// In he, this message translates to:
  /// **'חפש ספק...'**
  String get supplierSearchHint;

  /// No description provided for @supplierSearchPlaceholder.
  ///
  /// In he, this message translates to:
  /// **'חיפוש...'**
  String get supplierSearchPlaceholder;

  /// No description provided for @suppliersFoundCount.
  ///
  /// In he, this message translates to:
  /// **'נמצאו {count} ספקים'**
  String suppliersFoundCount(Object count);

  /// No description provided for @noResults.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו תוצאות'**
  String get noResults;

  /// No description provided for @noSavedSuppliers.
  ///
  /// In he, this message translates to:
  /// **'אין ספקים שמורים'**
  String get noSavedSuppliers;

  /// No description provided for @select.
  ///
  /// In he, this message translates to:
  /// **'בחר'**
  String get select;

  /// No description provided for @clear.
  ///
  /// In he, this message translates to:
  /// **'נקה'**
  String get clear;

  /// No description provided for @unknownSupplierInitial.
  ///
  /// In he, this message translates to:
  /// **'ס'**
  String get unknownSupplierInitial;

  /// No description provided for @sortTileTitle.
  ///
  /// In he, this message translates to:
  /// **'מיון'**
  String get sortTileTitle;

  /// No description provided for @sortNone.
  ///
  /// In he, this message translates to:
  /// **'ללא מיון'**
  String get sortNone;

  /// No description provided for @sortByCreatedAtOldest.
  ///
  /// In he, this message translates to:
  /// **'תאריך: ישן קודם'**
  String get sortByCreatedAtOldest;

  /// No description provided for @sortByCreatedAtNewest.
  ///
  /// In he, this message translates to:
  /// **'תאריך: חדש קודם'**
  String get sortByCreatedAtNewest;

  /// No description provided for @sortByTotalAmountLow.
  ///
  /// In he, this message translates to:
  /// **'סכום: נמוך קודם'**
  String get sortByTotalAmountLow;

  /// No description provided for @sortByTotalAmountHigh.
  ///
  /// In he, this message translates to:
  /// **'סכום: גבוה קודם'**
  String get sortByTotalAmountHigh;

  /// No description provided for @helpTextChooseRange.
  ///
  /// In he, this message translates to:
  /// **'בחר טווח'**
  String get helpTextChooseRange;

  /// No description provided for @rangeNoneLabel.
  ///
  /// In he, this message translates to:
  /// **'ללא'**
  String get rangeNoneLabel;

  /// No description provided for @filterCreatedDatePreview.
  ///
  /// In he, this message translates to:
  /// **'תאריך יצירה: {range}'**
  String filterCreatedDatePreview(Object range);

  /// No description provided for @filterDocumentDatePreview.
  ///
  /// In he, this message translates to:
  /// **'תאריך מסמך: {range}'**
  String filterDocumentDatePreview(Object range);

  /// No description provided for @filterDocumentTypePreview.
  ///
  /// In he, this message translates to:
  /// **'סוג מסמך: {types}'**
  String filterDocumentTypePreview(Object types);

  /// No description provided for @filterSupplierPreview.
  ///
  /// In he, this message translates to:
  /// **'שם ספק: {suppliers}'**
  String filterSupplierPreview(Object suppliers);

  /// No description provided for @filterStatusPreview.
  ///
  /// In he, this message translates to:
  /// **'סטטוס: {statuses}'**
  String filterStatusPreview(Object statuses);

  /// No description provided for @statusProcessing.
  ///
  /// In he, this message translates to:
  /// **'בעיבוד'**
  String get statusProcessing;

  /// No description provided for @statusError.
  ///
  /// In he, this message translates to:
  /// **'שגיאה'**
  String get statusError;

  /// No description provided for @documentProcessing.
  ///
  /// In he, this message translates to:
  /// **'המסמך עדיין בעיבוד'**
  String get documentProcessing;

  /// No description provided for @noImagesForRetry.
  ///
  /// In he, this message translates to:
  /// **'אין תמונות לשליחה מחדש'**
  String get noImagesForRetry;

  /// No description provided for @showScannedImage.
  ///
  /// In he, this message translates to:
  /// **'הצג תמונה סרוקה'**
  String get showScannedImage;

  /// No description provided for @retrieveDataAgain.
  ///
  /// In he, this message translates to:
  /// **'אחזר נתונים מחדש'**
  String get retrieveDataAgain;

  /// No description provided for @confirmRetrieveDataAgainTitle.
  ///
  /// In he, this message translates to:
  /// **'אישור'**
  String get confirmRetrieveDataAgainTitle;

  /// No description provided for @confirmRetrieveDataAgainMessage.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח שאתה רוצה לאחזר את נתוני המסמך מחדש?\nזה יכול לקחת זמן...'**
  String get confirmRetrieveDataAgainMessage;

  /// No description provided for @confirmSendToCashTitle.
  ///
  /// In he, this message translates to:
  /// **'אישור'**
  String get confirmSendToCashTitle;

  /// No description provided for @confirmSendToCashMessage.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח שברצונך לשלוח את המסמך לעדכון הקופה שלך?'**
  String get confirmSendToCashMessage;

  /// No description provided for @imageExportFailureTitle.
  ///
  /// In he, this message translates to:
  /// **'שגיאה בייצוא תמונות'**
  String get imageExportFailureTitle;

  /// No description provided for @copyTooltip.
  ///
  /// In he, this message translates to:
  /// **'העתקה'**
  String get copyTooltip;

  /// No description provided for @copiedToClipboard.
  ///
  /// In he, this message translates to:
  /// **'הועתק ללוח'**
  String get copiedToClipboard;

  /// No description provided for @continueButton.
  ///
  /// In he, this message translates to:
  /// **'המשך'**
  String get continueButton;

  /// No description provided for @imageExportDebugIntro.
  ///
  /// In he, this message translates to:
  /// **'לא הצלחנו לייצא תמונות מהסריקה. לא נשלח PDF ל-API.'**
  String get imageExportDebugIntro;

  /// No description provided for @imageExportErrorLine.
  ///
  /// In he, this message translates to:
  /// **'שגיאה: {error}'**
  String imageExportErrorLine(Object error);

  /// No description provided for @imageExportExpectedImages.
  ///
  /// In he, this message translates to:
  /// **'תמונות צפויות: {count}'**
  String imageExportExpectedImages(Object count);

  /// No description provided for @imageExportExistingImages.
  ///
  /// In he, this message translates to:
  /// **'תמונות קיימות: {count}'**
  String imageExportExistingImages(Object count);

  /// No description provided for @imageExportPdfPath.
  ///
  /// In he, this message translates to:
  /// **'pdfPath: {path}'**
  String imageExportPdfPath(Object path);

  /// No description provided for @imageExportFailedNull.
  ///
  /// In he, this message translates to:
  /// **'ייצוא תמונות נכשל (null)'**
  String get imageExportFailedNull;

  /// No description provided for @imageExportReturnedEmpty.
  ///
  /// In he, this message translates to:
  /// **'ייצוא תמונות החזיר רשימה ריקה (לא נמצאו תמונות תקינות)'**
  String get imageExportReturnedEmpty;

  /// No description provided for @imageExportPathExamples.
  ///
  /// In he, this message translates to:
  /// **'דוגמאות נתיבים (עד 10):\n{paths}'**
  String imageExportPathExamples(Object paths);

  /// No description provided for @serverError.
  ///
  /// In he, this message translates to:
  /// **'שגיאה בשרת: {error}'**
  String serverError(Object error);

  /// No description provided for @unexpectedError.
  ///
  /// In he, this message translates to:
  /// **'שגיאה לא צפויה: {error}'**
  String unexpectedError(Object error);

  /// No description provided for @noValidImagesToSend.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו תמונות תקינות לשליחה'**
  String get noValidImagesToSend;

  /// No description provided for @jsonTitle.
  ///
  /// In he, this message translates to:
  /// **'JSON'**
  String get jsonTitle;

  /// No description provided for @jsonContentLabel.
  ///
  /// In he, this message translates to:
  /// **'תוכן JSON'**
  String get jsonContentLabel;

  /// No description provided for @jsonCopiedSnackBar.
  ///
  /// In he, this message translates to:
  /// **'ה-JSON הועתק'**
  String get jsonCopiedSnackBar;

  /// No description provided for @noJsonToShow.
  ///
  /// In he, this message translates to:
  /// **'אין JSON להצגה'**
  String get noJsonToShow;

  /// No description provided for @copy.
  ///
  /// In he, this message translates to:
  /// **'העתקה'**
  String get copy;

  /// No description provided for @shareScannedDocument.
  ///
  /// In he, this message translates to:
  /// **'מסמך סרוק'**
  String get shareScannedDocument;

  /// No description provided for @fileNotFound.
  ///
  /// In he, this message translates to:
  /// **'הקובץ לא נמצא'**
  String get fileNotFound;

  /// No description provided for @shareError.
  ///
  /// In he, this message translates to:
  /// **'שגיאה בשיתוף: {error}'**
  String shareError(Object error);

  /// No description provided for @unableToLoadDocument.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את המסמך'**
  String get unableToLoadDocument;

  /// No description provided for @scannedImagesPreviewTitle.
  ///
  /// In he, this message translates to:
  /// **'תצוגת תמונות סרוקות'**
  String get scannedImagesPreviewTitle;

  /// No description provided for @scannedImagesShareText.
  ///
  /// In he, this message translates to:
  /// **'תמונות סרוקות'**
  String get scannedImagesShareText;

  /// No description provided for @unableToLoadImages.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את התמונות'**
  String get unableToLoadImages;

  /// No description provided for @noImagesToShow.
  ///
  /// In he, this message translates to:
  /// **'אין תמונות להצגה'**
  String get noImagesToShow;

  /// No description provided for @docTypeReceipt.
  ///
  /// In he, this message translates to:
  /// **'קבלה'**
  String get docTypeReceipt;

  /// No description provided for @docTypeCreditInvoice.
  ///
  /// In he, this message translates to:
  /// **'חשבונית זיכוי'**
  String get docTypeCreditInvoice;

  /// No description provided for @languageEnglishOptionLabel.
  ///
  /// In he, this message translates to:
  /// **'EN'**
  String get languageEnglishOptionLabel;

  /// No description provided for @languageHebrewOptionLabel.
  ///
  /// In he, this message translates to:
  /// **'עב'**
  String get languageHebrewOptionLabel;

  /// No description provided for @parseErrorImageTooLarge.
  ///
  /// In he, this message translates to:
  /// **'התמונה גדולה מדי ({sizeMB}MB). מקסימום {maxMB}MB.'**
  String parseErrorImageTooLarge(Object maxMB, Object sizeMB);

  /// No description provided for @parseErrorImagesNotReceived.
  ///
  /// In he, this message translates to:
  /// **'לא התקבלו תמונות'**
  String get parseErrorImagesNotReceived;

  /// No description provided for @parseErrorPdfTooLarge.
  ///
  /// In he, this message translates to:
  /// **'הקובץ גדול מדי ({sizeMB}MB). מקסימום {maxMB}MB.'**
  String parseErrorPdfTooLarge(Object maxMB, Object sizeMB);

  /// No description provided for @parseErrorScanJobEmptyResponse.
  ///
  /// In he, this message translates to:
  /// **'שגיאה ביצירת משימת סריקה: תשובה ריקה'**
  String get parseErrorScanJobEmptyResponse;

  /// No description provided for @parseErrorScanJobMissingJobId.
  ///
  /// In he, this message translates to:
  /// **'שגיאה ביצירת משימת סריקה: jobId חסר'**
  String get parseErrorScanJobMissingJobId;

  /// No description provided for @parseErrorDocumentProcessingEmptyResponse.
  ///
  /// In he, this message translates to:
  /// **'שגיאה בעיבוד המסמך: תשובה ריקה'**
  String get parseErrorDocumentProcessingEmptyResponse;

  /// No description provided for @parseErrorUnauthenticated.
  ///
  /// In he, this message translates to:
  /// **'יש להתחבר לפני שליחת מסמכים'**
  String get parseErrorUnauthenticated;

  /// No description provided for @parseErrorInvalidArgument.
  ///
  /// In he, this message translates to:
  /// **'קובץ לא תקין'**
  String get parseErrorInvalidArgument;

  /// No description provided for @parseErrorResourceExhausted.
  ///
  /// In he, this message translates to:
  /// **'יותר מדי בקשות. נסה שוב בעוד דקה'**
  String get parseErrorResourceExhausted;

  /// No description provided for @parseErrorInternal.
  ///
  /// In he, this message translates to:
  /// **'שגיאה בעיבוד המסמך'**
  String get parseErrorInternal;

  /// No description provided for @parseErrorUnknown.
  ///
  /// In he, this message translates to:
  /// **'שגיאה ({code})'**
  String parseErrorUnknown(Object code);

  /// No description provided for @docutainScanTitleScanPage.
  ///
  /// In he, this message translates to:
  /// **'סריקת מסמך'**
  String get docutainScanTitleScanPage;

  /// No description provided for @docutainScanFocusHint.
  ///
  /// In he, this message translates to:
  /// **'נא להחזיק יציב'**
  String get docutainScanFocusHint;

  /// No description provided for @docutainButtonScanTorchTitle.
  ///
  /// In he, this message translates to:
  /// **'פלאש'**
  String get docutainButtonScanTorchTitle;

  /// No description provided for @docutainButtonScanFinishTitle.
  ///
  /// In he, this message translates to:
  /// **'המשך'**
  String get docutainButtonScanFinishTitle;

  /// No description provided for @docutainButtonScanAutoCaptureOnTitle.
  ///
  /// In he, this message translates to:
  /// **'סרוק אוטומטית'**
  String get docutainButtonScanAutoCaptureOnTitle;

  /// No description provided for @docutainButtonScanAutoCaptureOffTitle.
  ///
  /// In he, this message translates to:
  /// **'סרוק ידנית'**
  String get docutainButtonScanAutoCaptureOffTitle;

  /// No description provided for @docutainButtonEditDeleteTitle.
  ///
  /// In he, this message translates to:
  /// **'מחק'**
  String get docutainButtonEditDeleteTitle;

  /// No description provided for @docutainButtonEditFinishTitle.
  ///
  /// In he, this message translates to:
  /// **'סיום'**
  String get docutainButtonEditFinishTitle;

  /// No description provided for @docutainButtonEditCropTitle.
  ///
  /// In he, this message translates to:
  /// **'חיתוך'**
  String get docutainButtonEditCropTitle;

  /// No description provided for @docutainButtonEditRotateTitle.
  ///
  /// In he, this message translates to:
  /// **'סיבוב'**
  String get docutainButtonEditRotateTitle;

  /// No description provided for @docutainButtonEditArrangeTitle.
  ///
  /// In he, this message translates to:
  /// **'סידור'**
  String get docutainButtonEditArrangeTitle;

  /// No description provided for @docutainTextTitleArrangementPage.
  ///
  /// In he, this message translates to:
  /// **'סידור'**
  String get docutainTextTitleArrangementPage;

  /// No description provided for @docutainTextDeleteDialogCurrentPage.
  ///
  /// In he, this message translates to:
  /// **'מחק דף נוכחי'**
  String get docutainTextDeleteDialogCurrentPage;

  /// No description provided for @docutainTextDeleteDialogAllPages.
  ///
  /// In he, this message translates to:
  /// **'מחק את כל הדפים'**
  String get docutainTextDeleteDialogAllPages;

  /// No description provided for @docutainTextDeleteDialogCancel.
  ///
  /// In he, this message translates to:
  /// **'ביטול'**
  String get docutainTextDeleteDialogCancel;

  /// No description provided for @docutainScanCancelledError.
  ///
  /// In he, this message translates to:
  /// **'הסריקה בוטלה.'**
  String get docutainScanCancelledError;

  /// No description provided for @docutainScanError.
  ///
  /// In he, this message translates to:
  /// **'שגיאה בסריקה: {error}'**
  String docutainScanError(Object error);

  /// No description provided for @docutainInitLicenseKeyMissing.
  ///
  /// In he, this message translates to:
  /// **'מפתח רישיון Docutain לא הוגדר. הוסף ב־app_config.dart (defaultValue) או הרץ עם: --dart-define=DOCUTAIN_LICENSE_KEY=המפתח_שלך'**
  String get docutainInitLicenseKeyMissing;

  /// No description provided for @docutainInitFailedWithSdkError.
  ///
  /// In he, this message translates to:
  /// **'אתחול Docutain נכשל: {sdkError}\n\nהרישיון קשור ל-applicationId של האפליקציה. באפליקציה זו: scanner.tavili.com. יש להנפיק רישיון ניסיון עם ה-ID הזה ב־ https://sdk.docutain.com/TrialLicense'**
  String docutainInitFailedWithSdkError(Object sdkError);

  /// No description provided for @docutainInitFailedWithoutSdkError.
  ///
  /// In he, this message translates to:
  /// **'אתחול Docutain נכשל. הרישיון קשור ל-applicationId. באפליקציה זו: scanner.tavili.com. הנפק רישיון ניסיון עם ID זה: https://sdk.docutain.com/TrialLicense'**
  String get docutainInitFailedWithoutSdkError;

  /// No description provided for @scanSourceTitle.
  ///
  /// In he, this message translates to:
  /// **'איך לצלם את המסמך?'**
  String get scanSourceTitle;

  /// No description provided for @scanSourceCamera.
  ///
  /// In he, this message translates to:
  /// **'מצלמה'**
  String get scanSourceCamera;

  /// No description provided for @scanSourceGallery.
  ///
  /// In he, this message translates to:
  /// **'גלריה'**
  String get scanSourceGallery;

  /// No description provided for @scanAddAnotherPageTitle.
  ///
  /// In he, this message translates to:
  /// **'הוספת דף'**
  String get scanAddAnotherPageTitle;

  /// No description provided for @scanAddAnotherPageMessage.
  ///
  /// In he, this message translates to:
  /// **'צילמת {count} דפים. להוסיף עוד דף?'**
  String scanAddAnotherPageMessage(int count);

  /// No description provided for @scanFinishCapture.
  ///
  /// In he, this message translates to:
  /// **'סיום'**
  String get scanFinishCapture;

  /// No description provided for @scanAddPage.
  ///
  /// In he, this message translates to:
  /// **'צלם דף נוסף'**
  String get scanAddPage;

  /// No description provided for @scanCropPageTitle.
  ///
  /// In he, this message translates to:
  /// **'עריכת דף'**
  String get scanCropPageTitle;

  /// No description provided for @scanCropPageCounter.
  ///
  /// In he, this message translates to:
  /// **'דף {current} מתוך {total}'**
  String scanCropPageCounter(int current, int total);

  /// No description provided for @scanMaxPagesReached.
  ///
  /// In he, this message translates to:
  /// **'הגעת למקסימום {max} דפים'**
  String scanMaxPagesReached(int max);

  /// No description provided for @scanPermissionDenied.
  ///
  /// In he, this message translates to:
  /// **'נדרשת הרשאה למצלמה או לגלריה'**
  String get scanPermissionDenied;

  /// No description provided for @scanNoImagesSelected.
  ///
  /// In he, this message translates to:
  /// **'לא נבחרו תמונות'**
  String get scanNoImagesSelected;

  /// No description provided for @scanDocumentSdk.
  ///
  /// In he, this message translates to:
  /// **'סרוק מסמך SDK'**
  String get scanDocumentSdk;

  /// No description provided for @scanDocumentFlutter.
  ///
  /// In he, this message translates to:
  /// **'סרוק מסמך Flutter'**
  String get scanDocumentFlutter;

  /// No description provided for @scanDocumentNative.
  ///
  /// In he, this message translates to:
  /// **'סרוק מסמך Native'**
  String get scanDocumentNative;

  /// No description provided for @manualScannerSelectScanTrack.
  ///
  /// In he, this message translates to:
  /// **'בחר מסלול סריקה'**
  String get manualScannerSelectScanTrack;

  /// No description provided for @manualScannerAddPage.
  ///
  /// In he, this message translates to:
  /// **'הוסף עמוד'**
  String get manualScannerAddPage;

  /// No description provided for @manualScannerFinishScan.
  ///
  /// In he, this message translates to:
  /// **'סיים סריקה'**
  String get manualScannerFinishScan;

  /// No description provided for @manualScannerApplyFilter.
  ///
  /// In he, this message translates to:
  /// **'החל פילטר שחור/לבן'**
  String get manualScannerApplyFilter;

  /// No description provided for @manualScannerFilterBw.
  ///
  /// In he, this message translates to:
  /// **'מסמך שחור/לבן'**
  String get manualScannerFilterBw;

  /// No description provided for @manualScannerFilterGrayscale.
  ///
  /// In he, this message translates to:
  /// **'גווני אפור'**
  String get manualScannerFilterGrayscale;

  /// No description provided for @manualScannerFilterContrast.
  ///
  /// In he, this message translates to:
  /// **'ניגודיות גבוהה'**
  String get manualScannerFilterContrast;

  /// No description provided for @manualScannerFilterThreshold.
  ///
  /// In he, this message translates to:
  /// **'סף שחור/לבן'**
  String get manualScannerFilterThreshold;

  /// No description provided for @manualScannerFilterCleanDocument.
  ///
  /// In he, this message translates to:
  /// **'ניקוי מסמך'**
  String get manualScannerFilterCleanDocument;

  /// No description provided for @supplierNameField.
  ///
  /// In he, this message translates to:
  /// **'שם ספק'**
  String get supplierNameField;

  /// No description provided for @allocationNumber.
  ///
  /// In he, this message translates to:
  /// **'מספר הקצאה'**
  String get allocationNumber;

  /// No description provided for @paymentDueDate.
  ///
  /// In he, this message translates to:
  /// **'תאריך פירעון'**
  String get paymentDueDate;

  /// No description provided for @warehouseField.
  ///
  /// In he, this message translates to:
  /// **'מחסן יעד'**
  String get warehouseField;

  /// No description provided for @warehouseLoading.
  ///
  /// In he, this message translates to:
  /// **'טוען מחסנים…'**
  String get warehouseLoading;

  /// No description provided for @warehousesEmpty.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו מחסנים'**
  String get warehousesEmpty;

  /// No description provided for @warehouseCodePrefix.
  ///
  /// In he, this message translates to:
  /// **'קוד'**
  String get warehouseCodePrefix;

  /// No description provided for @colDiscountPercent.
  ///
  /// In he, this message translates to:
  /// **'אחוז הנחה'**
  String get colDiscountPercent;

  /// No description provided for @colPackagingDepositTax.
  ///
  /// In he, this message translates to:
  /// **'אריזה/מס/פיקדון'**
  String get colPackagingDepositTax;

  /// No description provided for @colFinalUnitPrice.
  ///
  /// In he, this message translates to:
  /// **'מחיר ליח\' סופי'**
  String get colFinalUnitPrice;

  /// No description provided for @loadingSuppliers.
  ///
  /// In he, this message translates to:
  /// **'טוען ספקים…'**
  String get loadingSuppliers;

  /// No description provided for @suppliersLoadError.
  ///
  /// In he, this message translates to:
  /// **'שגיאה בטעינת ספקים'**
  String get suppliersLoadError;

  /// No description provided for @retry.
  ///
  /// In he, this message translates to:
  /// **'נסה שוב'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In he, this message translates to:
  /// **'אישור'**
  String get ok;

  /// No description provided for @runSyncButton.
  ///
  /// In he, this message translates to:
  /// **'סנכרון'**
  String get runSyncButton;

  /// No description provided for @syncConfirmTitle.
  ///
  /// In he, this message translates to:
  /// **'הרצת סנכרון מ-Comax'**
  String get syncConfirmTitle;

  /// No description provided for @syncConfirmMessage.
  ///
  /// In he, this message translates to:
  /// **'הסנכרון מתחבר ל-Comax שלך ומושך מחדש את כל הנתונים (ספקים, מוצרים, מחירים ומבצעים).\n\nכדי שהסנכרון יצליח עליך להיות מנותק מהמשתמש שלך ב-Comax — מערכת Comax מאפשרת חיבור יחיד בלבד. נתק/י קודם את המשתמש ב-Comax, ואז המשך/י.'**
  String get syncConfirmMessage;

  /// No description provided for @syncConfirmContinue.
  ///
  /// In he, this message translates to:
  /// **'התנתקתי — הרץ סנכרון'**
  String get syncConfirmContinue;

  /// No description provided for @syncing.
  ///
  /// In he, this message translates to:
  /// **'מבצע סנכרון...'**
  String get syncing;

  /// No description provided for @syncDone.
  ///
  /// In he, this message translates to:
  /// **'סונכרן בהצלחה'**
  String get syncDone;

  /// No description provided for @syncDoneMessage.
  ///
  /// In he, this message translates to:
  /// **'נתוני הספקים והמוצרים עודכנו מ-Comax.'**
  String get syncDoneMessage;

  /// No description provided for @syncErrorTitle.
  ///
  /// In he, this message translates to:
  /// **'שגיאת סנכרון'**
  String get syncErrorTitle;

  /// No description provided for @syncSessionInUse.
  ///
  /// In he, this message translates to:
  /// **'יש משתמש מחובר ל-Comax. התנתק מ-Comax, המתן כ-3 דקות, ונסה שוב.'**
  String get syncSessionInUse;

  /// No description provided for @syncBadCredentials.
  ///
  /// In he, this message translates to:
  /// **'נדרש עדכון הרשאות במערכת הניהול.'**
  String get syncBadCredentials;

  /// No description provided for @syncFailed.
  ///
  /// In he, this message translates to:
  /// **'הסנכרון נכשל, נסה שוב מאוחר יותר.'**
  String get syncFailed;

  /// No description provided for @syncRateLimited.
  ///
  /// In he, this message translates to:
  /// **'נסה שוב בעוד דקה.'**
  String get syncRateLimited;

  /// No description provided for @syncNoPermission.
  ///
  /// In he, this message translates to:
  /// **'למפתח אין הרשאה להריץ שליפה.'**
  String get syncNoPermission;

  /// No description provided for @syncTimeout.
  ///
  /// In he, this message translates to:
  /// **'הסנכרון אורך זמן רב מהצפוי, בדוק שוב מאוחר יותר.'**
  String get syncTimeout;

  /// No description provided for @rotateScreen.
  ///
  /// In he, this message translates to:
  /// **'סובב מסך'**
  String get rotateScreen;

  /// No description provided for @editBarcodeTitle.
  ///
  /// In he, this message translates to:
  /// **'מס\' פריט / ברקוד'**
  String get editBarcodeTitle;

  /// No description provided for @barcodeLabel.
  ///
  /// In he, this message translates to:
  /// **'ברקוד'**
  String get barcodeLabel;

  /// No description provided for @scanBarcodeTooltip.
  ///
  /// In he, this message translates to:
  /// **'סרוק ברקוד'**
  String get scanBarcodeTooltip;

  /// No description provided for @barcodeInCatalog.
  ///
  /// In he, this message translates to:
  /// **'קיים בקטלוג'**
  String get barcodeInCatalog;

  /// No description provided for @barcodeNotInCatalog.
  ///
  /// In he, this message translates to:
  /// **'אינו בקטלוג — ייתכן שזהו ברקוד חלופי; בחר את הברקוד הראשי של המוצר'**
  String get barcodeNotInCatalog;

  /// No description provided for @searchByProductName.
  ///
  /// In he, this message translates to:
  /// **'חיפוש מוצר לפי שם'**
  String get searchByProductName;

  /// No description provided for @productSearchHint.
  ///
  /// In he, this message translates to:
  /// **'הקלד שם מוצר…'**
  String get productSearchHint;

  /// No description provided for @noProductsFound.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו מוצרים'**
  String get noProductsFound;

  /// No description provided for @catalogLoading.
  ///
  /// In he, this message translates to:
  /// **'טוען קטלוג מוצרים…'**
  String get catalogLoading;

  /// No description provided for @barcodeIssuesTitle.
  ///
  /// In he, this message translates to:
  /// **'ברקודים שאינם קיימים בקטלוג'**
  String get barcodeIssuesTitle;

  /// No description provided for @barcodeIssuesMessage.
  ///
  /// In he, this message translates to:
  /// **'יש מוצרים שהברקוד שלהם אינו קיים בקטלוג. ייתכן שמדובר בברקוד חלופי — יש לבחור את הברקוד הראשי של המוצר. לא ניתן לשלוח לקופה עד לתיקון.'**
  String get barcodeIssuesMessage;

  /// No description provided for @jumpToFirstIssue.
  ///
  /// In he, this message translates to:
  /// **'קפוץ לבעיה הראשונה'**
  String get jumpToFirstIssue;

  /// No description provided for @validating.
  ///
  /// In he, this message translates to:
  /// **'מאמת...'**
  String get validating;

  /// No description provided for @validationSuccessTitle.
  ///
  /// In he, this message translates to:
  /// **'הנתונים תקינים'**
  String get validationSuccessTitle;

  /// No description provided for @validationSuccessMessage.
  ///
  /// In he, this message translates to:
  /// **'הנתונים תקינים ומוכנים לקליטה לקופה.'**
  String get validationSuccessMessage;

  /// No description provided for @validationErrorsTitle.
  ///
  /// In he, this message translates to:
  /// **'נמצאו בעיות לתיקון'**
  String get validationErrorsTitle;

  /// No description provided for @validationFailedTitle.
  ///
  /// In he, this message translates to:
  /// **'האימות נכשל'**
  String get validationFailedTitle;

  /// No description provided for @validationNetworkErrorTitle.
  ///
  /// In he, this message translates to:
  /// **'בעיית תקשורת'**
  String get validationNetworkErrorTitle;

  /// No description provided for @validationNetworkErrorMessage.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן היה לפנות לשרת. בדוק את החיבור ונסה שוב.'**
  String get validationNetworkErrorMessage;

  /// No description provided for @validationConfigError.
  ///
  /// In he, this message translates to:
  /// **'תקלת הגדרה במערכת. פנה לתמיכה (הרשאות/קוד לקוח).'**
  String get validationConfigError;

  /// No description provided for @validationRateLimited.
  ///
  /// In he, this message translates to:
  /// **'יותר מדי בקשות. נסה שוב בעוד רגע.'**
  String get validationRateLimited;

  /// No description provided for @validationGenericError.
  ///
  /// In he, this message translates to:
  /// **'האימות נכשל, נסה שוב מאוחר יותר.'**
  String get validationGenericError;

  /// No description provided for @lineLabel.
  ///
  /// In he, this message translates to:
  /// **'שורה'**
  String get lineLabel;

  /// No description provided for @suggestionsLabel.
  ///
  /// In he, this message translates to:
  /// **'הצעות'**
  String get suggestionsLabel;

  /// No description provided for @chooseCorrectSupplier.
  ///
  /// In he, this message translates to:
  /// **'בחר את הספק הנכון'**
  String get chooseCorrectSupplier;

  /// No description provided for @submitting.
  ///
  /// In he, this message translates to:
  /// **'שולח לקופה...'**
  String get submitting;

  /// No description provided for @submitBackground.
  ///
  /// In he, this message translates to:
  /// **'ממשיך ברקע…'**
  String get submitBackground;

  /// No description provided for @submitSuccessTitle.
  ///
  /// In he, this message translates to:
  /// **'נקלט בהצלחה'**
  String get submitSuccessTitle;

  /// No description provided for @submitSuccessMessage.
  ///
  /// In he, this message translates to:
  /// **'החשבונית נקלטה ל-Comax בהצלחה.'**
  String get submitSuccessMessage;

  /// No description provided for @submitErrorTitle.
  ///
  /// In he, this message translates to:
  /// **'השליחה לקופה נכשלה'**
  String get submitErrorTitle;

  /// No description provided for @submitNetworkError.
  ///
  /// In he, this message translates to:
  /// **'בעיית תקשורת בשליחה לקופה. נסה שוב.'**
  String get submitNetworkError;

  /// No description provided for @submitGenericError.
  ///
  /// In he, this message translates to:
  /// **'השליחה לקופה נכשלה, נסה שוב.'**
  String get submitGenericError;

  /// No description provided for @submitTimeout.
  ///
  /// In he, this message translates to:
  /// **'הקליטה נמשכת זמן רב. בדוק מאוחר יותר אם החשבונית נקלטה.'**
  String get submitTimeout;

  /// No description provided for @submitAlreadyReceivedTitle.
  ///
  /// In he, this message translates to:
  /// **'החשבונית כבר נקלטה'**
  String get submitAlreadyReceivedTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In he, this message translates to:
  /// **'הגדרות'**
  String get settingsTitle;

  /// No description provided for @customerCodeLabel.
  ///
  /// In he, this message translates to:
  /// **'קוד לקוח'**
  String get customerCodeLabel;

  /// No description provided for @customerCodeHint.
  ///
  /// In he, this message translates to:
  /// **'הזן קוד לקוח'**
  String get customerCodeHint;

  /// No description provided for @scanModelLabel.
  ///
  /// In he, this message translates to:
  /// **'מודל סריקה'**
  String get scanModelLabel;

  /// No description provided for @createNewProductButton.
  ///
  /// In he, this message translates to:
  /// **'צור פריט חדש'**
  String get createNewProductButton;

  /// No description provided for @editNewProductButton.
  ///
  /// In he, this message translates to:
  /// **'ערוך פריט חדש'**
  String get editNewProductButton;

  /// No description provided for @newProductTitle.
  ///
  /// In he, this message translates to:
  /// **'פריט חדש'**
  String get newProductTitle;

  /// No description provided for @editProductTitle.
  ///
  /// In he, this message translates to:
  /// **'עריכת פריט'**
  String get editProductTitle;

  /// No description provided for @npItem.
  ///
  /// In he, this message translates to:
  /// **'פריט'**
  String get npItem;

  /// No description provided for @npBarcode.
  ///
  /// In he, this message translates to:
  /// **'ברקוד'**
  String get npBarcode;

  /// No description provided for @npName.
  ///
  /// In he, this message translates to:
  /// **'שם'**
  String get npName;

  /// No description provided for @npDepartment.
  ///
  /// In he, this message translates to:
  /// **'מחלקה'**
  String get npDepartment;

  /// No description provided for @npGroup.
  ///
  /// In he, this message translates to:
  /// **'קבוצה'**
  String get npGroup;

  /// No description provided for @npMainSupplier.
  ///
  /// In he, this message translates to:
  /// **'ספק ראשי'**
  String get npMainSupplier;

  /// No description provided for @npSupplierItem.
  ///
  /// In he, this message translates to:
  /// **'פריט ספק'**
  String get npSupplierItem;

  /// No description provided for @npSupplierPrice.
  ///
  /// In he, this message translates to:
  /// **'מחיר ספק'**
  String get npSupplierPrice;

  /// No description provided for @npDiscountPct.
  ///
  /// In he, this message translates to:
  /// **'% הנחה'**
  String get npDiscountPct;

  /// No description provided for @npProfitPct.
  ///
  /// In he, this message translates to:
  /// **'% רווח'**
  String get npProfitPct;

  /// No description provided for @npSalePrice.
  ///
  /// In he, this message translates to:
  /// **'מחיר מכירה'**
  String get npSalePrice;

  /// No description provided for @npManageDeposit.
  ///
  /// In he, this message translates to:
  /// **'ניהול פיקדון'**
  String get npManageDeposit;

  /// No description provided for @npDraggedToRegister.
  ///
  /// In he, this message translates to:
  /// **'נגרר לקופה'**
  String get npDraggedToRegister;

  /// No description provided for @npDepositItem.
  ///
  /// In he, this message translates to:
  /// **'פריט פקדון'**
  String get npDepositItem;

  /// No description provided for @npMisc.
  ///
  /// In he, this message translates to:
  /// **'שונות'**
  String get npMisc;

  /// No description provided for @npRequiredMissing.
  ///
  /// In he, this message translates to:
  /// **'יש למלא את כל שדות החובה'**
  String get npRequiredMissing;

  /// No description provided for @npSelectDepartmentFirst.
  ///
  /// In he, this message translates to:
  /// **'בחר מחלקה תחילה'**
  String get npSelectDepartmentFirst;

  /// No description provided for @selectHint.
  ///
  /// In he, this message translates to:
  /// **'בחר'**
  String get selectHint;

  /// No description provided for @tbdOptions.
  ///
  /// In he, this message translates to:
  /// **'יוגדר בהמשך'**
  String get tbdOptions;

  /// No description provided for @loadingEllipsis.
  ///
  /// In he, this message translates to:
  /// **'טוען…'**
  String get loadingEllipsis;

  /// No description provided for @searchHintGeneric.
  ///
  /// In he, this message translates to:
  /// **'חיפוש…'**
  String get searchHintGeneric;

  /// No description provided for @npSectionItem.
  ///
  /// In he, this message translates to:
  /// **'זיהוי הפריט'**
  String get npSectionItem;

  /// No description provided for @npSectionClassification.
  ///
  /// In he, this message translates to:
  /// **'שיוך'**
  String get npSectionClassification;

  /// No description provided for @npSectionPricing.
  ///
  /// In he, this message translates to:
  /// **'תמחור'**
  String get npSectionPricing;

  /// No description provided for @npSectionPackaging.
  ///
  /// In he, this message translates to:
  /// **'אריזה והמרות'**
  String get npSectionPackaging;

  /// No description provided for @npSectionDeposit.
  ///
  /// In he, this message translates to:
  /// **'פקדון ומאפיינים'**
  String get npSectionDeposit;

  /// No description provided for @npSectionRegisterClub.
  ///
  /// In he, this message translates to:
  /// **'קופה ומועדון'**
  String get npSectionRegisterClub;

  /// No description provided for @npUnit.
  ///
  /// In he, this message translates to:
  /// **'מידה'**
  String get npUnit;

  /// No description provided for @npWeighable.
  ///
  /// In he, this message translates to:
  /// **'שקיל'**
  String get npWeighable;

  /// No description provided for @npNoSupplierDiscount.
  ///
  /// In he, this message translates to:
  /// **'ללא הנחת ספק'**
  String get npNoSupplierDiscount;

  /// No description provided for @npConversionQty.
  ///
  /// In he, this message translates to:
  /// **'המרה'**
  String get npConversionQty;

  /// No description provided for @npConversionUnit.
  ///
  /// In he, this message translates to:
  /// **'המרה ב'**
  String get npConversionUnit;

  /// No description provided for @npPackageWeight.
  ///
  /// In he, this message translates to:
  /// **'משקל אריזה'**
  String get npPackageWeight;

  /// No description provided for @npCalcQty.
  ///
  /// In he, this message translates to:
  /// **'כמות לחישוב'**
  String get npCalcQty;

  /// No description provided for @npDelicatessen.
  ///
  /// In he, this message translates to:
  /// **'מעדניה'**
  String get npDelicatessen;

  /// No description provided for @npClubCode.
  ///
  /// In he, this message translates to:
  /// **'קוד מועדון'**
  String get npClubCode;

  /// No description provided for @npRegisterDiscount.
  ///
  /// In he, this message translates to:
  /// **'הנחת קופה'**
  String get npRegisterDiscount;

  /// No description provided for @npPromotion.
  ///
  /// In he, this message translates to:
  /// **'מבצע'**
  String get npPromotion;

  /// No description provided for @npSalePriceEstimate.
  ///
  /// In he, this message translates to:
  /// **'הערכה — הערך הסופי נקבע באימות מול הקופה'**
  String get npSalePriceEstimate;

  /// No description provided for @npRequiredField.
  ///
  /// In he, this message translates to:
  /// **'שדה חובה'**
  String get npRequiredField;

  /// No description provided for @npDigitsOnly.
  ///
  /// In he, this message translates to:
  /// **'ספרות בלבד'**
  String get npDigitsOnly;

  /// No description provided for @npInvalidBarcode.
  ///
  /// In he, this message translates to:
  /// **'ברקוד לא תקין'**
  String get npInvalidBarcode;

  /// No description provided for @npProfitTooHigh.
  ///
  /// In he, this message translates to:
  /// **'% רווח חייב להיות קטן מ-100'**
  String get npProfitTooHigh;

  /// No description provided for @npDiscountRange.
  ///
  /// In he, this message translates to:
  /// **'% הנחה חייב להיות בין 0 ל-100'**
  String get npDiscountRange;

  /// No description provided for @npOptionsError.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לטעון את רשימות הבחירה'**
  String get npOptionsError;

  /// No description provided for @npOptionsNoData.
  ///
  /// In he, this message translates to:
  /// **'עדיין לא נשלפו נתוני קופה עבור לקוח זה'**
  String get npOptionsNoData;

  /// No description provided for @npNone.
  ///
  /// In he, this message translates to:
  /// **'ללא'**
  String get npNone;

  /// No description provided for @npSave.
  ///
  /// In he, this message translates to:
  /// **'שמור פריט'**
  String get npSave;

  /// No description provided for @npDelete.
  ///
  /// In he, this message translates to:
  /// **'מחק פריט חדש'**
  String get npDelete;

  /// No description provided for @npDeleteConfirm.
  ///
  /// In he, this message translates to:
  /// **'למחוק את הפריט החדש מהשורה?'**
  String get npDeleteConfirm;

  /// No description provided for @npBadge.
  ///
  /// In he, this message translates to:
  /// **'פריט חדש'**
  String get npBadge;

  /// No description provided for @npConfirmTitle.
  ///
  /// In he, this message translates to:
  /// **'אישור יצירת פריטים חדשים'**
  String get npConfirmTitle;

  /// No description provided for @npConfirmIrreversible.
  ///
  /// In he, this message translates to:
  /// **'יצירת פריט בקומקס אינה הפיכה — לא ניתן למחוק פריט, רק להעביר לארכיון.'**
  String get npConfirmIrreversible;

  /// No description provided for @npConfirmCount.
  ///
  /// In he, this message translates to:
  /// **'{count, plural, =1{פריט חדש אחד ייווצר בקופה:} other{{count} פריטים חדשים ייווצרו בקופה:}}'**
  String npConfirmCount(int count);

  /// No description provided for @npConfirmAction.
  ///
  /// In he, this message translates to:
  /// **'אשר ושלח לקופה'**
  String get npConfirmAction;

  /// No description provided for @scannerUnknownFailure.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לפתוח את הסורק. נסה שוב.'**
  String get scannerUnknownFailure;

  /// No description provided for @suggestedMatches.
  ///
  /// In he, this message translates to:
  /// **'התאמות מוצעות'**
  String get suggestedMatches;

  /// No description provided for @resolvingBarcodes.
  ///
  /// In he, this message translates to:
  /// **'מזהה ברקודים מהקטלוג…'**
  String get resolvingBarcodes;

  /// No description provided for @autoFilledBarcodesTitle.
  ///
  /// In he, this message translates to:
  /// **'שורות שהושלמו אוטומטית'**
  String get autoFilledBarcodesTitle;

  /// No description provided for @autoFilledBarcodesSubtitle.
  ///
  /// In he, this message translates to:
  /// **'הברקוד שוחזר מהקטלוג לפי שם ומחיר. כדאי לוודא את השורות המסומנות בכתום לפני שליחה לקופה.'**
  String get autoFilledBarcodesSubtitle;

  /// No description provided for @duplicateFoundTitle.
  ///
  /// In he, this message translates to:
  /// **'החשבונית כבר קיימת ב-Comax'**
  String get duplicateFoundTitle;

  /// No description provided for @duplicateSimilarTitle.
  ///
  /// In he, this message translates to:
  /// **'נמצאה חשבונית דומה ב-Comax'**
  String get duplicateSimilarTitle;

  /// No description provided for @duplicateReversedTitle.
  ///
  /// In he, this message translates to:
  /// **'מסמך זה היה קיים ב-Comax אך בוטל — ניתן לשלוח שוב'**
  String get duplicateReversedTitle;

  /// No description provided for @comaxDocumentLabel.
  ///
  /// In he, this message translates to:
  /// **'מסמך'**
  String get comaxDocumentLabel;

  /// No description provided for @duplicateSnapshotNote.
  ///
  /// In he, this message translates to:
  /// **'הנתונים נכונים לשליפה האחרונה מ-Comax:'**
  String get duplicateSnapshotNote;

  /// No description provided for @duplicateReferenceLabel.
  ///
  /// In he, this message translates to:
  /// **'אסמכתא ב-Comax:'**
  String get duplicateReferenceLabel;

  /// No description provided for @duplicateSuffixExplain.
  ///
  /// In he, this message translates to:
  /// **'סיומת של מספר החשבונית'**
  String get duplicateSuffixExplain;

  /// No description provided for @consistencyBlockTitle.
  ///
  /// In he, this message translates to:
  /// **'המספרים בחשבונית אינם מתחברים'**
  String get consistencyBlockTitle;

  /// No description provided for @consistencyBlockSubtitle.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לשלוח לקופה עד שהמספרים יתוקנו. ה-OCR כנראה קרא שורות בצורה שגויה:'**
  String get consistencyBlockSubtitle;

  /// No description provided for @consistencyBannerSubtitle.
  ///
  /// In he, this message translates to:
  /// **'סכום השורות אינו תואם לסה\"כ. בדוק את השורות המסומנות לפני שליחה לקופה.'**
  String get consistencyBannerSubtitle;

  /// No description provided for @consistencyWarnTitle.
  ///
  /// In he, this message translates to:
  /// **'הסכום בחשבונית שונה מהחישוב'**
  String get consistencyWarnTitle;

  /// No description provided for @consistencyWarnQuestion.
  ///
  /// In he, this message translates to:
  /// **'לשלוח לקופה בכל זאת?'**
  String get consistencyWarnQuestion;

  /// No description provided for @consistencyWarnSendAnyway.
  ///
  /// In he, this message translates to:
  /// **'שלח בכל זאת'**
  String get consistencyWarnSendAnyway;

  /// No description provided for @filterBySupplier.
  ///
  /// In he, this message translates to:
  /// **'הצג רק מוצרים של ספק החשבונית'**
  String get filterBySupplier;

  /// No description provided for @fromInvoiceLabel.
  ///
  /// In he, this message translates to:
  /// **'מהחשבונית:'**
  String get fromInvoiceLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
