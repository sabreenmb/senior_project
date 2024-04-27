
// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../common/common_functions.dart';
import '../model/student_club_model.dart';
import '../common/theme.dart';

class SClubDetailsScreen extends StatelessWidget {
  final StudentClubModel sClubDetails;
  const SClubDetailsScreen(this.sClubDetails, {super.key});
  @override
  Widget build(BuildContext context) {
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
                              sClubDetails.name!,
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
                                  sClubDetails.details!,
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
                                "قائد/ة النادي:  ", sClubDetails.leader!),
                            _buildInfoColumn(
                                "موعد فتح التسجيل:  ", sClubDetails.regTime!),
                            _buildInfoColumn(
                                "وسيلة التواصل : ", sClubDetails.contact!),
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

                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          height: 80,
                          child: sClubDetails.logo == "empty"
                              ? Container(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/icons/students-clubs.svg',
                                height: 100,
                                width: 100,
                                color: CustomColors.darkGrey,
                              ))
                              : CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: sClubDetails.logo!,
                              errorWidget: (context, url, error) =>
                                  Container(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        'assets/icons/students-clubs.svg',
                                        height: 100,
                                        width: 100,
                                        color: CustomColors.darkGrey,
                                      ))
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
                        if (sClubDetails.membersLink == "") {
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
                          launchURL(sClubDetails.membersLink!, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(160, 40),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        backgroundColor: sClubDetails.membersLink == ""?CustomColors.lightGrey:CustomColors.lightBlue,
                      ),
                      child: Text("انضم للأعضاء", style: TextStyles.btnText),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (sClubDetails.mngLink == "") {
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
                          launchURL(sClubDetails.mngLink!, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(160, 40),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        backgroundColor:sClubDetails.mngLink == ""?CustomColors.lightGrey: CustomColors.lightBlue,
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

  Widget _buildInfoColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyles.text1D.copyWith(height: 1.5),
                  ),
                  TextSpan(
                    text: ' $value',
                    style: TextStyles.text1L.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
