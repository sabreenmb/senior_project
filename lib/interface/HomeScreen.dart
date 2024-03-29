import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/ChatScreen.dart';
import 'package:senior_project/interface/SaveListScreen.dart';
import 'package:senior_project/interface/add_lost_item_screen.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/side_menu.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/Home_offer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
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

  void _LoadCreatedSessions() async {}

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 245, 242, 242),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.white,
        elevation: 0,
        title: Text("الرئيسية", style: TextStyles.heading1),
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
                  icon: Icon(Icons.home_outlined),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.apps),
                  label: 'الخدمات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.messenger_outline),
                  label: 'الدردشة',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border),
                  label: 'المحفوظات',
                ),
              ],
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                _buildCard(),
                _buildSectionTitle('يحدث اليوم'),
                _buildHorizontalScrollableCards(),
                _buildSectionTitle('أضيف حديثا'),
                _buildHorizontalScrollableCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return CarouselSlider(
      items: offers[1]['categoryList']
          .map((offer) {
            return HomeOfferCard(offer);
          })
          .toList()
          .cast<Widget>(),
      options: CarouselOptions(
        height: 180,
        autoPlay: offers[1]['categoryList'].length > 1 ? true : false,
        autoPlayInterval: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollableCards() {
    return Container(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Card(
              elevation: 4,
              shadowColor: Colors.grey.shade500,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Color.fromRGBO(89, 177, 212, 1), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 40, color: Colors.amber),
                    SizedBox(height: 10),
                    Text(
                      'ورشة عمل التخزين السحابي',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '2024-03-28',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '04:00 - 03:00',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
