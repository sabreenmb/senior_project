// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/interface/OfferCategoryScreen.dart';
import 'package:senior_project/interface/lost_and_found_screen.dart';

import '../interface/OffersListScreen.dart';
import '../interface/study_group.dart';
import '../theme.dart';

class GridCard extends StatelessWidget {
  Map<String, dynamic> details;
  int i;
  bool isServises;
  GridCard(this.details, this.i, this.isServises, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: (){
        isServises?_navigateOnServises(context):_navigateOnOffers(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.white,
          border: Border.all(color: CustomColors.lightGreyLowTrans),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: const [
            BoxShadow(
              color: CustomColors.lightGreyLowTrans,
              offset: Offset(
                0.0,
                10.0,
              ),
              blurRadius: 7.5,
            ),
            BoxShadow(
              color: Color.fromARGB(0, 255, 255, 255),
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: SvgPicture.asset(
                details['icon']!,
                width: 70,
                height: 70,
                //color: CustomColors.lightBlue.withOpacity(0.6),
              ),
            ),
            Text(
              isServises ? details['serviceName'] : details['offerCategory'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomColors.lightGrey,
              ),
            ),
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
      // Add cases for other services as needed

      // case 1:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LostAndFoundScreen(),
      //   ),
      // );
      // break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const OffersListScreen()));

        break;
      // case 3:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LostAndFoundScreen(),
      //   ),
      // );
      // break;
      // case 4:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LostAndFoundScreen(),
      //   ),
      // );
      // break;
      case 5:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StudyGroup()));
        break;
      // case 6:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LostAndFoundScreen(),
      //   ),
      // );
      // break;
      // case 7:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LostAndFoundScreen(),
      //   ),
      // );
      // break;
      // case 0:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LostAndFoundScreen(),
      //   ),
      // );
      // break;
      // Add cases for other services as needed
    }
  }

  void _navigateOnOffers(BuildContext context) {
    switch (i) {
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>  OfferCategoryScreen(i,details)));
        break;
    }
  }
}
