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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

             SizedBox(
               width: 95,
               height: 130,
               child: lostItemReport.photo=="empty"?
               const Image(image: AssetImage('assets/images/logo-icon.png')):Image.network('${lostItemReport.photo}'),
             ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical:5 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //start the colom
                mainAxisAlignment: MainAxisAlignment.start,
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
                    mainAxisSize: MainAxisSize.min,
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
                  Row(
                    children: [
                      const Icon(
                        Icons.call,
                        color: CustomColors.lightGrey,
                        size: 14.0,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        lostItemReport.phoneNumber!,
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
