import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Screen/RegisterScreen.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Code',
      debugShowCheckedModeBanner: false,
      home:
          LoginScreen(),
          // RegisterScreen(),
          // HomeScreen(),
      // CreateEvent(),
      // DetailEvent(),
    );
  }
}
