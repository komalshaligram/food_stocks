import 'dart:convert';
import 'dart:io';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;
import 'package:food_stock/data/storage/shared_preferences_helper.dart';

import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';


class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
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
// This function is called when ios app is opened, for android case `onDidReceiveNotificationResponse` function is called
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint("onMessageOpenedApp: $message");
      //  notificationRedirect(message.data[keyTypeValue], message.data[keyType]);
      },
    );
    if(Platform.isIOS){
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    String? fcmToken='';


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
        print("details:$details");
      },
    );
// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async{
      var data = json.decode(message!.data['data'].toString());
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      debugPrint('noti:${notification!.toMap().toString()}');
      debugPrint('data:${data.toString()}');
      if(data != null ){
        final http.Response response;
        var fileName;
        if(data['message']['imageUrl']!=null){
          response = await http.get(Uri.parse(AppUrls.baseFileUrl+data['message']['imageUrl'].toString()));
          final dir = await getTemporaryDirectory();
          // Create an image name
          fileName = '${dir.path}/image.png';
          // Save to filesystem
          final file = File(fileName);
          await file.writeAsBytes(response.bodyBytes);
        }

        debugPrint('noti:${data['message']['body'].toString()}');
        String body = Bidi.stripHtmlIfNeeded(data['message']['body'].toString());
        debugPrint('noti:${data['message']['body'].toString()}');
        debugPrint("body: ${body}");
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          data['message']['title'].toString(),
          parse(data['message']['body'].toString() ?? '').text ?? '',
          flutter_local_notifications.NotificationDetails(
              iOS:DarwinNotificationDetails(attachments: [DarwinNotificationAttachment(fileName)]),
            android:AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android!.smallIcon,
              styleInformation: BigPictureStyleInformation(
                FilePathAndroidBitmap(fileName),
            hideExpandedLargeIcon: false,
          ),
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });
  }

  @pragma('vm:entry-point')
  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint("Handling a background message: ${message.messageId}");
    debugPrint("Handling a background message: ${message.data.toString()}");
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