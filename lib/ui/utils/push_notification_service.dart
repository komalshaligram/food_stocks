import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;
import 'package:food_stock/data/storage/shared_preferences_helper.dart';

import 'package:html/parser.dart';
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
      debugPrint("message: $message");

      final RemoteNotification? notification = message!.notification;
      final AndroidNotification? android = message.notification?.android;
      final iosNotification = message.notification?.apple;

// If `onMessage` is triggered with a notification, construct our own
// local notification to show to users using the created channel.
      if(notification != null ){
        final http.Response response;
        var fileName;
        if(Platform.isAndroid && android!.imageUrl!=null){
          response = await http.get(Uri.parse(android.imageUrl.toString()));
        }else{
          response = await http.get(Uri.parse(iosNotification!.imageUrl.toString()));
        }
        final dir = await getTemporaryDirectory();
        // Create an image name
        fileName = '${dir.path}/image.png';
        // Save to filesystem
        final file = File(fileName);
        await file.writeAsBytes(response.bodyBytes);

        debugPrint("img res: ${response.toString()}");
        BigPictureStyleInformation  bigPictureStyleInformation =
        BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes),));
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          parse(notification.title ?? '').body?.text ?? '',
          parse(notification.body ?? '').body?.text ?? '',
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