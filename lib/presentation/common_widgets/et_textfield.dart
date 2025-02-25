import 'package:flutter/material.dart';

class EtTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final EdgeInsets? padding;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const EtTextField(
      {super.key,
      this.label = "",
      this.controller,
      this.onChanged,
      this.padding,
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
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: suffixIcon,
              label: Text(label),
              contentPadding: padding,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              )),
        ),
      ],
    );
  }
}
