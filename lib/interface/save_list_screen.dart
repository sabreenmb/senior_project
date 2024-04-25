import 'package:flutter/material.dart';
import 'package:senior_project/common/constant.dart';
import 'package:senior_project/common/theme.dart';
import 'package:senior_project/common/common_functions.dart';
import 'package:senior_project/widgets/save_list_card.dart';
import 'package:senior_project/widgets/side_menu.dart';

class SaveListScreen extends StatefulWidget {
  const SaveListScreen({super.key});
  @override
  State<SaveListScreen> createState() => _SaveListScreenState();
}
class _SaveListScreenState extends State<SaveListScreen>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pink,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("قائمة المحفوظات", style: TextStyles.pageTitle),
        centerTitle: false,
        iconTheme: const IconThemeData(color: CustomColors.darkGrey),
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
                      color: CustomColors.backgroundColor,
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
                ),
                saveList.isEmpty?
                    Center(child: Text('لا توجد محفوظات',style: TextStyles.pageTitle2)):
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
          itemCount: saveList.length,
          itemBuilder: (context, index) => SaveCard(
                saveList[index].item,
                saveList[index].serviceName,
                saveList[index].icon,
              )),
    );
  }
}
