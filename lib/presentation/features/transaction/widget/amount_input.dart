import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/utils/formatter.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatefulWidget {
  const AmountInput({super.key, this.onChanged});

  final void Function(double)? onChanged;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () {
        var rawValue = _controller.text.replaceAll(RegExp(r"/\D/"), "");
        var newValue = double.parse(rawValue);
        widget.onChanged?.call(newValue);
        var formattedValue = Formatter.formatCurrency(newValue);
        _controller.value = _controller.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(
              offset: formattedValue.lastIndexOf(RegExp(r"\d")) + 1),
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
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
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
          Text(
            "Nhập số tiền",
            style: TextStyle(
              fontSize: TextSize.medium,
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _controller,
            onChanged: (value) {
              if (value.isNotEmpty) {
                widget.onChanged?.call(double.parse(value));
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13)
            ],
            style: TextStyle(
              fontSize: TextSize.large,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
          Text("VNĐ"),
        ],
      ),
    );
  }
}
