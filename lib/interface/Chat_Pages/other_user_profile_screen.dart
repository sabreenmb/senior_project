// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/theme.dart';
import '../../constant.dart';
import '../../theme.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final enteredUserInfo otherUserInfo;
  const OtherUserProfileScreen({super.key, required this.otherUserInfo});
  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text(widget.otherUserInfo.name, style: TextStyles.heading1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.darkGrey),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        centerTitle: true,
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
                        color: CustomColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    ListView(
                      children: [
                        // const SizedBox(height: 8.0),
                        //profile pic **icon now change it later**
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                //const SizedBox(height: 12.0),
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 20),
                                    alignment: Alignment.topCenter,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      //color: Color.fromARGB(255, 139, 139, 139),
                                      shape: BoxShape.circle,
                                      // ignore: unnecessary_new
                                      border: new Border.all(
                                        color: CustomColors.darkGrey,
                                        width: 3,
                                      ),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        'assets/icons/UserProfile.svg',
                                        height: 100,
                                        width: 100,
                                        color: CustomColors.darkGrey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.otherUserInfo.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: CustomColors.lightBlue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.otherUserInfo.collage,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: CustomColors.darkGrey),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.otherUserInfo.major,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.darkGrey),
                                  ),
                                  const SizedBox(height: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
