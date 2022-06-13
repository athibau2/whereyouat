import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whereyouat/widgets/custom_button.dart';

class SocialSignInButton extends CustomButton {
  SocialSignInButton({
    required String asset,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
    double? borderRadius = 10,
    ButtonStyle? style,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(asset),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              Opacity(
                child: Image.asset('images/google-logo.png'),
                opacity: 0.0,
              ),
            ],
          ),
          onPressed: onPressed,
          color: color,
          borderRadius: borderRadius,
        );
}
