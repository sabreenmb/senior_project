import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/common/firebase_api.dart';
import 'package:senior_project/model/user_information_model.dart';
import 'common_functions.dart';
import 'constant.dart';
import '../model/dynamic_item_model.dart';
import '../model/student_club_model.dart';
import '../model/clinic_model.dart';
import '../model/conference_model.dart';
import '../model/courses_model.dart';
import '../model/student_group_model.dart';
import '../model/student_activity_model.dart';
import '../model/found_item_model.dart';
import '../model/lost_item_model.dart';
import '../model/offer_info_model.dart';
import '../model/other_events_model.dart';
import '../model/psych_guidance_model.dart';
import '../model/vol_op_model.dart';
import '../model/workshop_model.dart';

class Setup {
  Setup();
  Future<void> build() async {
    saveList = [];
    loadCourses();
    loadWorkshops();
    loadConferences();
    loadOtherEvents();
    // loadVolOp();
    await loadOffers();
  }

  Future<void> build2() async {
    loadAllUsers();
    loadSClubs();
    loadSActivities();
    loadStudyGroups();
    loadLostItems();
    loadFoundItems();
    loadClinics();
    loadPsychGuidance();
  }

  Future<void> loadPsychGuidance() async {
    try {
      final response = await http.get(FirebaseAPI.url('Psych-Guidance'));
      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        if (item.value['pg_collage'] == userInfo.collage) {
          pg = PsychGuidanceModel(
            id: item.key,
            proId: item.value['pg_ID'],
            proName: item.value['pg_name'],
            proLocation: item.value['pg_location'],
            collage: item.value['pg_collage'],
            proOfficeNumber: item.value['pg_number'],
            proEmail: item.value['pg_email'],
          );
          break;
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Empty List');
      }
    }
  }

  static Future<void> loadUserData(String enteredID) async {
    userProfileDoc = FirebaseAPI.currentUserInfo();
    DocumentSnapshot snapshot = await userProfileDoc.get();

    if (!snapshot.exists) {
      userProfileDoc.set({
        'image_url': '',
        'userID': enteredID.split("@")[0],
        'rule': 'user',
        'name': 'منار مجيد',
        'collage': 'الحاسبات',
        'major': 'هندسة برمجيات',
        'intrests': '',
        'hobbies': '',
        'skills': '',
        'pushToken': '',
        'offersPreferences': {
          'رياضة': false,
          'تعليم وتدريب': false,
          'مطاعم ومقاهي': false,
          'ترفيه': false,
          'مراكز صحية': false,
          'عناية وجمال': false,
          'سياحة وفنادق': false,
          'خدمات السيارات': false,
          'تسوق': false,
          'عقارات وبناء': false,
        },
      });
      List<dynamic> items = ['INIT'];

      CollectionReference saveItemsCollection =
          userProfileDoc.collection('saveItems');

      saveItemsCollection.doc('conferences').set({
        'items': items,
      });
      saveItemsCollection.doc('workshops').set({
        'items': items,
      });
      saveItemsCollection.doc('cources').set({
        'items': items,
      });
      saveItemsCollection.doc('otherEvents').set({
        'items': items,
      });
      saveItemsCollection.doc('studyGroubs').set({
        'items': items,
      });
      saveItemsCollection.doc('studentActivities').set({
        'items': items,
      });
      saveItemsCollection.doc('volunteerOp').set({
        'items': items,
      });
    }
    final userProfileData =
        await userProfileDoc.get().then((snapshot) => snapshot.data());

    userInfo.imageUrl = userProfileData?['image_url'];
    userInfo.userID = userProfileData?['userID'];
    userInfo.rule = userProfileData?['rule'];
    userInfo.name = userProfileData?['name'];
    userInfo.collage = userProfileData?['collage'];
    userInfo.major = userProfileData?['major'];
    userInfo.intrests = userProfileData?['intrests'];
    userInfo.hobbies = userProfileData?['hobbies'];
    userInfo.skills = userProfileData?['skills'];
    userInfo.pushToken = userProfileData?['pushToken'];

    userInfo.offersPreferences = userProfileData?['offersPreferences'];
    notificationServices.getFirebaseMessagingToken();
    notificationServices.updatePushToken();
  }

