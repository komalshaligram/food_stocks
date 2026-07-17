// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import '../../main.dart';
// import '../../routes/app_routes.dart';
// import '../../ui/utils/constants/app_strings.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'
// as flutter_local_notifications;
// import '../../data/storage/shared_preferences_helper.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class PushNotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   late AndroidNotificationChannel channel;
//   String id = '';
//   int notificationCount = 0;
//   String mainPage = '';
//   String subPage = '';
//   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//   Future<void> setupInteractedMessage() async {
//     if (Platform.isAndroid) {
//       NotificationSettings settings = await firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     } else {
//       PermissionStatus status = await Permission.notification.request();
//       if (status.isGranted) {
//         debugPrint('Granted!!!');
//         // notification permission is granted
//       } else {
//         // Open settings to enable notification permission
//       }
//     }
//
//     FirebaseMessaging.onMessageOpenedApp.listen(
//           (RemoteMessage message) async {
//         debugPrint('_____Here at onMessageOpenedApp....$message');
//         var data = json.decode(message.data['data'].toString());
//         debugPrint('_____onMessage_______${data.toString()}');
//         debugPrint('_____onMessage Noti_______${message.notification.toString()}');
//         debugPrint('main_page_____$mainPage');
//         debugPrint('sub_page_____$subPage');
//         debugPrint('id_____$id');
//         FlutterAppBadger.removeBadge();
//         SharedPreferencesHelper preferences =
//         SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
//         if(preferences.getSubUser()){
//           mainPage = data['notification']['message']['subUserMainPage'] ?? '';
//           subPage = data['notification']['message']['subUserSubPage'] ?? '';
//           id = data['notification']['message']['subUserId'] ?? '';
//
//         }
//         else{
//           mainPage = data['notification']['message']['mainPage'] ?? '';
//           subPage = data['notification']['message']['subPage'] ?? '';
//           id = data['notification']['message']['id'] ?? '';
//
//         }
//        showNotification(title: data['message']['title'],body: data['message']['body'],data: data,imageUrl: data['image'] ?? '',notiId: 0);
//
//       },
//     );
//
//     enableIOSNotifications();
//     await registerNotificationListeners();
//   }
//
//    handleMessage(String mainPage,String subPage, String id)  async {
//
//     debugPrint('_______handleMessage...');
//     debugPrint('main_page_____$mainPage');
//     debugPrint('sub_page_____$subPage');
//     debugPrint('id_____$id');
//
//     if (subPage == '') {
//       debugPrint('_______handleMessage1...');
//       if (mainPage == 'companyScreen') {
//         debugPrint('_______handleMessage2...${navigatorKey.currentState.toString()}');
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//             RouteDefine.companyScreen.name,
//             arguments: {AppStrings.companyIdString: id});
//         debugPrint('_______handleMessage3...');
//       }
//       if (mainPage == 'saleScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//           RouteDefine.productSaleScreen.name,);
//       }
//
//       if (mainPage == 'orderScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//           RouteDefine.orderScreen.name,);
//       }
//
//       if (mainPage == 'supplierScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//             RouteDefine.supplierScreen.name,
//             arguments: {AppStrings.companyIdString: id});
//       }
//       if (mainPage == 'storeScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//             RouteDefine.bottomNavScreen.name, arguments: {
//               AppStrings.companyIdString: id,
//               AppStrings.pushNavigationString: 'storeScreen'
//             });
//       }
//     } else {
//       if (subPage == 'companyProductsScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//             RouteDefine.companyProductsScreen.name,
//             arguments: {AppStrings.companyIdString: id});
//       }
//       else if (subPage == 'saleProductScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//             RouteDefine.productSaleScreen.name,
//             arguments: {AppStrings.companyIdString: id});
//       } else if (subPage == 'supplierProductsScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//             RouteDefine.supplierProductsScreen.name,
//             arguments: {AppStrings.supplierIdString: id});
//       } else if (subPage == 'catagoryScreen' ||
//           subPage == 'storeCategoryScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//             RouteDefine.storeCategoryScreen.name,
//             arguments: {AppStrings.companyIdString: id});
//       } else if (subPage == 'planogramScreen' ||
//           subPage == 'planogramProductScreen') {
//         Navigator.pushNamed(navigatorKey.currentState!.context,
//             RouteDefine.storeCategoryScreen.name,
//             arguments: {
//               AppStrings.companyIdString: id,
//               AppStrings.isSubCategory: 'false',
//             });
//       } else {
//         AppRouting.generateRoute(RouteSettings(
//           name: RouteDefine.splashScreen.name,
//         ));
//       }
//     }
//   }
//
//   Future<void> registerNotificationListeners() async {
//     channel = androidNotificationChannel();
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@drawable/ic_launcher1');
//     const DarwinInitializationSettings iOSSettings =
//     DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//     await Future.delayed(const Duration(seconds: 1));
//
//     String? fcmToken = '';
//
//     fcmToken = await FirebaseMessaging.instance.getToken();
//
//     SharedPreferencesHelper preferences =
//     SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
//     preferences.setFCMToken(fcmTokenId: fcmToken??'');
//     debugPrint("FCM Token: ${preferences.getFCMToken()}");
//     const InitializationSettings initSettings =
//     InitializationSettings(android: androidSettings, iOS: iOSSettings);
//     flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse details) {
//         debugPrint("__________details______:$details");
//         debugPrint('main_page_____$mainPage');
//         debugPrint('sub_page_____$subPage');
//         debugPrint('id_____$id');
//         //handleMessage(mainPage, subPage, id);
//       },
//     );
// // onMessage is called when the app is in foreground and a notification is received
//     // app is open
//     FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
//       var data = json.decode(message!.data['data'].toString());
//       FlutterAppBadger.removeBadge();
//       debugPrint('_____onMessage_______${data.toString()}');
//       //debugPrint('_____onMessage_______${data['data']['image'].toString()}');
//       //debugPrint('_____onMessage Noti_______${message.notification!.apple!.imageUrl!}');
//       if(Platform.isAndroid){
//       showNotification(imageUrl:data['data']['image'], notiId: 0, title: message.notification!.title??'', body: message.notification!.body??'',
//       data: data
//       );
//      }
//     });
//   }
//
//   showNotification({
//     required String imageUrl,
//     required int notiId,
//     required String title,
//     required String body,
//     var data,
//
//   }) async {
//     debugPrint('____notification_____');
//     debugPrint('main_page_____$mainPage');
//     debugPrint('sub_page_____$subPage');
//     debugPrint('id_____$id');
//     debugPrint('data_____$data');
//     channel = androidNotificationChannel();
//     SharedPreferencesHelper preferences =
//     SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
//
//     Uint8List? imageByte;
//     String? fileName;
//     if (imageUrl.isNotEmpty) {
//       Directory dir;
//       if (Platform.isAndroid) {
//         dir = await getTemporaryDirectory();
//       } else {
//         dir = await getApplicationDocumentsDirectory();
//       }
//       // Create an image name
//       fileName = '${dir.path}/image.png';
//       // Save to filesystem
//       final file = File(fileName);
//
//       imageByte =
//           (await NetworkAssetBundle(Uri.parse(imageUrl))
//               .load(imageUrl))
//               .buffer
//               .asUint8List();
//       await file.writeAsBytes(imageByte.toList());
//     }else{
//       fileName = null;
//     }
//     debugPrint('ide___$id');
//     notificationCount = notificationCount++;
//     await flutterLocalNotificationsPlugin.show(
//         notiId,
//         Bidi.stripHtmlIfNeeded(title),
//         Bidi.stripHtmlIfNeeded(body),
//         flutter_local_notifications.NotificationDetails(
//             android: imageByte!=null
//                 ? AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               importance: Importance.high,
//               priority: Priority.max,
//               channelShowBadge: true,
//               largeIcon:ByteArrayAndroidBitmap(imageByte),
//             )
//                 : AndroidNotificationDetails(channel.id, channel.name,
//                 channelDescription: channel.description,
//                 importance: Importance.high,
//                 priority: Priority.max,
//                 channelShowBadge: true),
//             iOS: DarwinNotificationDetails(presentBanner: true,attachments: [DarwinNotificationAttachment(fileName ?? '')]
//             ))
//     );
//     FlutterAppBadger.updateBadgeCount(notificationCount);
//     handleMessage(mainPage, subPage, id);
//   }
//   Future<File> writeToFile(ByteData data) async {
//     final buffer = data.buffer;
//     Directory tempDir = await getTemporaryDirectory();
//     String tempPath = tempDir.path;
//     var filePath = '$tempPath/file_01.tmp'; // file_01.tmp is dump file, can be anything
//     return  File(filePath).writeAsBytes(
//         buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//   }
//
//   Future<void> enableIOSNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//   }
//
//   AndroidNotificationChannel androidNotificationChannel() =>
//       const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         description:
//         'This channel is used for important notifications.', // description
//         importance: Importance.max,
//         showBadge: false,
//       );
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import '../../main.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;
import '../../data/storage/shared_preferences_helper.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../doc_scan/core/services/doc_scan_notifications.dart';

