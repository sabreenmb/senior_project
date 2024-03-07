// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/Chat_Pages/all_users_screen.dart';
import 'package:senior_project/model/chat_info.dart';
import 'package:senior_project/widgets/user_chat_item.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/interface/SaveListScreen.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/theme.dart';
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
    _pages = [
      {
        'page': const HomeScreen(),
      },
      {
        'page': const CurrentChats(),
      },
      {
        'page': const ServisesScreen(),
      },
      {
        'page': const SaveListScreen(),
      },
    ];
  }

  void _goToAllUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AllUsersScreen(),
      ),
    );
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
        _selectedPageIndex = index;
      }
      //todo uncomment on next sprints
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        _selectedPageIndex = index;
      } else if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
        _selectedPageIndex = index;
      } else if (index == 2) {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (_) => const ChatScreen()));
        // _selectedPageIndex = index;
      } else if (index == 3) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SaveListScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('heeeeeeeeeereeeeeeeeeee');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("الرسائل الخاصة", style: TextStyles.heading1),
        centerTitle: true,
        // actions: <Widget>[
        leading: IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded,
              color: CustomColors.darkGrey),
          iconSize: 35,
          hoverColor: CustomColors.white,
          padding: const EdgeInsets.only(right: 4, top: 4),
          onPressed: () {
            _goToAllUsers();
          },
        ),
        // ],
        iconTheme: const IconThemeData(color: CustomColors.darkGrey),
      ),
      endDrawer: SideDrawer(
        onProfileTap: goToProfilePage,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.1,
        clipBehavior: Clip.none,
        child: SizedBox(
          height: kBottomNavigationBarHeight * 1.2,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              unselectedItemColor: CustomColors.darkGrey,
              selectedItemColor: CustomColors.lightBlue,
              currentIndex: 2,
              items: const [
                BottomNavigationBarItem(
                  label: 'الرئيسية',
                  icon: Icon(Icons.home_outlined),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: 'الخدمات'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.messenger_outline,
                    ),
                    label: 'الدردشة'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_border), label: 'المحفوظات'),
              ],
            ),
          ),
        ),
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
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("chat_rooms").snapshots(),
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
        recevierUserID: recevierUserID,
        chatInfo: data,
      );
    }
    return Container();
  }
}
