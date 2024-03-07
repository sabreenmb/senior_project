import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/ChatScreen.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/interface/SaveListScreen.dart';
import 'package:senior_project/interface/add_lost_item_screen.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/model/clinic_report.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/clinic_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:url_launcher/url_launcher.dart';

class Clinic extends StatefulWidget {
  const Clinic({super.key});

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> with SingleTickerProviderStateMixin {
  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 2;
  //search
  List<ClinicReport> filteredClinicList = [];
  List<ClinicReport> _clinicReport = [];
  List<String> sortedDates = [];
  Map<String, List<ClinicReport>> sortedGroupedClinics = {};
  // Map<String, List<ClinicReport>> groupedClinicReports = {};
  String selectedBranch = 'المقر الرئيسي';
  final _userInputController = TextEditingController();
  //String currentFilter = "";

  //filter
  //bool isSelected = true;
  bool isSearch = false;
  bool isNew = false;
  bool isLoading = false;

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
    _LoadClinics();
  }

  void _LoadClinics() async {
    final List<ClinicReport> loadedClinics = [];

    try {
      setState(() {
        isLoading = true;
      });

      final url = Uri.https(
          'senior-project-72daf-default-rtdb.firebaseio.com', 'clinicdb.json');
      final response = await http.get(url);

      final Map<String, dynamic> clinicdata = json.decode(response.body);
      for (final item in clinicdata.entries) {
        loadedClinics.add(ClinicReport(
          id: item.key,
          //model name : firebase name
          clBranch: item.value['cl_branch'],
          clDepartment: item.value['cl_department'],
          clDoctor: item.value['cl_doctor'],
          clDate: item.value['cl_date'],
          clStarttime: item.value['cl_start_time'],
          clEndtime: item.value['cl_end_time'],
        ));
      }
    } catch (error) {
      print('Empty List');
    } finally {
      setState(() {
        isLoading = false;
        print("sabreeeen: $loadedClinics");
        _clinicReport = loadedClinics;
      });
    }
    _filterClinicListByBranch();
    //  _groupAndSortClinicsByDate();
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
        title: Text("العيادات", style: TextStyles.heading1),
        centerTitle: false,
        iconTheme: const IconThemeData(color: CustomColors.darkGrey),
      ),

