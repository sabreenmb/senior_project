import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/common/common_functions.dart';
import '../common/constant.dart';
import '../model/psych_guidance_report.dart';
import '../common/theme.dart';
import '../widgets/psych_guidance_card.dart';
import '../widgets/side_menu.dart';
import '../common/firebase_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Chat_Pages/chat_screen.dart';

class PsychGuidanceDetails extends StatefulWidget {
  const PsychGuidanceDetails({super.key});

  @override
  State<PsychGuidanceDetails> createState() => _PsychGuidanceState();
}

class _PsychGuidanceState extends State<PsychGuidanceDetails>
    with SingleTickerProviderStateMixin {
  late StreamSubscription connSub;
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

  @override
  void initState() {
    super.initState();
    connSub = Connectivity().onConnectivityChanged.listen(checkConnectivity);

    Future.delayed(const Duration(seconds: 1), () {});
  }

  @override
  void dispose() {
    connSub.cancel();
    super.dispose();
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
        body: ModalProgressHUD(
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, true),
          inAsyncCall: isLoading,
          child: SafeArea(
            bottom: false,
            child: (isOffline && pg == null)
                ? Center(
                    child: SizedBox(
                      // padding: EdgeInsets.only(bottom: 20),
                      // alignment: Alignment.topCenter,
                      height: 200,
                      child: Image.asset('assets/images/NoInternet_newo.png'),
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(left: 12, right: 12, bottom: 250),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'مرشدك النفسي متواجد لمساعدتك ',
                              style: TextStyles.subtitlePink,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15),
                            Text(
                              // 'للتواصل مع المرشد/ة '+ pg.ProName!+' عن طريق : ',
                              'للتواصل مع المرشد/ة ' +
                                  'صابرين محمد بن سلمان ' +
                                  ' عن طريق : ',
                              style: TextStyles.text2D,
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
                                  pg.ProLocation! +
                                      " ,مكتب  " +
                                      pg.ProOfficeNumber!,
                                  style: TextStyles.heading1D,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              "تم نسخ البريد الالكتروني"),
                                          duration: const Duration(seconds: 1),
                                          backgroundColor:
                                              CustomColors.darkGrey,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RealChatPage(
                                        otherUserInfo: allUsers[
                                            allUsers.indexWhere((element) =>
                                                element.userID == pg.ProId)],
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
                                        style: TextStyles.btnText),
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
