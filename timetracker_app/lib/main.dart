import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timetracker_app/app/landing_page/landing_page.dart';
import 'package:timetracker_app/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: LandingPage(
        auth: Auth(),
      ),
    );
  }
}
