import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import '../model/SClubInfo.dart';
import '../theme.dart';
import '../widgets/clubs_card.dart';
import '../widgets/commonWidgets.dart';
import 'ChatScreen.dart';
import 'HomeScreen.dart';
import 'SaveListScreen.dart';

class StudentClubsScreen extends StatefulWidget  {
  const StudentClubsScreen({super.key});

  @override
  State<StudentClubsScreen> createState() => _StudentClubsState();
}

class _StudentClubsState extends State<StudentClubsScreen>     with SingleTickerProviderStateMixin {

   late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }
   @override
   void dispose() {
     _animationController.dispose();
     super.dispose();
   }



  // ignore: unused_field



   Widget _buildSClubsList() {

     return  GridView(
       physics: const BouncingScrollPhysics(),

         gridDelegate:
         const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2,
             mainAxisSpacing: 20.0,
             crossAxisSpacing: 10.0,
             childAspectRatio: 1.1),
         children: SClubs.map<Widget>((doc) => ClubsCard(doc))
         .toList(),);


   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("النوادي الطلابية", style: TextStyles.heading1),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child:_buildSClubsList(),
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
