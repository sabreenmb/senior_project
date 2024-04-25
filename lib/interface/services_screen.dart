import 'package:flutter/material.dart';
import 'package:senior_project/widgets/side_menu.dart';
import '../common/common_functions.dart';
import '../common/constant.dart';
import '../common/theme.dart';
import '../widgets/grid_card.dart';


class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesState();
}

class _ServicesState extends State<ServicesScreen> {
  @override
  void initState() {
    super.initState();
    //todo notification testing
    // notificationServices.forgroundMessage();
    // notificationServices.firebaseInit(context);
    // notificationServices.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("الخدمات", style: TextStyles.pageTitle),
          centerTitle: false,
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
        ),
        endDrawer: SideDrawer(
          onProfileTap:  () => goToProfilePage(context),
        ),
          bottomNavigationBar: buildBottomBar(context, 1, true),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Expanded(
                  child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: CustomColors.backgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 25.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 1.3),
                        itemCount: services.length, itemBuilder: (context, i) => GridCard(services[i], i, true,)),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
