import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/invoice_document.dart';

/// התראות **מקומיות** (המכשיר לעצמו) על מעברי סטטוס של סריקת מסמך.
///
/// לא push מהשרת — המכשיר יורה אותן בעצמו כשמשתנה סטטוס, כדי שהמשתמש יידע
/// גם כשהאפליקציה ברקע. עצמאי מ-`PushNotificationService` הראשי (של Firebase)
/// כדי לא לשבור אותו, אבל **משתמש באותו ערוץ אנדרואיד** שכבר נוצר שם.
///
/// עובד ב-iOS וב-Android. ב-iOS ההרשאה כבר מתבקשת ע"י שירות ה-push הראשי;
/// כאן מבקשים גם הרשאת Android 13+ (POST_NOTIFICATIONS) שהיא runtime.
class DocScanNotifications {
  DocScanNotifications._();
  static final DocScanNotifications instance = DocScanNotifications._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// אותו ערוץ שהשירות הראשי יוצר — אין צורך ליצור חדש.
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';

  bool _initialized = false;

  /// נקרא כשמשתמש מקיש על התראה — מקבל את ה-payload (mobileDocumentId).
  /// נרשם ע"י שכבת ה-UI שיש לה גישה ל-router.
  void Function(String documentId)? onTapDocument;

  /// קידומת שמזהה התראה של doc_scan (מבדילה מהתראות Firebase של האפליקציה).
  static const String payloadPrefix = 'docscan:';

  /// מסמך שהמתין לניווט כשה-shell עוד לא היה mounted (cold start / פתיחה במסך
  /// אחר). נצרך ע"י ה-shell ברגע שהוא עולה. null = אין ממתין.
  String? pendingDocumentId;

  /// האם ה-DocScanShell כרגע mounted. השירות הראשי בודק זאת: אם כן — אין צורך
  /// לדחוף את מסך הסריקה (ה-shell יטפל ישירות); אם לא — צריך להביאו לחזית.
  bool shellMounted = false;

  /// אם ה-payload שייך ל-doc_scan — מנתב למסמך ומחזיר true. אחרת false.
  /// נקרא **גם** ע"י ה-callback של השירות הראשי (הם חולקים plugin יחיד).
  bool handleTapPayload(String? payload) {
    if (payload == null || !payload.startsWith(payloadPrefix)) return false;
    final id = payload.substring(payloadPrefix.length);
    // תמיד שומרים כ"ממתין" — כך גם אם ה-shell עוד לא mounted, הוא יפתח כשיעלה.
    pendingDocumentId = id;
    onTapDocument?.call(id);
    return true;
  }

  /// נצרך ע"י ה-shell: מחזיר את ה-payload הממתין (ומנקה אותו), או null.
  String? consumePending() {
    final id = pendingDocumentId;
    pendingDocumentId = null;
    return id;
  }

  /// מאתחל את ה-plugin, רושם את מטפל הלחיצה, ובודק אם האפליקציה **הופעלה**
  /// ע"י הקשה על התראה (cold start). בטוח לקריאה חוזרת.
  Future<void> init({void Function(String documentId)? onTap}) async {
    if (onTap != null) onTapDocument = onTap;
    await _ensureInitialized();
    // cold start: האפליקציה נפתחה מהקשה על התראה בזמן שהייתה סגורה.
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      handleTapPayload(launch?.notificationResponse?.payload);
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    // חשוב: **לא** קוראים כאן ל-`_plugin.initialize()`. ה-plugin הוא singleton
    // שכבר אותחל ע"י PushNotificationService בעליית האפליקציה, וה-callback שלו
    // (onDidReceiveNotificationResponse) הוא היחיד שיודע להביא את מסך הסורק
    // לחזית כשהוא לא פתוח (`_openDocScanScreen`) לפני הטיפול ב-payload. אם היינו
    // מאתחלים כאן מחדש, היינו דורסים את אותו callback ב-callback חלקי שלא פותח
    // את המסך — וזה בדיוק מה ששבר את הניווט מהתראה שברקע.
    //
    // כאן רק מבקשים הרשאת runtime של Android 13+ (iOS כבר מכוסה ע"י ה-push הראשי).
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _initialized = true;
  }

  Future<void> _show(int id, String title, String body, String docId) async {
    try {
      await _ensureInitialized();
      await _plugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(presentBanner: true),
        ),
        payload: '$payloadPrefix$docId',
      );
    } catch (e) {
      // התראה שנכשלה אסור שתפיל את זרימת הסריקה.
      debugPrint('[DocScanNotifications] show failed: $e');
    }
  }

  /// מזהה יציב פר-מסמך, כדי שהתראה חדשה על אותו מסמך **תחליף** את הקודמת
  /// (לא תיצור ערימה). נגזר מ-hashCode של ה-mobileDocumentId.
  int _idFor(String docId) => docId.hashCode & 0x7fffffff;

  /// הסריקה הסתיימה בהצלחה — המסמך מוכן, ממתין לשליחה לקופה.
  Future<void> scanReady(InvoiceDocument doc) => _show(
        _idFor(doc.id),
        'הסריקה הסתיימה',
        _withSupplier(doc, 'המסמך מוכן — ממתין לשליחה לקופה.'),
        doc.id,
      );

  /// שגיאה בסריקה (OCR נכשל).
  Future<void> scanFailed(InvoiceDocument doc) => _show(
        _idFor(doc.id),
        'הסריקה נכשלה',
        _withSupplier(doc, 'אירעה שגיאה בקריאת המסמך. נסה לסרוק שוב.'),
        doc.id,
      );

  /// הקליטה ל-Comax הסתיימה בהצלחה.
  Future<void> intakeReceived(InvoiceDocument doc) => _show(
        _idFor(doc.id),
        'נקלט בקופה',
        _withSupplier(
          doc,
          doc.comaxDocNumber != null && doc.comaxDocNumber!.isNotEmpty
              ? 'המסמך נקלט ב-Comax (מסמך ${doc.comaxDocNumber}).'
              : 'המסמך נקלט ב-Comax בהצלחה.',
        ),
        doc.id,
      );

  /// הקליטה ל-Comax נכשלה.
  Future<void> intakeFailed(InvoiceDocument doc) => _show(
        _idFor(doc.id),
        'הקליטה לקופה נכשלה',
        _withSupplier(
          doc,
          (doc.comaxReceiveError != null && doc.comaxReceiveError!.isNotEmpty)
              ? doc.comaxReceiveError!
              : 'אירעה שגיאה בהזנת המסמך ל-Comax.',
        ),
        doc.id,
      );

  /// משרשר את שם הספק לגוף ההודעה כשקיים, לזיהוי מהיר.
  String _withSupplier(InvoiceDocument doc, String body) {
    final name = (doc.companyName ?? '').trim();
    return name.isEmpty ? body : '$name — $body';
  }
}
