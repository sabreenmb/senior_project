import 'package:flutter/material.dart';
import 'package:senior_project/interface/LostAndFoundScreen.dart';

int currentPageIndex = 0;
NavigationDestinationLabelBehavior labelBehavior =
    NavigationDestinationLabelBehavior.alwaysHide;
enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

// final List pages = [
//   {
//     LostAndFoundScreen(),
//     LostAndFoundScreen(),
//     LostAndFoundScreen(),
//     LostAndFoundScreen(),
//     LostAndFoundScreen(),
//     LostAndFoundScreen(),
//     LostAndFoundScreen(),
//     LostAndFoundScreen(),
//     LostAndFoundScreen(),
//   }
// ];
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
