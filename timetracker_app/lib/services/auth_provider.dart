import 'package:flutter/cupertino.dart';
import 'package:timetracker_app/services/auth_base.dart';

//example of InheritedWidget

class AuthProvider extends InheritedWidget {
  AuthProvider({
    Key? key,
    required this.auth,
    required Widget child,
  }) : super(key: key, child: child);

  final AuthBase auth;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AuthBase of(BuildContext context) {
    AuthProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider!.auth;
  }
}
