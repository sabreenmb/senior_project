// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constant.dart';
import '../theme.dart';
import '../model/entered_user_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _intrestsController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

// i do not need it
  enteredUserInfo userInfo = enteredUserInfo(
    intrests: '',
    hobbies: '',
    skills: '',
  );

  void _snapshot() async {
    DocumentSnapshot snapshot = await userProfileDoc.get();
    snapshot = await userProfileDoc.get();
    final userProfileData = snapshot.data() as Map<String, dynamic>?;

    userIntrests = userProfileData?['intrests'] as String?;
    userHobbies = userProfileData?['hobbies'] as String?;
    userSkills = userProfileData?['skills'] as String?;

    _intrestsController.text = userIntrests ?? '';
    _hobbiesController.text = userHobbies ?? '';
    _skillsController.text = userSkills ?? '';
  }

  void _submit() async {
    try {
      // Save data to Firestore
      await userProfileDoc.update({
        'intrests': _intrestsController.text,
        'hobbies': _hobbiesController.text,
        'skills': _skillsController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile data saved successfully')),
      );
    } catch (e) {
      // Handle any errors that occur during saving
      print('Error saving profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while saving profile data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _snapshot();
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("الملف الشخصي", style: TextStyles.heading1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.darkGrey),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: loadingFunction(context, true),
        inAsyncCall: isLoading,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    ListView(
                      children: [
                        // const SizedBox(height: 8.0),
                        //profile pic **icon now change it later**
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                //const SizedBox(height: 12.0),
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 20),
                                    alignment: Alignment.topCenter,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      //color: Color.fromARGB(255, 139, 139, 139),
                                      shape: BoxShape.circle,
                                      // ignore: unnecessary_new
                                      border: new Border.all(
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
                                    userName!,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: CustomColors.lightBlue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    userCollage!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: CustomColors.darkGrey),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    userMajor!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: CustomColors.darkGrey),
                                  ),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _intrestsController,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      labelText: "الاهتمامات",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomColors.lightBlue,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomColors.lightBlue,
                                        ),
                                      ),
                                    ),
                                    onSaved: (value) {
                                      userInfo.intrests = value;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _hobbiesController,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      labelText: 'الهوايات',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomColors.lightBlue,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomColors.lightBlue,
                                        ),
                                      ),
                                    ),
                                    onSaved: (value) {
                                      userInfo.hobbies = value;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _skillsController,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      labelText: ' ما يمكنك اضافتة للمجتمع؟ ',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomColors.lightBlue,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CustomColors.lightBlue,
                                        ),
                                      ),
                                    ),
                                    //initialValue: userData['skills'],
                                    onSaved: (value) {
                                      userInfo.skills = value;
                                    },
                                  ),
                                  const SizedBox(height: 55.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 90),
                                    child: ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(175, 50),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor:
                                              CustomColors.lightBlue),
                                      child: Text("تحديث",
                                          style: TextStyles.text3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}        
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       backgroundColor: CustomColors.pink,
  //       elevation: 0,
  //       title: Text("الملف الشخصي", style: TextStyles.heading1),
  //       //centerTitle: false,
  //       iconTheme: const IconThemeData(color: CustomColors.darkGrey),
  //     ),
  //     endDrawer: const SideDrawer(),
  //     body: ListView(
  //       children: [
  //         const SizedBox(height: 12.0),
  //         //profile pic **icon now change it later**
  //         Container(
  //           margin: const EdgeInsets.all(20),
  //           child: SingleChildScrollView(
  //             child: Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Column(
  //                 //const SizedBox(height: 12.0),
  //                 children: [
  //                   Container(
  //                     margin: const EdgeInsets.only(top: 5, bottom: 20),
  //                     alignment: Alignment.topCenter,
  //                     height: 150,
  //                     decoration: BoxDecoration(
  //                       //color: Color.fromARGB(255, 139, 139, 139),
  //                       shape: BoxShape.circle,
  //                       // ignore: unnecessary_new
  //                       border: new Border.all(
  //                         color: CustomColors.darkGrey,
  //                         width: 3,
  //                       ),
  //                     ),
  //                     child: Container(
  //                       alignment: Alignment.center,
  //                       child: SvgPicture.asset(
  //                         'assets/icons/UserProfile.svg',
  //                         height: 100,
  //                         width: 100,
  //                         color: CustomColors.darkGrey,
  //                       ),
  //                     ),
  //                   ),
  //                   Text(
  //                     userName!,
  //                     style: const TextStyle(
  //                         fontSize: 20, color: CustomColors.darkGrey),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     userCollage!,
  //                     style: const TextStyle(
  //                         fontSize: 18, color: CustomColors.darkGrey),
  //                   ),
  //                   const SizedBox(height: 6),
  //                   Text(
  //                     userMajor!,
  //                     style: const TextStyle(
  //                         fontSize: 16, color: CustomColors.darkGrey),
  //                   ),
  //                   const SizedBox(height: 15),
  //                   TextFormField(
  //                     controller: _intrestsController,
  //                     keyboardType: TextInputType.text,
  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                     decoration: const InputDecoration(
  //                       labelText: "الاهتمامات",
  //                       focusedBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(
  //                           color: CustomColors.lightBlue,
  //                         ),
  //                       ),
  //                       enabledBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(
  //                           color: CustomColors.lightBlue,
  //                         ),
  //                       ),
  //                     ),
  //                     initialValue: userInterests,
  //                     onSaved: (value) {
  //                       userInfo.intrests = value;
  //                     },
  //                   ),
  //                   TextFormField(
  //                     controller: _hobbiesController,
  //                     keyboardType: TextInputType.text,
  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                     decoration: const InputDecoration(
  //                       labelText: 'الهوايات',
  //                       focusedBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(
  //                           color: CustomColors.lightBlue,
  //                         ),
  //                       ),
  //                       enabledBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(
  //                           color: CustomColors.lightBlue,
  //                         ),
  //                       ),
  //                     ),
  //                     onSaved: (value) {
  //                       userInfo.hobbies = value;
  //                     },
  //                   ),
  //                   TextFormField(
  //                     controller: _skillsController,
  //                     keyboardType: TextInputType.text,
  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                     decoration: const InputDecoration(
  //                       labelText: ' ما يمكنك اضافتة للمجتمع؟ ',
  //                       focusedBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(
  //                           color: CustomColors.lightBlue,
  //                         ),
  //                       ),
  //                       enabledBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(
  //                           color: CustomColors.lightBlue,
  //                         ),
  //                       ),
  //                     ),
  //                     //initialValue: userData['skills'],
  //                     onSaved: (value) {
  //                       userInfo.skills = value;
  //                     },
  //                   ),
  //                   const SizedBox(height: 55.0),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 90),
  //                     child: ElevatedButton(
  //                       onPressed: _submit,
  //                       style: ElevatedButton.styleFrom(
  //                           fixedSize: const Size(175, 50),
  //                           elevation: 0,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20),
  //                           ),
  //                           backgroundColor: CustomColors.lightBlue),
  //                       child: Text("تحديث", style: TextStyles.text3),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     // StreamBuilder<DocumentSnapshot>(
  //     //   stream: userProfileDoc.snapshots(),
  //     //   builder: (context, snapshot) {
  //     //     if (snapshot.hasData) {
  //     //       return
  //     //     } else if (snapshot.hasError) {
  //     //       print("object");
  //     //     }
  //     //     return const Center(
  //     //       child: CircularProgressIndicator(),
  //     //     );
  //     //   },
  //     // ),
  //   );
  // }
      // }
