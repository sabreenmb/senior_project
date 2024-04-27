// ignore_for_file: must_be_immutable, unused_local_variable
// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../model/offer_info_model.dart';
import '../common/theme.dart';
import '../view/offer_details.dart';

class OfferCard extends StatelessWidget {
  OfferInfoModel offerInfo;
  OfferCard(this.offerInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetailsScreen(offerInfo),
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
                        ? Container(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/offers.svg',
                              height: 100,
                              width: 100,
                              color: CustomColors.darkGrey,
                            ))
                        : CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: offerInfo.logo!,
                            errorWidget: (context, url, error) =>
                                Container(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/icons/offers.svg',
                                      height: 100,
                                      width: 100,
                                      color: CustomColors.darkGrey,
                                    ))
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          offerInfo.name!,
                          maxLines: 1,
                          overflow:TextOverflow.ellipsis,
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
