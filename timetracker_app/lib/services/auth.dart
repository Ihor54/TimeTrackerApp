import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timetracker_app/services/auth_base.dart';

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing google id token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: "ERROR_ABORTED_BY_USER",
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User?> signInFacebook() async {
    final loginResult = await FacebookLogin().logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (loginResult.status) {
      case FacebookLoginStatus.success:
        {
          final accessToken = loginResult.accessToken;
          final userCredential = await _firebaseAuth.signInWithCredential(
              FacebookAuthProvider.credential(accessToken!.token));
          return userCredential.user;
        }
      case FacebookLoginStatus.cancel:
        {
          throw FirebaseAuthException(
            code: "ERROR_ABORTED_BY_USER",
            message: 'Sign in aborted by user',
          );
        }
      case FacebookLoginStatus.error:
        {
          throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message: loginResult.error!.developerMessage,
          );
        }
      default:
        {
          throw UnimplementedError();
        }
    }
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FacebookLogin().logOut();
    await _firebaseAuth.signOut();
  }
}
