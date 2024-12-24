import 'package:flutter/material.dart';

class EtNotify extends StatelessWidget {
  final bool hasNotification;

  const EtNotify({this.hasNotification = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Icon(
        Icons.notifications_outlined,
        size: 35,
      ),
      Positioned(
        right: 5,
        top: 5,
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      )
    ]);
  }
}
