import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:senior_project/model/user_information_model.dart';
import 'package:senior_project/common/push_notification.dart';
import 'firebase_api.dart';
import '../model/dynamic_item_model.dart';
import '../model/student_club_model.dart';
import '../model/clinic_model.dart';
import '../model/conference_model.dart';
import '../model/courses_model.dart';
import '../model/student_group_model.dart';
import '../model/student_activity_model.dart';
import '../model/found_item_model.dart';
import '../model/lost_item_model.dart';
import '../model/other_events_model.dart';
import '../model/psych_guidance_model.dart';
import '../model/vol_op_model.dart';
import '../model/workshop_model.dart';

//Common use variables
bool isLoading = false;
bool isOffline = false;
var connectivityResult = (Connectivity().checkConnectivity());

PushNotification notificationServices = PushNotification();
UserInformationModel userInfo = UserInformationModel();
PsychGuidanceModel pg = PsychGuidanceModel();
DocumentReference<Map<String, dynamic>> userProfileDoc =
    FirebaseAPI.currentUserInfo();

//Lists use through all app
List<UserInformationModel> allUsers = [];
List<dynamic> recommendedOffers = [];
List<LostItemModel> lostItems = [];
List<FoundItemModel> foundItems = [];
List<WorkshopModel> workshopItems = [];
List<ConferencesModel> confItems = [];
List<OtherEventsModel> otherItems = [];
List<CoursesModel> courseItems = [];
List<VolOpModel> volOpItems = [];
List<SClubModel> sClubsItems = [];
List<DynamicItemModel> saveList = [];
List<StudentActivityModel> sActivitiesItems = [];
List<StudentGroupModel> studyGroupItems = [];
List<ClinicModel> clinicItems = [];
List<DynamicItemModel> combinedList = [];
List<DynamicItemModel> todayList = [];

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
