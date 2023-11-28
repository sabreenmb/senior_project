import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:senior_project/interface/LostAndFoundScreen.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';

class LostItemAddScreen extends StatefulWidget {
  @override
  _LostItemAddScreenState createState() => _LostItemAddScreenState();
}

class _LostItemAddScreenState extends State<LostItemAddScreen> {
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _selectedLocation = '';
  String _description = '';
  String _imageUrl = '';
  TextEditingController dateInput = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateInput.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  void _createLostItem() async{
    final url = Uri.https(
        'senior-project-72daf-default-rtdb.firebaseio.com', 'Lost-Items.json');
    final response=await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {'test': "name", 'val': '15'},
      ),
    );
    print(response.body);
    print(response.statusCode);
    if(!context.mounted){
      return;
    }
    Navigator.pop(context);
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (context) => LostAndFoundScreen()));


  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        backgroundColor: CustomColors.pink,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColors.white),
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
            SizedBox(height: 15),
            Expanded(
                child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
              ),
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: _takePhoto,
                          child: Column(
                            children: [
                              Container(
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
                                        child: _imageUrl.isNotEmpty
                                            ? Image.file(
                                                File(_imageUrl),
                                                height: screenWidth * 0.57,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                AppConstants.uploadpic,
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
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                          items: ['الكترونيات', 'اغراض شخصية', 'اخرى']
                              .map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                style: TextStyles.heading2,
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
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
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: TextField(
                                  controller: dateInput,
                                  decoration: InputDecoration(
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
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        TextFormField(
                          decoration: InputDecoration(
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
                          onChanged: (value) {
                            setState(() {
                              _selectedLocation = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12.0),
                        TextFormField(
                          maxLines: 1,
                          decoration: InputDecoration(
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
                          onChanged: (value) {
                            setState(() {
                              _description = value;
                            });
                          },
                        ),
                        const SizedBox(height: 32.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 90),
                          child: ElevatedButton(
                            onPressed: _createLostItem,
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(175, 40),
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
                ],
              ),
            ]))
          ],
        ),
      ),
    );
  }
}

class AppConstants {
  static const String uploadpic = 'assets/images/logo-icon.png';
}
