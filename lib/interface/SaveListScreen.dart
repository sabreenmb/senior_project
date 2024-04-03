import 'package:flutter/material.dart';
import 'package:senior_project/interface/lost_and_found_screen.dart';

class SaveListScreen extends StatelessWidget {
  const SaveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LostAndFoundScreen()));
            },
            child: const Text('back'),
          ),
        ),
      ),
    );
  }
}
