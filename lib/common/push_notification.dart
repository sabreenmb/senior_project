import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotifications(context, message);
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
// final String chatPartnerId = message.data['userID'];
//     if (chatPartnerId != null) {
//       // Get the current chat partner ID from the app's state or wherever you store it
//       final String currentChatPartnerId =
//           context; // Replace with the appropriate implementation

//       // Compare the current chat partner ID with the one from the notification
//       if (currentChatPartnerId == chatPartnerId) {
//         // User is already in the same chat, no need to show the notification
//         return;
//       }
//     }

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notifications',
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  // for getting firebase messaging token
  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) async {
      if (t != null) {
        userInfo.pushToken = t;
        print('Push Token: $t');
      }
    });
    updatePushToken();
    // for handling foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  Future<void> updatePushToken() async {
    FirebaseFirestore.instance
        .collection('userProfile')
        .doc(userInfo.userID)
        .update({
      'pushToken': userInfo.pushToken,
    });
  }

  // for sending push notification
  Future<void> sendPushNotification(
      UserInformation chatUser, String msg) async {
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

        // "data": {"type": "msj", "id": "manarrrr"}
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAMTCpa-M:APA91bGfd5VRb5nD4Si2TC247sE7K0tC4vhFrcSQ4MLmDTtwCMCay8PVAtCjRKQ-rhyj9EE7D8RT4raixWsWsWZDCHKihV3hb_7R0Ko0StNweb6dN05eKv1zXgOW62VbRJFJu3BGzsXM'
          },
          body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('\nsendPushNotificationE: $e');
    }
  }

  Future forgroundMessage() async {
    await fMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    // //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msj') {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MessageScreen(
      //               id: message.data['id'],
      //             )));
    }
  }
}
