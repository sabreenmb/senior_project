// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/model/conference_item_report.dart';
import 'package:senior_project/model/courses_item_report.dart';
import 'package:senior_project/model/other_event_item_report.dart';
import 'package:senior_project/model/workshop_item_report.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/conf_card.dart';
import 'package:senior_project/widgets/other_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:senior_project/widgets/workshop_card.dart';
import '../widgets/course_card.dart';
import 'ChatScreen.dart';
import 'SaveListScreen.dart';
import 'services_screen.dart';
import 'package:http/http.dart' as http;

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});
  @override
  State<EventScreen> createState() => _EventState();
}

class _EventState extends State<EventScreen> {
  final _userInputController = TextEditingController();
  List<CoursesItemReport> searchCourseList = [];
  List<WorkshopsItemReport> searchWorkshopList = [];
  List<ConferencesItemReport> searchConfList = [];
  List<OtherEventsItemReport> searchOtherList = [];

  List<CoursesItemReport> _courseItem = [];
  List<WorkshopsItemReport> _workshopItem = [];
  List<ConferencesItemReport> _confItem = [];
  List<OtherEventsItemReport> _otherItem = [];

  late List<Map<String, Object>> _pages;

  int _selectedPageIndex = 1;
  bool isSelected = true;
  bool isSearch = false;

  bool isSelectedCourse = true;
  bool isSelectedWorkshop = false;
  bool isSelectedConfre = false;
  bool isSelectedOther = false;

