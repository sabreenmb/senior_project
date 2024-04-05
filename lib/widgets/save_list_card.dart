import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/interface/student_activity.dart';
import 'package:senior_project/interface/study_group.dart';
import '../constant.dart';
import '../interface/VolunteerOpportunities.dart';
import '../interface/event_screen.dart';
import '../model/EventItem.dart';
import '../model/SavedList.dart';
import '../theme.dart';

// ignore: must_be_immutable
class SaveCard extends StatefulWidget {
  dynamic dynamicObject;
  String serviceName;
  String icon;

  SaveCard(this.dynamicObject, this.serviceName, this.icon, {Key? key})
      : super(key: key);

  @override
  State<SaveCard> createState() => _SaveCardState();
}

class _SaveCardState extends State<SaveCard> {
  //manar
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SavedList savedItem = SavedList(
        serviceName: widget.serviceName,
        dynamicObject: widget.dynamicObject,
        icon: widget.icon);
    //manar
    isSaved = SavedList.findId(widget.dynamicObject.id);

    return isSaved
        ? Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: CustomColors.lightBlue, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () {
                // Define the navigation logic here
                if (widget.serviceName == 'فرصة تطوعية') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VolunteerOp()),
                  );
                } else if (widget.serviceName == 'نشاط طلابي') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentActivity()),
                  );
                } else if (widget.serviceName == 'جلسة مذاكرة') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StudyGroup()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EventScreen()),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: SvgPicture.asset(
                        widget.icon,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Container(
                      width: 30.0,
                      child: const VerticalDivider(
                        thickness: 3.0,
                        color: CustomColors.darkGrey,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.serviceName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.lightBlue)),
                          const SizedBox(height: 10),
                          Text(widget.dynamicObject.name!,
                              style: const TextStyle(
                                  fontSize: 14, color: CustomColors.darkGrey)),
                          const SizedBox(height: 5),
                          Text(widget.dynamicObject.location!,
                              style: const TextStyle(
                                  fontSize: 14, color: CustomColors.darkGrey)),
                          const SizedBox(height: 5),
                          Text(widget.dynamicObject.date!,
                              style: const TextStyle(
                                  fontSize: 14, color: CustomColors.darkGrey)),
                          const SizedBox(height: 5),
                          Text(widget.dynamicObject.time!,
                              style: const TextStyle(
                                  fontSize: 14, color: CustomColors.darkGrey)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSaved = !isSaved;
                          saveList.removeWhere((item) =>
                              item.serviceName == widget.serviceName &&
                              item.item == widget.dynamicObject &&
                              item.icon == widget.icon);
                          savedItem
                              .removeItem(widget.dynamicObject.id!.toString());
                        });
                      },
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: CustomColors.lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}
