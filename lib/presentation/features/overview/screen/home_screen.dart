import 'package:expense_tracking/presentation/common_widgets/et_navigation_bar.dart';
import 'package:expense_tracking/presentation/features/overview/widget/et_home_appbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: EtNavigationBar(),
      body: Column(
        children: [
          SizedBox(
            height: 400,
            child: Stack(
              children: [
                EtHomeAppbar(),
                Positioned(
                    top: 180,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
