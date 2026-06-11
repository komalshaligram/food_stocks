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
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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

  /// No description provided for @app_language.
  ///
  /// In he, this message translates to:
  /// **'שפה עברית'**
  String get app_language;

  /// No description provided for @register.
  ///
  /// In he, this message translates to:
  /// **'הרשמה'**
  String get register;

  /// No description provided for @login.
  ///
  /// In he, this message translates to:
  /// **'התחברות'**
  String get login;

  /// No description provided for @business_details.
  ///
  /// In he, this message translates to:
  /// **'פרטי עסק'**
  String get business_details;

  /// No description provided for @type_of_picture.
  ///
  /// In he, this message translates to:
  /// **'סוג תמונה'**
  String get type_of_picture;

  /// No description provided for @type_of_business.
  ///
  /// In he, this message translates to:
  /// **'סוג העסק'**
  String get type_of_business;

  /// No description provided for @profile_picture.
  ///
  /// In he, this message translates to:
  /// **'תמונת פרופיל'**
  String get profile_picture;

  /// No description provided for @institutional.
  ///
  /// In he, this message translates to:
  /// **'מוסדי'**
  String get institutional;

  /// No description provided for @business_name.
  ///
  /// In he, this message translates to:
  /// **' שם העסק'**
  String get business_name;

  /// No description provided for @address.
  ///
  /// In he, this message translates to:
  /// **'כתובת העסק'**
  String get address;

  /// No description provided for @name_of_owner.
  ///
  /// In he, this message translates to:
  /// **'שם בעלים'**
  String get name_of_owner;

  /// No description provided for @next.
  ///
  /// In he, this message translates to:
  /// **'המשך'**
  String get next;

  /// No description provided for @more_details.
  ///
  /// In he, this message translates to:
  /// **'פרטי העסק'**
  String get more_details;

  /// No description provided for @client_form_details.
  ///
  /// In he, this message translates to:
  /// **'פרטי לקוח'**
  String get client_form_details;

  /// No description provided for @full_address.
  ///
  /// In he, this message translates to:
  /// **'כתובת מלאה'**
  String get full_address;

  /// No description provided for @email.
  ///
  /// In he, this message translates to:
  /// **'דוא”ל'**
  String get email;

  /// No description provided for @fax.
  ///
  /// In he, this message translates to:
  /// **'פקס'**
  String get fax;

  /// No description provided for @logo_image.
  ///
  /// In he, this message translates to:
  /// **'תמונת לוגו'**
  String get logo_image;

  /// No description provided for @upload_photo.
  ///
  /// In he, this message translates to:
  /// **'העלה תמונה'**
  String get upload_photo;

  /// No description provided for @activity_time.
  ///
  /// In he, this message translates to:
  /// **'זמני פעילות'**
  String get activity_time;

  /// No description provided for @until_time.
  ///
  /// In he, this message translates to:
  /// **'עד שעה'**
  String get until_time;

  /// No description provided for @from_time.
  ///
  /// In he, this message translates to:
  /// **'משעה'**
  String get from_time;

  /// No description provided for @sunday.
  ///
  /// In he, this message translates to:
  /// **'יום ראשון'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In he, this message translates to:
  /// **'יום שני'**
  String get monday;

  /// No description provided for @wednesday.
  ///
  /// In he, this message translates to:
  /// **'יום רביעי'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In he, this message translates to:
  /// **'יום חמישי'**
  String get thursday;

  /// No description provided for @friday_and_holiday_eves.
  ///
  /// In he, this message translates to:
  /// **'יום שישי וערבי חג'**
  String get friday_and_holiday_eves;

  /// No description provided for @contact_name.
  ///
  /// In he, this message translates to:
  /// **'איש קשר'**
  String get contact_name;

  /// No description provided for @israel_id.
  ///
  /// In he, this message translates to:
  /// **'תעודת זהות'**
  String get israel_id;

  /// No description provided for @city.
  ///
  /// In he, this message translates to:
  /// **'עיר / עיר של העסק'**
  String get city;

  /// No description provided for @skip.
  ///
  /// In he, this message translates to:
  /// **'דלג'**
  String get skip;

  /// No description provided for @files.
  ///
  /// In he, this message translates to:
  /// **'קבצים'**
  String get files;

  /// No description provided for @remove.
  ///
  /// In he, this message translates to:
  /// **'מחק תמונה'**
  String get remove;

  /// No description provided for @download.
  ///
  /// In he, this message translates to:
  /// **'הורד'**
  String get download;

  /// No description provided for @promissory_note.
  ///
  /// In he, this message translates to:
  /// **'שטר חוב'**
  String get promissory_note;

  /// No description provided for @personal_guarantee.
  ///
  /// In he, this message translates to:
  /// **'ערבות אישית'**
  String get personal_guarantee;

  /// No description provided for @photo_tz.
  ///
  /// In he, this message translates to:
  /// **'צילום ת.ז.'**
  String get photo_tz;

  /// No description provided for @business_certificate.
  ///
  /// In he, this message translates to:
  /// **'תעודת עסק'**
  String get business_certificate;

  /// No description provided for @saturday_and_holidays.
  ///
  /// In he, this message translates to:
  /// **'יום שבת וחגים'**
  String get saturday_and_holidays;

  /// No description provided for @tuesday.
  ///
  /// In he, this message translates to:
  /// **'יום שלישי'**
  String get tuesday;

  /// No description provided for @business_id.
  ///
  /// In he, this message translates to:
  /// **'ח.פ.'**
  String get business_id;

  /// No description provided for @gallery.
  ///
  /// In he, this message translates to:
  /// **'גלריה'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In he, this message translates to:
  /// **'מצלמה'**
  String get camera;

  /// No description provided for @this_months_expenses.
  ///
  /// In he, this message translates to:
  /// **'הוצאות החודש'**
  String get this_months_expenses;

  /// No description provided for @this_months_orders.
  ///
  /// In he, this message translates to:
  /// **'הזמנות החודש'**
  String get this_months_orders;

  /// No description provided for @general_framework.
  ///
  /// In he, this message translates to:
  /// **'מסגרת כללית'**
  String get general_framework;

  /// No description provided for @last_months_expenses.
  ///
  /// In he, this message translates to:
  /// **'הוצאות חודש שעבר'**
  String get last_months_expenses;

  /// No description provided for @balance_status.
  ///
  /// In he, this message translates to:
  /// **'יתרה לניצול'**
  String get balance_status;

  /// No description provided for @currency.
  ///
  /// In he, this message translates to:
  /// **'₪'**
  String get currency;

  /// No description provided for @all_sales.
  ///
  /// In he, this message translates to:
  /// **'כל המבצעים'**
  String get all_sales;

  /// No description provided for @sales.
  ///
  /// In he, this message translates to:
  /// **'לצפיה בכל המבצעים'**
  String get sales;

  /// No description provided for @my_basket.
  ///
  /// In he, this message translates to:
  /// **'הסל שלי'**
  String get my_basket;

  /// No description provided for @new_order.
  ///
  /// In he, this message translates to:
  /// **'הזמנה חדשה'**
  String get new_order;

  /// No description provided for @all_messages.
  ///
  /// In he, this message translates to:
  /// **'כל ההודעות'**
  String get all_messages;

  /// No description provided for @messages.
  ///
  /// In he, this message translates to:
  /// **'הודעות'**
  String get messages;

  /// No description provided for @read_more.
  ///
  /// In he, this message translates to:
  /// **'קרא עוד'**
  String get read_more;

  /// No description provided for @menu.
  ///
  /// In he, this message translates to:
  /// **'תפריט'**
  String get menu;

  /// No description provided for @my_orders.
  ///
  /// In he, this message translates to:
  /// **'ההזמנות שלי'**
  String get my_orders;

  /// No description provided for @certificate_scanning.
  ///
  /// In he, this message translates to:
  /// **'סריקת תעודות'**
  String get certificate_scanning;

  /// No description provided for @questions_and_answers.
  ///
  /// In he, this message translates to:
  /// **'שאלות ותשובות'**
  String get questions_and_answers;

  /// No description provided for @terms_of_use.
  ///
  /// In he, this message translates to:
  /// **'תנאי שימוש'**
  String get terms_of_use;

  /// No description provided for @contact_us.
  ///
  /// In he, this message translates to:
  /// **'יצירת קשר'**
  String get contact_us;

  /// No description provided for @about_the_app.
  ///
  /// In he, this message translates to:
  /// **'אודות האפליקציה'**
  String get about_the_app;

  /// No description provided for @editing.
  ///
  /// In he, this message translates to:
  /// **'עריכה'**
  String get editing;

  /// No description provided for @delete.
  ///
  /// In he, this message translates to:
  /// **'מחק'**
  String get delete;

  /// No description provided for @message.
  ///
  /// In he, this message translates to:
  /// **'הוֹדָעָה'**
  String get message;

  /// No description provided for @orders.
  ///
  /// In he, this message translates to:
  /// **'הזמנות'**
  String get orders;

  /// No description provided for @supplier.
  ///
  /// In he, this message translates to:
  /// **'ספק'**
  String get supplier;

  /// No description provided for @order_status.
  ///
  /// In he, this message translates to:
  /// **'סטטוס הזמנה'**
  String get order_status;

  /// No description provided for @order_date.
  ///
  /// In he, this message translates to:
  /// **'תאריך הזמנה'**
  String get order_date;

  /// No description provided for @order_number.
  ///
  /// In he, this message translates to:
  /// **'מספר הזמנה'**
  String get order_number;

  /// No description provided for @suppliers.
  ///
  /// In he, this message translates to:
  /// **'ספקים'**
  String get suppliers;

  /// No description provided for @all_suppliers.
  ///
  /// In he, this message translates to:
  /// **'כל הספקים'**
  String get all_suppliers;

  /// No description provided for @products.
  ///
  /// In he, this message translates to:
  /// **'מוצרים'**
  String get products;

  /// No description provided for @received.
  ///
  /// In he, this message translates to:
  /// **'התקבל הכל'**
  String get received;

  /// No description provided for @enter_your_phone.
  ///
  /// In he, this message translates to:
  /// **'הזן את מספר הטלפון שלך'**
  String get enter_your_phone;

  /// No description provided for @phone.
  ///
  /// In he, this message translates to:
  /// **'טלפון'**
  String get phone;

  /// No description provided for @enter_the_code_sent_to_phone_num.
  ///
  /// In he, this message translates to:
  /// **'הזן את הקוד שנשלח למספר הטלפון שהזנת'**
  String get enter_the_code_sent_to_phone_num;

  /// No description provided for @not_receive_verification_code.
  ///
  /// In he, this message translates to:
  /// **'לא קיבלת קוד אימות ?'**
  String get not_receive_verification_code;

  /// No description provided for @send_again.
  ///
  /// In he, this message translates to:
  /// **'שלח שוב'**
  String get send_again;

  /// No description provided for @log_out.
  ///
  /// In he, this message translates to:
  /// **'התנתק'**
  String get log_out;

  /// No description provided for @save.
  ///
  /// In he, this message translates to:
  /// **'שמור'**
  String get save;

  /// No description provided for @brands.
  ///
  /// In he, this message translates to:
  /// **'מותגים'**
  String get brands;

  /// No description provided for @all_brands.
  ///
  /// In he, this message translates to:
  /// **'כל מותגים'**
  String get all_brands;

  /// No description provided for @total_order.
  ///
  /// In he, this message translates to:
  /// **'סה”כ הזמנה'**
  String get total_order;

  /// No description provided for @delivery_date.
  ///
  /// In he, this message translates to:
  /// **'תאריך משלוח'**
  String get delivery_date;

  /// No description provided for @everything_was_received.
  ///
  /// In he, this message translates to:
  /// **'התקבל הכל'**
  String get everything_was_received;

  /// No description provided for @total.
  ///
  /// In he, this message translates to:
  /// **'סה”כ'**
  String get total;

  /// No description provided for @pending_delivery.
  ///
  /// In he, this message translates to:
  /// **'Pending'**
  String get pending_delivery;

  /// No description provided for @supplier_order_number.
  ///
  /// In he, this message translates to:
  /// **'מספר הזמנה'**
  String get supplier_order_number;

  /// No description provided for @driver_name.
  ///
  /// In he, this message translates to:
  /// **'פרטי נהג'**
  String get driver_name;

  /// No description provided for @order_products_list.
  ///
  /// In he, this message translates to:
  /// **'רשימת מוצרים בהזמנה'**
  String get order_products_list;

  /// No description provided for @return_products_list.
  ///
  /// In he, this message translates to:
  /// **'רשימת מוצרים להחזרה'**
  String get return_products_list;

  /// No description provided for @product_Name.
  ///
  /// In he, this message translates to:
  /// **'שם המוצר'**
  String get product_Name;

  /// No description provided for @product_issue.
  ///
  /// In he, this message translates to:
  /// **'בעיה במוצר'**
  String get product_issue;

  /// No description provided for @shipment_verification.
  ///
  /// In he, this message translates to:
  /// **'אישור משלוח'**
  String get shipment_verification;

  /// No description provided for @driver_return.
  ///
  /// In he, this message translates to:
  /// **'החזרת נהג'**
  String get driver_return;

  /// No description provided for @signature.
  ///
  /// In he, this message translates to:
  /// **'חתימה'**
  String get signature;

  /// No description provided for @driver_signature.
  ///
  /// In he, this message translates to:
  /// **'חתימת נהג'**
  String get driver_signature;

  /// No description provided for @categories.
  ///
  /// In he, this message translates to:
  /// **'קטגוריות'**
  String get categories;

  /// No description provided for @all_categories.
  ///
  /// In he, this message translates to:
  /// **'כל הקטגוריות'**
  String get all_categories;

  /// No description provided for @recommended_for_you.
  ///
  /// In he, this message translates to:
  /// **'לצפיה בכל המומלצים בשבילך'**
  String get recommended_for_you;

  /// No description provided for @all_recommended.
  ///
  /// In he, this message translates to:
  /// **'כל המומלצים'**
  String get all_recommended;

  /// No description provided for @from_your_previous_orders.
  ///
  /// In he, this message translates to:
  /// **'מהזמנות קודמות שלך'**
  String get from_your_previous_orders;

  /// No description provided for @more.
  ///
  /// In he, this message translates to:
  /// **'הכל'**
  String get more;

  /// No description provided for @search.
  ///
  /// In he, this message translates to:
  /// **'חיפוש'**
  String get search;

  /// No description provided for @note.
  ///
  /// In he, this message translates to:
  /// **'הערה'**
  String get note;

  /// No description provided for @notes.
  ///
  /// In he, this message translates to:
  /// **'הערות'**
  String get notes;

  /// No description provided for @add_to_order.
  ///
  /// In he, this message translates to:
  /// **'הוסף להזמנה'**
  String get add_to_order;

  /// No description provided for @sale.
  ///
  /// In he, this message translates to:
  /// **'מבצע'**
  String get sale;

  /// No description provided for @main.
  ///
  /// In he, this message translates to:
  /// **'ראשי'**
  String get main;

  /// No description provided for @finish.
  ///
  /// In he, this message translates to:
  /// **'לתשלום'**
  String get finish;

  /// No description provided for @home.
  ///
  /// In he, this message translates to:
  /// **'ראשי'**
  String get home;

  /// No description provided for @problem_detected.
  ///
  /// In he, this message translates to:
  /// **'זוהתה בעיה'**
  String get problem_detected;

  /// No description provided for @product_did_not_arrive_at_all.
  ///
  /// In he, this message translates to:
  /// **'המוצר לא הגיע בכלל'**
  String get product_did_not_arrive_at_all;

  /// No description provided for @product_arrived_damaged.
  ///
  /// In he, this message translates to:
  /// **'המוצר הגיע פגום'**
  String get product_arrived_damaged;

  /// No description provided for @product_arrived_incomplete.
  ///
  /// In he, this message translates to:
  /// **'המוצר הגיע לא שלם'**
  String get product_arrived_incomplete;

  /// No description provided for @expiration_date_issue.
  ///
  /// In he, this message translates to:
  /// **'בעיית תאריך תפוגה'**
  String get expiration_date_issue;

  /// No description provided for @wrong_product_received.
  ///
  /// In he, this message translates to:
  /// **'התקבל מוצר שגוי'**
  String get wrong_product_received;

  /// No description provided for @add_text.
  ///
  /// In he, this message translates to:
  /// **'פרט'**
  String get add_text;

  /// No description provided for @submit.
  ///
  /// In he, this message translates to:
  /// **'לתשלום'**
  String get submit;

  /// No description provided for @continues.
  ///
  /// In he, this message translates to:
  /// **'המשך'**
  String get continues;

  /// No description provided for @empty.
  ///
  /// In he, this message translates to:
  /// **'רוקן סל'**
  String get empty;

  /// No description provided for @contact.
  ///
  /// In he, this message translates to:
  /// **'יצירת קשר'**
  String get contact;

  /// No description provided for @order_summary.
  ///
  /// In he, this message translates to:
  /// **'סיכום הזמנה'**
  String get order_summary;

  /// No description provided for @supplier_name.
  ///
  /// In he, this message translates to:
  /// **'שם ספק'**
  String get supplier_name;

  /// No description provided for @send_order.
  ///
  /// In he, this message translates to:
  /// **'שלח הזמנה'**
  String get send_order;

  /// No description provided for @planogram.
  ///
  /// In he, this message translates to:
  /// **'מוצרים נבחרים'**
  String get planogram;

  /// No description provided for @order_sent_successfully.
  ///
  /// In he, this message translates to:
  /// **'ההזמנה נשלחה בהצלחה'**
  String get order_sent_successfully;

  /// No description provided for @total_credit.
  ///
  /// In he, this message translates to:
  /// **'סך האשראי'**
  String get total_credit;

  /// No description provided for @back_to_home_page.
  ///
  /// In he, this message translates to:
  /// **'בחזרה לעמוד הבית'**
  String get back_to_home_page;

  /// No description provided for @kg.
  ///
  /// In he, this message translates to:
  /// **'ק”ג'**
  String get kg;

  /// No description provided for @monthly_expense_graph.
  ///
  /// In he, this message translates to:
  /// **'גרף הוצאות חודשיות'**
  String get monthly_expense_graph;

  /// No description provided for @history.
  ///
  /// In he, this message translates to:
  /// **'תנועות בארנק'**
  String get history;

  /// No description provided for @export.
  ///
  /// In he, this message translates to:
  /// **'יצוא'**
  String get export;

  /// No description provided for @jan.
  ///
  /// In he, this message translates to:
  /// **'ינו'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In he, this message translates to:
  /// **'פבר'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In he, this message translates to:
  /// **'מרץ'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In he, this message translates to:
  /// **'אפר'**
  String get apr;

  /// No description provided for @jun.
  ///
  /// In he, this message translates to:
  /// **'יונ'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In he, this message translates to:
  /// **'יול'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In he, this message translates to:
  /// **'אוג'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In he, this message translates to:
  /// **'ספט'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In he, this message translates to:
  /// **'אוק'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In he, this message translates to:
  /// **'נוב'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In he, this message translates to:
  /// **'דצמ'**
  String get dec;

  /// No description provided for @ok.
  ///
  /// In he, this message translates to:
  /// **'בסדר'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In he, this message translates to:
  /// **'לְבַטֵל'**
  String get cancel;

  /// No description provided for @see_all.
  ///
  /// In he, this message translates to:
  /// **'ראה הכל'**
  String get see_all;

  /// No description provided for @discount.
  ///
  /// In he, this message translates to:
  /// **'בהנחה'**
  String get discount;

  /// No description provided for @january.
  ///
  /// In he, this message translates to:
  /// **'יָנוּאָר'**
  String get january;

  /// No description provided for @february.
  ///
  /// In he, this message translates to:
  /// **'פברואר'**
  String get february;

  /// No description provided for @march.
  ///
  /// In he, this message translates to:
  /// **'מרץ'**
  String get march;

  /// No description provided for @april.
  ///
  /// In he, this message translates to:
  /// **'אַפּרִיל'**
  String get april;

  /// No description provided for @may.
  ///
  /// In he, this message translates to:
  /// **'מאי'**
  String get may;

  /// No description provided for @june.
  ///
  /// In he, this message translates to:
  /// **'יוני'**
  String get june;

  /// No description provided for @july.
  ///
  /// In he, this message translates to:
  /// **'יולי'**
  String get july;

  /// No description provided for @august.
  ///
  /// In he, this message translates to:
  /// **'אוגוסט'**
  String get august;

  /// No description provided for @september.
  ///
  /// In he, this message translates to:
  /// **'סֶפּטֶמבֶּר'**
  String get september;

  /// No description provided for @october.
  ///
  /// In he, this message translates to:
  /// **'אוֹקְטוֹבֶּר'**
  String get october;

  /// No description provided for @november.
  ///
  /// In he, this message translates to:
  /// **'נוֹבֶמבֶּר'**
  String get november;

  /// No description provided for @december.
  ///
  /// In he, this message translates to:
  /// **'דֵצֶמבֶּר'**
  String get december;

  /// No description provided for @no_data.
  ///
  /// In he, this message translates to:
  /// **'אין מידע'**
  String get no_data;

  /// No description provided for @no_invoice_file.
  ///
  /// In he, this message translates to:
  /// **'לא נמצא קובץ חשבונית'**
  String get no_invoice_file;

  /// No description provided for @no_invoice_data.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו נתוני חשבונית'**
  String get no_invoice_data;

  /// No description provided for @no_refund_data.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו נתוני החזר כספי'**
  String get no_refund_data;

  /// No description provided for @cart_empty.
  ///
  /// In he, this message translates to:
  /// **'העגלה שלך ריקה'**
  String get cart_empty;

  /// No description provided for @please_enter_email.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן כתובת מייל'**
  String get please_enter_email;

  /// No description provided for @please_enter_valid_email.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן כתובת מייל חוקית'**
  String get please_enter_valid_email;

  /// No description provided for @phone_number_cant_be_empty.
  ///
  /// In he, this message translates to:
  /// **'מספר טלפון לא יכול להיות ריק'**
  String get phone_number_cant_be_empty;

  /// No description provided for @please_enter_valid_phone_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר טלפון תקין'**
  String get please_enter_valid_phone_number;

  /// No description provided for @phone_number_must_be_10digit.
  ///
  /// In he, this message translates to:
  /// **'מספר טלפון צריך להיות בן 10 ספרות'**
  String get phone_number_must_be_10digit;

  /// No description provided for @please_enter_your_business_name.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן את שם העסק'**
  String get please_enter_your_business_name;

  /// No description provided for @please_enter_valid_business_name.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן את שם העסק תקין'**
  String get please_enter_valid_business_name;

  /// No description provided for @please_enter_alphabets_only.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן אותיות בלבד'**
  String get please_enter_alphabets_only;

  /// No description provided for @please_enter_valid_business_id.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר ח.פ. תקין'**
  String get please_enter_valid_business_id;

  /// No description provided for @please_enter_business_id.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר ח.פ.'**
  String get please_enter_business_id;

  /// No description provided for @please_enter_owner_name.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן שם בעל העסק'**
  String get please_enter_owner_name;

  /// No description provided for @please_enter_israel_id.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר ת.ז.'**
  String get please_enter_israel_id;

  /// No description provided for @please_enter_valid_israel_id.
  ///
  /// In he, this message translates to:
  /// **'נא להזין תעודה מזהה ישראלית תקפה'**
  String get please_enter_valid_israel_id;

  /// No description provided for @please_enter_contact_name.
  ///
  /// In he, this message translates to:
  /// **'אנא הזם שם איש קשר'**
  String get please_enter_contact_name;

  /// No description provided for @please_enter_address.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן כתובת'**
  String get please_enter_address;

  /// No description provided for @please_enter_fax_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר פקס'**
  String get please_enter_fax_number;

  /// No description provided for @please_enter_valid_fax_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר פקס תקין'**
  String get please_enter_valid_fax_number;

  /// No description provided for @logged_out_successfully.
  ///
  /// In he, this message translates to:
  /// **'התנתקת בהצלחה'**
  String get logged_out_successfully;

  /// No description provided for @are_you_sure.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח?'**
  String get are_you_sure;

  /// No description provided for @document.
  ///
  /// In he, this message translates to:
  /// **'קובץ'**
  String get document;

  /// No description provided for @registered_successfully.
  ///
  /// In he, this message translates to:
  /// **'נרשמת בהצלחה'**
  String get registered_successfully;

  /// No description provided for @updated_successfully.
  ///
  /// In he, this message translates to:
  /// **'עודכן בהצלחה'**
  String get updated_successfully;

  /// No description provided for @removed_successfully.
  ///
  /// In he, this message translates to:
  /// **'!הוסר בהצלחה'**
  String get removed_successfully;

  /// No description provided for @something_is_wrong_try_again.
  ///
  /// In he, this message translates to:
  /// **'!משהו השתבש, אנא נסה שנית'**
  String get something_is_wrong_try_again;

  /// No description provided for @image_not_set.
  ///
  /// In he, this message translates to:
  /// **'לא הוזנה תמונה'**
  String get image_not_set;

  /// No description provided for @file_size_must_be_less_then.
  ///
  /// In he, this message translates to:
  /// **'KB 1024 משקל הקובץ צריך להיות קטן מ'**
  String get file_size_must_be_less_then;

  /// No description provided for @please_select_opening_time_after_previous_closing_time.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר שעת פתיחה שונה מהקודמת'**
  String get please_select_opening_time_after_previous_closing_time;

  /// No description provided for @please_select_opening_time_before_closing_time.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר שעת פתיחה מוקדמת יותר משעת סגירה'**
  String get please_select_opening_time_before_closing_time;

  /// No description provided for @please_select_closing_time_after_opening_time.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר שעת סגירה מאוחרת יותר משעת פתיחה'**
  String get please_select_closing_time_after_opening_time;

  /// No description provided for @please_select_opening_time.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר שעת פתיחה'**
  String get please_select_opening_time;

  /// No description provided for @please_select_previous_shift_time.
  ///
  /// In he, this message translates to:
  /// **'אנא מלא את השעות הקודמות'**
  String get please_select_previous_shift_time;

  /// No description provided for @please_select_first_shift_time.
  ///
  /// In he, this message translates to:
  /// **'אנא מלא את השעות הראשונות'**
  String get please_select_first_shift_time;

  /// No description provided for @please_enter_otp.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן את הקוד'**
  String get please_enter_otp;

  /// No description provided for @please_select_time_grater_then_0.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר שעה גדולה יותר מ 00:00'**
  String get please_select_time_grater_then_0;

  /// No description provided for @please_fill_up_closing_time.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן שעת סגירה'**
  String get please_fill_up_closing_time;

  /// No description provided for @no_internet_connection.
  ///
  /// In he, this message translates to:
  /// **'אין חיבור לאינטרנט'**
  String get no_internet_connection;

  /// No description provided for @cities_not_available.
  ///
  /// In he, this message translates to:
  /// **'אין את רשימת הערים'**
  String get cities_not_available;

  /// No description provided for @select_supplier.
  ///
  /// In he, this message translates to:
  /// **'בחר ספק'**
  String get select_supplier;

  /// No description provided for @please_select_supplier.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר ספק'**
  String get please_select_supplier;

  /// No description provided for @suppliers_not_available.
  ///
  /// In he, this message translates to:
  /// **'לא קיים במלאי'**
  String get suppliers_not_available;

  /// No description provided for @search_result_not_found.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו תוצאות חיפוש'**
  String get search_result_not_found;

  /// No description provided for @products_not_available.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו מוצרים'**
  String get products_not_available;

  /// No description provided for @sub_categories_not_available.
  ///
  /// In he, this message translates to:
  /// **'תת קטגוריה לא קיימת'**
  String get sub_categories_not_available;

  /// No description provided for @messages_not_found.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו הודעות'**
  String get messages_not_found;

  /// No description provided for @currently_this_Supplier_has_no_products.
  ///
  /// In he, this message translates to:
  /// **'כרגע אין מוצרים עבור ספק זה'**
  String get currently_this_Supplier_has_no_products;

  /// No description provided for @currently_products_are_not_on_sale.
  ///
  /// In he, this message translates to:
  /// **'כרגע אין מוצרים במבצע'**
  String get currently_products_are_not_on_sale;

  /// No description provided for @recommendation_products_are_not_available.
  ///
  /// In he, this message translates to:
  /// **'מוצרים מומלצים לא קיימים'**
  String get recommendation_products_are_not_available;

  /// No description provided for @companies_not_available.
  ///
  /// In he, this message translates to:
  /// **'חברות לא קיימות'**
  String get companies_not_available;

  /// No description provided for @categories_not_available.
  ///
  /// In he, this message translates to:
  /// **'קטגוריות לא קיימות'**
  String get categories_not_available;

  /// No description provided for @forms_Files_not_available.
  ///
  /// In he, this message translates to:
  /// **'קבצים וטפסים לא קיימים'**
  String get forms_Files_not_available;

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

  /// No description provided for @qa_not_available.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו שאלות ותשובות'**
  String get qa_not_available;

  /// No description provided for @product_added_to_cart.
  ///
  /// In he, this message translates to:
  /// **'המוצר הוסף לסל הקניות'**
  String get product_added_to_cart;

  /// No description provided for @you_have_reached_maximum_quantity.
  ///
  /// In he, this message translates to:
  /// **'הגעת לכמות המקסימלית'**
  String get you_have_reached_maximum_quantity;

  /// No description provided for @downloaded_successfully.
  ///
  /// In he, this message translates to:
  /// **' !הורד בהצלחה'**
  String get downloaded_successfully;

  /// No description provided for @failed_download.
  ///
  /// In he, this message translates to:
  /// **'ההורדה נכשלה'**
  String get failed_download;

  /// No description provided for @camera_permission.
  ///
  /// In he, this message translates to:
  /// **'אנא אפשר הרשאות מצלמה'**
  String get camera_permission;

  /// No description provided for @storage_permission.
  ///
  /// In he, this message translates to:
  /// **'אנא אפשר הרשאות אכסון'**
  String get storage_permission;

  /// No description provided for @enter_4digit_otp.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן קוד בין 4 ספרות'**
  String get enter_4digit_otp;

  /// No description provided for @you_want_clear_cart.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח שאתה רוצה לאפס את סל הקניות?'**
  String get you_want_clear_cart;

  /// No description provided for @you_want_delete_product.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח שאתה רוצה למחוק את המוצר?'**
  String get you_want_delete_product;

  /// No description provided for @select_issue.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר סוג בעיה'**
  String get select_issue;

  /// No description provided for @select_checkbox.
  ///
  /// In he, this message translates to:
  /// **'נא סמן את כל תיבת הסימון'**
  String get select_checkbox;

  /// No description provided for @select_atleast_one_checkbox.
  ///
  /// In he, this message translates to:
  /// **'אנא סמנו לפחות תיבת סימון אחת'**
  String get select_atleast_one_checkbox;

  /// No description provided for @signature_missing.
  ///
  /// In he, this message translates to:
  /// **'אנא הוסף חתימה'**
  String get signature_missing;

  /// No description provided for @driver_signature_missing.
  ///
  /// In he, this message translates to:
  /// **'על הנהג לחתום פה'**
  String get driver_signature_missing;

  /// No description provided for @surface_validation.
  ///
  /// In he, this message translates to:
  /// **'הזנת מספר משטחים גדול מידי אנא נסה מספר נמוך יותר'**
  String get surface_validation;

  /// No description provided for @connection_timed_out.
  ///
  /// In he, this message translates to:
  /// **'בעיית  חיבור לשרת'**
  String get connection_timed_out;

  /// No description provided for @send_timed_out.
  ///
  /// In he, this message translates to:
  /// **'בעיית שליחה לשרת'**
  String get send_timed_out;

  /// No description provided for @receive_timed_out.
  ///
  /// In he, this message translates to:
  /// **'בעיית קבלה מהשרת'**
  String get receive_timed_out;

  /// No description provided for @bad_request.
  ///
  /// In he, this message translates to:
  /// **'בעיה בבקשה'**
  String get bad_request;

  /// No description provided for @bad_ssl_certificates.
  ///
  /// In he, this message translates to:
  /// **'Bad SSL certificates'**
  String get bad_ssl_certificates;

  /// No description provided for @permission_denied.
  ///
  /// In he, this message translates to:
  /// **'אין הרשאה'**
  String get permission_denied;

  /// No description provided for @server_internal_error.
  ///
  /// In he, this message translates to:
  /// **'בעייה פנימית בשרת'**
  String get server_internal_error;

  /// No description provided for @server_bad_response.
  ///
  /// In he, this message translates to:
  /// **'שגיאה בבקשה לשרת'**
  String get server_bad_response;

  /// No description provided for @server_canceled.
  ///
  /// In he, this message translates to:
  /// **'השרת דחה את הפנייה'**
  String get server_canceled;

  /// No description provided for @unknown_error.
  ///
  /// In he, this message translates to:
  /// **'בעיה לא ידועה'**
  String get unknown_error;

  /// No description provided for @login_successful.
  ///
  /// In he, this message translates to:
  /// **'התחברת בהצלחה'**
  String get login_successful;

  /// No description provided for @add_1_quantity.
  ///
  /// In he, this message translates to:
  /// **'בחר לפחות כמות אחת'**
  String get add_1_quantity;

  /// No description provided for @out_of_stock.
  ///
  /// In he, this message translates to:
  /// **'לא קיים במלאי'**
  String get out_of_stock;

  /// No description provided for @select_business_type.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר את סוג העסק'**
  String get select_business_type;

  /// No description provided for @reorder.
  ///
  /// In he, this message translates to:
  /// **'הזמן שוב'**
  String get reorder;

  /// No description provided for @previous_order_products.
  ///
  /// In he, this message translates to:
  /// **'מוצרים מהזמנה קודמת'**
  String get previous_order_products;

  /// No description provided for @err_message.
  ///
  /// In he, this message translates to:
  /// **'משהו השתבש'**
  String get err_message;

  /// No description provided for @success_message.
  ///
  /// In he, this message translates to:
  /// **'הבקשה הושלמה בהצלחה'**
  String get success_message;

  /// No description provided for @invalid_operation.
  ///
  /// In he, this message translates to:
  /// **' פעולה לא חוקית'**
  String get invalid_operation;

  /// No description provided for @document_created_message.
  ///
  /// In he, this message translates to:
  /// **'נוצר מסמך בהצלחה'**
  String get document_created_message;

  /// No description provided for @login_success_message.
  ///
  /// In he, this message translates to:
  /// **'התחברות בוצעה בהצלחה'**
  String get login_success_message;

  /// No description provided for @user_created_message.
  ///
  /// In he, this message translates to:
  /// **'נרשמת בהצלחה'**
  String get user_created_message;

  /// No description provided for @validation_error.
  ///
  /// In he, this message translates to:
  /// **'שגיאת אימות'**
  String get validation_error;

  /// No description provided for @server_error_message.
  ///
  /// In he, this message translates to:
  /// **'שגיאת שרת פנימית התרחשה'**
  String get server_error_message;

  /// No description provided for @invalid_credentials.
  ///
  /// In he, this message translates to:
  /// **'פרטי הכניסה אינם תקינים'**
  String get invalid_credentials;

  /// No description provided for @verification_email_sent.
  ///
  /// In he, this message translates to:
  /// **'נשלח אימייל לאימות לכתובת האימייל הרשומה שלך. אנא בדוק את תיקיית הדואר הנכנס שלך'**
  String get verification_email_sent;

  /// No description provided for @invalid_code.
  ///
  /// In he, this message translates to:
  /// **'קוד אימות לא תקין. אנא בדוק את הקוד ונסה שוב'**
  String get invalid_code;

  /// No description provided for @already_verified.
  ///
  /// In he, this message translates to:
  /// **'האימות כבר הושלם'**
  String get already_verified;

  /// No description provided for @expired_code.
  ///
  /// In he, this message translates to:
  /// **'קוד אימות פג תוקף. אנא בקש קוד אימות חדש'**
  String get expired_code;

  /// No description provided for @verification_success.
  ///
  /// In he, this message translates to:
  /// **'אימות בוצע בהצלחה'**
  String get verification_success;

  /// No description provided for @invalid_verification_code.
  ///
  /// In he, this message translates to:
  /// **'קוד אימות לא תקין. אנא בדוק את הקוד ונסה שוב'**
  String get invalid_verification_code;

  /// No description provided for @expired_verification_code.
  ///
  /// In he, this message translates to:
  /// **'קוד אימות פג תוקף. אנא בקש קוד אימות חדש'**
  String get expired_verification_code;

  /// No description provided for @unverified_verification_code.
  ///
  /// In he, this message translates to:
  /// **'קוד אימות לא אומת. אנא אמת תחילה'**
  String get unverified_verification_code;

  /// No description provided for @user_not_found.
  ///
  /// In he, this message translates to:
  /// **'משתמש לא נמצא'**
  String get user_not_found;

  /// No description provided for @new_password_same_as_old.
  ///
  /// In he, this message translates to:
  /// **'סיסמה חדשה חייבת להיות שונה מהסיסמה הקיימת'**
  String get new_password_same_as_old;

  /// No description provided for @reset_successful.
  ///
  /// In he, this message translates to:
  /// **'איפוס סיסמה בוצע בהצלחה'**
  String get reset_successful;

  /// No description provided for @set_successful.
  ///
  /// In he, this message translates to:
  /// **'הגדרת סיסמה בוצעה בהצלחה'**
  String get set_successful;

  /// No description provided for @current_password_wrong.
  ///
  /// In he, this message translates to:
  /// **'הסיסמה הנוכחית שלך אינה נכונה אנא הכנס את הסיסמה הנכונה'**
  String get current_password_wrong;

  /// No description provided for @change_successful.
  ///
  /// In he, this message translates to:
  /// **'שינוי סיסמה בוצע בהצלחה'**
  String get change_successful;

  /// No description provided for @form_create_successful.
  ///
  /// In he, this message translates to:
  /// **'יצירת טופס בוצעה בהצלחה'**
  String get form_create_successful;

  /// No description provided for @form_update_successful.
  ///
  /// In he, this message translates to:
  /// **'עדכון טופס בוצע בהצלחה'**
  String get form_update_successful;

  /// No description provided for @form_not_found.
  ///
  /// In he, this message translates to:
  /// **'טופס לא נמצא'**
  String get form_not_found;

  /// No description provided for @form_exists_with_name.
  ///
  /// In he, this message translates to:
  /// **'שם הטופס כבר קיים. נסה שם חדש'**
  String get form_exists_with_name;

  /// No description provided for @internal_server_error.
  ///
  /// In he, this message translates to:
  /// **'שגיאת שרת פנימית'**
  String get internal_server_error;

  /// No description provided for @record_already_exist.
  ///
  /// In he, this message translates to:
  /// **'הרשומה כבר קיימת!'**
  String get record_already_exist;

  /// No description provided for @phone_number_already_exist.
  ///
  /// In he, this message translates to:
  /// **'מספר הטלפון כבר קיים'**
  String get phone_number_already_exist;

  /// No description provided for @email_already_exist.
  ///
  /// In he, this message translates to:
  /// **'האימייל כבר קיים'**
  String get email_already_exist;

  /// No description provided for @record_not_created.
  ///
  /// In he, this message translates to:
  /// **'הרשומה לא נוצרה'**
  String get record_not_created;

  /// No description provided for @token_error.
  ///
  /// In he, this message translates to:
  /// **'שגיאת טוקן'**
  String get token_error;

  /// No description provided for @data_not_found.
  ///
  /// In he, this message translates to:
  /// **'מידע לא נמצא'**
  String get data_not_found;

  /// No description provided for @invalid_contact.
  ///
  /// In he, this message translates to:
  /// **'מספר לא תקין אנא בדוק את מספר הטלפון שלך'**
  String get invalid_contact;

  /// No description provided for @found_contact.
  ///
  /// In he, this message translates to:
  /// **'המשתמש כבר נרשם'**
  String get found_contact;

  /// No description provided for @invalid_email.
  ///
  /// In he, this message translates to:
  /// **'האימייל לא נמצא'**
  String get invalid_email;

  /// No description provided for @record_does_not_exist.
  ///
  /// In he, this message translates to:
  /// **' הרשומה לא קיימת'**
  String get record_does_not_exist;

  /// No description provided for @sku_are_required.
  ///
  /// In he, this message translates to:
  /// **'נדרשים SKUs'**
  String get sku_are_required;

  /// No description provided for @product_id_are_required.
  ///
  /// In he, this message translates to:
  /// **'מזהה המוצר נדרש'**
  String get product_id_are_required;

  /// No description provided for @skus_are_not_registered.
  ///
  /// In he, this message translates to:
  /// **' אף SKU לא רשום'**
  String get skus_are_not_registered;

  /// No description provided for @no_products_are_registered.
  ///
  /// In he, this message translates to:
  /// **'אף מוצר אינו רשום'**
  String get no_products_are_registered;

  /// No description provided for @supplier_product_is_not_registered.
  ///
  /// In he, this message translates to:
  /// **'המוצר של הספק אינו רשום'**
  String get supplier_product_is_not_registered;

  /// No description provided for @products_supplier_mismatch.
  ///
  /// In he, this message translates to:
  /// **'אף מוצר לא תואם לספק'**
  String get products_supplier_mismatch;

  /// No description provided for @product_removal_sale_success.
  ///
  /// In he, this message translates to:
  /// **'המוצר הוסר ממכירה בהצלחה'**
  String get product_removal_sale_success;

  /// No description provided for @product_removal_sale_failure.
  ///
  /// In he, this message translates to:
  /// **' הסרת המוצר מהמכירה נכשלה'**
  String get product_removal_sale_failure;

  /// No description provided for @insufficient_data_for_product_removal_from_sale.
  ///
  /// In he, this message translates to:
  /// **'מידע לא מספיק להסרת מוצר מהמכירה'**
  String get insufficient_data_for_product_removal_from_sale;

  /// No description provided for @product_not_found.
  ///
  /// In he, this message translates to:
  /// **'המוצר לא נמצא'**
  String get product_not_found;

  /// No description provided for @failed_to_authenticate.
  ///
  /// In he, this message translates to:
  /// **'נכשל באימות'**
  String get failed_to_authenticate;

  /// No description provided for @record_updated_successfully.
  ///
  /// In he, this message translates to:
  /// **'הרשומה עודכנה בהצלחה'**
  String get record_updated_successfully;

  /// No description provided for @record_deleted_successfully.
  ///
  /// In he, this message translates to:
  /// **'הרשומה נמחקה בהצלחה'**
  String get record_deleted_successfully;

  /// No description provided for @record_created_successfully.
  ///
  /// In he, this message translates to:
  /// **'הרשומה נוצרה בהצלחה'**
  String get record_created_successfully;

  /// No description provided for @invalid_ids.
  ///
  /// In he, this message translates to:
  /// **'נא לספק זיהוי תקין'**
  String get invalid_ids;

  /// No description provided for @imported_successfully.
  ///
  /// In he, this message translates to:
  /// **'  הפריטים יובאו בהצלחה'**
  String get imported_successfully;

  /// No description provided for @cart_products_bad_request.
  ///
  /// In he, this message translates to:
  /// **'המוצר בעגלה לא מיושם'**
  String get cart_products_bad_request;

  /// No description provided for @cart_does_not_exist.
  ///
  /// In he, this message translates to:
  /// **'העגלה אינה קיימת'**
  String get cart_does_not_exist;

  /// No description provided for @cart_product_does_not_exist.
  ///
  /// In he, this message translates to:
  /// **'המוצר בעגלה אינו קיים'**
  String get cart_product_does_not_exist;

  /// No description provided for @product_does_not_exist_in_cart.
  ///
  /// In he, this message translates to:
  /// **'המוצר אינו קיים'**
  String get product_does_not_exist_in_cart;

  /// No description provided for @supplier_does_not_have_quantity.
  ///
  /// In he, this message translates to:
  /// **'הספק אינו מספק כמות מספיקה'**
  String get supplier_does_not_have_quantity;

  /// No description provided for @order_products_bad_request.
  ///
  /// In he, this message translates to:
  /// **'לפחות מוצר אחד דרוש'**
  String get order_products_bad_request;

  /// No description provided for @order_created_successfully.
  ///
  /// In he, this message translates to:
  /// **'הזמנה הוצבה בהצלחה'**
  String get order_created_successfully;

  /// No description provided for @order_updated_successfully.
  ///
  /// In he, this message translates to:
  /// **'הזמנה עודכנה בהצלחה'**
  String get order_updated_successfully;

  /// No description provided for @order_not_found.
  ///
  /// In he, this message translates to:
  /// **'הזמנה לא נמצאה'**
  String get order_not_found;

  /// No description provided for @low_quantity.
  ///
  /// In he, this message translates to:
  /// **'כמות המוצר נמוכה.'**
  String get low_quantity;

  /// No description provided for @cart_cleared.
  ///
  /// In he, this message translates to:
  /// **'העגלה נוקתה כעת'**
  String get cart_cleared;

  /// No description provided for @null_password.
  ///
  /// In he, this message translates to:
  /// **'הסיסמה אינה מוגדרת אנא הגדר סיסמה'**
  String get null_password;

  /// No description provided for @logout.
  ///
  /// In he, this message translates to:
  /// **'התנתק בהצלחה'**
  String get logout;

  /// No description provided for @message_created.
  ///
  /// In he, this message translates to:
  /// **'הודעה נוצרה בהצלחה'**
  String get message_created;

  /// No description provided for @message_updated.
  ///
  /// In he, this message translates to:
  /// **'הודעה עודכנה בהצלחה'**
  String get message_updated;

  /// No description provided for @quantity_fulfilled.
  ///
  /// In he, this message translates to:
  /// **'כמות המוצר נמלאה'**
  String get quantity_fulfilled;

  /// No description provided for @order_sale_exist.
  ///
  /// In he, this message translates to:
  /// **' הזמנה קיימת לא ניתן למחוק'**
  String get order_sale_exist;

  /// No description provided for @supplier_product_exist.
  ///
  /// In he, this message translates to:
  /// **'המוצר קיים לא ניתן למחוק'**
  String get supplier_product_exist;

  /// No description provided for @question_id_does_not_exist.
  ///
  /// In he, this message translates to:
  /// **'השאלה אינה קיימת'**
  String get question_id_does_not_exist;

  /// No description provided for @unique_question_and_answer.
  ///
  /// In he, this message translates to:
  /// **'שאלה עם אותו טקסט כבר קיימת'**
  String get unique_question_and_answer;

  /// No description provided for @question_created_successfully.
  ///
  /// In he, this message translates to:
  /// **'שאלה נוצרה בהצלחה'**
  String get question_created_successfully;

  /// No description provided for @question_record_does_not_exist.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאה רשומה תואמת לעדכון'**
  String get question_record_does_not_exist;

  /// No description provided for @question_deleted_successfully.
  ///
  /// In he, this message translates to:
  /// **'שאלה נמחקה בהצלחה'**
  String get question_deleted_successfully;

  /// No description provided for @product_already_in_cart.
  ///
  /// In he, this message translates to:
  /// **'המוצר כבר נמצא בעגלה'**
  String get product_already_in_cart;

  /// No description provided for @product_or_supplier_not_exits.
  ///
  /// In he, this message translates to:
  /// **'המוצר או הספק אינם קיימים'**
  String get product_or_supplier_not_exits;

  /// No description provided for @product_added_in_cart.
  ///
  /// In he, this message translates to:
  /// **'המוצר נוסף לעגלה שלך בהצלחה'**
  String get product_added_in_cart;

  /// No description provided for @product_updated_in_cart.
  ///
  /// In he, this message translates to:
  /// **'המוצר עודכן בהצלחה לעגלת הקניות שלך'**
  String get product_updated_in_cart;

  /// No description provided for @order_issue_created_notification_title.
  ///
  /// In he, this message translates to:
  /// **'בעיות דווחו במספר הזמנת הספק #'**
  String get order_issue_created_notification_title;

  /// No description provided for @file_not_found.
  ///
  /// In he, this message translates to:
  /// **'קובץ לא נמצא'**
  String get file_not_found;

  /// No description provided for @you_can_not_update_order.
  ///
  /// In he, this message translates to:
  /// **'קוד ספק לא חוקי'**
  String get you_can_not_update_order;

  /// No description provided for @you_can_not_create_issue.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לבצע קריאה'**
  String get you_can_not_create_issue;

  /// No description provided for @you_can_not_place_order.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לבצע הזמנה'**
  String get you_can_not_place_order;

  /// No description provided for @you_can_not_confirm_delivery.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לאשר קבלה'**
  String get you_can_not_confirm_delivery;

  /// No description provided for @signature_required.
  ///
  /// In he, this message translates to:
  /// **'חובה לחתום'**
  String get signature_required;

  /// No description provided for @provide_valid_csv.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר CSV'**
  String get provide_valid_csv;

  /// No description provided for @invalid_supplier_id.
  ///
  /// In he, this message translates to:
  /// **'קוד ספק לא חוקי'**
  String get invalid_supplier_id;

  /// No description provided for @admin_type_already_exist.
  ///
  /// In he, this message translates to:
  /// **'סוג מנהל קיים כבר'**
  String get admin_type_already_exist;

  /// No description provided for @already_linked_with_user.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן למחוק את סוג המנהל הזה כי הוא שייך כבר למנהל'**
  String get already_linked_with_user;

  /// No description provided for @qty_must_above_zero.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן להוסיף את המוצר, כמות צריכה להיות יותר מ 0'**
  String get qty_must_above_zero;

  /// No description provided for @not_enough_qty.
  ///
  /// In he, this message translates to:
  /// **'אין מספיק מלאי עבור המוצר הזה'**
  String get not_enough_qty;

  /// No description provided for @content_already_exist.
  ///
  /// In he, this message translates to:
  /// **'תוכן עם אותו שם קיים כבר'**
  String get content_already_exist;

  /// No description provided for @module_already_exist.
  ///
  /// In he, this message translates to:
  /// **'שם מודל קיים כבר'**
  String get module_already_exist;

  /// No description provided for @product_or_supplier_not_exist.
  ///
  /// In he, this message translates to:
  /// **'מוצר או ספק לא קיימים'**
  String get product_or_supplier_not_exist;

  /// No description provided for @issue_generated.
  ///
  /// In he, this message translates to:
  /// **'בעיות נוצרו'**
  String get issue_generated;

  /// No description provided for @delivery_confirmed.
  ///
  /// In he, this message translates to:
  /// **'משלוח אושר'**
  String get delivery_confirmed;

  /// No description provided for @permission_already_exist.
  ///
  /// In he, this message translates to:
  /// **'תבנית הראשאות קיימת כבר'**
  String get permission_already_exist;

  /// No description provided for @planogram_already_exist.
  ///
  /// In he, this message translates to:
  /// **'פלנוגרמה קיימת כבר'**
  String get planogram_already_exist;

  /// No description provided for @product_already_exist.
  ///
  /// In he, this message translates to:
  /// **'מוצר קיים כבר'**
  String get product_already_exist;

  /// No description provided for @duplicate_or_invalid_sku.
  ///
  /// In he, this message translates to:
  /// **'מקט כפול או לא תקין'**
  String get duplicate_or_invalid_sku;

  /// No description provided for @already_linked_with_sale.
  ///
  /// In he, this message translates to:
  /// **'קיים כבר מבצע לא ניתן להוריד את הספק'**
  String get already_linked_with_sale;

  /// No description provided for @already_exist.
  ///
  /// In he, this message translates to:
  /// **'הודעה באותו שם קיימת כבר'**
  String get already_exist;

  /// No description provided for @wallet_already_exist.
  ///
  /// In he, this message translates to:
  /// **'ארנק קיים כבר'**
  String get wallet_already_exist;

  /// No description provided for @not_enough_balance.
  ///
  /// In he, this message translates to:
  /// **'אין לך מספיק ייתרה בארנק'**
  String get not_enough_balance;

  /// No description provided for @invalid_amount.
  ///
  /// In he, this message translates to:
  /// **'סכום לא תקין'**
  String get invalid_amount;

  /// No description provided for @deduction_is_negative.
  ///
  /// In he, this message translates to:
  /// **'החזרים יוצגו במינוס בארנק'**
  String get deduction_is_negative;

  /// No description provided for @missing_quantity_not_more_than_original.
  ///
  /// In he, this message translates to:
  /// **'כמות לא יכולה להיות יותר מהכמות המקורית'**
  String get missing_quantity_not_more_than_original;

  /// No description provided for @check_all.
  ///
  /// In he, this message translates to:
  /// **'בחר הכל'**
  String get check_all;

  /// No description provided for @wait_while_uploading.
  ///
  /// In he, this message translates to:
  /// **'אנא המתן בזמן שמעלים'**
  String get wait_while_uploading;

  /// No description provided for @otp_resend_success.
  ///
  /// In he, this message translates to:
  /// **'הקוד נשלח שוב בהצלחה'**
  String get otp_resend_success;

  /// No description provided for @select_valid_document_format.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר רק קבצים מסוג: jpg, jpeg, png, heic, pdf'**
  String get select_valid_document_format;

  /// No description provided for @select_next_day_shift.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר ביום הבא'**
  String get select_next_day_shift;

  /// No description provided for @item_deleted.
  ///
  /// In he, this message translates to:
  /// **'המוצרים נמחקו בהצלחה'**
  String get item_deleted;

  /// No description provided for @this_supplier_have.
  ///
  /// In he, this message translates to:
  /// **' לספק הזה יש'**
  String get this_supplier_have;

  /// No description provided for @quantity_in_stock.
  ///
  /// In he, this message translates to:
  /// **'כמות במלאי'**
  String get quantity_in_stock;

  /// No description provided for @enter_valid_owner_name.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן שם בעלים תקין'**
  String get enter_valid_owner_name;

  /// No description provided for @enter_valid_contact_name.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן שם איש קשר תקין'**
  String get enter_valid_contact_name;

  /// No description provided for @enter_valid_address.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן כתובת תקינה'**
  String get enter_valid_address;

  /// No description provided for @this_company_has_no_product.
  ///
  /// In he, this message translates to:
  /// **'כרגע אין מוצרים לחברה הזו'**
  String get this_company_has_no_product;

  /// No description provided for @out_of_stock1.
  ///
  /// In he, this message translates to:
  /// **'לא במלאי'**
  String get out_of_stock1;

  /// No description provided for @account_not_approve.
  ///
  /// In he, this message translates to:
  /// **'חשבון לא מאושר'**
  String get account_not_approve;

  /// No description provided for @confirm.
  ///
  /// In he, this message translates to:
  /// **'לְאַשֵׁר'**
  String get confirm;

  /// No description provided for @rivchit_credentials_not_set.
  ///
  /// In he, this message translates to:
  /// **'פרטי ריווחית לא הוגדרו'**
  String get rivchit_credentials_not_set;

  /// No description provided for @comax_invoice_not_found.
  ///
  /// In he, this message translates to:
  /// **'חשבונית קומקס לא קיימת'**
  String get comax_invoice_not_found;

  /// No description provided for @total_amount_cant_be_zero.
  ///
  /// In he, this message translates to:
  /// **'סה\"כ לתשלום לא יכול להיות אפס'**
  String get total_amount_cant_be_zero;

  /// No description provided for @sale_not_exists.
  ///
  /// In he, this message translates to:
  /// **'המבצע לא קיים יותר'**
  String get sale_not_exists;

  /// No description provided for @comax_order_error.
  ///
  /// In he, this message translates to:
  /// **'משהו השתבש'**
  String get comax_order_error;

  /// No description provided for @comax_client_error.
  ///
  /// In he, this message translates to:
  /// **'משהו השתבש'**
  String get comax_client_error;

  /// No description provided for @unit_in_box.
  ///
  /// In he, this message translates to:
  /// **'יחידות במארז'**
  String get unit_in_box;

  /// No description provided for @approx.
  ///
  /// In he, this message translates to:
  /// **'כ-'**
  String get approx;

  /// No description provided for @kgBox.
  ///
  /// In he, this message translates to:
  /// **'ק״ג במארז'**
  String get kgBox;

  /// No description provided for @price.
  ///
  /// In he, this message translates to:
  /// **'מחיר'**
  String get price;

  /// No description provided for @sub_categories.
  ///
  /// In he, this message translates to:
  /// **'תתי קטגויות'**
  String get sub_categories;

  /// No description provided for @per_unit.
  ///
  /// In he, this message translates to:
  /// **'ליחידה'**
  String get per_unit;

  /// No description provided for @delivery_date_value.
  ///
  /// In he, this message translates to:
  /// **'משלוח עד 3 ימי עסקים'**
  String get delivery_date_value;

  /// No description provided for @order.
  ///
  /// In he, this message translates to:
  /// **'הזמנה'**
  String get order;

  /// No description provided for @monthly_credit.
  ///
  /// In he, this message translates to:
  /// **'זיכוי חודשי'**
  String get monthly_credit;

  /// No description provided for @refund.
  ///
  /// In he, this message translates to:
  /// **'החזר תשלום'**
  String get refund;

  /// No description provided for @sub_total.
  ///
  /// In he, this message translates to:
  /// **'מחיר לפני מע\"מ'**
  String get sub_total;

  /// No description provided for @order_amount.
  ///
  /// In he, this message translates to:
  /// **'סכום הזמנה'**
  String get order_amount;

  /// No description provided for @total_amount_subject_to_vat.
  ///
  /// In he, this message translates to:
  /// **'סה״כ סכום חייב במע״מ'**
  String get total_amount_subject_to_vat;

  /// No description provided for @total_amount_not_subject_to_vat.
  ///
  /// In he, this message translates to:
  /// **'סה״כ סכום שאינו חייב במע״מ'**
  String get total_amount_not_subject_to_vat;

  /// No description provided for @vat.
  ///
  /// In he, this message translates to:
  /// **'מע\"מ'**
  String get vat;

  /// No description provided for @total_refunds.
  ///
  /// In he, this message translates to:
  /// **'סה”כ זיכויים'**
  String get total_refunds;

  /// No description provided for @refund_amount_1.
  ///
  /// In he, this message translates to:
  /// **'למימוש בהזמנות הבאות '**
  String get refund_amount_1;

  /// No description provided for @refund_amount_2.
  ///
  /// In he, this message translates to:
  /// **'נותרה לך יתרת זכות של: '**
  String get refund_amount_2;

  /// No description provided for @refund_amount_3.
  ///
  /// In he, this message translates to:
  /// **'יש לך יתרת זכות של:'**
  String get refund_amount_3;

  /// No description provided for @refund_amount_4.
  ///
  /// In he, this message translates to:
  /// **' למימוש'**
  String get refund_amount_4;

  /// No description provided for @read_condition.
  ///
  /// In he, this message translates to:
  /// **'מצב קריאה'**
  String get read_condition;

  /// No description provided for @bottle_deposit.
  ///
  /// In he, this message translates to:
  /// **'פקדון בקבוק'**
  String get bottle_deposit;

  /// No description provided for @please_provide_valid_time.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן שעה תקינה'**
  String get please_provide_valid_time;

  /// No description provided for @please_enter_city.
  ///
  /// In he, this message translates to:
  /// **'נא להיכנס לעיר'**
  String get please_enter_city;

  /// No description provided for @issue_remove.
  ///
  /// In he, this message translates to:
  /// **'הסר'**
  String get issue_remove;

  /// No description provided for @issue_removed.
  ///
  /// In he, this message translates to:
  /// **'הבעיה הוסרה בהצלחה'**
  String get issue_removed;

  /// No description provided for @wallet_information_sent_to_your_email.
  ///
  /// In he, this message translates to:
  /// **'קובץ תנועות האנרק שלח נשלח למייל שלך'**
  String get wallet_information_sent_to_your_email;

  /// No description provided for @form_date.
  ///
  /// In he, this message translates to:
  /// **'מתאריך'**
  String get form_date;

  /// No description provided for @to_date.
  ///
  /// In he, this message translates to:
  /// **'עד היום'**
  String get to_date;

  /// No description provided for @until_date.
  ///
  /// In he, this message translates to:
  /// **'עד תאריך'**
  String get until_date;

  /// No description provided for @delete_account.
  ///
  /// In he, this message translates to:
  /// **'מחיקת חשבון'**
  String get delete_account;

  /// No description provided for @delete_pop_up_msg.
  ///
  /// In he, this message translates to:
  /// **'קיבלנו את בקשת מחיקת החשבון שלך, אנו נטפל בזה בימים הקרובים.'**
  String get delete_pop_up_msg;

  /// No description provided for @login_as_guest.
  ///
  /// In he, this message translates to:
  /// **'כניסה כאורח'**
  String get login_as_guest;

  /// No description provided for @new_version_app_update.
  ///
  /// In he, this message translates to:
  /// **'קיימת גירסה חדשה עבור האפליקציה אנא עדכן את האפליקציה'**
  String get new_version_app_update;

  /// No description provided for @update.
  ///
  /// In he, this message translates to:
  /// **'עדכן'**
  String get update;

  /// No description provided for @application_version.
  ///
  /// In he, this message translates to:
  /// **'גרסת אפליקציה'**
  String get application_version;

  /// No description provided for @no_product.
  ///
  /// In he, this message translates to:
  /// **'המוצר לא נמצא'**
  String get no_product;

  /// No description provided for @duplicate_order.
  ///
  /// In he, this message translates to:
  /// **'שכפל הזמנה'**
  String get duplicate_order;

  /// No description provided for @you_want_to_duplicate_this_order.
  ///
  /// In he, this message translates to:
  /// **'שים לב, מוצרים שלא קיימים יותר או שחסרים במלאי לא יוספו להזמנה החדשה. האם אתה בטוח שברצונך לשכפל את ההזמנה ?'**
  String get you_want_to_duplicate_this_order;

  /// No description provided for @wallet_refund.
  ///
  /// In he, this message translates to:
  /// **'זיכוי ארנק'**
  String get wallet_refund;

  /// No description provided for @original_was.
  ///
  /// In he, this message translates to:
  /// **'במקור היה'**
  String get original_was;

  /// No description provided for @was_not_in_stock.
  ///
  /// In he, this message translates to:
  /// **'לא היה במלאי'**
  String get was_not_in_stock;

  /// No description provided for @units.
  ///
  /// In he, this message translates to:
  /// **'יחידות'**
  String get units;

  /// No description provided for @surfaces_order.
  ///
  /// In he, this message translates to:
  /// **'משטחים להזמנה'**
  String get surfaces_order;

  /// No description provided for @refund_for_order.
  ///
  /// In he, this message translates to:
  /// **'זיכוי עבור הזמנה'**
  String get refund_for_order;

  /// No description provided for @related_products.
  ///
  /// In he, this message translates to:
  /// **'מוצרים דומים'**
  String get related_products;

  /// No description provided for @search_result.
  ///
  /// In he, this message translates to:
  /// **'תוצאות חיפוש'**
  String get search_result;

  /// No description provided for @price_par_box.
  ///
  /// In he, this message translates to:
  /// **'מחיר למארז'**
  String get price_par_box;

  /// No description provided for @invoice_number.
  ///
  /// In he, this message translates to:
  /// **'חשבונית זיכוי'**
  String get invoice_number;

  /// No description provided for @invoice.
  ///
  /// In he, this message translates to:
  /// **'חשבונית'**
  String get invoice;

  /// No description provided for @for_order.
  ///
  /// In he, this message translates to:
  /// **'להזמנה'**
  String get for_order;

  /// No description provided for @total_invoice_amount.
  ///
  /// In he, this message translates to:
  /// **'סכום החשבונית הכולל'**
  String get total_invoice_amount;

  /// No description provided for @not_include_surfaces_price.
  ///
  /// In he, this message translates to:
  /// **'הסכום אינו כולל עלות משטחים'**
  String get not_include_surfaces_price;

  /// No description provided for @open.
  ///
  /// In he, this message translates to:
  /// **'פתח'**
  String get open;

  /// No description provided for @pay_invoice_text.
  ///
  /// In he, this message translates to:
  /// **'תשלום חשבונית'**
  String get pay_invoice_text;

  /// No description provided for @data_for_form.
  ///
  /// In he, this message translates to:
  /// **'נתונים עבור טפסים'**
  String get data_for_form;

  /// No description provided for @client_info.
  ///
  /// In he, this message translates to:
  /// **'פרטי לקוח'**
  String get client_info;

  /// No description provided for @my_agent_code.
  ///
  /// In he, this message translates to:
  /// **'קוד סוכן'**
  String get my_agent_code;

  /// No description provided for @owner1_full_name.
  ///
  /// In he, this message translates to:
  /// **'שם בעלים 1'**
  String get owner1_full_name;

  /// No description provided for @owner_1_israel_id.
  ///
  /// In he, this message translates to:
  /// **'ת.ז. בעלים 1'**
  String get owner_1_israel_id;

  /// No description provided for @owner2_full_name.
  ///
  /// In he, this message translates to:
  /// **'שם בעלים 2'**
  String get owner2_full_name;

  /// No description provided for @owner_2_israel_id.
  ///
  /// In he, this message translates to:
  /// **'ת.ז. בעלים 2'**
  String get owner_2_israel_id;

  /// No description provided for @guarantee_1_full_name.
  ///
  /// In he, this message translates to:
  /// **'שם ערב 1'**
  String get guarantee_1_full_name;

  /// No description provided for @guarantee_1_israel_id.
  ///
  /// In he, this message translates to:
  /// **'ת.ז. ערב 1'**
  String get guarantee_1_israel_id;

  /// No description provided for @guarantee_2_full_name.
  ///
  /// In he, this message translates to:
  /// **'שם ערב 2'**
  String get guarantee_2_full_name;

  /// No description provided for @guarantee_2_israel_id.
  ///
  /// In he, this message translates to:
  /// **'ת.ז. ערב 2'**
  String get guarantee_2_israel_id;

  /// No description provided for @guarantee_1_address.
  ///
  /// In he, this message translates to:
  /// **' אנא הזן כתובת של ערב '**
  String get guarantee_1_address;

  /// No description provided for @guarantee_2_address.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן כתובת של ערב '**
  String get guarantee_2_address;

  /// No description provided for @guarantee_1_phone_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן טלפון של ערב 1'**
  String get guarantee_1_phone_number;

  /// No description provided for @guarantee_2_phone_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן טלפון של ערב 2'**
  String get guarantee_2_phone_number;

  /// No description provided for @bank_info.
  ///
  /// In he, this message translates to:
  /// **'פרטי חשבון בנק'**
  String get bank_info;

  /// No description provided for @name_of_bank.
  ///
  /// In he, this message translates to:
  /// **'שם בנק'**
  String get name_of_bank;

  /// No description provided for @branch_number.
  ///
  /// In he, this message translates to:
  /// **'מספר סניף'**
  String get branch_number;

  /// No description provided for @account_number.
  ///
  /// In he, this message translates to:
  /// **'מספר חשבון'**
  String get account_number;

  /// No description provided for @please_enter_guarantee1_name.
  ///
  /// In he, this message translates to:
  /// **'1 אנא הזן שם של ערב'**
  String get please_enter_guarantee1_name;

  /// No description provided for @please_enter_guarantee2_name.
  ///
  /// In he, this message translates to:
  /// **'2 אנא הזן שם של ערב'**
  String get please_enter_guarantee2_name;

  /// No description provided for @please_select_agent.
  ///
  /// In he, this message translates to:
  /// **'אנא הסוכן שלי'**
  String get please_select_agent;

  /// No description provided for @please_enter_branch_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר סניף'**
  String get please_enter_branch_number;

  /// No description provided for @please_enter_account_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר חשבון'**
  String get please_enter_account_number;

  /// No description provided for @privacy_policy.
  ///
  /// In he, this message translates to:
  /// **'הסכם שימוש בשירות - TAVILI'**
  String get privacy_policy;

  /// No description provided for @pesach_products.
  ///
  /// In he, this message translates to:
  /// **'מוצרים כשרים לפסח'**
  String get pesach_products;

  /// No description provided for @pesach.
  ///
  /// In he, this message translates to:
  /// **'כשר לפסח'**
  String get pesach;

  /// No description provided for @street_name.
  ///
  /// In he, this message translates to:
  /// **'שם רחוב'**
  String get street_name;

  /// No description provided for @street_number.
  ///
  /// In he, this message translates to:
  /// **'מספר בית'**
  String get street_number;

  /// No description provided for @enter_street_name.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן שם רחוב'**
  String get enter_street_name;

  /// No description provided for @enter_street_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר בית'**
  String get enter_street_number;

  /// No description provided for @enter_zip.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מיקוד'**
  String get enter_zip;

  /// No description provided for @zip.
  ///
  /// In he, this message translates to:
  /// **'מיקוד'**
  String get zip;

  /// No description provided for @owner1_sign.
  ///
  /// In he, this message translates to:
  /// **'חתימה בעלים 1'**
  String get owner1_sign;

  /// No description provided for @owner2_sign.
  ///
  /// In he, this message translates to:
  /// **'חתימה בעלים 2'**
  String get owner2_sign;

  /// No description provided for @guarantee1_sign.
  ///
  /// In he, this message translates to:
  /// **'חתימה ערב 1'**
  String get guarantee1_sign;

  /// No description provided for @guarantee2_sign.
  ///
  /// In he, this message translates to:
  /// **'חתימה ערב 2'**
  String get guarantee2_sign;

  /// No description provided for @upload_document.
  ///
  /// In he, this message translates to:
  /// **'אנא העלה את המסמך'**
  String get upload_document;

  /// No description provided for @connection_error.
  ///
  /// In he, this message translates to:
  /// **'בעיית התחברות'**
  String get connection_error;

  /// No description provided for @rivchit_invoice_number.
  ///
  /// In he, this message translates to:
  /// **'מס\' חשבונית'**
  String get rivchit_invoice_number;

  /// No description provided for @payment_invoice.
  ///
  /// In he, this message translates to:
  /// **'חשבונית תשלום'**
  String get payment_invoice;

  /// No description provided for @refund_invoice.
  ///
  /// In he, this message translates to:
  /// **'חשבונית זיכוי'**
  String get refund_invoice;

  /// No description provided for @payed.
  ///
  /// In he, this message translates to:
  /// **'שולם'**
  String get payed;

  /// No description provided for @pending.
  ///
  /// In he, this message translates to:
  /// **'ממתין'**
  String get pending;

  /// No description provided for @invoice_date.
  ///
  /// In he, this message translates to:
  /// **'תאריך החשבונית'**
  String get invoice_date;

  /// No description provided for @invoice_type.
  ///
  /// In he, this message translates to:
  /// **'סוג חשבונית'**
  String get invoice_type;

  /// No description provided for @invoice_status.
  ///
  /// In he, this message translates to:
  /// **'סטטוס חשבונית'**
  String get invoice_status;

  /// No description provided for @total_payment.
  ///
  /// In he, this message translates to:
  /// **'סה״כ לתשלום'**
  String get total_payment;

  /// No description provided for @invoice_amount.
  ///
  /// In he, this message translates to:
  /// **'סכום חשבונית'**
  String get invoice_amount;

  /// No description provided for @refund_amount.
  ///
  /// In he, this message translates to:
  /// **'סכום ההחזר'**
  String get refund_amount;

  /// No description provided for @refunded_on_order.
  ///
  /// In he, this message translates to:
  /// **'הזמנה שזוכתה'**
  String get refunded_on_order;

  /// No description provided for @refunded_on_invoices.
  ///
  /// In he, this message translates to:
  /// **'החזר כספי על חשבוניות'**
  String get refunded_on_invoices;

  /// No description provided for @remaining_refund.
  ///
  /// In he, this message translates to:
  /// **'זיכוי שנשאר'**
  String get remaining_refund;

  /// No description provided for @approve_previous_order.
  ///
  /// In he, this message translates to:
  /// **'עליך לאשר הזמנה קודמת'**
  String get approve_previous_order;

  /// No description provided for @order_sign_dialog.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לשדר הזמנה בגלל שיש הזמנות שקיבלת ולא חתמת עליהם\nאנא עבור על רשימת ההזמנות שלך ואשר שקיבלת אותם\nלאחר שתאשר תוכל לשדר את ההזמנה\nתודה !'**
  String get order_sign_dialog;

  /// No description provided for @show_order.
  ///
  /// In he, this message translates to:
  /// **'הצג הזמנות'**
  String get show_order;

  /// No description provided for @please_enter_surfaces.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן כמה משטחים אתה מחזיר'**
  String get please_enter_surfaces;

  /// No description provided for @please_enter_driverName.
  ///
  /// In he, this message translates to:
  /// **'נא להזין את שם הנהג'**
  String get please_enter_driverName;

  /// No description provided for @pallets_return.
  ///
  /// In he, this message translates to:
  /// **'כמה משטחים אתה מחזיר ?'**
  String get pallets_return;

  /// No description provided for @sub_user.
  ///
  /// In he, this message translates to:
  /// **'משתמשים'**
  String get sub_user;

  /// No description provided for @new_user.
  ///
  /// In he, this message translates to:
  /// **'חדש'**
  String get new_user;

  /// No description provided for @new_sub_user.
  ///
  /// In he, this message translates to:
  /// **'משתמש חדש'**
  String get new_sub_user;

  /// No description provided for @edit_sub_user.
  ///
  /// In he, this message translates to:
  /// **'עריכת משתמש'**
  String get edit_sub_user;

  /// No description provided for @full_name.
  ///
  /// In he, this message translates to:
  /// **'שם מלא'**
  String get full_name;

  /// No description provided for @phone_number.
  ///
  /// In he, this message translates to:
  /// **'טלפון נייד להתחברות'**
  String get phone_number;

  /// No description provided for @please_enter_sub_user.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן משמש'**
  String get please_enter_sub_user;

  /// No description provided for @account_permission.
  ///
  /// In he, this message translates to:
  /// **'הרשאות משתמש'**
  String get account_permission;

  /// No description provided for @categories_permissions.
  ///
  /// In he, this message translates to:
  /// **'הרשאות קטגוריות'**
  String get categories_permissions;

  /// No description provided for @brand_permissions.
  ///
  /// In he, this message translates to:
  /// **'הרשאות מותגים'**
  String get brand_permissions;

  /// No description provided for @supplier_permissions.
  ///
  /// In he, this message translates to:
  /// **'הרשאות ספקים'**
  String get supplier_permissions;

  /// No description provided for @account_admin.
  ///
  /// In he, this message translates to:
  /// **'משתמש מנהל'**
  String get account_admin;

  /// No description provided for @can_see_wallet.
  ///
  /// In he, this message translates to:
  /// **'יכול לראות ארנק'**
  String get can_see_wallet;

  /// No description provided for @can_add_basket.
  ///
  /// In he, this message translates to:
  /// **'יכול להוסיף לסל'**
  String get can_add_basket;

  /// No description provided for @can_create_order.
  ///
  /// In he, this message translates to:
  /// **'יכול לשלוח הזמנות'**
  String get can_create_order;

  /// No description provided for @can_approve_order.
  ///
  /// In he, this message translates to:
  /// **'יכול לאשר הזמנה'**
  String get can_approve_order;

  /// No description provided for @can_duplicate_order.
  ///
  /// In he, this message translates to:
  /// **'יכול לשכפל הזמנה'**
  String get can_duplicate_order;

  /// No description provided for @can_see_update_business_info.
  ///
  /// In he, this message translates to:
  /// **'יכול לראות ולעדכן פרטי עסק'**
  String get can_see_update_business_info;

  /// No description provided for @can_see_update_additional_info.
  ///
  /// In he, this message translates to:
  /// **'יכול לראות ולעדכן פרטים נוספים'**
  String get can_see_update_additional_info;

  /// No description provided for @can_see_update_times_info.
  ///
  /// In he, this message translates to:
  /// **'יכול לראות ולעדכן שעות עבודה'**
  String get can_see_update_times_info;

  /// No description provided for @can_see_files_forms.
  ///
  /// In he, this message translates to:
  /// **'יכול לראות קבצים וטפסים'**
  String get can_see_files_forms;

  /// No description provided for @can_manage_sub_users.
  ///
  /// In he, this message translates to:
  /// **'יכול לנהל משתמשים'**
  String get can_manage_sub_users;

  /// No description provided for @select_all.
  ///
  /// In he, this message translates to:
  /// **'בחר הכל'**
  String get select_all;

  /// No description provided for @see_order.
  ///
  /// In he, this message translates to:
  /// **'יכול לראות רשימת הזמנות'**
  String get see_order;

  /// No description provided for @select_none.
  ///
  /// In he, this message translates to:
  /// **'נקה הכל'**
  String get select_none;

  /// No description provided for @not_sufficient_permission.
  ///
  /// In he, this message translates to:
  /// **'אין לך הרשאה'**
  String get not_sufficient_permission;

  /// No description provided for @phone_number_of_other_sub_user.
  ///
  /// In he, this message translates to:
  /// **'מספר הטלפון כבר משוייך למשתמש אחר'**
  String get phone_number_of_other_sub_user;

  /// No description provided for @delete_sub_user_account.
  ///
  /// In he, this message translates to:
  /// **'מחיקת משתמש'**
  String get delete_sub_user_account;

  /// No description provided for @can_see_invoices.
  ///
  /// In he, this message translates to:
  /// **'יכול לראות חשבוניות'**
  String get can_see_invoices;

  /// No description provided for @can_scan_documents.
  ///
  /// In he, this message translates to:
  /// **'יכול לסרוק מסמכים'**
  String get can_scan_documents;

  /// No description provided for @maximum_qty.
  ///
  /// In he, this message translates to:
  /// **'מקסימום מארזים להזמנה עבור המבצע'**
  String get maximum_qty;

  /// No description provided for @not_add_more_than_max_qty.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן להוסיף יותר מהמקסימום עבור המבצע הזה'**
  String get not_add_more_than_max_qty;

  /// No description provided for @apply.
  ///
  /// In he, this message translates to:
  /// **'הצג'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In he, this message translates to:
  /// **'בָּרוּר'**
  String get clear;

  /// No description provided for @sorting.
  ///
  /// In he, this message translates to:
  /// **'מִיוּן'**
  String get sorting;

  /// No description provided for @filtering.
  ///
  /// In he, this message translates to:
  /// **'סִנוּן'**
  String get filtering;

  /// No description provided for @product_no_longer_in_stock.
  ///
  /// In he, this message translates to:
  /// **'המוצר כבר לא במלאי'**
  String get product_no_longer_in_stock;

  /// No description provided for @total_price_with_vat.
  ///
  /// In he, this message translates to:
  /// **'סה\'כ לתשלום כולל מע\'מ'**
  String get total_price_with_vat;

  /// No description provided for @price_includes_vat.
  ///
  /// In he, this message translates to:
  /// **'מחיר כולל מע”מ'**
  String get price_includes_vat;

  /// No description provided for @way_of_payment.
  ///
  /// In he, this message translates to:
  /// **'אופן התשלום'**
  String get way_of_payment;

  /// No description provided for @collection_from_bank_account.
  ///
  /// In he, this message translates to:
  /// **'גבייה מחשבון בנק לפי תנאי התשלום שנקבעו'**
  String get collection_from_bank_account;

  /// No description provided for @credit_card.
  ///
  /// In he, this message translates to:
  /// **'כרטיס אשראי'**
  String get credit_card;

  /// No description provided for @credit_card_details.
  ///
  /// In he, this message translates to:
  /// **'פרטי כרטיס אשראי'**
  String get credit_card_details;

  /// No description provided for @credit_card_number.
  ///
  /// In he, this message translates to:
  /// **'מספר כרטיס'**
  String get credit_card_number;

  /// No description provided for @validity.
  ///
  /// In he, this message translates to:
  /// **'תוקף'**
  String get validity;

  /// No description provided for @some_products_out_of_stock_Do_you_want_submit_order.
  ///
  /// In he, this message translates to:
  /// **'נמצאו מספר מוצרים שאינם במלאי. האם אתה רוצה לשלוח את ההזמנה ללא המוצרים שאינם במלאי ?'**
  String get some_products_out_of_stock_Do_you_want_submit_order;

  /// No description provided for @enter_credit_card_number.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר כרטיס'**
  String get enter_credit_card_number;

  /// No description provided for @enter_credit_card_validity.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן תוקף כרטיס'**
  String get enter_credit_card_validity;

  /// No description provided for @manage_credit_card.
  ///
  /// In he, this message translates to:
  /// **'ניהול כרטיס אשראי'**
  String get manage_credit_card;

  /// No description provided for @israel_id_or_business_id_number_error.
  ///
  /// In he, this message translates to:
  /// **'נתגלתה שגיאה במספר ת.ז. או במספק עוסק מורשה'**
  String get israel_id_or_business_id_number_error;

  /// No description provided for @rivchitclienterror.
  ///
  /// In he, this message translates to:
  /// **'rivchitclienterror'**
  String get rivchitclienterror;

  /// No description provided for @change_credit_card.
  ///
  /// In he, this message translates to:
  /// **'שינוי כרטיס אשראי'**
  String get change_credit_card;

  /// No description provided for @change_to_wallet_payment.
  ///
  /// In he, this message translates to:
  /// **'תשלום מהארנק שלך'**
  String get change_to_wallet_payment;

  /// No description provided for @pay_with_bank_transfer.
  ///
  /// In he, this message translates to:
  /// **'תשלום בהעברה בנקאית'**
  String get pay_with_bank_transfer;

  /// No description provided for @pay_with_credit_card.
  ///
  /// In he, this message translates to:
  /// **'תשלום בכרטיס אשראי'**
  String get pay_with_credit_card;

  /// No description provided for @pay_with_wallet.
  ///
  /// In he, this message translates to:
  /// **'תשלום מהארנק'**
  String get pay_with_wallet;

  /// No description provided for @israel_id_exist.
  ///
  /// In he, this message translates to:
  /// **'מספר הת.ז. או מספר העוסק מורשה כבר קיים במערכת'**
  String get israel_id_exist;

  /// No description provided for @add_credit_card.
  ///
  /// In he, this message translates to:
  /// **'הוספת כרטיס אשראי'**
  String get add_credit_card;

  /// No description provided for @under_maintenance.
  ///
  /// In he, this message translates to:
  /// **'האפליקציה כרגע בתחזוקה, אנא נסה שוב מאוחר יותר'**
  String get under_maintenance;

  /// No description provided for @retry.
  ///
  /// In he, this message translates to:
  /// **'נסה שוב'**
  String get retry;

  /// No description provided for @invalid_agent_code.
  ///
  /// In he, this message translates to:
  /// **'קוד הסוכן אינו תקין'**
  String get invalid_agent_code;

  /// No description provided for @agent_block.
  ///
  /// In he, this message translates to:
  /// **'עברת את מקסימום הנסיונות, אנא נסה שוב בעוד 30 דקות'**
  String get agent_block;

  /// No description provided for @warning_agent_code.
  ///
  /// In he, this message translates to:
  /// **'נותרו לך עוד 2 נסיונות להזין קוד סוכן תקין'**
  String get warning_agent_code;

  /// No description provided for @please_enter_valid_israel_id_owner1.
  ///
  /// In he, this message translates to:
  /// **'הזן ת.ז. תקינה עבור בעלים 1'**
  String get please_enter_valid_israel_id_owner1;

  /// No description provided for @please_enter_valid_israel_id_owner2.
  ///
  /// In he, this message translates to:
  /// **'הזן ת.ז. תקינה עבור בעלים 2'**
  String get please_enter_valid_israel_id_owner2;

  /// No description provided for @please_enter_valid_israel_id_guarantee1.
  ///
  /// In he, this message translates to:
  /// **'הזן ת.ז. תקינה עבור ערב 1'**
  String get please_enter_valid_israel_id_guarantee1;

  /// No description provided for @please_enter_valid_israel_id_guarantee2.
  ///
  /// In he, this message translates to:
  /// **'הזן ת.ז. תקינה עבור ערב 2'**
  String get please_enter_valid_israel_id_guarantee2;

  /// No description provided for @please_enter_valid_guarantee_name1.
  ///
  /// In he, this message translates to:
  /// **'הזן שם תקין עבור ערב 1'**
  String get please_enter_valid_guarantee_name1;

  /// No description provided for @please_enter_valid_guarantee_name2.
  ///
  /// In he, this message translates to:
  /// **'הזן שם תקין עבור ערב 2'**
  String get please_enter_valid_guarantee_name2;

  /// No description provided for @approve_for_promotional_info.
  ///
  /// In he, this message translates to:
  /// **'אני מאשר קבלת חומר שיווקי על מבצעים במייל, טלפון, SMS, הודעת PUSH, וכדומה מאפליקציית TAVILI ו/או קבוצת חברות סטוק טק.'**
  String get approve_for_promotional_info;

  /// No description provided for @delete_credit_card.
  ///
  /// In he, this message translates to:
  /// **'מחיקת כרטיס'**
  String get delete_credit_card;

  /// No description provided for @payment_dialog_option_title.
  ///
  /// In he, this message translates to:
  /// **'ניתן לבצע את התשלום כך:'**
  String get payment_dialog_option_title;

  /// No description provided for @understand_submit_order.
  ///
  /// In he, this message translates to:
  /// **'הבנתי, שלח הזמנה !'**
  String get understand_submit_order;

  /// No description provided for @agent_code_length_error.
  ///
  /// In he, this message translates to:
  /// **'מספר סוכן חייב להיות 6 ספרות.'**
  String get agent_code_length_error;

  /// No description provided for @issue_with_payment.
  ///
  /// In he, this message translates to:
  /// **'התשלום לא עבר בחברת האשראי'**
  String get issue_with_payment;

  /// No description provided for @how_do_you_want_to_pay.
  ///
  /// In he, this message translates to:
  /// **'איך אתה רוצה לשלם ?'**
  String get how_do_you_want_to_pay;

  /// No description provided for @credit_card_not_found.
  ///
  /// In he, this message translates to:
  /// **'לא נמצא כרטיס אשראי'**
  String get credit_card_not_found;

  /// No description provided for @bank_not_found.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו פרטי חשבון בנק'**
  String get bank_not_found;

  /// No description provided for @business_type_not_found.
  ///
  /// In he, this message translates to:
  /// **'לא נמצא סוג עסק'**
  String get business_type_not_found;

  /// No description provided for @user_not_updated.
  ///
  /// In he, this message translates to:
  /// **'משתמש לא עודכן'**
  String get user_not_updated;

  /// No description provided for @status_not_found.
  ///
  /// In he, this message translates to:
  /// **'לא נמצא סטטוס'**
  String get status_not_found;

  /// No description provided for @client_details_not_found.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו נתנים עבור הלקוח'**
  String get client_details_not_found;

  /// No description provided for @bdi_error.
  ///
  /// In he, this message translates to:
  /// **'משהו השתבש בבדיקת BDI'**
  String get bdi_error;

  /// No description provided for @year.
  ///
  /// In he, this message translates to:
  /// **'שנה'**
  String get year;

  /// No description provided for @month.
  ///
  /// In he, this message translates to:
  /// **'חודש'**
  String get month;

  /// No description provided for @enter_valid_year.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן תוקף שנה תקינה'**
  String get enter_valid_year;

  /// No description provided for @select_valid_month.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר חודש תקף'**
  String get select_valid_month;

  /// No description provided for @minimum_box.
  ///
  /// In he, this message translates to:
  /// **'מינימום מארזים להזמנה עבור המבצע'**
  String get minimum_box;

  /// No description provided for @minimum_box_title.
  ///
  /// In he, this message translates to:
  /// **'מספר המארזים המינימלי למבצע זה הוא: '**
  String get minimum_box_title;

  /// No description provided for @mix_sale_text.
  ///
  /// In he, this message translates to:
  /// **'מדובר במבצע מעורב'**
  String get mix_sale_text;

  /// No description provided for @sale_other_text.
  ///
  /// In he, this message translates to:
  /// **'אם לא תזמין לפחות'**
  String get sale_other_text;

  /// No description provided for @sale_other_text1.
  ///
  /// In he, this message translates to:
  /// **'מוצרים לא תקבל את מחיר המבצע'**
  String get sale_other_text1;

  /// No description provided for @mixed_sale_other_text.
  ///
  /// In he, this message translates to:
  /// **'תוכל להזמין גם משאר המוצרים המשתתפים במבצע'**
  String get mixed_sale_other_text;

  /// No description provided for @mix_minimum_box_title.
  ///
  /// In he, this message translates to:
  /// **'מספר הקופסאות המינימלי למכירה מעורבת זו הוא: '**
  String get mix_minimum_box_title;

  /// No description provided for @confirm_minimum_box.
  ///
  /// In he, this message translates to:
  /// **', אתה בטוח שאתה לא רוצה את מחיר המבצע ?'**
  String get confirm_minimum_box;

  /// No description provided for @productParticipatingSale.
  ///
  /// In he, this message translates to:
  /// **'מוצרים המשתתפים במבצע:'**
  String get productParticipatingSale;

  /// No description provided for @minimum_boxes_detail.
  ///
  /// In he, this message translates to:
  /// **'מספר הקופסאות המינימלי למכירה זו הוא:'**
  String get minimum_boxes_detail;

  /// No description provided for @addText.
  ///
  /// In he, this message translates to:
  /// **'הוסף'**
  String get addText;

  /// No description provided for @closeText.
  ///
  /// In he, this message translates to:
  /// **'סגור'**
  String get closeText;

  /// No description provided for @mixedSale.
  ///
  /// In he, this message translates to:
  /// **'מבצע מעורב'**
  String get mixedSale;

  /// No description provided for @minGrid.
  ///
  /// In he, this message translates to:
  /// **'מיני'**
  String get minGrid;

  /// No description provided for @maxGrid.
  ///
  /// In he, this message translates to:
  /// **'מקס'**
  String get maxGrid;

  /// No description provided for @minimumGrid.
  ///
  /// In he, this message translates to:
  /// **'מינימום'**
  String get minimumGrid;

  /// No description provided for @maximumGrid.
  ///
  /// In he, this message translates to:
  /// **'מקסימום'**
  String get maximumGrid;

  /// No description provided for @minimumList.
  ///
  /// In he, this message translates to:
  /// **'מינימום מארזים למבצע'**
  String get minimumList;

  /// No description provided for @maximumList.
  ///
  /// In he, this message translates to:
  /// **'מקסימום מארזים למבצע'**
  String get maximumList;

  /// No description provided for @credit_card_payment_failed.
  ///
  /// In he, this message translates to:
  /// **'תשלום בכרטיס אשראי נכשל'**
  String get credit_card_payment_failed;

  /// No description provided for @my_invoices.
  ///
  /// In he, this message translates to:
  /// **'החשבוניות שלי'**
  String get my_invoices;

  /// No description provided for @my_refunds.
  ///
  /// In he, this message translates to:
  /// **'הזיכויים שלי'**
  String get my_refunds;

  /// No description provided for @savings_for_sales.
  ///
  /// In he, this message translates to:
  /// **'חיסכון במבצעים'**
  String get savings_for_sales;

  /// No description provided for @minimum_order.
  ///
  /// In he, this message translates to:
  /// **'מינימום הזמנה :'**
  String get minimum_order;

  /// No description provided for @you_can_send_the_order.
  ///
  /// In he, this message translates to:
  /// **'אתה יכול לשדר את ההזמנה'**
  String get you_can_send_the_order;

  /// No description provided for @you_cant_send_the_order.
  ///
  /// In he, this message translates to:
  /// **'אתה מתחת למינימום'**
  String get you_cant_send_the_order;

  /// No description provided for @not_minimum_order.
  ///
  /// In he, this message translates to:
  /// **'Not minimum order'**
  String get not_minimum_order;

  /// No description provided for @show_all_results.
  ///
  /// In he, this message translates to:
  /// **'הצג את כל התוצאות '**
  String get show_all_results;

  /// No description provided for @bank_transfer_information.
  ///
  /// In he, this message translates to:
  /// **'פרטי חשבון להעברה בנקאית'**
  String get bank_transfer_information;

  /// No description provided for @pay_with_bank_check.
  ///
  /// In he, this message translates to:
  /// **'תשלום בשיק'**
  String get pay_with_bank_check;

  /// No description provided for @due_date.
  ///
  /// In he, this message translates to:
  /// **'תאריך לתשלום'**
  String get due_date;

  /// No description provided for @invoice_charge.
  ///
  /// In he, this message translates to:
  /// **'החיוב יבוצע כאשר תקבל חשבונית'**
  String get invoice_charge;

  /// No description provided for @paid.
  ///
  /// In he, this message translates to:
  /// **'שולם'**
  String get paid;

  /// No description provided for @wallet.
  ///
  /// In he, this message translates to:
  /// **'ארנק'**
  String get wallet;

  /// No description provided for @bank_transfer.
  ///
  /// In he, this message translates to:
  /// **'העברה בנקאית'**
  String get bank_transfer;

  /// No description provided for @bank_check.
  ///
  /// In he, this message translates to:
  /// **'שיק'**
  String get bank_check;

  /// No description provided for @payment_type.
  ///
  /// In he, this message translates to:
  /// **'שיטת תשלום'**
  String get payment_type;

  /// No description provided for @copy.
  ///
  /// In he, this message translates to:
  /// **'העתק'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In he, this message translates to:
  /// **'הועתק'**
  String get copied;

  /// No description provided for @select_number_of_owners.
  ///
  /// In he, this message translates to:
  /// **'בחר מספר בעלים'**
  String get select_number_of_owners;

  /// No description provided for @owner_first_name.
  ///
  /// In he, this message translates to:
  /// **'שם פרטי של הבעלים'**
  String get owner_first_name;

  /// No description provided for @owner_last_name.
  ///
  /// In he, this message translates to:
  /// **'שם משפחה של הבעלים'**
  String get owner_last_name;

  /// No description provided for @back_to_order.
  ///
  /// In he, this message translates to:
  /// **'חזרה לרשימת ההזמנות'**
  String get back_to_order;

  /// No description provided for @returns.
  ///
  /// In he, this message translates to:
  /// **'חזרות'**
  String get returns;

  /// No description provided for @enter_product_barcode.
  ///
  /// In he, this message translates to:
  /// **'הוסף את הברקוד של המוצר'**
  String get enter_product_barcode;

  /// No description provided for @scan_return_product.
  ///
  /// In he, this message translates to:
  /// **'סרוק את המוצר לחזרה'**
  String get scan_return_product;

  /// No description provided for @product_return_info.
  ///
  /// In he, this message translates to:
  /// **'נתוני מוצר לחזרה'**
  String get product_return_info;

  /// No description provided for @no_of_unit_for_return.
  ///
  /// In he, this message translates to:
  /// **'מספר יחידות לחזרה'**
  String get no_of_unit_for_return;

  /// No description provided for @no_of_kg_for_return.
  ///
  /// In he, this message translates to:
  /// **'מספר קג לחזרה'**
  String get no_of_kg_for_return;

  /// No description provided for @why_return_product.
  ///
  /// In he, this message translates to:
  /// **'למה אתה רוצה להחזיר את המוצר?'**
  String get why_return_product;

  /// No description provided for @add_proof_img.
  ///
  /// In he, this message translates to:
  /// **'העלה תמונות להוכחה'**
  String get add_proof_img;

  /// No description provided for @add_driver_delivery_document_img.
  ///
  /// In he, this message translates to:
  /// **'צילום של תעודת משלוח שקיבלת'**
  String get add_driver_delivery_document_img;

  /// No description provided for @add_driver_delivery_document_img_note.
  ///
  /// In he, this message translates to:
  /// **'יש לצלם את תעודת המשלוח כהוכחה לקבלת הסחורה'**
  String get add_driver_delivery_document_img_note;

  /// No description provided for @driver_return_delivery_document_img.
  ///
  /// In he, this message translates to:
  /// **'צילום של תעודת חזרה שקיבלת '**
  String get driver_return_delivery_document_img;

  /// No description provided for @driver_return_delivery_document_img_note.
  ///
  /// In he, this message translates to:
  /// **'יש לצלם את תעודת החזרה כהוכחה להחזרת הסחורה'**
  String get driver_return_delivery_document_img_note;

  /// No description provided for @add_notes.
  ///
  /// In he, this message translates to:
  /// **'הוסף הערות'**
  String get add_notes;

  /// No description provided for @new_return.
  ///
  /// In he, this message translates to:
  /// **'החזרות חדשות'**
  String get new_return;

  /// No description provided for @product_defective.
  ///
  /// In he, this message translates to:
  /// **'המוצר פגום'**
  String get product_defective;

  /// No description provided for @product_expiration_date_issue.
  ///
  /// In he, this message translates to:
  /// **'בעיית תאריך תפוגה למוצר'**
  String get product_expiration_date_issue;

  /// No description provided for @wrong_product.
  ///
  /// In he, this message translates to:
  /// **'מוצר לא נכון'**
  String get wrong_product;

  /// No description provided for @product_return_list.
  ///
  /// In he, this message translates to:
  /// **'רשימת מוצרים לבקשת חזרה'**
  String get product_return_list;

  /// No description provided for @add_another_product.
  ///
  /// In he, this message translates to:
  /// **'הוסף עוד מוצר לחזרה'**
  String get add_another_product;

  /// No description provided for @send_the_request.
  ///
  /// In he, this message translates to:
  /// **'שלח את הבקשה'**
  String get send_the_request;

  /// No description provided for @open_refund_invoice.
  ///
  /// In he, this message translates to:
  /// **'הצג חשבונית זיכוי'**
  String get open_refund_invoice;

  /// No description provided for @product_does_not_exist.
  ///
  /// In he, this message translates to:
  /// **'המוצר לא קיים במערכת'**
  String get product_does_not_exist;

  /// No description provided for @date_sent.
  ///
  /// In he, this message translates to:
  /// **'תאריך שליחה:'**
  String get date_sent;

  /// No description provided for @date_approved.
  ///
  /// In he, this message translates to:
  /// **'תאריך אישור:'**
  String get date_approved;

  /// No description provided for @total_refund.
  ///
  /// In he, this message translates to:
  /// **'סך החזרים:'**
  String get total_refund;

  /// No description provided for @view_invoice.
  ///
  /// In he, this message translates to:
  /// **'צפה בחשבונית'**
  String get view_invoice;

  /// No description provided for @enter_units.
  ///
  /// In he, this message translates to:
  /// **'אנא הזן מספר יחידות'**
  String get enter_units;

  /// No description provided for @select_one_option.
  ///
  /// In he, this message translates to:
  /// **'אנא בחר אחת מהאפשרויות'**
  String get select_one_option;

  /// No description provided for @add_one_proof_img.
  ///
  /// In he, this message translates to:
  /// **'אתה צריך להעלות לפחות תמונת הוכחה אחת'**
  String get add_one_proof_img;

  /// No description provided for @return_not_found.
  ///
  /// In he, this message translates to:
  /// **'חזרה לא קיימת'**
  String get return_not_found;

  /// No description provided for @return_deleted.
  ///
  /// In he, this message translates to:
  /// **'חזרה נמחקה בהצלחה'**
  String get return_deleted;

  /// No description provided for @return_summary.
  ///
  /// In he, this message translates to:
  /// **'נתוני חזרה'**
  String get return_summary;

  /// No description provided for @return_created_success.
  ///
  /// In he, this message translates to:
  /// **'החזרה נוצרה בהצלחה'**
  String get return_created_success;

  /// No description provided for @return_updated_success.
  ///
  /// In he, this message translates to:
  /// **'החזרה עודכנה בהצלחה.'**
  String get return_updated_success;

  /// No description provided for @click_to_scan.
  ///
  /// In he, this message translates to:
  /// **'לחץ כאן לסריקת ברקוד של המוצר'**
  String get click_to_scan;

  /// No description provided for @you_have.
  ///
  /// In he, this message translates to:
  /// **'יש לך '**
  String get you_have;

  /// No description provided for @countdown.
  ///
  /// In he, this message translates to:
  /// **'שעות ליצירת הזמנות נוספות ללא הגבלה מינימלית לספק Tavili.'**
  String get countdown;

  /// No description provided for @call_the_agent.
  ///
  /// In he, this message translates to:
  /// **'תתקשר לסוכן'**
  String get call_the_agent;

  /// No description provided for @return_draft_not_sent.
  ///
  /// In he, this message translates to:
  /// **'יש לך החזרות שטרם נשלחו.'**
  String get return_draft_not_sent;

  /// No description provided for @view_return.
  ///
  /// In he, this message translates to:
  /// **'הצג חזרה'**
  String get view_return;

  /// No description provided for @send_any_way.
  ///
  /// In he, this message translates to:
  /// **'שלח בכל זאת'**
  String get send_any_way;

  /// No description provided for @waiting_for_new_order_success_msg.
  ///
  /// In he, this message translates to:
  /// **'ההחזרה נרשמה בהצלחה. לנוחיותכם, ההחזרה תישלח ביום ביצוע ההזמנה הבאה שלכם. עד אז, תוכלו להוסיף החזרות נוספות.'**
  String get waiting_for_new_order_success_msg;

  /// No description provided for @issue_text.
  ///
  /// In he, this message translates to:
  /// **'הסתייגות:'**
  String get issue_text;

  /// No description provided for @return_number_text.
  ///
  /// In he, this message translates to:
  /// **'מספר החזרה:'**
  String get return_number_text;

  /// No description provided for @return_delivery_document_image.
  ///
  /// In he, this message translates to:
  /// **'יש להוסיף תמונה של תעודת המשלוח חתומה כולל ההערות'**
  String get return_delivery_document_image;

  /// No description provided for @driver_return_document_image.
  ///
  /// In he, this message translates to:
  /// **'יש להוסיף תמונה של תעודת החזרה חתומה'**
  String get driver_return_document_image;

  /// No description provided for @basket_loader_text.
  ///
  /// In he, this message translates to:
  /// **'ההזמנה שלך נשלחת עכשיו'**
  String get basket_loader_text;

  /// No description provided for @please_wait_text.
  ///
  /// In he, this message translates to:
  /// **'אנא המתן...'**
  String get please_wait_text;

  /// No description provided for @order_confirmation_loader_text.
  ///
  /// In he, this message translates to:
  /// **'אישור ההזמנה נשלח עכשיו'**
  String get order_confirmation_loader_text;

  /// No description provided for @open_text.
  ///
  /// In he, this message translates to:
  /// **'זיכוי פתוח'**
  String get open_text;

  /// No description provided for @invoice_open.
  ///
  /// In he, this message translates to:
  /// **'פתוח'**
  String get invoice_open;

  /// No description provided for @invoice_close.
  ///
  /// In he, this message translates to:
  /// **'סגור'**
  String get invoice_close;

  /// No description provided for @closed_text.
  ///
  /// In he, this message translates to:
  /// **'זיכוי סגור'**
  String get closed_text;

  /// No description provided for @in_progress_text.
  ///
  /// In he, this message translates to:
  /// **'בתהליך'**
  String get in_progress_text;

  /// No description provided for @partially_closed_text.
  ///
  /// In he, this message translates to:
  /// **'זוכה חלקית'**
  String get partially_closed_text;

  /// No description provided for @refunds_for_order.
  ///
  /// In he, this message translates to:
  /// **'חשבוניות זיכוי עבור הזמנה: '**
  String get refunds_for_order;

  /// No description provided for @my_accounting_card.
  ///
  /// In he, this message translates to:
  /// **'הכרטסת שלי'**
  String get my_accounting_card;

  /// No description provided for @remaining_to_pay.
  ///
  /// In he, this message translates to:
  /// **'יתרה לתשלום'**
  String get remaining_to_pay;

  /// No description provided for @invoices.
  ///
  /// In he, this message translates to:
  /// **'חשבוניות'**
  String get invoices;

  /// No description provided for @refunds.
  ///
  /// In he, this message translates to:
  /// **'זיכויים'**
  String get refunds;

  /// No description provided for @payment_wallet.
  ///
  /// In he, this message translates to:
  /// **'ארנק'**
  String get payment_wallet;

  /// No description provided for @payment_credit_card.
  ///
  /// In he, this message translates to:
  /// **'כרטיס אשראי'**
  String get payment_credit_card;

  /// No description provided for @payment_bank_transfer.
  ///
  /// In he, this message translates to:
  /// **'העברה בנקאית'**
  String get payment_bank_transfer;

  /// No description provided for @payment_bank_check.
  ///
  /// In he, this message translates to:
  /// **'צ\'ק'**
  String get payment_bank_check;

  /// No description provided for @invoice_date_range.
  ///
  /// In he, this message translates to:
  /// **'טווח תאריכים של חשבונית'**
  String get invoice_date_range;

  /// No description provided for @refunds_date_range.
  ///
  /// In he, this message translates to:
  /// **'טווח תאריכי החזרים'**
  String get refunds_date_range;

  /// No description provided for @select_date.
  ///
  /// In he, this message translates to:
  /// **'בחר תאריך'**
  String get select_date;

  /// No description provided for @maximum_three_month_date_range_required.
  ///
  /// In he, this message translates to:
  /// **'טווח תאריכים מקסימלי של 3 חודשים'**
  String get maximum_three_month_date_range_required;

  /// No description provided for @date_range.
  ///
  /// In he, this message translates to:
  /// **'טווח תאריכים'**
  String get date_range;

  /// No description provided for @my_clients.
  ///
  /// In he, this message translates to:
  /// **'הלקוחות שלי'**
  String get my_clients;

  /// No description provided for @switch_back_to_agent_view.
  ///
  /// In he, this message translates to:
  /// **'עבור חזרה למשתמש שלי'**
  String get switch_back_to_agent_view;

  /// No description provided for @clients_switch.
  ///
  /// In he, this message translates to:
  /// **'התחבר'**
  String get clients_switch;

  /// No description provided for @clients_set_minimum.
  ///
  /// In he, this message translates to:
  /// **'הגדר מינימום'**
  String get clients_set_minimum;

  /// No description provided for @clients_minimum_order.
  ///
  /// In he, this message translates to:
  /// **'מינימום :'**
  String get clients_minimum_order;

  /// No description provided for @clients_no_minimum.
  ///
  /// In he, this message translates to:
  /// **'אין מינימום'**
  String get clients_no_minimum;

  /// No description provided for @confirmation_no_minimum.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח שברצונך לעדכן שלא יהיה מינימום הזמנה בשעה הקרובה?'**
  String get confirmation_no_minimum;

  /// No description provided for @confirmation_minimum.
  ///
  /// In he, this message translates to:
  /// **'האם אתה בטוח שאתה רוצה לעדכן שכן יהיה מינימום הזמנה?'**
  String get confirmation_minimum;

  /// No description provided for @switch_client_message.
  ///
  /// In he, this message translates to:
  /// **'אתה מחובר עכשיו כלקוח: '**
  String get switch_client_message;

  /// No description provided for @switch_agent_message.
  ///
  /// In he, this message translates to:
  /// **'אתה עכשיו מחובר כסוכן'**
  String get switch_agent_message;

  /// No description provided for @no_suppliers_found.
  ///
  /// In he, this message translates to:
  /// **'לא נמצאו ספקים'**
  String get no_suppliers_found;

  /// No description provided for @invoice_payment.
  ///
  /// In he, this message translates to:
  /// **'תשלום חשבונית'**
  String get invoice_payment;

  /// No description provided for @making_pay_with_credit_card.
  ///
  /// In he, this message translates to:
  /// **'ביצוע תשלום בכרטיס אשראי'**
  String get making_pay_with_credit_card;

  /// No description provided for @credit_card_payment_error.
  ///
  /// In he, this message translates to:
  /// **'אירעה שגיאה בעת עיבוד התשלום בכרטיס האשראי עבור החשבונית'**
  String get credit_card_payment_error;

  /// No description provided for @credit_card_payment_success.
  ///
  /// In he, this message translates to:
  /// **'הצלחה! החשבונית שלך שולמה באמצעות כרטיס האשראי שלך.'**
  String get credit_card_payment_success;

  /// No description provided for @pdf_loading.
  ///
  /// In he, this message translates to:
  /// **'קובץ ה-PDF עדיין נטען. אנא המתן.'**
  String get pdf_loading;

  /// No description provided for @unable_pdf.
  ///
  /// In he, this message translates to:
  /// **'לא ניתן לשתף את קובץ ה-PDF. אנא נסה שוב.'**
  String get unable_pdf;

  /// No description provided for @sold_units.
  ///
  /// In he, this message translates to:
  /// **'נמכר ביחידות'**
  String get sold_units;

  /// No description provided for @supplier_delivery_schedule_title.
  ///
  /// In he, this message translates to:
  /// **'ימי אספקה — {city}'**
  String supplier_delivery_schedule_title(String city);

  /// No description provided for @supplier_delivery_schedule_button.
  ///
  /// In he, this message translates to:
  /// **'ימי אספקה'**
  String get supplier_delivery_schedule_button;

  /// No description provided for @supplier_delivery_schedule_delivery_on.
  ///
  /// In he, this message translates to:
  /// **'אספקה'**
  String get supplier_delivery_schedule_delivery_on;

  /// No description provided for @supplier_delivery_schedule_order_until.
  ///
  /// In he, this message translates to:
  /// **'הזמנה עד'**
  String get supplier_delivery_schedule_order_until;

  /// No description provided for @supplier_delivery_schedule_until_time.
  ///
  /// In he, this message translates to:
  /// **'עד {time}'**
  String supplier_delivery_schedule_until_time(String time);

  /// No description provided for @verify_data_correct.
  ///
  /// In he, this message translates to:
  /// **'וודא שהנתונים נכונים'**
  String get verify_data_correct;

  /// No description provided for @verify_form_subtitle.
  ///
  /// In he, this message translates to:
  /// **'אנא בדוק ועדכן את הפרטים לפני המשך ההזמנה'**
  String get verify_form_subtitle;

  /// No description provided for @business_details_section.
  ///
  /// In he, this message translates to:
  /// **'פרטי העסק'**
  String get business_details_section;

  /// No description provided for @address_section.
  ///
  /// In he, this message translates to:
  /// **'כתובת העסק'**
  String get address_section;

  /// No description provided for @delivery_section.
  ///
  /// In he, this message translates to:
  /// **'פרטי הורדת סחורה'**
  String get delivery_section;

  /// No description provided for @waze_location_saved.
  ///
  /// In he, this message translates to:
  /// **'מיקום Waze נשמר'**
  String get waze_location_saved;

  /// No description provided for @verify_phone_number.
  ///
  /// In he, this message translates to:
  /// **'מספר טלפון'**
  String get verify_phone_number;

  /// No description provided for @delivery_location_description.
  ///
  /// In he, this message translates to:
  /// **'תיאור מיקום להורדת סחורה'**
  String get delivery_location_description;

  /// No description provided for @waze_delivery_location.
  ///
  /// In he, this message translates to:
  /// **'מיקום Waze להורדת סחורה'**
  String get waze_delivery_location;

  /// No description provided for @open_waze_to_set_location.
  ///
  /// In he, this message translates to:
  /// **'פתח ב-Waze לבחירת מיקום'**
  String get open_waze_to_set_location;

  /// No description provided for @delivery_location_photo.
  ///
  /// In he, this message translates to:
  /// **'תמונה של מיקום להורדת סחורה'**
  String get delivery_location_photo;
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
