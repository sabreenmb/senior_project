import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/push_notification.dart';
import 'package:senior_project/theme.dart';
import 'package:shimmer/shimmer.dart';

import 'firebaseConnection.dart';
import 'model/EventItem.dart';
import 'model/SClubInfo.dart';
import 'model/conference_item_report.dart';
import 'model/courses_item_report.dart';
import 'model/create_student_activity_report.dart';
import 'model/found_item_report.dart';
import 'model/lost_item_report.dart';
import 'model/other_event_item_report.dart';
import 'model/volunteer_op_report.dart';
import 'model/workshop_item_report.dart';
//todo move to coommen var

int currentPageIndex = 0;

// where it is used

NavigationDestinationLabelBehavior labelBehavior =
    NavigationDestinationLabelBehavior.alwaysHide;
//todo move to coommen var

bool isLoading = false;
//todo move to coommen var
List<String> Categories = [
  'بطاقات',
  'نقود ',
  'مستندات',
  'مجوهرات',
  'ملابس',
  'إلكترونيات',
  'أغراض شخصية',
  'اخرى'
];

PushNotification notificationServices = PushNotification();
//todo sabreen changes
DocumentReference<Map<String, dynamic>> userProfileDoc = Connection.Users();
//todo move to coommen var
enteredUserInfo userInfo = enteredUserInfo();

//todo change the list info
List<String> SubjectsCode = [
  'ESPE-201',
  'CCCY-225',
  'SCBZ-447',
  'CCSW-438',
  'CMCR-212',
  'CCCS-214',
  'CCCN-212',
  'اخرى'
];
Widget loadingCards(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    enabled: true,
    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          width: 400,
        );
      },
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
          Text(load ? '..جاري التحميل' : '..جاري التحقق',
              style: TextStyles.heading3B, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
//todo move to coommen var

final List offers = [
  {
    "offerCategory": "رياضة",
    "icon": "assets/icons/Fitness.svg",
    "semanticsLabel": "Fitness",
    "categoryList": [],

    //'whenClick': LostAndFoundScreen() ,
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "تعليم وتدريب",
    "icon": "assets/icons/board.svg",
    "semanticsLabel": "board",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "مطاعم ومقاهي",
    "icon": "assets/icons/resturants.svg",
    "semanticsLabel": "resturants",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "ترفيه",
    "icon": "assets/icons/entertainment.svg",
    "semanticsLabel": "entertainment",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "مراكز صحية",
    "icon": "assets/icons/hospital.svg",
    "semanticsLabel": "hospital",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "عناية وجمال",
    "icon": "assets/icons/beauty.svg",
    "semanticsLabel": "beauty",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "سياحة وفنادق",
    "icon": "assets/icons/travel.svg",
    "semanticsLabel": "travel",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "خدمات السيارات",
    "icon": "assets/icons/carServises.svg",
    "semanticsLabel": "carServises",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "تسوق",
    "icon": "assets/icons/shopcart.svg",
    "semanticsLabel": "shopcart",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "عقارات وبناء",
    "icon": "assets/icons/construction.svg",
    "semanticsLabel": "construction",
    "categoryList": [],

    //"whenClick": LostAndFoundScreen(),
  },
];
//todo move to coommen var

final List services = [
  {
    "serviceName": "المفقودات",
    "icon": "assets/icons/lost-items.svg",
    "semanticsLabel": "lost items-icon",
    //'whenClick': LostAndFoundScreen() ,
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "serviceName": "الفرص التطوعية",
    "icon": "assets/icons/volunteering-opportunity.svg",
    "semanticsLabel": "volunteering opportunity-icon",
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "serviceName": "العروض",
    "icon": "assets/icons/offers.svg",
    "semanticsLabel": "offers-icon",
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "serviceName": "النوادي الطلابية",
    "icon": "assets/icons/students-clubs.svg",
    "semanticsLabel": "students clubs-icon",
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "serviceName": "الفعاليات",
    "icon": "assets/icons/events.svg",
    "semanticsLabel": "events-icon",
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "serviceName": "جلسة مذاكرة",
    "icon": "assets/icons/study.svg",
    "semanticsLabel": "study-icon",
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "serviceName": "الأنشطة الطلابية",
    "icon": "assets/icons/activities.svg",
    "semanticsLabel": "activities-icon",
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "serviceName": "العيادات",
    "icon": "assets/icons/clinic.svg",
    "semanticsLabel": "clinic-icon",
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "serviceName": "الإرشاد النفسي",
    "icon": "assets/icons/psychological-guidance.svg",
    "semanticsLabel": "psychological guidance.svg-icon",
    //"whenClick": LostAndFoundScreen(),
  },
];
//todo move to coommen var
List<LostItemReport> lostItemReport = [];
List<FoundItemReport> foundItemReport = [];
List<WorkshopsItemReport> workshopItem = [];
List<ConferencesItemReport> confItem = [];
List<OtherEventsItemReport> otherItem = [];
List<CoursesItemReport> courseItem = [];
List<VolunteerOpReport> volunteerOpReport = [];
List<EventItem> combinedList = [];
List<EventItem> todayList = [];
List<SClubInfo> SClubs = [];
List<EventItem> saveList = [];
List<CreateStudentActivityReport> createStudentActivityReport = [];

void homeCards() async {
  combinedList = [];

  workshopItem.forEach((item) {
    combinedList.add(EventItem(
        serviceName: 'workshops', item: item, icon: services[4]['icon']));
  });

  confItem.forEach((item) {
    combinedList.add(EventItem(
        serviceName: 'conferences', item: item, icon: services[4]['icon']));
    print(combinedList.elementAt(0).serviceName);
  });

  otherItem.forEach((item) {
    combinedList.add(EventItem(
        serviceName: 'otherEvents', item: item, icon: services[4]['icon']));
  });

  courseItem.forEach((item) {
    combinedList.add(EventItem(
        serviceName: 'courses', item: item, icon: services[4]['icon']));
  });
  volunteerOpReport.forEach((item) {
    combinedList.add(EventItem(
        serviceName: 'volunteerOp', item: item, icon: services[1]['icon']));
  });
  print(combinedList);
  sortItemsByTimestamp(combinedList);
}

void getTodayList() {
  todayList = [];
//data list may changed to a copy list

  for (int i = 0; i < combinedList.length; i++) {
    if (getValidity(combinedList[i].item.date) == true) {
      todayList.add(combinedList[i]);
      print('new test');
    }
  }
  print(todayList);
}

//todo remove if not used
// List<dynamic> eleminateOldData(List<dynamic> item) {
//   filteredList = item;
// //data list may changed to a copy list
//
//   for (int i = 0; i < filteredList.length; i++) {
//     // if (getValidityF(filteredList) == true) {
//     //   filteredList.remove(i);
//     //   print('new test');
//     //   i--;
//     // }
//   }
//   return filteredList;
// }
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
