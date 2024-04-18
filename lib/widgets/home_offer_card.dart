// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../interface/OfferDetails.dart';
import '../model/offer_info.dart';

class HomeOfferCard extends StatelessWidget {
  OfferInfo offerInfo;
  HomeOfferCard(this.offerInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetails(offerInfo),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(89, 177, 212, 1), width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 3),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        height: 180,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: 300,
            height: 80,
            // child: Text(
            //   "offerInfo.category.toString()",
            //   textAlign: TextAlign.center,
            // ),
            child: offerInfo.logo == "empty"
                ? const Image(image: AssetImage('assets/images/mug.png'))
                : CachedNetworkImage(
                    imageUrl: offerInfo.logo!,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ),
    );
  }
}
