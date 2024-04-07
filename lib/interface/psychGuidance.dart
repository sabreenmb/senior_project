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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
          title: Text("دليلك للارشاد النفسي", style: TextStyles.heading1),
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
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 5,
                          padding: const EdgeInsets.only(left: 15, right: 15),
                        ),
                        Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Color.fromRGBO(89, 177, 212,
                                    1), // Set the border color here
                                width: 2.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  22.0), // Set the border radius
                            ),
                            margin: const EdgeInsets.only(
                                top: 90.0,
                                left: 20.0,
                                right: 20.0,
                                bottom: 10.0),
                            child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 20.0,
                                    left: 20.0,
                                    right: 20.0,
                                    bottom: 20.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //start the colom
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.favorite_border,
                                              color: CustomColors.lightGrey,
                                              size: 25.0,
                                            ),
                                          ]),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "تذكر أنه لا بأس في طلب المساعدة. تواصل مع مستشاريك في الحرم الجامعي. إنهم موجودون لدعمك ومساعدتك على النجاح.",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff535D74),
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ]))),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "كيف هو مزاجك اليوم؟",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff535D74),
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return const Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: Colors.red,
                                );
                              case 1:
                                return const Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.redAccent,
                                );
                              case 2:
                                return const Icon(
                                  Icons.sentiment_neutral,
                                  color: Colors.amber,
                                );
                              case 3:
                                return const Icon(
                                  Icons.sentiment_satisfied,
                                  color: Colors.lightGreen,
                                );
                              case 4:
                                return const Icon(
                                  Icons.sentiment_very_satisfied,
                                  color: Colors.green,
                                );
                              default:
                                return const Icon(
                                  Icons.sentiment_neutral,
                                  color: Colors.amber,
                                );
                            }
                          },
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 100),
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
