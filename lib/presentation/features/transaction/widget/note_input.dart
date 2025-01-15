import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteInput extends StatelessWidget {
  final void Function(String note) onChanged;

  const NoteInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      maxLines: 3,
      inputFormatters: [LengthLimitingTextInputFormatter(100)],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
