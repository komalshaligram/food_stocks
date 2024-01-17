import 'dart:convert';
import 'dart:io';
import 'package:food_stock/main.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var fileName;
  String _subPage = '';
  String _mainPage = '';
  String _id = '';

  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint("onMessageOpenedApp: ${message.data}");
        _mainPage = message.data['data']['message']['mainPage'];
        _subPage = message.data['data']['message']['subPage'];
        _id = message.data['data']['message']['id'];
        manageNavigation( true, _mainPage, _subPage , _id);
      },
    );
    if (Platform.isIOS) {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }

    enableIOSNotifications();
    await registerNotificationListeners();
  }

  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_launcher1');
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    String? fcmToken = '';

    fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: ${fcmToken}");
    SharedPreferencesHelper preferences =
        SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    preferences.setFCMToken(fcmTokenId: fcmToken!);
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print("details:${details}");
        manageNavigation(true, _mainPage, _subPage , _id);
      },
    );
// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      var data = json.decode(message!.data['data'].toString());
      final RemoteNotification? notification = message.notification;
      final String? messageId = message.messageId;
      debugPrint('messageId______${messageId}');
      final AndroidNotification? android = message.notification?.android;
      debugPrint('data:${data.toString()}');
      if (data != null) {
        String? title =
            Bidi.stripHtmlIfNeeded(data['message']['title'].toString());
        String? body =
            Bidi.stripHtmlIfNeeded(data['message']['body'].toString());
        String mainPage = data['message']['mainPage'] ?? '';
        String subPage = data['message']['subPage'] ?? '';
        String id = data['message']['id'] ?? '';
        _subPage = subPage;
        _mainPage = mainPage;
        _id = id;
        String imageUrl = data['message']['imageUrl'] ?? '';

        if (imageUrl.isNotEmpty) {

          final http.Response response;
          response = await http
              .get(Uri.parse(AppUrls.baseFileUrl + imageUrl.toString()));
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
          await file.writeAsBytes(response.bodyBytes);
        }
        if (mainPage.isNotEmpty) {
          manageNavigation(false, mainPage, subPage ,id );
        }
        showNotification(
          notification.hashCode,
          title,
          body,
          channel.id,
          channel.name,
          channel.description ?? '',
          android?.smallIcon??'',
        );
      }
    });
  }

  showNotification(int id, String title, String body, String channelId,
      String channelName, String channelDesc, String? androidIcon) {
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
    Platform.isAndroid?  flutter_local_notifications.NotificationDetails(
        android: fileName != null
            ? AndroidNotificationDetails(
                channelId,
                channelName,
                channelDescription: channelDesc,
                icon: androidIcon??'',
                styleInformation: BigPictureStyleInformation(
                  FilePathAndroidBitmap(fileName),
                  hideExpandedLargeIcon: false,
                ),
              )
            : AndroidNotificationDetails(
                channelId,
                channelName,
                channelDescription: channelDesc,
                icon: androidIcon??'',
              ),
      ):flutter_local_notifications.NotificationDetails(
      iOS: fileName != null
          ? DarwinNotificationDetails(
          attachments: [DarwinNotificationAttachment(fileName)])
          : DarwinNotificationDetails(),
    ),
      // payload: message.data.toString(),
    );
  }

  showImage(String imageUrl) async {
    final http.Response response;
    var fName;
    response =
        await http.get(Uri.parse(AppUrls.baseFileUrl + imageUrl.toString()));
    Directory dir;
    if (Platform.isAndroid) {
      dir = await getTemporaryDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }
    // Create an image name
    fName = '${dir.path}/image.png';
    // Save to filesystem
    final file = File(fName);
    await file.writeAsBytes(response.bodyBytes);
    return fName;
  }

  void manageNavigation(bool isAppOpen, String mainPage, String subPage , String id) {

    debugPrint('main   = ${mainPage}');
    debugPrint('subPage   = ${subPage}');
    debugPrint('id = ${id}');
    if (isAppOpen) {
      if(subPage == ''){
        if (mainPage == 'companyScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.companyScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
        if (mainPage == 'saleScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.productSaleScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
        if (mainPage == 'supplierScreen') {
          Navigator.pushNamed(
              navigatorKey.currentState!.context, RouteDefine.supplierScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
        if (mainPage == 'storeScreen') {
          Navigator.pushNamed(
              navigatorKey.currentState!.context, RouteDefine.storeScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
      }
      else{
        if (subPage == 'companyProductsScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.companyProductsScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
        else if (subPage == 'supplierProductsScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.supplierProductsScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
      else if (subPage == 'catagoryScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.storeCategoryScreen.name,
              arguments: {AppStrings.companyIdString: id});
        }
      else if (subPage == 'planogramScreen') {
          Navigator.pushNamed(navigatorKey.currentState!.context,
              RouteDefine.storeCategoryScreen.name,
              arguments: {
                AppStrings.companyIdString: id,
                AppStrings.isSubCategory : 'false',
              });
        }
      }


    } else {
      AppRouting.generateRoute(RouteSettings(
          name: RouteDefine.splashScreen.name,
         ));
    }
  }

  @pragma('vm:entry-point')
  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint("Handling a background message: ${message.messageId}");
    debugPrint("Handling a background message: ${message.data.toString()}");
    _mainPage = message.data['data']['message']['mainPage'];
    _subPage = message.data['data']['message']['subPage'];
    _id = message.data['data']['message']['id'];
    manageNavigation( true, _mainPage, _subPage , _id);

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
      );
}