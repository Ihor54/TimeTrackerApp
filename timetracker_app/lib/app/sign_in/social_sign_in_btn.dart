import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:timetracker_app/common_widgets/custom_elevated_btn.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton(
      {required String assetName,
      required String text,
      required Color color,
      Color? textColor,
      VoidCallback? onPressed,
      Key? key})
      : super(
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(text, style: TextStyle(color: textColor, fontSize: 17.0)),
              Opacity(child: Image.asset(assetName), opacity: 0.0),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
