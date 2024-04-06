import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/interface/add_found_item_screen.dart';
import 'package:senior_project/interface/add_lost_item_screen.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/widgets/found_card.dart';
import 'package:senior_project/widgets/lost_card.dart';
import 'package:senior_project/theme.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/widgets/side_menu.dart';
import 'package:shimmer/shimmer.dart';
import '../constant.dart';
import '../model/found_item_report.dart';
import '../model/lost_item_report.dart';
import '../widgets/commonWidgets.dart';
import 'ChatScreen.dart';
import 'Chat_Pages/current_chats.dart';
import 'HomeScreen.dart';
import 'SaveListScreen.dart';
import '../firebaseConnection.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFoundScreen>
    with SingleTickerProviderStateMixin {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 2;
  //search
  List<LostItemReport> searchLostList = [];
  List<FoundItemReport> searchFoundList = [];

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
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  // void _LoadFoundItems() async {
  //   final List<FoundItemReport> loadedFoundItems = [];
  //
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
  //         'Found-Items.json');
  //     final response = await http.get(url);
  //
  //     final Map<String, dynamic> founddata = json.decode(response.body);
  //     for (final item in founddata.entries) {
  //       loadedFoundItems.add(FoundItemReport(
  //         id: item.key,
  //         category: item.value['Category'],
  //         foundDate: item.value['FoundDate'],
  //         foundPlace: item.value['FoundPlace'],
  //         receivePlace: item.value['ReceivePlace'],
  //         desription: item.value['Description'],
  //         photo: item.value['Photo'],
  //       ));
  //     }
  //   } catch (error) {
  //     print('Empty List');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //       _foundItemReport = loadedFoundItems;
  //     });
  //   }
  // }
  //
  // void _LoadLostItems() async {
  //   final List<LostItemReport> loadedLostItems = [];
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
  //         'Lost-Items.json');
  //     final response = await http.get(url);
  //     final Map<String, dynamic> lostdata = json.decode(response.body);
  //     for (final item in lostdata.entries) {
  //       loadedLostItems.add(LostItemReport(
  //         id: item.key,
  //         photo: item.value['Photo'],
  //         category: item.value['Category'],
  //         lostDate: item.value['LostDate'],
  //         expectedPlace: item.value['ExpectedPlace'],
  //         phoneNumber: item.value['PhoneNumber'],
  //         desription: item.value['Description'],
  //       ));
  //     }
  //   } catch (error) {
  //     print('empty list');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //       _lostItemReport = loadedLostItems;
  //     });
  //   }
  // }

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
    print('build enter');
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
          title: Text("المفقودات", style: TextStyles.heading1),
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
                          builder: (context) => const ServisesScreen()));
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
                          color: CustomColors.BackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                    Column(
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
                                    color: CustomColors.darkGrey, width: 1),
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
                                            ? lostItemReport
                                            : foundItemReport);
                                    FocusScope.of(context).unfocus();
                                  }),
                              hintText: 'ابحث',
                              suffixIcon: _userInputController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _userInputController.clear();

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
                                    color: CustomColors.darkGrey, width: 1),
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
                              filterSearchResults(_userInputController.text,
                                  isLost ? lostItemReport : foundItemReport);
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: isLost
                                            ? CustomColors.pink
                                            : Colors.transparent),
                                    child: Text("المفقودة",
                                        style: TextStyles.heading2),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: !isLost
                                            ? CustomColors.pink
                                            : Colors.transparent),
                                    child: Text(
                                      "الموجودة",
                                      style: TextStyles.heading2,
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
                                : lostItemReport.isEmpty)
                            : (isSearch
                                ? searchFoundList.isEmpty
                                : foundItemReport.isEmpty))
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                // padding: EdgeInsets.only(bottom: 20),
                                // alignment: Alignment.topCenter,
                                height: 200,
                                child:
                                    Image.asset('assets/images/notFound.png'),
                              ),
                            ),
                          ),
                        if (isLost
                            ? lostItemReport.isNotEmpty
                            : foundItemReport.isNotEmpty)
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
                                        itemBuilder: (context, index) => isLost
                                            ? LostCard(searchLostList[index])
                                            : FoundCard(searchFoundList[index]))
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
            .desription!
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
      label: Text(label, style: TextStyles.text3),
    );
  }

  Widget _buildcardList() {
    return StreamBuilder(
      stream:
          Connection.databaseReference(isLost ? 'Lost-Items' : 'Found-Items'),
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
              itemCount: isLost?lostItemReport.length:foundItemReport.length,
              itemBuilder: (context, index) {
                if (isLost) {
                  return LostCard(lostItemReport[0]);
                } else {
                  return FoundCard(foundItemReport[0]);
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
          lostItemReport.clear();
          reports = data.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return LostItemReport(
              id: key,
              photo: value['Photo'],
              category: value['Category'],
              lostDate: value['LostDate'],
              expectedPlace: value['ExpectedPlace'],
              phoneNumber: value['PhoneNumber'],
              desription: value['Description'],
            );
          }).toList();
          lostItemReport = reports.cast<LostItemReport>();
        } else {
          foundItemReport.clear();
          reports = data.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;
            return FoundItemReport(
              id: key,
              category: value['Category'],
              foundDate: value['FoundDate'],
              foundPlace: value['FoundPlace'],
              receivePlace: value['ReceivePlace'],
              desription: value['Description'],
              photo: value['Photo'],
            );
          }).toList();
          foundItemReport = reports.cast<FoundItemReport>();
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
