// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/model/courses_item_report.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';

// ignore: must_be_immutable
class CoursesCard extends StatelessWidget {
  CoursesItemReport courseItem;
  CoursesCard(this.courseItem, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
              Text(
                courseItem.Name!,
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
                    courseItem.presentBy!,
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
                    "${courseItem.courseDate!} , ${courseItem.courseTime!}",
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
                    courseItem.coursePlace!,
                    textAlign: TextAlign.right,
                    style: TextStyles.text,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 8.0,
          left: 15.0,
          child: TextButton(
            onPressed: () => _launchURL(courseItem.courseLink!, context),
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
