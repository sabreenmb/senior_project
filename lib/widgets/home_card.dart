// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../interface/vol_op_screen.dart';
import '../interface/event_screen.dart';
import '../common/theme.dart';

class HomeCard extends StatefulWidget {
  dynamic dynamicObject;
  String serviceName;
  String icon;

  HomeCard(this.dynamicObject, this.serviceName, this.icon, {Key? key})
      : super(key: key);

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        if (widget.serviceName == 'volunteerOp') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const VolunteerOp()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const EventScreen()));
        }
      },
      child: SizedBox(
        width: 200,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: CustomColors.lightBlue),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15, bottom: 15,top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 65,
                  child: Center(
                    child: SvgPicture.asset(
                      widget.icon,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.dynamicObject.name!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyles.heading3B,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.dynamicObject.location!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyles.text1L,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.date_range_outlined,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.dynamicObject.date!}',
                          textAlign: TextAlign.center,
                          style: TextStyles.text1L,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.timer_sharp,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.dynamicObject.time!}',
                          textAlign: TextAlign.center,
                          style: TextStyles.text1L,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
