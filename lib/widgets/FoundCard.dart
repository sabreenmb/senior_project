import 'package:flutter/material.dart';

import '../model/found_item_report.dart';
import '../theme.dart';

class FoundCard extends StatelessWidget {
  FoundItemReport foundItemReport;
  FoundCard(this.foundItemReport, {super.key});

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
              child: foundItemReport.photo=="empty"?
              const Image(image: AssetImage('assets/images/mug.png')):Image.network('${foundItemReport.photo}'),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    foundItemReport.category!,
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
                        foundItemReport.foundDate!,
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
                        foundItemReport.receivePlace!,
                        textAlign: TextAlign.right,
                        style: TextStyles.text,

                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    foundItemReport.desription!,
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
