import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/amount_input.dart';
import 'package:flutter/material.dart';

class CreateTransactionScreen extends StatefulWidget {
  const CreateTransactionScreen({super.key});

  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Tạo giao dịch",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90.0),
                child: CustomSlidingSegmentedControl<int>(
                    curve: Curves.easeInCubic,
                    isStretch: true,
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(7)),
                    innerPadding: EdgeInsets.all(4),
                    thumbDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4)),
                    children: {
                      0: AnimatedDefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        duration: Duration(milliseconds: 250),
                        child: Text(
                          "Thu nhập",
                          style: TextStyle(
                              fontSize: TextSize.medium,
                              color: _selectedSegment == 0
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                      1: AnimatedDefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        duration: Duration(milliseconds: 250),
                        child: Text(
                          "Chi tiêu",
                          style: TextStyle(
                              fontSize: TextSize.medium,
                              color: _selectedSegment == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        _selectedSegment = value;
                      });
                    }),
              ),
              AmountInput()
            ],
          ),
        ));
  }
}
