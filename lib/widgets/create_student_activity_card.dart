// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/saved_list_model.dart';
import 'package:senior_project/model/student_activity_model.dart';

import '../common/theme.dart';

class CreateStudentActivityCard extends StatefulWidget {
  StudentActivityModel createStudentActivityReport;
  CreateStudentActivityCard(this.createStudentActivityReport, {super.key});

  @override
  State<CreateStudentActivityCard> createState() =>
      _CreateStudentActivityCardState();
}

class _CreateStudentActivityCardState extends State<CreateStudentActivityCard> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SavedListModel savedItem = SavedListModel(
        serviceName: 'studentActivities',
        dynamicObject: widget.createStudentActivityReport,
        icon: services[6]['icon']);
    isSaved =
        SavedListModel.findId(widget.createStudentActivityReport.id.toString());

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
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: SizedBox(
                    child: Text(
                      widget.createStudentActivityReport.name!,
                      textAlign: TextAlign.right,
                      style: TextStyles.heading3B,
                      maxLines: 2,
                    ),
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
                      widget.createStudentActivityReport.location!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text1L,
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
                      '${widget.createStudentActivityReport.date!}',
                      textAlign: TextAlign.right,
                      style: TextStyles.text1L,
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
                      Icons.access_time,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.createStudentActivityReport.time!}',
                      textAlign: TextAlign.right,
                      style: TextStyles.text1L,
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
                      widget.createStudentActivityReport.numOfPerson!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text1L,
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
