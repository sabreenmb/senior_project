// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 80,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: sClubDetails.logo == "empty"
                    ? const Image(
                        image: AssetImage('assets/images/logo-icon.png'))
                    : FutureBuilder<void>(
                        future: precacheImage(
                          CachedNetworkImageProvider(sClubDetails.logo!),
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
                            return const Text(
                                'Error loading image'); // Handle error loading image
                          } else {
                            return CachedNetworkImage(
                              imageUrl: sClubDetails.logo!,
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
              ),
            ),
            Text(
              sClubDetails.name!,
              textAlign: TextAlign.center,
              style: TextStyles.heading1L,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
