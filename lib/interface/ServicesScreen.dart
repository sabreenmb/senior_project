import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServisesScreen extends StatelessWidget {
  ServisesScreen({super.key});

  final List services = [
    {
      "serviceName": "المفقودات",
      "icon": "assets/icons/lost-items.svg",
      "semanticsLabel": "lost items-icon"
    },
    {
      "serviceName": "الفرص التطوعية",
      "icon": "assets/icons/volunteering-opportunity.svg",
      "semanticsLabel": "volunteering opportunity-icon"
    },
    {
      "serviceName": "العروض",
      "icon": "assets/icons/offers.svg",
      "semanticsLabel": "offers-icon"
    },
    {
      "serviceName": "النوادي الطلابية",
      "icon": "assets/icons/students-clubs.svg",
      "semanticsLabel": "students clubs-icon"
    },
    {
      "serviceName": "الفعاليات",
      "icon": "assets/icons/events.svg",
      "semanticsLabel": "events-icon"
    },
    {
      "serviceName": "جلسة مذاكرة",
      "icon": "assets/icons/study.svg",
      "semanticsLabel": "study-icon"
    },
    {
      "serviceName": "الأنشطة الطلابية",
      "icon": "assets/icons/activities.svg",
      "semanticsLabel": "activities-icon"
    },
    {
      "serviceName": "العيادات",
      "icon": "assets/icons/clinic.svg",
      "semanticsLabel": "clinic-icon"
    },
    {
      "serviceName": "الإرشاد النفسي",
      "icon": "assets/icons/psychological-guidance.svg",
      "semanticsLabel": "psychological guidance.svg-icon"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('الخدمات'),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(196, 196, 196, 0.2),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 25.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.3),
            itemCount: services.length,
            itemBuilder: (context, i) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  border: Border.all(
                      color: const Color.fromRGBO(171, 171, 171, 0.53)),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: SvgPicture.asset(
                        services[i]['icon'],
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
                      services[i]['serviceName'],
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
            }),
      ),
    );
  }
}
