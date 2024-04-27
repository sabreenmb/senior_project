import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/controller/chat_service.dart';
import 'package:senior_project/view/Chat_Pages/other_user_profile_screen.dart';
import 'package:senior_project/model/user_information_model.dart';
import 'package:senior_project/model/message_info_model.dart';
import 'package:senior_project/widgets/chat_bubble.dart';
import 'package:senior_project/common/theme.dart';
import '../../common/common_functions.dart';

class RealChatPage extends StatefulWidget {
  final UserInformationModel otherUserInfo;
  const RealChatPage({super.key, required this.otherUserInfo});

  @override
  State<RealChatPage> createState() => _RealChatPageState();
}

class _RealChatPageState extends State<RealChatPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late StreamSubscription connSub;

  List<MessageInfoModel> _list = [];
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

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
                child: widget.otherUserInfo.imageUrl == ''
                    ? Icon(
                        Icons.account_circle_outlined,
                        color: CustomColors.darkGrey.withOpacity(0.8),
                        size: 40,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          width: 38,
                          height: 38,
                          fit: BoxFit.cover,
                          imageUrl: widget.otherUserInfo.imageUrl,
                          errorWidget: (context, url, error) => Icon(
                            Icons.account_circle_outlined,
                            color: CustomColors.darkGrey.withOpacity(0.8),
                            size: 40,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.otherUserInfo.name,
                style: TextStyles.menuTitle,
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
          color: CustomColors.black,
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 5, left: 5),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35)),
                        ),
                        child: Column(
                          //messages
                          children: [
                            Expanded(
                              child: (isOffline)
                                  ? Center(
                                      child: SizedBox(
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
              _list = snapshot.data!.docs
                  .map((document) => MessageInfoModel.fromJson(
                      document.data()! as Map<String, dynamic>))
                  .toList();
              if (_list.isNotEmpty) {
                return ListView.builder(
                    reverse: true,
                    itemCount: _list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildMessageItem(_list[index]);
                    });
              } else {
                return Center(
                  child: Text(
                    'أهلا! 👋\n\nيمكنك بدأ المحادثة الان',
                    textAlign: TextAlign.center,
                    style: TextStyles.heading2D,
                  ),
                );
              }
          }
        });
  }

  //item
  Widget _buildMessageItem(MessageInfoModel message) {
    bool isMe = userInfo.userID == message.senderID ? true : false;
    if (!isMe && message.readF.isEmpty) {
      _chatService.updateMessageReadStatus(message);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8),
      child: ChatBubble(
        message: message,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        color: CustomColors.white.withOpacity(0.4),
        padding: const EdgeInsets.only(bottom: 10, right: 5, left: 5, top: 8),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: CustomColors.lightGreyLowTrans.withOpacity(0.25),
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.only(right: 15, left: 5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onTap: () {},
                  controller: _messageController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "ادخل الرسالة...",
                  ),
                ),
              ),
              Container(
                // alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 3),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: CustomColors.lightBlue.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    if (isOffline) {
                      showNetWidgetDialog(context);
                    } else {
                      sendMessage();
                    }
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    size: 35,
                    color: CustomColors.darkGrey.withOpacity(0.6),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
