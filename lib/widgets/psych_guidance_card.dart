import 'package:flutter/material.dart';

import '../model/psych_guidance_report.dart';
import '../theme.dart';

class PGCard extends StatelessWidget {
  PsychGuidanceReport psychGuidanceItem;
  PGCard(this.psychGuidanceItem, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color.fromRGBO(89, 177, 212, 1), // Set the border color here
            width: 2.0, // Set the border width
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
              // const Row(children: [
              //   Icon(
              //     Icons.brain,
              //     color: CustomColors.lightGrey,
              //     size: 18.0,
              //   ),
              //   SizedBox(
              //     width: 5,
              //   ),
              //   Text(
              //     "كيف هو مزاجك اليوم؟",
              //     style: TextStyle(
              //       fontSize: 16,
              //       color: Color(0xff535D74),
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ]),

              const SizedBox(
                height: 5,
              ),
              Text(
                psychGuidanceItem.collage!,
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
                    psychGuidanceItem.ProLocation!,
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
                    psychGuidanceItem.ProName!,
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
                    psychGuidanceItem.ProOfficeNumber!,
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
                    psychGuidanceItem.ProEmail!,
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
