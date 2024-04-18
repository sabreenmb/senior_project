import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/widgets/commonWidgets.dart';
import '../constant.dart';
import '../model/psych_guidance_report.dart';
import '../theme.dart';
import '../widgets/psych_guidance_card.dart';
import '../widgets/side_menu.dart';
import '../firebaseConnection.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Chat_Pages/chat_screen.dart';

class PsychGuidanceDetails extends StatefulWidget {
  const PsychGuidanceDetails({super.key});

  @override
  State<PsychGuidanceDetails> createState() => _PsychGuidanceState();
}

class _PsychGuidanceState extends State<PsychGuidanceDetails>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    //  _LoadPsychGuidance();
  }

  @override
  Widget build(BuildContext context) {
    print('build enter');
    // _LoadPsychGuidance();
    // print(_PsychGuidanceReport);
    // matchingIndex = _PsychGuidanceReport.indexWhere(
    //     (item) => item.collage.toString() == userInfo.collage);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.noColor,
          elevation: 0,
          // title: Text("دليلك  النفسي", style: TextStyles.heading11),
          // centerTitle: true,
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServisesScreen()));
                },
              );
            },
          ),
        ),
        // endDrawer: SideDrawer(
        //   onProfileTap: () => goToProfilePage(context),
        // ),
        // bottomNavigationBar: buildBottomBar(context, 1, true),
        body: ModalProgressHUD(
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, true),
          inAsyncCall: isLoading,
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 250),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'مرشدك النفسي متواجد لمساعدتك ',
                        style: TextStyles.headingPink,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        // 'للتواصل مع المرشد/ة '+ pg.ProName!+' عن طريق : ',
                        'للتواصل مع المرشد/ة ' +
                            'صابرين محمد بن سلمان ' +
                            ' عن طريق : ',

                        style: TextStyles.text5,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: CustomColors.lightGrey,
                            size: 18.0,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            pg.ProLocation! + " ,مكتب  " + pg.ProOfficeNumber!,
                            style: TextStyles.heading1D,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Icon(
                      //       Icons.work_outline,
                      //       color: CustomColors.lightGrey,
                      //       size: 18.0,
                      //     ),
                      //     const SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       pg.ProOfficeNumber!,
                      //
                      //       style: TextStyles.heading1D,
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            color: CustomColors.lightGrey,
                            size: 18.0,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onLongPress: () {
                              Clipboard.setData(
                                      ClipboardData(text: pg.ProEmail!))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text("تم نسخ البريد الالكتروني"),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: CustomColors.darkGrey,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                );
                              });
                            },
                            child: Text(
                              pg.ProEmail!,
                              style: TextStyles.heading1D,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      Container(
                        margin: EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RealChatPage(
                                  otherUserInfo: allUsers[allUsers.indexWhere(
                                      (element) => element.userID == pg.ProId)],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(175, 40),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: CustomColors.lightBlue,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(' لبدء المحادثة',
                                  textAlign: TextAlign.center,
                                  style: TextStyles.text3),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.chat,
                                color: CustomColors.white,
                                size: 18.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/mind-removebg.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
