// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


import '../interface/OfferDetails.dart';
import '../model/offer_info.dart';
import '../common/theme.dart';

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
            ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 65,
              height: 80,
              child: offerInfo.logo == "empty"
                  ? Image(image: AssetImage('assets/images/logo-icon.png'))
                  : FutureBuilder<void>(
                future: precacheImage(
                  CachedNetworkImageProvider(offerInfo.logo!),
                  context,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey[300]!,
                      enabled: true,
                      child: Container(
                        color: Colors.white,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error loading image'); // Handle error loading image
                  } else {
                    return CachedNetworkImage(
                      imageUrl: offerInfo.logo!,
                      fit: BoxFit.fill,
                    );
                  }
                },
              ),
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
                          style: TextStyles.text1D,
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
