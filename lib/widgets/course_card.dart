// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:senior_project/common/common_functions.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/saved_list_model.dart';
import 'package:senior_project/model/courses_model.dart';

import 'package:senior_project/common/theme.dart';

class CoursesCard extends StatefulWidget {
  CoursesModel courseItem;
  CoursesCard(this.courseItem, {super.key});

  @override
  State<CoursesCard> createState() => _CoursesCardState();
}

class _CoursesCardState extends State<CoursesCard> {
  @override
  Widget build(BuildContext context) {
    bool isSaved;
    SavedListModel savedItem = SavedListModel(
        serviceName: 'cources',
        dynamicObject: widget.courseItem,
        icon: services[4]['icon']);
    isSaved = SavedListModel.findId(widget.courseItem.id.toString());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Stack(children: [
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
                  width: 270,
                  child: Text(
                    widget.courseItem.name!,
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
                    widget.courseItem.presentBy!,
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
                    Icons.date_range_outlined,
                    color: CustomColors.lightGrey,
                    size: 14.0,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${widget.courseItem.date!} , ${widget.courseItem.time!}",
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
                    widget.courseItem.location!,
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
        Positioned(
          bottom: 2.0,
          left: 8.0,
          child: TextButton(
            onPressed: () => launchURL(widget.courseItem.courseLink!, context),
            child: Text(
              'سجل',
              style: TextStyles.text1B,
            ),
          ),
        )
      ]),
    );
  }
}
