// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constant.dart';
import '../theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

// i do not need it

  // void _snapshot() async {
  //   DocumentSnapshot snapshot = await userProfileDoc.get();
  //   snapshot = await userProfileDoc.get();
  //   final userProfileData = snapshot.data() as Map<String, dynamic>?;

  //   _intrestsController.text = userInfo.intrests ?? '';
  //   _hobbiesController.text = userInfo.hobbies ?? '';
  //   _skillsController.text = userInfo.skills ?? '';
  // }

  void _submit() async {
    _formKey.currentState!.save();
    try {
      // Save data to Firestore
      await userProfileDoc.update({
        'intrests': userInfo.intrests,
        'hobbies': userInfo.hobbies,
        'skills': userInfo.skills,
      });

      // _snapshot();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحديث البيانات بنجاح'),
          duration: Duration(seconds: 1),
          backgroundColor: CustomColors.darkGrey,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } catch (e) {
      // Handle any errors that occur during saving
      print('يوجد خطأ حاول مرة أخرى $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء تحديث البيانات')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // _snapshot();
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
                              child: Form(
                                key: _formKey,
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
                                      userInfo.name!,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: CustomColors.lightBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      userInfo.collage!,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: CustomColors.darkGrey),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      userInfo.major!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.darkGrey),
                                    ),
                                    const SizedBox(height: 18),
                                    TextFormField(
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
                                      initialValue: userInfo.intrests,
                                      onSaved: (value) {
                                        userInfo.intrests = value;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
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
                                      initialValue: userInfo.hobbies,
                                      onSaved: (value) {
                                        userInfo.hobbies = value;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
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
                                      initialValue: userInfo.skills,
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
