// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    required this.textInputType,
    required this.validator,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType textInputType;
  final String? Function(String?) validator;
  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context, color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(10));
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
          hintText: hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          fillColor: Colors.white12,
          contentPadding: const EdgeInsets.all(10)),
    );
  }
}
