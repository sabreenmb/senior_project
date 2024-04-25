import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/widgets/side_menu.dart';
import '../common/constant.dart';
import '../common/theme.dart';
import '../widgets/student_clubs_card.dart';
import '../common/common_functions.dart';

class StudentClubsScreen extends StatefulWidget {
  const StudentClubsScreen({super.key});

  @override
  State<StudentClubsScreen> createState() => _StudentClubsState();
}

class _StudentClubsState extends State<StudentClubsScreen>
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
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("النوادي الطلابية", style: TextStyles.pageTitle),
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
                        builder: (context) => const ServicesScreen()));},
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
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: _buildSClubsList(),),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSClubsList() {
    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.1),
      children: sClubsItems.map<Widget>((doc) => StudentClubCard(doc)).toList(),
    );
  }
}
