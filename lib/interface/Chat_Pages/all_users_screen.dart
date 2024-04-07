// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/widgets/user_chat_item.dart';
import 'package:senior_project/theme.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsersScreen>
    with SingleTickerProviderStateMixin {
  final int _selectedPageIndex = 2;

  final _userInputController = TextEditingController();
  List<enteredUserInfo> _list = [];
  late AnimationController _animationController;
  late Stream<QuerySnapshot> users;
  //manar from here
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text("جميع الطلاب", style: TextStyles.heading1),
          centerTitle: true,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: CustomColors.darkGrey),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
        ),
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
                          color: CustomColors.BackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                    Container(
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
    return ListView.builder(
        // reverse: true,
        itemCount: allUsers.length,
        // padding: EdgeInsets.only(top: mq.height * .01),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          print(allUsers.elementAt(3).userID);
          return UserChatItem(
            context: context,
            otherUserInfo: allUsers[index],
          );
        });
  }
}
