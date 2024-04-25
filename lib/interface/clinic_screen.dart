import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/common/common_functions.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/common/theme.dart';
import 'package:senior_project/model/clinic_model.dart';
import 'package:senior_project/widgets/clinic_card.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:url_launcher/url_launcher.dart';

class Clinic extends StatefulWidget {
  const Clinic({super.key});

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> with SingleTickerProviderStateMixin {
  //search
  List<ClinicModel> filteredClinicList = [];
  List<String> sortedDates = [];
  String selectedBranch = 'المقر الرئيسي';
  final _userInputController = TextEditingController();

  bool isSearch = false;
  bool isNew = false;
  bool isLoading = false;
  bool searchPerformedAndEmpty = false;

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
    _filterClinicListByBranch();
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
          title: Text("العيادات", style: TextStyles.pageTitle),
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
                              style: TextStyles.heading2D,
                              decoration: InputDecoration(
                                hintStyle: TextStyles.heading2D,
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
                                            _filterClinicListByBranch();
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
                                      String imagePath = searchPerformedAndEmpty
                                          ? 'assets/images/searching-removebg-preview.png'
                                          : 'assets/images/no_content_removebg_preview.png';
                                      return Center(
                                        child: Container(
                                          height:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          child: Image.asset(imagePath,
                                              height: 200),
                                        ),
                                      );
                                    } else {
                                      ClinicModel report =
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
                                              padding: const EdgeInsets.all(6),
                                              color: CustomColors.lightBlue,
                                              width: double.infinity,
                                              child: Text(
                                                date,
                                                style: TextStyles.heading3D,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ClinicCard(report),
                                          if (index <
                                              filteredClinicList.length - 1)
                                            const SizedBox(height: 3),
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
                                if (!await launchUrl(url,
                                    mode: LaunchMode.externalApplication)) {
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
                              child: Text('احجز', style: TextStyles.btnText),
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
            isSearch = false;
            searchPerformedAndEmpty = false;
          });
        },
        backgroundColor: CustomColors.backgroundColor,
        selectedColor: CustomColors.pink,
        labelStyle: TextStyles.heading2D,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: isChipSelected ? CustomColors.noColor : CustomColors.darkGrey,
          width: 1,
        ),
      ),
    );
  }

  void _filterClinicListByBranch() {
    if (selectedBranch.isEmpty) {
      filteredClinicList = clinicItems
          .where((clinic) => clinic.clBranch == "المقر الرئيسي")
          .toList();
    } else {
      filteredClinicList = clinicItems
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
      searchPerformedAndEmpty = false;

      if (query.isNotEmpty) {
        searchPerformedAndEmpty = true;
        List<ClinicModel> tempList = clinicItems.where((report) {
          bool isSameBranch = report.clBranch == selectedBranch;
          bool matchesQuery = report.clDepartment!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              report.clDoctor!.toLowerCase().contains(query.toLowerCase());

          return isSameBranch && matchesQuery;
        }).toList();

        filteredClinicList.addAll(tempList);
      } else {
        filteredClinicList = clinicItems
            .where((report) => report.clBranch == selectedBranch)
            .toList();
      }
    });
  }
}
