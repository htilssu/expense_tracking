import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int total;
  final int currentStep;

  const StepIndicator(this.currentStep, this.total, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= total; i++) ...[
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10)),
            height: i == currentStep ? 15 : 10,
            width: i == currentStep ? 15 : 10,
          ),
          if (i != total)
            SizedBox(
              width: 8,
            ),
        ]
      ],
    );
  }
}
