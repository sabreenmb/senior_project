import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/ChatScreen.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/interface/SaveListScreen.dart';
import 'package:senior_project/interface/add_lost_item_screen.dart';
//import 'package:senior_project/interface/create_group.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/model/volunteer_op_report.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/op_card.dart';
import 'package:senior_project/widgets/side_menu.dart';

class VolunteerOp extends StatefulWidget {
  const VolunteerOp({super.key});

  @override
  State<VolunteerOp> createState() => _VolunteerOpState();
}

class _VolunteerOpState extends State<VolunteerOp>
    with SingleTickerProviderStateMixin {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 2;
  //search
  ////List<VolunteerOpReport> searchSessionList = [];

  final _userInputController = TextEditingController();
  //filter
  //// bool isSearch = false;
  bool isNew = false;
  List<VolunteerOpReport> _volunteerOpReport = [];
  //create button
  late AnimationController _animationController;

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
    _LoadCreatedSessions();
  }

  void _LoadCreatedSessions() async {
    final List<VolunteerOpReport> loadedVolunteerOp = [];

    try {
      setState(() {
        isLoading = true;
      });
      final url = Uri.https('senior-project-72daf-default-rtdb.firebaseio.com',
          'opportunities.json');
      final response = await http.get(url);

      final Map<String, dynamic> volunteerdata = json.decode(response.body);
      for (final item in volunteerdata.entries) {
        loadedVolunteerOp.add(VolunteerOpReport(
          id: item.key,
          //model name : firebase name
          opName: item.value['op_name'],
          opDate: item.value['op_date'],
          opTime: item.value['op_time'],
          opLocation: item.value['op_location'],
          opNumber: item.value['op_number'],
          opLink: item.value['op_link'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      setState(() {
        isLoading = false;
        print("sabreeeen: $loadedVolunteerOp");
        _volunteerOpReport = loadedVolunteerOp;
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
        title: Text("الفرص التطوعية", style: TextStyles.heading1),
        centerTitle: false,
        iconTheme: const IconThemeData(color: CustomColors.darkGrey),
      ),
      endDrawer: const SideDrawer(),
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
              selectedItemColor: CustomColors.darkGrey,
              currentIndex: _selectedPageIndex,
              items: const [
                BottomNavigationBarItem(
                  label: 'الرئيسية',
                  icon: Icon(Icons.home_outlined),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: 'الخدمات'),
                // BottomNavigationBarItem(
                //   label: "",
                //   activeIcon: null,
                //   icon: Icon(null),
                // ),
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
      //// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ////  floatingActionButton: FloatingActionButton(
      //   heroTag: "btn1",
      //   backgroundColor: CustomColors.lightBlue,
      //   hoverElevation: 10,
      //   splashColor: Colors.grey,
      //   tooltip: '',
      //   elevation: 4,
      //   onPressed: () async {
      //     await Navigator.of(context);
      //     // .push(MaterialPageRoute(builder: (ctx) => const CreateGroup()));
      //     _LoadCreatedSessions();
      //   },
      //   child: const Icon(Icons.add),
      // ),
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
                        //   child: TextField(
                        //  autofocus: false,
                        //  controller: _userInputController,
                        // keyboardType: TextInputType.text,
                        ////     textInputAction: TextInputAction.search,
                        //textAlignVertical: TextAlignVertical.bottom,
                        // textAlign: TextAlign.start,
                        // style: const TextStyle(
                        //   color: CustomColors.darkGrey,
                        // ),
                        // decoration: InputDecoration(
                        //   hintStyle: const TextStyle(
                        //     color: CustomColors.darkGrey,
                        //   ),
                        // focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(40),
                        //  borderSide: const BorderSide(
                        // color: CustomColors.darkGrey, width: 1),
                        //   ),
                        // prefixIcon: IconButton(
                        //     icon: const Icon(
                        //       Icons.search,
                        //       color: CustomColors.darkGrey,
                        //     ),
                        //     onPressed: () {
                        //     ////  searchSessionList.clear();
                        //    ////   filterSearchResults(_userInputController.text,
                        //     //      _volunteerOpReport);
                        //       FocusScope.of(context).unfocus();
                        //     }),
                        // hintText: 'ابحث',
                        // suffixIcon: _userInputController.text.isNotEmpty
                        //     ? IconButton(
                        //         onPressed: () {
                        //           _userInputController.clear();

                        //           setState(() {
                        //        ////     isSearch = false;
                        //           });
                        //         },
                        //         icon: const Icon(Icons.clear,
                        //             color: CustomColors.darkGrey))
                        //     : null,
                        //////// enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        //   borderSide: const BorderSide(
                        //       color: CustomColors.darkGrey, width: 1),
                        // ),
                      ),
                      // onChanged: (text) {
                      //   setState(() {});
                      // },
                      // onSubmitted: (text) {
                      //   //todo the same value of on icon presed
                      //   ////   searchSessionList.clear();
                      //   ///// filterSearchResults(
                      //   ////    _userInputController.text, _volunteerOpReport);
                      //   FocusScope.of(context).unfocus();
                      // },
                      // onTap: () {
                      //   ////       isSearch = true;
                      //   ///     searchSessionList.clear();
                      //   ////     searchSessionList.clear();
                      // },
                      //),
                      //   ),
                      //// if ((isSearch
                      ////   ? searchSessionList.isEmpty
                      ////   : _volunteerOpReport.isEmpty))
                      // Expanded(
                      // child: Center(
                      //   child: SizedBox(
                      //     // padding: EdgeInsets.only(bottom: 20),
                      //     // alignment: Alignment.topCenter,
                      //     height: 200,
                      //  /////   child: Image.asset('assets/images/notFound.png'),
                      //   ),
                      // ),
                      //  ),
                      if (_volunteerOpReport.isNotEmpty)
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0),
                          //  padding: const EdgeInsets.all(8.0),
                          child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                  itemCount: _volunteerOpReport.length,
                                  /////   itemCount: searchSessionList.length,
                                  itemBuilder: (context, index) =>
                                      OpCard(_volunteerOpReport[index]))),
                        )),
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

  //////void filterSearchResults(String query, List ls) {
  // setState(() {
  //   for (int item = 0; item < ls.length; item++) {
  //     if (ls[item]
  //         .subjectCode!
  //         .toLowerCase()
  //         .contains(query.toLowerCase().trim())) {
  //       searchSessionList.add(ls[item]);
  //     } //Add
  // else {
  //   if (ls[item]
  //       .category!
  //       .toLowerCase()
  //       .contains(query.toLowerCase().trim())) {
  //     searchSessionList.add(ls[item]);
  //   }
  // }
}
