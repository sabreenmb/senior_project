import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/interface/textBox.dart';
import '../theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollestion = FirebaseFirestore.instance.collection("users");
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("تعديل $field"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "ادخل $field",
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            //cancel button
            TextButton(
              child: const Text(
                'انهاء',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            //save button
            TextButton(
              child: const Text(
                'حفظ',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),
          ]),
    );

    //update
    if (newValue.trim().isNotEmpty) {
      await userCollestion.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.pink,
        elevation: 0,
        title: Text("الملف الشخصي", style: TextStyles.heading1),
        //centerTitle: false,
        iconTheme: const IconThemeData(color: CustomColors.darkGrey),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50),
          //profile pic **icon now change it later**
          const Icon(
            Icons.person,
            size: 100,
          ),

          const SizedBox(height: 10),


          //intrests   **change  ID**
          MyTextBox(
            text: '',
            sectionIntrests: 'الاهتمامات',
            onPressed: () => editField('الاهتمامات'),
          ),

          //hobbies    **change the ID**
          MyTextBox(
            text: '',
            sectionIntrests: 'هوايات',
            onPressed: () => editField('هوايات'),
          ),

          //skills     **change the ID**
          MyTextBox(
            text: '',
            sectionIntrests: 'ما يمكنك اضافته في المجتمع',
            onPressed: () => editField('ما يمكنك اضافته في المجتمع'),
          ),

          //recomendations

          TextButton(
            child: const Text(
              'انهاء',
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          const TextButton(
            onPressed: null,
            child: Text(
              'تطبيق',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
