// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/user_information_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // for getting firebase messaging token
  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) async {
      if (t != null) {
        userInfo.pushToken = t;
        if (kDebugMode) {
          print('Push Token: $t');
        }
      }
    });
  }

  Future<void> updatePushToken() async {
    FirebaseFirestore.instance
        .collection('userProfile')
        .doc(userInfo.userID)
        .update({
      'pushToken': userInfo.pushToken,
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotifications(context, message);
      showNotification(message);
    });
  }

  Future<void> initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInit =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initSet = InitializationSettings(
      android: androidInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSet,
        onDidReceiveNotificationResponse: (payload) {});
  }

  Future<void> showNotification(RemoteMessage message) async {
    if (isForeground) {
      // App is in the foreground, do not show the notification
      return;
    }

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.high,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high, // Set the priority to high
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  // for sending push notification
  Future<void> sendPushNotification(
      UserInformationModel chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": userInfo.name, //our name should be send
          "body": msg,
          "android_channel_id": "chat_rooms"
        },
        "android": {
          "notification": {
            "notification_count": 23,
          },
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAMTCpa-M:APA91bGfd5VRb5nD4Si2TC247sE7K0tC4vhFrcSQ4MLmDTtwCMCay8PVAtCjRKQ-rhyj9EE7D8RT4raixWsWsWZDCHKihV3hb_7R0Ko0StNweb6dN05eKv1zXgOW62VbRJFJu3BGzsXM'
          },
          body: jsonEncode(body));
    } catch (e) {
      if (kDebugMode) {
        print('\nsendPushNotificationE');
      }
    }
  }

  Future forgroundMessage() async {
    await fMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
