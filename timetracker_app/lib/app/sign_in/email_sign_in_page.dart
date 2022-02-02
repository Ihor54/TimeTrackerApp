import 'package:flutter/material.dart';
import 'package:timetracker_app/app/sign_in/email_sing_in_form_bloc_based.dart';
import 'package:timetracker_app/app/sign_in/email_sing_in_form_change_notifier.dart';

import 'email_sing_in_form_stateful.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        centerTitle: true,
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(child: EmailSignInFormChangeNotifier.create(context)),
        ),
      ),
    );
  }
}
