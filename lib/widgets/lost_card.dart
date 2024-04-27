// ignore_for_file: must_be_immutable
// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/view/Chat_Pages/chat_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../model/lost_item_model.dart';
import '../common/theme.dart';

class LostCard extends StatelessWidget {
  LostItemModel lostItem;
  LostCard(this.lostItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(
                    width: 95,
                    height: 130,
                    child: lostItem.photo == "empty"
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
                        CachedNetworkImageProvider(lostItem.photo!),
                        context,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: CustomColors.white,
                            highlightColor: CustomColors.highlightColor,
                            enabled: true,
                            child: Container(
                              color: CustomColors.white,
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
                              imageUrl: lostItem.photo!,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          lostItem.category!,
                          textAlign: TextAlign.right,
                          style: TextStyles.heading3B,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          lostItem.desription!,
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
                              lostItem.lostDate!,
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
                              lostItem.expectedPlace!,
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
                              Icons.call,
                              color: CustomColors.lightGrey,
                              size: 14.0,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              lostItem.phoneNumber!,
                              textAlign: TextAlign.right,
                              style: TextStyles.text1L,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          lostItem.creatorID != userInfo.userID
              ? Positioned(
                  top: 9,
                  left: 15,
                  child: IconButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RealChatPage(
                            otherUserInfo: allUsers[allUsers.indexWhere(
                                (element) =>
                                    element.userID == lostItem.creatorID)],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.chat,
                      color: CustomColors.lightBlue,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
