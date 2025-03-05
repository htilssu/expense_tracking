import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/currency_formatter.dart';

class AmountInput extends StatefulWidget {
  const AmountInput({super.key, this.onChanged, required this.value});

  final void Function(int)? onChanged;
  final int value;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _initializeController();
    }
  }

  void _initializeController() {
    var formattedValue = CurrencyFormatter.formatCurrency(widget.value);
    _controller = TextEditingController(
      text: formattedValue,
    );

    _controller.addListener(
      () {
        var rawValue = _controller.text.replaceAll(RegExp(r'\D'), '');
        var newValue = int.parse(rawValue);
        widget.onChanged?.call(newValue);
        var formattedValue = CurrencyFormatter.formatCurrency(newValue);
        _controller.value = _controller.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(
              offset: formattedValue.lastIndexOf(RegExp(r'\d')) + 1),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.placeholderColor,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Nhập số tiền',
            style: TextStyle(
              fontSize: TextSize.medium,
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _controller,
            onChanged: (value) {
              if (value.isNotEmpty) {
                widget.onChanged?.call(int.parse(value));
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13)
            ],
            style: const TextStyle(
              fontSize: TextSize.large,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          const Text('VNĐ'),
        ],
      ),
    );
  }
}
