import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../common/common_functions.dart';
import '../common/constant.dart';
import '../common/theme.dart';
import '../widgets/offer_card.dart';

class OfferCategoriesScreen extends StatefulWidget {
  final Map<String, dynamic> details;
  final int i;
  const OfferCategoriesScreen(this.i, this.details, {super.key});
  @override
  State<OfferCategoriesScreen> createState() => _OfferCategoryState();
}

class _OfferCategoryState extends State<OfferCategoriesScreen> {
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
          title: Text(details['offerCategory']!, style: TextStyles.pageTitle),
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
        body: ModalProgressHUD(
          color: CustomColors.black,
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
                            color: CustomColors.backgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                      ),
                      isOffline
                          ? Center(
                              child: SizedBox(
                                height: 200,
                                child: Image.asset(
                                    'assets/images/NoInternet_newo.png'),
                              ),
                            )
                          : Column(
                              children: [
                                if (_offerInfo.isEmpty)
                                  Expanded(
                                    child: Center(
                                      child: SizedBox(
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
