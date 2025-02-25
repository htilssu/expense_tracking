import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:flutter/material.dart';

class NumberInput extends StatefulWidget {
  final void Function(double value) onChanged;

  const NumberInput({super.key, required this.onChanged});

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EtTextField(
      controller: _controller,
      onChanged: (value) {
        if (value.isEmpty) {
          widget.onChanged(0);
          return;
        }

        var valueDouble = value.replaceAll(RegExp(r'\D|\.(?!=\.)'), '');
        _controller.value = _controller.value.copyWith(
          text: valueDouble,
          selection: TextSelection.collapsed(offset: valueDouble.length),
        );

        widget.onChanged(double.parse(valueDouble));
      },
      label: "Ngân sách",
      padding: const EdgeInsets.symmetric(horizontal: 16),
      keyboardType: TextInputType.number,
    );
  }
}
