// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/saved_list_model.dart';
import 'package:senior_project/model/conference_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/theme.dart';

// ignore: must_be_immutable
class ConfCard extends StatefulWidget {
  ConferencesModel confItem;
  ConfCard(this.confItem, {super.key});

  @override
  State<ConfCard> createState() => _ConfCardState();
}

class _ConfCardState extends State<ConfCard> {
  @override
  Widget build(BuildContext context) {
    bool isSaved;
    Size size = MediaQuery.of(context).size;
    SavedListModel savedItem = SavedListModel(
        serviceName: 'conferences',
        dynamicObject: widget.confItem,
        icon: services[4]['icon']);
    isSaved = SavedListModel.findId(widget.confItem.id.toString());

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
                      widget.confItem.name!,
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
                      Icons.date_range_outlined,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${widget.confItem.date!} , ${widget.confItem.time!}",
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
                      widget.confItem.location!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text1L,
                    ),
                  ],
                ),
              ]),
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
            onPressed: () => _launchURL(widget.confItem.confLink!, context),
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
