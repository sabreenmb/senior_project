// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/model/courses_item_report.dart';
import 'package:senior_project/model/other_event_item_report.dart';
import 'package:senior_project/model/workshop_item_report.dart';

import '../theme.dart';

// ignore: must_be_immutable
class OtherCard extends StatelessWidget {
  OtherEventsItemReport otherEventsItem;
  OtherCard(this.otherEventsItem, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                      otherEventsItem.Name!,
                      textAlign: TextAlign.right,
                      style: TextStyles.heading3B,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          otherEventsItem.presentBy!,
                          textAlign: TextAlign.right,
                          style: TextStyles.text,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
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
                          otherEventsItem.otherEventDate!,
                          textAlign: TextAlign.right,
                          style: TextStyles.text,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          otherEventsItem.otherEventTime!,
                          textAlign: TextAlign.right,
                          style: TextStyles.text,
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
                          otherEventsItem.otherEventPlace!,
                          textAlign: TextAlign.right,
                          style: TextStyles.text,
                        ),
                      ],
                    ),
                    Container(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              ElevatedButton(
                                child: Text(
                                  "سجل",
                                  style: TextStyles.heading3B,
                                ),
                                onPressed: () {},
                              ),
                            ])))
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
