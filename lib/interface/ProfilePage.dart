// ignore_for_file: dead_code

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
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
  String? _image;
  void _submit() async {
    _formKey.currentState!.save();
    // updateProfilePicture(File(_image!));
    try {
      // Save data to Firestore
      await userProfileDoc.update({
        'image_url': userInfo.image_url,
        'intrests': userInfo.intrests,
        'hobbies': userInfo.hobbies,
        'skills': userInfo.skills,
        'offersPreferences': userInfo.offersPreferences,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث البيانات بنجاح'),
          duration: const Duration(seconds: 1),
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

  Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${userInfo.userID}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    //updating image in firestore database
    userInfo.image_url = await ref.getDownloadURL();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .03,
                bottom: MediaQuery.of(context).size.height * .05),
            children: [
              //pick profile picture label
              const Text('اختر صورة للملف الشخصي',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: MediaQuery.of(context).size.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const BeveledRectangleBorder(),
                        shadowColor: CustomColors.lightGreyLowTrans,
                        fixedSize: Size(MediaQuery.of(context).size.width * .3,
                            MediaQuery.of(context).size.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        // log('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });
                        updateProfilePicture(File(_image!));
                        // for hiding bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    // child: Container(),
                    child: Image.asset(
                      'assets/images/logo-icon.png',
                    ),
                  ),

                  //take picture from camera button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.white,
                        shape: const BeveledRectangleBorder(),
                        shadowColor: CustomColors.lightGreyLowTrans,
                        fixedSize: Size(MediaQuery.of(context).size.width * .3,
                            MediaQuery.of(context).size.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        // log('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                          // updateProfilePicture(File(_image!));
                        });
                        updateProfilePicture(File(_image!));
                        // APIs.updateProfilePicture(File(_image!));
                        // for hiding bottom sheet
                        Navigator.pop(context);
                      }
                    },

                    // child: Container(),
                    child: Image.asset(
                      'assets/images/take_photo.png',
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // _snapshot();
    //// ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: CustomColors.pink,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: CustomColors.pink,
            elevation: 0,
            title: Text("الملف الشخصي", style: TextStyles.heading1),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: CustomColors.darkGrey),
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
                            Container(
                              // color: Colors.cyan,
                              // margin: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      // const SizedBox(height: 12.0),
                                      children: [
                                        CircleAvatar(
                                          radius: 80,
                                          backgroundColor: const Color.fromARGB(
                                              0, 15, 66, 186),
                                          child: Stack(
                                            children: [
                                              userInfo.image_url == ''
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      alignment:
                                                          Alignment.topCenter,
                                                      height: 140,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
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
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: CachedNetworkImage(
                                                        width: 140,
                                                        height: 140,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            userInfo.image_url,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            CircleAvatar(
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/UserProfile.svg',
                                                            height: 100,
                                                            width: 100,
                                                            color: CustomColors
                                                                .darkGrey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              Positioned(
                                                right: -9,
                                                bottom: 3,
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      CustomColors.white,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.camera_alt_rounded,
                                                      //Icons.camera_rounded,
                                                      color: CustomColors
                                                          .lightBlue,
                                                      size: 35,
                                                    ),
                                                    onPressed: () {
                                                      _showBottomSheet();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          userInfo.name,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: CustomColors.lightBlue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          userInfo.collage,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: CustomColors.darkGrey),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          userInfo.major,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: CustomColors.darkGrey),
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                            userInfo.intrests = value!;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                            userInfo.hobbies = value!;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: const InputDecoration(
                                            labelText:
                                                ' ما يمكنك اضافتة للمجتمع؟ ',
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
                                            userInfo.skills = value!;
                                          },
                                        ),
                                        const SizedBox(height: 20.0),
                                        Column(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 15.0),
                                              alignment: Alignment.centerRight,
                                              // color: Colors.amber,
                                              child: const Text(
                                                'اختر تفضيلات العروض:',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        CustomColors.darkGrey),
                                              ),
                                            ),
                                            SizedBox(
                                              // color: Color.fromARGB(
                                              //     255, 253, 229, 226),
                                              height: 105,
                                              // width: 32,
                                              child: ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: [
                                                  ...List.generate(
                                                    offers.length,
                                                    (index) => OfferItem(
                                                      index: index,
                                                      onSelected: (bool value) {
                                                        fun(value, index);
                                                        print(
                                                            "oooooooooooooooooooooooooooooooooooooooooooooooooo");
                                                        print(userInfo
                                                            .offersPreferences);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 40.0),
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
        ),
      ),
    );
  }

  void fun(bool value, int index) {
    bool found = false;
    if (value) {
      if (userInfo.offersPreferences[offers[index]['offerCategory']] == false) {
        userInfo.offersPreferences[offers[index]['offerCategory']] = true;
      }
    } else {
      if (userInfo.offersPreferences[offers[index]['offerCategory']] == true) {
        userInfo.offersPreferences[offers[index]['offerCategory']] = false;
      }
    }
  }
}

class OfferItem extends StatefulWidget {
  final int index;
  final ValueChanged<bool> onSelected;

  const OfferItem({super.key, required this.index, required this.onSelected});

  @override
  State<OfferItem> createState() => _OfferItemState();
}

class _OfferItemState extends State<OfferItem> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onSelected(_isSelected);
        });
      },
      child: Container(
        width: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: userInfo.offersPreferences[offers[widget.index]
                            ['offerCategory']] ==
                        true
                    ? Border.all(color: CustomColors.lightBlue, width: 2.0)
                    : null,
              ),
              child: SvgPicture.asset(
                offers[widget.index]['icon']!,
                width: 28,
                height: 28,
                color: CustomColors.lightBlue,
              ),
            ),
            // const SizedBox(
            //   height: 8.0,
            // ),
            Container(
              alignment: Alignment.center,
              child: Text(
                offers[widget.index]['offerCategory'],
                style: TextStyles.text2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
