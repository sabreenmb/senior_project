import 'package:flutter/material.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/create_student_activity.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/model/create_student_activity_report.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/commonWidgets.dart';
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
                                    : _buildCardList()
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

  Widget _buildCardList() {
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
