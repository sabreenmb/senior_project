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
    required this.otherUserInfo,
    this.chatInfo,
  });
  final BuildContext context;
  final enteredUserInfo otherUserInfo;
  final ChatInfo? chatInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: CustomColors.white,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
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
          style: const TextStyle(color: CustomColors.lightGrey, fontSize: 14),
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
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                      )
                    // message sent time
                    : Text(
                        MyDateUtil.getLastMessageTime(
                            context: context, time: chatInfo!.lastMsgTime),
                        style: const TextStyle(color: Colors.black54),
                      )
                : Text(
                    MyDateUtil.getLastMessageTime(
                        context: context, time: chatInfo!.lastMsgTime),
                    style: const TextStyle(color: Colors.black54),
                  ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUserProfileScreen(
                  otherUserInfo: otherUserInfo,
                ),
              ),
            );
          },
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
      )),
    );
  }
}
