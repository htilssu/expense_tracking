import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteInput extends StatefulWidget {
  final void Function(String note) onChanged;
  final String value;

  const NoteInput({super.key, required this.onChanged, required this.value});

  @override
  State<NoteInput> createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: 3,
      inputFormatters: [LengthLimitingTextInputFormatter(100)],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(NoteInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _initializeController();
    }
  }

  void _initializeController() {
    _controller = TextEditingController(
      text: widget.value,
    );
  }
}
