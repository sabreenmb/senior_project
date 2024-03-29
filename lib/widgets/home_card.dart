import 'package:flutter/material.dart';
import '../theme.dart';

class HomeCard extends StatelessWidget {
  final dynamic dynamicObject; // Change type to dynamic
  HomeCard(this.dynamicObject, {Key? key}) : super(key: key);

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
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 65,
              child: Center(
                child: Image.asset('assets/images/logo-icon.png'),
              ),
            ),
            Text(
              dynamicObject.name!,
              textAlign: TextAlign.right,
              style: TextStyles.heading3B,
            ),
            const SizedBox(
              height: 10,
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
                  dynamicObject.location!,
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
                  Icons.date_range_outlined,
                  color: CustomColors.lightGrey,
                  size: 14.0,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${dynamicObject.date!}   ${dynamicObject.time!}',
                  textAlign: TextAlign.right,
                  style: TextStyles.text,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
