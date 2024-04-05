import 'package:flutter/material.dart';
import 'package:senior_project/interface/Chat_Pages/current_chats.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/push_notification.dart';
import 'package:senior_project/widgets/side_menu.dart';

import '../constant.dart';
import '../theme.dart';
import '../widgets/grid_card.dart';
import 'HomeScreen.dart';
import 'SaveListScreen.dart';

class ServisesScreen extends StatefulWidget {
  const ServisesScreen({super.key});

  @override
  State<ServisesScreen> createState() => _ServisesState();
}

class _ServisesState extends State<ServisesScreen> {
  // ignore: unused_field
  int _selectedPageIndex = 1;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    //Move it to approprite place (home screen maybe)
    // notificationServices.getFirebaseMessagingToken();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();

    // notificationServices.getDeviceToken().then((value) {
    //   if (kDebugMode) {
    //     print('device token');
    //     print(value);
    //   }
    // });
  }

  void _selectPage(int index) {
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (index == 1) {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (_) => ServisesScreen()));
      } else if (index == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const CurrentChats()));
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

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("الخدمات", style: TextStyles.heading1),
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
                  Container(
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
                        itemBuilder: (context, i) => GridCard(
                              services[i],
                              i,
                              true,
                            )),
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
