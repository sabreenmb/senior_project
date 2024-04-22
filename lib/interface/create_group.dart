// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
//import 'package:senior_project/interface/LostAndFoundScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/model/create_group_report.dart';

import '../constant.dart';
//import '../model/found_item_report.dart';
import '../theme.dart';
import '../widgets/networkWedget.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  CreateGroupReport createGroupReport = CreateGroupReport(
      id: '', name: '', date: '', time: '', location: '', numPerson: '');
  // bool imageEmpty = false;
  String? _selectedSubject;
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
    _createGroupState();
  }

  void _createGroupState() async {
    try {
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'create-group.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(createGroupReport.toJson()),
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
          title: Text("انشاء جلسة مذاكرة", style: TextStyles.heading1),
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
                              SizedBox(
                                width: 100,
                                child: DropdownButtonFormField2<String>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.book_outlined,
                                      color: CustomColors.lightGrey,
                                    ),
                                    labelText: 'اسم و رمز المادة',
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
                                  value: _selectedSubject,
                                  items: SubjectsCode.map((name) {
                                    return DropdownMenuItem(
                                      value: name,
                                      child: Text(
                                        name,
                                        style: TextStyles.heading2,
                                        overflow: TextOverflow
                                            .ellipsis, // Add this line
                                        maxLines: 2,
                                      ),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'الرجاء تعبئة الحقل';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSubject = value!;
                                    });
                                  },
                                  onSaved: (value) {
                                    createGroupReport.name = _selectedSubject;
                                  },
                                  //هذا اللاين حق الكود مو راضي ينحذف ولازم احذفه
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: CustomColors.darkGrey,
                                    ),
                                    iconSize: 24,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
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
                                          labelText: "تاريخ الجلسة",
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
                                          createGroupReport.date = value;
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
                                          labelText: "وقت الجلسة",
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
                                          createGroupReport.time = value;
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
                                  labelText: 'مكان الجلسة',
                                  hintText: 'مثال: المقهى، المكتبة، البهو...',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 175, 175, 175),
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
                                  createGroupReport.location = value;
                                },
                              ),
                              const Text(
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
                                  } else {
                                    final int? number = int.tryParse(value);
                                    if (number == null) {
                                      return 'الرجاء إدخال رقم صحيح';
                                    } else if (number <= 2) {
                                      return 'الرجاء إدخال رقم أكبر من 2';
                                    } else if (number >= 100) {
                                      return 'الرجاء إدخال رقم أقل من 100';
                                    }
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  createGroupReport.numPerson = value;
                                },
                              ),
                              const SizedBox(height: 32.0),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 90),
                                child: ElevatedButton(
                                  onPressed:(){if(isOffline){showNetWidgetDialog(context);}else{
                                    _checkInputValue();}},
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
