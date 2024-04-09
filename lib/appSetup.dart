import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_project/firebaseConnection.dart';
import 'package:senior_project/model/entered_user_info.dart';

import 'constant.dart';
import 'model/EventItem.dart';
import 'model/SClubInfo.dart';
import 'model/conference_item_report.dart';
import 'model/courses_item_report.dart';
import 'model/create_group_report.dart';
import 'model/create_student_activity_report.dart';
import 'model/found_item_report.dart';
import 'model/lost_item_report.dart';
import 'model/offer_info.dart';
import 'package:http/http.dart' as http;

import 'model/other_event_item_report.dart';
import 'model/volunteer_op_report.dart';
import 'model/workshop_item_report.dart';

class Setup {
  Setup() {
    saveList = [];
    loadAllUsers();
    LoadOffers();
    loadCoursesItems();
    loadWorkshopsItems();
    loadConferencesItems();
    loadOtherEventsItems();
    LoadCreatedSessions();
    LoadSClubs();
    LoadCreatedActivities();
    loadStudyGroups();
    LoadLostItems();
    LoadFoundItems();
    // last one
    // loadSaveItems();
  }

  static Future<void> loadUserData(String enteredID) async {
    userProfileDoc = Connection.Users();
    DocumentSnapshot snapshot = await userProfileDoc.get();

    if (!snapshot.exists) {
      print("meeeeeeeeeeeeeeeemooooooooooo");
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

      print("weeeeeeennnn");
      List<dynamic> items = ['INIT'];

      CollectionReference saveItemsCollection =
          userProfileDoc.collection('saveItems');

      await saveItemsCollection.doc('offers').set({
        'items': items,
      });
      await saveItemsCollection.doc('conferences').set({
        'items': items,
      });
      await saveItemsCollection.doc('workshops').set({
        'items': items,
      });
      await saveItemsCollection.doc('cources').set({
        'items': items,
      });
      await saveItemsCollection.doc('otherEvents').set({
        'items': items,
      });
      await saveItemsCollection.doc('studyGroubs').set({
        'items': items,
      });
      await saveItemsCollection.doc('studentActivities').set({
        'items': items,
      });
      await saveItemsCollection.doc('volunteerOp').set({
        'items': items,
      });
    }
    final userProfileData =
        await userProfileDoc.get().then((snapshot) => snapshot.data());

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

  void loadAllUsers() async {
    // List<enteredUserInfo> allUsers = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('userProfile').get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
        //allUsers[i] = documentSnapshot.data() as enteredUserInfo;
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        enteredUserInfo otherUserInfo = enteredUserInfo(
          userID: data['userID'],
          rule: data['rule'],
          name: data['name'],
          collage: data['collage'],
          major: data['major'],
          intrests: data['intrests'],
          hobbies: data['hobbies'],
          skills: data['skills'],
          image_url: data["image_url"],
          pushToken: data["pushToken"],
          offersPreferences: data['offersPreferences'],
        );
        print("yyyyyyarb");
        print(allUsers[i].name);
        allUsers[i] = otherUserInfo;
      }
      // Process the documents here
    } catch (e) {
      print('Error loading documents: $e');
    }
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
    courseItem = [];
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
    try {
      // Retrieve the +document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('cources').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool zq = courseItem.any((item) => item.id.toString() == id);
        int matchingIndex =
            courseItem.indexWhere((item) => item.id.toString() == id);
        if (zq) {
          print("did i came hereeeeeee? 4");
          saveList.add(EventItem(
              serviceName: 'دورة',
              item: courseItem[matchingIndex],
              icon: services[4]['icon']));
        }
      }

