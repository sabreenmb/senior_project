import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/common/common_functions.dart';
import '../common/constant.dart';
import '../model/psych_guidance_model.dart';
import '../common/theme.dart';
import '../widgets/side_menu.dart';
import '../common/firebase_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'PsychGuidanceDetails.dart';

class PsychGuidance extends StatefulWidget {
  const PsychGuidance({super.key});

  @override
  State<PsychGuidance> createState() => _PsychGuidanceState();
}

class _PsychGuidanceState extends State<PsychGuidance>
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
        backgroundColor: CustomColors.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("دليلك للارشاد النفسي", style: TextStyles.pageTitle2),
          centerTitle: true,
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
        endDrawer: SideDrawer(
          onProfileTap: () => goToProfilePage(context),
        ),
        bottomNavigationBar: buildBottomBar(context, 1, true),
        body: ModalProgressHUD(
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, true),
          inAsyncCall: isLoading,
          child: SafeArea(
            bottom: false,
            child:
            Column(
              children: [
                // const SizedBox(height: 15),
                // Expanded(
                //   child: Stack(
                //     children: [
                //       Container(
                //         width:  MediaQuery.of(context).size.width,
                //         height: 400,
                //         decoration: BoxDecoration(
                //           color: CustomColors.white,
                //           borderRadius: BorderRadius.only(
                //             bottomLeft: Radius.circular(40),
                //             bottomRight: Radius.circular(40),
                //           ),
                //           image: DecorationImage(
                //             image: AssetImage('assets/images/brain.png'),
                //             fit: BoxFit.contain,
                //           ),
                //         ),
                //         child: Text("gggggggggggggggg"),
                //       ),
                //     ],
                //   ),
                // )
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height:  MediaQuery.of(context).size.height/2,
                        decoration: BoxDecoration(
                          color: CustomColors.pink,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/brain.png',
                              // 'assets/images/brain2.jpg',
                              // 'assets/images/mind.jpg',
                              fit: BoxFit.contain,
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

      Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),

                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text('انت تستحق ان تكون سعيداً ', style: TextStyles.subtitlePink),
                        SizedBox(
                          height: 10,
                        ),
                        Text(' تذكر...\n لا تخف من طلب المساعدة. مع الدعم المناسب , يمكنك ان تتحسن .',style: TextStyles.text2D,       textAlign: TextAlign.center,
                        ),
                        Container(margin: EdgeInsets.all(10),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 80),
                        child: ElevatedButton(
                          onPressed: () async { await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PsychGuidanceDetails()));
                              },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(175, 40),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: CustomColors.lightBlue),
                          child: Text("اطلب المساعدة", style: TextStyles.btnText),
                        ),
                                                )

                      ],
                    )
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
