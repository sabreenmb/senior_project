import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/OffersListScreen.dart';

import '../constant.dart';
import '../theme.dart';
import '../widgets/offer_card.dart';

class OfferCategoryScreen extends StatefulWidget {
  Map<String, dynamic> details;
  int i;
  // OfferCategoryScreen(this.details, {super.key});
  OfferCategoryScreen(this.i, this.details, {super.key});

  @override
  State<OfferCategoryScreen> createState() => _OfferCategoryState();
}

class _OfferCategoryState extends State<OfferCategoryScreen> {
  List<dynamic> _offerInfo = [];

  late StreamSubscription connSub;
  void checkConnectivity(List<ConnectivityResult> result) {
    switch (result[0]) {
      case ConnectivityResult.mobile || ConnectivityResult.wifi:
        if (isOffline != false) {
          setState(() {
            isOffline = false;
          });
        }
        break;
      case ConnectivityResult.none:
        if (isOffline != true) {
          setState(() {
            isOffline = true;
          });
        }
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    connSub = Connectivity().onConnectivityChanged.listen(checkConnectivity);


  }

  @override
  void dispose() {
    connSub.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> details = widget.details;
    int index = widget.i;
    _offerInfo = offers[index]['categoryList'];
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text(details['offerCategory']!, style: TextStyles.heading1),
          centerTitle: true,
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OffersListScreen()));
                },
              );
            },
          ),
        ),
        body: ModalProgressHUD(
          color: Colors.black,
          opacity: 0.5,
          progressIndicator: loadingFunction(context, true),
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
                          color: CustomColors.BackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                    isOffline
                        ? Center(
                      child: SizedBox(
                        // padding: EdgeInsets.only(bottom: 20),
                        // alignment: Alignment.topCenter,
                        height: 200,
                        child: Image.asset('assets/images/logo-icon.png'),
                      ),
                    )
                        : Column(
                      children: [
                        if (_offerInfo.isEmpty)
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                // padding: EdgeInsets.only(bottom: 20),
                                // alignment: Alignment.topCenter,
                                height: 200,
                                child: Image.asset(
                                    'assets/images/no_content_removebg_preview.png'),
                              ),
                            ),
                          ),
                        if (_offerInfo.isNotEmpty)
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                  itemCount: _offerInfo.length,
                                  itemBuilder: (context, index) =>
                                      OfferCard(_offerInfo[index])),
                            ),
                          )),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