  Future<void> loadAllUsers() async {
    allUsers = [];
    List<UserInformationModel> loadedUsers = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('userProfile').get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        UserInformationModel otherUserInfo = UserInformationModel(
          userID: data['userID'],
          rule: data['rule'],
          name: data['name'],
          collage: data['collage'],
          major: data['major'],
          intrests: data['intrests'],
          hobbies: data['hobbies'],
          skills: data['skills'],
          imageUrl: data["image_url"],
          pushToken: data["pushToken"],
          offersPreferences: data['offersPreferences'],
        );
        loadedUsers.add(otherUserInfo);
      }
      allUsers = loadedUsers;
      allUsers.removeWhere((element) => element.userID == userInfo.userID);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading documents');
      }
    }
  }

  Future<void> loadOffers() async {
    for (Map<String, dynamic> item in offers) {
      item['categoryList'].clear();
    }
    final List<OfferInfoModel> loadedOfferInfo = [];

    try {
      final response = await http.get(FirebaseAPI.url('offersdb'));
      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        if (getValidityF(item.value['of_expDate'])) {
          loadedOfferInfo.add(OfferInfoModel(
            id: item.key,
            timestamp: item.value['timestamp'],
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
      }
    } catch (error) {
      if (kDebugMode) {
        print('Empty List');
      }
    } finally {
      int falseNum = 0;
      List<dynamic> tempOffer = [];
      recommendedOffers = [];
      for (OfferInfoModel offer in loadedOfferInfo) {
        for (Map<String, dynamic> item in offers) {
          if (offer.category == item['offerCategory']) {
            item['categoryList'].add(offer);
            break;
          }
        }
      }
      for (Map<String, dynamic> item in offers) {
        if (userInfo.offersPreferences[item['offerCategory']] == true) {
          recommendedOffers.addAll(item['categoryList']);
        } else {
          tempOffer.addAll(item['categoryList']);
          falseNum++;
        }
      }
      if (falseNum > 9 || recommendedOffers.isEmpty) {
        recommendedOffers = tempOffer;
      }
    }
  }

  Future<void> loadCourses() async {
    courseItems = [];
    List<CoursesModel> loadedCourseItems = [];
    final response = await http.get(FirebaseAPI.url('eventsCoursesDB'));
    if (response.body == '"placeholder"') {
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    for (final item in data.entries) {
      if (getValidityF(item.value['course_date']) == true) {
        loadedCourseItems.add(CoursesModel(
          id: item.key,
          name: item.value['course_name'],
          presentBy: item.value['course_presenter'],
          date: item.value['course_date'],
          time: item.value['course_time'],
          location: item.value['course_location'],
          courseLink: item.value['course_link'],
          timestamp: item.value['timestamp'],
        ));
      }
    }
    courseItems = loadedCourseItems;

    try {
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('cources').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool flag = courseItems.any((item) => item.id.toString() == id);
        int matchingIndex =
            courseItems.indexWhere((item) => item.id.toString() == id);
        if (flag) {
          saveList.add(DynamicItemModel(
              serviceName: 'دورة',
              item: courseItems[matchingIndex],
              icon: services[4]['icon']));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item');
      }
    }
  }

  Future<void> loadWorkshops() async {
    workshopItems = [];
    List<WorkshopModel> loadedWorkshopsItems = [];

    final response = await http.get(FirebaseAPI.url('eventsWorkshopsDB'));
    if (response.body == '"placeholder"') {
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    for (final item in data.entries) {
      if (getValidityF(item.value['workshop_date']) == true) {
        loadedWorkshopsItems.add(WorkshopModel(
          id: item.key,
          name: item.value['workshop_name'],
          presentBy: item.value['workshop_presenter'],
          date: item.value['workshop_date'],
          location: item.value['workshop_location'],
          time: item.value['workshop_time'],
          workshopLink: item.value['workshop_link'],
          timestamp: item.value['timestamp'],
        ));
      }
    }
    workshopItems = loadedWorkshopsItems;
    try {
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('workshops').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool flag = workshopItems.any((item) => item.id.toString() == id);
        int matchingIndex =
            workshopItems.indexWhere((item) => item.id.toString() == id);
        if (flag) {
          saveList.add(DynamicItemModel(
              serviceName: 'ورشة عمل',
              item: workshopItems[matchingIndex],
              icon: services[4]['icon']));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item');
      }
    }
  }

  Future<void> loadConferences() async {
    confItems = [];
    List<ConferencesModel> loadedConferencesItems = [];

    final response = await http.get(FirebaseAPI.url('eventsConferencesDB'));
    if (response.body == '"placeholder"') {
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);

    for (final item in data.entries) {
      if (getValidityF(item.value['conference_date']) == true) {
        loadedConferencesItems.add(ConferencesModel(
          id: item.key,
          name: item.value['conference_name'],
          date: item.value['conference_date'],
          timestamp: item.value['timestamp'],
          time: item.value['conference_time'],
          location: item.value['conference_location'],
          confLink: item.value['conference_link'],
        ));
      }
    }
    confItems = loadedConferencesItems;
    try {
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('conferences').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool flag = confItems.any((item) => item.id.toString() == id);
        int matchingIndex =
            confItems.indexWhere((item) => item.id.toString() == id);
        if (flag) {
          saveList.add(DynamicItemModel(
              serviceName: 'مؤتمر',
              item: confItems[matchingIndex],
              icon: services[4]['icon']));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item');
      }
    }
  }

  Future<void> loadOtherEvents() async {
    otherItems = [];
    List<OtherEventsModel> loadedOtherEventsItems = [];

    final response = await http.get(FirebaseAPI.url('eventsOthersDB'));
    if (response.body == '"placeholder"') {
      return;
    }
    final Map<String, dynamic> eventData = json.decode(response.body);

    for (final item in eventData.entries) {
      if (getValidityF(item.value['OEvent_date']) == true) {
        loadedOtherEventsItems.add(OtherEventsModel(
          id: item.key,
          name: item.value['OEvent_name'],
          presentBy: item.value['OEvent_presenter'],
          date: item.value['OEvent_date'],
          time: item.value['OEvent_time'],
          location: item.value['OEvent_location'],
          otherEventLink: item.value['OEvent_link'],
          timestamp: item.value['timestamp'],
        ));
      }
    }
    otherItems = loadedOtherEventsItems;
    try {
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('otherEvents').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool flag = otherItems.any((item) => item.id.toString() == id);
        int matchingIndex =
            otherItems.indexWhere((item) => item.id.toString() == id);
        if (flag) {
          saveList.add(DynamicItemModel(
              serviceName: 'أخرى',
              item: otherItems[matchingIndex],
              icon: services[4]['icon']));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item');
      }
    }
  }

  Future<void> loadVolOp() async {
    volOpItems = [];
    final List<VolOpModel> loadedVolunteerOp = [];

    try {
      final response = await http.get(FirebaseAPI.url('opportunities'));
      if (response.body == '"placeholder"') {
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        if (getValidityF(item.value['op_date']) == true) {
          loadedVolunteerOp.add(VolOpModel(
            id: item.key,
            name: item.value['op_name'],
            date: item.value['op_date'],
            time: item.value['op_time'],
            location: item.value['op_location'],
            opNumber: item.value['op_number'],
            opLink: item.value['op_link'],
            timestamp: item.value['timestamp'],
          ));
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Empty List');
      }
    }
    volOpItems = loadedVolunteerOp;

    try {
      // Retrieve the +document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('volunteerOp').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool flag = volOpItems.any((item) => item.id.toString() == id);
        int matchingIndex =
            volOpItems.indexWhere((item) => item.id.toString() == id);
        if (flag) {
          saveList.add(DynamicItemModel(
              serviceName: 'فرصة تطوعية',
              item: volOpItems[matchingIndex],
              icon: services[1]['icon']));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item');
      }
    }
  }

  Future<void> loadSClubs() async {
    sClubsItems = [];
    List<StudentClubModel> loadedClubsInfo = [];

    try {
      final response = await http.get(FirebaseAPI.url('studentClubsDB'));
      if (response.body == 'placeholder') {
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        loadedClubsInfo.add(StudentClubModel(
          id: item.key,
          name: item.value['club_name'],
          logo: item.value['club_logo'],
          timestamp: item.value['timestamp'],
          details: item.value['club_details'],
          contact: item.value['club_contact'],
          regTime: item.value['club_regTime'],
          leader: item.value['club_leader'],
          membersLink: item.value['clubMB_link'],
          mngLink: item.value['clubMG_link'],
        ));
      }
    } catch (error) {
      if (kDebugMode) {
        print('Empty List');
      }
    } finally {
      sClubsItems = loadedClubsInfo; // fetched data from Firebase
    }
  }

  Future<void> loadSActivities() async {
    final List<StudentActivityModel> loadedCreatedStudentActivity = [];

    try {
      final response = await http.get(FirebaseAPI.url('create-activity'));

      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        if (getValidityF(item.value['date'])) {
          loadedCreatedStudentActivity.add(StudentActivityModel(
            id: item.key,
            name: item.value['name'],
            date: item.value['date'],
            time: item.value['time'],
            location: item.value['location'],
            numOfPerson: item.value['NumOfPerson'],
          ));
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Empty List');
      }
    } finally {
      sActivitiesItems = loadedCreatedStudentActivity;
    }

    try {
      DocumentSnapshot documentSnapshot = await userProfileDoc
          .collection("saveItems")
          .doc('studentActivities')
          .get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool flag = sActivitiesItems.any((item) => item.id.toString() == id);
        int matchingIndex =
            sActivitiesItems.indexWhere((item) => item.id.toString() == id);
        if (flag) {
          saveList.add(DynamicItemModel(
              serviceName: 'نشاط طلابي',
              item: sActivitiesItems[matchingIndex],
              icon: services[1]['icon']));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item');
      }
    }
  }

  Future<void> loadStudyGroups() async {
    studyGroupItems = [];
    try {
      final response = await http.get(FirebaseAPI.url('create-group'));

      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        if (getValidityF(item.value['date'])) {
          studyGroupItems.add(StudyGroupModel(
            id: item.key,
            name: item.value['name'],
            date: item.value['date'],
            time: item.value['time'],
            location: item.value['location'],
            numPerson: item.value['NumPerson'],
          ));
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Empty List');
      }
    }

    try {
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('studyGroubs').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool flag = studyGroupItems.any((item) => item.id.toString() == id);
        int matchingIndex =
            studyGroupItems.indexWhere((item) => item.id.toString() == id);
        if (flag) {
          saveList.add(DynamicItemModel(
              serviceName: 'جلسة مذاكرة',
              item: studyGroupItems[matchingIndex],
              icon: services[5]['icon']));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item');
      }
    }
  }

  Future<void> loadFoundItems() async {
    foundItems = [];
    final List<FoundItemModel> loadedFoundItems = [];

    try {
      final response = await http.get(FirebaseAPI.url('Found-Items'));

      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        loadedFoundItems.add(FoundItemModel(
          id: item.key,
          category: item.value['Category'],
          foundDate: item.value['FoundDate'],
          foundPlace: item.value['FoundPlace'],
          receivePlace: item.value['ReceivePlace'],
          description: item.value['Description'],
          photo: item.value['Photo'],
        ));
      }
    } catch (error) {
      if (kDebugMode) {
        print('Empty List');
      }
    } finally {
      foundItems = loadedFoundItems;
    }
  }

  Future<void> loadLostItems() async {
    lostItems = [];
    final List<LostItemModel> loadedLostItems = [];
    try {
      final response = await http.get(FirebaseAPI.url('Lost-Items'));
      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        loadedLostItems.add(LostItemModel(
          id: item.key,
          photo: item.value['photo'],
          category: item.value['category'],
          lostDate: item.value['lostDate'],
          expectedPlace: item.value['expectedPlace'],
          phoneNumber: item.value['phoneNumber'],
          desription: item.value['description'],
          creatorID: item.value['creatorID'],
        ));
      }
    } catch (error) {
      if (kDebugMode) {
        print('empty list');
      }
    } finally {
      lostItems = loadedLostItems;
    }
  }

  Future<void> loadClinics() async {
    final List<ClinicModel> loadedClinics = [];
    try {
      final url = Uri.https(
          'senior-project-72daf-default-rtdb.firebaseio.com', 'clinicdb.json');
      final response = await http.get(url);

      final Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        loadedClinics.add(ClinicModel(
          id: item.key,
          clBranch: item.value['cl_branch'],
          clDepartment: item.value['cl_department'],
          clDoctor: item.value['cl_doctor'],
          clDate: item.value['cl_date'],
          clStarttime: item.value['cl_start_time'],
          clEndtime: item.value['cl_end_time'],
        ));
      }
    } catch (error) {
      if (kDebugMode) {
        print('Empty List');
      }
    } finally {
      clinicItems = loadedClinics;
    }
  }
}
