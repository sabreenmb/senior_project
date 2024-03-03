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
import 'package:senior_project/widgets/side_menu.dart';
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

  // bool isValid = false;
  // bool isExpired = false;

  late AnimationController _animationController;
  late List<Map<String, Object>> _pages;

  int _selectedPageIndex = 1;
  bool isSelected = true;
  bool isSearch = false;

  bool isSelectedourse = true;
  bool isSelectedWorkshop = true;
  bool isSelectedConfre = true;
  bool isSelectedOther = true;

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

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 200),
  //   );
  //   _pages = [
  //     {
  //       'page': const HomeScreen(),
  //     },
  //     {
  //       'page': const ChatScreen(),
  //     },
  //     {
  //       'page': const ServisesScreen(),
  //     },
  //     {
  //       'page': const SaveListScreen(),
  //     },
  //   ];
  //   _LoadCoursesItems();
  //   _LoadWorkshopsItems();
  //   _LoadConferencesItems();
  //   _LoadOtherEventsItems();
  // }

  void _LoadCoursesItems() async {
    final List<CoursesItemReport> loadedCoursesItems = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url =
          Uri.https('senior-project-72daf-default-rtdb.firebaseio.com', '    ');
      final response = await http.get(url);

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedCoursesItems.add(CoursesItemReport(
          id: item.key,
          Name: item.value['Name'],
          presentBy: item.value['PresentBy'],
          courseDate: item.value['CourseDate'],
          courseTime: item.value['CourseTime'],
          coursePlace: item.value['CoursePlace'],
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
      final url =
          Uri.https('senior-project-72daf-default-rtdb.firebaseio.com', '    ');
      final response = await http.get(url);

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedOtherEventsItems.add(OtherEventsItemReport(
          id: item.key,
          Name: item.value['Name'],
          presentBy: item.value['PresentBy'],
          otherEventDate: item.value['OtherEventDate'],
          otherEventTime: item.value['OtherEventTime'],
          otherEventPlace: item.value['OtherEventPlace'],
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
                            //todo the same value of on icon presed
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
                            ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                if (isSelected != true) {
                                  setState(() {
                                    isSelected = true;
                                    if (isSearch) {
                                      _userInputController.clear();
                                      isSearch = false;
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(90, 40),
                                  side: BorderSide(
                                      color: isSelected
                                          ? Colors.transparent
                                          : CustomColors.darkGrey,
                                      width: 1),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: isSelected
                                      ? CustomColors.pink
                                      : Colors.transparent),
                              child:
                                  Text("الدورات", style: TextStyles.heading2),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (isSelected == true) {
                                  setState(() {
                                    isSelected = false;
                                    if (isSearch) {
                                      _userInputController.clear();
                                      isSearch = false;
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(110, 40),
                                  side: BorderSide(
                                      color: !isSelected
                                          ? Colors.transparent
                                          : CustomColors.darkGrey,
                                      width: 1),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: !isSelected
                                      ? CustomColors.pink
                                      : Colors.transparent),
                              child: Text(
                                "ورش عمل",
                                style: TextStyles.heading2,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (isSelected == false) {
                                  setState(() {
                                    isSelected = true;
                                    if (isSearch) {
                                      _userInputController.clear();
                                      isSearch = true;
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(100, 40),
                                  side: BorderSide(
                                      color: !isSelected
                                          ? Colors.transparent
                                          : CustomColors.darkGrey,
                                      width: 1),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: !isSelected
                                      ? CustomColors.pink
                                      : Colors.transparent),
                              child: Text(
                                "المؤتمرات",
                                style: TextStyles.heading2,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (isSelected == true) {
                                  setState(() {
                                    isSelected = false;
                                    if (isSearch) {
                                      _userInputController.clear();
                                      isSearch = false;
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(50, 40),
                                  side: BorderSide(
                                      color: !isSelected
                                          ? Colors.transparent
                                          : CustomColors.darkGrey,
                                      width: 1),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: !isSelected
                                      ? CustomColors.pink
                                      : Colors.transparent),
                              child: Text(
                                "اخرى",
                                style: TextStyles.heading2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // getFilterButton(() {
                      //   setState(() {
                      //     searchCourseList = _courseItem;
                      //     searchWorkshopList = _workshopItem;
                      //     searchConfList = _confItem;
                      //     searchOtherList = _otherItem;
                      //   });
                      // },
                      //     searchWorkshopList == false &&
                      //             searchConfList == false &&
                      //             searchOtherList == false
                      //         ? Colors.transparent
                      //         : CustomColors.darkGrey,
                      //     false,
                      //     'دورات',
                      //     searchWorkshopList == false &&
                      //             searchConfList == false &&
                      //             searchOtherList == false
                      //         ? CustomColors.pink
                      //         : Colors.transparent.withOpacity(0.7)),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      // getFilterButton(() {
                      //   if (!searchWorkshopList) {
                      //     isValid = !isValid;
                      //     setState(() {
                      //       searchWorkshopList = _workshopItem;
                      //       if (isValid == true) isExpired = false;
                      //     });
                      //   }
                      // },
                      //     isValid ? Colors.transparent : CustomColors.darkGrey,
                      //     false,
                      //     'ورش عمل',
                      //     isValid
                      //         ? CustomColors.pink
                      //         : Colors.transparent.withOpacity(0.7)),

                      // const SizedBox(
                      //   width: 5,
                      // ),

                      // getFilterButton(() {
                      //   setState(() {
                      //     searchCourseList = _courseItem;
                      //     searchWorkshopList = _workshopItem;
                      //     searchConfList = _confItem;
                      //     searchOtherList = _otherItem;
                      //   });
                      // },
                      //     searchCourseList == false &&
                      //             searchWorkshopList == false &&
                      //             searchOtherList == false
                      //         ? Colors.transparent
                      //         : CustomColors.darkGrey,
                      //     false,
                      //     'المؤتمرات',
                      //     searchCourseList == false &&
                      //             searchWorkshopList == false &&
                      //             searchOtherList == false
                      //         ? CustomColors.pink
                      //         : Colors.transparent.withOpacity(0.7)),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      // getFilterButton(() {
                      //   setState(() {
                      //     searchCourseList = _courseItem;
                      //     searchWorkshopList = _workshopItem;
                      //     searchConfList = _confItem;
                      //     searchOtherList = _otherItem;
                      //   });
                      // },
                      //     searchCourseList == false &&
                      //             searchWorkshopList == false &&
                      //             searchConfList == false
                      //         ? Colors.transparent
                      //         : CustomColors.darkGrey,
                      //     false,
                      //     'اخرى',
                      //     searchCourseList == false &&
                      //             searchWorkshopList == false &&
                      //             searchConfList == false
                      //         ? CustomColors.pink
                      //         : Colors.transparent.withOpacity(0.7)),
                      // const SizedBox(
                      //   width: 5,
                      // ),

                      if ((isSearch
                          ? searchCourseList.isEmpty
                          : searchWorkshopList.isEmpty))
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              // padding: EdgeInsets.only(bottom: 20),
                              // alignment: Alignment.topCenter,
                              height: 200,
                              child: Image.asset('assets/images/notFound.png'),
                            ),
                          ),
                        ),

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
                                        CoursesCard(searchCourseList[index]))
                                : ListView.builder(
                                    itemCount: _courseItem.length,
                                    itemBuilder: (context, index) =>
                                        CoursesCard(_courseItem[index])),
                          ),
                        )),
                    ])
                  ]))
                ]))));
  }

  // Widget getFilterButton(void Function() onButtonPress, Color buttonColor,
  //     bool isImage, String title, Color textColor) {
  //   return ElevatedButton(
  //       onPressed: onButtonPress,
  //       style: ElevatedButton.styleFrom(
  //           side: BorderSide(
  //               color: isSelected ? Colors.transparent : CustomColors.darkGrey,
  //               width: 1),
  //           elevation: 0,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           backgroundColor:
  //               isSelected ? CustomColors.pink : Colors.transparent)
  // }

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
