// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/interface/login_screen.dart';
import '../common/theme.dart';

class SideDrawer extends StatelessWidget {
  final void Function()? onProfileTap;

  const SideDrawer({super.key, this.onProfileTap});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColors.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CustomColors.darkGrey,
                          width: 3,
                        ),
                      ),
                      child: userInfo.imageUrl == ''
                          ? Container(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/icons/UserProfile.svg',
                                height: 100,
                                width: 100,
                                color: CustomColors.darkGrey,
                              ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                  width: 145,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  imageUrl: userInfo.imageUrl,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        alignment: Alignment.topCenter,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: CustomColors.darkGrey,
                                            width: 3,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/UserProfile.svg',
                                          height: 100,
                                          width: 100,
                                          color: CustomColors.darkGrey,
                                        ),
                                      )),
                            ),
                    ),
                    Text(
                      userInfo.name,
                      style: TextStyles.menuTitle,
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
                    "assets/icons/id_card.svg",
                    height: 40,
                    width: 40,
                    color: CustomColors.darkGrey,
                  ),
                  title: const Text("البطاقة الجامعية"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          backgroundColor: CustomColors.noColor,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomColors.white,
                              image: DecorationImage(
                                image: const AssetImage(
                                    'assets/images/logo/Logo.png'),
                                fit: BoxFit.scaleDown,
                                colorFilter: ColorFilter.mode(
                                  CustomColors.white.withOpacity(0.1),
                                  BlendMode.dstATop,
                                ),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: CustomColors.black,
                                  blurRadius: 10.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: CustomColors.pink,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  alignment: Alignment.center,
                                  child: Text("البطاقة الجامعية",
                                      style: TextStyles.pageTitle2),
                                ),
                                const SizedBox(height: 20),
                                CircleAvatar(
                                  radius: 80,
                                  backgroundColor:
                                      const Color.fromARGB(0, 15, 66, 186),
                                  child: Stack(
                                    children: [
                                      userInfo.imageUrl == ''
                                          ? Container(
                                              padding: const EdgeInsets.all(20),
                                              alignment: Alignment.topCenter,
                                              height: 140,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: CustomColors.darkGrey,
                                                  width: 3,
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/UserProfile.svg',
                                                height: 100,
                                                width: 100,
                                                color: CustomColors.darkGrey,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                  imageUrl: userInfo.imageUrl,
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        alignment:
                                                            Alignment.topCenter,
                                                        height: 140,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: CustomColors
                                                                .darkGrey,
                                                            width: 3,
                                                          ),
                                                        ),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/UserProfile.svg',
                                                          height: 100,
                                                          width: 100,
                                                          color: CustomColors
                                                              .darkGrey,
                                                        ),
                                                      )),
                                            ),
                                    ],
                                  ),
                                ),
                                Text(userInfo.name,
                                    style: TextStyles.heading1D),
                                const SizedBox(height: 10),
                                Text(userInfo.userID,
                                    style: TextStyles.heading2D),
                                const SizedBox(height: 8),
                                Text(userInfo.collage,
                                    style: TextStyles.heading2D),
                                const SizedBox(height: 8),
                                Text(userInfo.major,
                                    style: TextStyles.heading2D),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: CustomColors.pink,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(20),
                                    ),
                                  ),
                                  child: BarcodeWidget(
                                    barcode: Barcode.qrCode(),
                                    data: userInfo.userID,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
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
                FirebaseFirestore.instance
                    .collection('userProfile')
                    .doc(userInfo.userID)
                    .update({
                  'pushToken': '',
                });
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ),
          // const SizedBox(height: ),
        ],
      ),
    );
  }
}
