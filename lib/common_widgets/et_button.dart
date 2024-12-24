import 'package:flutter/material.dart';

class EtButton extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double borderRadius;
  final double height;
  final double width;
  final void Function()? onPressed;

  const EtButton({
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
