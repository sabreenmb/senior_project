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
import 'ChatScreen.dart';
import 'HomeScreen.dart';
import 'SaveListScreen.dart';

class StudentClubsScreen extends StatefulWidget  {
  const StudentClubsScreen({super.key});

  @override
  State<StudentClubsScreen> createState() => _StudentClubsState();
}

class _StudentClubsState extends State<StudentClubsScreen>     with SingleTickerProviderStateMixin {

   List<SClubInfo> _SClubs = [];
   late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _LoadSClubs();
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


   void _LoadSClubs() async {
     List<SClubInfo> loadedClubsInfo = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'studentClubsDB.json');
      final response = await http.get(url);

      final Map<String, dynamic> clubdata = json.decode(response.body);
      for (final item in clubdata.entries) {
        print(item.value['club_name']);
        loadedClubsInfo.add(SClubInfo(
          id: item.key,
          //model name : firebase name
          timestamp:item.value['timestamp'],

          name: item.value['club_name'],
          logo: item.value['club_logo'],
          details: item.value['club_details'],
          contact: item.value['club_contact'],
          regTime: item.value['club_regTime'],
          leader: item.value['club_leader'],
          membersLink: item.value['clubMB_link'],
          MngLink: item.value['clubMG_link'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      _SClubs = loadedClubsInfo; // fetched data from Firebase

      setState(() {
        isLoading = false;
      });
    }
  }

  // ignore: unused_field
  int _selectedPageIndex = 1;
  void _selectPage(int index) {
    index = 1;
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
      } else if (index == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      } else if (index == 3) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SaveListScreen()));
      }
      _selectedPageIndex = index;
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }


   Widget _buildSClubsList() {

     return  GridView(
       physics: const BouncingScrollPhysics(),
         children: _SClubs.map<Widget>((doc) => ClubsCard(doc))
         .toList(),

         gridDelegate:
         const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2,
             mainAxisSpacing: 20.0,
             crossAxisSpacing: 10.0,
             childAspectRatio: 1.1),);


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
        centerTitle: false,
        iconTheme: const IconThemeData(color: CustomColors.darkGrey),
        // Drawer: SideDrawer(onProfileTap: goToProfilePage, )
      ),
      endDrawer: SideDrawer(
        onProfileTap: goToProfilePage,
      ),
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
              currentIndex: 1,
              items: const [
                BottomNavigationBarItem(
                  label: 'الرئيسية',
                  icon: Icon(Icons.home_outlined),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: 'الخدمات'),
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
