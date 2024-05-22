// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/model/saved_list_model.dart';
import 'package:senior_project/model/vol_op_model.dart';
import '../common/common_functions.dart';
import '../common/theme.dart';

class OpCard extends StatefulWidget {
  VolOpModel volOpItem;
  OpCard(this.volOpItem, {super.key});

  @override
  State<OpCard> createState() => _OpCardState();
}

class _OpCardState extends State<OpCard> {
  @override
  Widget build(BuildContext context) {
    bool isSaved;
    SavedListModel savedItem = SavedListModel(
        serviceName: 'volunteerOp',
        dynamicObject: widget.volOpItem,
        icon: services[1]['icon']);
    isSaved = SavedListModel.findId(widget.volOpItem.id.toString());

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
                    width: 270,
                    child: Text(
                      widget.volOpItem.name!,
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
                      Icons.date_range_outlined,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${widget.volOpItem.date!} , ${widget.volOpItem.time!}",
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
                      widget.volOpItem.location!,
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
                      Icons.people,
                      color: CustomColors.lightGrey,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.volOpItem.opNumber!,
                      textAlign: TextAlign.right,
                      style: TextStyles.text1L,
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
            left: 10.0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isSaved = savedItem.handelSaveItem(isSaved);
                });
              },
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: CustomColors.lightBlue,
              ),
            ),
          ),
          if (widget.volOpItem.opLink != "")
            Positioned(
              bottom: 2.0,
              left: 8.0,
              child: TextButton(
                onPressed: () => launchURL(widget.volOpItem.opLink!, context),
                child: Text(
                  'سجل',
                  style: TextStyles.text1B,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
