// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/SavedList.dart';
import 'package:senior_project/model/courses_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/theme.dart';

// ignore: must_be_immutable
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
    Size size = MediaQuery.of(context).size;
    SavedList savedItem = SavedList(
        serviceName: 'cources',
        dynamicObject: widget.courseItem,
        icon: services[4]['icon']);
    isSaved = SavedList.findId(widget.courseItem.id.toString());

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
            //start the colom
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
          bottom: 8.0,
          left: 15.0,
          child: TextButton(
            onPressed: () => _launchURL(widget.courseItem.courseLink!, context),
            child: Text(
              'سجل',
              style: TextStyle(
                color: TextStyles.heading3B.color,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> _launchURL(String? urlString, BuildContext context) async {
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The URL is not available.')),
      );
      return;
    }
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }
}
