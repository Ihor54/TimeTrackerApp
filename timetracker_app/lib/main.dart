import 'package:flutter/material.dart';
import 'package:timetracker_app/app/sing_in/sign_in_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const SignInPage(),
    );
  }
}
