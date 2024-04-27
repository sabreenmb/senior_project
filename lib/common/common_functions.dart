import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/common/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/dynamic_item_model.dart';
import 'constant.dart';
import '../view/Chat_Pages/current_chats.dart';
import '../view/home_screen.dart';
import '../view/profile_screen.dart';
import 'package:senior_project/view/save_list_screen.dart';
import '../view/services_screen.dart';

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
          onTap: (int newIndex) {
            if (newIndex == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            } else if (newIndex == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ServicesScreen()));
            } else if (newIndex == 3) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const CurrentChats()));
            } else if (newIndex == 4) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SaveListScreen()));
            }
          },
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
          onTap: (int newIndex) {
            if (newIndex == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            } else if (newIndex == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ServicesScreen()));
            } else if (newIndex == 2) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const CurrentChats()));
            } else if (newIndex == 3) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SaveListScreen()));
            }
          },
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

Widget loadingFunction(BuildContext context, bool load) {
  return Center(
    child: Container(
      height: 200,
      width: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CustomColors.white,
      ),
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 70,
            width: 70,
            child: CircularProgressIndicator(
              backgroundColor: CustomColors.lightGrey,
              color: CustomColors.lightBlue,
              strokeWidth: 6,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(load ? 'جاري التحميل..' : 'جاري التحقق..',
              style: TextStyles.heading3B, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

Future<void> network() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  isOffline = (connectivityResult[0] == ConnectivityResult.none);
}

bool getValidity(String time) {
  DateTime expiryDate = DateTime.parse(time);
  DateTime now = DateTime.now();

  if (expiryDate.difference(now).inDays == 0) {
    return true;
  } else {
    return false;
  }
}

bool getValidityF(String time) {
  DateTime expiryDate = DateTime.parse(time);
  DateTime now = DateTime.now();

  if (expiryDate.difference(now).inDays >= 0) {
    return true;
  } else {
    return false;
  }
}

void sortItemsByTimestamp(List<dynamic> combined) {
  combined.sort((a, b) {
    DateTime timestampA = DateTime.parse(a.item.timestamp);
    DateTime timestampB = DateTime.parse(b.item.timestamp);
    return timestampB.compareTo(timestampA); // Sort in descending order
  });
}

void homeCards() async {
  combinedList = [];

  for (var item in workshopItems) {
    combinedList.add(DynamicItemModel(
        serviceName: 'workshops', item: item, icon: services[4]['icon']));
  }

  for (var item in confItems) {
    combinedList.add(DynamicItemModel(
        serviceName: 'conferences', item: item, icon: services[4]['icon']));
  }

  for (var item in otherItems) {
    combinedList.add(DynamicItemModel(
        serviceName: 'otherEvents', item: item, icon: services[4]['icon']));
  }

  for (var item in courseItems) {
    combinedList.add(DynamicItemModel(
        serviceName: 'courses', item: item, icon: services[4]['icon']));
  }
  for (var item in volOpItems) {
    combinedList.add(DynamicItemModel(
        serviceName: 'volunteerOp', item: item, icon: services[1]['icon']));
  }
  sortItemsByTimestamp(combinedList);
}

void getTodayList() {
  todayList = [];
//data list may changed to a copy list

  for (int i = 0; i < combinedList.length; i++) {
    if (getValidity(combinedList[i].item.date) == true) {
      todayList.add(combinedList[i]);
    }
  }
}

void goToProfilePage(BuildContext context) {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ProfileScreen(),
    ),
  );
}

void showNetWidgetDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(12, 30, 12, 12),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'حدث خطأ أثناء الاتصال بالإنترنت',
                    style: TextStyles.heading1D,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'يرجى التحقق من الاتصال بالإنترنت ثم معاودة المحاولة',
                  textAlign: TextAlign.center,
                  style: TextStyles.text1D,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();

// Add your logic here
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      backgroundColor: CustomColors.lightBlue,
                      side: const BorderSide(color: CustomColors.lightBlue, width: 1),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      'حسناً',
                      style: TextStyle(color: CustomColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future<void> launchURL(String? urlString, BuildContext context) async {
  if (urlString == null || urlString.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('The URL is not available.')),
    );
    return;
  }
  final Uri url = Uri.parse(urlString);

  if (!await launchUrl(url)) {
    if(!context.mounted){
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $urlString')),
    );
  }
}

