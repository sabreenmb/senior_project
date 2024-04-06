// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/model/create_group_report.dart';
import 'package:senior_project/model/SavedList.dart';
import 'package:senior_project/constant.dart';

import '../theme.dart';

class CreateCard extends StatefulWidget {
  CreateGroupReport createGroupReport;
  CreateCard(this.createGroupReport, {super.key});

  @override
  State<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  @override
  Widget build(BuildContext context) {
    bool isSaved = false;
    SavedList savedItem = SavedList(
        serviceName: 'studyGroubs',
        dynamicObject: widget.createGroupReport,
        icon: services[5]['icon']);
    isSaved = SavedList.findId(widget.createGroupReport.id.toString());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              //start the colom
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    widget.createGroupReport.name!,
                    textAlign: TextAlign.right,
                    style: TextStyles.heading3B,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                      widget.createGroupReport.location!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
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
                      '${widget.createGroupReport.date!}   ${widget.createGroupReport.time!}',
                      textAlign: TextAlign.right,
                      style: TextStyles.text,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.createGroupReport.numPerson!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            left: 15.0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isSaved = savedItem.addToSave(isSaved);
                });
              },
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: CustomColors.lightBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
