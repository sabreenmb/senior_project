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
          borderRadius: BorderRadius.circular(22),
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
              Text(
                psychGuidanceItem.collage!,
                textAlign: TextAlign.right,
                style: TextStyles.heading1B,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: CustomColors.lightGrey,
                    size: 24.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    psychGuidanceItem.ProLocation!,
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
                    Icons.person_outlined,
                    color: CustomColors.lightGrey,
                    size: 24.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    psychGuidanceItem.ProName!,
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
                    Icons.work_outline,
                    color: CustomColors.lightGrey,
                    size: 24.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    psychGuidanceItem.ProOfficeNumber!,
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
                    Icons.email_outlined,
                    color: CustomColors.lightGrey,
                    size: 24.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    psychGuidanceItem.ProEmail!,
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
        ));
  }
}
