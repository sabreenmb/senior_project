import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/Chat_Pages/current_chats.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/interface/lost_and_found_screen.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/home_card.dart';
import 'package:senior_project/widgets/side_menu.dart';

class SaveListScreen extends StatefulWidget {
  const SaveListScreen({super.key});

  @override
  State<SaveListScreen> createState() => _SaveListScreenState();
}

class _SaveListScreenState extends State<SaveListScreen> {
  int _selectedPageIndex = 3;

  @override
  void _selectPage(int index) {
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
      } else if (index == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const CurrentChats()));
      } else if (index == 3) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SaveListScreen()));
        _selectedPageIndex = index;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("قائمة المحفوظات", style: TextStyles.heading1),
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
              selectedItemColor: CustomColors.lightBlue,
              currentIndex: 3,
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
                    const SizedBox(height: 15),
                    Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        // color: const Color.fromARGB(255, 187, 55, 55),
                      ),
                      // margin: const EdgeInsets.only(bottom: 10),

                      // child: ElevatedButton(
                      //   onPressed: addTofire(),
                      //   child: Text("test"),
                      // )
                      child: InkWell(
                        child: _buildItems(),
                      ),
                    )

                    // _buildHorizontalScrollableCards(combinedList),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildItems() {
    print('kiss');
    print(courseItem.length);
    return Container(
      height: 240,
      child: ListView.builder(
        // scrollDirection: Axis.,
          itemCount: saveList.length,
          itemBuilder: (context, index) => _buildTextCard(
              saveList[index].serviceName, saveList[index].item)),
    );
  }

  Widget _buildTextCard(String title, dynamic item) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: CustomColors.lightBlue, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          print('Card tapped');
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.pink)),
              SizedBox(height: 10),
              Text(item.name!,
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.darkGrey,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
