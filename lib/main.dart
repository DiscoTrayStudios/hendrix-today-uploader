import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:hendrix_today_uploader/firebase_options.dart';
import 'package:hendrix_today_uploader/screens/main_menu.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainMenuScreen(),
    );
  }
}
