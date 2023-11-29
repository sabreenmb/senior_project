import 'package:flutter/material.dart';
import 'package:senior_project/interface/LostAndFoundScreen.dart';

class SaveListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Center(
      child: ElevatedButton(onPressed: () {      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LostAndFoundScreen())); }, child: Text('back'),),
    ),);
  }
}
