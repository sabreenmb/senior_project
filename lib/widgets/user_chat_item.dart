import 'package:flutter/material.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/view/Chat_Pages/chat_screen.dart';
import 'package:senior_project/view/Chat_Pages/helper/my_date_util.dart';
import 'package:senior_project/view/Chat_Pages/other_user_profile_screen.dart';
import 'package:senior_project/model/chat_info_model.dart';
import 'package:senior_project/model/user_information_model.dart';
import 'package:senior_project/common/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserChatItem extends StatelessWidget {
  const UserChatItem({
    super.key,
    required this.context,
    required this.otherUserInfo,
    this.chatInfo,
  });
  final BuildContext context;
  final UserInformationModel otherUserInfo;
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
          child: ListTile(
            title: Text(
              otherUserInfo.name,
              style: TextStyles.heading2D,
            ),
            subtitle: Text(
              chatInfo != null
                  ? (chatInfo?.lastMsgSender == userInfo.userID
                      ? "أنت: ${chatInfo?.lastMsg}"
                      : chatInfo?.lastMsg)!
                  : otherUserInfo.major,
              maxLines: 1,
              style: TextStyles.heading3G,
            ),
            trailing: chatInfo == null
                ? null //show nothing when no message is sent
                : (chatInfo!.lastMsgSender != userInfo.userID &&
                        chatInfo!.readF.isEmpty)
                    ? //show for unread message
                    Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: CustomColors.realBlue,
                            borderRadius: BorderRadius.circular(10)),
                      )
                    // message sent time
                    : Text(
                        MyDateUtil.getLastMessageTime(
                            context: context, time: chatInfo!.lastMsgTime),
                        style: const TextStyle(color: CustomColors.black),
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
              child: otherUserInfo.imageUrl == ''
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
                        imageUrl: otherUserInfo.imageUrl,
                        errorWidget: (context, url, error) => Icon(
                          Icons.account_circle_outlined,
                          color: CustomColors.darkGrey.withOpacity(0.8),
                          size: 40,
                        ),
                      ),
                    ),
            ),
          )),
    );
  }
}
