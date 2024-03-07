// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/Chat_Pages/helper/my_date_util.dart';
import 'package:senior_project/model/message_info.dart';

import '../theme.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
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
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
              color: isMe
                  ? const Color.fromARGB(168, 131, 205, 234)
                  : CustomColors.lightGreyLowTrans),
          child: Text(
            message.message,
            style: TextStyles.heading2,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 2),
        // Text(message.timestamp),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMe)
              Container()
            else if (message.readF.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20)
            else
              const Icon(Icons.done, color: CustomColors.lightGrey, size: 20),
            Container(
              alignment: alignment,
              // constraints: const BoxConstraints(maxWidth: 60),
              // color: Color.fromARGB(255, 162, 73, 25),
              padding: const EdgeInsets.all(1.0),
              child: Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: message.time),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
