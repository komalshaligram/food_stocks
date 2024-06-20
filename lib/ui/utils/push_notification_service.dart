import 'dart:convert';
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
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
            var data = json.decode(message!.data['data'].toString());
            debugPrint('_____onMessage_______${data.toString()}');
            debugPrint('_____onMessage_______${message.notification!.apple!.imageUrl!.toString()}');
            debugPrint('_____onMessage Noti_______${message.notification.toString()}');
      },
    );

    enableIOSNotifications();
    await registerNotificationListeners();
  }

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
// onMessage is called when the app is in foreground and a notific
// ation is received
    // app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      var data = json.decode(message!.data['data'].toString());

      debugPrint('_____onMessage_______${data.toString()}');
      //debugPrint('_____onMessage_______${data['data']['image'].toString()}');
    //  debugPrint('_____onMessage Noti_______${message.notification.toString()}');
  //    if(Platform.isAndroid){
        showNotification(imageUrl: data['data']['image'], notiId: 0, title: message.notification!.title??'', body: message.notification!.body??'');
   //   }
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
/*

    if (imageUrl.isNotEmpty) {
      imageByte = (await NetworkAssetBundle(Uri.parse(imageUrl))
          .load(imageUrl))
          .buffer
          .asUint8List();
      debugPrint('imageUrl__${imageByte}');
    }
    var file;
    try {
      final tempDir = await getTemporaryDirectory();
       file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(imageByte!);
    } catch(e) {
      // catch errors here
    }*/
    Uint8List? imageByte;
    String? fileName;
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
          (await NetworkAssetBundle(Uri.parse(imageUrl))
              .load(imageUrl))
              .buffer
              .asUint8List();
      await file.writeAsBytes(imageByte.toList());
    }else{
      fileName = null;
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
         iOS: DarwinNotificationDetails(presentBanner: true,attachments: [DarwinNotificationAttachment(fileName!)]
        ))
      );
  }
  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
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