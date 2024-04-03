import 'package:flutter/material.dart';

import '../model/psych_guidance_report.dart';
import '../theme.dart';

class PGCard extends StatelessWidget {
  PsychGuidanceReport psychGuidanceReport;
  PGCard(this.psychGuidanceReport, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              //start the colom
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  psychGuidanceReport.collage!,
                  textAlign: TextAlign.right,
                  style: TextStyles.heading3B,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      psychGuidanceReport.location!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      psychGuidanceReport.name!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      psychGuidanceReport.email!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )
        ]));
  }
}
