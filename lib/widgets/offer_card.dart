// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';


import '../interface/OfferDetails.dart';
import '../model/offer_info.dart';
import '../theme.dart';

class OfferCard extends StatelessWidget {
  OfferInfo offerInfo;
  OfferCard(this.offerInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap:  () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetails( offerInfo),
          ),
        );
      },
      child: SizedBox(
        height: 100,
        child: Card(
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
                  width: 65,
                  height: 80,
                  child: offerInfo.logo == "empty"
                      ? const Image(image: AssetImage('assets/images/mug.png'))
                      : Image.network(
                    '${offerInfo.logo}',
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: 1,
                  height: 80,
                  color: CustomColors.lightGrey,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //start the colom
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          offerInfo.name!,
                          textAlign: TextAlign.right,
                          style: TextStyles.heading1B,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          " خصم يصل الى  ${offerInfo.discount!}%",
                          textAlign: TextAlign.right,
                          style: TextStyles.text2,
                        ),



                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
