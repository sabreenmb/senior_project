import 'package:flutter/material.dart';
import '../theme.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: ,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  CustomColors.lightGrey.withOpacity(0.6),
                  CustomColors.lightGrey,
                ],
                center: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.add, size: 30, color: CustomColors.noColor),
                const SizedBox(width: 18),
                Text("data", style: TextStyles.text3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
