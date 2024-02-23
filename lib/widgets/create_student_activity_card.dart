// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/model/create_student_activity_report.dart';

import '../theme.dart';

class CreateStudentActivityCard extends StatelessWidget {
  CreateStudentActivityReport createStudentActivityReport;
  CreateStudentActivityCard(this.createStudentActivityReport, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //start the colom
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      createStudentActivityReport.activityName!,
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
                          createStudentActivityReport.activityPlace!,
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
                          Icons.timer_sharp,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          createStudentActivityReport.activityDate! +
                              '   ' +
                              createStudentActivityReport.activityTime!,
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
                          createStudentActivityReport.numOfPerson!,
                          textAlign: TextAlign.right,
                          style: TextStyles.text,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
