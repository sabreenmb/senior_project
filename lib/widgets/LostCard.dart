import 'package:flutter/material.dart';

import '../model/lost_item_report.dart';
import '../theme.dart';

class LostCard extends StatelessWidget {
  LostItemReport lostItemReport;
  LostCard(this.lostItemReport, {super.key});

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
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [

             SizedBox(
               width: 95,
               height: 130,
               child: lostItemReport.photo=="empty"?
               const Image(image: AssetImage('assets/images/mug.png')):Image.network('${lostItemReport.photo}'),
             ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    lostItemReport.category!,
                    textAlign: TextAlign.right,
                    style: TextStyles.heading3B,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.date_range_outlined,
                        color: CustomColors.lightGrey,
                        size: 14.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        lostItemReport.lostDate!,
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
                        Icons.location_on_outlined,
                        color: CustomColors.lightGrey,
                        size: 14.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        lostItemReport.expectedPlace!,
                        textAlign: TextAlign.right,
                        style: TextStyles.text,

                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    lostItemReport.desription!,
                    textAlign: TextAlign.right,
                    style: TextStyles.text2,

                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
