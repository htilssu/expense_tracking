import 'package:flutter/material.dart';

class EtButton extends StatelessWidget {
  Widget? child;
  Color? color;
  double borderRadius = 5;
  double height = 1;
  double width = double.infinity;
  void Function()? onPressed;

  EtButton({
    super.key,
    this.child,
    this.color,
    this.borderRadius = 5,
    this.height = 45,
    this.width = double.infinity,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: color ?? Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            minimumSize: Size(width, height)),
        child: child);
  }
}
