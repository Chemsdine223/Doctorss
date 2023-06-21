import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final Icon icon;
  final int maxLength;
  final int maxLines;
  final bool hideText;
  TextInputType? textInputType;
  // Function? validate;
  String Function(String?)? validate;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.label,
    required this.icon,
    required this.maxLength,
    required this.maxLines,
    required this.hideText,
    this.textInputType,
    this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validate,
      keyboardType: textInputType,
      autocorrect: false,
      obscureText: hideText,
      maxLength: maxLength,
      maxLines: maxLines,
      controller: controller,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: hintText,
        label: Text(label),
        prefixIcon: icon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
