import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_project/interface/firebaseConnection.dart';

import '../constant.dart';
import '../model/EventItem.dart';
import '../model/SClubInfo.dart';
import '../model/conference_item_report.dart';
import '../model/courses_item_report.dart';
import '../model/create_student_activity_report.dart';
import '../model/offer_info.dart';
import 'package:http/http.dart' as http;

import '../model/other_event_item_report.dart';
import '../model/volunteer_op_report.dart';
import '../model/workshop_item_report.dart';

class Setup{


  Setup() {
    LoadOffers();
    loadCoursesItems();
    loadWorkshopsItems();
    loadConferencesItems();
    loadOtherEventsItems();
    LoadCreatedSessions();
    LoadSClubs();
    LoadCreatedActivities();

    // last one
    loadSaveItems();

  }

  static Future<void> loadUserData(String enteredID) async {
    final userProfileData = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(enteredID.split("@")[0])
        .get()
        .then((snapshot) => snapshot.data() as Map<String, dynamic>?);

    userInfo.image_url = userProfileData?['image_url'];
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
    // new Setup();
  }

  void LoadOffers() async {
    final List<OfferInfo> loadedOfferInfo = [];

    try {
      // final url = Uri.https(
      //     'senior-project-72daf-default-rtdb.firebaseio.com', 'offersdb.json');
      final response = await http.get(Connection.url('offersdb'));

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        print(item.value['of_name']);
        loadedOfferInfo.add(OfferInfo(
          id: item.key,
          //model name : firebase name
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


  void loadCoursesItems() async {
    courseItem=[];
    final response = await http.get(Connection.url('eventsCoursesDB'));

    final Map<String, dynamic> data = json.decode(response.body);
    for (final item in data.entries) {
      print(item.value['course_name']);
      if (getValidityF(item.value['course_date']) == true) {
        courseItem.add(CoursesItemReport(
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
  }

  void loadWorkshopsItems() async {
    workshopItem=[];
    final response = await http.get(Connection.url('eventsWorkshopsDB'));

    final Map<String, dynamic> data = json.decode(response.body);
    for (final item in data.entries) {
      if (getValidityF(item.value['workshop_date']) == true) {
        workshopItem.add(WorkshopsItemReport(
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
  }

  void loadConferencesItems() async {
    confItem=[];
    final response = await http.get(Connection.url('eventsConferencesDB'));

    final Map<String, dynamic> data = json.decode(response.body);
    for (final item in data.entries) {
      if (getValidityF(item.value['conference_date']) == true) {
        confItem.add(ConferencesItemReport(
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
  }

  void loadOtherEventsItems() async {
    otherItem=[];
    final response = await http.get(Connection.url('eventsOthersDB'));

    final Map<String, dynamic> eventData = json.decode(response.body);
    for (final item in eventData.entries) {
      if (getValidityF(item.value['OEvent_date']) == true) {
        otherItem.add(OtherEventsItemReport(
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
  }

  void LoadCreatedSessions() async {
    final List<VolunteerOpReport> loadedVolunteerOp = [];

    try {

      final response = await http.get(Connection.url('opportunities'));

      final Map<String, dynamic> volunteerdata = json.decode(response.body);
      for (final item in volunteerdata.entries) {
        print(item.value['op_name']);
        if (getValidityF(item.value['op_date']) == true) {
          loadedVolunteerOp.add(VolunteerOpReport(
            id: item.key,
            //model name : firebase name
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
      print('Empty List');
    }
    volunteerOpReport=[];
    volunteerOpReport = loadedVolunteerOp;
  }


  void LoadSClubs() async {
    List<SClubInfo> loadedClubsInfo = [];

    try {
      // final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
      //     'studentClubsDB.json');
      final response = await http.get(Connection.url('studentClubsDB'));

      final Map<String, dynamic> clubdata = json.decode(response.body);
      for (final item in clubdata.entries) {
        print(item.value['club_name']);
        loadedClubsInfo.add(SClubInfo(
          id: item.key,
          //model name : firebase name
          name: item.value['club_name'],
          logo: item.value['club_logo'],
          timestamp: item.value['timestamp'],

          details: item.value['club_details'],
          contact: item.value['club_contact'],
          regTime: item.value['club_regTime'],
          leader: item.value['club_leader'],
          membersLink: item.value['clubMB_link'],
          MngLink: item.value['clubMG_link'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      SClubs=[];
      SClubs = loadedClubsInfo; // fetched data from Firebase
    }
  }

  void loadSaveItems() async {
    saveList = [];
    try {
      // Retrieve the document
      DocumentSnapshot documentSnapshot =
      await userProfileDoc.collection("saveItems").doc('Conferences').get();

      if (documentSnapshot.exists) {
        // Check if the item already exists in the 'items' array
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        var items = data['items'] as List<dynamic>;
        // print(items);

        //for (var id in items) {
        for (int i = 0; i < items.length; i++) {
          print(i);
          var id = items[i];
          // final String? itemIdTemp = id;
          print(id);
          if (confItem[i].id == id) {
            print("did i came hereeeeeee?");
            saveList.add(EventItem(
                serviceName: 'Conferences',
                item: confItem[i],
                icon: services[4]['icon']));
          } else if (workshopItem.contains(id)) {
          } else if (courseItem.contains(id)) {
          } else if (otherItem.contains(id)) {}
          // print(id);
          // if (items.contains(itemId)) {
          //   print('Item already exists.');
          //   return;
          // }
          // print("paaaaasss");
        }
      }
      print('Items added successfully.');
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  void LoadCreatedActivities() async {
    final List<CreateStudentActivityReport> loadedCreatedStudentActivity = [];

    try {


      final response = await http.get(Connection.url('create-activity'));

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedCreatedStudentActivity.add(CreateStudentActivityReport(
          id: item.key,
          //model name : firebase name
          activityName: item.value['ActivityName'],
          activityDate: item.value['ActivityDate'],
          activityTime: item.value['ActivityTime'],
          activityPlace: item.value['ActivityPlace'],
          numOfPerson: item.value['NumOfPerson'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
        createStudentActivityReport = loadedCreatedStudentActivity;
    }
  }



}