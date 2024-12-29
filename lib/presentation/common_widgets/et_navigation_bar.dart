import 'package:flutter/material.dart';

class EtNavigationBar extends StatelessWidget {
  const EtNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.wallet,
              size: 32,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 32,
            ),
            label: "")
      ],
      iconSize: 32,
    );
  }
}
