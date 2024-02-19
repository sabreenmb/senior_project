// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/login_screen.dart';
import '../theme.dart';

class SideDrawer extends StatelessWidget {
  final void Function()? onProfileTap;

  const SideDrawer({super.key, this.onProfileTap});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColors.BackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
                //border: Unde
                ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 20),
                  alignment: Alignment.topCenter,
                  height: 150,
                  decoration: BoxDecoration(
                    //color: Color.fromARGB(255, 139, 139, 139),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CustomColors.darkGrey,
                      width: 3,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/UserProfile.svg',
                      height: 100,
                      width: 100,
                      color: CustomColors.darkGrey,
                    ),
                  ),
                ),
                Text(
                  userInfo.name!,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.darkGrey),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CustomColors.lightBlue.withOpacity(0.3),
              border: const Border(
                top: BorderSide(color: CustomColors.lightBlue, width: 1),
                bottom: BorderSide(color: CustomColors.lightBlue, width: 1),
                left: BorderSide(color: CustomColors.lightBlue, width: 8),
                right: BorderSide(color: CustomColors.lightBlue, width: 1),
              ),
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/icons/profileIcon.svg",
                height: 30,
                width: 30,
                color: CustomColors.darkGrey.withOpacity(0.8),
              ),
              title: const Text("الملف الشخصي"),
              onTap: onProfileTap,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: CustomColors.lightBlue.withOpacity(0.3),
              border: const Border(
                top: BorderSide(color: CustomColors.lightBlue, width: 1),
                bottom: BorderSide(color: CustomColors.lightBlue, width: 1),
                left: BorderSide(color: CustomColors.lightBlue, width: 8),
                right: BorderSide(color: CustomColors.lightBlue, width: 1),
              ),
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/icons/logout.svg",
                height: 30,
                width: 30,
                color: CustomColors.darkGrey.withOpacity(0.8),
              ),
              title: const Text("تسجيل الخروج"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                // print('saaabreeeeeeeeeeeeeeeeeeena $userProfileDoc');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
