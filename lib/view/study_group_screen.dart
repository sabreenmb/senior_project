// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/view/study_group_form_screen.dart';
import 'package:senior_project/model/student_group_model.dart';
import 'package:senior_project/common/theme.dart';
import 'package:senior_project/widgets/study_group_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:shimmer/shimmer.dart';

import '../common/firebase_api.dart';
import '../common/common_functions.dart';

class StudyGroupScreen extends StatefulWidget {
  const StudyGroupScreen({super.key});

  @override
  State<StudyGroupScreen> createState() => _StudyGroupScreenState();
}

class _StudyGroupScreenState extends State<StudyGroupScreen>
    with SingleTickerProviderStateMixin {
  late StreamSubscription connSub;
  //search
  List<StudyGroupModel> searchSessionList = [];
  final _userInputController = TextEditingController();
  //filter
  bool isSearch = false;
  bool isNew = false;

  //create button
  late AnimationController _animationController;
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    connSub = Connectivity().onConnectivityChanged.listen(checkConnectivity);
  }

  @override
  void dispose() {
    _animationController.dispose();
    connSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("جلسة مذاكرة", style: TextStyles.pageTitle),
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
        bottomNavigationBar: buildBottomBarWF(context, 2),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          backgroundColor: CustomColors.lightBlue,
          hoverElevation: 10,
          splashColor: CustomColors.lightGrey,
          tooltip: '',
          elevation: 4,
          onPressed: () async {
            if (isOffline) {
              showNetWidgetDialog(context);
            } else {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const StudyGroupFormScreen()));
            }
          },
          child: const Icon(Icons.add),
        ),
        body: ModalProgressHUD(
          color: CustomColors.black,
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
                        : Column(
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
                                  decoration: InputDecoration(
                                    hintStyle: TextStyles.heading2D,
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
                                          searchSessionList.clear();
                                          filterSearchResults(
                                              _userInputController.text,
                                              studyGroupItems);
                                          FocusScope.of(context).unfocus();
                                        }),
                                    hintText: 'ابحث',
                                    suffixIcon: _userInputController
                                            .text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              _userInputController.clear();
                                              FocusScope.of(context).unfocus();

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
                                    searchSessionList.clear();
                                    filterSearchResults(
                                        _userInputController.text,
                                        studyGroupItems);
                                    FocusScope.of(context).unfocus();
                                  },
                                  onTap: () {
                                    isSearch = true;
                                    searchSessionList.clear();
                                  },
                                ),
                              ),
                              if ((isSearch
                                  ? searchSessionList.isEmpty
                                  : studyGroupItems.isEmpty))
                                Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      // padding: EdgeInsets.only(bottom: 20),
                                      // alignment: Alignment.topCenter,
                                      height: 200,
                                      child: Image.asset(isSearch
                                          ? 'assets/images/searching-removebg-preview.png'
                                          : 'assets/images/no_content_removebg_preview.png'),
                                    ),
                                  ),
                                ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: isSearch
                                        ? ListView.builder(
                                            itemCount: searchSessionList.length,
                                            itemBuilder: (context, index) =>
                                                StudyGroupCard(
                                                    searchSessionList[index]))
                                        : _buildCardList()),
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

  void filterSearchResults(String query, List ls) {
    setState(() {
      for (int item = 0; item < ls.length; item++) {
        if (ls[item].name!.toLowerCase().contains(query.toLowerCase().trim())) {
          searchSessionList.add(ls[item]);
        }
      }
    });
  }
}

Widget _buildCardList() {
  return StreamBuilder(
    stream: FirebaseAPI.databaseReference('create-group'),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Text('حدث خطأ اثناء تحميل البيانات');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        if (studyGroupItems.isEmpty) {
          return Shimmer.fromColors(
            baseColor: CustomColors.white,
            highlightColor: CustomColors.highlightColor,
            enabled: true,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: 1,
              itemBuilder: (context, index) {
                return StudyGroupCard(StudyGroupModel(
                  time: '',
                  id: '',
                  name: ' ',
                  date: '',
                  location: '',
                  numPerson: '',
                ));
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
              itemCount: studyGroupItems.length,
              itemBuilder: (context, index) {
                return StudyGroupCard(studyGroupItems[index]);
              },
            ),
          );
        }
      }

      final data = snapshot.data?.snapshot.value;
      if (data == null || data == 'placeholder') {
        return Center(
          child: SizedBox(
            height: 200,
            child: Image.asset('assets/images/no_content_removebg_preview.png'),
          ),
        );
      }
      Map<dynamic, dynamic> data2 = data as Map<dynamic, dynamic>;

      final List<StudyGroupModel> reports = data2.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;
        return StudyGroupModel(
          id: key,
          name: value['name'],
          date: value['date'],
          time: value['time'],
          location: value['location'],
          numPerson: value['NumPerson'],
        );
      }).toList();
      studyGroupItems.clear();
      studyGroupItems = reports;
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 10),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return StudyGroupCard(report);
        },
      );
    },
  );
}