      print('Items added successfully cources.');
    } catch (e) {
      print('Error adding itemmmmm: $e');
    }
  }

  void loadWorkshopsItems() async {
    workshopItem = [];
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

    try {
      // Retrieve the +document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('workshops').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool zq = workshopItem.any((item) => item.id.toString() == id);
        int matchingIndex =
            workshopItem.indexWhere((item) => item.id.toString() == id);
        if (zq) {
          print("did i came hereeeeeee? 7");
          saveList.add(EventItem(
              serviceName: 'ورشة عمل',
              item: workshopItem[matchingIndex],
              icon: services[4]['icon']));
        }
      }

      print('Items added successfully work.');
    } catch (e) {
      print('Error adding itemmmmm: $e');
    }
  }

  void loadConferencesItems() async {
    confItem = [];
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
    try {
      // Retrieve the +document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('conferences').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool zq = confItem.any((item) => item.id.toString() == id);
        int matchingIndex =
            confItem.indexWhere((item) => item.id.toString() == id);
        if (zq) {
          print("did i came hereeeeeee? 0");
          saveList.add(EventItem(
              serviceName: 'مؤتمر',
              item: confItem[matchingIndex],
              icon: services[4]['icon']));
        }
      }

      print('Items added successfully conf.');
    } catch (e) {
      print('Error adding itemmmmm: $e');
    }
  }

  void loadOtherEventsItems() async {
    otherItem = [];
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

    try {
      // Retrieve the +document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('otherEvents').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool zq = otherItem.any((item) => item.id.toString() == id);
        int matchingIndex =
            otherItem.indexWhere((item) => item.id.toString() == id);
        if (zq) {
          print("did i came hereeeeeee? 11");
          saveList.add(EventItem(
              serviceName: 'أخرى',
              item: otherItem[matchingIndex],
              icon: services[4]['icon']));
        }
      }

      print('Items added successfully other.');
    } catch (e) {
      print('Error adding itemmmmm: $e');
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
    volunteerOpReport = [];
    volunteerOpReport = loadedVolunteerOp;

    try {
      // Retrieve the +document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('volunteerOp').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool zq = volunteerOpReport.any((item) => item.id.toString() == id);
        int matchingIndex =
            volunteerOpReport.indexWhere((item) => item.id.toString() == id);
        if (zq) {
          print("did i came hereeeeeee? 1");
          saveList.add(EventItem(
              serviceName: 'فرصة تطوعية',
              item: volunteerOpReport[matchingIndex],
              icon: services[1]['icon']));
        }
      }

      print('Items added successfully vol.');
    } catch (e) {
      print('Error adding itemmmmm: $e');
    }
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
      SClubs = [];
      SClubs = loadedClubsInfo; // fetched data from Firebase
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
          name: item.value['name'],
          date: item.value['date'],
          time: item.value['time'],
          location: item.value['location'],
          numOfPerson: item.value['NumOfPerson'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      createStudentActivityReport = loadedCreatedStudentActivity;
    }

    try {
      // Retrieve the +document
      DocumentSnapshot documentSnapshot = await userProfileDoc
          .collection("saveItems")
          .doc('studentActivities')
          .get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool zq =
            createStudentActivityReport.any((item) => item.id.toString() == id);
        int matchingIndex = createStudentActivityReport
            .indexWhere((item) => item.id.toString() == id);
        if (zq) {
          print("did i came hereeeeeee? 6");
          saveList.add(EventItem(
              serviceName: 'نشاط طلابي',
              item: createStudentActivityReport[matchingIndex],
              icon: services[1]['icon']));
        }
      }

      print('Items added successfully act.');
    } catch (e) {
      print('Error adding itemmmmm: $e');
    }
  }

  void loadStudyGroups() async {
    createGroupReport = [];
    try {
      final response = await http.get(Connection.url('create-group'));

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        createGroupReport.add(CreateGroupReport(
          id: item.key,
          //model name : firebase name
          name: item.value['name'],
          date: item.value['date'],
          time: item.value['time'],
          location: item.value['location'],
          numPerson: item.value['NumPerson'],
        ));
      }
    } catch (error) {
      print('Empty List');
    }

    try {
      // Retrieve the +document
      DocumentSnapshot documentSnapshot =
          await userProfileDoc.collection("saveItems").doc('studyGroubs').get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      var items = data['items'] as List<dynamic>;

      for (int i = 0; i < items.length; i++) {
        var id = items[i];
        bool zq = createGroupReport.any((item) => item.id.toString() == id);
        int matchingIndex =
            createGroupReport.indexWhere((item) => item.id.toString() == id);
        if (zq) {
          print("did i came hereeeeeee? 98");
          saveList.add(EventItem(
              serviceName: 'جلسة مذاكرة',
              item: createGroupReport[matchingIndex],
              icon: services[5]['icon']));
        }
      }

      print('Items added successfully study grp.');
    } catch (e) {
      print('Error adding itemmmmm: $e');
    }
  }

  void LoadFoundItems() async {
    foundItemReport = [];
    final List<FoundItemReport> loadedFoundItems = [];

    try {
      final response = await http.get(Connection.url('Found-Items'));

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedFoundItems.add(FoundItemReport(
          id: item.key,
          category: item.value['Category'],
          foundDate: item.value['FoundDate'],
          foundPlace: item.value['FoundPlace'],
          receivePlace: item.value['ReceivePlace'],
          desription: item.value['Description'],
          photo: item.value['Photo'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      foundItemReport = loadedFoundItems;
    }
  }

  void LoadLostItems() async {
    lostItemReport = [];
    final List<LostItemReport> loadedLostItems = [];
    try {
      final response = await http.get(Connection.url('Lost-Items'));
      final Map<String, dynamic> lostdata = json.decode(response.body);
      for (final item in lostdata.entries) {
        loadedLostItems.add(LostItemReport(
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
      print('empty list');
    } finally {
      lostItemReport = loadedLostItems;
    }
  }
}