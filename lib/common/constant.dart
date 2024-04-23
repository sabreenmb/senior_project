import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/common/push_notification.dart';
import 'firebase_api.dart';
import '../model/EventItem.dart';
import '../model/SClubInfo.dart';
import '../model/clinic_report.dart';
import '../model/conference_item_report.dart';
import '../model/courses_item_report.dart';
import '../model/create_group_report.dart';
import '../model/create_student_activity_report.dart';
import '../model/found_item_report.dart';
import '../model/lost_item_report.dart';
import '../model/other_event_item_report.dart';
import '../model/psych_guidance_report.dart';
import '../model/volunteer_op_report.dart';
import '../model/workshop_item_report.dart';

//Common use variables
bool isLoading = false;
bool isOffline = false;
var connectivityResult = (Connectivity().checkConnectivity());

PushNotification notificationServices = PushNotification();
UserInformation userInfo = UserInformation();
PsychGuidanceReport pg = PsychGuidanceReport();
DocumentReference<Map<String, dynamic>> userProfileDoc =
    FirebaseAPI.currentUserInfo();

//Lists use through all app
List<UserInformation> allUsers = [];
List<dynamic> recommendedOffers = [];
List<LostItemReport> lostItems = [];
List<FoundItemReport> foundItems = [];
List<WorkshopsItemReport> workshopItems = [];
List<ConferencesItemReport> confItems = [];
List<OtherEventsItemReport> otherItems = [];
List<CoursesItemReport> courseItems = [];
List<VolunteerOpReport> volOpItems = [];
List<SClubInfo> sClubsItems = [];
List<EventItem> saveList = [];
List<CreateStudentActivityReport> sActivitiesItems = [];
List<CreateGroupReport> studyGroupItems = [];
List<ClinicReport> clinicItems = [];
List<EventItem> combinedList = [];
List<EventItem> todayList = [];

final List offers = [
  {
    "offerCategory": "رياضة",
    "icon": "assets/icons/Fitness.svg",
    "semanticsLabel": "Fitness",
    "categoryList": [],
  },
  {
    "offerCategory": "تعليم وتدريب",
    "icon": "assets/icons/board.svg",
    "semanticsLabel": "board",
    "categoryList": [],
  },
  {
    "offerCategory": "مطاعم ومقاهي",
    "icon": "assets/icons/resturants.svg",
    "semanticsLabel": "resturants",
    "categoryList": [],
  },
  {
    "offerCategory": "ترفيه",
    "icon": "assets/icons/entertainment.svg",
    "semanticsLabel": "entertainment",
    "categoryList": [],
  },
  {
    "offerCategory": "مراكز صحية",
    "icon": "assets/icons/hospital.svg",
    "semanticsLabel": "hospital",
    "categoryList": [],
  },
  {
    "offerCategory": "عناية وجمال",
    "icon": "assets/icons/beauty.svg",
    "semanticsLabel": "beauty",
    "categoryList": [],
  },
  {
    "offerCategory": "سياحة وفنادق",
    "icon": "assets/icons/travel.svg",
    "semanticsLabel": "travel",
    "categoryList": [],
  },
  {
    "offerCategory": "خدمات السيارات",
    "icon": "assets/icons/carServises.svg",
    "semanticsLabel": "carServises",
    "categoryList": [],
  },
  {
    "offerCategory": "تسوق",
    "icon": "assets/icons/shopcart.svg",
    "semanticsLabel": "shopcart",
    "categoryList": [],
  },
  {
    "offerCategory": "عقارات وبناء",
    "icon": "assets/icons/construction.svg",
    "semanticsLabel": "construction",
    "categoryList": [],
  },
];
final List services = [
  {
    "serviceName": "المفقودات",
    "icon": "assets/icons/lost-items.svg",
    "semanticsLabel": "lost items-icon",
  },
  {
    "serviceName": "الفرص التطوعية",
    "icon": "assets/icons/volunteering-opportunity.svg",
    "semanticsLabel": "volunteering opportunity-icon",
  },
  {
    "serviceName": "العروض",
    "icon": "assets/icons/offers.svg",
    "semanticsLabel": "offers-icon",
  },
  {
    "serviceName": "النوادي الطلابية",
    "icon": "assets/icons/students-clubs.svg",
    "semanticsLabel": "students clubs-icon",
  },
  {
    "serviceName": "الفعاليات",
    "icon": "assets/icons/events.svg",
    "semanticsLabel": "events-icon",
  },
  {
    "serviceName": "جلسة مذاكرة",
    "icon": "assets/icons/study.svg",
    "semanticsLabel": "study-icon",
  },
  {
    "serviceName": "الأنشطة الطلابية",
    "icon": "assets/icons/activities.svg",
    "semanticsLabel": "activities-icon",
  },
  {
    "serviceName": "العيادات",
    "icon": "assets/icons/clinic.svg",
    "semanticsLabel": "clinic-icon",
  },
  {
    "serviceName": "الإرشاد النفسي",
    "icon": "assets/icons/psychological-guidance.svg",
    "semanticsLabel": "psychological guidance.svg-icon",
  },
];
