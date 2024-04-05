// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:senior_project/interface/LostAndFoundScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/model/create_student_activity_report.dart';

import '../constant.dart';
//import '../model/found_item_report.dart';
import '../theme.dart';

class CreateStudentActivity extends StatefulWidget {
  const CreateStudentActivity({super.key});

  @override
  State<CreateStudentActivity> createState() => _CreateStudentActivityState();
}

class _CreateStudentActivityState extends State<CreateStudentActivity> {
  CreateStudentActivityReport createStudentActivityReport =
      CreateStudentActivityReport(
          id: '', name: '', date: '', time: '', location: '', numOfPerson: '');
  // bool imageEmpty = false;
  DateTime _selectedDate = DateTime.now();
  TextEditingController dateInput = TextEditingController();

  // String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  final _formKey = GlobalKey<FormState>();

  //get _checkInputValue => null;

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = _selectedDate;
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: CustomColors.lightBlue,
            hintColor: CustomColors.lightBlue,
            colorScheme:
                const ColorScheme.light(primary: CustomColors.lightBlue),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != currentDate) {
      setState(() {
        _selectedDate = picked;
        dateInput.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  TimeOfDay _selectedTime =
      TimeOfDay.now(); // Use TimeOfDay to represent the selected time
  TextEditingController timeInput = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        timeInput.text = _selectedTime
            .format(context); // Update the text field with the selected time
      });
    }
  }

  void _checkInputValue() async {
    final isValid = _formKey.currentState!.validate();
    // if (_selectedImage == null) {
    //   setState(() {
    //     imageEmpty = true;
    //   });
    // }
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    // final storageRef = FirebaseStorage.instance.ref();
    // .child('found_images')
    // .child('$uniqueFileName.jpg');

    try {
      setState(() {
        isLoading = true;
      });
      // await storageRef.putFile(_selectedImage!);
      // _imageUrl = await storageRef.getDownloadURL();
      // print(_imageUrl);
    } finally {
      setState(() {
        isLoading = false;
        FocusScope.of(context).unfocus();
      });
    }

    // foundItemReport.photo = _imageUrl;
    _createStudentActivityState();
  }

  void _createStudentActivityState() async {
    try {
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'create-activity.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(createStudentActivityReport.toJson()),
      );
    } catch (e) {}

    if (!context.mounted) {
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          backgroundColor: CustomColors.pink,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: CustomColors.darkGrey),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          title: Text("انشاء نشاط", style: TextStyles.heading1),
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
                    child: Stack(children: [
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
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 12.0),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  labelText: 'اسم النشاط',
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
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء تعبئة الحقل';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  createStudentActivityReport.name = value;
                                },
                              ),
                              const SizedBox(height: 12.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: dateInput,
                                        decoration: const InputDecoration(
                                          suffixIcon: Icon(
                                            Icons.date_range_outlined,
                                            color: CustomColors.lightGrey,
                                          ),
                                          labelText: "تاريخ النشاط",
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
                                        readOnly: true,
                                        onTap: () async {
                                          await _selectDate(context);
                                        },
                                        validator: (value) {
                                          print(value);
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'الرجاء تعبئة الحقل';
                                          }
                                          DateTime selected =
                                              DateTime.parse(value);
                                          DateTime now = DateTime.now();
                                          if (selected.difference(now).inDays <
                                              0) {
                                            return 'اختر تاريخ صحيح';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          createStudentActivityReport.date =
                                              value;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller:
                                            timeInput, // Use the new controller for the time picker
                                        decoration: const InputDecoration(
                                          suffixIcon: Icon(
                                            Icons.timer_sharp,
                                            color: CustomColors.lightGrey,
                                          ),
                                          labelText: "وقت النشاط",
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
                                        readOnly: true,
                                        onTap: () async {
                                          await _selectTime(
                                              context); // Use _selectTime instead of _selectDate
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'الرجاء تعبئة الحقل';
                                          }
                                          // Add additional validation if needed
                                          return null;
                                        },
                                        onSaved: (value) {
                                          createStudentActivityReport.time =
                                              value;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.location_on,
                                    color: CustomColors.lightGrey,
                                  ),
                                  labelText: 'مكان النشاط',
                                  hintText:
                                      'مثال: مبنى كلية العلوم، بهو كلية الحاسبات...',
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 175, 175, 175),
                                  ),
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
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء تعبئة الحقل';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  createStudentActivityReport.location = value;
                                },
                              ),
                              Text(
                                '* ملاحظة:  الرجاء التاكد من ان المكان متاح في الوقت المطلوب',
                                style: TextStyle(
                                  color: CustomColors.darkGrey,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(
                                    //تغيير الايقونه هنا
                                    Icons.people,
                                    color: CustomColors.lightGrey,
                                  ),
                                  labelText: '  عدد الاشخاص',
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
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء تعبئة الحقل';
                                  } else if (!RegExp(r'^\d+$')
                                      .hasMatch(value)) {
                                    return 'الرجاء إدخال أرقام فقط';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  createStudentActivityReport.numOfPerson =
                                      value;
                                },
                              ),
                              const SizedBox(height: 32.0),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 90),
                                child: ElevatedButton(
                                  onPressed: _checkInputValue,
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(175, 50),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: CustomColors.lightBlue),
                                  child: Text("انشاء", style: TextStyles.text3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
