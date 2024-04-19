import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/commonWidgets.dart';
import 'package:senior_project/widgets/home_offer_card.dart';
import 'package:senior_project/widgets/side_menu.dart';

import '../constant.dart';
import '../model/EventItem.dart';
import '../widgets/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //todo move it to the login screen

    homeCards();
    getTodayList();

  //  _LoadCreatedSessions();
  }

  void _LoadCreatedSessions() async {}

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("الرئيسية", style: TextStyles.heading1),
          centerTitle: false,
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
        ),
        endDrawer: SideDrawer(
          onProfileTap: () => goToProfilePage(context),
        ),
        bottomNavigationBar: buildBottomBar(context, 0, false),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    decoration: const BoxDecoration(
                      color: CustomColors.BackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildCard(),
                        _buildSectionTitle('يحدث اليوم'),
                        _buildHorizontalScrollableCards(todayList),
                        _buildSectionTitle('أضيف حديثا'),
                        _buildHorizontalScrollableCards(combinedList),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    List<dynamic> categoryList = offers[1]['categoryList'];
    // bool autoplayEnabled = categoryList.length > 1;

    return FutureBuilder(
      future: Future.wait(
        recommendedOffers.map((offer) =>
            precacheImage(CachedNetworkImageProvider(offer.logo!), context)),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return CarouselSlider(
          items: recommendedOffers
              .map((offer) => HomeOfferCard(offer))
              .toList()
              .cast<Widget>(),
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: CustomColors.darkGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollableCards(List<EventItem> details) {
    print('fiss');
    print(courseItem.length);
    return Container(
      height: 240,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: details.length,
          itemBuilder: (context, index) => HomeCard(details[index].item,
              details[index].serviceName, details[index].icon)),
    );
  }
}
