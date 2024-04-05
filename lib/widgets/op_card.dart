// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/model/EventItem.dart';
import 'package:senior_project/model/SavedList.dart';
import 'package:senior_project/model/volunteer_op_report.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';

class OpCard extends StatefulWidget {
  VolunteerOpReport volunteerOpReport;
  OpCard(this.volunteerOpReport, {super.key});

  @override
  State<OpCard> createState() => _OpCardState();
}

class _OpCardState extends State<OpCard> {
  @override
  Widget build(BuildContext context) {
    bool isSaved;
    Size size = MediaQuery.of(context).size;
    SavedList savedItem = SavedList(
        serviceName: 'volunteerOp',
        dynamicObject: widget.volunteerOpReport,
        icon: services[1]['icon']);
    isSaved = SavedList.findId(widget.volunteerOpReport.id.toString());

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
                Text(
                  widget.volunteerOpReport.name!,
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
                      Icons.date_range_outlined,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${widget.volunteerOpReport.date!} , ${widget.volunteerOpReport.time!}",
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
                      widget.volunteerOpReport.location!,
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
                      Icons.people,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.volunteerOpReport.opNumber!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
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
                  print('oooooooooooooooo');
                  print(isSaved);
                  isSaved = savedItem.addToSave(isSaved);

                  print(isSaved);
                });
              },
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: CustomColors.lightBlue,
              ),
            ),
          ),
          if (widget.volunteerOpReport.opLink != "")
            Positioned(
              bottom: 8.0,
              left: 15.0,
              child: TextButton(
                onPressed: () =>
                    _launchURL(widget.volunteerOpReport.opLink!, context),
                child: Text(
                  'سجل',
                  style: TextStyle(
                    color: TextStyles.heading3B.color,
                  ),
                ),
              ),
            ),
        ],
      ),
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
