import 'package:expense_tracking/constants/app_color.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:flutter/material.dart';

class EtTextField extends StatelessWidget {
  String label;
  TextEditingController? controller;
  Widget? suffixIcon;
  bool obscureText;

  EtTextField(
      {super.key,
      this.label = "",
      this.controller,
      this.suffixIcon,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            label: Text(label),
            labelStyle:
                TextStyle(fontSize: TextSize.medium, color: AppColor.hintColor),
            border: OutlineInputBorder()));
  }
}
