// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:senior_project/model/student_group_model.dart';
import 'package:senior_project/model/saved_list_model.dart';
import 'package:senior_project/common/constant.dart';

import '../common/theme.dart';

class StudyGroupCard extends StatefulWidget {
  StudyGroupModel studyGroup;
  StudyGroupCard(this.studyGroup, {super.key});

  @override
  State<StudyGroupCard> createState() => _StudyGroupCardState();
}

class _StudyGroupCardState extends State<StudyGroupCard> {
  @override
  Widget build(BuildContext context) {
    bool isSaved = false;
    SavedListModel savedItem = SavedListModel(
        serviceName: 'studyGroups',
        dynamicObject: widget.studyGroup,
        icon: services[5]['icon']);
    isSaved = SavedListModel.findId(widget.studyGroup.id.toString());

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: SizedBox(
                    child: Text(
                      widget.studyGroup.name!,
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
                      widget.studyGroup.location!,
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
                      widget.studyGroup.date!,
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
                      widget.studyGroup.time!,
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
                      widget.studyGroup.numPerson!,
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
