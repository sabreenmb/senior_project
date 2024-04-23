import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
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
  @override
  void initState() {
    super.initState();
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
                                child: _buildCardsList()),
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

  Widget _buildCardsList() {
    return StreamBuilder(
      stream: FirebaseAPI.databaseReference('opportunities'),
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
