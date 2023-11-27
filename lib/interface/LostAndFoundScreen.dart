import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senior_project/widgets/LostAndFoundItems.dart';
import 'package:senior_project/theme.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFoundScreen> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysHide;

  final _userInputController = TextEditingController();
  final isLost=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text(
          "المفقودات",
          style:TextStyles.heading1
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,

        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home,color: CustomColors.lightBlue,),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.apps_rounded,color: CustomColors.lightBlue),
            icon: Icon(Icons.apps),
            label: 'Commute',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.messenger_rounded,color: CustomColors.lightBlue),
            icon: Icon(Icons.messenger_outline_outlined),
            label: 'Saved',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark,color: CustomColors.lightBlue),
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 10),
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
                      padding: EdgeInsets.only(top: 15,left: 15,right: 15),
                      child: TextField(
                        autofocus: true,
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
                              icon: const Icon(Icons.search,color: CustomColors.darkGrey,),
                              onPressed: () {
                                // searchList.clear();
                                //
                                // filterSearchResults(
                                //     _userInputController.text);
                              }),
                          hintText: 'ابحث',
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.clear,color: CustomColors.darkGrey,),
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
                            onPressed: (){},
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
                                backgroundColor: isLost?CustomColors.pink:Colors.transparent),

                            child: Text(
                              "المفقودة",
                              style: TextStyles.heading2
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: (){},
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
                                backgroundColor: !isLost?CustomColors.pink:Colors.transparent),
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
                            itemCount: 6,
                            itemBuilder: (context, index) => LostAndFoundCard()),
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
