import 'package:flutter/material.dart';

import '../model/lost_item_report.dart';
import '../theme.dart';

class LostAndFoundCard extends StatelessWidget {
  LostItemReport lostItemReport;
  LostAndFoundCard(this.lostItemReport, {super.key});

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
            const Image(
              image: AssetImage('assets/images/mug.png'),
              width: 95,
              height: 130,
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
                  SizedBox(
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
                  SizedBox(
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
                  SizedBox(
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
