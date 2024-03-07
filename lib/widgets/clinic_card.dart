// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:senior_project/model/clinic_report.dart';

import '../theme.dart';

// ignore: must_be_immutable
class ClinicCard extends StatelessWidget {
  ClinicReport clinicReport;
  ClinicCard(
    this.clinicReport, {
    super.key,
  });

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            clinicReport.clDepartment!,
                            textAlign: TextAlign.right,
                            style: TextStyles.heading3B,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            clinicReport.clDoctor!,
                            //   textAlign: TextAlign
                            //      .right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: TextStyles.text.fontSize,
                              //    fontFamily: TextStyles.text
                              //     .fontFamily,
                              ///   fontWeight: TextStyles.text
                              //      .fontWeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.people,
                    //       color: CustomColors.lightGrey,
                    //       size: 14.0,
                    //     ),
                    //     const SizedBox(width: 5),
                    //     Text(
                    //       clinicReport.clDoctor!,
                    //       style: TextStyles.text,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          clinicReport.clDate!,
                          style: TextStyles.text,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_sharp,
                          color: CustomColors.lightGrey,
                          size: 14.0,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "${clinicReport.clStarttime!}-${clinicReport.clEndtime!}",
                          style: TextStyles.text,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
