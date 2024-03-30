import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/push_notification.dart';
import 'package:senior_project/theme.dart';
import 'package:http/http.dart' as http;

import 'model/conference_item_report.dart';
import 'model/courses_item_report.dart';
import 'model/offer_info.dart';
import 'model/other_event_item_report.dart';
import 'model/volunteer_op_report.dart';
import 'model/workshop_item_report.dart';

int currentPageIndex = 0;
NavigationDestinationLabelBehavior labelBehavior =
    NavigationDestinationLabelBehavior.alwaysHide;
bool isLoading = false;

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

DocumentReference<Map<String, dynamic>> userProfileDoc = FirebaseFirestore
    .instance
    .collection("userProfile")
    .doc(FirebaseAuth.instance.currentUser!.email!.split("@")[0]);

enteredUserInfo userInfo = enteredUserInfo(
  image_url: '',
  userID: '',
  rule: '',
  name: '',
  collage: '',
  major: '',
  intrests: '',
  hobbies: '',
  skills: '',
  pushToken: '',
);

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
final List clubs = [
  {
    "ClubName": "نادي الذكاء الاصطناعي",
    "icon": "assets/icons/Ailogo_2.png",
  },
  {
    "ClubName": "نادي الذكاء الاصطناعي",
    "icon": "assets/icons/Ailogo_2.png",
  },
  {
    "ClubName": "نادي الذكاء الاصطناعي",
    "icon": "assets/icons/Ailogo_2.png",
  },
  {
    "ClubName": "نادي الذكاء الاصطناعي",
    "icon": "assets/icons/Ailogo_2.png",
  }
];
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

void LoadOffers() async {
  final List<OfferInfo> loadedOfferInfo = [];

  try {
    final url = Uri.https(
        'senior-project-72daf-default-rtdb.firebaseio.com', 'offersdb.json');
    final response = await http.get(url);

    final Map<String, dynamic> founddata = json.decode(response.body);
    for (final item in founddata.entries) {
      print(item.value['of_name']);
      loadedOfferInfo.add(OfferInfo(
        id: item.key,
        //model name : firebase name
        name: item.value['of_name'],
        logo: item.value['of_logo'],
        category: item.value['of_category'],
        code: item.value['of_code'],
        details: item.value['of_details'],
        discount: item.value['of_discount'],
        expDate: item.value['of_expDate'],
        contact: item.value['of_contact'],
        targetUsers: item.value['of_target'],
      ));
    }
  } catch (error) {
    print('Empty List');
  } finally {
    List<OfferInfo> fetchedOffers =
        loadedOfferInfo; // fetched data from Firebase

    for (OfferInfo offer in fetchedOffers) {
      for (Map<String, dynamic> item in offers) {
        if (offer.category == item['offerCategory']) {
          item['categoryList'].add(offer);
          break;
        }
      }
    }
    print(offers[0]);
  }
}
List<WorkshopsItemReport> workshopItem = [];
List<ConferencesItemReport> confItem = [];
List<OtherEventsItemReport> otherItem = [];
List<CoursesItemReport> courseItem = [];

void loadCoursesItems() async {
  final url = Uri.https(
    'senior-project-72daf-default-rtdb.firebaseio.com',
    'eventsCoursesDB.json',
  );
  final response = await http.get(url);

  final Map<String, dynamic> data = json.decode(response.body);
  for (final item in data.entries) {
    print(item.value['course_name']);

    courseItem.add( CoursesItemReport(
      id: item.key,
      name: item.value['course_name'],
      presentBy: item.value['course_presenter'],
      date: item.value['course_date'],
      time: item.value['course_time'],
      location: item.value['course_location'],
      courseLink: item.value['course_link'],
    ));
  }

}
void loadWorkshopsItems() async {
  final url = Uri.https(
    'senior-project-72daf-default-rtdb.firebaseio.com',
    'eventsWorkshopsDB.json',
  );
  final response = await http.get(url);

  final Map<String, dynamic> data = json.decode(response.body);
  for (final item in data.entries) {
    workshopItem.add(WorkshopsItemReport(
      id: item.key,
      name: item.value['workshop_name'],
      presentBy: item.value['workshop_presenter'],
      date: item.value['workshop_date'],
      location: item.value['workshop_location'],
      time: item.value['workshop_time'],
      workshopLink: item.value['workshop_link'],
    ));
  }

  
}

void loadConferencesItems() async {
  final url = Uri.https(
    'senior-project-72daf-default-rtdb.firebaseio.com',
    'eventsConferencesDB.json',
  );
  final response = await http.get(url);

  final Map<String, dynamic> data = json.decode(response.body);
  for (final item in data.entries) {
    confItem.add(ConferencesItemReport(
      id: item.key,
      name: item.value['conference_name'],
      date: item.value['conference_date'],
      time: item.value['conference_time'],
      location: item.value['conference_location'],
      confLink: item.value['conference_link'],
    ));
  }

}

void loadOtherEventsItems() async {
  final url = Uri.https(
    'senior-project-72daf-default-rtdb.firebaseio.com',
    'eventsOthersDB.json',
  );
  final response = await http.get(url);

  final Map<String, dynamic> eventData = json.decode(response.body);
  for (final item in eventData.entries) {
    otherItem.add( OtherEventsItemReport(
      id: item.key,
      name: item.value['OEvent_name'],
      presentBy: item.value['OEvent_presenter'],
      date: item.value['OEvent_date'],
      time: item.value['OEvent_time'],
      location: item.value['OEvent_location'],
      otherEventLink: item.value['OEvent_link'],
    ));
  }

}
List<VolunteerOpReport> volunteerOpReport = [];

void LoadCreatedSessions() async {
  final List<VolunteerOpReport> loadedVolunteerOp = [];

  try {

    final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
        'opportunities.json');
    final response = await http.get(url);

    final Map<String, dynamic> volunteerdata = json.decode(response.body);
    for (final item in volunteerdata.entries) {
      print(item.value['op_name']);

      loadedVolunteerOp.add(VolunteerOpReport(
        id: item.key,
        //model name : firebase name
        name: item.value['op_name'],
        date: item.value['op_date'],
        time: item.value['op_time'],
        location: item.value['op_location'],
        opNumber: item.value['op_number'],
        opLink: item.value['op_link'],
      ));
    }
  } catch (error) {
    print('Empty List');
  }
  volunteerOpReport = loadedVolunteerOp;

}
List<EventItem> combinedList = [];

void homeCards()async{
   combinedList = [];

  workshopItem.forEach((item) {
    combinedList.add(EventItem(serviceName: 'Workshops', item: item, icon: services[4]['icon']));
  });

  confItem.forEach((item) {
    combinedList.add(EventItem(serviceName: 'Conferences', item: item ,icon: services[4]['icon']));
    print(combinedList.elementAt(0).serviceName);
  });

  otherItem.forEach((item) {
    combinedList.add(EventItem(serviceName: 'Other Events', item: item, icon: services[4]['icon']));
  });

  courseItem.forEach((item) {
    combinedList.add(EventItem(serviceName: 'Courses', item: item,icon: services[4]['icon']));
  });
  volunteerOpReport.forEach((item) {
    combinedList.add(EventItem(serviceName: 'OP', item: item,icon: services[1]['icon']));
  });
  print(combinedList);

}
class EventItem {
  final String serviceName;
  final dynamic item;
  final String icon;

  EventItem({required this.serviceName, required this.item, required this.icon});
}

