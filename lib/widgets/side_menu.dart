import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../theme.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColors.BackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                //border: Unde
                ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50, bottom: 20),
                  alignment: Alignment.topCenter,
                  height: 150,
                  decoration: BoxDecoration(
                    color: CustomColors.lightGrey.withOpacity(0.3),
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/UserProfile.png'),
                    ),
                  ),
                ),
                Text(
                  "منار محمود مجيد",
                  style: TextStyles.heading2,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
                //mainAxisAlignment: ,
                children: [
                  menuItem("assets/icons/profileIcon.svg", "الملف الشخصي"),
                  SizedBox(height: 10),
                  menuItem("assets/icons/logout.svg", "تسجيل الخروج"),
                ]),
          ),
        ],
      ),
    );
  }

  Widget menuItem(String itemIcon, String itemTitle) {
    return Material(
      child: InkWell(
        //onTap: (){}, //  Padding(
        child: Container(
          decoration: BoxDecoration(
            color: CustomColors.lightBlue.withOpacity(0.3),
            border: const Border(
              top: BorderSide(color: CustomColors.lightBlue, width: 1),
              bottom: BorderSide(color: CustomColors.lightBlue, width: 1),
              left: BorderSide(color: CustomColors.lightBlue, width: 8),
              right: BorderSide(color: CustomColors.lightBlue, width: 1),
            ),
          ),
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    itemIcon,
                    height: 30,
                    width: 30,
                    color: CustomColors.darkGrey.withOpacity(0.8),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  itemTitle,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        //),
      ),
    );
  }
}
