import 'package:flutter/material.dart';
import 'package:literalink/main.dart';

Widget authField(TextEditingController controller, String label,
    GlobalKey<FormState> formKey,
    {TextEditingController? otherController}) {
  bool isPasswordField = label.startsWith("Password");
  bool isEmailField = label.startsWith("Email");

  String labelText;
  switch (label) {
    case "Password2":
      labelText = "Repeat your Password";
      break;
    case "Password1":
      labelText = "Enter your Password";
      break;
    default:
      labelText = "Enter your $label";
  }

  IconData prefixIcon;
  if (isPasswordField) {
    prefixIcon = Icons.lock;
  } else if (isEmailField) {
    prefixIcon = Icons.mail;
  } else {
    prefixIcon = Icons.person;
  }

  return SizedBox(
    height: 82,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: const Color(0xFFF7F8F9),
        filled: true,
        prefixIcon: Icon(prefixIcon),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDADADA)),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: LiteraLink.darkGreen),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF8391A1)),
      ),
      obscureText: isPasswordField,
      validator: (value) => _validateField(value, label, otherController),
    ),
  );
}

String? _validateField(
    String? value, String label, TextEditingController? otherController) {
  if (value == null || value.isEmpty) {
    return 'Field cannot be empty';
  }
  if (label.startsWith("Password")) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (isNumericOnly(value)) {
      return 'Password cannot be entirely numeric';
    }
  }
  if (label == "Password2" &&
      otherController != null &&
      value != otherController.text) {
    return 'Passwords do not match';
  }
  if (label == "Email" && !value.contains('@')) {
    return 'Please enter a valid email';
  }
  return null;
}

bool isNumericOnly(String password) {
  return RegExp(r'^\d+$').hasMatch(password);
}
