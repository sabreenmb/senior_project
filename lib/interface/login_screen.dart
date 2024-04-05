// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/push_notification.dart';
import 'package:senior_project/theme.dart';
import '../constant.dart';
import 'appSetup.dart';
import 'services_screen.dart';
import 'package:http/http.dart' as http;

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  String _enteredID = '';
  String _enteredPass = '';
  bool _newVal = true;
  @override
  void initState() {
    super.initState();
    // Check if the user is already authenticated

  }







  void navigateToServicesScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ServisesScreen()),
    );
  }
  // void _submit() async {
  //   _newVal = false;
  //   final isValid = _formKey.currentState!.validate();
  //   setState(() {
  //     errorMessage = '';
  //   });
  //   if (!isValid) {
  //     return;
  //   }
  //   _formKey.currentState!.save();
  //   try {
  //     setState(() => isLoading = true);
  //     final userCridential = await _firebase.signInWithEmailAndPassword(
  //         email: _enteredID, password: _enteredPass);
  //
  //     // userID = _enteredID.split("@")[0];
  //     // print('saaabreeeeeeeeeeeeeeeeeeenaaaaa $userProfileDoc ,,,, $userID');
  //     userProfileDoc = FirebaseFirestore.instance
  //         .collection("userProfile")
  //         .doc(_enteredID.split("@")[0]);
  //     DocumentSnapshot snapshot = await userProfileDoc.get();
  //
  //     if (!snapshot.exists) {
  //       userProfileDoc.set({
  //         'image_url': '',
  //         'userID': _enteredID.split("@")[0],
  //         'rule': 'user',
  //         'name': 'منار مجيد',
  //         'collage': 'الحاسبات',
  //         'major': 'هندسة برمجيات',
  //         'intrests': '',
  //         'hobbies': '',
  //         'skills': '',
  //         'pushToken': '',
  //         'offersPreferences': {
  //           'رياضة': false,
  //           'تعليم وتدريب': false,
  //           'مطاعم ومقاهي': false,
  //           'ترفيه': false,
  //           'مراكز صحية': false,
  //           'عناية وجمال': false,
  //           'سياحة وفنادق': false,
  //           'خدمات السيارات': false,
  //           'تسوق': false,
  //           'عقارات وبناء': false,
  //         },
  //       });
  //       CollectionReference saveItemsCollection =
  //       userProfileDoc.collection('saveItems');
  //
  //       DocumentReference conferencesDocRef =
  //       saveItemsCollection.doc('Conferences');
  //
  //       List<dynamic> items = ['default'];
  //
  //       await conferencesDocRef.set({
  //       'items': items,
  //       });
  //     }
  //     snapshot = await userProfileDoc.get();
  //     // Cast the data to Map<String, dynamic> type
  //     final userProfileData = snapshot.data() as Map<String, dynamic>?;
  //
  //     userInfo.image_url = userProfileData?['image_url'];
  //     userInfo.userID = userProfileData?['userID'];
  //     userInfo.rule = userProfileData?['rule'];
  //     userInfo.name = userProfileData?['name'];
  //     userInfo.collage = userProfileData?['collage'];
  //     userInfo.major = userProfileData?['major'];
  //     userInfo.intrests = userProfileData?['intrests'];
  //     userInfo.hobbies = userProfileData?['hobbies'];
  //     userInfo.skills = userProfileData?['skills'];
  //     userInfo.pushToken = userProfileData?['pushToken'];
  //
  //     userInfo.offersPreferences = userProfileData?['offersPreferences'];
  //     notificationServices.getFirebaseMessagingToken();
  //     notificationServices.updatePushToken();
  //     // await PushNotification.getFirebaseMessagingToken();
  //     // PushNotification.updatePushToken();
  //     // PushNotification.forgroundMessage();
  //     // PushNotification.firebaseInit(context);
  //     // PushNotification.setupInteractMessage(context);
  //     //todo load data
  //     new Setup() ;
  //     // LoadOffers();
  //     // loadCoursesItems();
  //     // LoadCreatedSessions();
  //     // loadWorkshopsItems();
  //     // loadConferencesItems();
  //     // loadOtherEventsItems();
  //     // LoadSClubs();
  //
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
  //   } on FirebaseAuthException catch (error) {
  //     setState(() {
  //       errorMessage = 'الرقم الجامعي أو الرقم السري غير صحيح، حاول مرة أخرى.';
  //     });
  //     print(error.message ?? 'Athuntication Faild');
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }
  void _submit() async {
    _newVal = false;
    final isValid = _formKey.currentState!.validate();
    setState(() {
      errorMessage = '';
    });
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() => isLoading = true);
      final userCridential = await _firebase.signInWithEmailAndPassword(
        email: _enteredID,
        password: _enteredPass,
      );

      await Setup.loadUserData(_enteredID);
      new Setup();
      navigateToServicesScreen();
    } on FirebaseAuthException catch (error) {
      setState(() {
        errorMessage = 'الرقم الجامعي أو الرقم السري غير صحيح، حاول مرة أخرى.';
      });
      print(error.message ?? 'Athuntication Faild');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topMargin = screenHeight * 0.05;
    final numericRegex = RegExp(r'^[0-9]+$');
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, false),
          inAsyncCall: isLoading,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 30, bottom: 20, left: 20, right: 20),
                    width: 200,
                    child: const Image(
                      image: AssetImage(
                          'assets/images/logo/Sabreen_Logo_NoEdge1.png'),
                      // width: 95,
                      // height: 130,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          autovalidateMode: AutovalidateMode.disabled,
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'الرقم الجامعي',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.lightBlue,
                                        width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.lightBlue,
                                        width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.lightBlue),
                                  ),
                                ),
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "الرجاء إدخال الرقم الجامعي";
                                  } else {
                                    if (value.length != 7 && !_newVal) {
                                      return "الرقم الجامعي يجب أن يتكون من ٧ أرقام";
                                    }
                                    if (!numericRegex.hasMatch(value)) {
                                      return "الرقم الجامعي يجب أن يتكون من أرقام فقط";
                                    }
                                    return null;
                                  }
                                },
                                onTap: () => _newVal = true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onSaved: (value) {
                                  _enteredID = ("$value" "@uj.edu.sa");
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'الرقم السري',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.lightBlue,
                                        width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.lightBlue,
                                        width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColors.lightBlue),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "الرجاء إدخال الرقم السري";
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textAlign: TextAlign.right,
                                obscureText: true,
                                onSaved: (value) {
                                  _enteredPass = value!;
                                },
                              ),
                              SizedBox(height: topMargin),
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(175, 50),
                                    backgroundColor: CustomColors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(27))),
                                onPressed: _submit,
                                child: Text("تسجيل الدخول",
                                    style: TextStyles.text3),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
