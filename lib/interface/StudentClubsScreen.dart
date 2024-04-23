import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/widgets/side_menu.dart';

import '../constant.dart';
import '../theme.dart';
import '../widgets/clubs_card.dart';
import '../commonWidgets.dart';

class StudentClubsScreen extends StatefulWidget {
  const StudentClubsScreen({super.key});

  @override
  State<StudentClubsScreen> createState() => _StudentClubsState();
}

class _StudentClubsState extends State<StudentClubsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
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

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    connSub.cancel();

    _animationController.dispose();
    super.dispose();
  }

  // ignore: unused_field

  Widget _buildSClubsList() {
    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.1),
      children: SClubs.map<Widget>((doc) => ClubsCard(doc)).toList(),
    );
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
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: _buildSClubsList(),
                        ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
