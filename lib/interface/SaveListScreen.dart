import 'package:flutter/material.dart';
import 'package:senior_project/interface/LostAndFoundScreen.dart';

class SaveListScreen extends StatelessWidget {
  const SaveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Center(
      child: ElevatedButton(onPressed: () {      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LostAndFoundScreen())); }, child: const Text('back'),),
    ),);
  }
}
