import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/widgets/commonWidgets.dart';
import '../constant.dart';
import '../model/psych_guidance_report.dart';
import '../theme.dart';
import '../widgets/psych_guidance_card.dart';
import '../widgets/side_menu.dart';
import '../firebaseConnection.dart';

class PsychGuidance extends StatefulWidget {
  const PsychGuidance({super.key});

  @override
  State<PsychGuidance> createState() => _PsychGuidanceState();
}

class _PsychGuidanceState extends State<PsychGuidance>
    with SingleTickerProviderStateMixin {
  List<PsychGuidanceReport> _PsychGuidanceReport = [];
  int matchingIndex = 0;

  @override
  void initState() {
    super.initState();
    _LoadPsychGuidance();
  }

  void _LoadPsychGuidance() async {
    final List<PsychGuidanceReport> loadedPsychGuidance = [];

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Connection.url('Psych-Guidance'));
      final Map<String, dynamic> foundData = json.decode(response.body);
      for (final item in foundData.entries) {
        print('sabreen test');
        print(item.value['pg_name']);
        loadedPsychGuidance.add(PsychGuidanceReport(
          id: item.key,
          //model name : firebase name
          ProName: item.value['pg_name'],
          ProLocation: item.value['pg_location'],
          collage: item.value['pg_collage'],
          ProOfficeNumber: item.value['pg_number'],
          ProEmail: item.value['pg_email'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      setState(() {
        isLoading = false;
        _PsychGuidanceReport = loadedPsychGuidance;
        print(_PsychGuidanceReport.toList());
      });
    }
    matchingIndex = loadedPsychGuidance
        .indexWhere((item) => item.collage.toString() == userInfo.collage);
  }

  @override
  Widget build(BuildContext context) {
    print('build enter');
    print(_PsychGuidanceReport);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("الارشاد النفسي", style: TextStyles.heading1),
          centerTitle: false,
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
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
            child: Column(
              children: [
                const SizedBox(height: 15),
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.BackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 5,
                          padding: const EdgeInsets.only(left: 15, right: 15),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: const Padding(
                                padding:
                                    EdgeInsets.only(top: 15.0, right: 20.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "تذكر أنه لا بأس في طلب المساعدة. تواصل مع مستشاريك في الحرم الجامعي. إنهم موجودون لدعمك ومساعدتك على النجاح.",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff535D74),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 5,
                          padding: const EdgeInsets.only(left: 15, right: 15),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              top: 120.0, left: 8.0, right: 8.0, bottom: 385),
                          child: PGCard(_PsychGuidanceReport[matchingIndex]),
                        )),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
