import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/theme.dart';

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

String userID = '';
DocumentReference<Map<String, dynamic>> userProfileDoc = FirebaseFirestore
    .instance
    .collection("userProfile")
    .doc(FirebaseAuth.instance.currentUser!.email!.split("@")[0]);

enteredUserInfo userInfo = enteredUserInfo(
  rule: '',
  name: '',
  collage: '',
  major: '',
  intrests: '',
  hobbies: '',
  skills: '',
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
      padding: EdgeInsets.only(top: 30, bottom: 20),
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
    "categoryList":[],

    //'whenClick': LostAndFoundScreen() ,
    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "تعليم وتدريب",
    "icon": "assets/icons/board.svg",
    "semanticsLabel": "board",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "مطاعم ومقاهي",
    "icon": "assets/icons/resturants.svg",
    "semanticsLabel": "resturants",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "ترفيه",
    "icon": "assets/icons/entertainment.svg",
    "semanticsLabel": "entertainment",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "مراكز صحية",
    "icon": "assets/icons/hospital.svg",
    "semanticsLabel": "hospital",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "عناية وجمال",
    "icon": "assets/icons/beauty.svg",
    "semanticsLabel": "beauty",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "سياحة وفنادق",
    "icon": "assets/icons/travel.svg",
    "semanticsLabel": "travel",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "خدمات السيارات",
    "icon": "assets/icons/carServises.svg",
    "semanticsLabel": "carServises",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "تسوق",
    "icon": "assets/icons/shopcart.svg",
    "semanticsLabel": "shopcart",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
  {
    "offerCategory": "عقارات وبناء",
    "icon": "assets/icons/construction.svg",
    "semanticsLabel": "construction",
    "categoryList":[],

    //"whenClick": LostAndFoundScreen(),
  },
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
