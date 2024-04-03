import 'package:flutter/material.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/widgets/grid_card.dart';
import 'package:senior_project/widgets/side_menu.dart';

import '../constant.dart';
import '../theme.dart';
import 'ChatScreen.dart';
import 'HomeScreen.dart';
import 'SaveListScreen.dart';

class OffersListScreen extends StatefulWidget {
  const OffersListScreen({super.key});

  @override
  State<OffersListScreen> createState() => _OffersListState();
}

class _OffersListState extends State<OffersListScreen> {
  @override
  void initState() {
    super.initState();
    // _LoadOffers();
  }

  // void _LoadOffers() async {
  //   final List<OfferInfo> loadedOfferInfo = [];
  //
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final url = Uri.https(
  //         'senior-project-72daf-default-rtdb.firebaseio.com', 'offersdb.json');
  //     final response = await http.get(url);
  //
  //     final Map<String, dynamic> founddata = json.decode(response.body);
  //     for (final item in founddata.entries) {
  //       print(item.value['of_name']);
  //       loadedOfferInfo.add(OfferInfo(
  //         id: item.key,
  //         //model name : firebase name
  //         name: item.value['of_name'],
  //         logo: item.value['of_logo'],
  //         category: item.value['of_category'],
  //         code: item.value['of_code'],
  //         details: item.value['of_details'],
  //         discount: item.value['of_discount'],
  //         expDate: item.value['of_expDate'],
  //         contact: item.value['of_contact'],
  //         targetUsers: item.value['of_target'],
  //       ));
  //     }
  //   } catch (error) {
  //     print('Empty List');
  //   } finally {
  //     List<OfferInfo> fetchedOffers = await loadedOfferInfo;// fetched data from Firebase
  //
  //     for (OfferInfo offer in fetchedOffers) {
  //       for (Map<String, dynamic> item in offers) {
  //         if (offer.category == item['offerCategory']) {
  //           item['categoryList'].add(offer);
  //           break;
  //         }
  //       }
  //     }
  //     print(offers[0]);
  //     setState(() {
  //       isLoading = false;
  //
  //     });
  //
  //
  //   }
  // }

  // ignore: unused_field
  int _selectedPageIndex = 1;
  void _selectPage(int index) {
    index = 1;
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
      } else if (index == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      } else if (index == 3) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SaveListScreen()));
      }
      _selectedPageIndex = index;
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.pink,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.pink,
          elevation: 0,
          title: Text("العروض", style: TextStyles.heading1),
          centerTitle: false,
          iconTheme: const IconThemeData(color: CustomColors.darkGrey),
          // Drawer: SideDrawer(onProfileTap: goToProfilePage, )
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
                currentIndex: 1,
                items: const [
                  BottomNavigationBarItem(
                    label: 'الرئيسية',
                    icon: Icon(Icons.home_outlined),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.apps), label: 'الخدمات'),
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
        body: SafeArea(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 25.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 1.3),
                        itemCount: offers.length,
                        itemBuilder: (context, i) =>
                            GridCard(offers[i], i, false)),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
