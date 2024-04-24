import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/student_club_model.dart';
import '../common/theme.dart';

class StudentClubDetails extends StatefulWidget {
  StudentClubModel clubDetails;
  StudentClubDetails(this.clubDetails, {super.key});
  @override
  State<StudentClubDetails> createState() => _StudentClubDetailsState();
}

class _StudentClubDetailsState extends State<StudentClubDetails> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    StudentClubModel clubDetails = widget.clubDetails;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: const BoxDecoration(
                      color: CustomColors.darkGrey,
                    ),
                  ),
                  Positioned(
                    child: AppBar(
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.light,
                        statusBarBrightness: Brightness.light,
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: CustomColors.white),
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SearchScreen()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 670,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      margin: const EdgeInsets.only(top: 200),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0,horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              clubDetails.name!,
                              textAlign: TextAlign.center,
                              style: TextStyles.heading1D,
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  clubDetails.details!,
                                  textAlign: TextAlign.center,
                                  maxLines: 8,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.heading3B,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _buildInfoColumn(
                                "قائد/ة النادي:  ", clubDetails.leader!),
                            _buildInfoColumn(
                                "موعد فتح التسجيل:  ", clubDetails.regTime!),
                            _buildInfoColumn(
                                "وسيلة التواصل : ", clubDetails.contact!),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes the position of the shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 80,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: clubDetails.logo == "empty"
                              ? Image(
                                  image:
                                      AssetImage('assets/images/logo-icon.png'))
                              : FutureBuilder<void>(
                                  future: precacheImage(
                                    CachedNetworkImageProvider(
                                        clubDetails.logo!),
                                    context,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.white,
                                        highlightColor: Colors.grey[300]!,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'Error loading image'); // Handle error loading image
                                    } else {
                                      return CachedNetworkImage(
                                        imageUrl: clubDetails.logo!,
                                        fit: BoxFit.contain,
                                      );
                                    }
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (clubDetails.membersLink == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('التسجيل غير متاح حاليًا. '),
                              duration: const Duration(seconds: 2),
                              backgroundColor: CustomColors.darkGrey,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        } else {
                          _launchURL(clubDetails.membersLink!, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(160, 40),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        backgroundColor: CustomColors.lightBlue,
                      ),
                      child: Text("انضم للأعضاء", style: TextStyles.btnText),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (clubDetails.mngLink == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('التسجيل غير متاح حاليًا. '),
                              duration: const Duration(seconds: 2),
                              backgroundColor: CustomColors.darkGrey,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        } else {
                          _launchURL(clubDetails.mngLink!, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(160, 40),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        backgroundColor: CustomColors.lightBlue,
                      ),
                      child: Text("انضم للإدارة", style: TextStyles.btnText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String? urlString, BuildContext context) async {
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The URL is not available.')),
      );
      return;
    }
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  Widget _buildInfoColumn(String label, String value) {
    double width = MediaQuery.of(context).size.width / 20;
    print(width);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.text1D,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              style: TextStyles.text1L,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
