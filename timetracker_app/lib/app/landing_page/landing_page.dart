import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetracker_app/app/home_page/home_page.dart';
import 'package:timetracker_app/app/sing_in/sign_in_page.dart';
import 'package:timetracker_app/services/auth_base.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        onSignIn: _updateUser,
        auth: widget.auth,
      );
    }
    return HomePage(
      onSignOut: () => _updateUser(null),
      auth: widget.auth,
    );
  }
}
