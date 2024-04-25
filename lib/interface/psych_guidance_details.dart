// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/common_functions.dart';
import 'package:senior_project/interface/services_screen.dart';

import '../common/constant.dart';
import '../common/theme.dart';
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.noColor,
          elevation: 0,
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
          color: CustomColors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, true),
          inAsyncCall: isLoading,
          child: SafeArea(
            bottom: false,
            child: (isOffline)
                ? Center(
                    child: SizedBox(
                      height: 200,
                      child: Image.asset('assets/images/NoInternet_newo.png'),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 45, top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'مرشدك النفسي متواجد لمساعدتك ',
                                style: TextStyles.subtitlePink,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'للتواصل مع المرشد/ة ${pg.proName!}  عن طريق : ',
                                style: TextStyles.text2D,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
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
                                    "${pg.proLocation!} , ${pg.proOfficeNumber!}",
                                    style: TextStyles.heading1D,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
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
                                    onTap: () {
                                      Clipboard.setData(
                                              ClipboardData(text: pg.proEmail!))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                "تم نسخ البريد الالكتروني"),
                                            duration:
                                                const Duration(seconds: 1),
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
                                      pg.proEmail!,
                                      style: TextStyles.heading1D,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Container(
                                margin: const EdgeInsets.all(10),
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
                                                  element.userID == pg.proId)],
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
                        Image.asset(
                          'assets/images/mind-removebg.png',
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
