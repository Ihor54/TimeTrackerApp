import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker_app/app/sign_in/sign_in_manager.dart';
import 'package:timetracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:timetracker_app/services/auth_base.dart';
import 'email_sign_in/email_sign_in_page.dart';
import 'sign_in_btn.dart';
import 'social_sign_in_btn.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.manager, required this.isLoading})
      : super(key: key);

  final bool isLoading;
  final SignInManager manager;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) =>
                SignInPage(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        centerTitle: true,
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(child: _buildHeader(), height: 50.0),
          const SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          const SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: const Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          const SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700]!,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          const SizedBox(height: 8.0),
          const Text('or',
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
              textAlign: TextAlign.center),
          const SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in anonymously',
            textColor: Colors.black87,
            color: Colors.lightGreen[300]!,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }
}
