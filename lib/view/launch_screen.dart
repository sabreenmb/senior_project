// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/controller/app_setup.dart';
import 'package:senior_project/view/home_screen.dart';
import 'package:senior_project/common/theme.dart';
import '../common/constant.dart';
import '../common/network_page.dart';
import 'login_screen.dart';


class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late StreamSubscription connSub;
  void checkConnectivity(List<ConnectivityResult> result) {
    switch (result[0]) {
      case ConnectivityResult.mobile || ConnectivityResult.wifi:
        if (isOffline != false) {
          setState(() {
            isOffline = false;
          });
        }
        break;
      case ConnectivityResult.none:
        if (isOffline != true) {
          setState(() {
            isOffline = true;
          });
        }
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    connSub = Connectivity().onConnectivityChanged.listen(checkConnectivity);
    Future.delayed(const Duration(seconds: 1), () {
      setup();
    });
  }
  Future<void> setup() async {
    await _checkToken();
  }
  @override
  void dispose() {
    connSub.cancel();
    super.dispose();
  }

  Future<void> _checkToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (isOffline) {
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NetworkConnection()));
      } else {
        if (user != null) {
          if (!isOffline) {
            await Setup.loadUserData(user.email.toString());
            await Setup().build();
            Setup().build2();
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            });
          }
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('we do not have a token');
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
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