  void _selectPage(int index) {
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ServisesScreen()));
      } else if (index == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      } else if (index == 3) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SaveListScreen()));
      }
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 200),
    // );
    _pages = [
      {
        'page': const HomeScreen(),
      },
      {
        'page': const ChatScreen(),
      },
      {
        'page': const ServisesScreen(),
      },
      {
        'page': const SaveListScreen(),
      },
    ];
    _LoadCoursesItems();
    //_LoadWorkshopsItems();
    //_LoadConferencesItems();
    _LoadOtherEventsItems();
  }

  void _LoadCoursesItems() async {
    final List<CoursesItemReport> loadedCoursesItems = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'eventsCoursesDB.json');
      final response = await http.get(url);

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedCoursesItems.add(CoursesItemReport(
          id: item.key,
          Name: item.value['course_name'],
          presentBy: item.value['course_presenter'],
          courseDate: item.value['course_date'],
          courseTime: item.value['course_time'],
          coursePlace: item.value['course_location'],
          courseLink: item.value['course_link'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      setState(() {
        isLoading = false;
        _courseItem = loadedCoursesItems;
      });
    }
  }

  void _LoadWorkshopsItems() async {
    final List<WorkshopsItemReport> loadedWorkshopsItems = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url =
          Uri.https('senior-project-72daf-default-rtdb.firebaseio.com', '    ');
      final response = await http.get(url);

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedWorkshopsItems.add(WorkshopsItemReport(
          id: item.key,
          Name: item.value['Name'],
          presentBy: item.value['PresentBy'],
          workshopDate: item.value['WorkshopDate'],
          workshopPlace: item.value['WorkshopPlace'],
          workshopTime: item.value['WorkshopTime'],
          workshopLink: item.value['WorkshopLink'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      setState(() {
        isLoading = false;
        _workshopItem = loadedWorkshopsItems;
      });
    }
  }

  void _LoadConferencesItems() async {
    final List<ConferencesItemReport> loadedConferencesItems = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url =
          Uri.https('senior-project-72daf-default-rtdb.firebaseio.com', '    ');
      final response = await http.get(url);

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedConferencesItems.add(ConferencesItemReport(
          id: item.key,
          Name: item.value['Name'],
          presentBy: item.value['PresentBy'],
          confDate: item.value['ConfDate'],
          confTime: item.value['ConfTime'],
          confPlace: item.value['ConfPlace'],
          confLink: item.value['confLink'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      setState(() {
        isLoading = false;
        _confItem = loadedConferencesItems;
      });
    }
  }

  void _LoadOtherEventsItems() async {
    final List<OtherEventsItemReport> loadedOtherEventsItems = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'eventsOthersDB.json');
      final response = await http.get(url);

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedOtherEventsItems.add(OtherEventsItemReport(
          id: item.key,
          Name: item.value['OEvent_name'],
          presentBy: item.value['OEvent_presenter'],
          otherEventDate: item.value['OEvent_date'],
          otherEventTime: item.value['OEvent_time'],
          otherEventPlace: item.value['OEvent_location'],
          otherEventLink: item.value['OEvent_link'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      setState(() {
        isLoading = false;
        _otherItem = loadedOtherEventsItems;
      });
    }
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build enter');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("الفعاليات", style: TextStyles.heading1),
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
                selectedItemColor: CustomColors.lightBlue,
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
                child: Column(children: [
                  const SizedBox(height: 15),
                  Expanded(
                      child: Stack(children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.BackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                    Column(children: [
                      Container(
                        height: 60,
                        padding:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: TextField(
                          autofocus: false,
                          controller: _userInputController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          textAlignVertical: TextAlignVertical.bottom,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: CustomColors.darkGrey,
                          ),
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              color: CustomColors.darkGrey,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: CustomColors.darkGrey, width: 1),
                            ),
                            prefixIcon: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: CustomColors.darkGrey,
                                ),
                                onPressed: () {
                                  isSelected
                                      ? searchCourseList.clear()
                                      : searchWorkshopList.clear();
                                  searchConfList.clear();
                                  searchOtherList.clear();

                                  filterSearchResults(
                                      _userInputController.text,
                                      isSelected ? _courseItem : _workshopItem,
                                      _confItem,
                                      _otherItem);

                                  FocusScope.of(context).unfocus();
                                }),
                            hintText: 'ابحث',
                            suffixIcon: _userInputController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _userInputController.clear();

                                      setState(() {
                                        isSearch = false;
                                      });
                                    },
                                    icon: const Icon(Icons.clear,
                                        color: CustomColors.darkGrey))
                                : null,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: CustomColors.darkGrey, width: 1),
                            ),
                          ),
                          onChanged: (text) {
                            setState(() {});
                          },
                          onSubmitted: (text) {
                            isSelected
                                ? searchCourseList.clear()
                                : searchWorkshopList.clear();
                            searchConfList.clear();
                            searchOtherList.clear();

                            filterSearchResults(
                                _userInputController.text,
                                isSelected ? _courseItem : _workshopItem,
                                _confItem,
                                _otherItem);

                            FocusScope.of(context).unfocus();
                          },
                          onTap: () {
                            isSearch = true;
                            searchCourseList.clear();
                            searchWorkshopList.clear();
                            searchConfList.clear();
                            searchOtherList.clear();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getFilterButton(() {
                              if (!isSelectedCourse) {
                                isSelectedCourse = !isSelectedCourse;
                                setState(() {
                                  // searchList = getValidCertificates();
                                  if (isSelectedCourse == true)
                                    isSelectedConfre = false;
                                  isSelectedWorkshop = false;
                                  isSelectedOther = false;
                                });
                              }
                            },
                                isSelectedCourse
                                    ? CustomColors.pink
                                    : Colors.transparent,
                                "الدورات"),
                            getFilterButton(() {
                              if (!isSelectedWorkshop) {
                                isSelectedWorkshop = !isSelectedWorkshop;
                                setState(() {
                                  // searchList = getValidCertificates();
                                  if (isSelectedWorkshop == true)
                                    isSelectedConfre = false;
                                  isSelectedCourse = false;
                                  isSelectedOther = false;
                                });
                              }
                            },
                                isSelectedWorkshop
                                    ? CustomColors.pink
                                    : Colors.transparent,
                                "ورش عمل"),
                            getFilterButton(() {
                              if (!isSelectedConfre) {
                                isSelectedConfre = !isSelectedConfre;
                                setState(() {
                                  // searchList = getValidCertificates();
                                  if (isSelectedConfre == true)
                                    isSelectedCourse = false;
                                  isSelectedWorkshop = false;
                                  isSelectedOther = false;
                                });
                              }
                            },
                                isSelectedConfre
                                    ? CustomColors.pink
                                    : Colors.transparent,
                                "المؤتمرات"),
                            getFilterButton(() {
                              if (!isSelectedOther) {
                                isSelectedOther = !isSelectedOther;
                                setState(() {
                                  // searchList = getValidCertificates();
                                  if (isSelectedOther == true)
                                    isSelectedConfre = false;
                                  isSelectedWorkshop = false;
                                  isSelectedCourse = false;
                                });
                              }
                            },
                                isSelectedOther
                                    ? CustomColors.pink
                                    : Colors.transparent,
                                "اخرى"),
                          ],
                        ),
                      ),
                      // if ((isSearch
                      //     ? searchCourseList.isEmpty
                      //     : searchWorkshopList.isEmpty))
                      // Expanded(
                      //   child: Center(
                      //     child: SizedBox(
                      //       // padding: EdgeInsets.only(bottom: 20),
                      //       // alignment: Alignment.topCenter,
                      //       height: 200,
                      //       child: Image.asset('assets/images/notFound.png'),
                      //     ),
                      //   ),
                      // ),
                      if (_courseItem.isNotEmpty)
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: isSearch
                                      ? ListView.builder(
                                          itemCount: searchCourseList.length,
                                          itemBuilder: (context, index) =>
                                              CoursesCard(
                                                  searchCourseList[index]))
                                      : ListView.builder(
                                          itemCount: _courseItem.length,
                                          itemBuilder: (context, index) =>
                                              CoursesCard(_courseItem[index])),
                                ))),

                      if (_workshopItem.isNotEmpty)
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: isSearch
                                ? ListView.builder(
                                    itemCount: searchWorkshopList.length,
                                    itemBuilder: (context, index) =>
                                        WorkshopCard(searchWorkshopList[index]))
                                : ListView.builder(
                                    itemCount: _workshopItem.length,
                                    itemBuilder: (context, index) =>
                                        WorkshopCard(_workshopItem[index])),
                          ),
                        )),

                      if (_confItem.isNotEmpty)
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: isSearch
                                ? ListView.builder(
                                    itemCount: searchConfList.length,
                                    itemBuilder: (context, index) =>
                                        ConfCard(searchConfList[index]))
                                : ListView.builder(
                                    itemCount: _workshopItem.length,
                                    itemBuilder: (context, index) =>
                                        ConfCard(_confItem[index])),
                          ),
                        )),

                      if (_otherItem.isNotEmpty)
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: isSearch
                                ? ListView.builder(
                                    itemCount: searchOtherList.length,
                                    itemBuilder: (context, index) =>
                                        OtherCard(searchOtherList[index]))
                                : ListView.builder(
                                    itemCount: _otherItem.length,
                                    itemBuilder: (context, index) =>
                                        OtherCard(_otherItem[index])),
                          ),
                        )),
                    ])
                  ]))
                ]))));
  }

  Widget getFilterButton(
      void Function() onButtonPress, Color buttonColor, String title) {
    return ElevatedButton(
      onPressed: onButtonPress,
      style: ElevatedButton.styleFrom(
          side: const BorderSide(color: CustomColors.darkGrey, width: 1),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: buttonColor),
      child: Text(title, style: TextStyles.heading2),
    );
  }

  void filterSearchResults(
      String query,
      List ls,
      List<ConferencesItemReport> confItem,
      List<OtherEventsItemReport> otherItem) {
    setState(() {
      for (int item = 0; item < ls.length; item++) {
        if (ls[item].name!.toLowerCase().contains(query.toLowerCase().trim())) {
          isSelected
              ? searchCourseList.add(ls[item])
              : searchWorkshopList.add(ls[item]);
          searchConfList.add(ls[item]);
          searchOtherList.add(ls[item]);
        } //Add
        // else {
        //   if (ls[item]
        //       .category!
        //       .toLowerCase()
        //       .contains(query.toLowerCase().trim())) {
        //     isSelected
        //         ? searchCourseList.add(ls[item])
        //         : searchWorkshopList.add(ls[item]);
        //     searchConfList.add(ls[item]);
        //     searchOtherList.add(ls[item]);
        //   }
        // }
      }
    });
  }
}
