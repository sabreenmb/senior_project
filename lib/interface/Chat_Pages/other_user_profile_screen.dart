// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/model/user_information_model.dart';
import 'package:senior_project/common/theme.dart';
import '../../common/common_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final UserInformationModel otherUserInfo;

  const OtherUserProfileScreen({Key? key, required this.otherUserInfo})
      : super(key: key);

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
          color: CustomColors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, true),
          inAsyncCall: isLoading,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                color: CustomColors.backgroundColor,
                child: Container(
                  height: 370,
                  color: CustomColors.pink,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildProfileImage(),
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
    return Column(
      children: [
        CircleAvatar(
          radius: 90,
          backgroundColor: CustomColors.lightBlueLowTrans.withAlpha(160),
          child: widget.otherUserInfo.imageUrl == ''
              ? Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  height: 150,
                  decoration: BoxDecoration(
                    color: CustomColors.pink,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CustomColors.darkGrey.withOpacity(0.7),
                      width: 2,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/UserProfile.svg',
                    height: 100,
                    width: 100,
                    color: CustomColors.darkGrey,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CustomColors.darkGrey.withOpacity(0.7),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      imageUrl: widget.otherUserInfo.imageUrl,
                      errorWidget: (context, url, error) => Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.topCenter,
                        height: 140,
                        decoration: BoxDecoration(
                          color: CustomColors.pink,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CustomColors.darkGrey.withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/UserProfile.svg',
                          height: 100,
                          width: 100,
                          color: CustomColors.darkGrey,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 7.5),
        Text(widget.otherUserInfo.name, style: TextStyles.subtitleGrey),
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
                child: _buildItemCard(
                    Icons.school, 'الكلية: ', widget.otherUserInfo.collage),
              ),
              Visibility(
                visible: widget.otherUserInfo.major.isNotEmpty,
                child: _buildItemCard(
                    Icons.work, 'التخصص: ', widget.otherUserInfo.major),
              ),
              Visibility(
                visible: widget.otherUserInfo.intrests.isNotEmpty,
                child: _buildItemCard(Icons.favorite, 'الاهتمامات: ',
                    widget.otherUserInfo.intrests),
              ),
              Visibility(
                visible: widget.otherUserInfo.hobbies.isNotEmpty,
                child: _buildItemCard(
                    Icons.sports, 'الهوايات: ', widget.otherUserInfo.hobbies),
              ),
              Visibility(
                visible: widget.otherUserInfo.skills.isNotEmpty,
                child: _buildItemCard(
                    Icons.star, 'المهارات: ', widget.otherUserInfo.skills),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: CustomColors.lightGrey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                icon,
                color: CustomColors.darkGrey.withOpacity(0.75),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.heading1D,
                  ),
                  Text(
                    subtitle,
                    style: TextStyles.heading2D,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
