import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_app/app/home_page/home_page.dart';
import 'package:timetracker_app/app/sign_in/sign_in_page.dart';
import 'package:timetracker_app/services/auth_base.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return SignInPage();
            }
            return HomePage();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
