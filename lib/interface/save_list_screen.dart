import 'package:flutter/material.dart';
import 'package:senior_project/constant.dart';
import 'package:senior_project/theme.dart';
import 'package:senior_project/widgets/commonWidgets.dart';
import 'package:senior_project/widgets/save_list_card.dart';
import 'package:senior_project/widgets/side_menu.dart';

class SaveListScreen extends StatefulWidget {
  const SaveListScreen({super.key});

  @override
  State<SaveListScreen> createState() => _SaveListScreenState();
}

class _SaveListScreenState extends State<SaveListScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //todo move it to the login screen
     EmptyList=  saveList.isEmpty;

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
        onProfileTap: () => goToProfilePage(context),
      ),
      bottomNavigationBar: buildBottomBar(context, 3, false, isSaved: true),
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
                  ),
                  // child: _buildItems(),
                ),
                EmptyList?
                    Center(child: Text('لا توجد محفوظات',style: TextStyles.heading11)):

                _buildItems(),

              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildItems() {

    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          // scrollDirection: Axis.,
          itemCount: saveList.length,
          itemBuilder: (context, index) => SaveCard(
                saveList[index].item,
                saveList[index].serviceName,
                saveList[index].icon,
              )),

      // ),
      // ),
    );
  }
}
