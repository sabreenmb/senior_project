import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/theme.dart';

import '../constant.dart';
import '../widgets/commonWidgets.dart';
import 'login_screen.dart';
import 'package:senior_project/appSetup.dart';
import 'package:flutter/services.dart';
class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState()  {
    super.initState();

    setup();
  }
  Future<void> setup()async {
   await network();
    _checkToken();
  }

  Future<void> _checkToken() async {

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (isOffline){
           await  networkPopup(context,true);
           print(isOffline);

        }
        if(!isOffline) {
          print('test');
          await Setup.loadUserData(user.email.toString());
          await Setup().Build();
          Setup().Build2();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
        }else{
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        });
      }

    } catch (e) {
      print('we do not have a token');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }


  @override
  Widget build(BuildContext context) {
    // if(isOffline){
    //   networkPopup(context);
    // }else{
    //   _checkToken();
    //
    // }
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: Center(
          child: Image(
            width: 158,
            height: 170,
            image: AssetImage('assets/images/logo/Sabreen_Logo_NoEdge1.png'),
          ),
        ),
      ),
    );
  }
}
