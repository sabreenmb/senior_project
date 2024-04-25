// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/common_functions.dart';
import 'package:senior_project/interface/services_screen.dart';

import '../common/constant.dart';
import '../common/theme.dart';
import '../widgets/side_menu.dart';
import 'psych_guidance_details.dart';

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
  }

  @override
  Widget build(BuildContext context) {
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
                          builder: (context) => const ServicesScreen()));
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
          color: CustomColors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, true),
          inAsyncCall: isLoading,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        reverse: true,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.4,
                          decoration: const BoxDecoration(
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
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    reverse: false,
                    child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('أنت تستحق ان تكون سعيداً ',
                                style: TextStyles.subtitlePink),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ' تذكر...\n لا تخف من طلب المساعدة. مع الدعم المناسب , يمكنك أن تتحسن .',
                              style: TextStyles.text2D,
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 80),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PsychGuidanceDetails()));
                                },
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(175, 40),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: CustomColors.lightBlue),
                                child: Text("اطلب المساعدة",
                                    style: TextStyles.btnText),
                              ),
                            )
                          ],
                        )),
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
