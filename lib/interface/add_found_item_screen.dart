// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
//import 'package:senior_project/interface/LostAndFoundScreen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../common/common_functions.dart';
import '../common/constant.dart';
import '../common/firebase_api.dart';
import '../model/found_item_report.dart';
import '../common/theme.dart'; //.



class AddFoundItemScreen extends StatefulWidget {
  const AddFoundItemScreen({super.key});

  @override
  State<AddFoundItemScreen> createState() => _AddFoundItemState();
}

class _AddFoundItemState extends State<AddFoundItemScreen> {
  List<String> categories = [
    'بطاقات',
    'نقود',
    'مستندات',
    'مجوهرات',
    'ملابس',
    'إلكترونيات',
    'أغراض شخصية',
    'اخرى'
  ];
  FoundItemModel foundItemReport = FoundItemModel(
      id: '',
      photo: '',
      category: '',
      foundDate: '',
      foundPlace: '',
      receivePlace: '',
      desription: '');
  bool imageEmpty = false;
  File? _selectedImage;
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _imageUrl = '';
  TextEditingController dateInput = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = _selectedDate;
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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

  void _takePhoto() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedFile.path);
      imageEmpty = false;
    });
  }

  void _checkInputValue() async {
    final isValid = _formKey.currentState!.validate();
    if (_selectedImage == null) {
      setState(() {
        imageEmpty = true;
      });
    }
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    final storageRef =
        FirebaseAPI.fireStorageRef('found_images', uniqueFileName);

    try {
      setState(() {
        isLoading = true;
      });
      await storageRef.putFile(_selectedImage!);
      _imageUrl = await storageRef.getDownloadURL();
      print(_imageUrl);
    } finally {
      setState(() {
        isLoading = false;
        FocusScope.of(context).unfocus();
      });
    }

    foundItemReport.photo = _imageUrl;
    _createFoundItem();
  }

  void _createFoundItem() async {
    try {
      final response = await http.post(
        FirebaseAPI.url('Found-Items'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(foundItemReport.toJson()),
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
          title: Text("انشاء اعلان موجود", style: TextStyles.pageTitle),
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
                              InkWell(
                                onTap: _takePhoto,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: screenWidth * 0.57 + 2.0,
                                      width: double.infinity,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: imageEmpty
                                                ? Colors.red
                                                : CustomColors.lightBlue,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                              child: _selectedImage != null
                                                  ? Image.file(
                                                      _selectedImage!,
                                                      height:
                                                          screenWidth * 0.57,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/take_photo.png',
                                                      //  _imageUrl,
                                                      height:
                                                          screenWidth * 0.57,
                                                      width: 170,
                                                      fit: BoxFit.contain,
                                                    ),
                                            ),
                                            Positioned(
                                              bottom: 8,
                                              child: Text(
                                                'التقط صورة',
                                                style: TextStyles.heading3B,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12.0),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              DropdownButtonFormField2<String>(
                                decoration: const InputDecoration(
                                  labelText: 'اختر تصنيف',
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
                                value: _selectedCategory,
                                items: categories.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: TextStyles.heading2D,
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
                                    _selectedCategory = value!;
                                  });
                                },
                                onSaved: (value) {
                                  foundItemReport.category = _selectedCategory;
                                },
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: CustomColors.darkGrey,
                                  ),
                                  iconSize: 24,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                                          labelText: "تاريخ العثور",
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
                                          if (selected.difference(now).inDays >
                                              0) {
                                            return 'اختر تاريخ صحيح';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          foundItemReport.foundDate = value;
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
                                  labelText: 'مكان العثور',
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
                                  foundItemReport.foundPlace = value;
                                },
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.map,
                                    color: CustomColors.lightGrey,
                                  ),
                                  labelText: 'مكان استلام العنصر',
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
                                  foundItemReport.receivePlace = value;
                                },
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  labelText: 'وصف العنصر',
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
                                  foundItemReport.desription = value;
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
                                  child: Text("انشاء", style: TextStyles.btnText),
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
