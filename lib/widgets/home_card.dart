import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../interface/VolunteerOpportunities.dart';
import '../interface/event_screen.dart';
import '../theme.dart';

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
  //manar
  // bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // SavedList savedItem = SavedList(
    //     serviceName: widget.serviceName,
    //     dynamicObject: widget.dynamicObject,
    //     icon: widget.icon);
    // //manar
    // isSaved = SavedList.findId(widget.dynamicObject.id);

    return InkWell(
      onTap: () {
        // Define the navigation logic here
        if (widget.serviceName == 'volunteerOp') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VolunteerOp()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventScreen()),
          );
        }
      },
      child: SizedBox(
        width: 200,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: CustomColors.lightBlue),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // IconButton(
                //   onPressed: () {
                //     setState(() {
                //       isSaved = savedItem.addToSave(isSaved);
                //     });
                //   },
                //   icon: Icon(
                // isSaved ? Icons.bookmark : Icons.bookmark_border,
                //     color: CustomColors.lightBlue,
                //   ),
                // ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: CustomColors.lightGrey,
                            size: 14.0,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.dynamicObject.location!,
                            textAlign: TextAlign.center,
                            style: TextStyles.text,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            color: CustomColors.lightGrey,
                            size: 14.0,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${widget.dynamicObject.date!}',
                            textAlign: TextAlign.center,
                            style: TextStyles.text,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.timer_sharp,
                            color: CustomColors.lightGrey,
                            size: 14.0,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${widget.dynamicObject.time!}',
                            textAlign: TextAlign.center,
                            style: TextStyles.text,
                          ),
                        ],
                      ),
                    ],
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
