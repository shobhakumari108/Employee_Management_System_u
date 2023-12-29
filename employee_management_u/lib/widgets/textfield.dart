import 'package:flutter/material.dart';

Widget buildTextFieldWithIcon({
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  TextInputType? keyboardType,
}) {
  return Container(
    height: 50,
    decoration: BoxDecoration(),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      ),
    ),
  );
}
