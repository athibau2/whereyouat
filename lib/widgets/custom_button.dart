import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? borderRadius;
  final VoidCallback? onPressed;
  final double? height;
  const CustomButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
    this.borderRadius = 10,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        color: color,
        disabledColor: color,
        child: child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius!),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
