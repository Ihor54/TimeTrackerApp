import 'package:email_validator/email_validator.dart';

abstract class StringValidator {
  bool isValid(String value);
}

class PasswordValidator implements StringValidator {
  @override
  bool isValid(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}

class EmailCustomValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return EmailValidator.validate(value);
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = EmailCustomValidator();
  final StringValidator passwordValidator = PasswordValidator();
  final invlaidEmailErrorText = "Email format is invalid";
  final invlaidPasswordErrorText = "Password is invalid";
}
