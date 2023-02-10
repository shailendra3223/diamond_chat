import 'package:diamond_chat/preferance/pref.dart';
import 'package:diamond_chat/start_quiz.dart';
import 'package:diamond_chat/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  Prefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   GetMaterialApp(
      home:  StartQuizPage(),
      debugShowCheckedModeBanner: true,
    );
  }
}