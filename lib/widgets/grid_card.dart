// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/interface/Clinic.dart';
import 'package:senior_project/interface/OfferCategoryScreen.dart';
import 'package:senior_project/interface/lost_and_found_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../interface/OffersListScreen.dart';
import '../interface/StudentClubsScreen.dart';
import '../interface/VolunteerOpportunities.dart';
import '../interface/event_screen.dart';
import '../interface/psychGuidance.dart';
import '../interface/student_activity_screen.dart';
import '../interface/study_group_screen.dart';
import '../common/theme.dart';

class GridCard extends StatelessWidget {
  Map<String, dynamic> details;
  int i;
  bool isService;
  GridCard(this.details, this.i, this.isService, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        isService ? _navigateOnServises(context) : _navigateOnOffers(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.white,
          border: Border.all(color: CustomColors.lightGreyLowTrans),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: CustomColors.lightGrey.withOpacity(0.5),
              offset: const Offset(0, 5),
              blurRadius: 5.5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SvgPicture.asset(
                  details['icon']!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholderBuilder: (BuildContext context) => Shimmer.fromColors(
                    baseColor: CustomColors.white,
                    highlightColor: CustomColors.highlightColor,
                    child: Container(
                      width: 70,
                      height: 70,
                      color: CustomColors.white,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              isService ? details['serviceName'] : details['offerCategory'],
              textAlign: TextAlign.center,
                style: TextStyles.heading1L,
              )
          ],
        ),
      ),
    );
  }

  void _navigateOnServises(BuildContext context) {
    switch (i) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const LostAndFoundScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VolunteerOp(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const OffersListScreen()));
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StudentClubsScreen(),
          ),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EventScreen(),
          ),
        );
        break;
      case 5:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StudyGroupScreen()));
        break;
      case 6:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StudentActivityScreen(),
          ),
        );
        break;
      case 7:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Clinic(),
        ),
      );
      break;
      case 8:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PsychGuidance(),
        ),
      );
      break;
    }
  }

  void _navigateOnOffers(BuildContext context) async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => OfferCategoryScreen(i, details)));
  }
}
