// ignore_for_file: unused_local_variable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/push_notification.dart';
import 'package:senior_project/theme.dart';
import '../constant.dart';
import '../appSetup.dart';
import '../commonWidgets.dart';
import '../network.dart';
import 'services_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var connectivityResult = (Connectivity().checkConnectivity());

  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  String _enteredID = '';
  String _enteredPass = '';
  bool _newVal = true;
  @override
  void initState() {
    super.initState();
    // Check if the user is already authenticated
    network();

  }

  // Future<bool> checkNetworkConnection() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
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
      await Setup().build();
      Setup().build2();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
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
        body:
        ModalProgressHUD(
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
                                onPressed: () async {
                                  await network();
                                  if (isOffline) {
                                    await Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) => const NetworkConnection()));
                                  //todo  networkPopup(context,false);
                                  } else {
                                    _submit();
                                  }
                                },
                                //() async {
                                // isOnline = await checkNetworkConnection();
                                // if (isOnline) {
                                //   _submit();
                                // }else{
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         title: Text('Network Status'),
                                //         content: Text('No internet connection.'),
                                //         actions: [
                                //           TextButton(
                                //             child: Text('OK'),
                                //             onPressed: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //           ),
                                //         ],
                                //       );
                                //     },
                                //   );
                                // }
                                // },
                                child: Text("تسجيل الدخول",
                                    style: TextStyles.btnText),
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
