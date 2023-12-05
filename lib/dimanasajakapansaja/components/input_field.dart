import 'package:flutter/material.dart';

Widget addStationField(
  TextEditingController controller,
  String label,
  GlobalKey<FormState> formKey,
  String? initialValue, // membuat parameter ini nullable
) {
  // Hanya set nilai awal jika initialValue tidak null
  if (initialValue != null && controller.text.isEmpty) {
    controller.text = initialValue;
  }

  bool isPasswordField = label.startsWith("Password");

  String labelText = label == "Password2"
      ? "Repeat your Password"
      : label == "Password1"
          ? "Enter your Password"
          : "Enter your $label";

  return SizedBox(
    height: 77,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: const Color(0xFFF7F8F9),
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDADADA)),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal), // Contoh warna
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
      validator: (value) => _validateField(
          value, label), // Pastikan Anda memiliki fungsi validator ini
    ),
  );
}

String? _validateField(String? value, String label) {
  // Implementasikan logika validasi di sini
  // Contoh sederhana:
  if (value == null || value.isEmpty) {
    return 'Please enter your $label';
  }
  return null;
}
