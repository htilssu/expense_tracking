import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/presentation/common_widgets/et_navigation_bar.dart';
import 'package:expense_tracking/presentation/features/overview/widget/et_home_appbar.dart';
import 'package:expense_tracking/presentation/features/overview/widget/overview_card.dart';
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
            height: 370,
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
                        child: OverviewCard()))
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Lịch sử",
                      style: TextStyle(
                          fontSize: TextSize.medium,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            minimumSize: WidgetStatePropertyAll(Size(0, 0))),
                        child: Text(
                          "Xem tất cả",
                          style: TextStyle(
                            fontSize: TextSize.small + 2,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
