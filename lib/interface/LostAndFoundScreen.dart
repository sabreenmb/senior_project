import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_project/interface/LostReportCreation.dart';
import 'package:senior_project/interface/ServicesScreen.dart';
import 'package:senior_project/widgets/LostAndFoundItems.dart';
import 'package:senior_project/theme.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../model/lost_item_report.dart';
import 'ChatScreen.dart';
import 'HomeScreen.dart';
import 'SaveListScreen.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFoundScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  final _userInputController = TextEditingController();
  final isLost = true;
  List<LostItemReport> _lostItemReport = [];
  @override
  void initState() {
    super.initState();

    _pages = [
      {
        'page': HomeScreen(),
      },
      {
        'page': ChatScreen(),
      },
      {
        'page': LostItemAddScreen(),
      },
      {
        'page': ServisesScreen(),
      },
      {
        'page': SaveListScreen(),
      },
    ];
    _LoadItems();
  }

  void _LoadItems() async {
    final url = Uri.https(
        'senior-project-72daf-default-rtdb.firebaseio.com', 'Lost-Items.json');
    final response = await http.get(url);
    final Map<String, dynamic> lostdata = json.decode(response.body);
    final List<LostItemReport> _loadedLostItems = [];
    for (final item in lostdata.entries) {

      _loadedLostItems.add(LostItemReport(
        id: item.key,
        photo: item.value['PhotoBase64'],
        category: item.value['Category'],
        lostDate: item.value['LostDate'],
        expectedPlace: item.value['ExpectedPlace'],
        desription: item.value['Description'],
      ));
    }
    setState(() {
      _lostItemReport=_loadedLostItems;
    });
    print(response.body);
  }

  void _addItem() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => LostItemAddScreen()));
    _LoadItems();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("المفقودات", style: TextStyles.heading1),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        // color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedItemColor: CustomColors.lightBlue,
              selectedItemColor: Colors.purple,
              currentIndex: _selectedPageIndex,
              items: [
                BottomNavigationBarItem(
                  label: 'home',
                  icon: Icon(Icons.home_outlined),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: 'services'),
                BottomNavigationBarItem(
                  label: "",
                  activeIcon: null,
                  icon: Icon(null),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.messenger_outline,
                    ),
                    label: 'chat'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_border), label: 'save list'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          hoverElevation: 10,
          splashColor: Colors.grey,
          tooltip: 'create',
          elevation: 4,
          child: Icon(Icons.add),
          onPressed: _addItem,
          //     () => setState(() {
          //   _selectedPageIndex = 2;
          //   Navigator.pushReplacement(
          //       context, MaterialPageRoute(builder: (_) => LostItemAddScreen()));
          // }),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 15),
            Expanded(
                child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: CustomColors.BackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                ),
                Column(
                  children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
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
                          hintStyle: TextStyle(
                            color: CustomColors.darkGrey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: CustomColors.darkGrey, width: 1),
                            // style: BorderStyle.solid, color: CustomColors.white, width: 1,
                            // color: Colors.transparent,
                          ),
                          prefixIcon: IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: CustomColors.darkGrey,
                              ),
                              onPressed: () {
                                // searchList.clear();
                                //
                                // filterSearchResults(
                                //     _userInputController.text);
                              }),
                          hintText: 'ابحث',
                          suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: CustomColors.darkGrey,
                              ),
                              onPressed: () {
                                // searchList.clear();
                                //
                                // filterSearchResults(
                                //     _userInputController.text);
                              }),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: CustomColors.white, width: 1),

                            // style: BorderStyle.solid, color: Colors.white, width: 1,
                            // color: Colors.transparent,
                          ),
                        ),
                        onSubmitted: (text) {
                          // searchList.clear();
                          //
                          // filterSearchResults(_userInputController.text);
                          // searchList.clear();
                        },
                        onTap: () {
                          // searchList.clear();
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
                            onPressed: () {},
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
                            child: Text("المفقودة", style: TextStyles.heading2),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {},
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
                          // Show All button
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: _lostItemReport.length,
                            itemBuilder: (context, index) =>
                                LostAndFoundCard(_lostItemReport[index])),
                      ),
                    )
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
