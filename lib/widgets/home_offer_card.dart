// ignore_for_file: must_be_immutable, unused_local_variable
// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../common/theme.dart';
import '../interface/OfferDetails.dart';
import '../model/offer_info_model.dart';

class HomeOfferCard extends StatelessWidget {
  OfferInfoModel offerInfo;
  HomeOfferCard(this.offerInfo, {super.key});

  @override
  Widget build(BuildContext context) {

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
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CustomColors.white,
          border: Border.all(color: CustomColors.lightBlue, width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CustomColors.lightGrey.withOpacity(0.5),
              offset: const Offset(0, 3),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        height: 180,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child:   offerInfo.logo == "empty"
                ? Container(
                width: 300,
                height: 80,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: SvgPicture.asset(
                    'assets/icons/offers.svg',
                    color: CustomColors.darkGrey.withOpacity(0.7),
                  ),
                ))
                : CachedNetworkImage(
                width: 300,
                height: 80,
                fit: BoxFit.contain,
                imageUrl:  offerInfo.logo!,
                errorWidget: (context, url, error) => Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/offers.svg',
                      height: 100,
                      width: 100,
                      color: CustomColors.darkGrey,
                    ))),
            ),
      ),
    );
  }
}
