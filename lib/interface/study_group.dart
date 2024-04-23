import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/create_group.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/model/create_group_report.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/create_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:shimmer/shimmer.dart';

import '../firebaseConnection.dart';
import '../commonWidgets.dart';
import '../networkWedget.dart';

class StudyGroup extends StatefulWidget {
  const StudyGroup({super.key});

  @override
  State<StudyGroup> createState() => _StudyGroupState();
}

class _StudyGroupState extends State<StudyGroup>
    with SingleTickerProviderStateMixin {
  late StreamSubscription connSub;

  //search
  List<CreateGroupReport> searchSessionList = [];
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
          title: Text("جلسة مذاكرة", style: TextStyles.pageTitle),
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
                          builder: (context) => const ServisesScreen()));
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
          splashColor: Colors.grey,
          tooltip: '',
          elevation: 4,
          onPressed: () async {
            if (isOffline) {
              showNetWidgetDialog(context);
            } else {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const CreateGroup()));
            }
          },
          child: const Icon(Icons.add),
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
                          color: CustomColors.backgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                    isOffline
                        ? Center(
                            child: SizedBox(
                              // padding: EdgeInsets.only(bottom: 20),
                              // alignment: Alignment.topCenter,
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
                                          searchSessionList.clear();
                                          filterSearchResults(
                                              _userInputController.text,
                                              createGroupReport);
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
                                    //todo the same value of on icon presed
                                    searchSessionList.clear();
                                    filterSearchResults(
                                        _userInputController.text,
                                        createGroupReport);
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
                                  : createGroupReport.isEmpty))
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
                              if (createGroupReport.isNotEmpty)
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: isSearch
                                          ? ListView.builder(
                                              itemCount:
                                                  searchSessionList.length,
                                              itemBuilder: (context, index) =>
                                                  CreateCard(
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

Widget _buildCardList() {
  return StreamBuilder(
    stream: FirebaseAPI.databaseReference('create-group'),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        // return loadingFunction(context, true);
        return Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.grey[300]!,
          enabled: true,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            itemCount: createGroupReport.length,
            itemBuilder: (context, index) {
              return CreateCard(createGroupReport[0]);
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
      final List<CreateGroupReport> reports = data.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;
        return CreateGroupReport(
          id: key,
          //model name : firebase name
          name: value['name'],
          date: value['date'],
          time: value['time'],
          location: value['location'],
          numPerson: value['NumPerson'],
        );
      }).toList();
      createGroupReport.clear();
      createGroupReport = reports;
      // to do store the values
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 10),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return CreateCard(report);
        },
      );
    },
  );
}
