// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';

import '../interface/StudentClubDetails.dart';
import '../model/SClubInfo.dart';
import '../theme.dart';

class ClubsCard extends StatelessWidget {
  SClubInfo clubDetails;
  int i;
  ClubsCard(this.clubDetails, this.i, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: (){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>  ClubDetails(clubDetails)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.white,
          border: Border.all(color: CustomColors.lightBlue),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: clubDetails.logo == "empty"
                  ? const Image(image: AssetImage('assets/images/mug.png'))
                  : Image.network(
                '${clubDetails.logo}',
                fit: BoxFit.fill,
              ),
              // child:Image.asset( clubDetails)
              // SvgPicture.asset(
              //   details['icon']!,
              //   width: 70,
              //   height: 70,
              //   //color: CustomColors.lightBlue.withOpacity(0.6),
              // ),
            ),
            const SizedBox(height: 5,),
            Text(
               clubDetails.name! ,
              textAlign: TextAlign.center,
              style: TextStyles.heading1L
            ),

          ],
        ),
      ),
    );
  }


}
