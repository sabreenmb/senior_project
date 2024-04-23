import 'package:flutter/material.dart';
import 'package:senior_project/model/create_group_report.dart';

import '../common/theme.dart';

class CreateMain extends StatelessWidget {
  CreateGroupReport createGroupReport;
  CreateMain(this.createGroupReport, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
// ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            //start the colom
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                createGroupReport.name!,
                textAlign: TextAlign.right,
                style: TextStyles.heading3B,
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
                    createGroupReport.location!,
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
                    '${createGroupReport.date!}   ${createGroupReport.time!}',
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
                    createGroupReport.numPerson!,
                    textAlign: TextAlign.right,
                    style: TextStyles.text1L,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
