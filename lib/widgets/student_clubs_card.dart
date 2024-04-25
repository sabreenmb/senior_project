// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../interface/StudentClubDetails.dart';
import '../model/student_club_model.dart';
import '../common/theme.dart';

class StudentClubCard extends StatelessWidget {
  StudentClubModel sClubDetails;

  StudentClubCard(this.sClubDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentClubDetails(sClubDetails)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.white,
          border: Border.all(color: CustomColors.lightBlue),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: const [
            BoxShadow(
              color: CustomColors.lightGreyLowTrans,
              offset: Offset(
                0.0,
                10.0,
              ),
              blurRadius: 7.5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 80,
                child: sClubDetails.logo == "empty"
                    ? Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/students-clubs.svg',
                      height: 100,
                      width: 100,
                      color: CustomColors.darkGrey,
                    ))
                    : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: sClubDetails.logo!,
                    errorWidget: (context, url, error) =>
                        Container(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/students-clubs.svg',
                              height: 100,
                              width: 100,
                              color: CustomColors.darkGrey,
                            ))
                ),
              ),
            ),
            Text(
              sClubDetails.name!,
              textAlign: TextAlign.center,
              style: TextStyles.heading1L,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
