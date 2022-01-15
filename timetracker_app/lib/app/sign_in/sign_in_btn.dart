import 'package:flutter/cupertino.dart';
import 'package:timetracker_app/common_widgets/custom_elevated_btn.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton(
      {required String text,
      required Color color,
      required Color textColor,
      VoidCallback? onPressed,
      Key? key})
      : super(
          key: key,
          child: Text(text, style: TextStyle(color: textColor, fontSize: 15.0)),
          color: color,
          onPressed: onPressed,
        );
}
