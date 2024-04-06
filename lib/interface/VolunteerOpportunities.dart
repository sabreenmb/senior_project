import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/ChatScreen.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/interface/SaveListScreen.dart';
import 'package:senior_project/interface/add_lost_item_screen.dart';
//import 'package:senior_project/interface/create_group.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/model/volunteer_op_report.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/op_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:shimmer/shimmer.dart';

import '../firebaseConnection.dart';
import '../widgets/commonWidgets.dart';

class VolunteerOp extends StatefulWidget {
  const VolunteerOp({super.key});

  @override
  State<VolunteerOp> createState() => _VolunteerOpState();
}

class _VolunteerOpState extends State<VolunteerOp>
    with SingleTickerProviderStateMixin {
  late List<Map<String, Object>> _pages;
  //search
  ////List<VolunteerOpReport> searchSessionList = [];

  // List<VolunteerOpReport> _volunteerOpReport = [];
  //create button
  // void _LoadCreatedSessions() async {
  //   final List<VolunteerOpReport> loadedVolunteerOp = [];
  //
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
  //         'opportunities.json');
  //     final response = await http.get(url);
  //
  //     final Map<String, dynamic> volunteerdata = json.decode(response.body);
  //     for (final item in volunteerdata.entries) {
  //       loadedVolunteerOp.add(VolunteerOpReport(
  //         id: item.key,
  //         //model name : firebase name
  //         name: item.value['op_name'],
  //         date: item.value['op_date'],
  //         time: item.value['op_time'],
  //         location: item.value['op_location'],
  //         opNumber: item.value['op_number'],
  //         opLink: item.value['op_link'],
  //         timestamp:item.value['timestamp'],
  //
  //       ));
  //     }
  //   } catch (error) {
  //     print('Empty List');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //       print("sabreeeen: $loadedVolunteerOp");
  //       _volunteerOpReport = loadedVolunteerOp;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();

    //  _LoadCreatedSessions();
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
          title: Text("الفرص التطوعية", style: TextStyles.heading1),
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
                        if (volunteerOpReport.isNotEmpty)
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: _buildcardList()
                            ),
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

  Widget _buildcardList() {
    return StreamBuilder(
      stream: Connection.databaseReference('opportunities'),
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
              itemCount: volunteerOpReport.length,
              itemBuilder: (context, index) {
                return OpCard(volunteerOpReport[0]);
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
        final List<VolunteerOpReport> reports = data.entries.map((entry) {
          final key = entry.key;
          final value = entry.value;
          return VolunteerOpReport(
            id: key,
            //model name : firebase name
            name: value['op_name'],
            date: value['op_date'],
            time: value['op_time'],
            location: value['op_location'],
            opNumber: value['op_number'],
            opLink: value['op_link'],
            timestamp: value['timestamp'],
          );
        }).toList();
        volunteerOpReport.clear();
        volunteerOpReport = reports;
        // to do store the values
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return OpCard(report);
          },
        );
      },
    );
  }
}
