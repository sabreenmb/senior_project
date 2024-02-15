// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../model/entered_user_info.dart';
import '../theme.dart';

// ignore: must_be_immutable
class mytextBox extends StatelessWidget {
  enteredUserInfo userInfo;
  mytextBox(this.userInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return (Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                //start the colom
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userInfo.collage!,
                    textAlign: TextAlign.right,
                    style: TextStyles.heading3B,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userInfo.major!,
                    textAlign: TextAlign.right,
                    style: TextStyles.heading3B,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userInfo.intrests!,
                    textAlign: TextAlign.right,
                    style: TextStyles.heading3B,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userInfo.hobbies!,
                    textAlign: TextAlign.right,
                    style: TextStyles.heading3B,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userInfo.skills!,
                    textAlign: TextAlign.right,
                    style: TextStyles.heading3B,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]))));
  }
}
