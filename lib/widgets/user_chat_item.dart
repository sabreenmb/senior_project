import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/Chat_Pages/chat_screen.dart';
import 'package:senior_project/interface/Chat_Pages/helper/my_date_util.dart';
import 'package:senior_project/interface/Chat_Pages/other_user_profile_screen.dart';
import 'package:senior_project/model/chat_info.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class UserChatItem extends StatelessWidget {
  const UserChatItem({
    super.key,
    required this.context,
    required this.recevierUserID,
    this.chatInfo,
  });
  final BuildContext context;
  final String recevierUserID;
  final ChatInfo? chatInfo;

  void _goToUserProfile(enteredUserInfo otherUserInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfileScreen(
          otherUserInfo: otherUserInfo,
        ),
      ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getUser() {
    return FirebaseFirestore.instance
        .collection('userProfile')
        .where('userID', isEqualTo: recevierUserID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    String subti;
    if (chatInfo != null) {
      subti = (chatInfo?.lastMsgSender == userInfo.userID
          ? "أنت: ${chatInfo?.lastMsg}"
          : chatInfo?.lastMsg)!;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: CustomColors.white,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: FutureBuilder(
        future: _getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs[0];

            enteredUserInfo otherUserInfo = enteredUserInfo(
                userID: data.get('userID'),
                rule: data.get('rule'),
                name: data.get('name'),
                collage: data.get('collage'),
                major: data.get('major'),
                intrests: data.get('intrests'),
                hobbies: data.get('hobbies'),
                skills: data.get('skills'),
                image_url: data.get("image_url"));

            return InkWell(
                child: ListTile(
              title: Text(
                otherUserInfo.name,
                style: TextStyles.heading2,
              ),
              subtitle: Text(
                chatInfo != null
                    ? (chatInfo?.lastMsgSender == userInfo.userID
                        ? "أنت: ${chatInfo?.lastMsg}"
                        : chatInfo?.lastMsg)!
                    : otherUserInfo.major,
                maxLines: 1,
                style: const TextStyle(
                    color: CustomColors.lightGrey, fontSize: 14),
              ),
              trailing: chatInfo == null
                  ? null //show nothing when no message is sent
                  : chatInfo!.lastMsgSender != userInfo.userID
                      ? chatInfo!.readF.isEmpty
                          ?
                          //show for unread message
                          Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          // message sent time
                          : Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context,
                                  time: chatInfo!.lastMsgTime),
                              style: TextStyle(color: Colors.black54),
                            )
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: chatInfo!.lastMsgTime),
                          style: TextStyle(color: Colors.black54),
                        ),
              leading: GestureDetector(
                onTap: () {
                  _goToUserProfile(otherUserInfo);
                },

                // backgroundColor: Color.fromARGB(207, 96, 125, 139),
                child: otherUserInfo.image_url == ''
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
                          imageUrl: otherUserInfo.image_url,
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: SvgPicture.asset(
                              'assets/icons/UserProfile.svg',
                              color: CustomColors.darkGrey,
                            ),
                          ),
                        ),
                      ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RealChatPage(
                      otherUserInfo: otherUserInfo,
                    ),
                  ),
                );
              },
            ));
          }
          return Container();
        },
      ),
    );
  }
}
