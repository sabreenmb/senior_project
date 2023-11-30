import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:senior_project/interface/LostAndFoundScreen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../constant.dart';
import '../model/lost_item_report.dart';
import '../theme.dart';

class AddLostItemScreen extends StatefulWidget {
  const AddLostItemScreen({super.key});
  @override
  State<AddLostItemScreen> createState() => _AddLostItemScreenState();
}

class _AddLostItemScreenState extends State<AddLostItemScreen> {
  LostItemReport lostItemReport = LostItemReport(
      id: '',
      photo: '',
      category: '',
      lostDate: '',
      expectedPlace: '',
      phoneNumber: '',
      desription: '');

  File? _selectedImage;
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _imageUrl = 'assets/images/logo-icon.png';
  TextEditingController dateInput = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController controller = TextEditingController();
  // String initialCountry = 'SA';
  // PhoneNumber number = PhoneNumber(isoCode: 'SA');

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
            colorScheme: const ColorScheme.light(primary: CustomColors.lightBlue),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    print('${pickedFile?.path}');
    if (pickedFile == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
    // if (pickedFile != null) {
    //   setState(() {
    //     _imageUrl = pickedFile.path;
    //   });
    // }
  }

  void _checkInputValue() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    //todo right way to store an image

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('lost_images')
        .child('$uniqueFileName.jpg');
    if (_selectedImage == null) {
      _imageUrl = "empty";
    } else {
      try {
        await storageRef.putFile(_selectedImage!);
        _imageUrl = await storageRef.getDownloadURL();
        print(_imageUrl);
      } catch (error) {}
    }

    lostItemReport.photo = _imageUrl;
    _createLostItem();
  }

  void _createLostItem() async {
    final url = Uri.https(
        'senior-project-72daf-default-rtdb.firebaseio.com', 'Lost-Items.json');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(lostItemReport.toJson()),
    );
    print(response.body);
    print(response.statusCode);
    if (!context.mounted) {
      return;
    }
    Navigator.pop(context);
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (context) => LostAndFoundScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final numericRegex = RegExp(r'^[0-9]+$');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        backgroundColor: CustomColors.pink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.white),
          onPressed: () {
            Navigator.pop(context);

            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => LostAndFoundScreen()));
          },
        ),
        title: Text("انشاء اعلان مفقود", style: TextStyles.heading1),
        centerTitle: true,
      ),
      body: SafeArea(
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
                        topRight: Radius.circular(40))),
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
                          //Camera
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
                                        color: CustomColors.lightBlue,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
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
                                                  height: screenWidth * 0.57,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  _imageUrl,
                                                  height: screenWidth * 0.57,
                                                  width: 170,
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          child: Text(
                                            'اضف صورة',
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
                          //Categories
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
                            items: [
                              "بطاقات",
                              'نقود ',
                              'مستندات',
                              'مجوهرات',
                              'ملابس',
                              'إلكترونيات',
                              'أغراض شخصية',
                              'اخرى'
                            ].map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category,
                                  style: TextStyles.heading2,
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
                              lostItemReport.category = _selectedCategory;
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
                          //Lost Date
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: TextFormField(
                                    controller: dateInput,
                                    decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.date_range_outlined,
                                        color: CustomColors.lightGrey,
                                      ),
                                      labelText: "تاريخ الفقدان",
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
                                      DateTime selected = DateTime.parse(value);
                                      DateTime now = DateTime.now();
                                      if (selected.difference(now).inDays > 0) {
                                        return 'اختر تاريخ صحيح';
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    onSaved: (value) {
                                      lostItemReport.lostDate = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //Expected Place
                          const SizedBox(height: 12.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.location_on,
                                color: CustomColors.lightGrey,
                              ),
                              labelText: 'المكان المتوقع',
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // onChanged: (value) {
                            //   setState(() {
                            //     _selectedLocation = value;
                            //   });
                            // },
                            onSaved: (value) {
                              lostItemReport.expectedPlace = value;
                            },
                          ),
                          //Phone
                          // const SizedBox(height: 12.0),
                          // InternationalPhoneNumberInput(
                          //   selectorConfig: const SelectorConfig(
                          //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          //     showFlags: false,
                          //     leadingPadding:
                          //         CircularProgressIndicator.strokeAlignCenter,
                          //   ),
                          //   locale: _selectedCategory,
                          //   inputDecoration: const InputDecoration(
                          //     labelText: 'رقم الجوال',
                          //     focusedBorder: UnderlineInputBorder(
                          //       borderSide: BorderSide(
                          //         color: CustomColors.lightBlue,
                          //       ),
                          //     ),
                          //     enabledBorder: UnderlineInputBorder(
                          //       borderSide: BorderSide(
                          //         color: CustomColors.lightBlue,
                          //       ),
                          //     ),
                          //   ),
                          //   textAlignVertical: TextAlignVertical.top,
                          //   keyboardType: TextInputType.phone,
                          //   validator: (phone) {
                          //     if (phone == null) {
                          //       return 'الرجاء تعبئة الحقل';
                          //     } else if (phone.toString().startsWith('9')) {
                          //       return "رقم الجوال يجب أن يبدأ بـ 5";
                          //     }
                          //   },
                          //   autoValidateMode:
                          //       AutovalidateMode.onUserInteraction,
                          //   onSaved: (phone) {
                          //     lostItemReport.expectedPlace = phone.toString();
                          //   },
                          //   onInputChanged: (PhoneNumber value) {
                          //     print(value.phoneNumber);
                          //   },
                          // ),
                          const SizedBox(height: 12.0),
                          IntlPhoneField(
                            decoration: const InputDecoration(
                              labelText: 'رقم الجوال',
                              // suffixIcon: Icon(
                              //   Icons.phone,
                              //   color: CustomColors.lightGrey,
                              // ),
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
                            textAlignVertical: TextAlignVertical.top,
                            languageCode: 'ar',
                            initialCountryCode: 'SA',
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (phone) {
                              if (phone == null) {
                                return 'الرجاء تعبئة الحقل';
                              } else if (phone.toString().startsWith('9')) {
                                return "رقم الجوال يجب أن يبدأ بـ 5";
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onSaved: (phone) {
                              lostItemReport.expectedPlace = phone.toString();
                            },
                          ),
                          //Description
                          const SizedBox(height: 12.0),
                          TextFormField(
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // onChanged: (value) {
                            //   setState(() {
                            //     _description = value;
                            //   });
                            // },
                            onSaved: (value) {
                              lostItemReport.desription = value;
                            },
                          ),
                          //Submit Button
                          const SizedBox(height: 32.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
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
    );
  }
}
