import 'dart:convert';
import 'dart:io';

import 'package:eraser/eraser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:food_stock/main.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var fileName;

  late AndroidNotificationChannel channel;
  String mainPage = '';
  String subPage = '';
  String id = '';
  int notificationCount = 0;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  _handleMessage(RemoteMessage message,bool showNoti) {
    var data = json.decode(message.data['data'].toString());
    final RemoteNotification? notification = message.notification;
    final String? messageId = message.messageId;
    debugPrint('messageId___2___${messageId}');
    final AndroidNotification? android = message.notification?.android;
    debugPrint('data:${data.toString()}');
    if (data['isRead']) {
      notificationCount = notificationCount + 1;
    }
    if (data != null) {
      showNotification(
          notiId: notification.hashCode,
          androidIcon: android?.smallIcon ?? '',
          data: data,
          isNavigate: !showNoti,
          showNotification: showNoti,
          isAppOpen: false);
    }
    FlutterAppBadger.updateBadgeCount(notificationCount);
  }

  Future<void> setupInteractedMessage() async {
    if (Platform.isAndroid) {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('User granted permission: ${settings.authorizationStatus}');
    } else {
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        debugPrint('Granted!!!');
        // notification permission is granted
      } else {
        // Open settings to enable notification permission
      }
    }


    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        if (message != null) {
          _handleMessage(message,true);
        }
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      debugPrint('_______background calling...');
      if (message != null) {
        _handleMessage(message,true);
      }
    });
    enableIOSNotifications();
    await registerNotificationListeners();
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
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    String? fcmToken = '';

    fcmToken = Platform.isAndroid?await FirebaseMessaging.instance.getToken():await FirebaseMessaging.instance.getToken();

    SharedPreferencesHelper preferences =
        SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    preferences.setFCMToken(fcmTokenId: fcmToken??'');
    debugPrint("FCM Token: ${preferences.getFCMToken()}");
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint("__________details______:${details}");
        FlutterAppBadger.removeBadge();
            manageNavigation(isAppOpen: true,mainPage:  mainPage,subPage:  subPage, id: id);
      },
    );
