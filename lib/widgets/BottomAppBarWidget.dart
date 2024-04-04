import 'package:flutter/material.dart';
import 'package:senior_project/theme.dart';

class CommonWidget {




  static Widget buildBottomAppBar(BuildContext context, int index) {
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
            onTap: (int newIndex) => _selectPage(newIndex, context),
            unselectedItemColor: CustomColors.darkGrey,
            selectedItemColor: CustomColors.lightBlue,
            currentIndex: index,
            items: const [
              BottomNavigationBarItem(
                label: 'الرئيسية',
                icon: Icon(Icons.home_outlined),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps),
                label: 'الخدمات',
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

  static void _selectPage(int index, BuildContext context) {
    // just add the number
//     int selectedIndex = 2; // Replace with your desired index
// Widget appBar = CommonWidget.buildBottomAppBar(context, selectedIndex);
  }
}