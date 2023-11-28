import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../constant.dart';
import '../theme.dart';

class ServiceCard extends StatelessWidget {
  Map<String, String> serviceDetails;
  ServiceCard(this.serviceDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        border: Border.all(color: const Color.fromRGBO(171, 171, 171, 0.53)),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(171, 171, 171, 0.5),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 7.5,
          ), //BoxShadow
          BoxShadow(
            color: Color.fromARGB(0, 255, 255, 255),
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      ),
      //alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: SvgPicture.asset(
              serviceDetails['icon']!,
              width: 70,
              height: 70,
            ),
          ),
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //       image: AssetImage(),
          //
          // ),

          Text(
            serviceDetails['serviceName']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(168, 168, 168, 1),
            ),
          ),
        ],
      ),
    );
  }
}
