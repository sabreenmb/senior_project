// ignore_for_file: must_be_immutable, unused_local_variable
// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../model/found_item_model.dart';
import '../common/theme.dart';

class FoundCard extends StatelessWidget {
  FoundItemModel foundItem;
  FoundCard(this.foundItem, {super.key});

  @override
  Widget build(BuildContext context) {

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
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: SizedBox(
                width: 95,
                height: 130,
                child: foundItem.photo == "empty"
                    ?           Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/lost-items.svg',
                      height: 100,
                      width: 100,
                      color: CustomColors.darkGrey,
                    ))
                    : FutureBuilder<void>(
                        future: precacheImage(
                          CachedNetworkImageProvider(foundItem.photo!),
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
                            return Container(
                                width: 95,
                                height: 130,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: SvgPicture.asset(
                                    'assets/icons/lost-items.svg',
                                    color: CustomColors.darkGrey.withOpacity(0.7),
                                  ),
                                )); // Handle error loading image
                          } else {
                            return  CachedNetworkImage(
                                width: 95,
                                height: 130,
                                fit: BoxFit.fill,
                                imageUrl: foundItem.photo!,
                                errorWidget: (context, url, error) => Container(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/icons/lost-items.svg',
                                      height: 100,
                                      width: 100,
                                      color: CustomColors.darkGrey,
                                    )));
                          }
                        },
                      ),
              ),
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
                      foundItem.category!,
                      textAlign: TextAlign.right,
                      style: TextStyles.heading3B,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      foundItem.description!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text1D,
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
                          foundItem.foundDate!,
                          textAlign: TextAlign.right,
                          style: TextStyles.text1L,
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
                          foundItem.foundPlace!,
                          textAlign: TextAlign.right,
                          style: TextStyles.text1L,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.map,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          foundItem.receivePlace!,
                          textAlign: TextAlign.right,
                          style: TextStyles.text1L,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
