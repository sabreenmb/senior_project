import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/add_found_item_screen.dart';
import 'package:senior_project/interface/add_lost_item_screen.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/common/theme.dart';
import 'package:senior_project/widgets/found_card.dart';
import 'package:senior_project/widgets/lost_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:shimmer/shimmer.dart';

import '../common/constant.dart';
import '../common/firebase_api.dart';
import '../model/found_item_model.dart';
import '../model/lost_item_model.dart';
import '../common/common_functions.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFoundScreen>
    with SingleTickerProviderStateMixin {
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

  //search
  List<LostItemModel> searchLostList = [];
  List<FoundItemModel> searchFoundList = [];

  final _userInputController = TextEditingController();
  //filter
  bool isLost = true;
  bool isSearch = false;
  bool isButtonClicked = false;
  // List<LostItemReport> _lostItemReport = [];
  // List<FoundItemReport> _foundItemReport = [];
  //create button
  bool _isExpanded = false;
  late AnimationController _animationController;
  static const double _expandedSize = 200.0;
  static const double _collapsedSize = 0.0;
  @override
  void dispose() {
    connSub.cancel();

    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connSub = Connectivity().onConnectivityChanged.listen(checkConnectivity);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _toggleExpanded() {
    setState(() {
      isButtonClicked = true;
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

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
          title: Text("المفقودات", style: TextStyles.pageTitle),
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
        bottomNavigationBar: buildBottomBarWF(context, 2),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          backgroundColor: CustomColors.lightBlue,
          hoverElevation: 10,
          splashColor: Colors.grey,
          tooltip: '',
          elevation: 4,
          onPressed: _toggleExpanded,
          child: _isExpanded ? const Icon(Icons.close) : const Icon(Icons.add),
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
                          color: CustomColors.backgroundColor,
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
                              child: Image.asset(
                                  'assets/images/NoInternet_newo.png'),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 60,
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: TextField(
                                  autofocus: false,
                                  controller: _userInputController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.search,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: CustomColors.darkGrey,
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                      color: CustomColors.darkGrey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                          color: CustomColors.darkGrey,
                                          width: 1),
                                    ),
                                    prefixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.search,
                                          color: CustomColors.darkGrey,
                                        ),
                                        onPressed: () {
                                          isLost
                                              ? searchLostList.clear()
                                              : searchFoundList.clear();
                                          filterSearchResults(
                                              _userInputController.text,
                                              isLost
                                                  ? lostItems
                                                  : foundItems);
                                          FocusScope.of(context).unfocus();
                                        }),
                                    hintText: 'ابحث',
                                    suffixIcon: _userInputController
                                            .text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              _userInputController.clear();
                                              FocusScope.of(context).unfocus();

                                              setState(() {
                                                isButtonClicked = false;
                                                isSearch = false;
                                              });
                                            },
                                            icon: const Icon(Icons.clear,
                                                color: CustomColors.darkGrey))
                                        : null,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: CustomColors.darkGrey,
                                          width: 1),
                                    ),
                                  ),
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  onSubmitted: (text) {
                                    //todo the same value of on icon presed
                                    isLost
                                        ? searchLostList.clear()
                                        : searchFoundList.clear();
                                    filterSearchResults(
                                        _userInputController.text,
                                        isLost
                                            ? lostItems
                                            : foundItems);
                                    FocusScope.of(context).unfocus();
                                  },
                                  onTap: () {
                                    isSearch = true;
                                    searchLostList.clear();
                                    searchFoundList.clear();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();

                                            if (isLost != true) {
                                              setState(() {
                                                isButtonClicked = false;
                                                isLost = true;
                                                if (isSearch) {
                                                  _userInputController.clear();
                                                  isSearch = false;
                                                }
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(150, 40),
                                              side: BorderSide(
                                                  color: isLost
                                                      ? Colors.transparent
                                                      : CustomColors.darkGrey,
                                                  width: 1),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              backgroundColor: isLost
                                                  ? CustomColors.pink
                                                  : Colors.transparent),
                                          child: Text("المفقودة",
                                              style: TextStyles.heading2D),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (isLost == true) {
                                              setState(() {
                                                isButtonClicked = false;
                                                isLost = false;
                                                if (isSearch) {
                                                  _userInputController.clear();
                                                  isSearch = false;
                                                }
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(150, 40),
                                              side: BorderSide(
                                                  color: !isLost
                                                      ? Colors.transparent
                                                      : CustomColors.darkGrey,
                                                  width: 1),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              backgroundColor: !isLost
                                                  ? CustomColors.pink
                                                  : Colors.transparent),
                                          child: Text(
                                            "الموجودة",
                                            style: TextStyles.heading2D,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isLost
                                  ? (isSearch
                                      ? searchLostList.isEmpty
                                      : lostItems.isEmpty)
                                  : (isSearch
                                      ? searchFoundList.isEmpty
                                      : foundItems.isEmpty))
                                Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      // padding: EdgeInsets.only(bottom: 20),
                                      // alignment: Alignment.topCenter,
                                      height: 200,
                                      child: Image.asset(isSearch
                                          ? 'assets/images/searching-removebg-preview.png'
                                          : 'assets/images/no_content_removebg_preview.png'),
                                    ),
                                  ),
                                ),
                              if (isLost
                                  ? lostItems.isNotEmpty
                                  : foundItems.isNotEmpty)
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: isSearch
                                          ? ListView.builder(
                                              itemCount: isLost
                                                  ? searchLostList.length
                                                  : searchFoundList.length,
                                              itemBuilder: (context, index) =>
                                                  isLost
                                                      ? LostCard(
                                                          searchLostList[index])
                                                      : FoundCard(
                                                          searchFoundList[
                                                              index]))
                                          : _buildcardList()

                                      // : ListView.builder(
                                      //     itemCount: isLost
                                      //         ? lostItemReport.length
                                      //         : foundItemReport.length,
                                      //     itemBuilder: (context, index) => isLost
                                      //         ? LostCard(lostItemReport[index])
                                      //         : FoundCard(foundItemReport[index])),
                                      ),
                                )),
                            ],
                          ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          bottom: 0.0,
                          child: Container(
                            color: CustomColors.lightGrey.withOpacity(0),
                            width: _isExpanded ? _expandedSize : _collapsedSize,
                            height:
                                _isExpanded ? _expandedSize : _collapsedSize,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isExpanded) ...[
                                  _buildOption('إنشاء إعلان موجود', () async {
                                    bool result = false;
                                    try {
                                      result = await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const AddFoundItemScreen()));
                                    } catch (error) {}
                                    _toggleExpanded();
                                    if (result) {
                                      // _LoadFoundItems();
                                    }
                                  }),
                                  const SizedBox(height: 16.0),
                                  _buildOption(
                                    'إنشاء إعلان مفقود',
                                    () async {
                                      bool result = false;
                                      try {
                                        result = await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const AddLostItemScreen()));
                                      } catch (error) {}
                                      _toggleExpanded();
                                      if (result) {
                                        //_LoadLostItems();
                                      }
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
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

  void filterSearchResults(String query, List ls) {
    setState(() {
      isButtonClicked = false;
      for (int item = 0; item < ls.length; item++) {
        if (ls[item]
            .description!
            .toLowerCase()
            .contains(query.toLowerCase().trim())) {
          isLost ? searchLostList.add(ls[item]) : searchFoundList.add(ls[item]);
        } //Add
        else {
          if (ls[item]
              .category!
              .toLowerCase()
              .contains(query.toLowerCase().trim())) {
            isLost
                ? searchLostList.add(ls[item])
                : searchFoundList.add(ls[item]);
          }
        }
      }
    });
  }

  Widget _buildOption(String label, VoidCallback onPressed) {
    return FloatingActionButton.extended(
      heroTag: label,
      backgroundColor: CustomColors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
      onPressed: onPressed,
      label: Text(label, style: TextStyles.btnText),
    );
  }

  Widget _buildcardList() {
    return StreamBuilder(
      stream:
          FirebaseAPI.databaseReference(isLost ? 'Lost-Items' : 'Found-Items'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            isButtonClicked == false) {
          return Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey[300]!,
            enabled: true,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),
              itemCount:
                  isLost ? lostItems.length : foundItems.length,
              itemBuilder: (context, index) {
                if (isLost) {
                  return LostCard(lostItems[0]);
                } else {
                  return FoundCard(foundItems[0]);
                }
              },
            ),
          );
        }

        final Map<dynamic, dynamic> data =
            snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
        if (data == null) {
          return Text('No data available');
        }

        List<dynamic> reports;
        if (isLost) {
          lostItems.clear();
          reports = data.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return LostItemModel(
              id: key,
              photo: value['photo'],
              category: value['category'],
              lostDate: value['lostDate'],
              expectedPlace: value['expectedPlace'],
              phoneNumber: value['phoneNumber'],
              desription: value['description'],
              creatorID: value['creatorID'],
            );
          }).toList();
          lostItems = reports.cast<LostItemModel>();
        } else {
          foundItems.clear();
          reports = data.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return FoundItemModel(
              id: key,
              category: value['Category'],
              foundDate: value['FoundDate'],
              foundPlace: value['FoundPlace'],
              receivePlace: value['ReceivePlace'],
              description: value['Description'],
              photo: value['Photo'],
            );
          }).toList();
          foundItems = reports.cast<FoundItemModel>();
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            if (isLost) {
              return LostCard(report);
            } else {
              return FoundCard(report);
            }
          },
        );
      },
    );
  }
}
