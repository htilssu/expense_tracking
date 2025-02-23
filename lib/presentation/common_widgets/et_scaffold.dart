import 'package:flutter/material.dart';

import '../features/transaction/screen/create_transaction_screen.dart';
import 'et_bottom_navigation_bar.dart';

class EtScaffold extends StatelessWidget {
  final Widget body;

  const EtScaffold({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(
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
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: EtNavigationBar(),
      body: body,
    );
  }
}
