// ignore_for_file: must_be_immutable, unused_local_variable
import 'package:flutter/material.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/interface/Chat_Pages/helper/my_date_util.dart';
import 'package:senior_project/model/message_info_model.dart';
import '../common/theme.dart';

class ChatBubble extends StatelessWidget {
  final MessageInfoModel message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isMe = userInfo.userID == message.senderID ? true : false;
    var alignment = isMe ? Alignment.centerLeft : Alignment.centerRight;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
              color: isMe
                  ? CustomColors.lightBlueLowTrans
                  : CustomColors.lightGreyLowTrans),
          child: Text(
            message.message,
            style: TextStyles.heading2D,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMe)
              Container()
            else if (message.readF.isNotEmpty)
              const Icon(Icons.done_all_rounded,
                  color: CustomColors.realBlue, size: 20)
            else
              const Icon(Icons.done, color: CustomColors.lightGrey, size: 20),
            Container(
              alignment: alignment,
              padding: const EdgeInsets.all(1.0),
              child: Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: message.time),
                style: TextStyles.text1D,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
