import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/constant.dart';
//import 'package:senior_project/interface/create_group.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/model/volunteer_op_report.dart';
import 'package:senior_project/common/theme.dart';
import 'package:senior_project/widgets/op_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:shimmer/shimmer.dart';

import '../common/firebase_api.dart';
import '../common/common_functions.dart';

class VolunteerOp extends StatefulWidget {
  const VolunteerOp({super.key});

  @override
  State<VolunteerOp> createState() => _VolunteerOpState();
}

class _VolunteerOpState extends State<VolunteerOp>
    with SingleTickerProviderStateMixin {
  late StreamSubscription connSub;
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
          title: Text("الفرص التطوعية", style: TextStyles.pageTitle),
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
                                height: 5,
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                              ),
                              (volOpItems.isNotEmpty)
                                  ? Expanded(
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: _buildCardsList()),
                                    ))
                                  : Expanded(
                                      child: Center(
                                        child: SizedBox(
                                          height: 200,
                                          child: Image.asset(
                                              'assets/images/no_content_removebg_preview.png'),
                                        ),
                                      ),
                                    ),
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
          if (volOpItems.isEmpty) {
            return Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey[300]!,
              enabled: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return OpCard(VolunteerOpReport(
                    time: '',
                    id: '',
                    name: ' ',
                    date: '',
                    location: '',
                    opLink: ' ',
                    opNumber: ' ',
                    timestamp: ' ',
                  ));
                },
              ),
            );
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey[300]!,
              enabled: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: volOpItems.length,
                itemBuilder: (context, index) {
                  return OpCard(volOpItems[index]);
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
              child:
                  Image.asset('assets/images/no_content_removebg_preview.png'),
            ),
          );
        }

        Map<dynamic, dynamic> data2 = data as Map<dynamic, dynamic>;

// todo make sure it works
        final List<VolunteerOpReport> reports = data2.entries.map((entry) {
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
        volOpItems.clear();
        volOpItems = reports;
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
