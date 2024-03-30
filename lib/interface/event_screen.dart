// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
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

  int _selectedPageIndex = 1;
  bool isSelected = true;
  bool isSearch = false;

  bool isSelectedCourse = true;
  bool isSelectedWorkshop = false;
  bool isSelectedConfre = false;
  bool isSelectedOther = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await Future.wait([
        _loadCoursesItems(),
        _loadWorkshopsItems(),
        _loadConferencesItems(),
        _loadOtherEventsItems(),
      ]);
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load data. Please check your connection.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadCoursesItems() async {
    final url = Uri.https(
      'senior-project-72daf-default-rtdb.firebaseio.com',
      'eventsCoursesDB.json',
    );
    final response = await http.get(url);

    final Map<String, dynamic> foundData = json.decode(response.body);
    final loadedCoursesItems = foundData.entries.map((item) {
      return CoursesItemReport(
        id: item.key,
        name: item.value['course_name'],
        presentBy: item.value['course_presenter'],
        date: item.value['course_date'],
        time: item.value['course_time'],
        location: item.value['course_location'],
        courseLink: item.value['course_link'],
      );
    }).toList();

    setState(() {
      _courseItem = loadedCoursesItems;
    });
  }

  Future<void> _loadWorkshopsItems() async {
    final url = Uri.https(
      'senior-project-72daf-default-rtdb.firebaseio.com',
      'eventsWorkshopsDB.json',
    );
    final response = await http.get(url);

    final Map<String, dynamic> foundData = json.decode(response.body);
    final loadedWorkshopsItems = foundData.entries.map((item) {
      return WorkshopsItemReport(
        id: item.key,
        name: item.value['workshop_name'],
        presentBy: item.value['workshop_presenter'],
        date: item.value['workshop_date'],
        location: item.value['workshop_location'],
        time: item.value['workshop_time'],
        workshopLink: item.value['workshop_link'],
      );
    }).toList();

    setState(() {
      _workshopItem = loadedWorkshopsItems;
    });
  }

  Future<void> _loadConferencesItems() async {
    final url = Uri.https(
      'senior-project-72daf-default-rtdb.firebaseio.com',
      'eventsConferencesDB.json',
    );
    final response = await http.get(url);

    final Map<String, dynamic> foundData = json.decode(response.body);
    final loadedConferencesItems = foundData.entries.map((item) {
      return ConferencesItemReport(
        id: item.key,
        name: item.value['conference_name'],
        date: item.value['conference_date'],
        timestamp:item.value['timestamp'],
        time: item.value['conference_time'],
        location: item.value['conference_location'],
        confLink: item.value['conference_link'],
      );
    }).toList();

    setState(() {
      _confItem = loadedConferencesItems;
    });
  }

  Future<void> _loadOtherEventsItems() async {
    final url = Uri.https(
      'senior-project-72daf-default-rtdb.firebaseio.com',
      'eventsOthersDB.json',
    );
    final response = await http.get(url);

    final Map<String, dynamic> eventData = json.decode(response.body);
    final loadedOtherEventsItems = eventData.entries.map((item) {
      return OtherEventsItemReport(
        id: item.key,
        name: item.value['OEvent_name'],
        presentBy: item.value['OEvent_presenter'],
        date: item.value['OEvent_date'],
        time: item.value['OEvent_time'],
        location: item.value['OEvent_location'],
        otherEventLink: item.value['OEvent_link'],
      );
    }).toList();

    setState(() {
      _otherItem = loadedOtherEventsItems;
    });
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

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                  filterSearchResults(
                                    _userInputController.text,
                                    isSelectedCourse
                                        ? _courseItem
                                        : isSelectedConfre
                                            ? _confItem
                                            : isSelectedWorkshop
                                                ? _workshopItem
                                                : isSelectedOther
                                                    ? _otherItem
                                                    : [],
                                  );
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
                            // isSelected
                            //     ? searchCourseList.clear()
                            //     : searchWorkshopList.clear();
                            // searchConfList.clear();
                            // searchOtherList.clear();
                            filterSearchResults(
                              _userInputController.text,
                              isSelectedCourse
                                  ? _courseItem
                                  : isSelectedConfre
                                      ? _confItem
                                      : isSelectedWorkshop
                                          ? _workshopItem
                                          : isSelectedOther
                                              ? _otherItem
                                              : [],
                            );

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
                              FocusScope.of(context).unfocus();

                              if (!isSelectedCourse) {
                                isSelectedCourse = !isSelectedCourse;
                                setState(() {
                                  // searchList = getValidCertificates();
                                  if (isSelectedCourse == true) {
                                    isSelectedConfre = false;
                                    isSelectedWorkshop = false;
                                    isSelectedOther = false;
                                  }
                                  if (isSearch) {
                                    _userInputController.clear();
                                    isSearch = false;
                                  }
                                });
                              }
                            },
                                isSelectedCourse
                                    ? CustomColors.pink
                                    : Colors.transparent,
                                "الدورات"),
                            getFilterButton(() {
                              FocusScope.of(context).unfocus();

                              if (!isSelectedWorkshop) {
                                isSelectedWorkshop = !isSelectedWorkshop;
                                setState(() {
                                  // searchList = getValidCertificates();
                                  if (isSelectedWorkshop == true) {
                                    isSelectedConfre = false;
                                    isSelectedCourse = false;
                                    isSelectedOther = false;
                                  }
                                  if (isSearch) {
                                    _userInputController.clear();
                                    isSearch = false;
                                  }
                                });
                              }
                            },
                                isSelectedWorkshop
                                    ? CustomColors.pink
                                    : Colors.transparent,
                                "ورش عمل"),
                            getFilterButton(() {
                              FocusScope.of(context).unfocus();

                              if (!isSelectedConfre) {
                                isSelectedConfre = !isSelectedConfre;
                                setState(() {
                                  // searchList = getValidCertificates();
                                  if (isSelectedConfre == true) {
                                    isSelectedCourse = false;
                                    isSelectedWorkshop = false;
                                    isSelectedOther = false;
                                  }
                                  if (isSearch) {
                                    _userInputController.clear();
                                    isSearch = false;
                                  }
                                });
                              }
                            },
                                isSelectedConfre
                                    ? CustomColors.pink
                                    : Colors.transparent,
                                "المؤتمرات"),
                            getFilterButton(() {
                              FocusScope.of(context).unfocus();
                              if (!isSelectedOther) {
                                isSelectedOther = !isSelectedOther;
                                setState(() {
                                  // searchList = getValidCertificates();
                                  if (isSelectedOther == true) {
                                    isSelectedConfre = false;
                                    isSelectedWorkshop = false;
                                    isSelectedCourse = false;
                                  }
                                  if (isSearch) {
                                    _userInputController.clear();
                                    isSearch = false;
                                  }
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
                      if ((isSelectedCourse && _courseItem.isEmpty) ||
                          (isSelectedWorkshop && _workshopItem.isEmpty) ||
                          (isSelectedConfre && _confItem.isEmpty) ||
                          (isSelectedOther && _otherItem.isEmpty) ||
                          (isSearch &&
                              ((searchCourseList.isEmpty && isSelectedCourse) ||
                                  (isSelectedWorkshop &&
                                      searchWorkshopList.isEmpty) ||
                                  (isSelectedConfre &&
                                      searchConfList.isEmpty) ||
                                  (isSelectedOther &&
                                      searchOtherList.isEmpty))))
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              height: 200,
                              child: Image.asset('assets/images/notFound.png'),
                            ),
                          ),
                        ),
                      // if (isSelectedCourse
                      //     ? (isSearch
                      //         ? searchCourseList.isEmpty
                      //         : _courseItem.isEmpty)
                      //     : false)
                      //   Expanded(
                      //     child: Center(
                      //       child: Container(
                      //         // padding: EdgeInsets.only(bottom: 20),
                      //         // alignment: Alignment.topCenter,
                      //         height: 200,
                      //         child: Image.asset('assets/images/notFound.png'),
                      //       ),
                      //     ),
                      //   ),
                      if (isSelectedCourse && _courseItem.isNotEmpty)
                        buildExpandedWidget(_courseItem, searchCourseList,
                            (item) => CoursesCard(item)),

                      if (isSelectedWorkshop && _workshopItem.isNotEmpty)
                        buildExpandedWidget(_workshopItem, searchWorkshopList,
                            (item) => WorkshopCard(item)),

                      if (isSelectedConfre && _confItem.isNotEmpty)
                        buildExpandedWidget(_confItem, searchConfList,
                            (item) => ConfCard(item)),

                      if (isSelectedOther && _otherItem.isNotEmpty)
                        buildExpandedWidget(_otherItem, searchOtherList,
                            (item) => OtherCard(item)),
                    ])
                  ]))
                ]))));
  }

  Widget buildExpandedWidget(
      List itemList, List searchList, Widget Function(dynamic) itemBuilder) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: isSearch
              ? ListView.builder(
                  itemCount: searchList.length,
                  itemBuilder: (context, index) =>
                      itemBuilder(searchList[index]),
                )
              : ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) => itemBuilder(itemList[index]),
                ),
        ),
      ),
    );
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
  ) {
    setState(() {
      searchCourseList.clear();
      searchWorkshopList.clear();
      searchConfList.clear();
      searchOtherList.clear();

      for (int item = 0; item < ls.length; item++) {
        if (ls[item].Name!.toLowerCase().contains(query.toLowerCase().trim())) {
          if (isSelectedCourse) {
            searchCourseList.add(ls[item]);
          } else if (isSelectedWorkshop) {
            searchWorkshopList.add(ls[item]);
          } else if (isSelectedConfre) {
            searchConfList.add(ls[item]);
          } else {
            searchOtherList.add(ls[item]);
          }
        }
        // else if (ls[item].category!.toLowerCase().contains(query.toLowerCase().trim())) {
        //
        // }
      }
    });
  }
}
