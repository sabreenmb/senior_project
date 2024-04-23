import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/model/entered_user_info.dart';
import 'package:senior_project/common/theme.dart';
import '../../common/common_functions.dart';
import '../../common/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final UserInformation otherUserInfo;

  const OtherUserProfileScreen({Key? key, required this.otherUserInfo})
      : super(key: key);

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text(
            "المعلومات الشخصية",
            style: TextStyles.pageTitle,
          ),
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: CustomColors.darkGrey),
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
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 330,
                  decoration: const BoxDecoration(
                    color: CustomColors.pink,
                  ),
                ),
                color: CustomColors.backgroundColor, // Pink background color
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildProfileImage(),
                    _buildUserInfo(),
                    _buildDetailsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 90,
      backgroundColor: const Color.fromARGB(0, 32, 57, 113),
      child: Stack(
        children: [
          _buildProfileImageContent(),
        ],
      ),
    );
  }

  Widget _buildProfileImageContent() {
    return widget.otherUserInfo.image_url == ''
        ? Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: CustomColors.darkGrey,
                width: 3,
              ),
            ),
            child: SvgPicture.asset(
              'assets/icons/UserProfile.svg',
              height: 100,
              width: 100,
              color: CustomColors.darkGrey,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                imageUrl: widget.otherUserInfo.image_url,
                errorWidget: (context, url, error) => Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.topCenter,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CustomColors.darkGrey,
                          width: 3,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/UserProfile.svg',
                        height: 100,
                        width: 100,
                        color: CustomColors.darkGrey,
                      ),
                    )

                //  CircleAvatar(
                //   child: SvgPicture.asset(
                //     'assets/icons/UserProfile.svg',
                //     height: 100,
                //     width: 100,
                //     color: CustomColors.darkGrey,
                //   ),
                // ),
                ),
          );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          widget.otherUserInfo.name,
          style: const TextStyle(
            fontSize: 20,
            color: CustomColors.darkGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: widget.otherUserInfo.collage.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background color
                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.school,
                      color: CustomColors.darkGrey,
                    ),
                    title: const Text(
                      'الكلية: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                    subtitle: Text(
                      widget.otherUserInfo.collage,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.otherUserInfo.major.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background color
                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.work,
                      color: CustomColors.darkGrey,
                    ),
                    title: const Text(
                      'التخصص: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                    subtitle: Text(
                      widget.otherUserInfo.major,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.otherUserInfo.intrests.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background color
                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: CustomColors.darkGrey,
                    ),
                    title: const Text(
                      'الاهتمامات: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                    subtitle: Text(
                      widget.otherUserInfo.intrests,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.otherUserInfo.hobbies.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background color
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.sports,
                      color: CustomColors.darkGrey,
                    ),
                    title: const Text(
                      'الهوايات: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                    subtitle: Text(
                      widget.otherUserInfo.hobbies,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.otherUserInfo.skills.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background color
                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.star, color: CustomColors.darkGrey),
                    title: const Text(
                      'المهارات: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                    subtitle: Text(
                      widget.otherUserInfo.skills,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
