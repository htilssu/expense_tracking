import 'package:flutter/material.dart';

import '../features/transaction/screen/create_transaction_screen.dart';
import 'et_bottom_navigation_bar.dart';

class EtScaffold extends StatelessWidget {
  final Widget body;
  final void Function(int index) onNavigation;

  const EtScaffold({required this.body, super.key, required this.onNavigation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(
            side: BorderSide(
          color: Colors.white,
        )),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return CreateTransactionScreen();
            },
          ));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: EtNavigationBar(onNavigation: onNavigation),
      body: body,
    );
  }
}
