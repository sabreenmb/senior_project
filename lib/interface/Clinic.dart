import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/model/clinic_report.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/clinic_card.dart';
import 'package:senior_project/widgets/commonWidgets.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:url_launcher/url_launcher.dart';

class Clinic extends StatefulWidget {
  const Clinic({super.key});

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> with SingleTickerProviderStateMixin {
  //search
  List<ClinicReport> filteredClinicList = [];
  List<ClinicReport> _clinicReport = [];
  List<String> sortedDates = [];
  Map<String, List<ClinicReport>> sortedGroupedClinics = {};
  String selectedBranch = 'المقر الرئيسي';
  final _userInputController = TextEditingController();

  bool isSearch = false;
  bool isNew = false;
  bool isLoading = false;

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
          title: Text("العيادات", style: TextStyles.heading1),
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
        // bottomNavigationBar: buildBottomBar(context, 1, true),
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
                                          _userInputController.text);
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
                                filteredClinicList.clear();
                                filterSearchResults(text);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                          // if ((isSearch
                          //     ? filteredClinicList.isEmpty
                          //     : _clinicReport.isEmpty))
                          //   Expanded(
                          //     child: Center(
                          //       child: SizedBox(
                          //         // padding: EdgeInsets.only(bottom: 20),
                          //         // alignment: Alignment.topCenter,
                          //         height: 200,
                          //         child:
                          //             Image.asset('assets/images/notFound.png'),
                          //       ),
                          //     ),
                          //   ),
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
                                            child: Image.asset(
                                                'assets/images/notFound.png'),
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
                                                        .parse(
                                                            filteredClinicList[
                                                                    index - 1]
                                                                .clDate!)) !=
                                                date;
                                        return Column(
                                          children: [
                                            if (showDateHeader)
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                // padding: const EdgeInsets.only(
                                                //     bottom: 8),
                                                //     style: TextStyle(
                                                color:
                                                    TextStyles.heading3B.color,
                                                //  ),
                                                width: double.infinity,
                                                child: Text(
                                                  date,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        CustomColors.darkGrey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            // SizedBox(height: 3.0),
                                            ClinicCard(report),
                                            //    ),
                                            if (index <
                                                filteredClinicList.length - 1)
                                              const SizedBox(height: 3),
                                            //),
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
      ),
    );
  }

  Widget _buildDynamicButton(String branchName) {
    bool isChipSelected = selectedBranch == branchName;
    isSearch = false;
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
    filteredClinicList.sort((a, b) => DateFormat('yyyy-MM-dd')
        .parse(a.clDate!)
        .compareTo(DateFormat('yyyy-MM-dd').parse(b.clDate!)));
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredClinicList.clear();

      if (query.isNotEmpty) {
        List<ClinicReport> tempList = _clinicReport.where((report) {
          bool isSameBranch = report.clBranch == selectedBranch;
          bool matchesQuery = report.clDepartment!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              report.clDoctor!.toLowerCase().contains(query.toLowerCase());

          return isSameBranch && matchesQuery;
        }).toList();

        filteredClinicList.addAll(tempList);
      } else {
        filteredClinicList = _clinicReport
            .where((report) => report.clBranch == selectedBranch)
            .toList();
      }
    });
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
