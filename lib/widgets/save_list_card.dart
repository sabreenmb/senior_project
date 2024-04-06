import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_project/interface/student_activity.dart';
import 'package:senior_project/interface/study_group.dart';

import '../constant.dart';
import '../interface/VolunteerOpportunities.dart';
import '../interface/event_screen.dart';
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: InkWell(
              onTap: () {
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
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 6,
                    child: IconButton(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 50,
                          child: SvgPicture.asset(
                            widget.icon,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 100.0,
                              child: VerticalDivider(
                                width: 30,
                                thickness: 1.0,
                                color: CustomColors.lightGrey,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.serviceName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.lightBlue)),
                              const SizedBox(height: 10),
                              Text(widget.dynamicObject.name!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: CustomColors.lightGrey)),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 14, color: CustomColors.lightGrey),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.dynamicObject.location!,
                                    style: TextStyles.text,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 14, color: CustomColors.lightGrey),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.dynamicObject.date!,
                                    style: TextStyles.text,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 14, color: CustomColors.lightGrey),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.dynamicObject.time!,
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
                ],
              ),
            ))
        : Container();
  }
}
