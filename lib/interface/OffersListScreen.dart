import 'package:flutter/material.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/widgets/grid_card.dart';
import 'package:senior_project/widgets/side_menu.dart';

import '../common/constant.dart';
import '../common/theme.dart';
import '../common/common_functions.dart';

class OffersListScreen extends StatefulWidget {
  const OffersListScreen({super.key});

  @override
  State<OffersListScreen> createState() => _OffersListState();
}

class _OffersListState extends State<OffersListScreen> {
  @override
  void initState() {
    super.initState();
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
          title: Text("العروض", style: TextStyles.pageTitle),
          centerTitle: true,
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        endDrawer: SideDrawer(
          onProfileTap: () => goToProfilePage(context),
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
                        itemCount: offers.length,
                        itemBuilder: (context, i) =>
                            GridCard(offers[i], i, false)),
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
