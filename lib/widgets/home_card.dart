import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../theme.dart';

class HomeCard extends StatelessWidget {
  dynamic dynamicObject;
  String serviceName;
  String icon;

  HomeCard(this.dynamicObject, this.serviceName, this.icon, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        // Define the navigation logic here
        //Navigator.push(
        // context,
        // MaterialPageRoute(builder: (context) => ()),
        //  );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: CustomColors.lightBlue),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 65,
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Text(
                  dynamicObject.name!,
                  textAlign: TextAlign.center,
                  style: TextStyles.heading3B,
                ),
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: CustomColors.lightGrey,
                        size: 14.0,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        dynamicObject.location!,
                        textAlign: TextAlign.center,
                        style: TextStyles.text,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        color: CustomColors.lightGrey,
                        size: 14.0,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${dynamicObject.date!}',
                        textAlign: TextAlign.center,
                        style: TextStyles.text,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_sharp,
                        color: CustomColors.lightGrey,
                        size: 14.0,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${dynamicObject.time!}',
                        textAlign: TextAlign.center,
                        style: TextStyles.text,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
