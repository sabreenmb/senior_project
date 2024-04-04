import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constant.dart';
import '../model/psych_guidance_report.dart';
import '../theme.dart';
import '../widgets/psych_guidance_card.dart';
import '../widgets/side_menu.dart';
import 'ChatScreen.dart';
import 'HomeScreen.dart';
import 'ProfilePage.dart';
import 'SaveListScreen.dart';
import 'add_lost_item_screen.dart';
import 'services_screen.dart';

class PsychGuidance extends StatefulWidget {
  const PsychGuidance({super.key});

  @override
  State<PsychGuidance> createState() => _PsychGuidanceState();
}

class _PsychGuidanceState extends State<PsychGuidance>
    with SingleTickerProviderStateMixin {
  List<PsychGuidanceReport> _PsychGuidanceReport = [];

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 2;

  @override
  void initState() {
    super.initState();

    _pages = [
      {
        'page': const HomeScreen(),
      },
      {
        'page': const ChatScreen(),
      },
      {
        'page': const AddLostItemScreen(),
      },
      {
        'page': const ServisesScreen(),
      },
      {
        'page': const SaveListScreen(),
      },
    ];
    _LoadPsychGuidance();
  }

  void _LoadPsychGuidance() async {
    final List<PsychGuidanceReport> loadedPsychGuidance = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'Psych-Guidance.json');
      final response = await http.get(url);

      final Map<String, dynamic> foundData = json.decode(response.body);
      for (final item in foundData.entries) {
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
  }

  void _selectPage(int index) {
    setState(() {
      if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
        _selectedPageIndex = index;
      }
      // todo uncomment on next sprints
      //  if (index == 0) {
      //    Navigator.pushReplacement(
      //        context, MaterialPageRoute(builder: (_) => HomeScreen()));
      //  } else if (index == 1) {
      //    Navigator.pushReplacement(
      //        context, MaterialPageRoute(builder: (_) => ServisesScreen()));
      //  } else if (index == 2) {
      //    Navigator.pushReplacement(
      //        context, MaterialPageRoute(builder: (_) => ChatScreen()));
      //  } else if (index == 3) {
      //    Navigator.pushReplacement(
      //        context, MaterialPageRoute(builder: (_) => SaveListScreen()));
      //  }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build enter');
    print(_PsychGuidanceReport);

    return Scaffold(
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
        onProfileTap: goToProfilePage,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.1,
        clipBehavior: Clip.none,
        child: SizedBox(
          height: kBottomNavigationBarHeight * 1.2,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              unselectedItemColor: CustomColors.darkGrey,
              selectedItemColor: CustomColors.darkGrey,
              currentIndex: _selectedPageIndex,
              items: const [
                BottomNavigationBarItem(
                  label: 'الرئيسية',
                  icon: Icon(Icons.home_outlined),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: 'الخدمات'),
                // BottomNavigationBarItem(
                //   label: "",
                //   activeIcon: null,
                //   icon: Icon(null),
                // ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.messenger_outline,
                    ),
                    label: 'الدردشة'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_border), label: 'المحفوظات'),
              ],
            ),
          ),
        ),
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
                              padding: EdgeInsets.only(top: 15.0, right: 20.0),
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
                            top: 110.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              itemCount: _PsychGuidanceReport.length,
                              itemBuilder: (context, index) =>
                                  PGCard(_PsychGuidanceReport[index]),
                            )),
                      )),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
