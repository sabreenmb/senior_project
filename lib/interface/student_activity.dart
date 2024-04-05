import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/ChatScreen.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/interface/SaveListScreen.dart';
import 'package:senior_project/interface/add_lost_item_screen.dart';
import 'package:senior_project/interface/create_student_activity.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/model/create_student_activity_report.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/create_student_activity_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:shimmer/shimmer.dart';

import '../firebaseConnection.dart';

class StudentActivity extends StatefulWidget {
  const StudentActivity({super.key});

  @override
  State<StudentActivity> createState() => _StudentActivityState();
}

class _StudentActivityState extends State<StudentActivity>
    with SingleTickerProviderStateMixin {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 2;
  //search
  List<CreateStudentActivityReport> searchActivityList = [];

  final _userInputController = TextEditingController();
  //filter
  bool isSearch = false;
  bool isNew = false;
  //create button
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // _pages = [
    //   {
    //     'page': const HomeScreen(),
    //   },
    //   {
    //     'page': const ChatScreen(),
    //   },
    //   {
    //     'page': const AddLostItemScreen(),
    //   },
    //   {
    //     'page': const ServisesScreen(),
    //   },
    //   {
    //     'page': const SaveListScreen(),
    //   },
    // ];
  }

  void _selectPage(int index) {
    setState(() {
      if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
        _selectedPageIndex = index;
      }
      //todo uncomment on next sprints
      // if (index == 0) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => HomeScreen()));
      // } else if (index == 1) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => ServisesScreen()));
      // } else if (index == 2) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => ChatScreen()));
      // } else if (index == 3) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => SaveListScreen()));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build enter');
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
            title: Text("أنشطة طلابية", style: TextStyles.heading1),
            centerTitle: false,
            iconTheme: const IconThemeData(color: CustomColors.darkGrey),
          ),
          endDrawer: const SideDrawer(),
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
                    BottomNavigationBarItem(
                      label: "",
                      activeIcon: null,
                      icon: Icon(null),
                    ),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: CustomColors.lightBlue,
            hoverElevation: 10,
            splashColor: Colors.grey,
            tooltip: '',
            elevation: 4,
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const CreateStudentActivity()));
              //_LoadCreatedActivities();
            },
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
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
                                    color: CustomColors.darkGrey, width: 1),
                              ),
                              prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: CustomColors.darkGrey,
                                  ),
                                  onPressed: () {
                                    searchActivityList.clear();
                                    filterSearchResults(
                                        _userInputController.text,
                                        createStudentActivityReport);
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
                              searchActivityList.clear();
                              filterSearchResults(_userInputController.text,
                                  createStudentActivityReport);
                              FocusScope.of(context).unfocus();
                            },
                            onTap: () {
                              isSearch = true;
                              searchActivityList.clear();
                              // searchActivityList.clear();
                            },
                          ),
                        ),
                        if ((isSearch
                            ? searchActivityList.isEmpty
                            : createStudentActivityReport.isEmpty))
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                // padding: EdgeInsets.only(bottom: 20),
                                // alignment: Alignment.topCenter,
                                height: 200,
                                child:
                                    Image.asset('assets/images/notFound.png'),
                              ),
                            ),
                          ),
                        if (createStudentActivityReport.isNotEmpty)
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: isSearch
                                    ? ListView.builder(
                                        itemCount: searchActivityList.length,
                                        itemBuilder: (context, index) =>
                                            CreateStudentActivityCard(
                                                searchActivityList[index]))
                                    : _buildcardList()
                                // ListView.builder(
                                //     itemCount: createStudentActivityReport.length,
                                //
                                //     itemBuilder: (context, index) =>
                                //             CreateStudentActivityCard(
                                //                 _createStudentActivityReport[
                                //                     index])),
                                ),
                          )),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          )),
    );
  }

  Widget _buildcardList() {
    return StreamBuilder(
      stream: Connection.databaseReference('create-activity'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // return loadingFunction(context, true);
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: 4,
              itemBuilder: (context, index) {
                return CreateStudentActivityCard(
                    createStudentActivityReport[0]);
              },
            ),
          );
        }

        final Map<dynamic, dynamic> data =
            snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
        if (data == null) {
          return Text('No data available');
        }

// todo make sure it works
        final List<CreateStudentActivityReport> reports =
            data.entries.map((entry) {
          final key = entry.key;
          final value = entry.value;
          return CreateStudentActivityReport(
            numOfPerson: value['NumOfPerson'],
            date: value['date'],
            name: value['name'],
            time: value['time'],
            location: value['location'],
            id: key,
          );
        }).toList();
        createStudentActivityReport.clear();
        createStudentActivityReport = reports;
        // to do store the values
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return CreateStudentActivityCard(report);
          },
        );
      },
    );
  }

  void filterSearchResults(String query, List ls) {
    setState(() {
      for (int item = 0; item < ls.length; item++) {
        if (ls[item].name!.toLowerCase().contains(query.toLowerCase().trim())) {
          searchActivityList.add(ls[item]);
        } //Add
        // else {
        //   if (ls[item]
        //       .category!
        //       .toLowerCase()
        //       .contains(query.toLowerCase().trim())) {
        //     searchSessionList.add(ls[item]);
        //   }
        // }
      }
    });
  }
}