// onMessage is called when the app is in foreground and a notification is received
    // app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      debugPrint('_____onMessage_______');
      var data = json.decode(message!.data['data'].toString());

      final RemoteNotification? notification = message.notification;
      if (notification != null) {
        final String? messageId = message.messageId;
        debugPrint('open app___${messageId}');
        final AndroidNotification? android = message.notification?.android;
        debugPrint('data:${data.toString()}');

        if (data != null) {
            showNotification(
              notiId: notification.hashCode,
              androidIcon: android?.smallIcon ?? '',
              data: data,
              isNavigate: false,
              showNotification: true,
              isAppOpen: true);
        }

        FlutterAppBadger.removeBadge();
      }
    });
  }

  showNotification({
    required int notiId,
    String? androidIcon,
    var data,
    required bool isNavigate,
    required bool showNotification,
    required bool isAppOpen,
  }) async {
    debugPrint('____notification_____');
    channel = androidNotificationChannel();
    String? title = Bidi.stripHtmlIfNeeded(data['message']['title'].toString());
    String? body = Bidi.stripHtmlIfNeeded(data['message']['body'].toString());
    SharedPreferencesHelper preferences = SharedPreferencesHelper(
        prefs: await SharedPreferences.getInstance());
    String imageUrl = '';
    print('preference____${preferences.getSubUser()}');
    if(preferences.getSubUser()){
      mainPage = data['message']['subUserMainPage'] ?? '';
      subPage = data['message']['subUserSubPage'] ?? '';
      id = data['message']['subUserId'] ?? '';
      imageUrl = data['message']['imageUrl'] ?? '';
    }
    else{
      mainPage = data['message']['mainPage'] ?? '';
      subPage = data['message']['subPage'] ?? '';
      id = data['message']['id'] ?? '';
      imageUrl = data['message']['imageUrl'] ?? '';
    }


    Uint8List? imageByte;
    if (imageUrl.isNotEmpty) {
      Directory dir;
      if (Platform.isAndroid) {
        dir = await getTemporaryDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }
      // Create an image name
      fileName = '${dir.path}/image.png';
      // Save to filesystem
      final file = File(fileName);

      imageByte =
          (await NetworkAssetBundle(Uri.parse(AppUrls.baseFileUrl + imageUrl))
                  .load(AppUrls.baseFileUrl + imageUrl))
              .buffer
              .asUint8List();
      await file.writeAsBytes(imageByte.toList());

      debugPrint('imageBytes:$imageByte');
    }else{
      fileName = null;
    }
    debugPrint('subPage___${subPage}');
    debugPrint('mainPage___${mainPage}');
    debugPrint('ide___${id}');
    debugPrint('isNavigate___${isNavigate}');
    debugPrint('showNotification___${showNotification}');

    if (showNotification) {
      debugPrint('fileName_____${fileName}');
     await flutterLocalNotificationsPlugin.show(
        notiId,
        title,
        body,
        Platform.isAndroid
            ? flutter_local_notifications.NotificationDetails(
                android: imageByte != null
                    ? AndroidNotificationDetails(
                        channel.id,
                        channel.name,
                        channelDescription: channel.description,
                        icon: androidIcon ?? '',
                        channelShowBadge: true,
                        largeIcon: ByteArrayAndroidBitmap(imageByte),
                      )
                    : AndroidNotificationDetails(channel.id, channel.name,
                        channelDescription: channel.description,
                        icon: androidIcon ?? '',
                        channelShowBadge: true),
              )
            : flutter_local_notifications.NotificationDetails(
                iOS: fileName != null
                    ? DarwinNotificationDetails(
                        attachments: [DarwinNotificationAttachment(fileName)])
                    : DarwinNotificationDetails(),
              ),
        // payload: message.data.toString(),
      );
    }
    if (isNavigate /*&& showNotification*/) {
      print('___________navigation');
      manageNavigation(isAppOpen: isAppOpen, mainPage: mainPage, subPage: subPage, id: id);
    }
  }

  void manageNavigation(
      {bool isAppOpen = false,
      String?mainPage = '',
      String? subPage = '',
      String? id = ''}) {
    debugPrint('main  1 = ${mainPage}');
    debugPrint('subPage   1= ${subPage}');
    debugPrint('id 1= ${id}');
    debugPrint('isAppOpen = ${isAppOpen}');

    if (isAppOpen) {
      debugPrint('subPage  1 = ${subPage}');
      if (subPage == '') {
        if (mainPage == 'companyScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.companyScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
        if (mainPage == 'saleScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.productSaleScreen.name,);
        }
        if (mainPage == 'supplierScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.supplierScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
        if (mainPage == 'storeScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.bottomNavScreen.name, arguments: {
            AppStrings.companyIdString: id,
            AppStrings.pushNavigationString: 'storeScreen'
          });
        }
      } else {
        if (subPage == 'companyProductsScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.companyProductsScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
        else if (subPage == 'saleProductScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.productSaleScreen.name,
              arguments: {AppStrings.companyIdString: id});
        } else if (subPage == 'supplierProductsScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.supplierProductsScreen.name,
              arguments: {AppStrings.supplierIdString: id});
        } else if (subPage == 'catagoryScreen' ||
            subPage == 'storeCategoryScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.storeCategoryScreen.name,
              arguments: {AppStrings.companyIdString: id});
        } else if (subPage == 'planogramScreen' ||
            subPage == 'planogramProductScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.storeCategoryScreen.name,
              arguments: {
                AppStrings.companyIdString: id,
                AppStrings.isSubCategory: 'false',
              });
        } else {
          AppRouting.generateRoute(RouteSettings(
            name: RouteDefine.splashScreen.name,
          ));
        }
      }
    } else {
      AppRouting.generateRoute(RouteSettings(
        name: RouteDefine.splashScreen.name,
      ));
    }
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.max,
        showBadge: false,
      );
}