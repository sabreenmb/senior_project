import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/Chat_Pages/chat_service.dart';
import 'package:senior_project/interface/Chat_Pages/other_user_profile_screen.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/model/message_info.dart';
import 'package:senior_project/widgets/chat_bubble.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/networkWedget.dart';

class RealChatPage extends StatefulWidget {
  final enteredUserInfo otherUserInfo;
  const RealChatPage({super.key, required this.otherUserInfo});

  @override
  State<RealChatPage> createState() => _RealChatPageState();
}

class _RealChatPageState extends State<RealChatPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late StreamSubscription connSub;

  List<Message> _list = [];
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  // final ScrollController _scrollController = ScrollController();

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

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      var tempMsg = _messageController.text;
      _messageController.clear();

      await _chatService.sendMessage(
        widget.otherUserInfo,
        tempMsg,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    connSub.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    connSub = Connectivity().onConnectivityChanged.listen(checkConnectivity);
  }

  void _goToUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfileScreen(
          otherUserInfo: widget.otherUserInfo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _goToUserProfile();
                },
                child: widget.otherUserInfo.image_url == ''
                    ? const Icon(
                        Icons.account_circle_outlined,
                        color: Color.fromARGB(163, 51, 51, 51),
                        size: 40,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                            width: 38,
                            height: 38,
                            fit: BoxFit.cover,
                            imageUrl: widget.otherUserInfo.image_url,
                            errorWidget: (context, url, error) => Container(
                                  padding: const EdgeInsets.all(20),
                                  alignment: Alignment.topCenter,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: CustomColors.darkGrey,
                                      width: 3,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/UserProfile.svg',
                                    height: 100,
                                    width: 100,
                                    color: CustomColors.darkGrey,
                                  ),
                                )),
                      ),
              ),
              const SizedBox(width: 12),
              // Add spacing between the image and title
              Text(
                widget.otherUserInfo.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.darkGrey,
                ),
              ),
            ],
          ),
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
                const SizedBox(height: 5),
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.backgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                    ),
                    Container(
                      child: Column(
                        //messages
                        children: [
                          Expanded(
                            child: (isOffline)
                                ? Center(
                                    child: SizedBox(
                                      // padding: EdgeInsets.only(bottom: 20),
                                      // alignment: Alignment.topCenter,
                                      height: 200,
                                      child: Image.asset(
                                          'assets/images/NoInternet_newo.png'),
                                    ),
                                  )
                                : _buildMessageList(),
                          ),

                          //user input
                          _buildMessageInput(),
                        ],
                      ),
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

  //list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessage(
            widget.otherUserInfo.userID, userInfo.userID),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const SizedBox();

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              // final data = snapshot.data?.docs; //
              _list = snapshot.data!.docs
                  .map((document) => Message.fromJson(
                      document.data()! as Map<String, dynamic>))
                  .toList();
              //data?.map(() => Message.fromJson(e.data())).toList() ?? [];

              if (_list.isNotEmpty) {
                return ListView.builder(
                    reverse: true,
                    itemCount: _list.length,
                    // padding: EdgeInsets.only(top: mq.height * .01),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildMessageItem(_list[index]);
                    });
              } else {
                return const Center(
                  child: Text('Say Hii! 👋', style: TextStyle(fontSize: 20)),
                );
              }
          }
        }
        // if (snapshot.hasError) {
        //   return const Text("كل زق");
        // }

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return loadingFunction(context, true);
        // }

        // WidgetsBinding.instance!.addPostFrameCallback((_) {
        //   // Scroll to the last item in the list
        //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        // });
        // return ListView(
        //   controller: _scrollController,
        //   padding: const EdgeInsets.symmetric(horizontal: 2),
        //   children: snapshot.data!.docs
        //       .map((document) => _buildMessageItem(document))
        //       .toList(),
        // );

        );
  }

  //item
  Widget _buildMessageItem(Message message) {
    // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    bool isMe = userInfo.userID == message.senderID ? true : false;
    if (!isMe && message.readF.isEmpty) {
      _chatService.updateMessageReadStatus(message);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
      child: ChatBubble(
        message: message,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: CustomColors.noColor,
      padding: const EdgeInsets.only(bottom: 15, right: 10, left: 10, top: 8),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color.fromARGB(65, 171, 171, 171),
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onTap: () {},
                // keyboardType: TextInputType.text,
                controller: _messageController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "ادخل الرسالة...",
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (isOffline) {
                  showNetWidgetDialog(context);
                } else {
                  sendMessage();
                }
              },
              icon: const Icon(
                Icons.send,
                size: 35,
                color: Color.fromARGB(255, 59, 111, 132),
              ),
              padding: const EdgeInsets.only(bottom: 2),
            )
          ],
        ),
      ),
    );
  }
}
