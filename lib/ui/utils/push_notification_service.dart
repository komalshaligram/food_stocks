import 'dart:io';
import 'package:flutter/services.dart';
import 'package:food_stock/main.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
as flutter_local_notifications;
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  String id = '';
  int notificationCount = 0;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

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
            debugPrint('_____Here at onMessageOpenedApp....$message');
        if (message != null) {
          debugPrint('onMessageOpenedApp:${message.data}');
          debugPrint("main page1:${message.data['mainPage']}");
          debugPrint("sub page1:${message.data['subPage']}");
        }
      },
    );

    enableIOSNotifications();
    await registerNotificationListeners();
  }

/*  Future<void> manageNavOnKilled(RemoteMessage message) async {
    debugPrint('_______background calling...');
    debugPrint('onMessageOpenedApp:$message');
    debugPrint("main page:${message.data['mainPage']}");
    debugPrint("sub page:${message.data['subPage']}");
    handleMessage(message.data['mainPage'],message.data['subPage']??'',message.data['_id']);
    }*/

  Future<void> handleMessage(String mainPage,String subPage, String id)  async {
  debugPrint('_______handleMessage...');
    if (subPage == '') {
      debugPrint('_______handleMessage1...');
      if (mainPage == 'companyScreen') {
        debugPrint('_______handleMessage2...${navigatorKey.currentState.toString()}');
        Navigator.pushNamed(navigatorKey.currentState!.context,
            RouteDefine.companyScreen.name,
            arguments: {AppStrings.companyIdString: id});
        debugPrint('_______handleMessage3...');
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

      },
    );
// onMessage is called when the app is in foreground and a notification is received
    // app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      debugPrint('_____onMessage_______${message!.data['image'].toString()}');
      debugPrint('_____onMessage_______${message.data['image'].toString()}');
      if(Platform.isAndroid){
        showNotification(imageUrl: message.data['image'], notiId: 0, title: message.notification!.title??'', body: message.notification!.body??'');
      }
    });
  }

  showNotification({
    required String imageUrl,
    required int notiId,
    required String title,
    required String body,
  }) async {
    debugPrint('____notification_____');
    channel = androidNotificationChannel();

    Uint8List? imageByte;
    if (imageUrl.isNotEmpty) {
      imageByte = (await NetworkAssetBundle(Uri.parse(imageUrl))
          .load(imageUrl))
          .buffer
          .asUint8List();
      debugPrint('imageUrl__${imageByte}');
    }

    debugPrint('ide___${id}');
      await flutterLocalNotificationsPlugin.show(
        notiId,
        Bidi.stripHtmlIfNeeded(title),
        Bidi.stripHtmlIfNeeded(body),
       flutter_local_notifications.NotificationDetails(
          android: imageByte!=null
              ? AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.max,
            channelShowBadge: true,
              largeIcon:ByteArrayAndroidBitmap(imageByte),
          )
              : AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              priority: Priority.max,
              channelShowBadge: true),
        )
      );
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