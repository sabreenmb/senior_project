// ignore_for_file: unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/interface/Chat_Pages/all_users_screen.dart';
import 'package:senior_project/model/chat_info_model.dart';
import 'package:senior_project/common/common_functions.dart';
import 'package:senior_project/widgets/user_chat_item.dart';
import 'package:senior_project/common/theme.dart';
import 'package:senior_project/widgets/side_menu.dart';

class CurrentChats extends StatefulWidget {
  const CurrentChats({super.key});

  @override
  State<CurrentChats> createState() => _CurrentChatsState();
}

class _CurrentChatsState extends State<CurrentChats>
    with SingleTickerProviderStateMixin {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 2;
  //search
  final _userInputController = TextEditingController();
  //filter
  bool isSearch = false;
  bool isNew = false;
  late AnimationController _animationController;
  late StreamSubscription connSub;
  void checkConnectivity(List<ConnectivityResult> result) {
    switch (result[0]) {
      case ConnectivityResult.mobile || ConnectivityResult.wifi:
        if (isOffline != false) {
          setState(() {
            isOffline = false;
          });
        }
        break;
      case ConnectivityResult.none:
        if (isOffline != true) {
          setState(() {
            isOffline = true;
          });
        }
        break;
      default:
        break;
    }
  }

  //manar from here
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    connSub.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connSub = Connectivity().onConnectivityChanged.listen(checkConnectivity);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _goToAllUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AllUsersScreen(),
      ),
    );
  }

  Stream<QuerySnapshot> getUsers() {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .orderBy('lastMsgTime', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    print('heeeeeeeeeereeeeeeeeeee');
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("الرسائل الخاصة", style: TextStyles.pageTitle),
          centerTitle: true,
          // actions: <Widget>[
          leading: IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: CustomColors.darkGrey),
            iconSize: 35,
            hoverColor: CustomColors.white,
            padding: const EdgeInsets.only(right: 4, top: 4),
            onPressed: () {
              if (isOffline) {
              } else {}
              _goToAllUsers();
            },
          ),
          // ],
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
        ),
        endDrawer: SideDrawer(
          onProfileTap: () => goToProfilePage(context),
        ),
        bottomNavigationBar: buildBottomBar(context, 2, false),
        body: ModalProgressHUD(
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, true),
          inAsyncCall: isLoading,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.backgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                    (isOffline)
                        ? Center(
                            child: SizedBox(
                            // padding: EdgeInsets.only(bottom: 20),
                            // alignment: Alignment.topCenter,
                            height: 200,
                            child: Image.asset(
                                'assets/images/NoInternet_newo.png'),
                          ))
                        : Container(
                            padding: const EdgeInsets.all(10),
                            child: _buildUsersList(),
                          ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat_rooms")
            .orderBy('lastMsgTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("كل زق");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingFunction(context, true);
          }

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> temp = document.data()! as Map<String, dynamic>;

    ChatInfo data = ChatInfo(
      user1: temp['user1'],
      user2: temp["user2"],
      lastMsg: temp['lastMsg'],
      lastMsgSender: temp['lastMsgSender'],
      readF: temp['readF'],
      lastMsgTime: temp['lastMsgTime'],
    );
    // bool isMe = data['user1'] == userInfo.userID ? true : false;
    bool isMe = data.user1 == userInfo.userID ? true : false;
    if (data.user1 == userInfo.userID || data.user2 == userInfo.userID) {
      String recevierUserID = isMe ? data.user2 : data.user1;

      return UserChatItem(
        context: context,
        otherUserInfo: allUsers[
            allUsers.indexWhere((element) => element.userID == recevierUserID)],
        chatInfo: data,
      );
    }
    return Container();
  }
}
