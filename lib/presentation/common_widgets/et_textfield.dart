import 'package:expense_tracking/constants/app_color.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:flutter/material.dart';

class EtTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const EtTextField(
      {super.key,
      this.label = "",
      this.controller,
      this.validator,
      this.suffixIcon,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextFormField(
          validator: validator,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: suffixIcon,
              label: Text(label),
              labelStyle: TextStyle(
                  fontSize: TextSize.medium, color: AppColor.hintColor),
              border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
