import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/common_functions.dart';
import 'package:senior_project/common/theme.dart';
import 'package:senior_project/widgets/home_offer_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:shimmer/shimmer.dart';

import '../common/constant.dart';
import '../model/dynamic_item_model.dart';
import '../model/offer_info_model.dart';
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
    network();

    homeCards();
    getTodayList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("الرئيسية", style: TextStyles.pageTitle),
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
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildCard(),
                            Visibility(
                              visible: todayList.isNotEmpty,
                              child: _buildSectionTitle('يحدث اليوم'),
                            ),
                            Visibility(
                              visible: todayList.isNotEmpty,
                              child: _buildHorizontalScrollableCards(todayList),
                            ),
                            _buildSectionTitle('أضيف حديثا'),
                            _buildHorizontalScrollableCards(combinedList),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return FutureBuilder(
      future: Future.wait(
        recommendedOffers.map((offer) =>
            precacheImage(CachedNetworkImageProvider(offer.logo!), context)),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: CustomColors.white,
            highlightColor: CustomColors.highlightColor,
            enabled: true,
            child: CarouselSlider(
              items: [
                HomeOfferCard(
                  OfferInfoModel(
                    timestamp: '',
                    name: ' ',
                    id: '',
                    logo: 'empty',
                    category: '',
                    code: '',
                    details: '',
                    discount: '',
                    expDate: '',
                    contact: '',
                    targetUsers: '',
                  ),
                ),
              ],
              options: CarouselOptions(
                height: 180,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
              ),
            ),
          );
        }
        return recommendedOffers.length != 1
            ? CarouselSlider(
                items: recommendedOffers
                    .map((offer) => HomeOfferCard(offer))
                    .toList()
                    .cast<Widget>(),
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
              )
            : HomeOfferCard(recommendedOffers[0]);
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
          style: TextStyles.heading1D,
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollableCards(List<DynamicItemModel> details) {
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
