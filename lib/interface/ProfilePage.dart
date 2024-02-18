// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/widgets/side_menu.dart';

import '../model/entered_user_info.dart';
import '../theme.dart';
import 'ChatScreen.dart';
import 'HomeScreen.dart';
import 'SaveListScreen.dart';
import 'services_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  enteredUserInfo userInfo = enteredUserInfo(
    collage: '',
    major: '',
    intrests: '',
    hobbies: '',
    skills: '',
  );
  int _selectedPageIndex = 2;
  String errorMessage = '';

  // ignore: unused_field
  bool _newVal = true;
  final _formKey = GlobalKey<FormState>();

  TextEditingController yourController = TextEditingController();

  void _submit() async {
    _newVal = false;
    final isValid = _formKey.currentState!.validate();
    setState(() {
      errorMessage = '';
    });
    if (!isValid) {
      return;
    }
  }

  void _selectPage(int index) {
    setState(() {
      if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
        _selectedPageIndex = index;
      }
      //todo uncomment on next sprints
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        _selectedPageIndex = index;
      } else if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
        _selectedPageIndex = index;
      } else if (index == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatScreen()));
        _selectedPageIndex = index;
      } else if (index == 3) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SaveListScreen()));
        _selectedPageIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("الملف الشخصي", style: TextStyles.heading1),
          //centerTitle: false,
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
        ),
        endDrawer: const SideDrawer(),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 0.1,
          clipBehavior: Clip.none,
          child: SizedBox(
            height: kBottomNavigationBarHeight * 1.2,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: BottomNavigationBar(
                onTap: _selectPage,
                unselectedItemColor: CustomColors.darkGrey,
                selectedItemColor: CustomColors.lightBlue,
                currentIndex: 1,
                items: const [
                  BottomNavigationBarItem(
                    label: 'الرئيسية',
                    icon: Icon(Icons.home_outlined),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.apps), label: 'الخدمات'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.messenger_outline,
                      ),
                      label: 'الدردشة'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark_border), label: 'المحفوظات'),
                ],
              ),
            ),
          ),
        ),
        body: ListView(children: [
          const SizedBox(height: 12.0),
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
                              margin: const EdgeInsets.only(top: 5, bottom: 20),
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
                            const Text(
                              " شموخ مازن قطان ",
                              style: TextStyle(
                                  fontSize: 20, color: CustomColors.darkGrey),
                            ),
                            TextFormField(
                              controller: yourController,
                              keyboardType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: ' كلية ',
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
                                userInfo.collage = value;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: ' التخصص ',
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
                                userInfo.major = value;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: ' الاهتمامات ',
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
                            TextFormField(
                              keyboardType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: ' الهوايات ',
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
                              onSaved: (value) {
                                userInfo.skills = value;
                              },
                            ),
                            const SizedBox(height: 32.0),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 90),
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(175, 50),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: CustomColors.lightBlue),
                                child: Text("حفظ", style: TextStyles.text3),
                              ),
                            ),
                          ]))))
        ]));
  }
}
