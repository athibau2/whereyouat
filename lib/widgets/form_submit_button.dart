import 'package:flutter/material.dart';
import 'custom_button.dart';

class FormSubmitButton extends CustomButton {
  FormSubmitButton({required String text, required VoidCallback? onPressed})
      : super(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          height: 44.0,
          color: Colors.indigo,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
