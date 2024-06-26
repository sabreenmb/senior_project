// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/conference_model.dart';
import 'package:senior_project/model/courses_model.dart';
import 'package:senior_project/model/other_events_model.dart';
import 'package:senior_project/model/workshop_model.dart';
import 'package:senior_project/common/theme.dart';
import 'package:senior_project/widgets/conferences_card.dart';
import 'package:senior_project/widgets/other_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:senior_project/widgets/workshop_card.dart';
import 'package:shimmer/shimmer.dart';
import '../common/firebase_api.dart';
import '../common/common_functions.dart';
import '../widgets/course_card.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});
  @override
  State<EventScreen> createState() => _EventState();
}

class _EventState extends State<EventScreen> {
  final _userInputController = TextEditingController();
  late StreamSubscription connSub;

  List<CoursesModel> searchCourseList = [];
  List<WorkshopModel> searchWorkshopList = [];
  List<ConferencesModel> searchConfList = [];
  List<OtherEventsModel> searchOtherList = [];

  bool isSelected = true;
  bool isSearch = false;

  bool isSelectedCourse = true;
  bool isSelectedWorkshop = false;
  bool isSelectedConfre = false;
  bool isSelectedOther = false;
  String errorMessage = '';
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
  }

  @override
  void dispose() {
    connSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text("الفعاليات", style: TextStyles.pageTitle),
            centerTitle: true,
            iconTheme: const IconThemeData(color: CustomColors.darkGrey),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
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
                  child: Column(children: [
                    const SizedBox(height: 15),
                    Expanded(
                        child: Stack(children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: CustomColors.backgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                      ),
                      isOffline
                          ? Center(
                              child: SizedBox(
                                height: 200,
                                child: Image.asset(
                                    'assets/images/NoInternet_newo.png'),
                              ),
                            )
                          : Column(children: [
                              Container(
                                height: 60,
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
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
                                          color: CustomColors.darkGrey,
                                          width: 1),
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
                                                ? courseItems
                                                : isSelectedConfre
                                                    ? confItems
                                                    : isSelectedWorkshop
                                                        ? workshopItems
                                                        : isSelectedOther
                                                            ? otherItems
                                                            : [],
                                          );
                                          FocusScope.of(context).unfocus();
                                        }),
                                    hintText: 'ابحث',
                                    suffixIcon: _userInputController
                                            .text.isNotEmpty
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
                                          color: CustomColors.darkGrey,
                                          width: 1),
                                    ),
                                  ),
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  onSubmitted: (text) {
                                    filterSearchResults(
                                      _userInputController.text,
                                      isSelectedCourse
                                          ? courseItems
                                          : isSelectedConfre
                                              ? confItems
                                              : isSelectedWorkshop
                                                  ? workshopItems
                                                  : isSelectedOther
                                                      ? otherItems
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
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      getFilterButton(() {
                                        FocusScope.of(context).unfocus();
                                        if (!isSelectedCourse) {
                                          isSelectedCourse = !isSelectedCourse;
                                          setState(() {
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
                                              : CustomColors.noColor,
                                          "الدورات"),
                                      getFilterButton(() {
                                        FocusScope.of(context).unfocus();
                                        if (!isSelectedWorkshop) {
                                          isSelectedWorkshop =
                                              !isSelectedWorkshop;
                                          setState(() {
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
                                              : CustomColors.noColor,
                                          "ورش عمل"),
                                      getFilterButton(() {
                                        FocusScope.of(context).unfocus();

                                        if (!isSelectedConfre) {
                                          isSelectedConfre = !isSelectedConfre;
                                          setState(() {
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
                                              : CustomColors.noColor,
                                          "المؤتمرات"),
                                      getFilterButton(() {
                                        FocusScope.of(context).unfocus();
                                        if (!isSelectedOther) {
                                          isSelectedOther = !isSelectedOther;
                                          setState(() {
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
                                              : CustomColors.noColor,
                                          "اخرى"),
                                    ],
                                  ),
                                ),
                              ),
                              if (isSearch &&
                                  ((searchCourseList.isEmpty &&
                                          isSelectedCourse) ||
                                      (isSelectedWorkshop &&
                                          searchWorkshopList.isEmpty) ||
                                      (isSelectedConfre &&
                                          searchConfList.isEmpty) ||
                                      (isSelectedOther &&
                                          searchOtherList.isEmpty)))
                                Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      height: 200,
                                      child: Image.asset(
                                          'assets/images/searching-removebg-preview.png'),
                                    ),
                                  ),
                                ),
                              if (isSelectedCourse )
                                buildExpandedWidget(
                                    courseItems,
                                    searchCourseList,
                                    (item) => CoursesCard(item),
                                    'eventsCoursesDB'),

                              if (isSelectedWorkshop )
                                buildExpandedWidget(
                                    workshopItems,
                                    searchWorkshopList,
                                    (item) => WorkshopCard(item),
                                    'eventsWorkshopsDB'),

                              if (isSelectedConfre)
                                buildExpandedWidget(
                                    confItems,
                                    searchConfList,
                                    (item) => ConferencesCard(item),
                                    'eventsConferencesDB'),

                              if (isSelectedOther )
                                buildExpandedWidget(
                                    otherItems,
                                    searchOtherList,
                                    (item) => OtherCard(item),
                                    'eventsOthersDB'),
                            ])
                    ]))
                  ])))),
    );
  }

  Widget buildExpandedWidget(List itemList, List searchList,
      Widget Function(dynamic) itemBuilder, String path) {
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
                : _buildCardsList(path, itemList, itemBuilder)),
      ),
    );
  }

  Widget _buildCardsList(
      String name, List itemList, Widget Function(dynamic) itemBuilder) {
    return StreamBuilder(
      stream: FirebaseAPI.databaseReference(name),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('حدث خطأ اثناء تحميل البيانات');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          if (itemList.isEmpty)
          {
            return Shimmer.fromColors(
              baseColor: CustomColors.white,
              highlightColor: CustomColors.highlightColor,
              enabled: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return WorkshopCard(WorkshopModel(
                      time: '',
                      timestamp: '',
                      location: '',
                      name: ' ',
                      presentBy: ' ',
                      date: '',
                      id: '',
                      workshopLink: ' '));
                },
              ),
            );
          } else {
            return Shimmer.fromColors(
              baseColor: CustomColors.white,
              highlightColor: CustomColors.highlightColor,
              enabled: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return itemBuilder(itemList[0]);
                },
              ),
            );
          }
        }
        final data = snapshot.data?.snapshot.value;

        if ( data == null ||data == 'placeholder') {
          return Center(
            child: SizedBox(
              height: 200,
              child:
                  Image.asset('assets/images/no_content_removebg_preview.png'),
            ),
          );
        }

        Map<dynamic, dynamic> data2 = data as Map<dynamic, dynamic>;

        List<dynamic> reports;
        if (name == 'eventsCoursesDB') {
          courseItems.clear();
          reports = data2.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return CoursesModel(
              id: key,
              name: value['course_name'],
              presentBy: value['course_presenter'],
              date: value['course_date'],
              time: value['course_time'],
              location: value['course_location'],
              courseLink: value['course_link'],
              timestamp: value['timestamp'],
            );
          }).toList();
          courseItems = reports.cast<CoursesModel>();
        } else if (name == 'eventsWorkshopsDB') {
          workshopItems.clear();
          reports = data2.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return WorkshopModel(
              id: key,
              name: value['workshop_name'],
              presentBy: value['workshop_presenter'],
              date: value['workshop_date'],
              location: value['workshop_location'],
              time: value['workshop_time'],
              workshopLink: value['workshop_link'],
              timestamp: value['timestamp'],
            );
          }).toList();
          workshopItems = reports.cast<WorkshopModel>();
        } else if (name == 'eventsConferencesDB') {
          confItems.clear();
          reports = data2.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return ConferencesModel(
              id: key,
              name: value['conference_name'],
              date: value['conference_date'],
              timestamp: value['timestamp'],
              time: value['conference_time'],
              location: value['conference_location'],
              confLink: value['conference_link'],
            );
          }).toList();
          confItems = reports.cast<ConferencesModel>();
        } else {
          otherItems.clear();
          reports = data2.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return OtherEventsModel(
              id: key,
              name: value['OEvent_name'],
              presentBy: value['OEvent_presenter'],
              date: value['OEvent_date'],
              time: value['OEvent_time'],
              location: value['OEvent_location'],
              otherEventLink: value['OEvent_link'],
              timestamp: value['timestamp'],
            );
          }).toList();
          otherItems = reports.cast<OtherEventsModel>();
        }
        // to do store the values
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return itemBuilder(report);
          },
        );
      },
    );
  }

  Widget getFilterButton(
      void Function() onButtonPress, Color buttonColor, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onButtonPress,
        style: ElevatedButton.styleFrom(
            side: BorderSide(
                color: (buttonColor == CustomColors.pink
                    ? buttonColor
                    : CustomColors.darkGrey),
                width: 1),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: buttonColor),
        child: Text(title, style: TextStyles.heading2D),
      ),
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
        if (ls[item].name!.toLowerCase().contains(query.toLowerCase().trim())) {
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
