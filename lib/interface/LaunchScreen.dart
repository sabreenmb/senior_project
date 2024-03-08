import 'package:flutter/material.dart';
import 'package:senior_project/theme.dart';

import 'login_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CustomColors.white,
      body: Center(
        child: Image(
          width: 158,
          height: 170,
          image: AssetImage('assets/images/logo/Sabreen_Logo_NoEdge1.png'),
        ),
      ),
    );
  }
}
