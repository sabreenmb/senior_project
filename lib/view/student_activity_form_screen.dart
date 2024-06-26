// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_local_variable

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/model/student_activity_model.dart';

import '../common/common_functions.dart';
import '../common/constant.dart';
import '../common/theme.dart';

class StdActivityFormScreen extends StatefulWidget {
  const StdActivityFormScreen({super.key});

  @override
  State<StdActivityFormScreen> createState() => _StdActivityFormScreenState();
}

class _StdActivityFormScreenState extends State<StdActivityFormScreen> {
  StudentActivityModel studentActivityItem = StudentActivityModel(
      id: '', name: '', date: '', time: '', location: '', numOfPerson: '');
  DateTime _selectedDate = DateTime.now();
  TextEditingController dateInput = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  TimeOfDay _selectedTime =
      TimeOfDay.now(); // Use TimeOfDay to represent the selected time
  TextEditingController timeInput = TextEditingController();

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
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
    } finally {
      setState(() {
        isLoading = false;
        FocusScope.of(context).unfocus();
      });
    }
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
        body: json.encode(studentActivityItem.toJson()),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error in creating student activity');
      }
    }

    if (!context.mounted) {
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text("انشاء نشاط", style: TextStyles.pageTitle),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          color: CustomColors.black,
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
                                  studentActivityItem.name = value;
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
                                          studentActivityItem.date = value;
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
                                          return null;
                                        },
                                        onSaved: (value) {
                                          studentActivityItem.time = value;
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
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.location_on,
                                    color: CustomColors.lightGrey,
                                  ),
                                  labelText: 'مكان النشاط',
                                  hintText:
                                      'مثال: مبنى كلية العلوم، بهو كلية الحاسبات...',
                                  hintStyle: TextStyles.text1D,
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColors.lightBlue,
                                    ),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
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
                                  studentActivityItem.location = value;
                                },
                              ),
                              Text(
                                '* ملاحظة:  الرجاء التاكد من ان المكان متاح في الوقت المطلوب',
                                style: TextStyles.text1D,
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(
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
                                  studentActivityItem.numOfPerson = value;
                                },
                              ),
                              const SizedBox(height: 32.0),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 90),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (isOffline) {
                                      showNetWidgetDialog(context);
                                    } else {
                                      _checkInputValue();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(175, 50),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: CustomColors.lightBlue),
                                  child:
                                      Text("انشاء", style: TextStyles.btnText),
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
