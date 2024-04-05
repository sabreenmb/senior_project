import 'package:flutter/material.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/interface/Chat_Pages/current_chats.dart';
import 'package:senior_project/interface/HomeScreen.dart';
import 'package:senior_project/interface/ProfilePage.dart';
import 'package:senior_project/interface/services_screen.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/side_menu.dart';

class SaveListScreen extends StatefulWidget {
  const SaveListScreen({super.key});

  @override
  State<SaveListScreen> createState() => _SaveListScreenState();
}

class _SaveListScreenState extends State<SaveListScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 3;

  @override
  void _selectPage(int index) {
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ServisesScreen()));
      } else if (index == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const CurrentChats()));
      } else if (index == 3) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SaveListScreen()));
        _selectedPageIndex = index;
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
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("قائمة المحفوظات", style: TextStyles.heading1),
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
              currentIndex: 3,
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
                const SizedBox(height: 15),
                Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    // color: const Color.fromARGB(255, 187, 55, 55),
                  ),
                  // margin: const EdgeInsets.only(bottom: 10),

                  // child: ElevatedButton(
                  //   onPressed: addTofire(),
                  //   child: Text("test"),
                  // )
                  child: InkWell(
                    child: _buildItems(),
                  ),
                )

                // _buildHorizontalScrollableCards(combinedList),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildItems() {
    print('kiss');
    print(courseItem.length);
    return Container(
      height: 240,
      child: ListView.builder(
          // scrollDirection: Axis.,
          itemCount: saveList.length,
          itemBuilder: (context, index) => _buildTextCard(
                saveList[index].serviceName,
                saveList[index].item,
                saveList[index].icon,
              )),
    );
  }

  Widget _buildTextCard(String title, dynamic item, String icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: CustomColors.lightBlue, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          print('Card tapped');
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image.asset(icon, width: 50,
                  errorBuilder: (context, error, stackTrace) {
                print('Failed to load image: $icon');
                return Icon(Icons.broken_image);
              }),
              Container(
                width: 30.0,
                child: VerticalDivider(
                  thickness: 3.0,
                  color: CustomColors.darkGrey,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.lightBlue)),
                    SizedBox(height: 10),
                    Text(item.name,
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey)),
                    SizedBox(height: 5),
                    Text(item.location,
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey)),
                    SizedBox(height: 5),
                    Text(item.date,
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey)),
                    SizedBox(height: 5),
                    Text(item.time,
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
