// ignore_for_file: unused_field

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
import '../constant.dart';
import '../model/found_item_report.dart';
import '../model/lost_item_report.dart';
import 'ChatScreen.dart';
import 'HomeScreen.dart';
import 'SaveListScreen.dart';

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
  bool isNew = false;
  List<LostItemReport> _lostItemReport = [];
  List<FoundItemReport> _foundItemReport = [];
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
    _pages = [
      {
        'page': const HomeScreen(),
      },
      {
        'page': const ChatScreen(),
      },
      {
        'page': const AddLostItemScreen(),
      },
      {
        'page': const ServisesScreen(),
      },
      {
        'page': const SaveListScreen(),
      },
    ];
    _LoadLostItems();
    _LoadFoundItems();
  }

  void _LoadFoundItems() async {
    final List<FoundItemReport> loadedFoundItems = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'Found-Items.json');
      final response = await http.get(url);

      final Map<String, dynamic> founddata = json.decode(response.body);
      for (final item in founddata.entries) {
        loadedFoundItems.add(FoundItemReport(
          id: item.key,
          category: item.value['Category'],
          foundDate: item.value['FoundDate'],
          foundPlace: item.value['FoundPlace'],
          receivePlace: item.value['ReceivePlace'],
          desription: item.value['Description'],
          photo: item.value['Photo'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      setState(() {
        isLoading = false;
        _foundItemReport = loadedFoundItems;
      });
    }
  }

  void _LoadLostItems() async {
    final List<LostItemReport> loadedLostItems = [];
    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'Lost-Items.json');
      final response = await http.get(url);
      final Map<String, dynamic> lostdata = json.decode(response.body);
      for (final item in lostdata.entries) {
        loadedLostItems.add(LostItemReport(
          id: item.key,
          photo: item.value['Photo'],
          category: item.value['Category'],
          lostDate: item.value['LostDate'],
          expectedPlace: item.value['ExpectedPlace'],
          phoneNumber: item.value['PhoneNumber'],
          desription: item.value['Description'],
        ));
      }
    } catch (error) {
      print('empty list');
    } finally {
      setState(() {
        isLoading = false;
        _lostItemReport = loadedLostItems;
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
        _selectedPageIndex = index;
      }
      //todo uncomment on next sprints
      // if (index == 0) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => HomeScreen()));
      // } else if (index == 1) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => ServisesScreen()));
      // } else if (index == 2) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => ChatScreen()));
      // } else if (index == 3) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => SaveListScreen()));
      // }
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build enter');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("المفقودات", style: TextStyles.heading1),
        centerTitle: false,
        iconTheme: const IconThemeData(color: CustomColors.darkGrey),
      ),
      endDrawer: SideDrawer(
        onProfileTap: goToProfilePage,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.1,
        clipBehavior: Clip.none,
        child: SizedBox(
          height: kBottomNavigationBarHeight * 1.2,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              unselectedItemColor: CustomColors.darkGrey,
              selectedItemColor: CustomColors.lightBlue,
              currentIndex: _selectedPageIndex,
              items: const [
                BottomNavigationBarItem(
                  label: 'الرئيسية',
                  icon: Icon(Icons.home_outlined),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: 'الخدمات'),
                BottomNavigationBarItem(
                  label: "",
                  activeIcon: null,
                  icon: Icon(null),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.messenger_outline,
                    ),
                    label: 'الدردشة'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_border), label: 'المحفوظات'),
              ],
            ),
          ),
        ),
      ),
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
                        padding:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                                          ? _lostItemReport
                                          : _foundItemReport);
                                  FocusScope.of(context).unfocus();
                                }),
                            hintText: 'ابحث',
                            suffixIcon: _userInputController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _userInputController.clear();

                                      setState(() {
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
                                isLost ? _lostItemReport : _foundItemReport);
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                if (isLost != true) {
                                  setState(() {
                                    isLost = true;
                                    if (isSearch) {
                                      _userInputController.clear();
                                      isSearch = false;
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(175, 40),
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
                              child:
                                  Text("المفقودة", style: TextStyles.heading2),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (isLost == true) {
                                  setState(() {
                                    isLost = false;
                                    if (isSearch) {
                                      _userInputController.clear();
                                      isSearch = false;
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(175, 40),
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
                          ],
                        ),
                      ),
                      if (isLost
                          ? (isSearch
                              ? searchLostList.isEmpty
                              : _lostItemReport.isEmpty)
                          : (isSearch
                              ? searchFoundList.isEmpty
                              : _foundItemReport.isEmpty))
                        Expanded(
                          child: Center(
                            child: Container(
                              // padding: EdgeInsets.only(bottom: 20),
                              // alignment: Alignment.topCenter,
                              height: 200,
                              child: Image.asset('assets/images/notFound.png'),
                            ),
                          ),
                        ),
                      if (isLost
                          ? _lostItemReport.isNotEmpty
                          : _foundItemReport.isNotEmpty)
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
                                : ListView.builder(
                                    itemCount: isLost
                                        ? _lostItemReport.length
                                        : _foundItemReport.length,
                                    itemBuilder: (context, index) => isLost
                                        ? LostCard(_lostItemReport[index])
                                        : FoundCard(_foundItemReport[index])),
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
                          height: _isExpanded ? _expandedSize : _collapsedSize,
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
                                    _LoadFoundItems();
                                  }
                                }),
                                const SizedBox(height: 16.0),
                                _buildOption(
                                  'إنشاء إعلان مفقود',
                                  () async {
                                    bool result = false;
                                    try {
                                      result = await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const AddLostItemScreen()));
                                    } catch (error) {}
                                    _toggleExpanded();
                                    if (result) {
                                      _LoadLostItems();
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
    );
  }

  void filterSearchResults(String query, List ls) {
    setState(() {
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
}
