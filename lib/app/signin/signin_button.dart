import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whereyouat/widgets/custom_button.dart';

class SignInButton extends CustomButton {
  SignInButton({
    required String text,
    required Color textColor,
    required VoidCallback? onPressed,
    double? borderRadius = 10,
    Color? color,
    ButtonStyle? style,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15),
          ),
          onPressed: onPressed,
          color: color,
          borderRadius: borderRadius,
        );
}
