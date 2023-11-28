import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/interface/LostAndFoundScreen.dart';

import '../theme.dart';

class ServiceCard extends StatelessWidget {
  Map<String, dynamic> details;
  int i;
  ServiceCard(this.details, this.i, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        if (i == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LostAndFoundScreen()));
        }
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
              ),
            ),
            Text(
              details['serviceName'],
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
}
