import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_project/widgets/ServiceCard.dart';

import '../constant.dart';
import '../theme.dart';

class ServisesScreen extends StatefulWidget {
  ServisesScreen({super.key});

  @override
  State<ServisesScreen> createState() => _ServisesState();
}

class _ServisesState extends State<ServisesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("الخدمات", style: TextStyles.heading1),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: CustomColors.lightBlue,
            ),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Icons.apps_rounded, color: CustomColors.lightBlue),
            icon: Icon(Icons.apps),
            label: 'Commute',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Icons.messenger_rounded, color: CustomColors.lightBlue),
            icon: Icon(Icons.messenger_outline_outlined),
            label: 'Saved',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark, color: CustomColors.lightBlue),
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 15),
            Expanded(
                child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: CustomColors.BackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                ),
                Container(
                  // color: const Color.fromRGBO(196, 196, 196, 0.2),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 25.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1.3),
                      itemCount: services.length,
                      itemBuilder: (context, i) => ServiceCard(services[i])),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
