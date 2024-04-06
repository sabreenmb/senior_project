import 'package:flutter/material.dart';
import 'package:senior_project/theme.dart';

import '../interface/ChatScreen.dart';
import '../interface/Chat_Pages/current_chats.dart';
import '../interface/HomeScreen.dart';
import '../interface/ProfilePage.dart';
import '../interface/SaveListScreen.dart';
import '../interface/services_screen.dart';

Widget buildBottomBarWF(BuildContext context, int index) {
  return BottomAppBar(
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
          onTap: (int newIndex) => _selectPage2(newIndex, context),
          unselectedItemColor: CustomColors.darkGrey,
          selectedItemColor: CustomColors.lightBlue,
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              label: 'الرئيسية',
              icon: Icon(Icons.home_outlined),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'الخدمات'),
            BottomNavigationBarItem(
              label: "",
              activeIcon: null,
              icon: Icon(null),
            ),
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
  );
}

Widget buildBottomBar(BuildContext context, int index,bool isService) {
  return BottomAppBar(
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
          showSelectedLabels:isService?false:true,
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          onTap: (int newIndex) => _selectPage(newIndex, context),
          unselectedItemColor: CustomColors.darkGrey,
          selectedItemColor: isService?CustomColors.darkGrey:CustomColors.lightBlue,
          currentIndex: index,
          items:  [
            BottomNavigationBarItem(
              label: 'الرئيسية',
              icon: Icon(Icons.home_outlined),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label:'الخدمات',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.messenger_outline,
              ),
              label: 'الدردشة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'المحفوظات',
            ),
          ],
        ),
      ),
    ),
  );
}

void _selectPage(int index, BuildContext context) {
  // if (index == 1) {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
  //   _selectedPageIndex = index;
  // }
  //todo uncomment on next sprints
  if (index == 0) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));
  } else if (index == 1) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ServisesScreen()));
  } else if (index == 2) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => CurrentChats()));
  } else if (index == 3) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SaveListScreen()));
  }
}

void _selectPage2(int index, BuildContext context) {
  //todo uncomment on next sprints
  if (index == 0) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));
  } else if (index == 1) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ServisesScreen()));
  } else if (index == 3) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => CurrentChats()));
  } else if (index == 4) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SaveListScreen()));
  }
}

void goToProfilePage(BuildContext context) {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ProfilePage(),
    ),
  );
}