class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  String id = '';
  int notificationCount = 0;
  String mainPage = '';
  String subPage = '';
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupInteractedMessage() async {
    if (Platform.isAndroid) {
      await firebaseMessaging.requestPermission(
          alert: true, badge: true, sound: true);
    } else {
      await Permission.notification.request();
    }

    /// 🔹 Token refresh listener (ADDED)
    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      SharedPreferencesHelper preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      preferences.setFCMToken(fcmTokenId: newToken);
      debugPrint("FCM Token refreshed: $newToken");
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        var data = json.decode(message.data['data'].toString());
        FlutterAppBadger.removeBadge();

        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());

        if (preferences.getSubUser()) {
          mainPage = data['notification']['message']['subUserMainPage'] ?? '';
          subPage = data['notification']['message']['subUserSubPage'] ?? '';
          id = data['notification']['message']['subUserId'] ?? '';
        } else {
          mainPage = data['notification']['message']['mainPage'] ?? '';
          subPage = data['notification']['message']['subPage'] ?? '';
          id = data['notification']['message']['id'] ?? '';
        }

        showNotification(
            title: data['message']['title'],
            body: data['message']['body'],
            data: data,
            imageUrl: data['image'] ?? '',
            notiId: 0);
      },
    );

    enableIOSNotifications();

    /// 🔹 protected call (ADDED)
    try {
      await registerNotificationListeners();
    } catch (e) {
      debugPrint("registerNotificationListeners error: $e");
    }
  }

  /// מביא את מסך סריקת התעודות לחזית, כדי שה-DocScanShell יעלה ויפתח את המסמך.
  /// אם כבר פתוח — לא דוחפים שוב (בדיקת ה-shell תטפל ב-pending).
  void _openDocScanScreen() {
    final nav = navigatorKey.currentState;
    if (nav == null) return;
    nav.pushNamed(RouteDefine.certificateScanningScreen.name);
  }

  handleMessage(String mainPage, String subPage, String id) async {
    if (navigatorKey.currentState == null) return;

    if (subPage == '') {
      if (mainPage == 'companyScreen') {
        Navigator.pushNamed(
            navigatorKey.currentState!.context, RouteDefine.companyScreen.name,
            arguments: {AppStrings.companyIdString: id});
      }
      if (mainPage == 'saleScreen') {
        Navigator.pushNamed(navigatorKey.currentState!.context,
            RouteDefine.productSaleScreen.name);
      }
      if (mainPage == 'orderScreen') {
        Navigator.pushNamed(
            navigatorKey.currentState!.context, RouteDefine.orderScreen.name);
      }
    }
  }

  Future<void> registerNotificationListeners() async {
    channel = androidNotificationChannel();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_launcher1');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    /// 🔹 FCM TOKEN FIX (MINIMAL)
    SharedPreferencesHelper preferences =
        SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

    String? cachedToken = preferences.getFCMToken();

    if (cachedToken.isEmpty) {
      try {
        String? token = await firebaseMessaging.getToken();
        if (token != null && token.isNotEmpty) {
          preferences.setFCMToken(fcmTokenId: token);
          debugPrint("FCM Token (new): $token");
        }
      } catch (e) {
        debugPrint("FCM getToken error: $e");
      }
    } else {
      debugPrint("FCM Token (cached): $cachedToken");
    }

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) {
        // התראת doc_scan (סטטוס סריקה/קליטה): מביאים את מסך הסריקה לחזית (אם לא
        // פתוח) ואז מטפלים ב-payload — ה-shell יפתח את המסמך כשיעלה.
        final payload = resp.payload ?? '';
        if (payload.startsWith(DocScanNotifications.payloadPrefix)) {
          // רק אם הסורק לא פתוח — מביאים אותו לחזית (אחרת ניצור עותק כפול).
          if (!DocScanNotifications.instance.shellMounted) _openDocScanScreen();
          DocScanNotifications.instance.handleTapPayload(payload);
          return;
        }

        handleMessage(mainPage, subPage, id);
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      var data = json.decode(message!.data['data'].toString());
      FlutterAppBadger.removeBadge();

      if (Platform.isAndroid) {
        showNotification(
            imageUrl: data['data']['image'],
            notiId: 0,
            title: message.notification!.title ?? '',
            body: message.notification!.body ?? '',
            data: data);
      }
    });
  }

  showNotification(
      {required String imageUrl,
      required int notiId,
      required String title,
      required String body,
      var data}) async {
    channel = androidNotificationChannel();

    Uint8List? imageByte;
    String? fileName;

    if (imageUrl.isNotEmpty) {
      Directory dir = await getTemporaryDirectory();
      fileName = '${dir.path}/image.png';

      final file = File(fileName);
      imageByte = (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
          .buffer
          .asUint8List();

      await file.writeAsBytes(imageByte);
    }

    /// 🔹 FIXED
    notificationCount++;

    await flutterLocalNotificationsPlugin.show(
      notiId,
      Bidi.stripHtmlIfNeeded(title),
      Bidi.stripHtmlIfNeeded(body),
      flutter_local_notifications.NotificationDetails(
        android: imageByte != null
            ? AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                priority: Priority.max,
                largeIcon: ByteArrayAndroidBitmap(imageByte),
              )
            : AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                priority: Priority.max),
        iOS: DarwinNotificationDetails(
            presentBanner: true,
            attachments: fileName != null
                ? [DarwinNotificationAttachment(fileName)]
                : []),
      ),
    );

    FlutterAppBadger.updateBadgeCount(notificationCount);
    handleMessage(mainPage, subPage, id);
  }

  Future<void> enableIOSNotifications() async {
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        showBadge: false,
      );
}
