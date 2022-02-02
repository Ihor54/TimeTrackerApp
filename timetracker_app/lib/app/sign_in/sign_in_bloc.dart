import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:timetracker_app/services/auth_base.dart';

class SignInBloc {
  SignInBloc({required this.auth});

  final AuthBase auth;
  final _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User?> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);

  Future<User?> signInFacebook() async => await _signIn(auth.signInFacebook);
}
