import 'package:flutter/material.dart';
import 'package:senior_project/theme.dart';
import '../constant.dart';
import '../interface/Chat_Pages/current_chats.dart';
import '../interface/HomeScreen.dart';
import '../interface/LaunchScreen.dart';
import '../interface/ProfilePage.dart';

import 'package:senior_project/interface/save_list_screen.dart';
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

Widget buildBottomBar(BuildContext context, int index, bool isService,
    {bool isSaved = false}) {
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
          showSelectedLabels: isService ? false : true,
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          onTap: (int newIndex) => _selectPage(newIndex, context),
          unselectedItemColor: CustomColors.darkGrey,
          selectedItemColor:
              isService ? CustomColors.darkGrey : CustomColors.lightBlue,
          currentIndex: index,
          items: [
            const BottomNavigationBarItem(
              label: 'الرئيسية',
              icon: Icon(Icons.home_outlined),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'الخدمات',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.messenger_outline,
              ),
              label: 'الدردشة',
            ),
            BottomNavigationBarItem(
              icon: isSaved
                  ? const Icon(Icons.bookmark)
                  : const Icon(Icons.bookmark_border),
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
  }
}

void _selectPage2(int index, BuildContext context) {
  //todo uncomment on next sprints
  if (index == 0) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  } else if (index == 1) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
  } else if (index == 3) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const CurrentChats()));
  } else if (index == 4) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const SaveListScreen()));
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

 networkPopup(BuildContext context,bool start){

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.fromLTRB(
            12, 30, 12, 12),
        insetPadding:
        const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(30),
        ),
        content: SizedBox(
          width: MediaQuery.of(context)
              .size
              .width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.red,
                      width: 2),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                      8.0),
                  child: Icon(
                    size: 50,
                    weight: 50,
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(
                    vertical:  20),
                child:  Text(
                    'حدث خطأ اثناء الاتصال بالانترنت',
                    style:
                    // TextStyles.heading1
                    TextStyles.heading1D,
                    textAlign:
                    TextAlign.center),),

              Text(
                'يرجى التحقق من الاتصال بالانترنت ثم معاودة المحاولة',
                textAlign: TextAlign.center,
                style: TextStyles.text2,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets
                    .symmetric(
                    horizontal: 6),
                child: ElevatedButton(
                    onPressed: () async {

                      if(start&&isOffline){
                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) => const LaunchScreen()));
                        await network();


                      } else{
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton
                        .styleFrom(
                      minimumSize:
                      const Size(
                          100, 40),
                      backgroundColor:
                      CustomColors
                          .lightBlue,
                      side: BorderSide(
                          color: CustomColors
                              .lightBlue,
                          width: 1),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              20)),
                    ),
                    child: Text(
                     start?'اعادة المحاولة' :' حسناً',
                      style: TextStyle(
                          color:
                          CustomColors
                              .white),
                    )),
                // two buttons: primary (with colored background) and secondary (without colored background)
              )

              // footer of popup msg


            ],
          ),
        ),
      );
    },
  );
}