import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/chat_info.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/model/message_info.dart';
import 'package:senior_project/common/push_notification.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send
  Future<void> sendMessage(
      UserInformation otherUserInfo, String message) async {
    //get current user info ----

    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();

      //create new message
      Message newMessage = Message(
        senderID: userInfo.userID,
        receiverID: otherUserInfo.userID,
        message: message,
        time: time,
        readF: '',
      );

      //construct chat room id -> sender+receiver
      List<String> ids = [userInfo.userID, otherUserInfo.userID];
      ids.sort();
      String chatRoomID = ids.join("_");

      if (!await isChatExist(chatRoomID)) {
        ChatInfo newChat = ChatInfo(
          user1: userInfo.userID,
          user2: otherUserInfo.userID,
          lastMsg: newMessage.message,
          lastMsgSender: newMessage.senderID,
          readF: newMessage.readF,
          lastMsgTime: newMessage.time,
        );

        await _firestore
            .collection("chat_rooms")
            .doc(chatRoomID)
            .set(newChat.toMap());
      }

      await _firestore.collection("chat_rooms").doc(chatRoomID).update({
        'lastMsg': newMessage.message,
        'lastMsgSender': newMessage.senderID,
        'readF': newMessage.readF,
        'lastMsgTime': newMessage.time,
      });
      //add the message to firestore
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .doc(time)
          .set(newMessage.toMap())
          .then((value) => notificationServices.sendPushNotification(
              otherUserInfo, message));
    } catch (error) {
      // Handle the error condition
      print("Error sending message: $error");
      // You can display an error message or perform any other necessary actions
    }
  }

  //get
  Stream<QuerySnapshot> getMessage(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<bool> isChatExist(String chatRoomID) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .get();

    if (!snapshot.exists) {
      return false;
    }

    return true;
  }

  Future<void> updateMessageReadStatus(Message message) async {
    List<String> ids = [message.senderID, message.receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection('messages')
        .doc(message.time)
        .update({'readF': time});

    _firestore.collection("chat_rooms").doc(chatRoomID).update({'readF': time});
  }

// Future<void> updateActiveStatus(bool isOnline) async {
//     _firestore.collection('userProfile').doc(userInfo.userID).update({
//       'push_token': userInfo.pushToken,
//     });
//   }
}
