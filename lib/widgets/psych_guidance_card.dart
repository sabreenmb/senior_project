import 'package:flutter/material.dart';

import '../constant.dart';
import '../model/psych_guidance_report.dart';
import '../theme.dart';

class PGCard extends StatelessWidget {
  // PsychGuidanceReport psychGuidanceItem;
  PGCard( {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color.fromRGBO(89, 177, 212, 1),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(22.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            //start the colom
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                pg.collage!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 20,
                  color: CustomColors.lightBlue,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: CustomColors.lightGrey,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    pg.ProLocation!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      color: CustomColors.lightGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.person_outlined,
                    color: CustomColors.lightGrey,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    pg.ProName!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      color: CustomColors.lightGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.work_outline,
                    color: CustomColors.lightGrey,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    pg.ProOfficeNumber!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      color: CustomColors.lightGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: CustomColors.lightGrey,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    pg.ProEmail!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      color: CustomColors.lightGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ));
  }
}