      endDrawer: SideDrawer(
        onProfileTap: goToProfilePage,
      ),

      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.white,
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 0.1,
      //   clipBehavior: Clip.none,
      //   child: SizedBox(
      //     height: kBottomNavigationBarHeight * 1.2,
      //     width: MediaQuery.of(context).size.width,
      //     child: Container(
      //       decoration: const BoxDecoration(
      //         color: Colors.white,
      //       ),
      //       child: BottomNavigationBar(
      //         onTap: _selectPage,
      //         unselectedItemColor: CustomColors.darkGrey,
      //         selectedItemColor: CustomColors.darkGrey,
      //         currentIndex: _selectedPageIndex,
      //         items: const [
      //           BottomNavigationBarItem(
      //             label: 'الرئيسية',
      //             icon: Icon(Icons.home_outlined),
      //           ),
      //           BottomNavigationBarItem(
      //               icon: Icon(Icons.apps), label: 'الخدمات'),
      //           BottomNavigationBarItem(
      //             label: "",
      //             activeIcon: null,
      //             icon: Icon(null),
      //           ),
      //           BottomNavigationBarItem(
      //               icon: Icon(
      //                 Icons.messenger_outline,
      //               ),
      //               label: 'الدردشة'),
      //           BottomNavigationBarItem(
      //               icon: Icon(Icons.bookmark_border), label: 'المحفوظات'),
      //         ],
      //       ),
      // ),
      //  ),
      // ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   heroTag: "btn1",
      //   backgroundColor: CustomColors.lightBlue,
      //   hoverElevation: 10,
      //   splashColor: Colors.grey,
      //   tooltip: '',
      //   elevation: 4,
      //   onPressed: () async {
      //     await Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (ctx) => const CreateGroup()));
      //     _LoadClinics();
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
                                    filteredClinicList.clear();
                                    filterSearchResults(
                                        _userInputController.text,
                                        _clinicReport);
                                    FocusScope.of(context).unfocus();
                                  }),
                              hintText: 'ابحث',
                              suffixIcon: _userInputController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _userInputController.clear();

                                        setState(() {
                                          isSearch = false;
                                          // selectedBranch =
                                          //     "";
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
                              filteredClinicList.clear();
                              filterSearchResults(
                                  _userInputController.text, _clinicReport);
                              FocusScope.of(context).unfocus();
                            },
                            onTap: () {
                              isSearch = true;
                              filteredClinicList.clear();
                              filteredClinicList.clear();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildDynamicButton("المقر الرئيسي"),
                                _buildDynamicButton("الفيصلية"),
                                _buildDynamicButton("الفيصلية مبنى 17"),
                                _buildDynamicButton("الكامل"),
                                _buildDynamicButton("خليص"),
                                _buildDynamicButton("كلية التربية"),
                                _buildDynamicButton("الكليات الصحية"),
                                _buildDynamicButton("كلية التصاميم والفنون"),
                              ],
                            ),
                          ),
                        ),
                        if ((isSearch
                            ? filteredClinicList.isEmpty
                            : _clinicReport.isEmpty))
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
                        if (_clinicReport.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                  itemCount: filteredClinicList.isEmpty
                                      ? 1
                                      : filteredClinicList.length,
                                  itemBuilder: (context, index) {
                                    if (filteredClinicList.isEmpty) {
                                      return Center(
                                        child: SizedBox(
                                          height: 200,
                                          //child: Image.asset(
                                          //   'assets/images/notFound.png'),
                                        ),
                                      );
                                    } else {
                                      ClinicReport report =
                                          filteredClinicList[index];
                                      String date = DateFormat('yyyy-MM-dd')
                                          .format(DateFormat('yyyy-MM-dd')
                                              .parse(report.clDate!));
                                      bool showDateHeader = index == 0 ||
                                          DateFormat('yyyy-MM-dd').format(
                                                  DateFormat('yyyy-MM-dd')
                                                      .parse(filteredClinicList[
                                                              index - 1]
                                                          .clDate!)) !=
                                              date;
                                      return Column(
                                        children: [
                                          if (showDateHeader)
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              //     style: TextStyle(
                                              color: TextStyles.heading3B.color,
                                              //  ),
                                              width: double.infinity,
                                              child: Text(
                                                date,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  // color: CustomColors.lightGrey,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ClinicCard(report),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              final Uri url =
                                  Uri.parse('http://bit.ly/34oXjTO');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                //  foregroundColor:
                                // Colors.white,
                                fixedSize: const Size(175, 50),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: CustomColors.lightBlue),
                            child: Text('احجز', style: TextStyles.text3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicButton(String branchName) {
    bool isChipSelected = selectedBranch == branchName;
    // isSearch =
    //     false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(branchName),
        selected: isChipSelected,
        onSelected: (bool selected) {
          setState(() {
            selectedBranch = branchName;
            _filterClinicListByBranch();
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: CustomColors.pink,
        labelStyle: TextStyle(
          color: isChipSelected ? Colors.white : Colors.black,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: isChipSelected ? Colors.transparent : CustomColors.darkGrey,
          width: 1,
        ),
      ),
    );
  }

  void _filterClinicListByBranch() {
    if (selectedBranch.isEmpty) {
      filteredClinicList = _clinicReport
          .where((clinic) => clinic.clBranch == "المقر الرئيسي")
          .toList();
    } else {
      filteredClinicList = _clinicReport
          .where((clinic) => clinic.clBranch == selectedBranch)
          .toList();
    }
    // Sort filteredClinicList by date
    filteredClinicList.sort((a, b) => DateFormat('yyyy-MM-dd')
        .parse(a.clDate!)
        .compareTo(DateFormat('yyyy-MM-dd').parse(b.clDate!)));
  }

  void filterSearchResults(String query, List ls) {
    setState(() {
      for (int item = 0; item < ls.length; item++) {
        if (ls[item]
            //.clBranch!
            .clDepartment!
            .toLowerCase()
            .contains(query.toLowerCase().trim())) {
          filteredClinicList.add(ls[item]);
        }

        //Add
        // else {
        //   if (ls[item]
        //       .category!
        //       .toLowerCase()
        //       .contains(query.toLowerCase().trim())) {
        //     searchClinicList.add(ls[item]);
        //   }
        // }
      }
    });
  }
}
