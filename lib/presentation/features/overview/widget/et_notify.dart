import 'package:flutter/material.dart';

class EtNotify extends StatelessWidget {
  final bool _hasNotification;

  const EtNotify(this._hasNotification, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Icon(
        Icons.notifications_outlined,
        size: 26,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      if (_hasNotification)
        Positioned(
          right: 5,
          top: 5,
          child: Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )
    ]);
  }
}
