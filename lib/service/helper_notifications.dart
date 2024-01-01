import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class HelperNotifications {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: androidInitialize,iOS: DarwinInitializationSettings());
   

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // <--- This is the new line
      print("--------Message------------");
      print(
          "onMessage : ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
    });
  }
}



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'custom_notification_channel_id',
  'Notification',
  description: 'notifications from Your App Name.',
  importance: Importance.high,
);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void setupFcm() {
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  //when the app is in foreground state and you click on notification.
  flutterLocalNotificationsPlugin.initialize(initializationSettings,);

  //When the app is terminated, i.e., app is neither in foreground or background.
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    //Its compulsory to check if RemoteMessage instance is null or not.
    if (message != null) {
      goToNextScreen(message.data);
    }
  });

  //When the app is in the background, but not terminated.
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
      goToNextScreen(event.data);
    },
    cancelOnError: false,
    onDone: () {},
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (android.imageUrl != null && android.imageUrl!.trim().isNotEmpty) {
          final String largeIcon = await _base64encodedImage(
            android.imageUrl!,
          );

          final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(largeIcon),
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
            contentTitle: notification.title,
            htmlFormatContentTitle: true,
            summaryText: notification.body,
            htmlFormatSummaryText: true,
            hideExpandedLargeIcon: true,
          );

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: "app_icon",
                // icon: 'custom_notification_icon',
                // color: primaryColor,
                importance: Importance.max,
                priority: Priority.high,
                largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
              styleInformation: bigPictureStyleInformation,
              ),
            ),
            payload: json.encode(message.data),
          );
        }
        else {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // icon: 'custom_notification_icon',
                // color: primaryColor,
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
            payload: json.encode(message.data),
          );
        }
      }
    });

}

Future<void> deleteFcmToken() async {
  return await FirebaseMessaging.instance.deleteToken();
}

Future<String> getFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return Future.value(token);
}

void goToNextScreen(Map<String, dynamic> data) {
  if (data['click_action'] != null) {
    switch (data['click_action']) {
      // case "first_screen":
      //   navigatorKey.currentState.pushNamed(FirstScreen.routeName,);
      //   break;
      // case "second_screen":
      //   navigatorKey.currentState.pushNamed(SecondScreen.routeName,);
      //   break;
      // case "sample_screen":
      //   navigatorKey.currentState.pushNamed(SampleScreen.routeName,);
    }
    return;
  }
  //If the payload is empty or no click_action key found then go to Notification Screen if your app has one.
  // navigatorKey.currentState.pushNamed(NotificationPage.routeName,);
}

Future<String> _base64encodedImage(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  final String base64Data = base64Encode(response.bodyBytes);
  return base64Data;
}
